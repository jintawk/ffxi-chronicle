// NuiCache.h - the per-process shared texture cache for native UI modules (nui design section C).
//
// Several addon DLLs that draw with the nui library each need the
// same window-type atlas, the same item icons and sometimes the same pictures. This header lets
// them hold ONE texture per thing instead of one per module.
//
// Mechanism: a per-process named mapping `Local\FFXiNuiCache_v<MAJOR>_<pid>` (64 KiB, created by
// the first module, handle and view leaked on purpose so it outlives every module) holds a header,
// 32 client records and 384 entry records. An entry is a key plus the cache's ONE COM reference to
// an object (an IDirect3DTexture8) that lives in d3d8 / dgVoodoo memory, not in any module, so any
// module can Release it through its vtable whichever module created it. Modules never AddRef; each
// marks what it uses with one holder bit (its client slot). Only plain integers and COM pointers
// enter the mapping, never a pointer into a module's image or heap.
//
// Threads: nc_frame/nc_acquire(NC_RENDER) on the render thread at the top of a module's draw;
// nc_start/nc_stop/nc_release (and nc_acquire(NC_LUA)) on the Lua thread; nc_detach from
// DllMain(DLL_PROCESS_DETACH) only, which does lock-free bit clears and nothing else.
//
// FROZEN at nui 1.0.0 (2026-10-19): major 1 revision 1 as test/frozen/layout_nuicache.1.0.0.txt
// records it, with the semantics below and in design section C.2 (test/frozen_check.py fails
// any change that is not an appended field).
// Every module of one MAJOR must build against a layout-identical copy (offsets frozen, checked by
// test/layout_nuicache.txt). Within a major, NUICACHE_REV may grow and fields may only be
// appended into reserved space with zero meaning "old behaviour". An incompatible change bumps the
// major, which changes the mapping name: two majors never share and both still draw. Any failure
// (no mapping, wrong magic/major/layout/policy, no client slot, table full, a lock timeout on the
// Lua thread, `noshare`) gives that module or texture the private path: nc_acquire creates the
// object itself and the module releases it, exactly as before the cache existed.
//
// Usage (one module):
//   nc_start("chronicle", "0.1.0", noshare);              // Lua thread, at start()
//   per draw:  switch (nc_frame(device)) {                 // render thread, before any cached use
//              case NC_FRAME_SKIP:  draw nothing this frame;
//              case NC_FRAME_RESET: nc_release() every ref (shared ones become no-ops), re-acquire;
//              case NC_FRAME_OK: }
//              nc_acquire(key, device, create_fn, ctx, "atlas t6", NC_RENDER, &ref);
//   nc_release(ref) when a handle is freed;  nc_stop() at stop();  nc_detach() in DllMain detach.
//   nui 1.2.1: nc_hold(key, &ref) on the Lua thread keeps an entry another module made (no decode,
//   no create) until this module's draw attaches the ref (if nc_gen() still equals ref.gen).
// The object in a shared ref is borrowed: never Release it yourself. A private ref (entry == -1)
// is owned by the module; nc_release releases it.

#ifndef NUICACHE_H
#define NUICACHE_H

#include <windows.h>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstring>

#ifndef NUICACHE_MAJOR
#define NUICACHE_MAJOR 1u
#endif
#ifndef NUICACHE_REV
#define NUICACHE_REV 1u
#endif
#ifndef NUICACHE_ENTRIES
#define NUICACHE_ENTRIES 384             // frozen in major 1; a test variant changes it to prove the fallback
#endif
#define NUICACHE_CLIENTS 32               // frozen: one holder bit per client in a LONG
#define NUICACHE_MAGIC 0x4349554Eu        // bytes 'N' 'U' 'I' 'C'
#define NUICACHE_MAP_SIZE 65536u
#define NUICACHE_GRACE_MS 10000u          // unheld entries live this long (a //lua reload finds its atlas)
#define NUICACHE_BUDGET (8u << 20)        // unheld bytes above this go at once, oldest first
#define NUICACHE_SWEEP_MS 16u
#define NUICACHE_RENDER_SPINS 2000u       // render thread: then give up for this frame
#define NUICACHE_LUA_WAIT_MS 50u          // Lua thread: then private fallback
#define NUICACHE_BACKOFF_MS 2000u         // after a failed create

// Test hooks (test): a shared clock, and a yield inside every critical section.
#ifndef NUICACHE_NOW
#define NUICACHE_NOW() GetTickCount()
#endif
#ifndef NUICACHE_TEST_YIELD
#define NUICACHE_TEST_YIELD() ((void)0)
#endif

static_assert(sizeof(void*) == 4, "NuiCache targets 32-bit FFXI");

// ---- frozen records (major 1) -------------------------------------------------------------------

struct NcHeader {                      // 256 bytes at offset 0
    std::uint32_t magic;               //   0
    volatile LONG ready;               //   4
    std::uint32_t major;               //   8
    std::uint32_t map_size;            //  12
    std::uint32_t creator_pid;         //  16
    volatile LONG max_rev;             //  20
    volatile LONG lock;                //  24  0 or the holder's client token
    volatile LONG lock_timeouts;       //  28
    void* volatile device;             //  32  device identity (C.5)
    volatile LONG gen;                 //  36  bumped when `device` changes
    volatile LONG pending;             //  40  unheld or stale entries may exist: sweep
    volatile LONG last_sweep_ms;       //  44
    std::uint32_t grace_ms;            //  48  policy, written once by the creator
    std::uint32_t unheld_budget;       //  52
    std::uint32_t client_cap;          //  56
    std::uint32_t client_stride;       //  60
    std::uint32_t clients_off;         //  64
    std::uint32_t entry_cap;           //  68
    std::uint32_t entry_stride;        //  72
    std::uint32_t entries_off;         //  76
#ifdef NUI_FAULT_LAYOUT                //  self-test only: two fields swapped
    volatile LONG hits;
    volatile LONG creates;
#else
    volatile LONG creates;             //  80  status counters from here
    volatile LONG hits;                //  84
#endif
    volatile LONG releases;            //  88
    volatile LONG fallbacks;           //  92
    volatile LONG live_bytes;          //  96
    volatile LONG unheld_bytes;        // 100
    volatile LONG lock_breaks;         // 104
    volatile LONG reclaims;            // 108  dead clients reclaimed by a sweep
    volatile LONG live_entries;        // 112
    unsigned char reserved[256 - 116];
};

