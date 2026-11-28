// PadHook.h - shared hook on the controller state the game reads, for nui modules that take the pad.
// PadHook 1: one ABI forever, revisions within it (the rules UiHook/UiHook.h keeps, applied here).
//
// With its "Enable XInput" setting on (padmode000 flag 6), the client reads an XInput pad through its own
// shim, xinputdll.dll in the game folder, which calls xinput1_3.dll. Without that setting the client uses
// DirectInput8, which PadHook does not hook yet. PadState::source says where a state came from, so a
// DirectInput source can join the same state, the same mask and the same bus in a later revision.
//
// There are two routes to the state. A module tries route 1 first, then route 0. bus->route says which one
// is live (0 also on a bus that a revision 1 or 2 module patched).
//
// Route 1 (revision 3): the client's XInput wrapper in FFXiMain.dll. The client keeps the shim's handle in
// one slot (H) and the shim's XInputGetState_ in the next (F). One wrapper reads both. It is found by its
// signature over FFXiMain's code sections, never by address (it is at 10008EA0 in the 2026-10 and 2026-11
// builds):
//
//     +0   A1 <H>                  mov eax, [H]
//          85 C0 74 1B             test eax, eax / jz fail      ; the shim is not loaded
//     +9   A1 <F>                  mov eax, [F]                 ; the patch goes here
//          85 C0 74 12             test eax, eax / jz fail
//          8B 4C 24 08 8B 54 24 04 51 52        push the two arguments
//          FF D0 83 C4 08 C2 08 00              call eax / add esp, 8 / ret 8: the shim is __cdecl
//     fail: B8 01 00 00 00 C2 08 00              mov eax, 1 / ret 8
//
// The signature (these 44 bytes, H and F left out) also matches the SetState wrapper. The GetState wrapper is
// the match where F = H + 4.
// PadHook needs exactly one such match, both slots in a writable section of FFXiMain.dll, and wrapper + 8 on
// an 8-byte boundary. Once the client has loaded the shim (H is not zero), H must hold xinputdll.dll's
// handle and F must hold its XInputGetState_. While H is zero, the signature and the slot layout decide alone.
//
// The patch changes `mov eax, [F]` to `mov eax, thunk` (B8 <thunk>). It has the same length and stays one
// instruction. One locked 8-byte compare-and-exchange of wrapper + 8 .. + 15 writes it, and bytes 8, 14 and
// 15 go back unchanged. The client writes only data, so its rewrites of the slots (at input init, on each
// device re-enumeration, and about every 1.5 s while no pad is attached) never undo the patch. Nothing is
// saved that can go stale: the thunk and the adapter read F on every call.
//
//     block+16  A1 <&dispatch>   mov eax, [dispatch]
//               85 C0 74 0B      test eax, eax / jz pass
//               FF 74 24 08      push [esp+8]                   ; copy the two arguments
//               FF 74 24 08      push [esp+8]
//               FF D0 C3         call eax / ret                 ; the __stdcall dispatcher pops the copies
//     pass:     A1 <F>           mov eax, [F]
//               85 C0 74 02      test eax, eax / jz none
//               FF E0            jmp eax                        ; the shim returns to the wrapper itself
//     none:     B8 01 00 00 00   mov eax, 1                     ; what the wrapper returns without F
//               C3               ret
//
//     block+64  the adapter, bus->original: __stdcall, as the dispatcher calls it
//               A1 <F> 85 C0 74 10               mov eax, [F] / test eax, eax / jz none
//               FF 74 24 08 FF 74 24 08          push [esp+8] twice
//               FF D0 83 C4 08 C2 08 00          call eax / add esp, 8 / ret 8
//     none:     B8 01 00 00 00 C2 08 00          mov eax, 1 / ret 8
//
// The wrapper tests F before it calls, and the patch takes that test away, so the thunk and the adapter
// test F again. A thunk in the slot itself would crash the game: the wrapper calls F as __cdecl and pops the
// arguments itself, so a __stdcall dispatcher reached by a jump pops them a second time (test/pad_linux runs
// that case and requires the crash). The client's unloader frees the shim and zeros only H, and the wrapper
// tests H before it reaches the patch. padhook_pin, which pad() calls, pins xinputdll.dll once the client has
// loaded it, so the unloader can never unmap it while a read is on its way through the dispatcher.
//
// Route 0 (revisions 1 and 2, and the fallback of revision 3): the Windows hot-patch form of
// xinput1_3.dll!XInputGetState, never undone:
//
//     site-5:  E9 <rel32 -> thunk>     the five bytes of padding before the function (90 or CC)
//     site:    EB F9                   was 8B FF (mov edi, edi): a jump back into the padding
//
// The long jump is written first, where no thread executes; then the two-byte instruction at the
// entry is swapped for the short jump in one locked 16-bit write, so a thread entering the function
// sees either `mov edi, edi` or the jump, never half of either. Calling site+2 is the original
// function (mov edi, edi is a no-op), so there is no displaced code and no trampoline to build.
//
//     block+16  A1 <&dispatch> mov eax, [dispatch]
//               85 C0          test eax, eax
//               74 02          jz  orig
//               FF E0          jmp eax                 ; the dispatcher returns to the game itself
//     orig:     E9 <site+2>    jmp to the original
//
// eax is free at a stdcall entry, so the game's arguments and return address are untouched. On this route
// xinput1_3.dll is pinned (it can then never unload under the patch). Many builds of xinput1_3.dll are not
// hot-patchable (they start 55 8B EC): route 0 refuses those, and says which bytes it found.
//
// On both routes the patch is never undone, and the thunk lives in one VirtualAlloc block (128 bytes) that
// no module owns and nothing frees. block+0 holds the driving module's dispatcher (__stdcall, with
// XInputGetState's signature), or null. With null, the hook passes every call through.
//
// What the dispatcher does (any module's: the live client with the highest revision drives, as UiHook):
//   1. calls the original;
//   2. records the state it returned into the bus (PadState per user index, behind a seqlock) for
//      every module to read;
//   3. hides buttons from the game while any live client holds the pad (capture, renewed by a
//      heartbeat: a client that stops renewing for PADHOOK_HEARTBEAT_MS no longer holds it, so a
//      stuck or crashed addon never leaves the player without a controller). The rules:
//        - a button held when the pad is taken still reaches the game until it is released;
//        - a button pressed while the pad is held is hidden from the game, and stays hidden until it
//          is released, even after the pad is given back (the game never sees half a press);
//        - while the pad is held, the sticks read centred and the triggers read released (unless held
//          from before the capture), so neither the camera nor a macro bar moves;
//   4. renumbers dwPacketNumber: the number the game sees changes exactly when the state it sees
//      changes (a button hidden or shown while the pad itself is still has a new number).
//   5. (revision 2) the chord. A client names the buttons that take its pad together (padhook_chord, e.g.
//      L3 + R3). While nobody holds the pad, the first of them to go down is held back from the game for
//      up to PADHOOK_CHORD_MS: its partner arriving makes it the chord, and both stay hidden until released
//      (the game never sees the chord, even when it maps those buttons itself); released alone before
//      then, it is shown to the game for PADHOOK_REPLAY_READS reads (a tap still reaches it); still held
//      alone when the time is up, the game gets it then. Only those buttons are ever delayed, and only
//      while nobody holds the pad.
//
// ABI and revisions: mapping Local\FFXiPadHook_v1_<pid>, always PADHOOK_MAP_BYTES, mapped whole.
// Offsets are frozen (test/layout_padhook.txt); new fields only go into the reserved tails, and zero
// means the old behaviour. A module leaves in DllMain(DLL_PROCESS_DETACH) with
// padhook_unregister(bus, slot, false), which hands the dispatch on before its code unmaps.
//
// Revisions meet on one bus. Any revision's dispatcher works through either route's thunk, and calls
// bus->original the same way. A revision 1 or 2 module that joins a route 1 bus registers as before. A
// revision 2 module sets bus->blocked when route 0 refuses. A revision 3 module still tries route 1 then,
// and clears bus->blocked when route 1 succeeds. To revision 3, bus->blocked means only that route 0 is
// refused for good: it calls the bus blocked (PADHOOK_BLOCKED) once route 1 is refused for good as well,
// and until then a host retries.
//
// PADHOOK_FAULT_* and PADHOOK_TEST_* are for tests only. Never define them in a module that ships.

