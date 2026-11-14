// UiHook.h - shared hook on FFXiMain's EndScene wrapper, for 2D drawn ABOVE the game's own UI.
// UiHook 2: one ABI forever, revisions within it.
//
// Modelled on BroGuyPal's SceneHook.h, with its own mapping name so
// the two buses never meet. SceneHook draws inside draw_scene (under the UI); UiHook draws after the
// game's whole 2D pass, just before the frame's EndScene, so callbacks sit on top of the game's
// windows. Windower's own texts are drawn by its device wrapper later and stay on top.
//
// The target (client build 2026-10-13): the renderer's EndScene wrapper, __thiscall,
// ecx = renderer ([0x1045666C]), 16 bytes, unique in .text:
//
//     8B 41 0C          mov eax, [ecx+0Ch]       ; the device
//     50                push eax
//     8B 08             mov ecx, [eax]           ; its vtable
//     FF 91 8C 00 00 00 call [ecx+8Ch]           ; IDirect3DDevice8::EndScene
//     C3                ret
//     90 90 90
//
// It is found by that signature, never by address. Exactly one match is required; anything else
// (a client update, another tool's patch, an older UiHook) means no patch and a status message.
//
// The patch, written once and never undone (the first 6 bytes are three whole instructions), in one
// locked 8-byte write of bytes 0..7 (6..7 unchanged; write_site):
//
//     wrapper:  E9 <rel32 -> thunk>  90
//
// The thunk lives in one VirtualAlloc block owned by no module and never freed:
//
//     block+0   dispatch       the owner module's dispatcher, or null
//     block+16  60             pushad
//               A1 <&dispatch> mov eax, [dispatch]
//               85 C0          test eax, eax
//               74 06          jz  done
//               51             push ecx              ; renderer
//               FF D0          call eax              ; __cdecl dispatch(renderer)
//               83 C4 04       add esp, 4
//     done:     61             popad
//               8B 41 0C 50 8B 08                    ; the 6 displaced bytes
//               E9 <rel32 -> wrapper+6>
//
// pushad/popad give the original code every register exactly as the caller left it (ecx = the
// renderer), so the game's EndScene runs once, with its own `this`, and its eax comes back
// unchanged; esp is balanced. With dispatch == null the hook is a pure pass-through. Handing the
// frame between modules is one aligned 4-byte store into `dispatch`.
//
// ABI and revisions (the rules every future copy of this file keeps):
//   * The ABI is 2 forever: mapping Local\FFXiUiHook_v2_<pid>, always UIHOOK_MAP_BYTES (4096) bytes,
//     mapped whole. There can only be one patch of the wrapper, so an incompatible UiHook could never
//     coexist; everything after this is a revision (UIHOOK_REV, from 1) within ABI 2.
//   * FROZEN at nui 1.0.0 (2026-10-19): ABI 2 revision 1 as test/frozen/layout_uihook.1.0.0.txt
//     records it (test/frozen_check.py fails any change that is not an appended field).
//   * Every offset in test/layout_uihook.txt is frozen. New fields go only into the
//     reserved tails (UiBus::reserved_hdr, UiClient::reserved) or after UiBus::status, and zero must
//     mean "old behaviour" (the mapping starts zeroed).
//   * The frame is driven by the dispatcher of the live client with the highest revision: a newer
//     module takes it on register; on unregister it passes to the highest-revision survivor (ties: the
//     lowest slot), or to nobody. A dispatcher of any revision calls every live, enabled client's
//     draw with the frozen signature below; that is the whole compatibility contract.
//   * Joining needs only hook_installed: a module whose own signature check fails (an older module
//     after a client update that only a newer module knows) joins once any module has patched. A host
//     retries uihook_join on a slow timer (UIHOOK_RETRY_MS) while it returns UIHOOK_JOIN_RETRY.
//   * A pre-release ABI 1 patch already present (the wrapper jumps into a thunk with this exact shape
//     that is not this bus's) is never patched over: UIHOOK_BLOCKED, a status line, nothing drawn.
//
// Each module compiles its own dispatcher (an inline function, so one copy per DLL). A module must
// leave in DllMain(DLL_PROCESS_DETACH) with uihook_unregister(bus, slot, false), which hands the frame
// on before its code unmaps. As defence in depth, a dispatcher skips (and frees) a client whose draw
// function is no longer inside its module's mapped image, and a register replaces an owner whose
// dispatcher is no longer mapped. Residual (as SceneHook): a module unmapped while it owns the frame
// without its DllMain running (process teardown only) leaves the thunk calling unmapped code until
// the next register.
//
// UIHOOK_FAULT_* and UIHOOK_TEST_* are for test only (deliberately broken builds that the
// tests must catch). Never define them in a module that ships.

#ifndef UIHOOK_H
#define UIHOOK_H

#include <windows.h>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>

#define UIHOOK_ABI_VERSION 2u              // never changes again
#ifndef UIHOOK_REV
#define UIHOOK_REV 1                       // this file's revision within ABI 2 (tests override it)
#endif
#define UIHOOK_MAX_CLIENTS 32
#define UIHOOK_MAP_BYTES 4096u
#define UIHOOK_MAP_NAME_FMT "Local\\FFXiUiHook_v2_%lu"
#define UIHOOK_RETRY_MS 5000               // how often a host retries uihook_join after UIHOOK_JOIN_RETRY
#define UIHOOK_DRAIN_MS 100                // unregister(may_wait) of the driver: longest wait for the frame to move on