struct NcClient {                      // 64 bytes x 32
    volatile LONG state;               //   0  0 free, 1 live, 2 being filled in
    volatile LONG serial;              //   4  bumped on each take of the slot (token, ABA)
    HMODULE module;                    //   8  liveness (mapped at that base: VirtualQuery)
    std::uint32_t rev;                 //  12
    char name[16];                     //  16  status only
    char version[16];                  //  32
    unsigned char reserved[16];        //  48
};

struct NcEntry {                       // 128 bytes x 384
    volatile LONG state;               //   0  0 free, 1 creating, 2 live, 3 releasing
    volatile LONG holders;             //   4  bit i = client slot i uses it
    volatile LONG creator;             //   8  client token while creating
    std::uint32_t kind;                //  12  key ...
    std::uint32_t fmt;                 //  16
    std::uint32_t a;                   //  20
    std::uint32_t b;                   //  24
    std::uint32_t hash_lo;             //  28
    std::uint32_t hash_hi;             //  32  ... key
    std::uint32_t obj_type;            //  36  1 = IUnknown-released (IDirect3DTexture8)
    void* obj;                         //  40  the cache's one reference
    void* device;                      //  44  created on
    std::uint32_t gen;                 //  48
    std::uint16_t w, h;                //  52, 54
    std::uint32_t bytes;               //  56
    volatile LONG last_used_ms;        //  60
    char label[32];                    //  64  "atlas t6", "icon 4165": status
    unsigned char reserved[32];        //  96
};

static_assert(sizeof(NcHeader) == 256, "NcHeader is frozen at 256 bytes");
static_assert(sizeof(NcClient) == 64, "NcClient is frozen at 64 bytes");
static_assert(sizeof(NcEntry) == 128, "NcEntry is frozen at 128 bytes");
static_assert(256 + 64 * NUICACHE_CLIENTS + 128 * 384 <= NUICACHE_MAP_SIZE, "records fit the reservation");

// ---- public types -------------------------------------------------------------------------------

enum NcKind : std::uint32_t { NC_ATLAS = 1, NC_ITEM_ICON = 2, NC_PICTURE = 3 };   // 4+ reserved (C.3)
enum NcThread { NC_RENDER = 0, NC_LUA = 1 };
enum NcResult { NC_FAILED = 0, NC_HIT = 1, NC_CREATED = 2, NC_PRIVATE = 3, NC_BUSY = 4 };
enum NcFrame { NC_FRAME_OK = 0, NC_FRAME_RESET = 1, NC_FRAME_SKIP = 2 };

struct NcKey {
    std::uint32_t kind, fmt, a, b;     // kind 1 ATLAS (a = window type), 2 ITEM_ICON (a = item id),
    std::uint64_t hash;                // 3 PICTURE (a, b = max w, h); hash = install dir or content
};

// What a create callback made. bytes = what the entry accounts for the budget (w * h * 4).
struct NcMade { std::uint16_t w, h; std::uint32_t bytes; };

// Creates the object with ONE reference (which the cache or the module then owns), or null.
// Called outside the cache lock. __cdecl, frozen.
typedef void*(__cdecl* nc_create_fn)(void* ctx, void* device, NcKey const* key, NcMade* made);

struct NcRef {
    void* obj;                         // null = nothing
    std::int32_t entry;                // >= 0 shared (borrowed obj), -1 private (owned obj)
    std::uint32_t gen;
    std::uint16_t w, h;
    std::uint32_t bytes;
};

struct NcStatus {
    int shared;                        // this module uses the shared cache
    char why[48];                      // why not, when private
    int slot;
    long gen, max_rev, clients;
    char client_names[NUICACHE_CLIENTS][36];   // "chronicle 0.1.0"
    long creates, hits, releases, fallbacks, live_entries, live_bytes, unheld_bytes;
    long lock_timeouts, lock_breaks, reclaims;
    long my_shared, my_private;        // refs this module holds
};

