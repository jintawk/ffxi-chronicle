// KeyHook.h - shared hook on the keyboard the game reads, for nui modules that keep single keys from the game.
// KeyHook 1: one ABI forever, revisions within it (the rules UiHook/UiHook.h and PadHook/PadHook.h keep).
//
// Why. Windower's keyboard event cannot keep a key from the game: a true return lets the arrows turn the camera
// all the same. keyboard_blockinput keeps every key from the game, so the player cannot chat, use a macro or
// run a Windower bind meanwhile. KeyHook hides only the keys a module names, and only from the game.
//
// What the client does (the 2026-11-02 build; nui never uses an address, it finds code by signature). One input
// object holds the DirectInput keyboard device (at +0x88 in that build). One function, the input update, reads
// it once per main loop tick on the main thread, with exactly two calls:
//
//     GetDeviceState(device, 0x100, input+0x98)              the 256-byte key state
//     GetDeviceData(device, 0x14, input+0x79C, &n, 0)        up to n = 16 buffered events, no DIGDD_PEEK
//
// The update counts a key as down when its state byte has 0x80, or when a press event for it came in this tick,
// and ignores release events. Everything in the game (the camera, the menus, every action, Enter and Escape for
// the chat line) reads what the update makes of those two reads. So hiding a key means clearing its state byte
// and dropping its press events. With Windower loaded, the device the client calls is very likely Windower's
// wrapper, which applies its own block, console key and binds first. KeyHook then runs after Windower, so
// Windower's events, binds and console keep working.
//
// What KeyHook does not see: the chat line's own keys. Space, / and typed characters reach the chat line as
// WM_KEYDOWN and WM_CHAR, which the client reads from its message pump. KeyHook hides keys from the game's
// actions, not from the chat line.
//
// The sites. Each read is followed by `cmp eax, 0x800700AA` (3D AA 00 07 80), and each signature (45 and 42
// bytes, below) runs from the load of the device to that cmp. The patch changes the cmp into a call of the
// same length (E8 <rel32 -> thunk>), so a thread inside the read returns to a whole instruction either way. One
// locked 8-byte compare-and-exchange of the aligned block that holds the cmp writes it, and the other three
// bytes of the block go back unchanged. KeyHook needs: each signature to match exactly once in FFXiMain.dll's
// code sections, both sites to load the device from the same offset of the input object, the event read to
// follow the state read within KEYHOOK_SITE_SPAN bytes (the same function), and each cmp to lie in one aligned
// 8-byte block. Otherwise it patches nothing, for good in this module, and the status says why.
//
//     block+0    the driving module's dispatcher, or null
//     block+16   the state read's thunk (block+64: the event read's, the same shape)
//                50 51 52              push eax / push ecx / push edx      ; eax: the read's HRESULT, kept
//                8B 0D <&dispatch>     mov ecx, [dispatch]
//                85 C9 74 16           test ecx, ecx / jz done              ; nobody drives: the cmp alone
//                FF B6 <disp32>        push [esi+disp]                      ; the device (esi: the input object)
//                68 <asked>            push asked                           ; events the client asked for (0: state)
//                6A 00 | 55 90         push 0 | push ebp                    ; the count (ebp, events only)
//                57 | 53               push edi | push ebx                  ; the data (edi: state, ebx: events)
//                FF 74 24 18           push [esp+24]                        ; the HRESULT
//                6A <kind>             push kind
//                FF D1                 call ecx                             ; __stdcall: pops its 6 arguments
//     done:      5A 59 58              pop edx / pop ecx / pop eax
//                3D <imm32>            cmp eax, 0x800700AA                  ; the client's own cmp, on its own eax
//                C3                    ret                                  ; ret keeps the flags
//
// The signatures fix the registers: esi is the input object, edi the state buffer, ebx the events and ebp the
// count. All four are callee-saved, so the read leaves them as they were. There is nothing to chain and no
// original to call: the read has already run when the thunk runs. The patch is never undone, and the block is
// never freed. With nobody driving, the thunk runs the client's cmp and nothing else.
//
// What the dispatcher does (any module's: the live client with the highest revision drives, as UiHook). The keys
// to hide are the union of the live clients' masks (256 bits each, DirectInput key codes). A client renews its
// mask at least every KEYHOOK_HEARTBEAT_MS, or it lapses, so a stuck or crashed addon never leaves keys hidden.
// One record per key serves both reads: the game saw this press (saw), or this press is hidden (hid).
//   - A new press is decided once, at the first read that shows it: hidden if it is in the mask then, the
//     game's otherwise. When a module starts to drive after nobody did, every key held at its first state read
//     is the game's (it may have gone down unseen).
//   - A press the game saw stays the game's until its release, even if the key goes into the mask meanwhile.
//   - A hidden press stays hidden until its release, even after the key leaves the mask or the mask lapses.
//   - The state read clears a hidden key's byte. The event read drops a hidden key's events and moves the rest
//     down, and writes the new count.
//   - A press ends at its release event. If that event is lost, the press ends when the state read showed the key
//     up and the event read then returned fewer events than the client asked for (the buffer was empty).
//
// ABI and revisions: mapping Local\FFXiKeyHook_v1_<pid>, always KEYHOOK_MAP_BYTES, mapped whole. Offsets are
// frozen (test/layout_keyhook.txt); new fields only go into the reserved tails, and zero means the old behaviour.
// A module leaves in DllMain(DLL_PROCESS_DETACH) with keyhook_unregister(bus, slot, false), which hands the
// dispatch on before its code unmaps. Any revision's dispatcher works through the thunks, which call it with one
// frozen signature (keyhook_fn). A dispatcher ignores a kind it does not know.
//
// KEYHOOK_FAULT_* and KEYHOOK_TEST_* are for tests only. Never define them in a module that ships.

#ifndef KEYHOOK_H
#define KEYHOOK_H

#include <windows.h>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>

#define KEYHOOK_ABI_VERSION 1u             // never changes again
#ifndef KEYHOOK_REV
#define KEYHOOK_REV 1                      // this file's revision within ABI 1 (tests override it)
#endif
#define KEYHOOK_MAX_CLIENTS 16
#define KEYHOOK_KEYS 256                   // DirectInput key codes 0..255
#define KEYHOOK_WORDS 8                    // a mask of 256 keys in 32-bit words
#define KEYHOOK_MAP_BYTES 4096u
#define KEYHOOK_MAP_NAME_FMT "Local\\FFXiKeyHook_v1_%lu"
#define KEYHOOK_RETRY_MS 5000              // how often a host retries keyhook_join after KEYHOOK_JOIN_RETRY
#define KEYHOOK_HEARTBEAT_MS 250           // a mask not renewed for this long has lapsed
#define KEYHOOK_DRAIN_MS 100
#define KEYHOOK_SITE_SPAN 0x400            // the event read follows the state read within this many bytes
#define KEYHOOK_GAME "FFXiMain.dll"
#define KEYHOOK_SITES "FFXiMain's keyboard reads"   // the sites' name in status lines