#ifndef PADHOOK_H
#define PADHOOK_H

#include <windows.h>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>

#define PADHOOK_ABI_VERSION 1u             // never changes again
#ifndef PADHOOK_REV
#define PADHOOK_REV 3                      // this file's revision within ABI 1 (tests override it); 2: the chord; 3: route 1
#endif
#define PADHOOK_MAX_CLIENTS 16
#define PADHOOK_INDEXES 4                  // XInput user indexes 0..3
#define PADHOOK_MAP_BYTES 4096u
#define PADHOOK_MAP_NAME_FMT "Local\\FFXiPadHook_v1_%lu"
#define PADHOOK_RETRY_MS 5000              // how often a host retries padhook_join after PADHOOK_JOIN_RETRY
#define PADHOOK_HEARTBEAT_MS 250           // a capture not renewed for this long has lapsed
#define PADHOOK_CHORD_MS 150               // rev 2: a chord button is held back this long waiting for its partner
#define PADHOOK_REPLAY_READS 2             // rev 2: a chord button tapped alone is shown to the game for this many reads
#define PADHOOK_DRAIN_MS 100
#ifndef PADHOOK_DLL
#define PADHOOK_DLL "xinput1_3.dll"        // route 0's DLL (tests point it at a fake)
#endif
#define PADHOOK_GAME "FFXiMain.dll"        // route 1: the client module that holds the wrapper and the slots
#define PADHOOK_SHIM "xinputdll.dll"       // route 1: the client's own XInput shim
#define PADHOOK_SHIM_GET "XInputGetState_" // ... and its GetState, __cdecl
#define PADHOOK_WRAPPER "FFXiMain's XInput wrapper"   // route 1's name in status lines

// PadBus::route (rev 3; 0 on a bus a rev 1 or 2 module patched)
#define PADHOOK_ROUTE_EXPORT 0             // route 0: xinput1_3.dll!XInputGetState, hot-patched
#define PADHOOK_ROUTE_WRAPPER 1            // route 1: FFXiMain's XInput wrapper

// padhook_state()
#define PADHOOK_LIVE 0                     // one route is patched by this bus
#define PADHOOK_WAIT 1                     // not patched yet: no wrapper, and xinput1_3.dll not loaded (yet)
#define PADHOOK_BLOCKED 2                  // no wrapper, and route 0 cannot be patched safely (not hot-patchable, another hook)
#define PADHOOK_NO_BUS 3

#define PADHOOK_JOIN_RETRY (-1)
#define PADHOOK_JOIN_BLOCKED (-2)
#define PADHOOK_JOIN_FULL (-3)
#define PADHOOK_JOIN_NO_BUS (-4)

// PadState::source
#define PADHOOK_SRC_NONE 0
#define PADHOOK_SRC_XINPUT 1
#define PADHOOK_SRC_DINPUT 2               // reserved: a later revision

// Buttons are XInput's XINPUT_GAMEPAD_* bits; the triggers take two bits of their own above them
// (a trigger is "held" past PADHOOK_TRIGGER_DOWN), so one mask covers everything that can be pressed.
#define PADHOOK_LT 0x10000ul
#define PADHOOK_RT 0x20000ul
#define PADHOOK_TRIGGER_DOWN 30            // XINPUT_GAMEPAD_TRIGGER_THRESHOLD

static_assert(sizeof(void*) == 4, "PadHook targets 32-bit FFXI");

#if defined(__GNUC__)
#define PADHOOK_ALIGN_STACK __attribute__((force_align_arg_pointer))
#else
#define PADHOOK_ALIGN_STACK
#endif

// XInput's XINPUT_STATE, declared here so no SDK header is needed (16 bytes, the Windows layout)
struct PadXState {
    DWORD packet;
    WORD buttons;
    BYTE lt, rt;
    SHORT lx, ly, rx, ry;
};
static_assert(sizeof(PadXState) == 16, "XINPUT_STATE is 16 bytes");

typedef DWORD(__stdcall* padhook_get_fn)(DWORD index, PadXState* state);

// 32 bytes: what the game read last, raw (before any mask), per user index.
struct PadState {
    unsigned long seq;               // changes with every change of the fields below; 0 = never read
    unsigned long buttons;           // XINPUT_GAMEPAD_* | PADHOOK_LT | PADHOOK_RT
    unsigned char lt, rt;
    unsigned char connected;         // the last read succeeded
    unsigned char source;            // PADHOOK_SRC_*
    short lx, ly, rx, ry;
    unsigned long tick;              // GetTickCount() of the last read
    unsigned long reads;             // reads of this index
    unsigned char reserved[4];
};

// 48 bytes: the mask per user index (the dispatcher's own working state).
struct PadMask {
    unsigned long masked;            // hidden from the game now
    unsigned long passthru;          // held when the pad was taken: reaches the game until released
    volatile LONG was_captured;
    unsigned long out_packet;        // the dwPacketNumber the game sees
    PadXState last_out;              // what the game was last given
    unsigned long hidden;            // presses hidden from the game, ever (status)
    unsigned char reserved[12];
};

// 64 bytes; offsets frozen.
struct PadClient {
    volatile LONG occupied;          // 0 free, 1 being filled in, 2 live
    volatile LONG capture;           // 1: this client holds the pad (while its heartbeat is fresh)
    volatile LONG alive_tick;        // GetTickCount() of the client's last renewal
    padhook_get_fn dispatch;         // this client's module's dispatcher
    unsigned long rev;
    HMODULE module;
    volatile LONG const* nonce_at;
    LONG nonce;
    char name[16];
    unsigned long chord;             // rev 2: the buttons that take this client's pad together (0: none)
    unsigned char reserved[12];
};

// 24 bytes (rev 2, in the bus header's reserved tail): the chord step's working state.
struct PadChord {
    unsigned long buttons;           // the union of the live clients' chords, refreshed every read
    unsigned long deferred;          // chord buttons held back from the game, waiting for a partner
    unsigned long since;             // GetTickCount() when the first of them went down
    unsigned long replay;            // a tap released alone: shown to the game for `replay_left` more reads
    unsigned long replay_left;
    unsigned long prev;              // the chord buttons held at the last read
};
static_assert(sizeof(PadChord) == 24, "PadChord is 24 bytes forever");

// 4096 bytes mapped; offsets frozen.
struct PadBus {
    volatile LONG ready;
    unsigned long abi_version;       // 1
    unsigned long size;
    volatile LONG install_lock;
    volatile LONG hook_installed;
    volatile LONG owner_slot;
    volatile LONG in_flight;
    volatile LONG installs;
    volatile LONG calls;             // game reads through the dispatcher
    unsigned char* block;            // never freed
    padhook_get_fn volatile* dispatch_ptr;
    std::uintptr_t site;             // route 0: XInputGetState; route 1: the wrapper
    padhook_get_fn original;         // route 0: site + 2; route 1: the adapter (block + 64)
    volatile LONG owner_rev;
    volatile LONG reg_lock;
    volatile LONG handovers;
    volatile LONG blocked;
    volatile LONG serial;
    volatile LONG write_lock;        // the dispatcher's state writes (one thread at a time; others skip)
    volatile LONG wseq;              // seqlock over `pads`: odd while written
    volatile LONG last_index;        // the user index that last read connected
    volatile LONG lapses;            // captures that ended by a missed heartbeat
    PadChord chord;                  // rev 2 (zero: no chord, the rev 1 behaviour)
    volatile LONG route;             // rev 3: PADHOOK_ROUTE_* (zero: route 0, the rev 2 behaviour)
    unsigned char reserved_hdr[12];
    PadState pads[PADHOOK_INDEXES];  // 128
    PadMask masks[PADHOOK_INDEXES];  // 192
    PadClient clients[PADHOOK_MAX_CLIENTS];   // 1024
    char status[192];
    // append here only
};

static_assert(sizeof(PadState) == 32, "PadState is 32 bytes forever");
static_assert(sizeof(PadMask) == 48, "PadMask is 48 bytes forever");
static_assert(sizeof(PadClient) == 64, "PadClient is 64 bytes forever");
static_assert(offsetof(PadBus, pads) == 128, "PadBus header is 128 bytes");
static_assert(sizeof(PadBus) <= PADHOOK_MAP_BYTES, "PadBus must fit the fixed mapping");