namespace nc_detail {

struct Local {                         // per module (one copy per DLL); zero = not started
    NcHeader* hdr;
    int slot;
    LONG token;
    LONG gen;
    void* device;                      // private mode: the device textures were made on
    bool started, noshare, device_seen;
    char why[48];
    volatile LONG mod_lock;            // this module's own bookkeeping (Lua vs render thread)
    LONG shared_refs, private_refs;
    DWORD backoff_until;
    bool backoff;
    // review HOOK-5: an object the render thread made but could not publish (the cache lock was busy
    // after the create). Its entry stays `creating` under this module's token, so nobody else makes
    // it, and the object is published at this module's next render-thread acquire instead of being
    // thrown away and made again.
    struct Unpublished { int entry; void* obj; NcMade made; LONG gen; void* device; } unpub;
    std::uint16_t count[NUICACHE_ENTRIES];     // my refs per entry
    LONG count_gen[NUICACHE_ENTRIES];          // gen those refs were taken in
};

inline Local& local() { static Local value; return value; }

inline DWORD now() { return static_cast<DWORD>(NUICACHE_NOW()); }

inline NcClient* clients(NcHeader* h) { return reinterpret_cast<NcClient*>(reinterpret_cast<char*>(h) + 256); }
inline NcEntry* entries(NcHeader* h) {
    return reinterpret_cast<NcEntry*>(reinterpret_cast<char*>(h) + 256 + 64 * NUICACHE_CLIENTS);
}

inline LONG atomic_and(volatile LONG* p, LONG mask) {
    LONG old = *p;
    for (;;) {
        LONG const seen = InterlockedCompareExchange(p, old & mask, old);
        if (seen == old) return old;
        old = seen;
    }
}
inline LONG atomic_or(volatile LONG* p, LONG bits) {
    LONG old = *p;
    for (;;) {
        LONG const seen = InterlockedCompareExchange(p, old | bits, old);
        if (seen == old) return old;
        old = seen;
    }
}
inline LONG load(volatile LONG const* p) { return InterlockedCompareExchange(const_cast<volatile LONG*>(p), 0, 0); }

inline void spin_mod(Local& L) {
    while (InterlockedCompareExchange(&L.mod_lock, 1, 0) != 0) Sleep(0);
}
inline void unspin_mod(Local& L) { InterlockedExchange(&L.mod_lock, 0); }

inline LONG make_token(int slot, LONG serial) { return static_cast<LONG>((static_cast<std::uint32_t>(serial) << 5) | std::uint32_t(slot)); }

inline bool token_live(NcHeader* h, LONG token) {
    if (token == 0) return false;
    int const slot = int(std::uint32_t(token) & 31u);
    NcClient& c = clients(h)[slot];
    return load(&c.state) == 1 && make_token(slot, load(&c.serial)) == token;
}

// The interlocked spinlock (C.6). Render: about 2,000 spins then give up for this frame. Lua: up
// to 50 ms with Sleep(0). A lock held by a token whose client slot is gone is broken by CAS.
inline bool lock(NcHeader* h, LONG token, NcThread th) {
#ifdef NUI_FAULT_NO_LOCK
    (void)h; (void)token; (void)th;
    return true;
#else
    if (InterlockedCompareExchange(&h->lock, token, 0) == 0) return true;
    DWORD const t0 = GetTickCount();
    for (std::uint32_t spin = 1;; ++spin) {
        LONG const cur = load(&h->lock);
        if (cur == 0) {
            if (InterlockedCompareExchange(&h->lock, token, 0) == 0) return true;
        } else if ((spin & 63u) == 0 && !token_live(h, cur)) {
            if (InterlockedCompareExchange(&h->lock, token, cur) == cur) {
                InterlockedIncrement(&h->lock_breaks);
                return true;
            }
        }
        if (th == NC_RENDER) {
            if (spin >= NUICACHE_RENDER_SPINS) break;
            YieldProcessor();
        } else {
            if (GetTickCount() - t0 >= NUICACHE_LUA_WAIT_MS) break;
            Sleep(0);
        }
    }
    InterlockedIncrement(&h->lock_timeouts);
    return false;
#endif
}

inline void unlock(NcHeader* h) {
#ifndef NUI_FAULT_LOCK_NEVER_RELEASED
    InterlockedExchange(&h->lock, 0);
#else
    (void)h;
#endif
}

// IUnknown::Release through the vtable (slot 2, __stdcall): the object's code lives in d3d8.
inline unsigned long com_release(void* obj) {
    typedef unsigned long(__stdcall * release_fn)(void*);
    release_fn const fn = (*reinterpret_cast<release_fn**>(obj))[2];
    unsigned long const r = fn(obj);
#ifdef NUI_FAULT_DOUBLE_RELEASE
    fn(obj);
#endif
    return r;
}

inline std::uint32_t key_fmt(NcKey const& k, int slot) {
#ifdef NUI_FAULT_KEY_HAS_MODULE
    return k.fmt ^ (std::uint32_t(slot + 1) << 24);
#else
    (void)slot;
    return k.fmt;
#endif
}

inline bool key_eq(NcEntry const& e, NcKey const& k, int slot) {
    return e.kind == k.kind && e.fmt == key_fmt(k, slot) && e.a == k.a && e.b == k.b
        && e.hash_lo == std::uint32_t(k.hash) && e.hash_hi == std::uint32_t(k.hash >> 32);
}

struct Doomed { int n; int idx[NUICACHE_ENTRIES]; void* obj[NUICACHE_ENTRIES]; std::uint32_t type[NUICACHE_ENTRIES]; };

// Under the lock: take a live entry out of the table (state 3); the object is released after unlock.
inline void doom(NcHeader* h, int i, Doomed& d) {
    NcEntry& e = entries(h)[i];
    InterlockedExchange(&e.state, 3);
    InterlockedExchange(&e.holders, 0);
    d.idx[d.n] = i;
    d.obj[d.n] = e.obj;
    d.type[d.n] = e.obj_type;
    ++d.n;
    InterlockedExchangeAdd(&h->live_bytes, -LONG(e.bytes));
    InterlockedDecrement(&h->live_entries);
}

inline void clear_entry(NcEntry& e) {
    e.creator = 0;
    e.kind = e.fmt = e.a = e.b = e.hash_lo = e.hash_hi = 0;
    e.obj_type = 0;
    e.obj = nullptr;
    e.device = nullptr;
    e.gen = 0;
    e.w = e.h = 0;
    e.bytes = 0;
    e.last_used_ms = 0;
    e.label[0] = 0;
}

// After unlock: Release each doomed object, then free its entry. Entries of an object type this
// build does not know are never released by it (frozen rule); they are never doomed either.
inline void finish(NcHeader* h, Doomed& d) {
    for (int k = 0; k < d.n; ++k) {
        if (d.obj[k] && d.type[k] == 1) com_release(d.obj[k]);
        InterlockedIncrement(&h->releases);
        NcEntry& e = entries(h)[d.idx[k]];
        clear_entry(e);
        MemoryBarrier();
        InterlockedExchange(&e.state, 0);
    }
    d.n = 0;
}

struct DeadSnap { int n; int slot[NUICACHE_CLIENTS]; LONG serial[NUICACHE_CLIENTS]; };

// Is `m` still mapped there: its headers' region part of an image whose allocation starts at m?
// VirtualQuery only (review HOOK-4): it takes no loader or module-list lock, so the render thread
// never waits for a DLL load or a thread start, and it is the same test UiHook's liveness check uses.
// Before 1.2.6 this was GetModuleHandleEx(FROM_ADDRESS), which can block behind the loader.
inline bool module_mapped(HMODULE m) {
#ifdef NUI_FAULT_DEAD_BY_LOADER            // self-test: the loader call of before 1.2.6
    HMODULE got = nullptr;
    return m && GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                                   reinterpret_cast<LPCSTR>(m), &got) && got == m;
#else
    MEMORY_BASIC_INFORMATION r {};
    if (!m || !VirtualQuery(m, &r, sizeof(r))) return false;
    return r.State == MEM_COMMIT && r.Type == MEM_IMAGE && r.AllocationBase == reinterpret_cast<void*>(m);
#endif
}