// uihook_state()
#define UIHOOK_LIVE 0                      // the wrapper is patched by this bus: register works
#define UIHOOK_WAIT 1                      // not patched yet (no module found the wrapper): retry later
#define UIHOOK_BLOCKED 2                   // an ABI 1 pre-release patch holds the wrapper: never in this process
#define UIHOOK_NO_BUS 3

// uihook_join() results below zero
#define UIHOOK_JOIN_RETRY (-1)
#define UIHOOK_JOIN_BLOCKED (-2)
#define UIHOOK_JOIN_FULL (-3)
#define UIHOOK_JOIN_NO_BUS (-4)

static_assert(sizeof(void*) == 4, "UiHook targets 32-bit FFXI");

// FFXI's render thread does not guarantee a 16-byte aligned stack; GCC builds fault on SSE spills
// without realignment. Put it on draw callbacks too.
#if defined(__GNUC__)
#define UIHOOK_ALIGN_STACK __attribute__((force_align_arg_pointer))
#else
#define UIHOOK_ALIGN_STACK
#endif

// Frozen forever. device = [renderer + 0x0C] read with a guarded read, or null.
typedef void(__cdecl* uihook_draw_fn)(void* user, void* renderer, void* device);
typedef void(__cdecl* uihook_dispatch_fn)(void* renderer);

// 64 bytes; offsets frozen (test/layout_uihook.txt).
struct UiClient {
    volatile LONG occupied;          // 0 free, 1 being filled in, 2 live. Only 2 is dispatched.
    volatile LONG enabled;
    uihook_draw_fn draw;
    uihook_dispatch_fn dispatch;     // this client's module's dispatcher
    void* user;
#ifndef UIHOOK_FAULT_LAYOUT_SWAP
    unsigned long rev;               // UIHOOK_REV the module was built with
    long order;                      // draw order hint, 0 = by slot (rev 1 dispatchers ignore it)
#else
    long order;
    unsigned long rev;
#endif
    HMODULE module;                  // the module that registered: liveness checks and status
    char name[16];                   // "chronicle", "myaddon": status only
    volatile LONG const* nonce_at;   // a variable in the module's image holding `nonce` while it is loaded:
    LONG nonce;                      // a module unloaded and another mapped at the same base fails it
    unsigned char reserved[8];       // append here; zero = old behaviour
};

// 4096 bytes mapped; offsets frozen (ready, abi_version, size at 0, 4, 8 and every other field).
struct UiBus {
    volatile LONG ready;
    unsigned long abi_version;       // 2
    unsigned long size;              // the largest sizeof(UiBus) of any module attached
    volatile LONG install_lock;
    volatile LONG hook_installed;
    volatile LONG owner_slot;        // -1 when dispatch is null
    volatile LONG in_flight;
    volatile LONG installs;          // times the wrapper was patched in this process (0 or 1)
    volatile LONG dispatches;        // dispatcher entries (wrapper calls while someone listened)
    unsigned char* block;            // never freed
    void* volatile* dispatch_ptr;    // == block
    std::uintptr_t site;             // the patched wrapper
    volatile LONG owner_rev;         // rev of the dispatcher installed in *dispatch_ptr, 0 = none
    volatile LONG reg_lock;          // thread id holding register/unregister/handover, 0 = free
    volatile LONG handovers;         // times *dispatch_ptr changed hands
    volatile LONG reclaimed;         // dead clients freed by a dispatcher
    volatile LONG blocked;           // 1: an ABI 1 pre-release patch holds the wrapper
    std::uintptr_t foreign_site;     // where that patch is
    volatile LONG lock_breaks;       // reg_lock taken over after a timeout
    volatile LONG serial;            // source of module nonces
    unsigned char reserved_hdr[48];  // append here; zero = old behaviour
    UiClient clients[UIHOOK_MAX_CLIENTS];
    char status[192];                // the last install event: "hook installed at ..", why not, ..
    // append here only
};

static_assert(sizeof(UiClient) == 64, "UiClient is 64 bytes forever");
static_assert(offsetof(UiBus, clients) == 128, "UiBus header is 128 bytes");
static_assert(sizeof(UiBus) <= UIHOOK_MAP_BYTES, "UiBus must fit the fixed mapping");