// what a thunk passes the dispatcher (keyhook_fn's `kind`)
#define KEYHOOK_READ_STATE 0               // data: the 256-byte state GetDeviceState filled; count: null; asked: 0
#define KEYHOOK_READ_EVENTS 1              // data: KeyEvent[*count] from GetDeviceData; asked: the count asked for

// keyhook_state()
#define KEYHOOK_LIVE 0                     // the sites are patched
#define KEYHOOK_WAIT 1                     // not patched yet: FFXiMain.dll is not loaded (never in game)
#define KEYHOOK_BLOCKED 2                  // the sites cannot be patched safely in this process
#define KEYHOOK_NO_BUS 3

#define KEYHOOK_JOIN_RETRY (-1)
#define KEYHOOK_JOIN_BLOCKED (-2)
#define KEYHOOK_JOIN_FULL (-3)
#define KEYHOOK_JOIN_NO_BUS (-4)

static_assert(sizeof(void*) == 4, "KeyHook targets 32-bit FFXI");

#if defined(__GNUC__)
#define KEYHOOK_ALIGN_STACK __attribute__((force_align_arg_pointer))
#else
#define KEYHOOK_ALIGN_STACK
#endif

// DirectInput's DIDEVICEOBJECTDATA (DirectInput 8, 32-bit), declared here so no SDK header is needed
struct KeyEvent {
    DWORD ofs;                       // the key code (c_dfDIKeyboard: 0..255)
    DWORD data;                      // 0x80: pressed
    DWORD time;
    DWORD seq;
    DWORD app;
};
static_assert(sizeof(KeyEvent) == 20, "DIDEVICEOBJECTDATA is 20 bytes");

// The dispatcher: the thunks call it after each read, on the thread that read (the client's main thread).
typedef void(__stdcall* keyhook_fn)(DWORD kind, LONG hr, void* data, DWORD* count, DWORD asked, void* device);

// 128 bytes; offsets frozen.
struct KeyClient {
    volatile LONG occupied;          // 0 free, 1 being filled in, 2 live
    volatile LONG hiding;            // 1: this client's mask holds keys (while its heartbeat is fresh)
    volatile LONG alive_tick;        // GetTickCount() of the client's last renewal
    keyhook_fn dispatch;             // this client's module's dispatcher
    unsigned long rev;
    HMODULE module;
    volatile LONG const* nonce_at;
    LONG nonce;
    char name[16];
    volatile unsigned long hide[KEYHOOK_WORDS];   // the keys this client hides: bit (code & 31) of word (code >> 5)
    unsigned char reserved[48];
};

// 192 bytes: the dispatcher's own working state, one record per key.
struct KeyState {
    unsigned long saw[KEYHOOK_WORDS];      // the game saw the current press
    unsigned long hid[KEYHOOK_WORDS];      // the current press is hidden from the game
    unsigned long down[KEYHOOK_WORDS];     // down at the last state read (raw)
    volatile LONG state_ok;                // the last state read succeeded (down is current)
    unsigned long state_reads;
    unsigned long event_reads;
    unsigned long hidden;                  // presses hidden, ever
    unsigned long dropped;                 // events dropped, ever
    unsigned long ended;                   // hidden presses ended without their release event
    void* volatile device;                 // the device the client read last (status: whose object it is)
    unsigned long tick;                    // GetTickCount() of the last read
    volatile LONG primed;                  // 0: the next state read gives every held key to the game (a driver started)
    unsigned char reserved[60];
};

// 4096 bytes mapped; offsets frozen.
struct KeyBus {
    volatile LONG ready;
    unsigned long abi_version;       // 1
    unsigned long size;
    volatile LONG install_lock;
    volatile LONG hook_installed;
    volatile LONG owner_slot;
    volatile LONG in_flight;
    volatile LONG installs;
    volatile LONG calls;             // reads through the dispatcher
    unsigned char* block;            // never freed
    keyhook_fn volatile* dispatch_ptr;
    std::uintptr_t site_state;       // the cmp after GetDeviceState
    std::uintptr_t site_events;      // the cmp after GetDeviceData
    volatile LONG owner_rev;
    volatile LONG reg_lock;
    volatile LONG handovers;
    volatile LONG blocked;           // the sites cannot be patched safely in this process
    volatile LONG serial;
    volatile LONG write_lock;        // the dispatcher's state writes (one thread at a time; others only hide)
    volatile LONG lapses;            // masks that ended by a missed heartbeat
    unsigned long device_disp;       // where the input object holds the device (from the sites)
    unsigned char reserved_hdr[44];
    KeyState keys;                   // 192
    KeyClient clients[KEYHOOK_MAX_CLIENTS];   // 2048
    char status[192];
    // append here only
};

static_assert(sizeof(KeyClient) == 128, "KeyClient is 128 bytes forever");
static_assert(sizeof(KeyState) == 192, "KeyState is 192 bytes forever");
static_assert(offsetof(KeyBus, keys) == 128, "KeyBus header is 128 bytes");
static_assert(sizeof(KeyBus) <= KEYHOOK_MAP_BYTES, "KeyBus must fit the fixed mapping");