// Outside the lock: live clients whose module is gone.
inline void find_dead(NcHeader* h, int me, DeadSnap& s) {
    s.n = 0;
    NcClient* c = clients(h);
    for (int i = 0; i < NUICACHE_CLIENTS; ++i) {
        if (i == me || load(&c[i].state) != 1) continue;
        LONG const serial = load(&c[i].serial);
        if (!module_mapped(c[i].module)) { s.slot[s.n] = i; s.serial[s.n] = serial; ++s.n; }
    }
}

// Under the lock. device: the render thread's device, or null for "no device check".
// force_unheld: release every unheld entry now (stop() of the last client, CreateTexture failure).
inline void sweep_locked(NcHeader* h, void* device, DWORD t, bool force_unheld, DeadSnap const* dead, Doomed& d) {
    NcEntry* E = entries(h);
    // 1. device identity (C.5): a new device releases everything made on the old one, holders or not
    if (device && h->device != device) {
        h->device = device;
        InterlockedIncrement(&h->gen);
        for (int i = 0; i < NUICACHE_ENTRIES; ++i)
            if (load(&E[i].state) == 2 && E[i].device != device) doom(h, i, d);
    }
    // 2. dead clients (module unmapped without DllMain): their bits and slots
#ifndef NUI_FAULT_NO_RECLAIM
    if (dead) {
        NcClient* C = clients(h);
        for (int k = 0; k < dead->n; ++k) {
            NcClient& c = C[dead->slot[k]];
            if (load(&c.state) != 1 || load(&c.serial) != dead->serial[k]) continue;
            LONG const mask = ~(LONG(1) << dead->slot[k]);
            for (int i = 0; i < NUICACHE_ENTRIES; ++i) {
                if (atomic_and(&E[i].holders, mask) & ~mask) E[i].last_used_ms = LONG(t);
            }
            InterlockedExchange(&c.state, 0);
            InterlockedIncrement(&h->reclaims);
        }
    }
#else
    (void)dead;
#endif
    // 3. entries left `creating` by a creator that is gone
    for (int i = 0; i < NUICACHE_ENTRIES; ++i) {
        if (load(&E[i].state) == 1 && !token_live(h, E[i].creator)) {
            clear_entry(E[i]);
            InterlockedExchange(&E[i].state, 0);
        }
    }
    // 4. unheld entries: past grace, then oldest first above the budget
    std::uint32_t unheld = 0;
    int left = 0;
    for (int i = 0; i < NUICACHE_ENTRIES; ++i) {
        NcEntry& e = E[i];
        if (load(&e.state) != 2 || e.obj_type != 1) continue;
#ifndef NUI_FAULT_SWEEP_FREES_HELD
        if (load(&e.holders) != 0) continue;
#endif
        if (force_unheld || t - DWORD(e.last_used_ms) >= h->grace_ms) { doom(h, i, d); continue; }
        unheld += e.bytes;
        ++left;
    }
    while (unheld > h->unheld_budget && left > 0) {
        int oldest = -1;
        for (int i = 0; i < NUICACHE_ENTRIES; ++i) {
            NcEntry& e = E[i];
            if (load(&e.state) != 2 || e.obj_type != 1 || load(&e.holders) != 0) continue;
            if (oldest < 0 || LONG(DWORD(e.last_used_ms) - DWORD(E[oldest].last_used_ms)) < 0) oldest = i;
        }
        if (oldest < 0) break;
        unheld -= E[oldest].bytes;
        --left;
        doom(h, oldest, d);
    }
    InterlockedExchange(&h->unheld_bytes, LONG(unheld));
    InterlockedExchange(&h->pending, left > 0 ? 1 : 0);
    InterlockedExchange(&h->last_sweep_ms, LONG(t));
}

inline NcResult make_private(Local& L, NcKey const& key, void* device, nc_create_fn create, void* ctx, NcRef* out) {
    NcMade made {0, 0, 0};
    void* obj = create ? create(ctx, device, &key, &made) : nullptr;
    if (!obj) return NC_FAILED;
    out->obj = obj;
    out->entry = -1;
    out->gen = 0;
    out->w = made.w;
    out->h = made.h;
    out->bytes = made.bytes;
    InterlockedIncrement(&L.private_refs);
    return NC_PRIVATE;
}

// my ref count on entry i (under mod_lock)
inline void count_up(Local& L, int i, LONG gen) {
    if (L.count_gen[i] != gen) { L.count_gen[i] = gen; L.count[i] = 0; }
    ++L.count[i];
    ++L.shared_refs;
}

inline void set_why(Local& L, char const* why) { std::snprintf(L.why, sizeof(L.why), "%s", why); }