namespace uihook_detail {

inline UiBus*& cached_bus() { static UiBus* value = nullptr; return value; }

constexpr std::size_t kSigBytes = 16;
constexpr unsigned char kWrapperSig[kSigBytes] = {
    0x8B, 0x41, 0x0C, 0x50, 0x8B, 0x08, 0xFF, 0x91, 0x8C, 0x00, 0x00, 0x00, 0xC3, 0x90, 0x90, 0x90,
};
constexpr std::size_t kDisplaced = 6;    // mov eax,[ecx+0Ch] / push eax / mov ecx,[eax]
constexpr std::size_t kThunkAt = 16;
constexpr std::size_t kBlockBytes = 64;
constexpr std::size_t kThunkBytes = 2 + 4 + 11 + kDisplaced + 5;    // 28
constexpr std::size_t kPatchBytes = 8;   // bytes 0..7 written at once: the 6 patched ones and 6..7 unchanged

// review HOOK-1: the patch is one locked 8-byte compare-and-exchange of bytes 0..7 (cmpxchg8b), so a
// thread fetching the wrapper sees either the original instructions or the whole jump, never an E9
// with a stale rel32. The wrapper is 16-byte aligned, so the 8 bytes sit in one cache line. Bytes 6..7
// (FF 91, the start of the EndScene call) are written back unchanged. False when the site no longer
// holds `expect` (nothing written). A thread already past byte 0 inside the first three original
// instructions when the patch lands (preempted at site+3 or site+4, a window of a few instructions
// once per process) would resume inside the new jump; no write order can prevent that without
// suspending every thread, and the risk is accepted.
inline bool write_site(std::uintptr_t site, unsigned char const* want, unsigned char const* expect) {
#ifdef UIHOOK_FAULT_SPLIT_PATCH
    volatile unsigned char* p = reinterpret_cast<volatile unsigned char*>(site);   // three stores, as before 1.2.6
    if (std::memcmp(const_cast<unsigned char const*>(p), expect, kPatchBytes) != 0) return false;
    p[0] = want[0];
    for (int i = 1; i < 5; ++i) p[i] = want[i];
    p[5] = want[5];
    return true;
#else
    LONGLONG old_v = 0, new_v = 0;
    std::memcpy(&old_v, expect, kPatchBytes);
    std::memcpy(&new_v, want, kPatchBytes);
    return InterlockedCompareExchange64(reinterpret_cast<LONGLONG volatile*>(site), new_v, old_v) == old_v;
#endif
}

inline bool page_readable(DWORD protect) {
    if (protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
    switch (protect & 0xFF) {
    case PAGE_READONLY: case PAGE_READWRITE: case PAGE_WRITECOPY:
    case PAGE_EXECUTE_READ: case PAGE_EXECUTE_READWRITE: case PAGE_EXECUTE_WRITECOPY:
        return true;
    default:
        return false;
    }
}

inline bool page_executable(DWORD protect) {
    if (protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
    switch (protect & 0xFF) {
    case PAGE_EXECUTE: case PAGE_EXECUTE_READ: case PAGE_EXECUTE_READWRITE: case PAGE_EXECUTE_WRITECOPY:
        return true;
    default:
        return false;
    }
}

inline bool span_readable(std::uintptr_t address, std::size_t size) {
    if (address == 0 || size == 0) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(reinterpret_cast<void const*>(address), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || !page_readable(region.Protect)) return false;
    std::uintptr_t const low = reinterpret_cast<std::uintptr_t>(region.BaseAddress);
    return address >= low && address + size <= low + region.RegionSize;
}

// Is `code` executable code inside a mapped image, and inside `module`'s image when module is known?
// VirtualQuery only: no loader lock, so it is safe on the render thread and in DllMain.
inline bool code_in_module(void const* code, HMODULE module) {
    if (!code) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(code, &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || region.Type != MEM_IMAGE || !page_executable(region.Protect)) return false;
    return !module || region.AllocationBase == reinterpret_cast<void*>(module);
}

// Is `module` still mapped at that address (its headers' region is part of an image whose
// allocation starts there)?
inline bool module_mapped(HMODULE module) {
    MEMORY_BASIC_INFORMATION region {};
    if (!module || !VirtualQuery(module, &region, sizeof(region))) return false;
    return region.State == MEM_COMMIT && region.Type == MEM_IMAGE && region.AllocationBase == reinterpret_cast<void*>(module);
}

// This module's load nonce (one per DLL: an inline function's static), set on its first register.
inline volatile LONG& module_nonce() { static volatile LONG value = 0; return value; }

// The thread that last entered this module's dispatcher (one per DLL), for uihook_unregister's drain.
inline volatile DWORD& last_dispatch_tid() { static volatile DWORD value = 0; return value; }

// Is the module that wrote this record still the one mapped at c.module? Its image must be mapped
// there and its nonce variable must still hold the record's nonce (a different module loaded at the
// same base has its own nonce, or none).
inline bool module_alive(UiClient const& c) {
    if (!c.module) return true;                      // never written by ABI 2: judged by its code alone
    if (!module_mapped(c.module)) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!c.nonce_at || !VirtualQuery(const_cast<LONG const*>(c.nonce_at), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || region.Type != MEM_IMAGE || !page_readable(region.Protect)
        || region.AllocationBase != reinterpret_cast<void*>(c.module))
        return false;
    return *c.nonce_at == c.nonce;
}

// Is a client alive: its module still loaded, and `draw` executable image code (in that module or
// any other still-mapped one: a host may register a callback from elsewhere).
inline bool client_alive(UiClient const& c, void const* draw) {
    return module_alive(c) && code_in_module(draw, nullptr);
}

// The module this copy of the header was compiled into.
inline HMODULE self_module();

// Call fn(address) for every match of sig in [begin, end), walking contiguous runs of committed
// readable pages (a VirtualProtect inside the module splits regions; never test a whole section).
template <typename Fn>
inline void scan_each(std::uintptr_t begin, std::uintptr_t end, unsigned char const* sig, std::size_t n, Fn&& fn) {
    std::uintptr_t address = begin;
    while (address < end) {
        MEMORY_BASIC_INFORMATION region {};
        if (!VirtualQuery(reinterpret_cast<void const*>(address), &region, sizeof(region))) break;
        std::uintptr_t const region_end = reinterpret_cast<std::uintptr_t>(region.BaseAddress) + region.RegionSize;
        if (region_end <= address) break;
        if (region.State != MEM_COMMIT || !page_readable(region.Protect)) { address = region_end; continue; }
        std::uintptr_t run_end = region_end;
        while (run_end < end) {
            MEMORY_BASIC_INFORMATION next {};
            if (!VirtualQuery(reinterpret_cast<void const*>(run_end), &next, sizeof(next))
                || next.State != MEM_COMMIT || !page_readable(next.Protect)) break;
            std::uintptr_t const next_end = reinterpret_cast<std::uintptr_t>(next.BaseAddress) + next.RegionSize;
            if (next_end <= run_end) break;
            run_end = next_end;
        }
        std::uintptr_t const limit = run_end < end ? run_end : end;
        auto const* bytes = reinterpret_cast<unsigned char const*>(address);
        for (std::size_t off = 0; address + off + n <= limit; ++off) {
            if (bytes[off] == sig[0] && std::memcmp(bytes + off, sig, n) == 0) fn(address + off);
        }
        address = run_end;
    }
}

// Count matches of sig in [begin, end); *first = the first one.
inline int scan_count(std::uintptr_t begin, std::uintptr_t end, unsigned char const* sig, std::size_t n,
                      std::uintptr_t* first) {
    int count = 0;
    scan_each(begin, end, sig, n, [&](std::uintptr_t at) {
        if (count == 0 && first) *first = at;
        ++count;
    });
    return count;
}

// fn(begin, end) for every executable section of the loaded FFXiMain.dll. False (and *reason) when
// it is not loaded or its headers are unreadable.
template <typename Fn>
inline bool for_each_code_section(char const** reason, Fn&& fn) {
    if (reason) *reason = "FFXiMain.dll is not loaded";
    HMODULE module = GetModuleHandleA("FFXiMain.dll");
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
    for (unsigned i = 0; i < nt->FileHeader.NumberOfSections; ++i, ++section) {
        if ((section->Characteristics & IMAGE_SCN_MEM_EXECUTE) == 0) continue;
        std::uintptr_t const start = base + section->VirtualAddress;
        fn(start, start + section->Misc.VirtualSize);
    }
    return true;
}

// The wrapper's address, or 0 with *reason set. `simulate_missing` scans for the signature with
// its last byte changed, so the real not-found path runs (the in-game fail-closed test).
inline std::uintptr_t find_wrapper(bool simulate_missing, char const** reason) {
#ifdef UIHOOK_TEST_SIG_BLIND
    simulate_missing = true;             // a module that does not know this client's wrapper
#endif
    unsigned char sig[kSigBytes];
    std::memcpy(sig, kWrapperSig, kSigBytes);
    if (simulate_missing) sig[kSigBytes - 1] = 0xCC;

    int count = 0;
    std::uintptr_t hit = 0;
    if (!for_each_code_section(reason, [&](std::uintptr_t begin, std::uintptr_t end) {
            std::uintptr_t first = 0;
            int const c = scan_count(begin, end, sig, kSigBytes, &first);
            if (c > 0 && count == 0) hit = first;
            count += c;
        }))
        return 0;
    if (count == 1) return hit;
    if (reason) {
        *reason = count == 0
            ? (simulate_missing ? "EndScene wrapper signature not found (simulated)"
                                : "EndScene wrapper signature not found (client update, or patched by another tool)")
            : "EndScene wrapper signature is not unique";
    }
    return 0;
}

// The thunk bytes for a block at `block` and a wrapper at `site` (kThunkBytes, written at block+16).
inline void thunk_bytes(std::uintptr_t block, std::uintptr_t site, unsigned char* t) {
    auto const slot = static_cast<std::uint32_t>(block);
    t[0] = 0x60;
    t[1] = 0xA1;
    std::memcpy(t + 2, &slot, 4);
    unsigned char const call[] = {0x85, 0xC0, 0x74, 0x06, 0x51, 0xFF, 0xD0, 0x83, 0xC4, 0x04, 0x61};
    std::memcpy(t + 6, call, sizeof(call));
    unsigned char* const tail = t + 6 + sizeof(call);
    std::memcpy(tail, kWrapperSig, kDisplaced);
    tail[kDisplaced] = 0xE9;
    std::uintptr_t const tail_at = block + kThunkAt + 6 + sizeof(call);
    std::int32_t const back = static_cast<std::int32_t>((site + kDisplaced) - (tail_at + kDisplaced + 5));
    std::memcpy(tail + kDisplaced + 1, &back, 4);
}

// A UiHook-shaped patch on the wrapper (any ABI: the thunk has had this shape since ABI 1):
// `E9 rel32 90` followed by the wrapper's own bytes 6..15, jumping to exactly the thunk above.
// Returns the site and *block_out, or 0 (also when there is more than one).
inline std::uintptr_t find_uihook_patch(std::uintptr_t* block_out) {
    std::uintptr_t found = 0, found_block = 0;
    int count = 0;
    char const* reason = "";
    for_each_code_section(&reason, [&](std::uintptr_t begin, std::uintptr_t end) {
        scan_each(begin, end, kWrapperSig + kDisplaced, kSigBytes - kDisplaced, [&](std::uintptr_t tail) {
            std::uintptr_t const site = tail - kDisplaced;
            if (site < begin || !span_readable(site, kSigBytes)) return;
            auto const* p = reinterpret_cast<unsigned char const*>(site);
            if (p[0] != 0xE9 || p[5] != 0x90) return;
            std::int32_t rel = 0;
            std::memcpy(&rel, p + 1, 4);
            std::uintptr_t const thunk = site + 5 + static_cast<std::uintptr_t>(static_cast<std::intptr_t>(rel));
            std::uintptr_t const block = thunk - kThunkAt;
            if (!span_readable(block, kThunkAt + kThunkBytes)) return;
            unsigned char want[kThunkBytes];
            thunk_bytes(block, site, want);
            if (std::memcmp(reinterpret_cast<void const*>(thunk), want, kThunkBytes) != 0) return;
            if (count == 0) { found = site; found_block = block; }
            ++count;
        });
    });
    if (count != 1) return 0;
    if (block_out) *block_out = found_block;
    return found;
}

// Take the register/handover lock: up to about 50 ms, then break it (a holder cannot legitimately
// keep it that long: it only edits a few records). `wait` false = one try only (the render thread).
inline bool reg_lock(UiBus* bus, bool wait) {
    LONG const me = static_cast<LONG>(GetCurrentThreadId());
    DWORD const start = GetTickCount();
    for (;;) {
        if (InterlockedCompareExchange(&bus->reg_lock, me, 0) == 0) return true;
        if (!wait) return false;
        if (GetTickCount() - start > 50) {
#ifdef UIHOOK_FAULT_NO_LOCK_BREAK
            return true;                             // proceeds without the lock, the stale token stays
#endif
            LONG const held = InterlockedCompareExchange(&bus->reg_lock, 0, 0);
            if (held != 0 && InterlockedCompareExchange(&bus->reg_lock, me, held) == held) {
                InterlockedIncrement(&bus->lock_breaks);
                return true;
            }
        }
        Sleep(0);
    }
}

inline void reg_unlock(UiBus* bus) { InterlockedExchange(&bus->reg_lock, 0); }

inline void clear_client(UiClient& c) {
    InterlockedExchange(&c.enabled, 0);
    c.draw = nullptr;
    c.dispatch = nullptr;
    c.user = nullptr;
    c.rev = 0;
    c.order = 0;
    c.module = nullptr;
    c.nonce_at = nullptr;
    c.nonce = 0;
    std::memset(c.name, 0, sizeof(c.name));
    MemoryBarrier();
    InterlockedExchange(&c.occupied, 0);
}

// Can this client's dispatcher drive the frame? (live, and its dispatcher still mapped)
inline bool can_own(UiClient const& c) {
    return c.occupied == 2 && c.dispatch && module_alive(c)
        && code_in_module(reinterpret_cast<void const*>(c.dispatch), c.module);
}

inline void set_owner(UiBus* bus, int slot) {
    void* const next = slot >= 0 ? reinterpret_cast<void*>(bus->clients[slot].dispatch) : nullptr;
    if (*bus->dispatch_ptr != next) InterlockedIncrement(&bus->handovers);
    *bus->dispatch_ptr = next;                       // one aligned store: the frame changes hands here
    InterlockedExchange(&bus->owner_rev, slot >= 0 ? static_cast<LONG>(bus->clients[slot].rev) : 0);
    InterlockedExchange(&bus->owner_slot, slot);
}

// Hand the frame to the live client with the highest revision other than `leaving` (ties: the
// lowest slot), or to nobody (pass-through). Caller holds reg_lock.
inline void reassign_owner(UiBus* bus, int leaving) {
    if (!bus || !bus->dispatch_ptr) return;
    int best = -1;
    for (int i = 0; i < UIHOOK_MAX_CLIENTS; ++i) {
        if (i == leaving) continue;
        UiClient const& c = bus->clients[i];
        if (!can_own(c)) continue;
#ifdef UIHOOK_FAULT_HANDOVER_FIRST
        best = i;
        break;
#else
        if (best < 0 || c.rev > bus->clients[best].rev) best = i;
#endif
    }
    set_owner(bus, best);
}

// The dispatcher just found client i dead (its module unmapped without unregistering): free it.
inline void reclaim_dead(UiBus* bus, int i) {
    if (!reg_lock(bus, false)) return;                // busy: skip it this frame, try next frame
    UiClient& c = bus->clients[i];
    if (c.occupied == 2 && !client_alive(c, reinterpret_cast<void const*>(c.draw)) && bus->owner_slot != i) {
        clear_client(c);
        InterlockedIncrement(&bus->reclaimed);
    }
    reg_unlock(bus);
}

// The dispatcher: one copy per module. Entered from the thunk on the render thread.
inline void UIHOOK_ALIGN_STACK __cdecl dispatch(void* renderer) {
    UiBus* bus = cached_bus();
    if (!bus) return;
    InterlockedIncrement(&bus->in_flight);
    InterlockedIncrement(&bus->dispatches);
    last_dispatch_tid() = GetCurrentThreadId();
    void* device = nullptr;
    std::uintptr_t const at = reinterpret_cast<std::uintptr_t>(renderer) + 0x0C;
    if (renderer && span_readable(at, 4)) std::memcpy(&device, reinterpret_cast<void const*>(at), 4);
    for (int i = 0; i < UIHOOK_MAX_CLIENTS; ++i) {
        UiClient& c = bus->clients[i];
        if (c.occupied != 2 || !c.enabled) continue;
        uihook_draw_fn const draw = c.draw;
        if (!draw) continue;
#ifdef UIHOOK_FAULT_SKIP_FOREIGN
        if (c.dispatch != &dispatch) continue;
#endif
#ifndef UIHOOK_FAULT_NO_LIVENESS
        if (!client_alive(c, reinterpret_cast<void const*>(draw))) { reclaim_dead(bus, i); continue; }
#endif
        draw(c.user, renderer, device);      // each client restores the device state it changes
    }
    InterlockedDecrement(&bus->in_flight);
}

inline HMODULE self_module() {
    HMODULE m = nullptr;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       reinterpret_cast<LPCSTR>(&dispatch), &m);
    return m;
}

}  // namespace uihook_detail

// Attach to the process-wide bus, creating it on first use. Null if the mapping fails or the bus is
// not a UiHook 2 bus. The mapping and view are leaked on purpose: they belong to the process, so the
// hook outlives every module.
inline UiBus* uihook_attach() {
    UiBus*& cached = uihook_detail::cached_bus();
    if (cached) return cached;
    char name[64];
    std::snprintf(name, sizeof(name), UIHOOK_MAP_NAME_FMT, static_cast<unsigned long>(GetCurrentProcessId()));
    HANDLE mapping = CreateFileMappingA(INVALID_HANDLE_VALUE, nullptr, PAGE_READWRITE, 0, UIHOOK_MAP_BYTES, name);
    if (!mapping) return nullptr;
    bool const existed = GetLastError() == ERROR_ALREADY_EXISTS;
    auto* bus = static_cast<UiBus*>(MapViewOfFile(mapping, FILE_MAP_ALL_ACCESS, 0, 0, UIHOOK_MAP_BYTES));
    if (!bus) { CloseHandle(mapping); return nullptr; }
    if (!existed) {
        bus->abi_version = UIHOOK_ABI_VERSION;
        bus->size = sizeof(UiBus);
        bus->owner_slot = -1;
        std::snprintf(bus->status, sizeof(bus->status), "bus created");
        MemoryBarrier();
        InterlockedExchange(&bus->ready, 1);
    } else {
        for (int spin = 0; spin < 2000 && InterlockedCompareExchange(&bus->ready, 0, 0) == 0; ++spin) Sleep(1);
        if (InterlockedCompareExchange(&bus->ready, 0, 0) == 0) { UnmapViewOfFile(bus); CloseHandle(mapping); return nullptr; }
    }
    // any revision of ABI 2 is welcome: older creators leave our appended fields zero, newer ones
    // have fields we never read
    if (bus->abi_version != UIHOOK_ABI_VERSION || bus->size < offsetof(UiBus, status) + sizeof(bus->status)
        || bus->size > UIHOOK_MAP_BYTES) {
        UnmapViewOfFile(bus);
        CloseHandle(mapping);
        return nullptr;
    }
    for (;;) {
        LONG const seen = static_cast<LONG>(bus->size);
        if (seen >= static_cast<LONG>(sizeof(UiBus))) break;
        if (InterlockedCompareExchange(reinterpret_cast<volatile LONG*>(&bus->size), sizeof(UiBus), seen) == seen) break;
    }
    cached = bus;
    return bus;
}

inline int uihook_state(UiBus const* bus) {
    if (!bus) return UIHOOK_NO_BUS;
    if (bus->hook_installed) return UIHOOK_LIVE;
    if (bus->blocked) return UIHOOK_BLOCKED;
    return UIHOOK_WAIT;
}

// Patch the wrapper if nobody has yet. Safe from every module on every load; only the first call
// that finds the wrapper patches. True when the patch is live, whoever wrote it: a module that
// cannot find the wrapper itself still joins once another module has patched (retry later on
// false, unless uihook_state says UIHOOK_BLOCKED). With simulate_missing it always fails, through
// the real not-found path, and never patches (the in-game fail-closed test). `who` names the
// patcher in the status line.
inline bool uihook_ensure_hook(UiBus* bus, bool simulate_missing = false, char const* who = nullptr) {
    using namespace uihook_detail;
    if (!bus) return false;
    if (simulate_missing) {
        char const* reason = "";
        find_wrapper(true, &reason);
        std::snprintf(bus->status, sizeof(bus->status), "%s", reason);
        return false;
    }
#ifndef UIHOOK_FAULT_SCAN_FIRST
    if (InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0) return true;
#endif
    if (InterlockedCompareExchange(&bus->blocked, 0, 0) != 0) return false;
    if (InterlockedCompareExchange(&bus->install_lock, 1, 0) != 0) {
        for (int spin = 0; spin < 2000 && InterlockedCompareExchange(&bus->hook_installed, 0, 0) == 0; ++spin) Sleep(1);
        return InterlockedCompareExchange(&bus->hook_installed, 0, 0) != 0;
    }
    char const* reason = "EndScene wrapper not found";
    std::uintptr_t const site = find_wrapper(false, &reason);
    if (site == 0) {
#ifndef UIHOOK_FAULT_NO_ABI1_CHECK
        std::uintptr_t block = 0;
        std::uintptr_t const other = find_uihook_patch(&block);
        if (other && reinterpret_cast<unsigned char*>(block) != bus->block) {
            // not ours (ours sets hook_installed): a pre-release ABI 1 module patched first
            bus->foreign_site = other;
            InterlockedExchange(&bus->blocked, 1);
            std::snprintf(bus->status, sizeof(bus->status),
                          "an older pre-release UiHook (ABI 1) holds the hook: rebuild the other module");
            InterlockedExchange(&bus->install_lock, 0);
            return false;
        }
#endif
        std::snprintf(bus->status, sizeof(bus->status), "%s", reason);
        InterlockedExchange(&bus->install_lock, 0);
        return false;
    }
    auto* block = static_cast<unsigned char*>(VirtualAlloc(nullptr, kBlockBytes, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE));
    if (!block) {
        std::snprintf(bus->status, sizeof(bus->status), "hook block alloc failed");
        InterlockedExchange(&bus->install_lock, 0);
        return false;
    }
    std::memset(block, 0xCC, kBlockBytes);
    std::memset(block, 0, 4);                                        // dispatch = null
    unsigned char* t = block + kThunkAt;
    thunk_bytes(reinterpret_cast<std::uintptr_t>(block), site, t);
    FlushInstructionCache(GetCurrentProcess(), block, kBlockBytes);

    bus->block = block;
    bus->dispatch_ptr = reinterpret_cast<void* volatile*>(block);
    bus->site = site;
    MemoryBarrier();

    DWORD previous = 0;
    if (!VirtualProtect(reinterpret_cast<void*>(site), kPatchBytes, PAGE_EXECUTE_READWRITE, &previous)) {
        std::snprintf(bus->status, sizeof(bus->status), "VirtualProtect failed");
        bus->block = nullptr;
        bus->dispatch_ptr = nullptr;
        bus->site = 0;
        VirtualFree(block, 0, MEM_RELEASE);
        InterlockedExchange(&bus->install_lock, 0);
        return false;
    }
    std::int32_t const to_thunk = static_cast<std::int32_t>(reinterpret_cast<std::uintptr_t>(t) - (site + 5));
    unsigned char want[kPatchBytes];
    want[0] = 0xE9;
    std::memcpy(want + 1, &to_thunk, 4);
    want[5] = 0x90;
    std::memcpy(want + kDisplaced, kWrapperSig + kDisplaced, kPatchBytes - kDisplaced);
    bool const wrote = write_site(site, want, kWrapperSig);
    VirtualProtect(reinterpret_cast<void*>(site), kPatchBytes, previous, &previous);
    FlushInstructionCache(GetCurrentProcess(), reinterpret_cast<void*>(site), kPatchBytes);
    if (!wrote) {                                    // the bytes changed under us: never patch over them
        std::snprintf(bus->status, sizeof(bus->status), "EndScene wrapper changed while patching");
        bus->block = nullptr;
        bus->dispatch_ptr = nullptr;
        bus->site = 0;
        VirtualFree(block, 0, MEM_RELEASE);
        InterlockedExchange(&bus->install_lock, 0);
        return false;
    }

    InterlockedIncrement(&bus->installs);
    std::snprintf(bus->status, sizeof(bus->status), "hook installed at %p by %s (rev %d)", reinterpret_cast<void*>(site),
                  who && *who ? who : "?", UIHOOK_REV);
    InterlockedExchange(&bus->hook_installed, 1);
    InterlockedExchange(&bus->install_lock, 0);
    return true;
}

// A slot index, or -1 (not hooked yet, or full). `name` (up to 15 chars) is for status only;
// `order` is a draw order hint for later revisions (rev 1 draws by slot). The frame goes to this
// module when nobody drives it, when this module's revision is higher than the driver's, or when the
// driver's dispatcher is no longer mapped.
inline int uihook_register(UiBus* bus, uihook_draw_fn draw, void* user, char const* name = nullptr, long order = 0) {
    using namespace uihook_detail;
    if (!bus || !draw || !bus->dispatch_ptr || !InterlockedCompareExchange(&bus->hook_installed, 0, 0)) return -1;
    HMODULE const self = self_module();
    volatile LONG& nonce = module_nonce();
    while (nonce == 0) {
        LARGE_INTEGER t {};
        QueryPerformanceCounter(&t);
        InterlockedCompareExchange(&nonce, static_cast<LONG>((InterlockedIncrement(&bus->serial) << 20) ^ t.LowPart), 0);
    }
    reg_lock(bus, true);
    int slot = -1;
    for (int i = 0; i < UIHOOK_MAX_CLIENTS; ++i) {
        if (InterlockedCompareExchange(&bus->clients[i].occupied, 1, 0) != 0) continue;
        UiClient& c = bus->clients[i];
        c.draw = draw;
        c.dispatch = &dispatch;
        c.user = user;
        c.rev = UIHOOK_REV;
        c.order = order;
        c.module = self;
        c.nonce_at = &nonce;
        c.nonce = nonce;
        std::memset(c.name, 0, sizeof(c.name));
        if (name) std::strncpy(c.name, name, sizeof(c.name) - 1);
        InterlockedExchange(&c.enabled, 1);
        MemoryBarrier();
        InterlockedExchange(&c.occupied, 2);
        slot = i;
        break;
    }
    if (slot >= 0) {
        LONG const owner = InterlockedCompareExchange(&bus->owner_slot, 0, 0);
        bool take = owner < 0 || owner >= UIHOOK_MAX_CLIENTS;
        if (!take) {
            UiClient const& o = bus->clients[owner];
            // the driver must be a live client whose dispatcher is the one installed, still mapped
            take = !can_own(o) || reinterpret_cast<void*>(o.dispatch) != *bus->dispatch_ptr;
        }
#ifndef UIHOOK_FAULT_NO_REV_TAKEOVER
        if (!take) take = static_cast<LONG>(UIHOOK_REV) > InterlockedCompareExchange(&bus->owner_rev, 0, 0);
#endif
        if (take) set_owner(bus, slot);
    }
    reg_unlock(bus);
    return slot;
}

// Leave the bus. Also call from DllMain(DLL_PROCESS_DETACH) with may_wait = false (loader lock).
// Only a slot this module registered is touched.
//
// may_wait (review HOOK-2): in_flight covers only the dispatcher's own body. When this module drove
// the frame, the render thread may still be in the thunk with this module's dispatcher loaded into
// eax (between `mov eax, [dispatch]` and the dispatcher's first increment), or in its prologue or
// epilogue, after the hand-over. So the driver also waits (at most UIHOOK_DRAIN_MS) until the
// dispatcher count has moved on by two: with one render thread, the second entry after the hand-over
// starts only once the thread has left any call that began before it. With nobody to hand to, the
// count never moves and the whole UIHOOK_DRAIN_MS passes. When the last frame ran on this very thread
// (offline harnesses draw on the Lua thread) no other thread can be inside, and nothing is waited for.
inline void uihook_unregister(UiBus* bus, int slot, bool may_wait) {
    using namespace uihook_detail;
    if (!bus || slot < 0 || slot >= UIHOOK_MAX_CLIENTS) return;
    UiClient& c = bus->clients[slot];
    if (c.dispatch != &dispatch) return;              // not ours (stale slot number): leave it alone
    reg_lock(bus, true);
    InterlockedExchange(&c.enabled, 0);
    bool const drove = InterlockedCompareExchange(&bus->owner_slot, 0, 0) == slot;
#ifndef UIHOOK_FAULT_NO_HANDOVER
    if (drove) reassign_owner(bus, slot);
#endif
    LONG const handed_at = InterlockedCompareExchange(&bus->dispatches, 0, 0);
    clear_client(c);
    reg_unlock(bus);
    if (may_wait) {
        for (int spin = 0; spin < 200 && InterlockedCompareExchange(&bus->in_flight, 0, 0) != 0; ++spin) Sleep(1);
#ifndef UIHOOK_FAULT_NO_DRAIN
        if (drove && last_dispatch_tid() != GetCurrentThreadId()) {
            DWORD const t0 = GetTickCount();
            while (InterlockedCompareExchange(&bus->dispatches, 0, 0) - handed_at < 2 && GetTickCount() - t0 < UIHOOK_DRAIN_MS)
                Sleep(1);
        }
#endif
    }
    (void)handed_at;
}

// Everything a module's start() needs once it has a bus: patch if nobody has, then register.
// A slot >= 0, or:
//   UIHOOK_JOIN_RETRY    not hooked yet (this module cannot find the wrapper, and no module has
//                        patched): call again every UIHOOK_RETRY_MS; bus->status says why
//   UIHOOK_JOIN_BLOCKED  an ABI 1 pre-release patch holds the wrapper: retrying cannot help
//   UIHOOK_JOIN_FULL     32 clients already
//   UIHOOK_JOIN_NO_BUS
inline int uihook_join(UiBus* bus, uihook_draw_fn draw, void* user, char const* name = nullptr, long order = 0,
                       bool simulate_missing = false) {
    if (!bus) return UIHOOK_JOIN_NO_BUS;
    if (!uihook_ensure_hook(bus, simulate_missing, name))
        return uihook_state(bus) == UIHOOK_BLOCKED ? UIHOOK_JOIN_BLOCKED : UIHOOK_JOIN_RETRY;
    int const slot = uihook_register(bus, draw, user, name, order);
    return slot >= 0 ? slot : UIHOOK_JOIN_FULL;
}

inline void uihook_set_enabled(UiBus* bus, int slot, bool enabled) {
    if (!bus || slot < 0 || slot >= UIHOOK_MAX_CLIENTS) return;
    InterlockedExchange(&bus->clients[slot].enabled, enabled ? 1 : 0);
}

inline int uihook_active_clients(UiBus const* bus) {
    if (!bus) return 0;
    int n = 0;
    for (int i = 0; i < UIHOOK_MAX_CLIENTS; ++i)
        if (bus->clients[i].occupied == 2 && bus->clients[i].enabled) ++n;
    return n;
}

// One line for a status display, e.g.
//   "live at 1000A740; 2 clients: chronicle r1, myaddon r2 (drives)"
//   "blocked: an older pre-release UiHook (ABI 1) holds the hook: rebuild ..."
//   "waiting: EndScene wrapper signature not found (...)"
inline void uihook_describe(UiBus const* bus, char* out, std::size_t n) {
    if (!out || n == 0) return;
    out[0] = 0;
    int const st = uihook_state(bus);
    if (st == UIHOOK_NO_BUS) { std::snprintf(out, n, "no bus"); return; }
    if (st != UIHOOK_LIVE) {
        std::snprintf(out, n, "%s: %s", st == UIHOOK_BLOCKED ? "blocked" : "waiting", bus->status);
        return;
    }
    std::size_t len = static_cast<std::size_t>(std::snprintf(out, n, "live at %08lX; %d clients",
                                                             static_cast<unsigned long>(bus->site),
                                                             uihook_active_clients(bus)));
    char const* sep = ": ";
    for (int i = 0; i < UIHOOK_MAX_CLIENTS && len < n; ++i) {
        UiClient const& c = bus->clients[i];
        if (c.occupied != 2) continue;
        char nm[17];
        std::memcpy(nm, c.name, 16);
        nm[16] = 0;
        len += static_cast<std::size_t>(std::snprintf(out + len, n - len, "%s%s r%lu%s%s", sep, nm[0] ? nm : "?",
                                                      static_cast<unsigned long>(c.rev),
                                                      bus->owner_slot == i ? " (drives)" : "",
                                                      c.enabled ? "" : " (off)"));
        sep = ", ";
    }
}

#endif  // UIHOOK_H