namespace keyhook_detail {

inline KeyBus*& cached_bus() { static KeyBus* value = nullptr; return value; }
inline volatile LONG& module_nonce() { static volatile LONG value = 0; return value; }
inline volatile DWORD& last_dispatch_tid() { static volatile DWORD value = 0; return value; }

constexpr std::size_t kBlockBytes = 128;
constexpr std::size_t kStateThunkAt = 16;
constexpr std::size_t kEventsThunkAt = 64;
constexpr std::size_t kThunkBytes = 44;
constexpr std::size_t kThunkJz = 11;                  // jz done (rel8 at +12)
constexpr std::size_t kThunkDone = 35;
constexpr unsigned char kCmp[5] = {0x3D, 0xAA, 0x00, 0x07, 0x80};   // cmp eax, 0x800700AA
inline constexpr char kChanged[] = "changed while they were patched";

inline unsigned long bit_of(unsigned i) { return 1ul << (i & 31u); }

inline bool page_ok(DWORD protect, bool exec) {
    if (protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
    switch (protect & 0xFF) {
    case PAGE_EXECUTE: return exec;
    case PAGE_EXECUTE_READ: case PAGE_EXECUTE_READWRITE: case PAGE_EXECUTE_WRITECOPY: return true;
    case PAGE_READONLY: case PAGE_READWRITE: case PAGE_WRITECOPY: return !exec;
    default: return false;
    }
}

inline bool span_readable(std::uintptr_t address, std::size_t size) {
    if (address == 0 || size == 0) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(reinterpret_cast<void const*>(address), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || !(page_ok(region.Protect, false) || page_ok(region.Protect, true))) return false;
    std::uintptr_t const low = reinterpret_cast<std::uintptr_t>(region.BaseAddress);
    return address >= low && address + size <= low + region.RegionSize;
}

inline bool code_in_module(void const* code, HMODULE module) {
    if (!code) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(code, &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || region.Type != MEM_IMAGE || !page_ok(region.Protect, true)) return false;
    return !module || region.AllocationBase == reinterpret_cast<void*>(module);
}

inline bool module_mapped(HMODULE module) {
    MEMORY_BASIC_INFORMATION region {};
    if (!module || !VirtualQuery(module, &region, sizeof(region))) return false;
    return region.State == MEM_COMMIT && region.Type == MEM_IMAGE && region.AllocationBase == reinterpret_cast<void*>(module);
}

inline bool module_alive(KeyClient const& c) {
    if (!c.module || !module_mapped(c.module)) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!c.nonce_at || !VirtualQuery(const_cast<LONG const*>(c.nonce_at), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || region.Type != MEM_IMAGE || region.AllocationBase != reinterpret_cast<void*>(c.module))
        return false;
    return *c.nonce_at == c.nonce;
}

inline bool can_own(KeyClient const& c) {
    return c.occupied == 2 && c.dispatch && module_alive(c) && code_in_module(reinterpret_cast<void const*>(c.dispatch), c.module);
}

inline bool reg_lock(KeyBus* bus, bool wait) {
    LONG const me = static_cast<LONG>(GetCurrentThreadId());
    DWORD const start = GetTickCount();
    for (;;) {
        if (InterlockedCompareExchange(&bus->reg_lock, me, 0) == 0) return true;
        if (!wait) return false;
        if (GetTickCount() - start > 50) {
            LONG const held = InterlockedCompareExchange(&bus->reg_lock, 0, 0);
            if (held != 0 && InterlockedCompareExchange(&bus->reg_lock, me, held) == held) return true;
        }
        Sleep(0);
    }
}
inline void reg_unlock(KeyBus* bus) { InterlockedExchange(&bus->reg_lock, 0); }

inline void clear_client(KeyClient& c) {
    InterlockedExchange(&c.hiding, 0);
    for (int w = 0; w < KEYHOOK_WORDS; ++w) c.hide[w] = 0;
    c.dispatch = nullptr;
    c.rev = 0;
    c.module = nullptr;
    c.nonce_at = nullptr;
    c.nonce = 0;
    std::memset(c.name, 0, sizeof(c.name));
    MemoryBarrier();
    InterlockedExchange(&c.occupied, 0);
}

inline void set_owner(KeyBus* bus, int slot) {
    keyhook_fn const next = slot >= 0 ? bus->clients[slot].dispatch : nullptr;
    // nobody drove: keys went down and up unseen, so the next state read gives every held key to the game
    if (*bus->dispatch_ptr == nullptr && next) InterlockedExchange(&bus->keys.primed, 0);
    if (*bus->dispatch_ptr != next) InterlockedIncrement(&bus->handovers);
    *bus->dispatch_ptr = next;
    InterlockedExchange(&bus->owner_rev, slot >= 0 ? static_cast<LONG>(bus->clients[slot].rev) : 0);
    InterlockedExchange(&bus->owner_slot, slot);
}

inline void reassign_owner(KeyBus* bus, int leaving) {
    if (!bus || !bus->dispatch_ptr) return;
    int best = -1;
    for (int i = 0; i < KEYHOOK_MAX_CLIENTS; ++i) {
        if (i == leaving || !can_own(bus->clients[i])) continue;
        if (best < 0 || bus->clients[i].rev > bus->clients[best].rev) best = i;
    }
    set_owner(bus, best);
}

// The keys to hide now: the union of the live clients' masks. A mask whose heartbeat is older than
// KEYHOOK_HEARTBEAT_MS has lapsed; it is dropped here, once, and counted. False when no key is in any mask.
inline bool hide_mask(KeyBus* bus, DWORD now, unsigned long* out) {
    for (int w = 0; w < KEYHOOK_WORDS; ++w) out[w] = 0;
    bool any = false;
    for (int i = 0; i < KEYHOOK_MAX_CLIENTS; ++i) {
        KeyClient& c = bus->clients[i];
        if (c.occupied != 2 || !c.hiding) continue;
#ifndef KEYHOOK_FAULT_NO_HEARTBEAT
        if (now - static_cast<DWORD>(c.alive_tick) > KEYHOOK_HEARTBEAT_MS) {
            if (InterlockedCompareExchange(&c.hiding, 0, 1) == 1) InterlockedIncrement(&bus->lapses);
            continue;
        }
#endif
        for (int w = 0; w < KEYHOOK_WORDS; ++w) out[w] |= c.hide[w];
        any = true;
    }
    (void)now;
    return any;
}

// A new press of key i: hidden if it is in the mask, the game's otherwise. True: hidden.
inline bool decide(KeyState& k, unsigned i, unsigned long const* mask) {
    unsigned const w = i >> 5;
    unsigned long const b = bit_of(i);
    if (mask[w] & b) {
        k.hid[w] |= b;
        ++k.hidden;
        return true;
    }
    k.saw[w] |= b;
    return false;
}

// The state read: 256 bytes, one per key code, 0x80 when down. Pure on its inputs: tests call it directly.
inline void apply_state(KeyState& k, unsigned char* s, unsigned long const* mask) {
    ++k.state_reads;
    for (unsigned i = 0; i < KEYHOOK_KEYS; ++i) {
        unsigned const w = i >> 5;
        unsigned long const b = bit_of(i);
        if (!(s[i] & 0x80)) { k.down[w] &= ~b; continue; }
        k.down[w] |= b;
#ifdef KEYHOOK_FAULT_TAKE_HELD
        if ((k.saw[w] & b) && (mask[w] & b)) { k.saw[w] &= ~b; k.hid[w] |= b; }
#endif
#ifdef KEYHOOK_FAULT_LEAK_HELD
        if ((k.hid[w] & b) && !(mask[w] & b)) { k.hid[w] &= ~b; k.saw[w] |= b; }
#endif
        if (k.hid[w] & b) { s[i] = 0; continue; }       // hidden at its press: hidden until its release
        if (k.saw[w] & b) continue;                    // the game saw it go down: the game's until its release
        if (decide(k, i, mask)) s[i] = 0;
    }
    InterlockedExchange(&k.state_ok, 1);
}

// The event read: n events in order, the count rewritten. `asked` is the count the client asked for: fewer back
// means the buffer is empty, and the lost-release rule may end a press. Pure on its inputs: tests call it.
inline void apply_events(KeyState& k, KeyEvent* ev, DWORD* count, DWORD asked, unsigned long const* mask) {
    ++k.event_reads;
    if (!ev || !count) return;
    DWORD n = *count;
    if (asked && n > asked) n = asked;
    unsigned long last_press[KEYHOOK_WORDS] = {0, 0, 0, 0, 0, 0, 0, 0};
    DWORD out = 0;
    for (DWORD j = 0; j < n; ++j) {
        KeyEvent const e = ev[j];
        bool keep = true;
        if (e.ofs < KEYHOOK_KEYS) {
            unsigned const i = e.ofs, w = i >> 5;
            unsigned long const b = bit_of(i);
#ifndef KEYHOOK_FAULT_NO_EVENTS
            if (e.data & 0x80) {
                last_press[w] |= b;
                if (k.hid[w] & b) keep = false;
                else if (!(k.saw[w] & b)) keep = !decide(k, i, mask);
            } else {
                last_press[w] &= ~b;
                if (k.hid[w] & b) { keep = false; k.hid[w] &= ~b; }
                else k.saw[w] &= ~b;
            }
#else
            (void)w; (void)b; (void)mask;
#endif
        }
        if (keep) ev[out++] = e;
        else ++k.dropped;
    }
    *count = out;
#ifndef KEYHOOK_FAULT_NO_DRAIN
    if (asked && n < asked && k.state_ok) {        // the buffer is empty: a key up in the state, with no press since, is up
        for (int w = 0; w < KEYHOOK_WORDS; ++w) {
            unsigned long const ends = (k.hid[w] | k.saw[w]) & ~k.down[w] & ~last_press[w];
            k.ended += static_cast<unsigned long>(__builtin_popcountl(k.hid[w] & ends));
            k.hid[w] &= ~ends;
            k.saw[w] &= ~ends;
        }
    }
#endif
}

// The dispatcher: one copy per module, called from the thunks after each read, on the client's main thread.
inline void KEYHOOK_ALIGN_STACK __stdcall dispatch(DWORD kind, LONG hr, void* data, DWORD* count, DWORD asked, void* device) {
    KeyBus* bus = cached_bus();
    if (!bus) return;
    InterlockedIncrement(&bus->in_flight);
    InterlockedIncrement(&bus->calls);
    last_dispatch_tid() = GetCurrentThreadId();
    KeyState& k = bus->keys;
    if (InterlockedCompareExchange(&bus->write_lock, 1, 0) == 0) {
        k.device = device;
        DWORD const now = GetTickCount();
        k.tick = now;
        unsigned long mask[KEYHOOK_WORDS];
        hide_mask(bus, now, mask);
        if (kind == KEYHOOK_READ_STATE) {
#ifndef KEYHOOK_FAULT_NO_PRIME
            if (hr >= 0 && data && !k.primed) {              // a key held when the driving started stays the game's
                auto const* s = static_cast<unsigned char const*>(data);
                for (unsigned i = 0; i < KEYHOOK_KEYS; ++i)
                    if ((s[i] & 0x80) && !(k.hid[i >> 5] & bit_of(i))) k.saw[i >> 5] |= bit_of(i);
                InterlockedExchange(&k.primed, 1);
            }
#endif
            if (hr >= 0 && data) apply_state(k, static_cast<unsigned char*>(data), mask);
            else InterlockedExchange(&k.state_ok, 0);        // the client clears the state itself; down is stale
        } else if (kind == KEYHOOK_READ_EVENTS) {
            if (hr >= 0) apply_events(k, static_cast<KeyEvent*>(data), count, asked, mask);
        }                                                    // another kind: a later revision's, nothing to do
        InterlockedExchange(&bus->write_lock, 0);
    } else if (hr >= 0 && data) {
        // another thread is writing (two readers at once): hide what is hidden, change nothing else
        if (kind == KEYHOOK_READ_STATE) {
            auto* s = static_cast<unsigned char*>(data);
            for (unsigned i = 0; i < KEYHOOK_KEYS; ++i) if (k.hid[i >> 5] & bit_of(i)) s[i] = 0;
        } else if (kind == KEYHOOK_READ_EVENTS && count) {
            auto* ev = static_cast<KeyEvent*>(data);
            DWORD out = 0, n = asked && *count > asked ? asked : *count;
            for (DWORD j = 0; j < n; ++j) {
                KeyEvent const e = ev[j];
                if (e.ofs < KEYHOOK_KEYS && (k.hid[e.ofs >> 5] & bit_of(e.ofs))) continue;
                ev[out++] = e;
            }
            *count = out;
        }
    }
    InterlockedDecrement(&bus->in_flight);
}

inline HMODULE self_module() {
    HMODULE m = nullptr;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       reinterpret_cast<LPCSTR>(&dispatch), &m);
    return m;
}

inline std::uint32_t le32(unsigned char const* p) {
    std::uint32_t v = 0;
    std::memcpy(&v, p, 4);
    return v;
}

// ---- the sites ----

// -1 is a wildcard. The device's offset (bytes 2..5) is read from the match.
constexpr short kStateSig[45] = {
    0x8B, 0x86, -1, -1, -1, -1,                  // mov eax, [esi+disp]       the device
    0xDB, 0x44, 0x24, -1, 0x85, 0xC0,            // fild [esp+..] / test eax, eax
    0xD9, 0x5C, 0x24, -1,                        // fstp [esp+..]
    0x0F, 0x84, -1, -1, -1, -1,                  // jz (no device)
    0x8B, 0x08,                                  // mov ecx, [eax]            its vtable
    0x8D, 0xBE, -1, -1, -1, -1, 0x57,            // lea edi, [esi+..] / push edi           the state buffer
    0x68, 0x00, 0x01, 0x00, 0x00, 0x50,          // push 0x100 / push eax
    0xFF, 0x51, 0x24,                            // call [ecx+0x24]           GetDeviceState
    0x3D, 0xAA, 0x00, 0x07, 0x80,                // cmp eax, 0x800700AA       the patch
};
constexpr short kEventsSig[42] = {
    0x8B, 0x86, -1, -1, -1, -1,                  // mov eax, [esi+disp]       the device
    0x8D, 0xAE, -1, -1, -1, -1,                  // lea ebp, [esi+..]         the count
    0x8D, 0x9E, -1, -1, -1, -1,                  // lea ebx, [esi+..]         the events
    0x6A, 0x00, 0x55,                            // push 0 (no DIGDD_PEEK) / push ebp
    0xC7, 0x45, 0x00, -1, -1, -1, -1,            // mov dword [ebp], asked
    0x8B, 0x10, 0x53, 0x6A, 0x14, 0x50,          // mov edx, [eax] / push ebx / push 0x14 / push eax
    0xFF, 0x52, 0x28,                            // call [edx+0x28]           GetDeviceData
    0x3D, 0xAA, 0x00, 0x07, 0x80,                // cmp eax, 0x800700AA       the patch
};
constexpr std::size_t kStateCmpAt = 40, kEventsCmpAt = 37, kEventsAskedAt = 24, kDispAt = 2;

template <std::size_t N>
inline bool sig_at(unsigned char const* p, short const (&sig)[N]) {
    for (std::size_t i = 0; i < N; ++i)
        if (sig[i] >= 0 && p[i] != static_cast<unsigned char>(sig[i])) return false;
    return true;
}

struct SiteScan {
    int state_count, events_count;
    std::uintptr_t state_at, events_at;     // the first match of each (its first byte)
    std::uint32_t state_disp, events_disp;  // the device's offset at each
    std::uint32_t asked;                    // the event read's count
};

// Both signatures over n bytes at p, which the process sees at `base`. Adds to s (several runs make one scan).
// Pure: tests call it.
inline void scan_sites(unsigned char const* p, std::size_t n, std::uintptr_t base, SiteScan& s) {
    for (std::size_t off = 0; off + sizeof(kEventsSig) / sizeof(short) <= n; ++off) {
        if (p[off] != 0x8B || p[off + 1] != 0x86) continue;
        if (off + sizeof(kStateSig) / sizeof(short) <= n && sig_at(p + off, kStateSig)) {
            if (s.state_count++ == 0) { s.state_at = base + off; s.state_disp = le32(p + off + kDispAt); }
        }
        if (sig_at(p + off, kEventsSig)) {
            if (s.events_count++ == 0) {
                s.events_at = base + off;
                s.events_disp = le32(p + off + kDispAt);
                s.asked = le32(p + off + kEventsAskedAt);
            }
        }
    }
}

// Can a 5-byte instruction at `at` be written with one aligned 8-byte compare-and-exchange?
inline bool fits_one_block(std::uintptr_t at) { return at % 8 <= 3; }

// What the scan means: null when it can be patched, otherwise why not. Pure: tests call it.
inline char const* scan_verdict(SiteScan const& s) {
    if (s.state_count == 0) return "were not found: no GetDeviceState read (a client update?)";
    if (s.events_count == 0) return "were not found: no GetDeviceData read (a client update?)";
#ifndef KEYHOOK_FAULT_FIRST_MATCH
    if (s.state_count > 1) return "are not unique: several GetDeviceState reads";
    if (s.events_count > 1) return "are not unique: several GetDeviceData reads";
#endif
    if (s.state_disp != s.events_disp) return "read two devices (the offsets differ)";
    if (s.events_at <= s.state_at || s.events_at - s.state_at > KEYHOOK_SITE_SPAN) return "are not in one function";
    if (s.asked == 0 || s.asked > 4096) return "ask for an odd count of events";
    if (!fits_one_block(s.state_at + kStateCmpAt) || !fits_one_block(s.events_at + kEventsCmpAt))
        return "are not on 8-byte boundaries that one write can patch";
    return nullptr;
}

// A thunk (kThunkBytes) for one read. Events: the count is in ebp and the data in ebx; state: no count, data in edi.
inline void thunk_bytes(std::uintptr_t block, bool events, std::uint32_t disp, std::uint32_t asked, unsigned char* t) {
    unsigned char code[kThunkBytes] = {
        0x50, 0x51, 0x52,                        // push eax / push ecx / push edx
        0x8B, 0x0D, 0, 0, 0, 0,                  // mov ecx, [dispatch]
        0x85, 0xC9, 0x74, static_cast<unsigned char>(kThunkDone - (kThunkJz + 2)),   // test ecx, ecx / jz done
        0xFF, 0xB6, 0, 0, 0, 0,                  // push [esi+disp]       the device
        0x68, 0, 0, 0, 0,                        // push asked
        0x6A, 0x00,                              // push 0 | push ebp; nop   the count
        0x57,                                    // push edi | push ebx      the data
        0xFF, 0x74, 0x24, 0x18,                  // push [esp+24]            the HRESULT
        0x6A, 0x00,                              // push kind
        0xFF, 0xD1,                              // call ecx
        0x5A, 0x59, 0x58,                        // done: pop edx / pop ecx / pop eax
        0x3D, 0xAA, 0x00, 0x07, 0x80,            // cmp eax, 0x800700AA
        0xC3,                                    // ret
    };
    auto const d = static_cast<std::uint32_t>(block);
    std::memcpy(code + 5, &d, 4);
    std::memcpy(code + 15, &disp, 4);
    std::memcpy(code + 20, &asked, 4);
    if (events) {
        code[24] = 0x55; code[25] = 0x90;
        code[26] = 0x53;
        code[32] = KEYHOOK_READ_EVENTS;
    }
#ifdef KEYHOOK_FAULT_NO_CMP
    code[38] = code[39] = code[40] = code[41] = code[42] = 0x90;   // the flags the jumps after it test are the thunk's own
#endif
    std::memcpy(t, code, kThunkBytes);
}

// The 8 aligned bytes that hold the cmp at `cmp_at`, before (as found) and after the patch (E8 <rel32 -> thunk>).
inline void patch_bytes(std::uintptr_t cmp_at, std::uintptr_t thunk, unsigned char const* found, unsigned char* want) {
    std::size_t const k = cmp_at % 8;
    std::memcpy(want, found, 8);
    want[k] = 0xE8;
    auto const rel = static_cast<std::int32_t>(thunk - (cmp_at + 5));
    std::memcpy(want + k + 1, &rel, 4);
}

// One site: the aligned block read, checked to hold the cmp, and written in one locked compare-and-exchange.
// write = false: the check alone. Null on success, or why not.
inline char const* write_site(std::uintptr_t cmp_at, std::uintptr_t thunk, unsigned char* old_out, bool write = true) {
    std::uintptr_t const at = cmp_at & ~static_cast<std::uintptr_t>(7);
    if (!fits_one_block(cmp_at)) return "are not on 8-byte boundaries that one write can patch";
    unsigned char found[8];
    std::memcpy(found, reinterpret_cast<void const*>(at), 8);
    if (std::memcmp(found + (cmp_at - at), kCmp, sizeof(kCmp)) != 0) return kChanged;
    if (old_out) std::memcpy(old_out, found, 8);
    if (!write) return nullptr;
    unsigned char want[8];
    patch_bytes(cmp_at, thunk, found, want);
    DWORD previous = 0;
    if (!VirtualProtect(reinterpret_cast<void*>(at), 8, PAGE_EXECUTE_READWRITE, &previous))
        return "could not be patched (VirtualProtect failed)";
    LONGLONG old_v = 0, new_v = 0;
    std::memcpy(&old_v, found, 8);
    std::memcpy(&new_v, want, 8);
    bool const wrote = InterlockedCompareExchange64(reinterpret_cast<LONGLONG volatile*>(at), new_v, old_v) == old_v;
    VirtualProtect(reinterpret_cast<void*>(at), 8, previous, &previous);
    FlushInstructionCache(GetCurrentProcess(), reinterpret_cast<void*>(at), 8);
    return wrote ? nullptr : kChanged;
}

// Put a site back as it was (only when the other site failed in the same install). The thunk block stays, so a
// thread inside the thunk still returns to the instruction after the cmp.
inline void unwrite_site(std::uintptr_t cmp_at, unsigned char const* old_bytes) {
    std::uintptr_t const at = cmp_at & ~static_cast<std::uintptr_t>(7);
    unsigned char now[8];
    std::memcpy(now, reinterpret_cast<void const*>(at), 8);
    DWORD previous = 0;
    if (!VirtualProtect(reinterpret_cast<void*>(at), 8, PAGE_EXECUTE_READWRITE, &previous)) return;
    LONGLONG old_v = 0, new_v = 0;
    std::memcpy(&old_v, now, 8);
    std::memcpy(&new_v, old_bytes, 8);
    InterlockedCompareExchange64(reinterpret_cast<LONGLONG volatile*>(at), new_v, old_v);
    VirtualProtect(reinterpret_cast<void*>(at), 8, previous, &previous);
    FlushInstructionCache(GetCurrentProcess(), reinterpret_cast<void*>(at), 8);
}

// Patch both sites that the checks passed: the block, then the state site, then the event site (the state site
// goes back if the event site fails). Null on success, with bus->block, dispatch_ptr, the sites and device_disp set.
inline char const* install(KeyBus* bus, SiteScan const& s) {
    auto* block = static_cast<unsigned char*>(VirtualAlloc(nullptr, kBlockBytes, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
    if (!block) return "could not be patched (no memory for the hook block)";
    std::memset(block, 0xCC, kBlockBytes);
    std::memset(block, 0, 4);
    auto const b = reinterpret_cast<std::uintptr_t>(block);
    thunk_bytes(b, false, s.state_disp, 0, block + kStateThunkAt);
    thunk_bytes(b, true, s.events_disp, s.asked, block + kEventsThunkAt);
    FlushInstructionCache(GetCurrentProcess(), block, kBlockBytes);
    std::uintptr_t const cmp_state = s.state_at + kStateCmpAt, cmp_events = s.events_at + kEventsCmpAt;
    bus->block = block;
    bus->dispatch_ptr = reinterpret_cast<keyhook_fn volatile*>(block);
    bus->site_state = cmp_state;
    bus->site_events = cmp_events;
    bus->device_disp = s.state_disp;
    MemoryBarrier();
    auto undo = [&](char const* why) {
        bus->block = nullptr; bus->dispatch_ptr = nullptr; bus->site_state = bus->site_events = 0; bus->device_disp = 0;
        VirtualFree(block, 0, MEM_RELEASE);
        return why;
    };
    unsigned char old_state[8], old_events[8];
    // both checked before either is written
    if (char const* why = write_site(cmp_state, b + kStateThunkAt, old_state, false)) return undo(why);
    if (char const* why = write_site(cmp_events, b + kEventsThunkAt, old_events, false)) return undo(why);
    if (char const* why = write_site(cmp_state, b + kStateThunkAt, old_state)) return undo(why);
    if (char const* why = write_site(cmp_events, b + kEventsThunkAt, old_events)) {
        unwrite_site(cmp_state, old_state);
        // the block stays: a thread may be inside the state thunk now (it only ran the cmp, nobody drives yet)
        bus->block = nullptr; bus->dispatch_ptr = nullptr; bus->site_state = bus->site_events = 0; bus->device_disp = 0;
        return why;
    }
    return nullptr;
}

inline bool page_writable(DWORD protect) {
    if (protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
    switch (protect & 0xFF) {
    case PAGE_READWRITE: case PAGE_WRITECOPY: case PAGE_EXECUTE_READWRITE: case PAGE_EXECUTE_WRITECOPY: return true;
    default: return false;
    }
}

// fn(begin, end, characteristics) for every section of the loaded client module, or false when it is not
// loaded or its headers are unreadable.
template <typename Fn>
inline bool for_each_game_section(HMODULE* out, Fn&& fn) {
    HMODULE module = GetModuleHandleA(KEYHOOK_GAME);
    if (out) *out = module;
    if (!module) return false;
    auto const base = reinterpret_cast<std::uintptr_t>(module);
    if (!span_readable(base, sizeof(IMAGE_DOS_HEADER))) return false;
    auto const* dos = reinterpret_cast<IMAGE_DOS_HEADER const*>(base);
    if (dos->e_magic != IMAGE_DOS_SIGNATURE) return false;
    std::uintptr_t const nt_at = base + static_cast<std::uintptr_t>(dos->e_lfanew);
    if (!span_readable(nt_at, sizeof(IMAGE_NT_HEADERS32))) return false;
    auto const* nt = reinterpret_cast<IMAGE_NT_HEADERS32 const*>(nt_at);
    if (nt->Signature != IMAGE_NT_SIGNATURE) return false;
    auto const* section = IMAGE_FIRST_SECTION(nt);
    if (!span_readable(reinterpret_cast<std::uintptr_t>(section), sizeof(IMAGE_SECTION_HEADER) * nt->FileHeader.NumberOfSections))
        return false;
    for (unsigned i = 0; i < nt->FileHeader.NumberOfSections; ++i, ++section)
        fn(base + section->VirtualAddress, base + section->VirtualAddress + section->Misc.VirtualSize, section->Characteristics);
    return true;
}

// fn(bytes, n, address) for every run of committed readable pages in [begin, end) (a VirtualProtect inside the
// module splits regions, so a section is never tested whole; as UiHook's scan_each). Readable regions in a row
// make one run, so only an unreadable page ends a run, and no match can cross one.
template <typename Fn>
inline void for_each_readable_run(std::uintptr_t begin, std::uintptr_t end, Fn&& fn) {
    std::uintptr_t address = begin;
    while (address < end) {
        MEMORY_BASIC_INFORMATION region {};
        if (!VirtualQuery(reinterpret_cast<void const*>(address), &region, sizeof(region))) break;
        std::uintptr_t const region_end = reinterpret_cast<std::uintptr_t>(region.BaseAddress) + region.RegionSize;
        if (region_end <= address) break;
        bool const readable = region.State == MEM_COMMIT && (page_ok(region.Protect, false) || page_ok(region.Protect, true));
        if (!readable) { address = region_end; continue; }
        std::uintptr_t run_end = region_end;
        while (run_end < end) {
            MEMORY_BASIC_INFORMATION next {};
            if (!VirtualQuery(reinterpret_cast<void const*>(run_end), &next, sizeof(next)) || next.State != MEM_COMMIT
                || !(page_ok(next.Protect, false) || page_ok(next.Protect, true))) break;
            std::uintptr_t const next_end = reinterpret_cast<std::uintptr_t>(next.BaseAddress) + next.RegionSize;
            if (next_end <= run_end) break;
            run_end = next_end;
        }
        std::uintptr_t const limit = run_end < end ? run_end : end;
        fn(reinterpret_cast<unsigned char const*>(address), static_cast<std::size_t>(limit - address), address);
        address = run_end;
    }
}

// The scan over the client's code sections, done once per module (the client's code never changes).
struct SiteFind {
    int state;                       // 0 not yet (the client module is not loaded), 1 found, 2 refused for good
    SiteScan scan;
    char const* why;
};
inline SiteFind& site_find() { static SiteFind value = {0, {0, 0, 0, 0, 0, 0, 0}, nullptr}; return value; }

inline SiteFind& find_sites() {
    SiteFind& f = site_find();
    if (f.state != 0) return f;
    SiteScan s {0, 0, 0, 0, 0, 0, 0};
    HMODULE game = nullptr;
    bool const headers = for_each_game_section(&game, [&](std::uintptr_t begin, std::uintptr_t end, DWORD flags) {
        if (!(flags & IMAGE_SCN_MEM_EXECUTE)) return;
        for_each_readable_run(begin, end, [&](unsigned char const* p, std::size_t n, std::uintptr_t at) {
            scan_sites(p, n, at, s);
        });
    });
    if (!game) { f.why = "were not looked for (" KEYHOOK_GAME " is not loaded)"; return f; }
    f.state = 2;
    if (!headers) { f.why = "were not looked for (" KEYHOOK_GAME "'s headers are unreadable)"; return f; }
    f.scan = s;
    f.why = scan_verdict(s);
    if (!f.why) f.state = 1;
    return f;
}

}  // namespace keyhook_detail

// Attach to the process-wide bus, creating it on first use (leaked on purpose: it belongs to the process).
inline KeyBus* keyhook_attach() {
    KeyBus*& cached = keyhook_detail::cached_bus();
    if (cached) return cached;
    char name[64];
    std::snprintf(name, sizeof(name), KEYHOOK_MAP_NAME_FMT, static_cast<unsigned long>(GetCurrentProcessId()));
    HANDLE mapping = CreateFileMappingA(INVALID_HANDLE_VALUE, nullptr, PAGE_READWRITE, 0, KEYHOOK_MAP_BYTES, name);
    if (!mapping) return nullptr;
    bool const existed = GetLastError() == ERROR_ALREADY_EXISTS;
    auto* bus = static_cast<KeyBus*>(MapViewOfFile(mapping, FILE_MAP_ALL_ACCESS, 0, 0, KEYHOOK_MAP_BYTES));
    if (!bus) { CloseHandle(mapping); return nullptr; }
    if (!existed) {
        bus->abi_version = KEYHOOK_ABI_VERSION;
        bus->size = sizeof(KeyBus);
        bus->owner_slot = -1;
        std::snprintf(bus->status, sizeof(bus->status), "bus created");
        MemoryBarrier();
        InterlockedExchange(&bus->ready, 1);
    } else {
        for (int spin = 0; spin < 2000 && InterlockedCompareExchange(&bus->ready, 0, 0) == 0; ++spin) Sleep(1);
        if (InterlockedCompareExchange(&bus->ready, 0, 0) == 0) { UnmapViewOfFile(bus); CloseHandle(mapping); return nullptr; }
    }
    if (bus->abi_version != KEYHOOK_ABI_VERSION || bus->size < offsetof(KeyBus, status) + sizeof(bus->status)
        || bus->size > KEYHOOK_MAP_BYTES) {
        UnmapViewOfFile(bus);
        CloseHandle(mapping);
        return nullptr;
    }
    for (;;) {
        LONG const seen = static_cast<LONG>(bus->size);
        if (seen >= static_cast<LONG>(sizeof(KeyBus))) break;
        if (InterlockedCompareExchange(reinterpret_cast<volatile LONG*>(&bus->size), sizeof(KeyBus), seen) == seen) break;
    }
    cached = bus;
    return bus;
}

inline int keyhook_state(KeyBus const* bus) {
    if (!bus) return KEYHOOK_NO_BUS;
    if (bus->hook_installed) return KEYHOOK_LIVE;
    if (bus->blocked) return KEYHOOK_BLOCKED;
    return KEYHOOK_WAIT;
}

// Patch both sites if nobody has yet. True when the patch is live, whoever wrote it. False with bus->status saying
// why: retry later (KEYHOOK_WAIT), or never in this process (bus->blocked). simulate_missing: the not-found path,
// always.
inline bool keyhook_ensure_hook(KeyBus* bus, bool simulate_missing = false, char const* who = nullptr) {
    using namespace keyhook_detail;
    if (!bus) return false;
    if (InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0) return true;
    if (simulate_missing) {
        if (InterlockedCompareExchange(&bus->blocked, 0, 0) == 0)
            std::snprintf(bus->status, sizeof(bus->status), "%s were not found (simulated)", KEYHOOK_SITES);
        return false;
    }
    if (InterlockedCompareExchange(&bus->install_lock, 1, 0) != 0) {
        for (int spin = 0; spin < 2000 && InterlockedCompareExchange(&bus->hook_installed, 0, 0) == 0; ++spin) Sleep(1);
        return InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0;
    }
    if (InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0) {   // patched between the first check and the lock
        InterlockedExchange(&bus->install_lock, 0);
        return true;
    }
    auto done = [&](bool live) {
        if (live) {
            InterlockedIncrement(&bus->installs);
            InterlockedExchange(&bus->hook_installed, 1);
        }
        InterlockedExchange(&bus->install_lock, 0);
        return live;
    };
    if (InterlockedCompareExchange(&bus->blocked, 0, 0) != 0) return done(false);   // refused before: the status says why
    char const* const who_s = who && *who ? who : "?";
    SiteFind& f = find_sites();
    char const* why = f.why;
    if (f.state == 1) {
        why = install(bus, f.scan);
        if (why) { f.state = 2; f.why = why; }
    }
    if (!why) {
        std::snprintf(bus->status, sizeof(bus->status), "hook installed at %s %08lX, %08lX by %s (rev %d)", KEYHOOK_SITES,
                      static_cast<unsigned long>(bus->site_state), static_cast<unsigned long>(bus->site_events), who_s, KEYHOOK_REV);
        return done(true);
    }
    std::snprintf(bus->status, sizeof(bus->status), "%s %s", KEYHOOK_SITES, why);
    if (f.state == 2) InterlockedExchange(&bus->blocked, 1);
    return done(false);
}

// A slot index, or -1. The dispatch goes to this module when nobody drives it, when its revision is higher than
// the driver's, or when the driver's dispatcher is no longer mapped.
inline int keyhook_register(KeyBus* bus, char const* name = nullptr) {
    using namespace keyhook_detail;
    if (!bus || !bus->dispatch_ptr || !InterlockedCompareExchange(&bus->hook_installed, 0, 0)) return -1;
    HMODULE const self = self_module();
    volatile LONG& nonce = module_nonce();
    while (nonce == 0) {
        LARGE_INTEGER t {};
        QueryPerformanceCounter(&t);
        InterlockedCompareExchange(&nonce, static_cast<LONG>((InterlockedIncrement(&bus->serial) << 20) ^ t.LowPart), 0);
    }
    reg_lock(bus, true);
    int slot = -1;
    for (int i = 0; i < KEYHOOK_MAX_CLIENTS; ++i) {
        if (InterlockedCompareExchange(&bus->clients[i].occupied, 1, 0) != 0) continue;
        KeyClient& c = bus->clients[i];
        c.hiding = 0;
        for (int w = 0; w < KEYHOOK_WORDS; ++w) c.hide[w] = 0;
        c.alive_tick = static_cast<LONG>(GetTickCount());
        c.dispatch = &dispatch;
        c.rev = KEYHOOK_REV;
        c.module = self;
        c.nonce_at = &nonce;
        c.nonce = nonce;
        std::memset(c.name, 0, sizeof(c.name));
        if (name) std::strncpy(c.name, name, sizeof(c.name) - 1);
        MemoryBarrier();
        InterlockedExchange(&c.occupied, 2);
        slot = i;
        break;
    }
    if (slot >= 0) {
        LONG const owner = InterlockedCompareExchange(&bus->owner_slot, 0, 0);
        bool take = owner < 0 || owner >= KEYHOOK_MAX_CLIENTS;
        if (!take) {
            KeyClient const& o = bus->clients[owner];
            take = !can_own(o) || o.dispatch != *bus->dispatch_ptr;
        }
        if (!take) take = static_cast<LONG>(KEYHOOK_REV) > InterlockedCompareExchange(&bus->owner_rev, 0, 0);
        if (take) set_owner(bus, slot);
    }
    reg_unlock(bus);
    return slot;
}

// Leave the bus; also from DllMain(DLL_PROCESS_DETACH) with may_wait = false (loader lock).
inline void keyhook_unregister(KeyBus* bus, int slot, bool may_wait) {
    using namespace keyhook_detail;
    if (!bus || slot < 0 || slot >= KEYHOOK_MAX_CLIENTS) return;
    KeyClient& c = bus->clients[slot];
    if (c.dispatch != &dispatch) return;
    reg_lock(bus, true);
    InterlockedExchange(&c.hiding, 0);
    bool const drove = InterlockedCompareExchange(&bus->owner_slot, 0, 0) == slot;
    if (drove) reassign_owner(bus, slot);
    LONG const handed_at = InterlockedCompareExchange(&bus->calls, 0, 0);
    clear_client(c);
    reg_unlock(bus);
    if (may_wait) {
        for (int spin = 0; spin < 200 && InterlockedCompareExchange(&bus->in_flight, 0, 0) != 0; ++spin) Sleep(1);
        if (drove && last_dispatch_tid() != GetCurrentThreadId()) {
            DWORD const t0 = GetTickCount();
            while (InterlockedCompareExchange(&bus->calls, 0, 0) - handed_at < 2 && GetTickCount() - t0 < KEYHOOK_DRAIN_MS) Sleep(1);
        }
    }
}

// Patch if nobody has, then register. A slot >= 0, or a KEYHOOK_JOIN_* code.
inline int keyhook_join(KeyBus* bus, char const* name = nullptr, bool simulate_missing = false) {
    if (!bus) return KEYHOOK_JOIN_NO_BUS;
    if (!keyhook_ensure_hook(bus, simulate_missing, name))
        return keyhook_state(bus) == KEYHOOK_BLOCKED ? KEYHOOK_JOIN_BLOCKED : KEYHOOK_JOIN_RETRY;
    int const slot = keyhook_register(bus, name);
    return slot >= 0 ? slot : KEYHOOK_JOIN_FULL;
}

// The keys this client hides (KEYHOOK_WORDS words; null or all zero: none), and the heartbeat. The mask lasts while
// the client renews it at least every KEYHOOK_HEARTBEAT_MS. Presses already decided keep their rule.
inline void keyhook_hide(KeyBus* bus, int slot, unsigned long const* mask) {
    if (!bus || slot < 0 || slot >= KEYHOOK_MAX_CLIENTS) return;
    KeyClient& c = bus->clients[slot];
    if (c.dispatch != &keyhook_detail::dispatch) return;
    bool any = false;
    for (int w = 0; w < KEYHOOK_WORDS; ++w) {
        unsigned long const v = mask ? mask[w] : 0;
        c.hide[w] = v;
        any = any || v != 0;
    }
    MemoryBarrier();
    InterlockedExchange(&c.alive_tick, static_cast<LONG>(GetTickCount()));
    InterlockedExchange(&c.hiding, any ? 1 : 0);
}

// Does this client hide keys now (its mask lapses without a heartbeat)?
inline bool keyhook_hiding(KeyBus const* bus, int slot) {
    if (!bus || slot < 0 || slot >= KEYHOOK_MAX_CLIENTS) return false;
    return bus->clients[slot].occupied == 2 && bus->clients[slot].hiding != 0;
}

inline int keyhook_active_clients(KeyBus const* bus) {
    if (!bus) return 0;
    int n = 0;
    for (int i = 0; i < KEYHOOK_MAX_CLIENTS; ++i) if (bus->clients[i].occupied == 2) ++n;
    return n;
}

inline int keyhook_count(unsigned long const volatile* words) {
    int n = 0;
    for (int w = 0; w < KEYHOOK_WORDS; ++w) n += __builtin_popcountl(words[w]);
    return n;
}

// The module that holds the vtable of the device the client read last ("Hook.dll": Windower's wrapper), or false.
inline bool keyhook_device_module(KeyBus const* bus, char* out, std::size_t n) {
    using namespace keyhook_detail;
    if (!out || n == 0) return false;
    out[0] = 0;
    if (!bus) return false;
    auto const dev = reinterpret_cast<std::uintptr_t>(bus->keys.device);
    if (!span_readable(dev, 4)) return false;
    std::uintptr_t const vtbl = *reinterpret_cast<std::uintptr_t const*>(dev);
    if (!span_readable(vtbl, 0x2C)) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(reinterpret_cast<void const*>(vtbl), &region, sizeof(region)) || region.Type != MEM_IMAGE) return false;
    char path[260];
    DWORD const len = GetModuleFileNameA(static_cast<HMODULE>(region.AllocationBase), path, sizeof(path));
    if (len == 0 || len >= sizeof(path)) return false;
    char const* base = path;
    for (char const* p = path; *p; ++p) if (*p == '\\' || *p == '/') base = p + 1;
    std::snprintf(out, n, "%s", base);
    return true;
}

// One line for a status display, e.g.
//   "live at FFXiMain's keyboard reads 10005A89, 10005B20; 1 client: chronicle r1 (drives, hides 10)"
//   "blocked: FFXiMain's keyboard reads were not found: no GetDeviceState read (a client update?)"
inline void keyhook_describe(KeyBus const* bus, char* out, std::size_t n) {
    if (!out || n == 0) return;
    out[0] = 0;
    int const st = keyhook_state(bus);
    if (st == KEYHOOK_NO_BUS) { std::snprintf(out, n, "no bus"); return; }
    if (st != KEYHOOK_LIVE) {
        std::snprintf(out, n, "%s: %s", st == KEYHOOK_BLOCKED ? "blocked" : "waiting", bus->status);
        return;
    }
    int const clients = keyhook_active_clients(bus);
    std::size_t len = static_cast<std::size_t>(std::snprintf(out, n, "live at %s %08lX, %08lX; %d client%s", KEYHOOK_SITES,
        static_cast<unsigned long>(bus->site_state), static_cast<unsigned long>(bus->site_events), clients, clients == 1 ? "" : "s"));
    char const* sep = ": ";
    for (int i = 0; i < KEYHOOK_MAX_CLIENTS && len < n; ++i) {
        KeyClient const& c = bus->clients[i];
        if (c.occupied != 2) continue;
        char nm[17];
        std::memcpy(nm, c.name, 16);
        nm[16] = 0;
        bool const drives = bus->owner_slot == i;
        int const hides = c.hiding ? keyhook_count(c.hide) : 0;
        char what[40] = "";
        if (drives && hides) std::snprintf(what, sizeof(what), " (drives, hides %d)", hides);
        else if (drives) std::snprintf(what, sizeof(what), " (drives)");
        else if (hides) std::snprintf(what, sizeof(what), " (hides %d)", hides);
        len += static_cast<std::size_t>(std::snprintf(out + len, n - len, "%s%s r%lu%s", sep, nm[0] ? nm : "?",
            static_cast<unsigned long>(c.rev), what));
        sep = ", ";
    }
}

#endif  // KEYHOOK_H