inline NcHeader* attach(Local& L) {
    char name[64];
#ifdef NUI_FAULT_MAJOR_SHARED
    std::uint32_t const major_in_name = 1u;
#else
    std::uint32_t const major_in_name = NUICACHE_MAJOR;
#endif
    std::snprintf(name, sizeof(name), "Local\\FFXiNuiCache_v%lu_%lu", static_cast<unsigned long>(major_in_name),
                  static_cast<unsigned long>(GetCurrentProcessId()));
    HANDLE mapping = CreateFileMappingA(INVALID_HANDLE_VALUE, nullptr, PAGE_READWRITE, 0, NUICACHE_MAP_SIZE, name);
    if (!mapping) { set_why(L, "mapping failed"); return nullptr; }
    bool const existed = GetLastError() == ERROR_ALREADY_EXISTS;
    auto* h = static_cast<NcHeader*>(MapViewOfFile(mapping, FILE_MAP_ALL_ACCESS, 0, 0, NUICACHE_MAP_SIZE));
    if (!h) { CloseHandle(mapping); set_why(L, "map view failed"); return nullptr; }
    if (!existed) {
        h->magic = NUICACHE_MAGIC;
        h->major = NUICACHE_MAJOR;
        h->map_size = NUICACHE_MAP_SIZE;
        h->creator_pid = GetCurrentProcessId();
        h->grace_ms = NUICACHE_GRACE_MS;
        h->unheld_budget = NUICACHE_BUDGET;
        h->client_cap = NUICACHE_CLIENTS;
        h->client_stride = sizeof(NcClient);
        h->clients_off = 256;
        h->entry_cap = NUICACHE_ENTRIES;
        h->entry_stride = sizeof(NcEntry);
        h->entries_off = 256 + 64 * NUICACHE_CLIENTS;
        MemoryBarrier();
        InterlockedExchange(&h->ready, 1);
    } else {
        for (int spin = 0; spin < 500 && load(&h->ready) == 0; ++spin) Sleep(1);
    }
    char const* bad = nullptr;
    if (load(&h->ready) == 0) bad = "cache never became ready";
    else if (h->magic != NUICACHE_MAGIC) bad = "wrong magic";
#ifndef NUI_FAULT_MAJOR_SHARED
    else if (h->major != NUICACHE_MAJOR) bad = "other major";
#endif
    else if (h->map_size < NUICACHE_MAP_SIZE || h->creator_pid != GetCurrentProcessId()) bad = "foreign mapping";
    else if (h->client_cap != NUICACHE_CLIENTS || h->client_stride != sizeof(NcClient) || h->clients_off != 256
             || h->entry_cap != NUICACHE_ENTRIES || h->entry_stride != sizeof(NcEntry)
             || h->entries_off != 256 + 64 * NUICACHE_CLIENTS)
        bad = "layout differs";
    else if (h->grace_ms > 600000u || h->unheld_budget > (256u << 20)) bad = "unknown policy";
    if (bad) {
        UnmapViewOfFile(h);
        CloseHandle(mapping);
        set_why(L, bad);
        return nullptr;
    }
    return h;     // handle and view leaked on purpose: the mapping belongs to the process
}

inline HMODULE own_module() {
    HMODULE m = nullptr;
    GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                       reinterpret_cast<LPCSTR>(&local), &m);
    return m;
}

}  // namespace nc_detail

// ---- public API ---------------------------------------------------------------------------------

// FNV-1a 64 (C.3 hashes): file contents for pictures; nc_hash_path for the install dir.
inline std::uint64_t nc_fnv1a64(void const* data, std::size_t n, std::uint64_t h = 0xcbf29ce484222325ull) {
    auto const* p = static_cast<unsigned char const*>(data);
    for (std::size_t i = 0; i < n; ++i) { h ^= p[i]; h *= 0x100000001b3ull; }
    return h;
}
inline std::uint64_t nc_hash_path(char const* s) {
    std::uint64_t h = 0xcbf29ce484222325ull;
    for (; s && *s; ++s) {
        unsigned char c = static_cast<unsigned char>(*s);
        if (c >= 'A' && c <= 'Z') c = static_cast<unsigned char>(c + 32);
        if (c == '/') c = '\\';
        h ^= c;
        h *= 0x100000001b3ull;
    }
    return h;
}

// Lua thread, at start(). True = sharing; false = private for this module (see NcStatus::why).
// Calling it again while started returns the same answer.
inline bool nc_start(char const* name, char const* version, bool noshare) {
    using namespace nc_detail;
    Local& L = local();
    if (L.started) return L.hdr != nullptr;
    std::memset(&L, 0, sizeof(L));
    L.slot = -1;
    L.started = true;
    L.noshare = noshare;
    if (noshare) { set_why(L, "noshare"); return false; }
    NcHeader* h = attach(L);
    if (!h) return false;
    NcClient* C = clients(h);
    for (int i = 0; i < NUICACHE_CLIENTS; ++i) {
        if (InterlockedCompareExchange(&C[i].state, 2, 0) != 0) continue;
        if (make_token(i, InterlockedIncrement(&C[i].serial)) == 0) InterlockedIncrement(&C[i].serial);   // 0 = unlocked
        C[i].module = own_module();
        C[i].rev = NUICACHE_REV;
        std::snprintf(C[i].name, sizeof(C[i].name), "%s", name ? name : "?");
        std::snprintf(C[i].version, sizeof(C[i].version), "%s", version ? version : "?");
        MemoryBarrier();
        InterlockedExchange(&C[i].state, 1);
        L.slot = i;
        L.token = make_token(i, load(&C[i].serial));
        for (;;) {
            LONG const cur = load(&h->max_rev);
            if (cur >= LONG(NUICACHE_REV) || InterlockedCompareExchange(&h->max_rev, LONG(NUICACHE_REV), cur) == cur) break;
        }
        L.hdr = h;
        set_why(L, "");
        return true;
    }
    set_why(L, "no free client slot");
    return false;
}

// Render thread, top of every draw, before any cached object is touched.
//   NC_FRAME_RESET: the device changed (any module may have released shared objects): nc_release
//                   every ref this module holds (shared ones are no-ops) and acquire again.
//   NC_FRAME_SKIP:  the device changed but the cache lock was busy: draw nothing, retry next frame.
inline NcFrame nc_frame(void* device) {
    using namespace nc_detail;
    Local& L = local();
    if (!L.started) return NC_FRAME_SKIP;
    NcHeader* h = L.hdr;
    if (!h) {                                   // private: only our own device matters
        bool const changed = L.device_seen && L.device != device;
        L.device = device;
        L.device_seen = true;
        return changed ? NC_FRAME_RESET : NC_FRAME_OK;
    }
    DWORD const t = now();
    bool const dev_changed = device && h->device != device;
    bool const due = load(&h->pending) != 0 && t - DWORD(load(&h->last_sweep_ms)) >= NUICACHE_SWEEP_MS;
    if (dev_changed || due) {
        DeadSnap dead;
        find_dead(h, L.slot, dead);
        Doomed d;
        d.n = 0;
        if (lock(h, L.token, NC_RENDER)) {
            NUICACHE_TEST_YIELD();
            sweep_locked(h, device, t, false, &dead, d);
            unlock(h);
            finish(h, d);
        } else if (dev_changed) {
            return NC_FRAME_SKIP;
        }
    }
    LONG const g = load(&h->gen);
#ifdef NUI_FAULT_NO_GEN_CHECK
    if (L.gen == 0) L.gen = g;
    return NC_FRAME_OK;
#else
    if (g != L.gen) { L.gen = g; return NC_FRAME_RESET; }
    return NC_FRAME_OK;
#endif
}