namespace padhook_detail {

inline PadBus*& cached_bus() { static PadBus* value = nullptr; return value; }
inline volatile LONG& module_nonce() { static volatile LONG value = 0; return value; }
inline volatile DWORD& last_dispatch_tid() { static volatile DWORD value = 0; return value; }

constexpr std::size_t kBlockBytes = 128;                  // rev 3: 64 before, with no adapter
constexpr std::size_t kThunkAt = 16;                      // either route's thunk
constexpr std::size_t kThunkBytes = 5 + 2 + 2 + 2 + 5;    // 16: route 0's thunk
constexpr std::size_t kWrapThunkBytes = 37;               // route 1's thunk
constexpr std::size_t kAdapterAt = 64;                    // route 1's adapter (bus->original)
constexpr std::size_t kAdapterBytes = 33;
constexpr std::size_t kWrapSigBytes = 44;                 // through the wrapper's own fail path
constexpr std::size_t kWrapPatchAt = 8;                   // wrapper + 8 .. + 15, written at once
constexpr DWORD kWrapperFail = 1;                         // what the wrapper returns without H or F
inline constexpr char kWrapChanged[] = "changed while it was patched";   // route 1 refused for good

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

inline bool module_alive(PadClient const& c) {
    if (!c.module || !module_mapped(c.module)) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!c.nonce_at || !VirtualQuery(const_cast<LONG const*>(c.nonce_at), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || region.Type != MEM_IMAGE || region.AllocationBase != reinterpret_cast<void*>(c.module))
        return false;
    return *c.nonce_at == c.nonce;
}

inline bool can_own(PadClient const& c) {
    return c.occupied == 2 && c.dispatch && module_alive(c) && code_in_module(reinterpret_cast<void const*>(c.dispatch), c.module);
}

inline bool reg_lock(PadBus* bus, bool wait) {
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
inline void reg_unlock(PadBus* bus) { InterlockedExchange(&bus->reg_lock, 0); }

inline void clear_client(PadClient& c) {
    InterlockedExchange(&c.capture, 0);
    c.chord = 0;
    c.dispatch = nullptr;
    c.rev = 0;
    c.module = nullptr;
    c.nonce_at = nullptr;
    c.nonce = 0;
    std::memset(c.name, 0, sizeof(c.name));
    MemoryBarrier();
    InterlockedExchange(&c.occupied, 0);
}

inline void set_owner(PadBus* bus, int slot) {
    padhook_get_fn const next = slot >= 0 ? bus->clients[slot].dispatch : nullptr;
    if (*bus->dispatch_ptr != next) InterlockedIncrement(&bus->handovers);
    *bus->dispatch_ptr = next;
    InterlockedExchange(&bus->owner_rev, slot >= 0 ? static_cast<LONG>(bus->clients[slot].rev) : 0);
    InterlockedExchange(&bus->owner_slot, slot);
}

inline void reassign_owner(PadBus* bus, int leaving) {
    if (!bus || !bus->dispatch_ptr) return;
    int best = -1;
    for (int i = 0; i < PADHOOK_MAX_CLIENTS; ++i) {
        if (i == leaving || !can_own(bus->clients[i])) continue;
        if (best < 0 || bus->clients[i].rev > bus->clients[best].rev) best = i;
    }
    set_owner(bus, best);
}

// Does any live client hold the pad now? (a capture whose heartbeat is older than PADHOOK_HEARTBEAT_MS
// has lapsed; it is dropped here, once, and counted)
inline bool captured(PadBus* bus, DWORD now, unsigned long* chords = nullptr) {
    bool any = false;
    unsigned long all = 0;
    for (int i = 0; i < PADHOOK_MAX_CLIENTS; ++i) {
        PadClient& c = bus->clients[i];
        if (c.occupied == 2) all |= c.chord;
        if (c.occupied != 2 || !c.capture) continue;
#ifndef PADHOOK_FAULT_NO_HEARTBEAT
        if (now - static_cast<DWORD>(c.alive_tick) > PADHOOK_HEARTBEAT_MS) {
            if (InterlockedCompareExchange(&c.capture, 0, 1) == 1) InterlockedIncrement(&bus->lapses);
            continue;
        }
#else
        (void)now;
#endif
        any = true;
    }
    if (chords) *chords = all;
    return any;
}

inline unsigned long held_of(PadXState const& s) {
    unsigned long h = s.buttons;
    if (s.lt > PADHOOK_TRIGGER_DOWN) h |= PADHOOK_LT;
    if (s.rt > PADHOOK_TRIGGER_DOWN) h |= PADHOOK_RT;
    return h;
}

// The mask rules (see the top of the file), applied to the state the original returned. Pure on its
// inputs: tests call it directly.
inline void apply_mask(PadMask& m, PadXState& s, bool cap, unsigned long hide = 0, unsigned long force = 0) {
    unsigned long const held = held_of(s);
#ifndef PADHOOK_FAULT_TAKE_HELD
    // held from before: what the game has already seen go down (its last state) stays the game's until
    // released; a press that arrives in the same read as the capture is the addon's
    if (cap && !m.was_captured) m.passthru = held_of(m.last_out) & held & ~m.masked;
#else
    if (cap && !m.was_captured) m.passthru = 0;
#endif
    m.passthru &= held;
#ifndef PADHOOK_FAULT_LEAK_HELD
    unsigned long const kept = m.masked & held;                       // hidden presses stay hidden until released
#else
    unsigned long const kept = cap ? (m.masked & held) : 0;
#endif
    unsigned long const now_masked = cap ? ((held & ~m.passthru) | kept) : kept;
    m.hidden += static_cast<unsigned long>(__builtin_popcountl(now_masked & ~m.masked));
    m.masked = now_masked;
    m.was_captured = cap ? 1 : 0;
    PadXState out = s;
    out.buttons = static_cast<WORD>(out.buttons & ~(m.masked & 0xFFFFul));
    if (m.masked & PADHOOK_LT) out.lt = 0;
    if (m.masked & PADHOOK_RT) out.rt = 0;
    if (cap) {
        if (!(m.passthru & PADHOOK_LT)) out.lt = 0;
        if (!(m.passthru & PADHOOK_RT)) out.rt = 0;
        out.lx = out.ly = out.rx = out.ry = 0;
    }
    out.buttons = static_cast<WORD>((out.buttons & ~(hide & 0xFFFFul)) | (force & 0xFFFFul));   // the chord step
    out.packet = 0;
    PadXState last = m.last_out;
    last.packet = 0;
#ifndef PADHOOK_FAULT_NO_RENUMBER
    if (std::memcmp(&out, &last, sizeof(out)) != 0 || m.out_packet == 0) ++m.out_packet;
    out.packet = m.out_packet;
#else
    out.packet = s.packet;
    (void)last;
#endif
    m.last_out = out;
    s = out;
}

// The chord step (rev 2), before the mask: decides from the raw buttons what the game must not see yet
// (*hide), what it must see although released (*force), and makes a completed chord a hidden press in m
// (so it stays hidden until released, by the mask's own rule). Pure on its inputs: tests call it directly.
inline void apply_chord(PadChord& c, PadMask& m, unsigned long held, bool cap, DWORD now,
                        unsigned long* hide, unsigned long* force) {
    *hide = 0;
    *force = 0;
    unsigned long const C = c.buttons;
    unsigned long const on = held & C;
#ifndef PADHOOK_FAULT_NO_CHORD
    if (C == 0 || cap) {                             // nobody asks, or the pad is held (everything new is hidden then)
        c.deferred = 0;
        c.replay = c.replay_left = 0;
        c.prev = on;
        return;
    }
    if (c.replay_left > 0) {
        *force = c.replay & ~held;
        if (--c.replay_left == 0) c.replay = 0;
    }
    unsigned long const fresh = on & ~c.prev;
    // the chord: every button of it either new in this read or still held back (never one the game already has)
    if ((on & C) == C && ((fresh | c.deferred) & C) == C) {
        m.masked |= C;                               // hidden until each is released
        c.deferred = 0;
    } else if (c.deferred != 0) {
        if ((on & c.deferred) == 0) {                // released alone in time: a tap the game still gets
            c.replay = c.deferred;
            c.replay_left = PADHOOK_REPLAY_READS;
            *force |= c.replay & ~held;
            if (--c.replay_left == 0) c.replay = 0;
            c.deferred = 0;
        } else if (now - c.since > PADHOOK_CHORD_MS) {
            c.deferred = 0;                          // held alone too long: the game's now
        }
    } else if (fresh != 0 && (m.masked & fresh) == 0 && (on & ~fresh) == 0) {
        c.deferred = fresh;                          // the first chord button down: wait for its partner
        c.since = now;
    }
    *hide = c.deferred;
#else
    (void)cap; (void)now; (void)m;
#endif
    c.prev = on;
}

inline void record(PadBus* bus, DWORD index, DWORD result, PadXState const* s) {
    PadState& p = bus->pads[index];
    unsigned char const conn = result == ERROR_SUCCESS ? 1 : 0;
    unsigned long const buttons = conn ? held_of(*s) : 0;
    bool const same = p.connected == conn && (!conn || (p.buttons == buttons && p.lt == s->lt && p.rt == s->rt
        && p.lx == s->lx && p.ly == s->ly && p.rx == s->rx && p.ry == s->ry));
    InterlockedIncrement(&bus->wseq);                 // odd: being written
    MemoryBarrier();
    p.tick = GetTickCount();
    ++p.reads;
    if (!same || p.seq == 0) {
        p.connected = conn;
        p.source = PADHOOK_SRC_XINPUT;
        p.buttons = buttons;
        p.lt = conn ? s->lt : 0;
        p.rt = conn ? s->rt : 0;
        p.lx = conn ? s->lx : 0;
        p.ly = conn ? s->ly : 0;
        p.rx = conn ? s->rx : 0;
        p.ry = conn ? s->ry : 0;
        ++p.seq;
        if (p.seq == 0) p.seq = 1;
    }
    MemoryBarrier();
    InterlockedIncrement(&bus->wseq);                 // even again
    if (conn) InterlockedExchange(&bus->last_index, static_cast<LONG>(index));
}

// The dispatcher: one copy per module, entered from the thunk on whichever game thread reads the pad.
inline DWORD PADHOOK_ALIGN_STACK __stdcall dispatch(DWORD index, PadXState* state) {
    PadBus* bus = cached_bus();
    padhook_get_fn const original = bus ? bus->original : nullptr;
    if (!original) return ERROR_DEVICE_NOT_CONNECTED;     // cannot happen: the bus is set before the patch
    InterlockedIncrement(&bus->in_flight);
    InterlockedIncrement(&bus->calls);
    last_dispatch_tid() = GetCurrentThreadId();
    DWORD const r = original(index, state);
    if (index < PADHOOK_INDEXES && state && InterlockedCompareExchange(&bus->write_lock, 1, 0) == 0) {
        record(bus, index, r, state);
        if (r == ERROR_SUCCESS) {
            DWORD const now = GetTickCount();
            unsigned long chords = 0, hide = 0, force = 0;
            bool const cap = captured(bus, now, &chords);
            PadMask& m = bus->masks[index];
            // the chord follows one pad: the user index that last read connected
            if (static_cast<LONG>(index) == bus->last_index) {
                bus->chord.buttons = chords;
                apply_chord(bus->chord, m, held_of(*state), cap, now, &hide, &force);
            }
            apply_mask(m, *state, cap, hide, force);
        }
        InterlockedExchange(&bus->write_lock, 0);
    } else if (r == ERROR_SUCCESS && index < PADHOOK_INDEXES && state) {
        // another thread is writing (two readers at once): hide what is hidden, change nothing else
        PadMask const& m = bus->masks[index];
        state->buttons = static_cast<WORD>(state->buttons & ~(m.masked & 0xFFFFul));
        if (m.was_captured) { state->lx = state->ly = state->rx = state->ry = 0; }
    }
    InterlockedDecrement(&bus->in_flight);
    return r;
}

inline HMODULE self_module() {
    HMODULE m = nullptr;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       reinterpret_cast<LPCSTR>(&dispatch), &m);
    return m;
}

inline void thunk_bytes(std::uintptr_t block, std::uintptr_t site, unsigned char* t) {
    auto const slot = static_cast<std::uint32_t>(block);
    t[0] = 0xA1;
    std::memcpy(t + 1, &slot, 4);
    unsigned char const body[] = {0x85, 0xC0, 0x74, 0x02, 0xFF, 0xE0, 0xE9};
    std::memcpy(t + 5, body, sizeof(body));
    std::uintptr_t const jmp_end = block + kThunkAt + kThunkBytes;
    std::int32_t const rel = static_cast<std::int32_t>((site + 2) - jmp_end);
    std::memcpy(t + 12, &rel, 4);
}

inline void hexbytes(char* out, std::size_t n, unsigned char const* p, int count) {
    std::size_t len = 0;
    out[0] = 0;
    for (int i = 0; i < count && len + 4 < n; ++i) len += static_cast<std::size_t>(std::snprintf(out + len, n - len, "%s%02X", i ? " " : "", p[i]));
}

// ---- route 1: the client's XInput wrapper (rev 3) ----

// The wrapper's first 44 bytes, through its fail path (mov eax, 1 / ret 8), so the value the thunk and the
// adapter return without F (kWrapperFail) is the client's own. Bytes 1..4 (H) and 10..13 (F) are the slot
// addresses, which differ by build.
constexpr unsigned char kWrapSig[kWrapSigBytes] = {
    0xA1, 0x00, 0x00, 0x00, 0x00, 0x85, 0xC0, 0x74, 0x1B, 0xA1, 0x00, 0x00, 0x00, 0x00, 0x85, 0xC0, 0x74, 0x12,
    0x8B, 0x4C, 0x24, 0x08, 0x8B, 0x54, 0x24, 0x04, 0x51, 0x52, 0xFF, 0xD0, 0x83, 0xC4, 0x08, 0xC2, 0x08, 0x00,
    0xB8, 0x01, 0x00, 0x00, 0x00, 0xC2, 0x08, 0x00,
};

inline std::uint32_t le32(unsigned char const* p) {
    std::uint32_t v = 0;
    std::memcpy(&v, p, 4);
    return v;
}

inline bool wrap_sig_at(unsigned char const* p) {
    for (std::size_t i = 0; i < kWrapSigBytes; ++i) {
        if ((i >= 1 && i <= 4) || (i >= 10 && i <= 13)) continue;
        if (p[i] != kWrapSig[i]) return false;
    }
    return true;
}

struct WrapperHit {
    std::uintptr_t site;             // the wrapper
    std::uintptr_t handle_slot;      // H: the shim's handle
    std::uintptr_t fn_slot;          // F: its XInputGetState_ (H + 4)
};

// The GetState wrappers in n bytes at p, which the process sees at `base`: the signature's matches where
// F = H + 4 (the SetState wrapper's match has F = H + 8). *first = the first one. Pure: tests call it.
inline int scan_wrappers(unsigned char const* p, std::size_t n, std::uintptr_t base, WrapperHit* first) {
    int count = 0;
    for (std::size_t off = 0; off + kWrapSigBytes <= n; ++off) {
        if (p[off] != 0xA1 || !wrap_sig_at(p + off)) continue;
        std::uint32_t const h = le32(p + off + 1), f = le32(p + off + 10);
#ifndef PADHOOK_FAULT_FIRST_MATCH
        if (f != h + 4) continue;
#endif
        if (count == 0 && first) *first = WrapperHit {base + off, h, f};
        ++count;
#ifdef PADHOOK_FAULT_FIRST_MATCH
        break;
#endif
    }
    return count;
}

// What the scan's result means: null when it can be patched, otherwise why not. Pure: tests call it.
inline char const* scan_verdict(int count, WrapperHit const& hit) {
    if (count == 0) return "was not found (a client update?)";
    if (count > 1) return "is not unique";
    if ((hit.site + kWrapPatchAt) % 8 != 0) return "is not on an 8-byte boundary at +8";
    return nullptr;
}

// Route 1's thunk (kWrapThunkBytes, at block + kThunkAt).
inline void wrap_thunk_bytes(std::uintptr_t block, std::uintptr_t fn_slot, unsigned char* t) {
    auto const d = static_cast<std::uint32_t>(block);
    auto const f = static_cast<std::uint32_t>(fn_slot);
#ifndef PADHOOK_FAULT_OLD_THUNK
    unsigned char const code[kWrapThunkBytes] = {
        0xA1, 0, 0, 0, 0,                // mov eax, [dispatch]
        0x85, 0xC0, 0x74, 0x0B,          // test eax, eax / jz pass
        0xFF, 0x74, 0x24, 0x08,          // push [esp+8]
        0xFF, 0x74, 0x24, 0x08,          // push [esp+8]
        0xFF, 0xD0, 0xC3,                // call eax / ret
        0xA1, 0, 0, 0, 0,                // pass: mov eax, [F]
        0x85, 0xC0, 0x74, 0x02,          // test eax, eax / jz none
        0xFF, 0xE0,                      // jmp eax
        0xB8, 0x01, 0x00, 0x00, 0x00,    // none: mov eax, 1
        0xC3,                            // ret
    };
#else
    // route 0's thunk shape on this route: the __stdcall dispatcher is reached by a jump (the crash)
    unsigned char const code[kWrapThunkBytes] = {
        0xA1, 0, 0, 0, 0, 0x85, 0xC0, 0x74, 0x0B, 0xFF, 0xE0, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90, 0x90,
        0xA1, 0, 0, 0, 0, 0x85, 0xC0, 0x74, 0x02, 0xFF, 0xE0, 0xB8, 0x01, 0x00, 0x00, 0x00, 0xC3,
    };
#endif
    std::memcpy(t, code, kWrapThunkBytes);
    std::memcpy(t + 1, &d, 4);
    std::memcpy(t + 21, &f, 4);
}

// Route 1's adapter (kAdapterBytes, at block + kAdapterAt): the client's __cdecl F behind a __stdcall entry.
inline void wrap_adapter_bytes(std::uintptr_t fn_slot, unsigned char* t) {
    auto const f = static_cast<std::uint32_t>(fn_slot);
    unsigned char const code[kAdapterBytes] = {
        0xA1, 0, 0, 0, 0,                // mov eax, [F]
        0x85, 0xC0, 0x74, 0x10,          // test eax, eax / jz none
        0xFF, 0x74, 0x24, 0x08,          // push [esp+8]
        0xFF, 0x74, 0x24, 0x08,          // push [esp+8]
        0xFF, 0xD0,                      // call eax
        0x83, 0xC4, 0x08,                // add esp, 8
        0xC2, 0x08, 0x00,                // ret 8
        0xB8, 0x01, 0x00, 0x00, 0x00,    // none: mov eax, 1
        0xC2, 0x08, 0x00,                // ret 8
    };
    std::memcpy(t, code, kAdapterBytes);
    std::memcpy(t + 1, &f, 4);
}

// The 8 bytes at wrapper + 8 before the patch, and after it.
inline void wrap_patch_bytes(WrapperHit const& hit, std::uintptr_t thunk, unsigned char* expect, unsigned char* want) {
    auto const f = static_cast<std::uint32_t>(hit.fn_slot);
    auto const t = static_cast<std::uint32_t>(thunk);
    unsigned char const before[8] = {0x1B, 0xA1, 0, 0, 0, 0, 0x85, 0xC0};     // jz's offset / mov eax, [F] / test
    std::memcpy(expect, before, 8);
    std::memcpy(expect + 2, &f, 4);
    std::memcpy(want, before, 8);
    want[1] = 0xB8;                                                          // mov eax, thunk
    std::memcpy(want + 2, &t, 4);
}

// Patch a wrapper that the checks have passed: the block, then one locked 8-byte compare-and-exchange (as
// UiHook's write_site). Null on success, with bus->block, dispatch_ptr, site, original and route set.
inline char const* install_wrapper(PadBus* bus, WrapperHit const& hit) {
    auto* block = static_cast<unsigned char*>(VirtualAlloc(nullptr, kBlockBytes, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
    if (!block) return "could not be patched (no memory for the hook block)";
    std::memset(block, 0xCC, kBlockBytes);
    std::memset(block, 0, 4);
    auto const b = reinterpret_cast<std::uintptr_t>(block);
    wrap_thunk_bytes(b, hit.fn_slot, block + kThunkAt);
    wrap_adapter_bytes(hit.fn_slot, block + kAdapterAt);
    FlushInstructionCache(GetCurrentProcess(), block, kBlockBytes);
    bus->block = block;
    bus->dispatch_ptr = reinterpret_cast<padhook_get_fn volatile*>(block);
    bus->site = hit.site;
    bus->original = reinterpret_cast<padhook_get_fn>(block + kAdapterAt);
    InterlockedExchange(&bus->route, PADHOOK_ROUTE_WRAPPER);
    MemoryBarrier();
    auto undo = [&](char const* why) {
        bus->block = nullptr; bus->dispatch_ptr = nullptr; bus->site = 0; bus->original = nullptr;
        InterlockedExchange(&bus->route, PADHOOK_ROUTE_EXPORT);
        VirtualFree(block, 0, MEM_RELEASE);
        return why;
    };
    std::uintptr_t const at = hit.site + kWrapPatchAt;
    DWORD previous = 0;
    if (!VirtualProtect(reinterpret_cast<void*>(at), 8, PAGE_EXECUTE_READWRITE, &previous))
        return undo("could not be patched (VirtualProtect failed)");
    unsigned char expect[8], want[8];
    wrap_patch_bytes(hit, b + kThunkAt, expect, want);
    LONGLONG old_v = 0, new_v = 0;
    std::memcpy(&old_v, expect, 8);
    std::memcpy(&new_v, want, 8);
    bool const wrote = InterlockedCompareExchange64(reinterpret_cast<LONGLONG volatile*>(at), new_v, old_v) == old_v;
    VirtualProtect(reinterpret_cast<void*>(at), 8, previous, &previous);
    FlushInstructionCache(GetCurrentProcess(), reinterpret_cast<void*>(at), 8);
    if (!wrote) return undo(kWrapChanged);
    return nullptr;
}

// The wrapper's handle slot on a route 1 bus (from the patched bytes, which keep H), or 0. Checked once per
// module: the bytes must be the patched wrapper, pointing at this bus's thunk.
inline std::uintptr_t handle_slot(PadBus const* bus) {
    static std::uintptr_t cached = 0;
    if (cached) return cached;
    if (!bus || bus->route != PADHOOK_ROUTE_WRAPPER || !bus->hook_installed || !bus->block) return 0;
    std::uintptr_t const site = bus->site;
    if (!span_readable(site, kWrapSigBytes)) return 0;
    auto const* p = reinterpret_cast<unsigned char const*>(site);
    if (p[0] != 0xA1 || p[9] != 0xB8 || le32(p + 10) != static_cast<std::uint32_t>(reinterpret_cast<std::uintptr_t>(bus->block) + kThunkAt))
        return 0;
    std::uintptr_t const slot = le32(p + 1);
    if (!span_readable(slot, 8)) return 0;
    cached = slot;
    return cached;
}

inline std::uintptr_t read_slot(std::uintptr_t slot) { return *reinterpret_cast<std::uintptr_t const volatile*>(slot); }

inline volatile LONG& shim_pinned() { static volatile LONG value = 0; return value; }   // one per module

// fn(section) for every section of the loaded client module, or false when it is not loaded or its
// headers are unreadable.
template <typename Fn>
inline bool for_each_game_section(HMODULE* out, Fn&& fn) {
    HMODULE module = GetModuleHandleA(PADHOOK_GAME);
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

// fn(bytes, n, address) for every run of committed readable pages in [begin, end) (a VirtualProtect inside
// the module splits regions, so a section is never tested whole; as UiHook's scan_each)
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

inline bool page_writable(DWORD protect) {
    if (protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
    switch (protect & 0xFF) {
    case PAGE_READWRITE: case PAGE_WRITECOPY: case PAGE_EXECUTE_READWRITE: case PAGE_EXECUTE_WRITECOPY: return true;
    default: return false;
    }
}

// Are both slots (H and F, 8 bytes) inside one writable section of the client module, and writable now?
inline bool slots_writable(WrapperHit const& hit) {
    bool ok = false;
    for_each_game_section(nullptr, [&](std::uintptr_t begin, std::uintptr_t end, DWORD flags) {
        if (hit.handle_slot >= begin && hit.handle_slot + 8 <= end && (flags & IMAGE_SCN_MEM_WRITE)) ok = true;
    });
    if (!ok) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(reinterpret_cast<void const*>(hit.handle_slot), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || region.Type != MEM_IMAGE || !page_writable(region.Protect)) return false;
    std::uintptr_t const low = reinterpret_cast<std::uintptr_t>(region.BaseAddress);
    return hit.handle_slot >= low && hit.handle_slot + 8 <= low + region.RegionSize;
}

// The scan over the client's code sections, done once per module (the client's code never changes).
struct WrapperScan {
    int state;                       // 0 not yet (the client module is not loaded), 1 found, 2 refused for good
    WrapperHit hit;
    char const* why;
    int mismatches;                  // joins that found the slots holding other values (refused for good at 3)
};
inline WrapperScan& wrapper_scan() { static WrapperScan value = {0, {0, 0, 0}, nullptr, 0}; return value; }

// Can route 1 still go live, as far as this module knows? False once it is refused for good.
inline bool route1_open() { return wrapper_scan().state != 2; }

inline WrapperScan& find_wrapper() {
    WrapperScan& s = wrapper_scan();
    if (s.state != 0) return s;
    int count = 0;
    WrapperHit first {0, 0, 0};
    HMODULE game = nullptr;
    bool const headers = for_each_game_section(&game, [&](std::uintptr_t begin, std::uintptr_t end, DWORD flags) {
        if (!(flags & IMAGE_SCN_MEM_EXECUTE)) return;
        for_each_readable_run(begin, end, [&](unsigned char const* p, std::size_t n, std::uintptr_t at) {
            WrapperHit h {0, 0, 0};
            int const c = scan_wrappers(p, n, at, &h);
            if (c > 0 && count == 0) first = h;
            count += c;
        });
    });
    if (!game) { s.why = "was not looked for (" PADHOOK_GAME " is not loaded)"; return s; }
    s.state = 2;
    if (!headers) { s.why = "was not looked for (" PADHOOK_GAME "'s headers are unreadable)"; return s; }
    s.why = scan_verdict(count, first);
    if (!s.why && !slots_writable(first)) s.why = "has its slots outside a writable section of " PADHOOK_GAME;
    if (!s.why) { s.hit = first; s.state = 1; }
    return s;
}

// Once the client has loaded its shim (H is not zero): H holds xinputdll.dll's handle, and F its GetState.
// A few tries, a ms apart: the client may be writing the slots at that moment.
inline char const* slot_values(WrapperHit const& hit) {
    char const* why = nullptr;
    for (int attempt = 0; attempt < 4; ++attempt) {
        if (attempt) Sleep(1);
        std::uintptr_t const h = read_slot(hit.handle_slot);
        if (h == 0) return nullptr;                  // not loaded yet: the signature and the layout decide alone
        HMODULE shim = nullptr;
        if (!GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, PADHOOK_SHIM, &shim)
            || reinterpret_cast<std::uintptr_t>(shim) != h) {
            why = "has a handle slot that does not hold " PADHOOK_SHIM;
            continue;
        }
        auto const want = reinterpret_cast<std::uintptr_t>(reinterpret_cast<void*>(GetProcAddress(shim, PADHOOK_SHIM_GET)));
        if (!want || read_slot(hit.fn_slot) != want) {
            why = "has a function slot that does not hold " PADHOOK_SHIM "!" PADHOOK_SHIM_GET;
            continue;
        }
        return nullptr;
    }
    return why;
}

}  // namespace padhook_detail

// Attach to the process-wide bus, creating it on first use (leaked on purpose: it belongs to the process).
inline PadBus* padhook_attach() {
    PadBus*& cached = padhook_detail::cached_bus();
    if (cached) return cached;
    char name[64];
    std::snprintf(name, sizeof(name), PADHOOK_MAP_NAME_FMT, static_cast<unsigned long>(GetCurrentProcessId()));
    HANDLE mapping = CreateFileMappingA(INVALID_HANDLE_VALUE, nullptr, PAGE_READWRITE, 0, PADHOOK_MAP_BYTES, name);
    if (!mapping) return nullptr;
    bool const existed = GetLastError() == ERROR_ALREADY_EXISTS;
    auto* bus = static_cast<PadBus*>(MapViewOfFile(mapping, FILE_MAP_ALL_ACCESS, 0, 0, PADHOOK_MAP_BYTES));
    if (!bus) { CloseHandle(mapping); return nullptr; }
    if (!existed) {
        bus->abi_version = PADHOOK_ABI_VERSION;
        bus->size = sizeof(PadBus);
        bus->owner_slot = -1;
        bus->last_index = -1;
        std::snprintf(bus->status, sizeof(bus->status), "bus created");
        MemoryBarrier();
        InterlockedExchange(&bus->ready, 1);
    } else {
        for (int spin = 0; spin < 2000 && InterlockedCompareExchange(&bus->ready, 0, 0) == 0; ++spin) Sleep(1);
        if (InterlockedCompareExchange(&bus->ready, 0, 0) == 0) { UnmapViewOfFile(bus); CloseHandle(mapping); return nullptr; }
    }
    if (bus->abi_version != PADHOOK_ABI_VERSION || bus->size < offsetof(PadBus, status) + sizeof(bus->status)
        || bus->size > PADHOOK_MAP_BYTES) {
        UnmapViewOfFile(bus);
        CloseHandle(mapping);
        return nullptr;
    }
    for (;;) {
        LONG const seen = static_cast<LONG>(bus->size);
        if (seen >= static_cast<LONG>(sizeof(PadBus))) break;
        if (InterlockedCompareExchange(reinterpret_cast<volatile LONG*>(&bus->size), sizeof(PadBus), seen) == seen) break;
    }
    cached = bus;
    return bus;
}

// bus->blocked means route 0 is refused for good (a rev 2 module sets it too). Rev 3 calls the bus blocked only
// once route 1 is refused for good as well. Until then it waits, and a host retries padhook_join.
inline int padhook_state(PadBus const* bus) {
    if (!bus) return PADHOOK_NO_BUS;
    if (bus->hook_installed) return PADHOOK_LIVE;
    if (bus->blocked && !padhook_detail::route1_open()) return PADHOOK_BLOCKED;
    return PADHOOK_WAIT;
}

namespace padhook_detail {

// Route 1, under install_lock: null when it is live, otherwise why not.
inline char const* try_wrapper(PadBus* bus) {
    WrapperScan& s = find_wrapper();
    if (s.state != 1) return s.why;
    if (char const* why = slot_values(s.hit)) {
        if (++s.mismatches >= 3) { s.state = 2; s.why = why; }   // seconds apart: not the client mid-write
        return why;
    }
    char const* why = install_wrapper(bus, s.hit);
    if (why == kWrapChanged) { s.state = 2; s.why = why; }   // another tool's patch: never again in this module
    return why;
}

// Route 0, under install_lock: 0 live, 1 retry later, 2 never in this process; *why says why not.
inline int try_export(PadBus* bus, char* why, std::size_t n) {
    auto fail = [&](int verdict, char const* fmt, char const* a = "") {
        std::snprintf(why, n, fmt, a);
        return verdict;
    };
    // the game loads xinput1_3.dll itself when it uses XInput; nui never loads it (no XInput reads in DirectInput mode)
    HMODULE xi = nullptr;
    if (!GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_PIN, PADHOOK_DLL, &xi) || !xi)
        return fail(1, "%s is not loaded (the game reads the pad with DirectInput, or not yet)", PADHOOK_DLL);
    auto const site = reinterpret_cast<std::uintptr_t>(reinterpret_cast<void*>(GetProcAddress(xi, "XInputGetState")));
    if (!site || !span_readable(site - 5, 7)) return fail(2, "XInputGetState not found in %s", PADHOOK_DLL);
    auto const* p = reinterpret_cast<unsigned char const*>(site);
    bool pad_ok = true;
    for (int i = -5; i < 0; ++i) pad_ok = pad_ok && (p[i] == 0x90 || p[i] == 0xCC);
    if (p[0] == 0xEB || p[0] == 0xE9 || p[-5] == 0xE9) {
        char hex[40];
        hexbytes(hex, sizeof(hex), p - 5, 7);
        return fail(2, "XInputGetState is already hooked by another tool (%s): not patched", hex);
    }
    if (!pad_ok || p[0] != 0x8B || p[1] != 0xFF) {
        char hex[40];
        hexbytes(hex, sizeof(hex), p - 5, 7);
        return fail(2, "XInputGetState is not hot-patchable (%s): not patched", hex);
    }
    auto* block = static_cast<unsigned char*>(VirtualAlloc(nullptr, kBlockBytes, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
    if (!block) return fail(1, "hook block alloc failed%s");
    std::memset(block, 0xCC, kBlockBytes);
    std::memset(block, 0, 4);
    unsigned char* t = block + kThunkAt;
    thunk_bytes(reinterpret_cast<std::uintptr_t>(block), site, t);
    FlushInstructionCache(GetCurrentProcess(), block, kBlockBytes);
    bus->block = block;
    bus->dispatch_ptr = reinterpret_cast<padhook_get_fn volatile*>(block);
    bus->site = site;
    bus->original = reinterpret_cast<padhook_get_fn>(site + 2);
    InterlockedExchange(&bus->route, PADHOOK_ROUTE_EXPORT);
    MemoryBarrier();

    DWORD previous = 0;
    if (!VirtualProtect(reinterpret_cast<void*>(site - 5), 7, PAGE_EXECUTE_READWRITE, &previous)) {
        bus->block = nullptr; bus->dispatch_ptr = nullptr; bus->site = 0; bus->original = nullptr;
        VirtualFree(block, 0, MEM_RELEASE);
        return fail(1, "VirtualProtect failed%s");
    }
    auto* w = reinterpret_cast<unsigned char*>(site - 5);
    std::int32_t const to_thunk = static_cast<std::int32_t>(reinterpret_cast<std::uintptr_t>(t) - site);
    w[0] = 0xE9;                                       // the padding: no thread runs here
    std::memcpy(w + 1, &to_thunk, 4);
    FlushInstructionCache(GetCurrentProcess(), w, 5);
    // the entry: 8B FF -> EB F9 in one locked 16-bit compare-and-exchange
    unsigned short const want = 0xF9EB, expect = 0xFF8B;
    bool const wrote = __sync_val_compare_and_swap(reinterpret_cast<unsigned short volatile*>(site), expect, want) == expect;
    if (!wrote) std::memset(w, 0x90, 5);
    VirtualProtect(reinterpret_cast<void*>(site - 5), 7, previous, &previous);
    FlushInstructionCache(GetCurrentProcess(), reinterpret_cast<void*>(site - 5), 7);
    if (!wrote) {
        bus->block = nullptr; bus->dispatch_ptr = nullptr; bus->site = 0; bus->original = nullptr;
        VirtualFree(block, 0, MEM_RELEASE);
        return fail(2, "XInputGetState changed while patching%s");
    }
    return 0;
}

// The part of the status that names route 0's reason (rev 3 writes "<route 1's reason>; <route 0's>").
inline char const* export_reason(char const* status) {
    static char const prefix[] = PADHOOK_WRAPPER " ";
    if (std::strncmp(status, prefix, sizeof(prefix) - 1) != 0) return status;
    char const* tail = std::strstr(status, "; ");
    return tail ? tail + 2 : "";
}

}  // namespace padhook_detail

// Route 1: pin xinputdll.dll once the client has loaded it, so the client's unloader can never unmap it while
// a read is on its way through the dispatcher. pad() calls this. Until the client loads the shim it costs one
// read of the handle slot. True once this module has pinned it. A rev 1 or 2 module never pins it: on a bus
// where only such modules poll, the shim stays unpinned, as it is without nui.
inline bool padhook_pin(PadBus const* bus) {
    using namespace padhook_detail;
    volatile LONG& pinned = shim_pinned();
    if (pinned) return true;
    std::uintptr_t const slot = handle_slot(bus);
    if (!slot) return false;
    // a handle that was not the shim (the client between FreeLibrary and zeroing H, or something else): asked
    // about again at most once a second
    static std::uintptr_t refused = 0;
    static DWORD refused_at = 0;
    std::uintptr_t const h = read_slot(slot);
    if (h == 0 || (h == refused && GetTickCount() - refused_at < 1000)) return false;
    HMODULE shim = nullptr;
    if (!GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT, PADHOOK_SHIM, &shim)
        || reinterpret_cast<std::uintptr_t>(shim) != h) {
        refused = h;
        refused_at = GetTickCount();
        return false;
    }
    HMODULE held = nullptr;
    if (!GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_PIN, PADHOOK_SHIM, &held) || held != shim) return false;
    InterlockedExchange(&pinned, 1);
    return true;
}

// Is the client's shim loaded now (route 1: the handle slot is not zero)? False on route 0.
inline bool padhook_shim_loaded(PadBus const* bus) {
    std::uintptr_t const slot = padhook_detail::handle_slot(bus);
    return slot && padhook_detail::read_slot(slot) != 0;
}

// Patch one route if nobody has yet: route 1, the client's XInput wrapper, then route 0, the export. True when
// a patch is live, whoever wrote it. False with bus->status naming both routes' reasons: retry later
// (PADHOOK_WAIT), or never in this process (bus->blocked). A rev 2 module may have set bus->blocked: route 1 is
// still tried then, and clears it. simulate_missing: both not-found paths, always.
inline bool padhook_ensure_hook(PadBus* bus, bool simulate_missing = false, char const* who = nullptr) {
    using namespace padhook_detail;
    if (!bus) return false;
    if (InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0) return true;
    if (simulate_missing) {
        if (InterlockedCompareExchange(&bus->blocked, 0, 0) == 0)   // a blocked bus keeps route 0's real reason
            std::snprintf(bus->status, sizeof(bus->status), "%s was not found (simulated); %s is not loaded (simulated)",
                          PADHOOK_WRAPPER, PADHOOK_DLL);
        return false;
    }
    if (InterlockedCompareExchange(&bus->install_lock, 1, 0) != 0) {
        for (int spin = 0; spin < 2000 && InterlockedCompareExchange(&bus->hook_installed, 0, 0) == 0; ++spin) Sleep(1);
        return InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0;
    }
    auto done = [&](bool live) {
        if (live) {
            InterlockedIncrement(&bus->installs);
            InterlockedExchange(&bus->hook_installed, 1);
        }
        InterlockedExchange(&bus->install_lock, 0);
        return live;
    };
    if (InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0) {   // patched between the first check and the lock
        InterlockedExchange(&bus->install_lock, 0);
        return true;
    }
    char const* const who_s = who && *who ? who : "?";
#ifdef PADHOOK_FAULT_EXPORT_FIRST
    {
        char why0[176];
        if (!InterlockedCompareExchange(&bus->blocked, 0, 0) && try_export(bus, why0, sizeof(why0)) == 0) {
            std::snprintf(bus->status, sizeof(bus->status), "hook installed at %s!XInputGetState", PADHOOK_DLL);
            return done(true);
        }
    }
#endif
    char const* const why_wrapper = try_wrapper(bus);
    if (!why_wrapper) {
        std::snprintf(bus->status, sizeof(bus->status), "hook installed at %s %08lX by %s (rev %d)", PADHOOK_WRAPPER,
                      static_cast<unsigned long>(bus->site), who_s, PADHOOK_REV);
        InterlockedExchange(&bus->blocked, 0);
        done(true);
        padhook_pin(bus);
        return true;
    }
    char why_export[176];
    int verdict = 2;
    if (InterlockedCompareExchange(&bus->blocked, 0, 0) != 0) {
        std::snprintf(why_export, sizeof(why_export), "%s", export_reason(bus->status));   // refused before: never again
    } else {
        verdict = try_export(bus, why_export, sizeof(why_export));
    }
    if (verdict == 0) {
        std::snprintf(bus->status, sizeof(bus->status), "hook installed at %s!XInputGetState %08lX by %s (rev %d); %s %s",
                      PADHOOK_DLL, static_cast<unsigned long>(bus->site), who_s, PADHOOK_REV, PADHOOK_WRAPPER, why_wrapper);
        return done(true);
    }
    std::snprintf(bus->status, sizeof(bus->status), "%s %s; %s", PADHOOK_WRAPPER, why_wrapper, why_export);
    if (verdict == 2) InterlockedExchange(&bus->blocked, 1);
    return done(false);
}

// A slot index, or -1. The dispatch goes to this module when nobody drives it, when its revision is
// higher than the driver's, or when the driver's dispatcher is no longer mapped.
inline int padhook_register(PadBus* bus, char const* name = nullptr) {
    using namespace padhook_detail;
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
    for (int i = 0; i < PADHOOK_MAX_CLIENTS; ++i) {
        if (InterlockedCompareExchange(&bus->clients[i].occupied, 1, 0) != 0) continue;
        PadClient& c = bus->clients[i];
        c.capture = 0;
        c.chord = 0;
        c.alive_tick = static_cast<LONG>(GetTickCount());
        c.dispatch = &dispatch;
        c.rev = PADHOOK_REV;
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
        bool take = owner < 0 || owner >= PADHOOK_MAX_CLIENTS;
        if (!take) {
            PadClient const& o = bus->clients[owner];
            take = !can_own(o) || o.dispatch != *bus->dispatch_ptr;
        }
        if (!take) take = static_cast<LONG>(PADHOOK_REV) > InterlockedCompareExchange(&bus->owner_rev, 0, 0);
        if (take) set_owner(bus, slot);
    }
    reg_unlock(bus);
    return slot;
}

// Leave the bus; also from DllMain(DLL_PROCESS_DETACH) with may_wait = false (loader lock).
inline void padhook_unregister(PadBus* bus, int slot, bool may_wait) {
    using namespace padhook_detail;
    if (!bus || slot < 0 || slot >= PADHOOK_MAX_CLIENTS) return;
    PadClient& c = bus->clients[slot];
    if (c.dispatch != &dispatch) return;
    reg_lock(bus, true);
    InterlockedExchange(&c.capture, 0);
    bool const drove = InterlockedCompareExchange(&bus->owner_slot, 0, 0) == slot;
    if (drove) reassign_owner(bus, slot);
    LONG const handed_at = InterlockedCompareExchange(&bus->calls, 0, 0);
    clear_client(c);
    reg_unlock(bus);
    if (may_wait) {
        for (int spin = 0; spin < 200 && InterlockedCompareExchange(&bus->in_flight, 0, 0) != 0; ++spin) Sleep(1);
        if (drove && last_dispatch_tid() != GetCurrentThreadId()) {
            DWORD const t0 = GetTickCount();
            while (InterlockedCompareExchange(&bus->calls, 0, 0) - handed_at < 2 && GetTickCount() - t0 < PADHOOK_DRAIN_MS) Sleep(1);
        }
    }
}

// Patch if nobody has, then register. A slot >= 0, or a PADHOOK_JOIN_* code.
inline int padhook_join(PadBus* bus, char const* name = nullptr, bool simulate_missing = false) {
    if (!bus) return PADHOOK_JOIN_NO_BUS;
    if (!padhook_ensure_hook(bus, simulate_missing, name))
        return padhook_state(bus) == PADHOOK_BLOCKED ? PADHOOK_JOIN_BLOCKED : PADHOOK_JOIN_RETRY;
    int const slot = padhook_register(bus, name);
    return slot >= 0 ? slot : PADHOOK_JOIN_FULL;
}

// Hold or give back the pad. Holding lasts while the client renews it (padhook_alive) at least every
// PADHOOK_HEARTBEAT_MS.
inline void padhook_capture(PadBus* bus, int slot, bool on) {
    if (!bus || slot < 0 || slot >= PADHOOK_MAX_CLIENTS) return;
    PadClient& c = bus->clients[slot];
    if (c.dispatch != &padhook_detail::dispatch) return;
    InterlockedExchange(&c.alive_tick, static_cast<LONG>(GetTickCount()));
    InterlockedExchange(&c.capture, on ? 1 : 0);
}

inline void padhook_alive(PadBus* bus, int slot) {
    if (!bus || slot < 0 || slot >= PADHOOK_MAX_CLIENTS) return;
    PadClient& c = bus->clients[slot];
    if (c.dispatch != &padhook_detail::dispatch) return;
    InterlockedExchange(&c.alive_tick, static_cast<LONG>(GetTickCount()));
}

// rev 2: the buttons that, pressed together, take this client's pad (0: none). The hook keeps the chord from
// the game (see the top of the file); the client still sees it raw, and takes the pad itself.
inline void padhook_chord(PadBus* bus, int slot, unsigned long buttons) {
    if (!bus || slot < 0 || slot >= PADHOOK_MAX_CLIENTS) return;
    PadClient& c = bus->clients[slot];
    if (c.dispatch != &padhook_detail::dispatch) return;
    c.chord = buttons;
    MemoryBarrier();
}

// Is this client's capture still on (it lapses without a heartbeat)?
inline bool padhook_holding(PadBus const* bus, int slot) {
    if (!bus || slot < 0 || slot >= PADHOOK_MAX_CLIENTS) return false;
    return bus->clients[slot].occupied == 2 && bus->clients[slot].capture != 0;
}

// A consistent copy of what the game last read at `index` (false while a write keeps it torn after a few tries).
inline bool padhook_read(PadBus const* bus, int index, PadState* out) {
    if (!bus || index < 0 || index >= PADHOOK_INDEXES || !out) return false;
    for (int tries = 0; tries < 8; ++tries) {
        LONG const a = bus->wseq;
        if (a & 1) { YieldProcessor(); continue; }
        MemoryBarrier();
        std::memcpy(out, const_cast<PadState const*>(&bus->pads[index]), sizeof(PadState));
        MemoryBarrier();
        if (bus->wseq == a) return true;
    }
    return false;
}

inline int padhook_active_clients(PadBus const* bus) {
    if (!bus) return 0;
    int n = 0;
    for (int i = 0; i < PADHOOK_MAX_CLIENTS; ++i) if (bus->clients[i].occupied == 2) ++n;
    return n;
}

// One line for a status display, e.g.
//   "live at FFXiMain's XInput wrapper 10008EA0; 1 client: chronicle r3 (drives)"
//   "live at FFXiMain's XInput wrapper 10008EA0 (the client has not loaded xinputdll.dll yet); 1 client: ..."
//   "live at xinput1_3.dll!XInputGetState 6C1A2B30; 2 clients: chronicle r3 (drives, holds), hud r2"
//   "blocked: FFXiMain's XInput wrapper was not found (a client update?); XInputGetState is not hot-patchable (...)"
inline void padhook_describe(PadBus const* bus, char* out, std::size_t n) {
    if (!out || n == 0) return;
    out[0] = 0;
    int const st = padhook_state(bus);
    if (st == PADHOOK_NO_BUS) { std::snprintf(out, n, "no bus"); return; }
    if (st != PADHOOK_LIVE) {
        std::snprintf(out, n, "%s: %s", st == PADHOOK_BLOCKED ? "blocked" : "waiting", bus->status);
        return;
    }
    int const clients = padhook_active_clients(bus);
    std::size_t len = 0;
    if (bus->route == PADHOOK_ROUTE_WRAPPER) {
        len = static_cast<std::size_t>(std::snprintf(out, n, "live at %s %08lX%s; %d client%s", PADHOOK_WRAPPER,
            static_cast<unsigned long>(bus->site), padhook_shim_loaded(bus) ? "" : " (the client has not loaded " PADHOOK_SHIM " yet)",
            clients, clients == 1 ? "" : "s"));
    } else {
        len = static_cast<std::size_t>(std::snprintf(out, n, "live at %s!XInputGetState %08lX; %d client%s", PADHOOK_DLL,
            static_cast<unsigned long>(bus->site), clients, clients == 1 ? "" : "s"));
    }
    char const* sep = ": ";
    for (int i = 0; i < PADHOOK_MAX_CLIENTS && len < n; ++i) {
        PadClient const& c = bus->clients[i];
        if (c.occupied != 2) continue;
        char nm[17];
        std::memcpy(nm, c.name, 16);
        nm[16] = 0;
        bool const drives = bus->owner_slot == i, holds = c.capture != 0;
        len += static_cast<std::size_t>(std::snprintf(out + len, n - len, "%s%s r%lu%s", sep, nm[0] ? nm : "?",
            static_cast<unsigned long>(c.rev), drives && holds ? " (drives, holds)" : drives ? " (drives)" : holds ? " (holds)" : ""));
        sep = ", ";
    }
}

#endif  // PADHOOK_H