namespace nc_detail {
// Render thread, mod_lock held (review HOOK-5): the object an earlier acquire made but could not
// publish goes into its entry now, unheld (the caller's lookup that follows finds it and marks it), or
// is Released when its generation or device has passed, or the entry is no longer ours. The cache
// lock busy again: kept for the next acquire.
inline void publish_unpublished(Local& L, NcHeader* h) {
    if (!lock(h, L.token, NC_RENDER)) return;
    Local::Unpublished const u = L.unpub;
    L.unpub = Local::Unpublished {};
    NcEntry& e = entries(h)[u.entry];
    bool const ours = load(&e.state) == 1 && e.creator == L.token;
    void* drop = nullptr;
    if (ours && LONG(e.gen) == load(&h->gen) && LONG(e.gen) == u.gen && h->device == u.device) {
        e.obj = u.obj;
        e.obj_type = 1;
        e.w = u.made.w;
        e.h = u.made.h;
        e.bytes = u.made.bytes;
        e.holders = 0;
        e.last_used_ms = LONG(now());
        e.creator = 0;
        MemoryBarrier();
        InterlockedExchange(&e.state, 2);
        InterlockedIncrement(&h->creates);
        InterlockedIncrement(&h->live_entries);
        InterlockedExchangeAdd(&h->live_bytes, LONG(u.made.bytes));
        InterlockedExchange(&h->pending, 1);
    } else {
        if (ours) {
            clear_entry(e);
            MemoryBarrier();
            InterlockedExchange(&e.state, 0);
        }
        drop = u.obj;
    }
    unlock(h);
    if (drop) com_release(drop);
}

// nc_stop (mod_lock held, cache lock held when `locked`): an unpublished object's entry is freed; the
// object is returned for the caller to Release after unlocking.
inline void* drop_unpublished(Local& L, NcHeader* h, bool locked) {
    if (!L.unpub.obj) return nullptr;
    Local::Unpublished const u = L.unpub;
    L.unpub = Local::Unpublished {};
    NcEntry& e = entries(h)[u.entry];
    if (locked && load(&e.state) == 1 && e.creator == L.token) {
        clear_entry(e);
        MemoryBarrier();
        InterlockedExchange(&e.state, 0);
    }                                                   // not locked: the entry is left to sweep step 3
    return u.obj;
}
}  // namespace nc_detail

// Find or make the object for `key`. NC_HIT / NC_CREATED: shared, borrowed. NC_PRIVATE: owned by
// this module (fallback). NC_BUSY: someone is creating it, or the lock was busy on the render
// thread, or the device changed under us: draw without it and ask again next frame. NC_FAILED:
// create failed (then 2 s of backoff on creates).
inline NcResult nc_acquire(NcKey const& key, void* device, nc_create_fn create, void* ctx, char const* label,
                           NcThread th, NcRef* out) {
    using namespace nc_detail;
    Local& L = local();
    *out = NcRef {nullptr, -1, 0, 0, 0, 0};
    if (!L.started) return NC_FAILED;
    if (!L.hdr) return make_private(L, key, device, create, ctx, out);
    NcHeader* h = L.hdr;
    if (h->device != device) return NC_BUSY;            // the render thread's nc_frame owns device changes
    spin_mod(L);
    if (L.unpub.obj && th == NC_RENDER) publish_unpublished(L, h);
    if (!lock(h, L.token, th)) {
        if (th == NC_RENDER) { unspin_mod(L); return NC_BUSY; }
        InterlockedIncrement(&h->fallbacks);
        NcResult const r = make_private(L, key, device, create, ctx, out);
        unspin_mod(L);
        return r;
    }
    NcEntry* E = entries(h);
    LONG const gen = load(&h->gen);
    LONG const bit = LONG(1) << L.slot;
    int found = -1, free_at = -1;
    for (int i = 0; i < NUICACHE_ENTRIES; ++i) {
        LONG const st = load(&E[i].state);
        if ((st == 1 || st == 2) && LONG(E[i].gen) == gen && key_eq(E[i], key, L.slot)) { found = i; break; }
        if (st == 0 && free_at < 0) free_at = i;
    }
    NUICACHE_TEST_YIELD();
    if (found >= 0) {
        NcEntry& e = E[found];
        if (load(&e.state) != 2) { unlock(h); unspin_mod(L); return NC_BUSY; }   // being created
        atomic_or(&e.holders, bit);
        e.last_used_ms = LONG(now());
        InterlockedIncrement(&h->hits);
        *out = NcRef {e.obj, found, std::uint32_t(gen), e.w, e.h, e.bytes};
        unlock(h);
        count_up(L, found, gen);
        unspin_mod(L);
        return NC_HIT;
    }
    if (L.backoff && LONG(now() - L.backoff_until) < 0) { unlock(h); unspin_mod(L); return NC_FAILED; }
    L.backoff = false;
    if (free_at < 0) {                                   // table full
        unlock(h);
        InterlockedIncrement(&h->fallbacks);
#ifdef NUI_FAULT_NO_FALLBACK
        unspin_mod(L);
        return NC_FAILED;
#else
        NcResult const r = make_private(L, key, device, create, ctx, out);
        unspin_mod(L);
        return r;
#endif
    }
    NcEntry& e = E[free_at];
    clear_entry(e);
    e.creator = L.token;
    e.kind = key.kind;
    e.fmt = key_fmt(key, L.slot);
    e.a = key.a;
    e.b = key.b;
    e.hash_lo = std::uint32_t(key.hash);
    e.hash_hi = std::uint32_t(key.hash >> 32);
    e.device = device;
    e.gen = std::uint32_t(gen);
    std::snprintf(e.label, sizeof(e.label), "%s", label ? label : "");
    MemoryBarrier();
    InterlockedExchange(&e.state, 1);                    // creating: others get NC_BUSY for this key
    unlock(h);

    // decode + CreateTexture outside the lock. Review HOOK-5: every lock below is taken in the
    // caller's mode (the render thread spins briefly and gives up; before 1.2.6 it waited up to 50 ms
    // per try, as the Lua thread does), and the render thread never creates twice in one frame.
    NcThread const lth = th;
#ifdef NUI_FAULT_RENDER_LOCK_LUA           // self-test: the render thread waits as the Lua thread (before 1.2.6)
    th = NC_LUA;
#endif
    NcMade made {0, 0, 0};
    void* obj = create ? create(ctx, device, &key, &made) : nullptr;
    if (!obj) {                                          // address space: drop every unheld entry
        Doomed d;
        d.n = 0;
        if (lock(h, L.token, th)) {
            sweep_locked(h, nullptr, now(), true, nullptr, d);
            unlock(h);
            finish(h, d);
        }
#ifndef NUI_FAULT_RENDER_RETRY_CREATE      // self-test: the render thread creates again at once (before 1.2.6)
        if (lth == NC_LUA)                               // the Lua thread retries once; the render thread waits for the backoff
#endif
            obj = create ? create(ctx, device, &key, &made) : nullptr;
    }
    bool locked = false;
    for (int tries = 0; tries < 3 && !locked; ++tries) locked = lock(h, L.token, th);
#ifndef NUI_FAULT_DROP_UNPUBLISHED         // self-test: a made object thrown away when the lock is busy (before 1.2.6)
    if (!locked && obj && lth == NC_RENDER && !L.unpub.obj) {
        L.unpub = Local::Unpublished {free_at, obj, made, gen, device};   // published at the next acquire
        unspin_mod(L);
        return NC_BUSY;
    }
#endif
    if (!locked || !obj || LONG(e.gen) != load(&h->gen) || h->device != device) {
        clear_entry(e);                                  // ours alone while creating
        MemoryBarrier();
        InterlockedExchange(&e.state, 0);
        if (locked) unlock(h);
        if (obj) com_release(obj);
        if (!obj) { L.backoff = true; L.backoff_until = now() + NUICACHE_BACKOFF_MS; }
        unspin_mod(L);
        return obj ? NC_BUSY : NC_FAILED;
    }
    e.obj = obj;
    e.obj_type = 1;
    e.w = made.w;
    e.h = made.h;
    e.bytes = made.bytes;
    e.holders = bit;
    e.last_used_ms = LONG(now());
    e.creator = 0;
    MemoryBarrier();
    InterlockedExchange(&e.state, 2);
    InterlockedIncrement(&h->creates);
    InterlockedIncrement(&h->live_entries);
    InterlockedExchangeAdd(&h->live_bytes, LONG(made.bytes));
    *out = NcRef {obj, free_at, std::uint32_t(gen), made.w, made.h, made.bytes};
    unlock(h);
    count_up(L, free_at, gen);
    unspin_mod(L);
    return NC_CREATED;
}

// nui 1.2.1. Lua thread (any thread but a draw): this module's hold on a LIVE shared entry for `key`,
// found and marked under the cache lock exactly as nc_acquire's hit (holder bit, last use, `hits`),
// so no sweep can release it until nc_release. Nothing is ever created: no entry (or private mode,
// or the lock busy for NUICACHE_LUA_WAIT_MS) is NC_FAILED, and unlike nc_acquire with a null create
// it never purges unheld entries or starts a create backoff. The ref is shared and borrowed, of
// generation ref.gen: the render thread may use it only while nc_gen() is that generation.
// Only the frozen records and the holder-bit rule are used (no layout or semantic change).
inline NcResult nc_hold(NcKey const& key, NcRef* out) {
    using namespace nc_detail;
    Local& L = local();
    *out = NcRef {nullptr, -1, 0, 0, 0, 0};
    if (!L.started || !L.hdr) return NC_FAILED;
    NcHeader* h = L.hdr;
    spin_mod(L);
    if (!lock(h, L.token, NC_LUA)) { unspin_mod(L); return NC_FAILED; }
    NcEntry* E = entries(h);
    LONG const gen = load(&h->gen);
    for (int i = 0; i < NUICACHE_ENTRIES; ++i) {
        NcEntry& e = E[i];
        if (load(&e.state) != 2 || LONG(e.gen) != gen || !key_eq(e, key, L.slot)) continue;
#ifndef NUI_FAULT_HOLD_NO_BIT                  // self-test: a "hold" that does not mark the entry
        atomic_or(&e.holders, LONG(1) << L.slot);
#endif
        e.last_used_ms = LONG(now());
        InterlockedIncrement(&h->hits);
        *out = NcRef {e.obj, i, std::uint32_t(gen), e.w, e.h, e.bytes};
        unlock(h);
        count_up(L, i, gen);
        unspin_mod(L);
        return NC_HIT;
    }
    unlock(h);
    unspin_mod(L);
    return NC_FAILED;
}

// nui 1.2.1. Render thread, after nc_frame: the cache generation this module draws in. A shared ref
// of another generation (a hold taken before a device change) must be given back, not drawn.
inline LONG nc_gen() { return nc_detail::local().gen; }

// Give a ref back (either thread). Shared: when this module's last ref to the entry goes, its
// holder bit is cleared (lock-free) and the entry starts its grace time. A shared ref from before a
// device change is a no-op. Private: the module's own reference is Released here.
inline void nc_release(NcRef& ref) {
    using namespace nc_detail;
    if (!ref.obj) return;
    Local& L = local();
    if (ref.entry < 0) {
        com_release(ref.obj);
        InterlockedDecrement(&L.private_refs);
        ref = NcRef {nullptr, -1, 0, 0, 0, 0};
        return;
    }
    NcHeader* h = L.hdr;
    int const i = ref.entry;
    if (h && L.started && i < NUICACHE_ENTRIES) {
        spin_mod(L);
        if (L.count_gen[i] == LONG(ref.gen) && L.count[i] > 0) {
            --L.shared_refs;
            if (--L.count[i] == 0) {
                NcEntry& e = entries(h)[i];
#ifndef NUI_FAULT_NO_HOLDER_CLEAR
                if (e.gen == ref.gen && load(&e.state) == 2) {
                    e.last_used_ms = LONG(now());
                    atomic_and(&e.holders, ~(LONG(1) << L.slot));
                    InterlockedExchange(&h->pending, 1);
                }
#else
                (void)e;
#endif
            }
        }
        unspin_mod(L);
    }
    ref = NcRef {nullptr, -1, 0, 0, 0, 0};
}

// A live shared entry for `key` exists now (a hint: e.g. skip the 2 MiB atlas decode at start()).
inline bool nc_has(NcKey const& key) {
    using namespace nc_detail;
    Local& L = local();
    NcHeader* h = L.hdr;
    if (!h) return false;
    LONG const gen = load(&h->gen);
    NcEntry* E = entries(h);
    for (int i = 0; i < NUICACHE_ENTRIES; ++i)
        if (load(&E[i].state) == 2 && LONG(E[i].gen) == gen && key_eq(E[i], key, L.slot)) return true;
    return false;
}

// Lua thread, at stop(). Every shared ref of this module is dropped (the module must forget them;
// private refs are still the module's to nc_release, before or after). If this is the last live
// client, every unheld entry is released now. Then the client slot is freed.
inline void nc_stop() {
    using namespace nc_detail;
    Local& L = local();
    if (!L.started) return;
    NcHeader* h = L.hdr;
    if (h && L.slot >= 0) {
        spin_mod(L);
        DeadSnap dead;
        find_dead(h, L.slot, dead);
        bool const locked = lock(h, L.token, NC_LUA);
        NcEntry* E = entries(h);
        LONG const mask = ~(LONG(1) << L.slot);
        DWORD const t = now();
        for (int i = 0; i < NUICACHE_ENTRIES; ++i)
            if (atomic_and(&E[i].holders, mask) & ~mask) E[i].last_used_ms = LONG(t);
        Doomed d;
        d.n = 0;
        void* const unpub = drop_unpublished(L, h, locked);
        if (locked) {
            NcClient* C = clients(h);
            int others = 0;
            for (int i = 0; i < NUICACHE_CLIENTS; ++i) if (i != L.slot && load(&C[i].state) != 0) ++others;
            for (int k = 0; k < dead.n; ++k) if (load(&C[dead.slot[k]].state) == 1) --others;
#ifndef NUI_FAULT_STOP_KEEPS_UNHELD
            bool const last = others <= 0;
#else
            bool const last = false;
            (void)others;
#endif
            sweep_locked(h, nullptr, t, last, &dead, d);
            if (!last) InterlockedExchange(&h->pending, 1);
            unlock(h);
            finish(h, d);
        } else {
            InterlockedExchange(&h->pending, 1);
        }
        if (unpub) com_release(unpub);
        InterlockedExchange(&clients(h)[L.slot].state, 0);
        unspin_mod(L);
    }
    L.started = false;
    L.hdr = nullptr;
    L.slot = -1;
}

// DllMain(DLL_PROCESS_DETACH) only (loader lock): lock-free bit clears, free the slot, ask for a
// sweep. No D3D call, no lock, no wait. Objects stay for another module's sweep (or the next start).
inline void nc_detach() {
    using namespace nc_detail;
    Local& L = local();
    NcHeader* h = L.hdr;
    if (L.started && h && L.slot >= 0) {
#ifndef NUI_FAULT_DETACH_KEEPS_BITS
        NcEntry* E = entries(h);
        LONG const mask = ~(LONG(1) << L.slot);
        DWORD const t = now();
        for (int i = 0; i < NUICACHE_ENTRIES; ++i)
            if (atomic_and(&E[i].holders, mask) & ~mask) E[i].last_used_ms = LONG(t);
#endif
        InterlockedExchange(&clients(h)[L.slot].state, 0);
        InterlockedExchange(&h->pending, 1);
    }
    L.started = false;
    L.hdr = nullptr;
    L.slot = -1;
}

inline void nc_status(NcStatus* s) {
    using namespace nc_detail;
    Local& L = local();
    std::memset(s, 0, sizeof(*s));
    s->shared = L.hdr != nullptr;
    std::snprintf(s->why, sizeof(s->why), "%s", L.started ? L.why : "not started");
    s->slot = L.slot;
    s->my_shared = L.shared_refs;
    s->my_private = L.private_refs;
    NcHeader* h = L.hdr;
    if (!h) return;
    s->gen = load(&h->gen);
    s->max_rev = load(&h->max_rev);
    NcClient* C = clients(h);
    for (int i = 0; i < NUICACHE_CLIENTS; ++i) {
        if (load(&C[i].state) != 1) continue;
        std::snprintf(s->client_names[s->clients], sizeof(s->client_names[0]), "%.15s %.15s", C[i].name, C[i].version);
        ++s->clients;
    }
    s->creates = load(&h->creates);
    s->hits = load(&h->hits);
    s->releases = load(&h->releases);
    s->fallbacks = load(&h->fallbacks);
    s->live_entries = load(&h->live_entries);
    s->live_bytes = load(&h->live_bytes);
    s->unheld_bytes = load(&h->unheld_bytes);
    s->lock_timeouts = load(&h->lock_timeouts);
    s->lock_breaks = load(&h->lock_breaks);
    s->reclaims = load(&h->reclaims);
}

#endif  // NUICACHE_H
