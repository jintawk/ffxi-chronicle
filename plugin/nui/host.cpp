// host.cpp - see host.hpp
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <d3d8.h>

#include "host.hpp"

#include "UiHook/UiHook.h"
#include "assets.hpp"
#include "cache.hpp"
#include "client.hpp"
#include "d3d8_backend.hpp"
#include "device.hpp"
#include "ops.hpp"
#include "key.hpp"
#include "pad.hpp"
#include "textures.hpp"
#include "ui.hpp"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <deque>
#include <iterator>
#include <map>
#include <new>
#include <set>
#include <string>
#include <utility>
#include <vector>

namespace nui {
namespace {

LuaApi& g_lua = lua();
HostConfig const* g_cfg = nullptr;

// ---------------------------------------------------------------------------------------------
// Threads (1.2.0). Windower runs each addon's Lua on its OWN worker thread (LuaCore.dll: one task
// queue per addon); the draw callback runs on the game's render thread, inside the EndScene
// wrapper. They are different threads, and the game thread waits for the worker on every incoming
// packet, mouse move, key and chat line (LuaCore posts those events and waits for the result), so
// neither side may hold a lock for long, and the render thread never reads a file:
//   g_lock   what the render thread draws from: g_layers[].used / z / dl / key, g_icons, g_be,
//            g_store's maps and pixels, g_assets (the pointer and its atlas pixels), g_want,
//            g_failed, the screen fields. The render thread holds it for its draw (once per
//            displayed frame); the worker only to swap in finished work (microseconds). Everything
//            slow (parse, layer build, DAT and file reads, Assets loads) runs on the worker first.
//   g_plock  the render thread's profiler counters (prof() copies and resets them).
//   g_qlock  (1.2.1) the decode thread's queue, its finished pixels and its counters. Taken alone or
//            inside g_lock (never the other way round); the decode thread takes nothing else.
// Worker-only (written only by the worker, so the worker reads them without a lock):
// g_layers[].cmds / ox / oy / clip / icons, g_icon_refs, g_assets' fonts and recipe, the pointer
// g_assets itself, the structure of g_store's maps, g_window_type, g_store.dat.
// ---------------------------------------------------------------------------------------------

CRITICAL_SECTION g_lock {};
CRITICAL_SECTION g_plock {};
bool g_lock_ready = false;
void lock() { if (g_lock_ready) EnterCriticalSection(&g_lock); }
void unlock() { if (g_lock_ready) LeaveCriticalSection(&g_lock); }

Assets* g_assets = nullptr;               // fonts, frame recipe, widths; its atlas pixels freed once the texture exists
TextureStore g_store;
D3D8Backend g_be;

constexpr int kLayers = 16;
struct Layer {
    bool used = false;
    int z = 0;
    std::vector<Cmd> cmds;
    DrawList dl;
    std::uint64_t key = 0;                // names dl's content for the backend's vertex cache (new on every build)
    std::vector<int> icons;               // item ids its I commands draw, sorted, unique
    float ox = 0, oy = 0;
    bool has_clip = false;
    Rect clip {0, 0, 0, 0};
};
Layer g_layers[kLayers + 1];              // 1..16
std::uint64_t g_next_key = 0;             // worker

volatile bool g_running = false;
// review HOST-4: the atlas's last upload failed; it is tried again after g_failed's backoff (before 1.2.6 a
// sticky flag left the window blank until a reload, while status() said "start again", which could not)
bool g_atlas_failed = false;
DeviceCheck g_devcheck;
std::set<int> g_icons;                    // item ids some layer draws (and that have an icon)
std::map<int, int> g_icon_refs;           // worker: item id -> layers drawing it
std::map<int, DWORD> g_failed;            // handle -> when to try making its texture again (NUICACHE_NOW)
std::map<int, DWORD> g_want;              // handle -> since when the render thread waits for the worker's pixels
NcRef g_atlas_held {};                    // 1.2.1: wintype's hold on the atlas another module made, until attached
volatile LONG g_want_flag = 0;            // g_want is not empty
constexpr DWORD kWantWaitMs = 1000;       // then the render thread reads the pixels itself (counted)

UiBus* g_bus = nullptr;
int g_slot = -1;

// stats
unsigned long g_calls = 0, g_drawn = 0, g_rebuilds = 0, g_uploads = 0, g_no_device = 0;
unsigned long g_hits = 0, g_creates = 0, g_privates = 0, g_busy = 0, g_skipped = 0, g_resets = 0;
double g_last_us = 0, g_max_us = 0, g_build_us = 0, g_qpc_us = 0;
int g_rt_w = 0, g_rt_h = 0, g_screen_w = 0, g_screen_h = 0;
bool g_scale_auto = false;
float g_view_f = 1.0f;          // one of Lua's units in screen px (the UI scale, or a simulated screen)
float g_scale = 1.0f;
int g_window_type = 6;
std::uintptr_t g_last_device = 0;
char g_status[256] = "idle";
std::string g_ffxi;

// The back-buffer rule (1.2.0): the game ends a scene around every mid-frame Clear (the scene
// render target, effect targets, the shadow map, lens-flare occlusion tests), so the wrapper runs
// several times a frame and anything drawn before the last call is cleared. Draw only when the
// bound render target is the device's back buffer; when no call has had it bound for kBbFallbackMs,
// draw on every call (today's behaviour) until one has it again.
constexpr DWORD kBbFallbackMs = 500;
DWORD g_last_bb = 0;
bool g_bb_seen = false;                   // a call since start() (g_last_bb is set)
volatile bool g_fallback = false;

// Ticks, and tick deltas -> microseconds. Only deltas are ever converted: D3D8 puts the x87 FPU in
// 24-bit precision, so an absolute tick count as a double would be quantised to ~16 ms.
long long g_qpc_f = 1, g_qpc0 = 0;
long long qpc() {
    LARGE_INTEGER t;
    QueryPerformanceCounter(&t);
    return t.QuadPart;
}
double us_of(long long ticks) { return double(ticks) * g_qpc_us; }
double us_since(long long t0) { return us_of(qpc() - t0); }

// ---------------------------------------------------------------------------------------------
// Profiler (1.2.0): prof() returns these since the last prof() and resets them. Ticks, not us.
// ---------------------------------------------------------------------------------------------

struct RtSize { int w, h; unsigned long n; };
struct ProfRender {                        // render thread, under g_plock
    unsigned long calls, draws, calls_bb, calls_other, fallback_draws, bb_fallback_n, no_device;
    RtSize rt[8];
    unsigned long rt_more;
    long long t_draw, t_draw_max, t_skip;
    long long t_wait, t_wait_max;
    unsigned long waits_50;
    unsigned long batches, dps, verts, xform_builds;
    unsigned long uploads;
    long long t_upload_max;
    unsigned long reads;                   // files read on this thread (pixels the worker had not supplied)
    long long t_read, t_read_max;
    unsigned long wants;
    unsigned long held;                    // 1.2.1: holds attached (textures another module made, never decoded here)
    DWORD tid;
};
struct ProfWorker {                        // worker thread only
    long long t0;
    unsigned long layers, removes, layer_pos, pos_same, builds;
    long long t_layer, t_layer_max, t_build;
    unsigned long locks, waits_50;
    long long t_wait, t_wait_max, t_hold, t_hold_max;
    unsigned long reads;
    long long t_read, t_read_max;
    unsigned long tex_loads, holds, decodes;   // 1.2.1: pictures loaded, cache holds taken (no decode), decodes on this thread
    long long t_tex_load_max, t_decode, t_decode_max;
    std::size_t tex_read_max;              // 1.2.6: the most bytes one tex_load read on this thread (HOST-10)
    DWORD tid;
};
ProfRender g_pr {};
ProfWorker g_pw {};

// The render thread's counters for one call, added under g_plock at its end.
struct CallProf {
    bool drawn = false, bb = false, fallback_draw = false, engaged = false, no_device = false;
    int rw = 0, rh = 0;
    long long t = 0, t_wait = 0;
    unsigned long uploads = 0, reads = 0, wants = 0, held = 0;
    long long t_upload_max = 0, t_read = 0, t_read_max = 0;
};
CallProf* g_call = nullptr;                // the render call in progress (render thread only)

void prof_render_add(CallProf const& c, unsigned long batches, unsigned long dps, unsigned long verts) {
    if (!g_lock_ready) return;
    EnterCriticalSection(&g_plock);
    ProfRender& p = g_pr;
    ++p.calls;
    p.tid = GetCurrentThreadId();
    if (c.no_device) ++p.no_device;
    if (c.bb) ++p.calls_bb; else if (!c.no_device) ++p.calls_other;
    if (c.engaged) ++p.bb_fallback_n;
    if (c.rw > 0) {
        int i = 0;
        while (i < 8 && p.rt[i].n && (p.rt[i].w != c.rw || p.rt[i].h != c.rh)) ++i;
        if (i < 8) { p.rt[i].w = c.rw; p.rt[i].h = c.rh; ++p.rt[i].n; } else ++p.rt_more;
    }
    if (c.drawn) {
        ++p.draws;
        if (c.fallback_draw) ++p.fallback_draws;
        p.t_draw += c.t;
        if (c.t > p.t_draw_max) p.t_draw_max = c.t;
        p.batches += batches;
        p.dps += dps;
        p.verts += verts;
    } else {
        p.t_skip += c.t;
    }
    p.t_wait += c.t_wait;
    if (c.t_wait > p.t_wait_max) p.t_wait_max = c.t_wait;
    if (us_of(c.t_wait) > 50) ++p.waits_50;
    p.uploads += c.uploads;
    if (c.t_upload_max > p.t_upload_max) p.t_upload_max = c.t_upload_max;
    p.reads += c.reads;
    p.t_read += c.t_read;
    if (c.t_read_max > p.t_read_max) p.t_read_max = c.t_read_max;
    p.wants += c.wants;
    p.held += c.held;
    LeaveCriticalSection(&g_plock);
}

// A file read on the render thread (pixels the worker had not supplied): timed and counted.
struct RenderRead {
    long long t0 = qpc();
    ~RenderRead() {
        if (!g_call) return;
        long long const t = qpc() - t0;
        ++g_call->reads;
        g_call->t_read += t;
        if (t > g_call->t_read_max) g_call->t_read_max = t;
    }
};
// A file read on the worker thread.
struct WorkerRead {
    long long t0 = qpc();
    ~WorkerRead() {
        long long const t = qpc() - t0;
        ++g_pw.reads;
        g_pw.t_read += t;
        if (t > g_pw.t_read_max) g_pw.t_read_max = t;
    }
};

// The worker's g_lock: how long it waited for the render thread, and how long it held the lock.
long long g_wlock_t1 = 0;
void wlock() {
    long long const t0 = qpc();
    lock();
    g_wlock_t1 = qpc();
    long long const w = g_wlock_t1 - t0;
    ++g_pw.locks;
    g_pw.t_wait += w;
    if (w > g_pw.t_wait_max) g_pw.t_wait_max = w;
    if (us_of(w) > 50) ++g_pw.waits_50;
    g_pw.tid = GetCurrentThreadId();
}
void wunlock() {
    long long const h = qpc() - g_wlock_t1;
    g_pw.t_hold += h;
    if (h > g_pw.t_hold_max) g_pw.t_hold_max = h;
    unlock();
}

// ---------------------------------------------------------------------------------------------
// The decode thread (1.2.1). A picture no module holds in the cache is decoded here, never on the Lua
// thread: stb_image plus the area-averaged fit took 6 ms for a typical map and up to 77 ms for a
// 2133 x 2133 one, inside handlers the game thread waits for. One thread at a time, started by the
// first job and gone as soon as the queue is empty. It takes a reference on this module
// (GetModuleHandleEx) and leaves with FreeLibraryAndExitThread, so a module unloaded without stop()
// stays mapped until the thread is out. It touches only g_qlock's state (the queue, the finished
// pixels, its counters): never g_lock, the store, the cache or a texture. The render thread moves
// finished pixels into the store at the top of its draw (drain_decodes); a picture whose job is not
// done is simply not drawn yet, as any texture before its upload. stop() cancels every job and waits
// for the thread.
// ---------------------------------------------------------------------------------------------

struct DecodeJob {
    std::uint64_t id = 0;
    int handle = 0;
    std::string path;                     // read here when bytes is empty (a file over kReadAllBytes, or pixels asked again)
    std::vector<unsigned char> bytes;     // the file tex_load read and hashed
    int max_w = 0, max_h = 0;
};
struct DecodeDone {
    std::uint64_t id = 0;
    int handle = 0;
    bool ok = false;
    int w = 0, h = 0;
    std::vector<uint32_t> px;
    std::uint64_t hash = 0;               // 1.2.6: the file's hash when it was read here (the picture's cache key)
};

CRITICAL_SECTION g_qlock {};

// 1.2.5 (review HOST-1): a C++ exception (an allocation failing in a 32-bit client near its 2 GB)
// must never unwind into LuaCore or the game's EndScene frames, where it ends in std::terminate. Every
// Lua function, the draw callback and the cache create callbacks catch it at their edge. Whatever
// lock the throwing thread holds is left here (a critical section knows its owner), so the other
// threads are not deadlocked; the call returns nil plus a reason, or the frame is not drawn.
volatile LONG g_native_errors = 0;
#ifdef NUI_TEST_CLOCK                     // test (test_render "ex"): the driver makes one site throw once
extern "C" int __cdecl nui_test_throw(int site);
#define NUI_TEST_THROW(site) do { if (nui_test_throw(site)) throw std::bad_alloc(); } while (0)
extern "C" unsigned long __cdecl nui_test_decode_ms();     // 1.2.6 (test_render "tl"): a decode that takes long
#else
#define NUI_TEST_THROW(site) ((void)0)
#endif
void leave_if_mine(CRITICAL_SECTION& cs) {
    HANDLE const me = reinterpret_cast<HANDLE>(static_cast<ULONG_PTR>(GetCurrentThreadId()));
    while (cs.OwningThread == me && cs.RecursionCount > 0) LeaveCriticalSection(&cs);
}
void leave_held_locks() {
#ifdef NUI_FAULT_NO_LOCK_LEAVE            // self-test: a throw leaves its locks held (before 1.2.5)
    return;
#endif
    if (!g_lock_ready) return;
    leave_if_mine(g_qlock);               // taken inside g_lock, so left first
    leave_if_mine(g_plock);
    leave_if_mine(g_lock);
}
std::deque<DecodeJob> g_queue;            // g_qlock
std::vector<DecodeDone> g_done;           // g_qlock
std::uint64_t g_inflight = 0;             // g_qlock: the job being decoded
bool g_inflight_cancel = false;           // g_qlock: its result is not wanted any more
bool g_thread_on = false;                 // g_qlock: a decode thread runs (or is being started)
volatile LONG g_jobs = 0;                 // queued + being decoded
volatile LONG g_done_flag = 0;            // g_done is not empty
DWORD g_job_tid = 0;                      // the thread that queued the last job (the Lua thread)
std::uint64_t g_job_next = 0;             // worker: job ids, never reused (not even across stop/start)
std::vector<HANDLE> g_threads;            // worker: decode threads started and not yet seen gone
unsigned long g_dec_n = 0, g_dec_fail = 0, g_dec_cancel = 0;   // g_qlock: since the last prof()
long long g_dec_t = 0, g_dec_t_max = 0;

// One job off the queue, decoded and handed over. false when the queue was empty (the thread is
// then marked gone in the same hold of g_qlock as the empty check, so a new job starts a new one).
bool decode_one() {
    DecodeJob job;
    EnterCriticalSection(&g_qlock);
    if (g_queue.empty()) {
        g_thread_on = false;
        LeaveCriticalSection(&g_qlock);
        return false;
    }
    job = std::move(g_queue.front());
    g_queue.pop_front();
    g_inflight = job.id;
    g_inflight_cancel = false;
    LeaveCriticalSection(&g_qlock);
#ifdef NUI_TEST_CLOCK
    if (unsigned long const ms = nui_test_decode_ms()) Sleep(ms);
#endif
    long long const t0 = qpc();
    DecodeDone d;
    d.id = job.id;
    d.handle = job.handle;
    std::string err;
    try {                                 // nothing may escape a thread of the game's process
        if (job.bytes.empty()) {
            // read here: a file over kReadAllBytes (1.2.6, review HOST-10: hashed here, not on the Lua
            // thread) or pixels asked again; the hash names the picture in the cache
            std::vector<unsigned char> bytes;
            if (!job.path.empty() && read_file(job.path, bytes)) {
                d.hash = nc_fnv1a64(bytes.data(), bytes.size());
                d.ok = decode_image_mem(bytes.data(), bytes.size(), job.max_w, job.max_h, d.px, d.w, d.h, err);
            }
        } else {
            d.ok = decode_image_mem(job.bytes.data(), job.bytes.size(), job.max_w, job.max_h, d.px, d.w, d.h, err);
        }
    } catch (...) {
        d.ok = false;
        std::vector<uint32_t>().swap(d.px);
    }
    std::vector<unsigned char>().swap(job.bytes);
    long long const t = qpc() - t0;
    bool const ok = d.ok;
    EnterCriticalSection(&g_qlock);
    bool const keep = !g_inflight_cancel;
    g_inflight = 0;
    if (keep) {
        try {
            g_done.push_back(std::move(d));
        } catch (...) {                   // out of memory: the picture is not drawn
        }
        InterlockedExchange(&g_done_flag, 1);
    } else {
        ++g_dec_cancel;
    }
    ++g_dec_n;
    if (!ok) ++g_dec_fail;
    g_dec_t += t;
    if (t > g_dec_t_max) g_dec_t_max = t;
    InterlockedDecrement(&g_jobs);
    LeaveCriticalSection(&g_qlock);
    return true;                          // a cancelled result's pixels are freed here, on this thread
}

DWORD WINAPI decode_main(void* self) {
    while (decode_one()) {}
    if (self) FreeLibraryAndExitThread(static_cast<HMODULE>(self), 0);
    return 0;
}

// Worker: forget decode threads that are gone.
void prune_threads() {
    for (std::size_t i = 0; i < g_threads.size();) {
        if (WaitForSingleObject(g_threads[i], 0) == WAIT_OBJECT_0) {
            CloseHandle(g_threads[i]);
            g_threads[i] = g_threads.back();
            g_threads.pop_back();
        } else {
            ++i;
        }
    }
}

// Worker: waits (up to ms each) for every decode thread to be gone. -> true when none is left.
bool join_threads(DWORD ms) {
    for (HANDLE h : g_threads) WaitForSingleObject(h, ms);
    prune_threads();
    return g_threads.empty();
}

// Worker: a picture's decode, queued for the decode thread (started when none runs). Without a
// thread (CreateThread failed) it is decoded here, as before 1.2.1.
void queue_decode(std::uint64_t id, int handle, std::string const& path, std::vector<unsigned char>&& bytes,
                  int max_w, int max_h) {
    DecodeJob j;
    j.id = id;
    j.handle = handle;
    j.path = path;
    j.bytes.swap(bytes);
    j.max_w = max_w;
    j.max_h = max_h;
    bool start = false;
    EnterCriticalSection(&g_qlock);
    g_queue.push_back(std::move(j));
    InterlockedIncrement(&g_jobs);
    g_job_tid = GetCurrentThreadId();
    if (!g_thread_on) start = g_thread_on = true;
    LeaveCriticalSection(&g_qlock);
    if (!start) return;
    prune_threads();
    HMODULE self = nullptr;
    HANDLE th = nullptr;
#ifndef NUI_FAULT_THREAD_NO_REF           // self-test: a thread that does not keep its module mapped
    if (GetModuleHandleExA(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS, reinterpret_cast<LPCSTR>(&decode_main), &self))
        th = CreateThread(nullptr, 0, &decode_main, self, 0, nullptr);
#else
    th = CreateThread(nullptr, 0, &decode_main, nullptr, 0, nullptr);
#endif
    if (th) {
        g_threads.push_back(th);
        return;
    }
    if (self) FreeLibrary(self);
    while (decode_one()) {}               // no thread: decode here
}

// Worker, inside wlock: the decode of `id` is not wanted (its picture was freed). What it took is
// moved to the trash vectors, freed by the caller after unlocking.
void cancel_decode(std::uint64_t id, std::vector<DecodeJob>& trash, std::vector<DecodeDone>& trash_done) {
    if (!id) return;
    EnterCriticalSection(&g_qlock);
    for (auto it = g_queue.begin(); it != g_queue.end(); ++it) {
        if (it->id != id) continue;
        trash.push_back(std::move(*it));
        g_queue.erase(it);
        InterlockedDecrement(&g_jobs);
        ++g_dec_cancel;
        break;
    }
    if (g_inflight == id) g_inflight_cancel = true;
    for (std::size_t i = 0; i < g_done.size(); ++i) {
        if (g_done[i].id != id) continue;
        trash_done.push_back(std::move(g_done[i]));
        g_done.erase(g_done.begin() + std::ptrdiff_t(i));
        ++g_dec_cancel;
        break;
    }
    LeaveCriticalSection(&g_qlock);
}

// Render thread, g_lock held, top of a draw: finished pixels into their pictures. A result whose
// picture is gone or now waits for another job is dropped.
void drain_decodes() {
    if (!g_done_flag) return;
    std::vector<DecodeDone> got;
    EnterCriticalSection(&g_qlock);
    got.swap(g_done);
    InterlockedExchange(&g_done_flag, 0);
    LeaveCriticalSection(&g_qlock);
    for (DecodeDone& d : got) {
        auto it = g_store.pics.find(d.handle);
        if (it == g_store.pics.end() || it->second.job != d.id) continue;
        Picture& p = it->second;
        p.job = 0;
        if (d.ok && d.w == p.w && d.h == p.h && (p.hash || d.hash)) {
            p.px.swap(d.px);
            if (!p.hash) p.hash = d.hash;     // 1.2.6: a file hashed on the decode thread
        } else {
            p.bad = true;                     // never drawn (prof: decode_failed)
        }
    }
}

// Offline harnesses draw their frames on the Lua thread itself; in game the render thread is never
// the Lua thread. Such a draw first lets this module's decodes finish (and their threads leave), so
// a frame drawn right after tex_load shows the picture exactly as when tex_load decoded it (QA frames
// do not move; a FreeLibrary right after a frame unloads at once).
void finish_decodes_on_lua_thread() {
#ifdef NUI_FAULT_NO_LUA_WAIT              // self-test: an offline frame drawn before the decode finished
    return;
#endif
    if (GetCurrentThreadId() != g_job_tid) return;     // g_threads is the Lua thread's: only it reads it
    if (g_threads.empty() && !g_jobs) return;
    join_threads(30000);
}

// Render thread, g_lock held: a hold the Lua thread took (nc_hold: a texture another module made),
// attached as this handle's texture. false when the device changed since (the ref is given back and
// the handle is made the usual way).
bool attach_held(int handle, NcRef& held) {
    NcRef r = held;
    held = NcRef {nullptr, -1, 0, 0, 0, 0};
    if (!r.obj) return false;
    if (LONG(r.gen) != nc_gen()) {
        nc_release(r);
        return false;
    }
    g_be.attach(handle, r);
    g_want.erase(handle);
    ++g_uploads;
    ++g_hits;
    if (g_call) ++g_call->held;
    return true;
}

void release_textures() {
    g_be.release();
    g_be.dev = nullptr;
    g_failed.clear();
}

// ---------------------------------------------------------------------------------------------
// The shared texture cache (cache.hpp): keys, "does a module hold it already", create callbacks
// ---------------------------------------------------------------------------------------------

bool have_picture(Picture const& p) { return nc_has(picture_key(p.max_w, p.max_h, p.hash)); }
bool have_icon(int id, std::uint64_t install) { return nc_has(icon_key(id, install)); }

// Create callbacks: render thread, inside nc_acquire (outside the cache's lock), g_lock held. The
// pixels are normally there (decoded by the worker); reading them here is the fallback, counted.
void* create_atlas_body(void* device, NcKey const* key, NcMade* made) {
    NUI_TEST_THROW(4);
    std::vector<uint32_t> const* px = g_assets ? &g_assets->atlas : nullptr;
    Assets again;
    if (!px || px->empty()) {
        // not decoded at start (a module held it then) or dropped since, and the worker did not
        // supply it in time: read the game's art again here
        RenderRead r;
        if (!again.load(g_ffxi, int(key->a))) return nullptr;
        px = &again.atlas;
    }
    IDirect3DTexture8* t = create_texture(static_cast<IDirect3DDevice8*>(device), px->data(), kAtlasW, kAtlasH);
    if (t) *made = NcMade {kAtlasW, kAtlasH, std::uint32_t(kAtlasW) * kAtlasH * 4};
    return t;
}

// Pixels the worker or the decode thread supplied are uploaded where they are, not copied first (review
// REND-12: a copy doubled the picture's memory on the render thread); only a read here makes a vector.
void* create_picture_body(void* ctx, void* device, NcMade* made) {
    NUI_TEST_THROW(3);
    std::vector<uint32_t> px;
    uint32_t const* src = nullptr;
    int w = 0, h = 0;
    int const handle = int(reinterpret_cast<std::intptr_t>(ctx));
    auto it = g_store.pics.find(handle);
    if (it == g_store.pics.end()) return nullptr;
    if (!it->second.px.empty() && it->second.px.size() == std::size_t(it->second.w) * std::size_t(it->second.h)) {
        src = it->second.px.data();
        w = it->second.w;
        h = it->second.h;
    } else {
        RenderRead r;
        if (!g_store.picture_pixels(handle, px, w, h)) return nullptr;
        src = px.data();
    }
    IDirect3DTexture8* t = create_texture(static_cast<IDirect3DDevice8*>(device), src, w, h);
    if (t) *made = NcMade {std::uint16_t(w), std::uint16_t(h), std::uint32_t(w) * h * 4};
    return t;
}

void* create_icon_body(void* ctx, void* device, NcMade* made) {
    std::vector<uint32_t> px;
    uint32_t const* src = nullptr;
    int const id = int(reinterpret_cast<std::intptr_t>(ctx));
    auto it = g_store.icons.find(id);
    if (it != g_store.icons.end() && it->second.px.size() == std::size_t(kIconCell) * kIconCell) {
        src = it->second.px.data();
    } else {
        RenderRead r;
        if (!g_store.icon_pixels(id, px)) return nullptr;
        src = px.data();
    }
    IDirect3DTexture8* t = create_texture(static_cast<IDirect3DDevice8*>(device), src, kIconCell, kIconCell);
    if (t) *made = NcMade {kIconCell, kIconCell, kIconCell * kIconCell * 4};
    return t;
}

// 1.2.5: an exception never leaves a create callback: it would unwind through nc_acquire and leave
// the entry being created, with this module's spin held (review HOST-1). Null = not made.
void* __cdecl create_atlas(void*, void* device, NcKey const* key, NcMade* made) {
    try { return create_atlas_body(device, key, made); } catch (...) { InterlockedIncrement(&g_native_errors); return nullptr; }
}
void* __cdecl create_picture(void* ctx, void* device, NcKey const*, NcMade* made) {
#ifdef NUI_FAULT_CREATE_THROWS_THROUGH    // self-test: an exception leaves the create callback (before 1.2.5)
    return create_picture_body(ctx, device, made);
#endif
    try { return create_picture_body(ctx, device, made); } catch (...) { InterlockedIncrement(&g_native_errors); return nullptr; }
}
void* __cdecl create_icon(void* ctx, void* device, NcKey const*, NcMade* made) {
    try { return create_icon_body(ctx, device, made); } catch (...) { InterlockedIncrement(&g_native_errors); return nullptr; }
}

// The texture for a handle, from the cache (render thread, g_lock held).
NcResult acquire(IDirect3DDevice8* dev, int handle) {
    NcKey key;
    nc_create_fn fn = nullptr;
    void* ctx = nullptr;
    char label[32];
    if (handle == kTexAtlas) {
        key = atlas_key(g_window_type, g_store.install);
        fn = &create_atlas;
        std::snprintf(label, sizeof(label), "atlas t%d", g_window_type);
    } else if (is_icon_handle(handle)) {
        int const id = icon_of(handle);
        key = icon_key(id, g_store.install);
        fn = &create_icon;
        ctx = reinterpret_cast<void*>(std::intptr_t(id));
        std::snprintf(label, sizeof(label), "icon %d", id);
    } else {
        auto it = g_store.pics.find(handle);
        if (it == g_store.pics.end()) return NC_FAILED;
        key = picture_key(it->second.max_w, it->second.max_h, it->second.hash);
        fn = &create_picture;
        ctx = reinterpret_cast<void*>(std::intptr_t(handle));
        std::snprintf(label, sizeof(label), "pic %08lx%08lx", (unsigned long)(it->second.hash >> 32),
                      (unsigned long)it->second.hash);
    }
    NcRef ref;
    long long const t0 = qpc();
    NcResult const r = nc_acquire(key, dev, fn, ctx, label, NC_RENDER, &ref);
    if (r == NC_HIT || r == NC_CREATED || r == NC_PRIVATE) {
        g_be.attach(handle, ref);
        if (handle == kTexAtlas) {
            if (g_assets) std::vector<uint32_t>().swap(g_assets->atlas);
        } else {
            g_store.made(handle);
        }
        g_want.erase(handle);
        ++g_uploads;
        if (r == NC_HIT) ++g_hits;
        else if (r == NC_CREATED) ++g_creates;
        else ++g_privates;
        if (r != NC_HIT && g_call) {
            long long const t = qpc() - t0;
            ++g_call->uploads;
            if (t > g_call->t_upload_max) g_call->t_upload_max = t;
        }
    } else if (r == NC_BUSY) {
        ++g_busy;
    } else {
        g_failed[handle] = NUICACHE_NOW() + NUICACHE_BACKOFF_MS;
    }
    return r;
}

// Render thread, g_lock held: true when the texture's pixels are not here and no module holds it
// in the cache, i.e. making it now would read a file on this thread. The worker is asked for them
// (service_wants, on its next call into the module) and the texture waits; after kWantWaitMs
// without them it is made here after all (the read is counted in prof().reads_render).
bool wait_for_pixels(int handle) {
    DWORD const now = NUICACHE_NOW();
    bool missing = false;
    if (handle == kTexAtlas) {
        missing = (!g_assets || g_assets->atlas.empty()) && !nc_has(atlas_key(g_window_type, g_store.install));
    } else if (is_icon_handle(handle)) {
        auto it = g_store.icons.find(icon_of(handle));
        missing = it != g_store.icons.end() && it->second.exists && it->second.px.empty() &&
                  !nc_has(icon_key(icon_of(handle), g_store.install));
    } else {
        auto it = g_store.pics.find(handle);
        if (it != g_store.pics.end() && (it->second.job || it->second.bad)) return true;   // 1.2.1: the decode thread's
        missing = it != g_store.pics.end() && it->second.px.empty() && !have_picture(it->second);
    }
#ifdef NUI_FAULT_RENDER_READS             // self-test: a render thread that reads what it lacks itself
    missing = false;
#endif
    if (!missing) return false;
    auto w = g_want.find(handle);
    if (w == g_want.end()) {
        g_want[handle] = now;
        InterlockedExchange(&g_want_flag, 1);
        if (g_call) ++g_call->wants;
        return true;
    }
    return LONG(now - w->second) < LONG(kWantWaitMs);
}

void ensure(IDirect3DDevice8* dev, int handle, DWORD now) {
    if (g_be.has(handle)) return;
    auto f = g_failed.find(handle);
    if (f != g_failed.end()) {
        if (LONG(now - f->second) < 0) return;
        g_failed.erase(f);
    }
    if (handle >= 2 && !is_icon_handle(handle)) {          // 1.2.1: a picture tex_load found held: no pixels needed
        auto it = g_store.pics.find(handle);
        if (it != g_store.pics.end() && it->second.held.obj && attach_held(handle, it->second.held)) return;
    }
    if (wait_for_pixels(handle)) return;
    acquire(dev, handle);
}

// ---------------------------------------------------------------------------------------------
// Worker side: icons, pixels the render thread asked for, layer builds
// ---------------------------------------------------------------------------------------------

// Worker. Whether the item has an icon; the first time an id is seen it is learned here. keep (an id
// about to be drawn): its pixels are cut here (one open handle per icon DAT) and kept until the texture
// exists, even when a module holds it in the cache now: that entry may be swept before this module's
// next frame acquires it, and the render thread never reads the DAT itself. keep false (icon() for an
// id nothing draws): only whether it exists, from the cache when a module holds it.
bool known_icon(int id, bool keep) {
    if (id <= 0 || id > 65535 || g_store.ffxi.empty()) return false;
    auto it = g_store.icons.find(id);
    if (it != g_store.icons.end()) return it->second.exists;
    Icon ic;
    if (!keep && have_icon(id, g_store.install)) {
        ic.exists = true;
    } else {
        WorkerRead r;
        ic.exists = g_store.cut_icon(id, ic.px);
        if (!keep) std::vector<uint32_t>().swap(ic.px);
    }
    bool const exists = ic.exists;
    wlock();
    g_store.icons[id] = std::move(ic);
    wunlock();
    return exists;
}

// Worker, before a layer with these icon ids is built and swapped in: every id is known to the
// store (so the build only looks ids up), and an icon that is about to be drawn again has its pixels
// again (4 KB, dropped once its texture exists: from the cache or made from them, never from a file
// read on the render thread).
void prefill_icons(std::vector<int> const& ids) {
    std::vector<std::pair<int, std::vector<uint32_t>>> cut;
    for (int id : ids) {
        if (id <= 0 || id > 65535 || g_store.ffxi.empty()) continue;
        auto it = g_store.icons.find(id);
        if (it == g_store.icons.end()) {
            known_icon(id, true);
            continue;
        }
#ifndef NUI_FAULT_RENDER_READS
        if (!it->second.exists || !it->second.px.empty() || g_icon_refs.count(id)) continue;   // drawn: the render thread's
        std::vector<uint32_t> px;
        WorkerRead r;
        if (g_store.cut_icon(id, px)) cut.emplace_back(id, std::move(px));
#endif
    }
    if (cut.empty()) return;
    wlock();
    for (auto& c : cut) g_store.icons[c.first].px.swap(c.second);
    wunlock();
}

// Worker, g_lock held: a layer's icon ids went from `was` to `now` (both sorted, unique).
void icons_changed(std::vector<int> const& was, std::vector<int> const& now) {
    std::vector<int> added, gone;
    std::set_difference(now.begin(), now.end(), was.begin(), was.end(), std::back_inserter(added));
    std::set_difference(was.begin(), was.end(), now.begin(), now.end(), std::back_inserter(gone));
    for (int id : added)
        if (++g_icon_refs[id] == 1) {
            auto it = g_store.icons.find(id);
            if (it != g_store.icons.end() && it->second.exists) g_icons.insert(id);
        }
    for (int id : gone) {
        auto r = g_icon_refs.find(id);
        if (r == g_icon_refs.end() || --r->second > 0) continue;
        // nothing draws it: its texture goes back to the cache (another module, or this one within
        // the grace time, finds it there) and its pixels are dropped
        g_icon_refs.erase(r);
        g_icons.erase(id);
        g_be.drop(icon_handle(id));
        g_want.erase(icon_handle(id));
        g_failed.erase(icon_handle(id));
        auto it = g_store.icons.find(id);
        if (it != g_store.icons.end()) std::vector<uint32_t>().swap(it->second.px);
    }
}

std::vector<int> icon_ids(std::vector<Cmd> const& cmds) {
    std::set<int> ids;
    ops_icons(cmds, ids);
    return std::vector<int>(ids.begin(), ids.end());
}

// Worker: pixels the render thread asked for (wait_for_pixels), read here and handed over.
void service_wants() {
    if (!g_want_flag) return;
    std::vector<int> hs;
    wlock();
    for (auto const& kv : g_want) hs.push_back(kv.first);
    wunlock();
    int const type = g_window_type;
    std::vector<uint32_t> atlas;
    std::vector<std::pair<int, std::vector<uint32_t>>> got;
    std::vector<int> pics;                // 1.2.1: pictures go to the decode thread
    for (int h : hs) {
        std::vector<uint32_t> px;
        if (h == kTexAtlas) {
            Assets a;
            WorkerRead r;
            if (!g_ffxi.empty() && a.load(g_ffxi, type)) atlas.swap(a.atlas);
            continue;
        }
        if (is_icon_handle(h)) {
            WorkerRead r;
            g_store.cut_icon(icon_of(h), px);
        } else {
            pics.push_back(h);
            continue;
        }
        got.emplace_back(h, std::move(px));
    }
    std::vector<DecodeJob> jobs;
    wlock();
    for (int h : hs) {
        g_want.erase(h);
        g_failed.erase(h);
    }
    for (int h : pics) {
        auto it = g_store.pics.find(h);
        if (it == g_store.pics.end() || !it->second.px.empty() || it->second.job || it->second.bad ||
            it->second.path.empty())
            continue;
        DecodeJob j;
        j.id = it->second.job = ++g_job_next;
        j.handle = h;
        j.path = it->second.path;
        j.max_w = it->second.max_w;
        j.max_h = it->second.max_h;
        jobs.push_back(std::move(j));
    }
    if (!atlas.empty() && g_assets && g_window_type == type && g_assets->atlas.empty()) g_assets->atlas.swap(atlas);
    for (auto& g : got) {
        if (g.second.empty()) continue;
        if (is_icon_handle(g.first)) {
            auto it = g_store.icons.find(icon_of(g.first));
            if (it != g_store.icons.end() && it->second.px.empty() && g_icons.count(icon_of(g.first))) it->second.px.swap(g.second);
        } else {
            auto it = g_store.pics.find(g.first);
            if (it != g_store.pics.end() && it->second.px.empty()) it->second.px.swap(g.second);
        }
    }
    if (g_want.empty()) InterlockedExchange(&g_want_flag, 0);
    wunlock();
    for (DecodeJob& j : jobs) queue_decode(j.id, j.handle, j.path, std::move(j.bytes), j.max_w, j.max_h);
}

// Builds a layer's quads from its commands into out (worker, no lock: reads only worker-owned state
// and the store's ids, which prefill_icons made known).
void build_layer(Layer const& L, DrawList& out, Assets const& assets) {
    long long const t0 = qpc();
    out.clear(L.has_clip ? Rect {L.clip.x0 + L.ox, L.clip.y0 + L.oy, L.clip.x1 + L.ox, L.clip.y1 + L.oy}
                         : Rect {-1e9f, -1e9f, 1e9f, 1e9f});
    out.ox = L.ox;
    out.oy = L.oy;
    Ui ui {assets, out};
    ops_replay(ui, L.cmds, &g_store, &have_icon);
    ++g_pw.builds;
    g_pw.t_build += qpc() - t0;
}

// ---------------------------------------------------------------------------------------------
// The draw callback (render thread)
// ---------------------------------------------------------------------------------------------

// 1.2.5 (review REND-5): the game's device is not created multithreaded, so a texture Release on the
// Lua thread can race the game's own drawing. Private textures dropped while running wait for the
// render thread (D3D8Backend::pending), and stop() hands its last give-back (every texture, the
// holds, the cache's last-client sweep) to the next draw call, waiting up to kFinalWaitMs. Only
// when nothing is drawing (no draw call for kFinalLiveMs: minimised, a lost device, the offline
// harnesses whose frames run on the Lua thread) does the Lua thread do it itself.
// g_final: 0 none, 1 asked by stop(), 2 the render thread is doing it, 3 done.
volatile LONG g_final = 0;
volatile DWORD g_render_tid = 0;          // the thread of the last draw call
volatile DWORD g_render_seen = 0;         // and when (GetTickCount)
volatile LONG g_final_render = 0;         // stops whose give-back the render thread did (status().final_render)
constexpr DWORD kFinalLiveMs = 500;
constexpr DWORD kFinalWaitMs = 250;
constexpr DWORD kStopJoinMs = 250;        // 1.2.6: stop()'s wait for a decode in progress (review HOST-10)

// g_lock held: every texture, hold and cache entry of this module given back, on the calling thread.
void give_back_textures() {
    release_textures();                   // shared: holder bits cleared; private: queued
    g_be.flush_pending();                 // private: Released
    for (auto& kv : g_store.pics) nc_release(kv.second.held);   // 1.2.1: holds never attached
    nc_release(g_atlas_held);
    nc_stop();                            // the last module out releases what nobody holds
}

// Render thread: stop()'s give-back, when asked.
void final_pass_here() {
    if (InterlockedCompareExchange(&g_final, 2, 1) != 1) return;
    lock();
    give_back_textures();
    unlock();
    InterlockedIncrement(&g_final_render);
    InterlockedExchange(&g_final, 3);
}

// Lua thread, in stop(), before anything is torn down: true when the render thread gave everything back.
bool render_final_pass() {
#ifdef NUI_FAULT_NO_FINAL_PASS            // self-test: stop() gives back on the Lua thread (before 1.2.5)
    return false;
#endif
    if (!g_running || !g_bus || g_slot < 0) return false;
    DWORD const tid = g_render_tid;
    if (!tid || tid == GetCurrentThreadId() || LONG(GetTickCount() - g_render_seen) > LONG(kFinalLiveMs)) return false;
    InterlockedExchange(&g_final, 1);
    DWORD const t0 = GetTickCount();
    for (;;) {
        LONG const f = g_final;
        if (f == 3) return true;
        if (f == 1 && LONG(GetTickCount() - t0) >= LONG(kFinalWaitMs) && InterlockedCompareExchange(&g_final, 0, 1) == 1)
            return false;                 // no draw call took it: the Lua thread gives back, as before 1.2.5
        Sleep(1);
    }
}

void ui_draw_body(void* device) {
    if (!g_running) return;
    g_render_tid = GetCurrentThreadId();
    g_render_seen = GetTickCount();
    if (g_final) { final_pass_here(); return; }
    long long const t0 = qpc();
    CallProf cp;
    ++g_calls;
    auto const dev_addr = reinterpret_cast<std::uintptr_t>(device);
    g_last_device = dev_addr;
    if (!device || !g_devcheck.plausible(dev_addr)) {
        ++g_no_device;
        cp.no_device = true;
        cp.t = qpc() - t0;
        prof_render_add(cp, 0, 0, 0);
        return;
    }
    auto* dev = static_cast<IDirect3DDevice8*>(device);

    // the back-buffer rule: is the bound render target the device's back buffer?
    {
        IDirect3DSurface8* rt = nullptr;
        IDirect3DSurface8* bb = nullptr;
        if (SUCCEEDED(dev->GetRenderTarget(&rt)) && rt) {
            D3DSURFACE_DESC d {};
            if (SUCCEEDED(rt->GetDesc(&d))) { cp.rw = int(d.Width); cp.rh = int(d.Height); }
            if (SUCCEEDED(dev->GetBackBuffer(0, D3DBACKBUFFER_TYPE_MONO, &bb)) && bb) cp.bb = rt == bb;
        }
        if (bb) bb->Release();
        if (rt) rt->Release();
    }
    DWORD const tnow = NUICACHE_NOW();
    if (!g_bb_seen) { g_bb_seen = true; g_last_bb = tnow; }
    if (cp.bb) {
        g_last_bb = tnow;
        g_fallback = false;
    } else if (!g_fallback && LONG(tnow - g_last_bb) >= LONG(kBbFallbackMs)) {
        g_fallback = true;                // nothing had the back buffer bound for a while: draw on every call
        cp.engaged = true;
    }
    bool draw_now = cp.bb || g_fallback;
#if defined(NUI_FAULT_BB_ALWAYS)          // self-test: draws on every call (before 1.2.0)
    draw_now = true;
#elif defined(NUI_FAULT_BB_NO_FALLBACK)   // self-test: never falls back when no call has the back buffer
    draw_now = cp.bb;
#endif
    if (!draw_now) {
        cp.t = qpc() - t0;
        prof_render_add(cp, 0, 0, 0);
        return;
    }
    cp.fallback_draw = !cp.bb;
    finish_decodes_on_lua_thread();       // offline harnesses only (their frames run on the Lua thread)

    long long const tl = qpc();
    lock();
    cp.t_wait = qpc() - tl;
    if (!g_running || !g_assets) { unlock(); cp.t = qpc() - t0; prof_render_add(cp, 0, 0, 0); return; }
    g_call = &cp;
    NUI_TEST_THROW(2);
    g_be.flush_pending();                 // 1.2.5: private textures the Lua thread dropped, Released here
    // the cache first, before any texture is touched: a new device (any module may have released
    // the shared textures made on the old one) means forget them all and acquire them again
    NcFrame const fr = nc_frame(dev);
    bool drew = false;
    do {
        if (fr == NC_FRAME_SKIP) { ++g_skipped; break; }
#ifndef NUI_FAULT_NO_GEN_CHECK
        if (fr == NC_FRAME_RESET || g_be.dev != dev) {
#else
        if (fr == NC_FRAME_RESET) {           // self-test: a renderer that keeps textures across a device change
#endif
            if (!g_be.tex.empty()) ++g_resets;
            release_textures();
            g_be.flush_pending();
        }
        g_be.init(dev);
        drain_decodes();                  // 1.2.1: pixels the decode thread finished
        DWORD const now = NUICACHE_NOW();
        if (!g_be.has(kTexAtlas)) {
#ifdef NUI_FAULT_STICKY_UPLOAD            // self-test: one failed upload blanks the window until a reload (before 1.2.6)
            if (g_atlas_failed) break;
#endif
            // review HOST-4: a failed upload is tried again after the backoff, like any texture
            auto const f = g_failed.find(kTexAtlas);
            if (f != g_failed.end() && LONG(now - f->second) < 0) break;
            if (!attach_held(kTexAtlas, g_atlas_held)) {    // 1.2.1: wintype found it held: no pixels needed
                if (wait_for_pixels(kTexAtlas)) break;  // the worker reads the art again: next frames
                NcResult const r = acquire(dev, kTexAtlas);
                if (r == NC_BUSY) break;                       // being made, or the cache was busy: next frame
                if (r == NC_FAILED) {
                    g_atlas_failed = true;
                    std::snprintf(g_status, sizeof(g_status), "texture upload failed; nothing drawn, trying again");
                    break;
                }
            }
            g_failed.erase(kTexAtlas);
            g_atlas_failed = false;
            std::snprintf(g_status, sizeof(g_status), "drawing");
        }
        for (auto const& kv : g_store.pics) ensure(dev, kv.first, now);
        for (int id : g_icons) ensure(dev, icon_handle(id), now);

        g_rt_w = cp.rw;
        g_rt_h = cp.rh;
        g_be.rt_w = g_rt_w;
        g_be.rt_h = g_rt_h;
        g_scale = ((g_scale_auto && g_screen_w > 0 && g_rt_w > 0) ? float(g_rt_w) / float(g_screen_w) : 1.0f) * g_view_f;
        g_be.scale = g_scale;

        static std::vector<DrawList const*> order;
        static std::vector<std::uint64_t> keys;
        static std::vector<int> ids;
        order.clear();
        keys.clear();
        ids.clear();
        for (int i = 1; i <= kLayers; ++i)
            if (g_layers[i].used) ids.push_back(i);
        std::stable_sort(ids.begin(), ids.end(), [](int a, int b) { return g_layers[a].z < g_layers[b].z; });
        for (int i : ids) {
            order.push_back(&g_layers[i].dl);
            keys.push_back(g_layers[i].key);
        }
        unsigned long const xb = g_be.xform_builds;
        g_be.draw(order, &keys);
        if (g_be.last_failed) InterlockedIncrement(&g_native_errors);
        if (g_be.xform_builds != xb) {
            EnterCriticalSection(&g_plock);
            g_pr.xform_builds += g_be.xform_builds - xb;
            LeaveCriticalSection(&g_plock);
        }
        ++g_drawn;
        drew = true;
    } while (false);
    g_call = nullptr;
    unsigned long const batches = g_be.last_batches, dps = g_be.last_dps, verts = g_be.last_verts;
    unlock();
    cp.drawn = drew;
    cp.t = qpc() - t0;
    if (drew) {
        g_last_us = us_of(cp.t);
        if (g_last_us > g_max_us) g_max_us = g_last_us;
    }
    prof_render_add(cp, batches, dps, verts);
}

void UIHOOK_ALIGN_STACK __cdecl ui_draw(void* user, void* renderer, void* device) {
    (void)user;
    (void)renderer;
    try {
        ui_draw_body(device);
    } catch (...) {                       // 1.2.5 (review HOST-1): this frame is not drawn; the game goes on
        InterlockedIncrement(&g_native_errors);
        g_call = nullptr;
        leave_held_locks();
        if (g_final == 2) InterlockedExchange(&g_final, 3);
        std::snprintf(g_status, sizeof(g_status), "a draw ran out of memory; skipped");
    }
}

// ---------------------------------------------------------------------------------------------
// Lua functions
// ---------------------------------------------------------------------------------------------

int fail(lua_State* L, char const* msg) {
    std::snprintf(g_status, sizeof(g_status), "%s", msg);
    g_lua.pushboolean(L, 0);
    g_lua.pushstring(L, g_status);
    return 2;
}

int nil_why(lua_State* L, char const* msg) {
    g_lua.pushnil(L);
    g_lua.pushstring(L, msg);
    return 2;
}

int __cdecl l_version(lua_State* L) {
    g_lua.pushstring(L, g_cfg->version);
    return 1;
}

// start([ffxi_dir [, flags]]) -> ok, message [, retry_ms]. See host.hpp.
int __cdecl l_start(lua_State* L) {
    if (g_running) {
        g_lua.pushboolean(L, 1);
        g_lua.pushstring(L, "already running");
        return 2;
    }
    InterlockedExchange(&g_final, 0);
    int const top = g_lua.gettop(L);
    if ((top >= 1 && g_lua.type(L, 1) != kTString && g_lua.type(L, 1) != kTNil) ||
        (top >= 2 && g_lua.type(L, 2) != kTString && g_lua.type(L, 2) != kTNil))
        return fail(L, "start expects ([ffxi_dir [, flags]]) as strings");
    std::size_t n = 0;
    char const* dir = top >= 1 && g_lua.type(L, 1) == kTString ? g_lua.tolstring(L, 1, &n) : nullptr;
    char const* flags = top >= 2 && g_lua.type(L, 2) == kTString ? g_lua.tolstring(L, 2, &n) : nullptr;
    bool const nosig = flags && std::strstr(flags, "nosig");
    bool const noshare = flags && std::strstr(flags, "noshare");

    std::string ffxi;
    if (dir && *dir) {
        ffxi = dir;
        if (ffxi.back() != '\\' && ffxi.back() != '/') ffxi += '\\';
    } else if (!find_ffxi_dir(ffxi)) {
        return fail(L, "FFXiMain.dll is not loaded (no game): nothing hooked, nothing drawn");
    }

    // the shared texture cache (private for this module with "noshare", or when it cannot attach);
    // left again on any failure below, so a module waiting for the hook holds no client slot
    nc_start(g_cfg->name, g_cfg->version, noshare);
    auto failed = [&](char const* msg) {
        if (!g_running) nc_stop();
        return fail(L, msg);
    };

    if (!g_assets || g_ffxi != ffxi) {
        // a module holds this window type's atlas already: load the metrics and the recipe only
        std::uint64_t const install = nc_hash_path(ffxi.c_str());
        bool const pixels = !nc_has(atlas_key(g_window_type, install));
        auto* fresh = new Assets();
        if (!fresh->load(ffxi, g_window_type, 39542, pixels)) {
            std::string const msg = "assets missing: " + fresh->log;
            delete fresh;
            return failed(msg.c_str());
        }
        wlock();
        Assets* old = g_assets;
        g_assets = fresh;
        g_ffxi = ffxi;
        g_store.ffxi = ffxi;
        g_store.install = install;
        g_be.drop(kTexAtlas);
        wunlock();
        delete old;
    }

    if (!g_bus) g_bus = uihook_attach();
    if (!g_bus) return failed("UiHook bus unavailable");
    if (g_slot < 0) {
        int const r = uihook_join(g_bus, &ui_draw, nullptr, g_cfg->name, 0, nosig);
        if (r == UIHOOK_JOIN_RETRY) {
            // not hooked yet: start again later (UIHOOK_RETRY_MS); another module may patch first
            char msg[256];
            std::snprintf(msg, sizeof(msg), "not hooked: %s", g_bus->status);
            failed(msg);
            g_lua.pushnumber(L, UIHOOK_RETRY_MS);
            return 3;
        }
        if (r == UIHOOK_JOIN_BLOCKED) {
            char msg[256];
            std::snprintf(msg, sizeof(msg), "not hooked: %s", g_bus->status);
            return failed(msg);
        }
        if (r < 0) return failed(r == UIHOOK_JOIN_FULL ? "UiHook is full" : "UiHook bus unavailable");
        g_slot = r;
    }

    wlock();
    g_atlas_failed = false;
    g_calls = g_drawn = g_rebuilds = g_no_device = 0;
    g_last_us = g_max_us = g_build_us = 0;
    g_bb_seen = false;
    g_fallback = false;
    g_running = true;
    wunlock();
    std::snprintf(g_status, sizeof(g_status), "hooked, waiting for a frame");
    g_lua.pushboolean(L, 1);
    g_lua.pushstring(L, g_status);
    return 2;
}

int __cdecl l_stop(lua_State* L) {
    bool const handed = render_final_pass();   // 1.2.5: textures given back on the render thread (REND-5)
    g_running = false;
    pad_release();                        // the pad goes back to the game with the drawing
    key_release();                        // and the keys
    if (g_bus && g_slot >= 0) uihook_unregister(g_bus, g_slot, true);
    g_slot = -1;
    // 1.2.1: no decode is wanted any more; the one in progress (at most one picture) is waited for
    std::deque<DecodeJob> queued;
    std::vector<DecodeDone> done;
    EnterCriticalSection(&g_qlock);
    queued.swap(g_queue);
    InterlockedExchangeAdd(&g_jobs, -LONG(queued.size()));
    done.swap(g_done);
    InterlockedExchange(&g_done_flag, 0);
    if (g_inflight) g_inflight_cancel = true;
    LeaveCriticalSection(&g_qlock);
    queued.clear();
    done.clear();
    // review HOST-10: a decode in progress cannot be interrupted, and its result is not wanted; the
    // thread holds its own reference on this module, so stop() waits only briefly for it (before 1.2.6
    // up to 10 s, with the game thread waiting on this call)
#ifndef NUI_FAULT_STOP_WAITS_DECODE       // self-test: stop() waits for the decode to end (before 1.2.6)
    join_threads(kStopJoinMs);
#else
    join_threads(10000);
#endif
    wlock();
    if (!handed) give_back_textures();    // nothing is drawing: here, as before 1.2.5
    g_devcheck.reset();
    Assets* old = g_assets;
    g_assets = nullptr;
    g_ffxi.clear();
    g_store.clear();
    g_store.ffxi.clear();
    g_store.install = 0;
    g_icons.clear();
    g_icon_refs.clear();
    g_want.clear();
    InterlockedExchange(&g_want_flag, 0);
    for (Layer& l : g_layers) l = Layer();
    wunlock();
    delete old;
    InterlockedExchange(&g_final, 0);
    std::snprintf(g_status, sizeof(g_status), "stopped");
    g_lua.pushstring(L, g_status);
    return 1;
}

bool layer_id(lua_State* L, int& id) {
    if (g_lua.gettop(L) < 1 || g_lua.type(L, 1) != kTNumber) return false;
    double const v = g_lua.tonumber(L, 1);
    if (!(v >= 1 && v <= kLayers && v == std::floor(v))) return false;
    id = int(v);
    return true;
}

// layer(id, z, text) -> commands | nil, why: draw this command list (ops.cpp format) as layer id
// (1-16) at depth z (back to front, then by id); layer(id) removes it. Parsed and built here, on
// the Lua thread, outside the lock; only the finished layer is swapped in under it.
int __cdecl l_layer(lua_State* L) {
    service_wants();
    int id = 0;
    if (!layer_id(L, id)) return nil_why(L, "layer expects (id 1-16, z, text) or (id)");
    long long const b0 = qpc();
    if (g_lua.gettop(L) < 2 || g_lua.type(L, 2) == kTNil) {
        Layer old;
        wlock();
        std::swap(g_layers[id], old);
        icons_changed(old.icons, {});
        wunlock();
        ++g_pw.removes;
        g_lua.pushboolean(L, 1);
        return 1;
    }
    if (g_lua.type(L, 2) != kTNumber || g_lua.gettop(L) < 3 || g_lua.type(L, 3) != kTString)
        return nil_why(L, "layer expects (id 1-16, z, text) or (id)");
    double const z = g_lua.tonumber(L, 2);
    if (!(z >= -1000 && z <= 1000 && z == std::floor(z))) return nil_why(L, "layer: z must be an integer -1000..1000");
    if (!g_assets) return nil_why(L, "layer: start() first");
    std::size_t n = 0;
    char const* text = g_lua.tolstring(L, 3, &n);
    Layer fresh;
    std::string err;
    if (!ops_parse(text, n, fresh.cmds, err)) return nil_why(L, ("layer: " + err).c_str());
    Layer& cur = g_layers[id];
    fresh.used = true;
    fresh.z = int(z);
    fresh.ox = cur.ox;                    // a re-sent layer keeps its place and clip
    fresh.oy = cur.oy;
    fresh.has_clip = cur.has_clip;
    fresh.clip = cur.clip;
    fresh.icons = icon_ids(fresh.cmds);
    prefill_icons(fresh.icons);           // DAT reads here, before any lock
#if defined(NUI_FAULT_BUILD_IN_LOCK)      // self-test: the build under the lock (before 1.2.0)
    wlock();
    build_layer(fresh, fresh.dl, *g_assets);
    fresh.key = ++g_next_key;
    std::swap(cur, fresh);
#elif defined(NUI_FAULT_BUILD_IN_PLACE)   // self-test: the build straight into the list being drawn
    std::swap(cur.cmds, fresh.cmds);
    std::swap(cur.icons, fresh.icons);
    cur.used = true;
    cur.z = fresh.z;
    build_layer(cur, cur.dl, *g_assets);
    wlock();
    cur.key = ++g_next_key;
#else
    build_layer(fresh, fresh.dl, *g_assets);
    fresh.key = ++g_next_key;
    wlock();
    NUI_TEST_THROW(1);
    std::swap(cur, fresh);
#endif
    icons_changed(fresh.icons, cur.icons);
    ++g_rebuilds;
    wunlock();
    // fresh (the replaced layer) is freed here, outside the lock
    g_build_us = us_since(b0);
    long long const t = qpc() - b0;
    ++g_pw.layers;
    g_pw.t_layer += t;
    if (t > g_pw.t_layer_max) g_pw.t_layer_max = t;
    g_lua.pushnumber(L, double(cur.cmds.size()));
    return 1;
}

// layer_pos(id, ox, oy [, x0, y0, x1, y1]) -> true | nil, why: move a layer by (ox, oy) and clip it
// to the rectangle (in the layer's own coordinates; no rectangle = no clip). Replays the stored
// commands; nothing is parsed. The same place and clip again changes nothing (1.2.0: no rebuild).
int __cdecl l_layer_pos(lua_State* L) {
    service_wants();
    int id = 0;
    if (!layer_id(L, id) || g_lua.gettop(L) < 3 || g_lua.type(L, 2) != kTNumber || g_lua.type(L, 3) != kTNumber)
        return nil_why(L, "layer_pos expects (id, ox, oy [, x0, y0, x1, y1])");
    double v[6] = {g_lua.tonumber(L, 2), g_lua.tonumber(L, 3), 0, 0, 0, 0};
    bool const clip = g_lua.gettop(L) >= 7;
    for (int i = 0; clip && i < 4; ++i) {
        if (g_lua.type(L, 4 + i) != kTNumber) return nil_why(L, "layer_pos: the clip needs four numbers");
        v[2 + i] = g_lua.tonumber(L, 4 + i);
    }
    for (double x : v)
        if (!(x >= -32768 && x <= 32768)) return nil_why(L, "layer_pos: out of range");
    Layer& l = g_layers[id];
    if (!l.used) return nil_why(L, "layer_pos: no such layer");
    ++g_pw.layer_pos;
    float const ox = float(v[0]), oy = float(v[1]);
    Rect const c {float(v[2]), float(v[3]), float(v[4]), float(v[5])};
    // a build is a function of the commands, the offset, the clip and the assets (wintype rebuilds)
    bool same = l.ox == ox && l.oy == oy;
#ifndef NUI_FAULT_LP_IGNORE_CLIP          // self-test: a clip change alone is taken for no change
    same = same && l.has_clip == clip && (!clip || (l.clip.x0 == c.x0 && l.clip.y0 == c.y0 && l.clip.x1 == c.x1 && l.clip.y1 == c.y1));
#endif
    if (same) {
        ++g_pw.pos_same;
        g_lua.pushboolean(L, 1);
        return 1;
    }
    l.ox = ox;
    l.oy = oy;
    l.has_clip = clip;
    l.clip = c;
    long long const b0 = qpc();
    DrawList dl;
    build_layer(l, dl, *g_assets);
    wlock();
    std::swap(l.dl, dl);
    l.key = ++g_next_key;
    wunlock();
    g_build_us = us_since(b0);
    g_lua.pushboolean(L, 1);
    return 1;
}

// tex_load(path [, max_w [, max_h]]) -> handle, w, h | nil, why: a PNG / JPEG / BMP, fitted inside
// max_w x max_h; uploaded on the next frame.
int __cdecl l_tex_load(lua_State* L) {
    service_wants();
    if (g_lua.gettop(L) < 1 || g_lua.type(L, 1) != kTString) return nil_why(L, "tex_load expects (path [, max_w, max_h])");
    double const mw = g_lua.gettop(L) >= 2 && g_lua.type(L, 2) == kTNumber ? g_lua.tonumber(L, 2) : 0;
    double const mh = g_lua.gettop(L) >= 3 && g_lua.type(L, 3) == kTNumber ? g_lua.tonumber(L, 3) : 0;
    if (!(mw >= 0 && mw <= 4096 && mh >= 0 && mh <= 4096)) return nil_why(L, "tex_load: size limit 0-4096");
    std::size_t n = 0;
    char const* path = g_lua.tolstring(L, 1, &n);
    std::string err;
    // 1.2.1: read, hash and size here (stb_image's info: the header only), never decoded on this
    // thread. A picture some module holds in the cache gets this module's hold too (nc_hold): no
    // decode at all, and no sweep can release it before this module's frame attaches it (1.1.0 only
    // asked nc_has and left a blank frame when that happened). Any other picture is decoded on the
    // decode thread; its quads are drawn from the first frame after its pixels arrive.
    long long const t0 = qpc();
    Picture pic;
    std::vector<unsigned char> bytes;
    {
        WorkerRead r;
        if (!TextureStore::prepare(std::string(path, n), int(mw), int(mh), pic, err, &bytes))
            return nil_why(L, err.c_str());
    }
    NcKey const key = picture_key(pic.max_w, pic.max_h, pic.hash);
    // 1.2.6: a deferred file has no hash yet (the decode thread reads it): no hold, it is decoded
#if defined(NUI_FAULT_NO_HOLD)            // self-test: 1.1.0's skip, a module holds it now but this one does not
    bool const hit = !pic.deferred && nc_has(key);
#else
    bool const hit = !pic.deferred && nc_hold(key, &pic.held) == NC_HIT;
#endif
    bool decode_here = false;
#if defined(NUI_FAULT_ALWAYS_DECODE)      // self-test: 1.2.0, every picture decoded on the Lua thread
    nc_release(pic.held);
    decode_here = true;
#elif defined(NUI_FAULT_SYNC_DECODE)      // self-test: a picture nobody holds decoded on the Lua thread
    decode_here = !hit;
#endif
    if (decode_here) {
        long long const d0 = qpc();
        int dw = 0, dh = 0;
        if (pic.deferred && read_file(pic.path, bytes)) pic.hash = nc_fnv1a64(bytes.data(), bytes.size());
        bool const ok = decode_image_mem(bytes.data(), bytes.size(), pic.max_w, pic.max_h, pic.px, dw, dh, err);
        long long const dt = qpc() - d0;
        ++g_pw.decodes;
        g_pw.t_decode += dt;
        if (dt > g_pw.t_decode_max) g_pw.t_decode_max = dt;
        if (!ok) return nil_why(L, decode_error(pic.path, err).c_str());   // review REND-4
    } else if (!hit) {
        pic.job = ++g_job_next;
    }
    int const w = pic.w, hh = pic.h;
    if (pic.read > g_pw.tex_read_max) g_pw.tex_read_max = pic.read;
    std::uint64_t const job = pic.job;
    std::string const file = job ? pic.path : std::string();
    wlock();
    int const handle = g_store.next++;
    g_store.pics[handle] = std::move(pic);
    wunlock();
    if (job) queue_decode(job, handle, file, std::move(bytes), int(mw), int(mh));
    ++g_pw.tex_loads;
    if (hit) ++g_pw.holds;
    long long const t = qpc() - t0;
    if (t > g_pw.t_tex_load_max) g_pw.t_tex_load_max = t;
    g_lua.pushnumber(L, handle);
    g_lua.pushnumber(L, w);
    g_lua.pushnumber(L, hh);
    return 3;
}

// tex_free(handle) -> true | nil
int __cdecl l_tex_free(lua_State* L) {
    double const h = g_lua.gettop(L) >= 1 && g_lua.type(L, 1) == kTNumber ? g_lua.tonumber(L, 1) : 0;
    if (!(h >= 2 && h == std::floor(h))) return nil_why(L, "tex_free expects a picture handle");
    std::vector<DecodeJob> trash;
    std::vector<DecodeDone> trash_done;
    wlock();
    auto it = g_store.pics.find(int(h));
    if (it != g_store.pics.end()) {
        nc_release(it->second.held);      // 1.2.1: a hold never attached
        cancel_decode(it->second.job, trash, trash_done);
    }
    bool const ok = g_store.free(int(h));
    g_be.drop(int(h));
    g_want.erase(int(h));
    g_failed.erase(int(h));
    wunlock();
    if (!ok) return nil_why(L, "tex_free: no such texture");
    g_lua.pushboolean(L, 1);
    return 1;
}

// icon(item_id) -> true | false: whether the game has an icon for the item
int __cdecl l_icon(lua_State* L) {
    service_wants();
    double const id = g_lua.gettop(L) >= 1 && g_lua.type(L, 1) == kTNumber ? g_lua.tonumber(L, 1) : 0;
    bool const has = id >= 1 && id <= 65535 && id == std::floor(id) && known_icon(int(id), false);
    g_lua.pushboolean(L, has);
    return 1;
}

// icon_pixels(item_id) -> 4096-byte BGRA string, 32 x 32 rows top first | nil (tests)
int __cdecl l_icon_pixels(lua_State* L) {
    double const id = g_lua.gettop(L) >= 1 && g_lua.type(L, 1) == kTNumber ? g_lua.tonumber(L, 1) : 0;
    uint32_t px[kIconCell * kIconCell];
    bool ok = false;
    if (!g_ffxi.empty() && id >= 1 && id <= 65535) {
        WorkerRead r;
        ok = item_icon(g_ffxi, int(id), px);
    }
    if (!ok) {
        g_lua.pushnil(L);
        return 1;
    }
    g_lua.pushlstring(L, reinterpret_cast<char const*>(px), sizeof(px));
    return 1;
}

// metrics() -> {moji = {96 advance widths}, title = {{w, h, top} x 95}, from_game} | nil: the fonts
// the DLL draws with, for Lua's layout (after start())
int __cdecl l_metrics(lua_State* L) {
    if (!g_assets) { g_lua.pushnil(L); return 1; }
    g_lua.createtable(L, 0, 3);
    g_lua.createtable(L, 96, 0);
    for (int i = 0; i < 96; ++i) {
        g_lua.pushnumber(L, g_assets->widths[i]);
        g_lua.rawseti(L, -2, i + 1);
    }
    g_lua.setfield(L, -2, "moji");
    // review REND-9: without the title font every glyph is {0, 1, 0} (no width, a height to divide by;
    // the DLL draws no title text then) and title_font is false
    bool const title_ok = g_assets->title_ok();
    g_lua.createtable(L, 95, 0);
    for (int i = 0; i < 95; ++i) {
        g_lua.createtable(L, 3, 0);
        g_lua.pushnumber(L, title_ok ? g_assets->title[i].lw : 0); g_lua.rawseti(L, -2, 1);
        g_lua.pushnumber(L, title_ok ? g_assets->title[i].lh : 1); g_lua.rawseti(L, -2, 2);
        g_lua.pushnumber(L, title_ok ? g_assets->title[i].top : 0); g_lua.rawseti(L, -2, 3);
        g_lua.rawseti(L, -2, i + 1);
    }
    g_lua.setfield(L, -2, "title");
    g_lua.pushboolean(L, title_ok ? 1 : 0);
    g_lua.setfield(L, -2, "title_font");
    // 1.2.3: the window title font's advances (ASCII 0x20..0x7E); absent when the font is missing
    if (g_assets->have_wtitle) {
        g_lua.createtable(L, 95, 0);
        for (int i = 0; i < 95; ++i) {
            g_lua.pushnumber(L, g_assets->wtitle[i].adv);
            g_lua.rawseti(L, -2, i + 1);
        }
        g_lua.setfield(L, -2, "wtitle");
    }
    g_lua.pushboolean(L, g_assets->widths_from_game ? 1 : 0);
    g_lua.setfield(L, -2, "from_game");
    return 1;
}

// wintype(n) -> true | nil, why: draw in window type n (1-8) from now on: that type's art and frame
// recipe (ROM/0/(13+n).DAT), loaded here on the Lua thread; every layer is rebuilt with the new
// recipe (outside the lock, then swapped in) and the atlas re-uploaded on the next frame. Before
// start(), only remembered for it.
int __cdecl l_wintype(lua_State* L) {
    service_wants();
    double const n = g_lua.gettop(L) >= 1 && g_lua.type(L, 1) == kTNumber ? g_lua.tonumber(L, 1) : 0;
    if (!(n >= 1 && n <= 8 && n == std::floor(n))) return nil_why(L, "wintype expects 1-8");
    if (g_ffxi.empty()) {
        g_window_type = int(n);
        g_lua.pushboolean(L, 1);
        return 1;
    }
    // 1.2.1: a type's atlas some module holds in the cache is held for this module too (nc_hold) and
    // not decoded: no sweep can release it before this module's frame attaches it (1.2.0 decoded
    // every time for that reason: a run of type switches leaves unheld atlases over the budget).
    // Otherwise decoded here, as before (a window type switch is rare; the frame needs the atlas).
    NcRef held;
#if defined(NUI_FAULT_ALWAYS_DECODE)      // self-test: 1.2.0
    bool const hit = false;
#else
    bool const hit = nc_hold(atlas_key(int(n), g_store.install), &held) == NC_HIT;
#endif
    auto* fresh = new Assets();
    bool const pixels = !hit;
    long long const d0 = qpc();
    // 1.2.10: the window art no longer has to be there (ui.cpp draws a plain frame without it), so
    // a type whose DAT cannot be read is still switched to rather than refused
    if (!fresh->load(g_ffxi, int(n), 39542, pixels)) {
        std::string const msg = "wintype: assets missing: " + fresh->log;
        delete fresh;
        nc_release(held);
        return nil_why(L, msg.c_str());
    }
    if (pixels) {
        long long const dt = qpc() - d0;
        ++g_pw.decodes;
        g_pw.t_decode += dt;
        if (dt > g_pw.t_decode_max) g_pw.t_decode_max = dt;
    } else {
        ++g_pw.holds;
    }
    std::vector<std::pair<int, DrawList>> rebuilt;
    for (int i = 1; i <= kLayers; ++i)
        if (g_layers[i].used) {
            rebuilt.emplace_back(i, DrawList());
            build_layer(g_layers[i], rebuilt.back().second, *fresh);
        }
    wlock();
    Assets* old = g_assets;
    g_assets = fresh;
    g_window_type = int(n);
    std::swap(g_atlas_held, held);       // the previous type's hold, if never attached, is given back below
    nc_release(held);
    g_be.drop(kTexAtlas);                // next frame: this type's atlas (the hold, or from the cache)
    g_want.erase(kTexAtlas);
    g_failed.erase(kTexAtlas);
    g_atlas_failed = false;
    for (auto& r : rebuilt) {
        std::swap(g_layers[r.first].dl, r.second);
        g_layers[r.first].key = ++g_next_key;
    }
    wunlock();
    delete old;
    g_lua.pushboolean(L, 1);
    return 1;
}

// Fallback if read_config fails on a future client: wtfind(v) narrows
// candidates in FFXiMain's writable sections as a memory scanner does: the first call (or
// wtfind(v, true)) keeps every byte equal to v (1-based) or v - 1 (0-based); each later call, made
// after switching the type in the game's Config, keeps those that now read the new value in the same
// encoding. -> count, {"rva:enc", ...} (up to 16). wtwatch(rva, enc) then follows one: wtread() ->
// the type (1-8) or nil.
struct Cand {
    std::uint32_t rva;
    unsigned char enc;                   // 1 = stored 1-based, 0 = stored 0-based
};
std::vector<Cand> g_cands;
bool g_cands_started = false;
std::uintptr_t g_wt_addr = 0;
int g_wt_enc = 1;

int __cdecl l_wtfind(lua_State* L) {
    double const v = g_lua.gettop(L) >= 1 && g_lua.type(L, 1) == kTNumber ? g_lua.tonumber(L, 1) : 0;
    bool const restart = g_lua.gettop(L) >= 2 && g_lua.toboolean(L, 2);
    if (!(v >= 1 && v <= 8 && v == std::floor(v))) {
        g_lua.pushnil(L);
        g_lua.pushstring(L, "wtfind expects the window type now set in Config (1-8)");
        return 2;
    }
    std::uintptr_t const base = ffxi_base();
    if (!base) {
        g_lua.pushnil(L);
        g_lua.pushstring(L, "FFXiMain.dll is not loaded");
        return 2;
    }
    auto const one = static_cast<unsigned char>(v), zero = static_cast<unsigned char>(v - 1);
    if ((restart || !g_cands_started) && v == 1) {
        g_lua.pushnil(L);   // 0-based type 1 is a zero byte: most of .data
        g_lua.pushstring(L, "start the search from a window type other than 1");
        return 2;
    }
    if (restart || !g_cands_started) {
        g_cands.clear();
        g_cands_started = true;
        for (Section const& sec : ffxi_sections()) {
            if (!sec.write || sec.exec) continue;
            each_readable_run(sec.start, sec.start + sec.size, [&](std::uintptr_t a, unsigned char const* b, std::size_t n) {
                for (std::size_t i = 0; i < n; ++i) {
                    if (b[i] == one) g_cands.push_back({std::uint32_t(a + i - base), 1});
                    else if (b[i] == zero) g_cands.push_back({std::uint32_t(a + i - base), 0});
                }
            });
        }
    } else {
        std::vector<Cand> keep;
        for (Cand const& c : g_cands) {
            std::uintptr_t const a = base + c.rva;
            if (!span_readable(a, 1)) continue;
            unsigned char const b = *reinterpret_cast<unsigned char const*>(a);
            if ((c.enc == 1 && b == one) || (c.enc == 0 && b == zero)) keep.push_back(c);
        }
        g_cands.swap(keep);
    }
    g_lua.pushnumber(L, double(g_cands.size()));
    g_lua.createtable(L, 16, 0);
    for (std::size_t i = 0; i < g_cands.size() && i < 16; ++i) {
        char b[32];
        std::snprintf(b, sizeof(b), "%08lx:%d", (unsigned long)g_cands[i].rva, int(g_cands[i].enc));
        g_lua.pushstring(L, b);
        g_lua.rawseti(L, -2, int(i) + 1);
    }
    return 2;
}

// wtwatch(rva, enc) or wtwatch() to stop -> true | nil, why
int __cdecl l_wtwatch(lua_State* L) {
    if (g_lua.gettop(L) < 1 || g_lua.type(L, 1) == kTNil) {
        g_wt_addr = 0;
        g_lua.pushboolean(L, 1);
        return 1;
    }
    double const rva = g_lua.type(L, 1) == kTNumber ? g_lua.tonumber(L, 1) : -1;
    double const enc = g_lua.gettop(L) >= 2 && g_lua.type(L, 2) == kTNumber ? g_lua.tonumber(L, 2) : 1;
    std::uintptr_t const base = ffxi_base();
    if (!base || !(rva >= 0 && rva < 0x2000000 && rva == std::floor(rva)) || !(enc == 0 || enc == 1)) {
        g_lua.pushnil(L);
        g_lua.pushstring(L, "wtwatch expects (rva, enc 0|1) with the game loaded");
        return 2;
    }
    g_wt_addr = base + std::uintptr_t(rva);
    g_wt_enc = int(enc);
    g_lua.pushboolean(L, 1);
    return 1;
}

// wtread() -> the window type set in the game's Config (1-8), source ("config" | "watch") | nil
int __cdecl l_wtread(lua_State* L) {
    service_wants();
    int v = -1;
    if (!g_wt_addr && read_config(18, v) && v >= 0 && v <= 7) {
        g_lua.pushnumber(L, v + 1);
        g_lua.pushstring(L, "config");
        return 2;
    }
    if (!g_wt_addr || !span_readable(g_wt_addr, 1)) {
        g_lua.pushnil(L);
        return 1;
    }
    int const t = *reinterpret_cast<unsigned char const*>(g_wt_addr) + (g_wt_enc == 0 ? 1 : 0);
    if (t < 1 || t > 8) {
        g_lua.pushnil(L);
        return 1;
    }
    g_lua.pushnumber(L, t);
    g_lua.pushstring(L, "watch");
    return 2;
}

void set_num(lua_State* L, char const* k, double v) { g_lua.pushnumber(L, v); g_lua.setfield(L, -2, k); }
void set_str(lua_State* L, char const* k, char const* v) { g_lua.pushstring(L, v); g_lua.setfield(L, -2, k); }
void set_bool(lua_State* L, char const* k, bool v) { g_lua.pushboolean(L, v ? 1 : 0); g_lua.setfield(L, -2, k); }

char const* hook_state_name(int st) {
    switch (st) {
    case UIHOOK_LIVE: return "live";
    case UIHOOK_WAIT: return "waiting";
    case UIHOOK_BLOCKED: return "blocked";
    default: return "no bus";
    }
}

int __cdecl l_status(lua_State* L) {
    service_wants();
    char buf[64];
    g_lua.createtable(L, 0, 48);
    set_str(L, "version", g_cfg->version);
    set_bool(L, "running", g_running);
    set_str(L, "message", g_status);
    set_str(L, "hook", g_bus ? g_bus->status : "not attached");
    set_str(L, "hook_state", hook_state_name(uihook_state(g_bus)));
    {
        char line[512];
        uihook_describe(g_bus, line, sizeof(line));
        set_str(L, "describe", g_bus ? line : "not attached");
    }
    if (g_bus) {
        set_num(L, "clients", uihook_active_clients(g_bus));
        set_num(L, "installs", g_bus->installs);
        set_bool(L, "owner", g_slot >= 0 && g_bus->owner_slot == g_slot);
        set_num(L, "owner_rev", g_bus->owner_rev);
        set_num(L, "rev", UIHOOK_REV);
        std::snprintf(buf, sizeof(buf), "%08lx", (unsigned long)g_bus->site);
        set_str(L, "site", buf);
    }
    set_num(L, "slot", g_slot);
    set_num(L, "native_errors", g_native_errors);     // 1.2.5: calls and frames an exception ended (HOST-1)
    set_num(L, "final_render", g_final_render);       // 1.2.5: stops given back on the render thread (REND-5)
    wlock();
    set_num(L, "pending_releases", double(g_be.pending.size()));   // 1.2.5: private textures waiting for a draw
    // 1.2.6 (review HOST-4): running, and not held back by a failed atlas upload (true again by itself
    // once the retry after the backoff succeeds). Consumers gate their input on it.
    set_bool(L, "drawing", g_running && !g_atlas_failed);
    wunlock();
    std::snprintf(buf, sizeof(buf), "%08lx", (unsigned long)g_last_device);
    set_str(L, "device", buf);
    set_bool(L, "device_ok", g_last_device != 0 && g_devcheck.ok);
    set_num(L, "calls", g_calls);
    set_num(L, "drawn", g_drawn);
    set_num(L, "no_device", g_no_device);
    set_num(L, "uploads", g_uploads);
    set_num(L, "rebuilds", g_rebuilds);
    set_num(L, "last_us", g_last_us);
    set_num(L, "max_us", g_max_us);
    set_num(L, "build_us", g_build_us);
    set_str(L, "prof_rule", g_fallback ? "all" : "bb");     // 1.2.0: draw on the back-buffer call only, or on every call
    set_bool(L, "bb_fallback", g_fallback);
    {
        wlock();
        double quads = 0, batches = 0, vbytes = 0;
        int layers = 0;
        for (int i = 1; i <= kLayers; ++i)
            if (g_layers[i].used) {
                ++layers;
                quads += double(g_layers[i].dl.v.size() / 6);
                batches += double(g_layers[i].dl.batches.size());
                vbytes += double(g_layers[i].dl.v.capacity() * sizeof(Vtx));
            }
        for (auto const& x : g_be.xcache) vbytes += double(x.v.capacity() * sizeof(Vtx));
        double tex_kb = 0, cpu_kb = 0, shared_kb = 0;
        int n_shared = 0, n_private = 0;
        for (auto const& kv : g_be.tex) {
            double const kb = double(kv.second.w) * kv.second.h * 4 / 1024;
            tex_kb += kb;
            if (kv.second.ref.entry >= 0) { ++n_shared; shared_kb += kb; } else { ++n_private; }
        }
        for (auto const& kv : g_store.pics) cpu_kb += double(kv.second.px.capacity()) * 4 / 1024;
        for (auto const& kv : g_store.icons) cpu_kb += double(kv.second.px.capacity()) * 4 / 1024;
        if (g_assets) cpu_kb += double(g_assets->atlas.capacity()) * 4 / 1024;
        int const pics = int(g_store.pics.size());
        std::snprintf(buf, sizeof(buf), "%08lx", (unsigned long)reinterpret_cast<std::uintptr_t>(g_be.get(kTexAtlas)));
        std::string const atlas_ptr = buf;
        int const icons = int(g_icons.size());
        wunlock();
        // the shared texture cache (C.9): this module's view, then the process-wide counters
        NcStatus cs;
        nc_status(&cs);
        g_lua.createtable(L, 0, 24);
        set_bool(L, "shared", cs.shared != 0);
        set_str(L, "why", cs.why);
        set_num(L, "slot", cs.slot);
        set_num(L, "gen", cs.gen);
        set_num(L, "shared_textures", n_shared);
        set_num(L, "private_textures", n_private);
        set_num(L, "shared_kb", shared_kb);
        set_num(L, "my_shared_refs", cs.my_shared);
        set_num(L, "my_private_refs", cs.my_private);
        set_num(L, "hits", g_hits);
        set_num(L, "creates", g_creates);
        set_num(L, "privates", g_privates);
        set_num(L, "busy", g_busy);
        set_num(L, "skipped", g_skipped);
        set_num(L, "resets", g_resets);
        set_str(L, "atlas_ptr", atlas_ptr.c_str());
        set_num(L, "icons", icons);
        set_num(L, "live_entries", cs.live_entries);
        set_num(L, "live_kb", double(cs.live_bytes) / 1024);
        set_num(L, "unheld_kb", double(cs.unheld_bytes) / 1024);
        set_num(L, "all_creates", cs.creates);
        set_num(L, "all_hits", cs.hits);
        set_num(L, "fallbacks", cs.fallbacks);
        set_num(L, "max_rev", cs.max_rev);
        g_lua.createtable(L, int(cs.clients), 0);
        for (long i = 0; i < cs.clients; ++i) {
            g_lua.pushstring(L, cs.client_names[i]);
            g_lua.rawseti(L, -2, int(i) + 1);
        }
        g_lua.setfield(L, -2, "clients");
        g_lua.setfield(L, -2, "cache");
        set_num(L, "layers", layers);
        set_num(L, "quads", quads);
        set_num(L, "batches", batches);
        set_num(L, "grey_ok", g_be.grey_caps);        // 1.1.0: 1 grey drawn grey, 0 in colour (device lacks the ops), -1 no frame yet
        set_num(L, "vertex_kb", vbytes / 1024);
        set_num(L, "texture_kb", tex_kb);
        set_num(L, "cpu_pixels_kb", cpu_kb);
        set_num(L, "pictures", pics);
        set_num(L, "decodes_pending", g_jobs);       // 1.2.1: pictures queued for or on the decode thread
    }
    set_num(L, "rt_w", g_rt_w);
    set_num(L, "rt_h", g_rt_h);
    set_num(L, "screen_w", g_screen_w);
    set_num(L, "screen_h", g_screen_h);
    set_num(L, "scale", g_scale);
    set_num(L, "view_f", g_view_f);
    set_num(L, "window_type", g_window_type);
    {
        int v = -1;
        set_bool(L, "config_read", read_config(18, v));        // also runs the one-time search
        std::snprintf(buf, sizeof(buf), "%08lx", (unsigned long)config_global());
        set_str(L, "cfg_ptr", buf);
    }
    {
        int uw = 0, uh = 0;
        set_bool(L, "ui_found", read_ui_size(uw, uh));
        set_num(L, "ui_w", uw);
        set_num(L, "ui_h", uh);
        std::snprintf(buf, sizeof(buf), "%08lx", (unsigned long)ui_size_global());
        set_str(L, "ui_ptr", buf);
    }
    set_bool(L, "scale_auto", g_scale_auto);
    set_str(L, "assets", g_assets ? g_assets->log.c_str() : "not loaded");
    return 1;
}

// prof() -> table (1.2.0): the profiler's counters since the last prof() (then reset). A copy of a
// few PODs; the render thread waits at most for that copy. See host.hpp for the fields.
int __cdecl l_prof(lua_State* L) {
    service_wants();
    ProfRender r;
    if (g_lock_ready) EnterCriticalSection(&g_plock);
    r = g_pr;
    std::memset(&g_pr, 0, sizeof(g_pr));
    g_pr.tid = r.tid;
    if (g_lock_ready) LeaveCriticalSection(&g_plock);
    ProfWorker const w = g_pw;
    long long const now = qpc();
    std::memset(&g_pw, 0, sizeof(g_pw));
    g_pw.t0 = now;
    g_pw.tid = w.tid;
    double const draws = r.draws ? double(r.draws) : 1.0;
    g_lua.createtable(L, 0, 56);
    set_num(L, "wall_ms", us_of(now - w.t0) / 1000);
    // render thread: calls into the wrapper and which of them drew
    set_num(L, "calls", r.calls);
    set_num(L, "draws", r.draws);
    set_num(L, "calls_bb", r.calls_bb);
    set_num(L, "calls_other", r.calls_other);
    set_num(L, "no_device", r.no_device);
    set_bool(L, "bb_fallback", g_fallback);
    set_num(L, "bb_fallback_n", r.bb_fallback_n);
    set_num(L, "fallback_draws", r.fallback_draws);
    g_lua.createtable(L, 8, 0);
    int k = 0;
    for (RtSize const& s : r.rt)
        if (s.n) {
            g_lua.createtable(L, 0, 3);
            set_num(L, "w", s.w);
            set_num(L, "h", s.h);
            set_num(L, "n", s.n);
            g_lua.rawseti(L, -2, ++k);
        }
    g_lua.setfield(L, -2, "rt_sizes");
    set_num(L, "rt_more", r.rt_more);
    set_num(L, "us_draw_avg", us_of(r.t_draw) / draws);
    set_num(L, "us_draw_max", us_of(r.t_draw_max));
    set_num(L, "us_skip", us_of(r.t_skip));
    set_num(L, "wait_avg_us", r.calls ? us_of(r.t_wait) / double(r.calls) : 0);
    set_num(L, "wait_max_us", us_of(r.t_wait_max));
    set_num(L, "waits_over_50", r.waits_50);
    set_num(L, "batches", double(r.batches) / draws);
    set_num(L, "draw_calls", double(r.dps) / draws);
    set_num(L, "verts", double(r.verts) / draws);
    set_num(L, "xform_builds", r.xform_builds);
    set_num(L, "uploads", r.uploads);
    set_num(L, "us_upload_max", us_of(r.t_upload_max));
    set_num(L, "reads_render", r.reads);
    set_num(L, "us_read_render", us_of(r.t_read));
    set_num(L, "us_read_render_max", us_of(r.t_read_max));
    set_num(L, "wants", r.wants);
    set_num(L, "held_attached", r.held);
    set_num(L, "render_tid", r.tid);
    // worker (Lua) thread
    set_num(L, "layers", w.layers);
    set_num(L, "removes", w.removes);
    set_num(L, "layer_us_avg", w.layers ? us_of(w.t_layer) / double(w.layers) : 0);
    set_num(L, "layer_us_max", us_of(w.t_layer_max));
    set_num(L, "layer_pos", w.layer_pos);
    set_num(L, "pos_same", w.pos_same);
    set_num(L, "builds", w.builds);
    set_num(L, "us_build", us_of(w.t_build));
    set_num(L, "w_locks", w.locks);
    set_num(L, "w_wait_avg_us", w.locks ? us_of(w.t_wait) / double(w.locks) : 0);
    set_num(L, "w_wait_max_us", us_of(w.t_wait_max));
    set_num(L, "w_waits_over_50", w.waits_50);
    set_num(L, "w_hold_avg_us", w.locks ? us_of(w.t_hold) / double(w.locks) : 0);
    set_num(L, "w_hold_max_us", us_of(w.t_hold_max));
    set_num(L, "reads_worker", w.reads);
    set_num(L, "us_read_worker", us_of(w.t_read));
    set_num(L, "us_read_worker_max", us_of(w.t_read_max));
    // 1.2.1: pictures and atlases: holds (no decode), decodes on this thread, the decode thread
    set_num(L, "tex_loads", w.tex_loads);
    set_num(L, "us_tex_load_max", us_of(w.t_tex_load_max));
    set_num(L, "tex_load_read_max", double(w.tex_read_max));     // 1.2.6: bytes, the most one tex_load read here
    set_num(L, "holds", w.holds);
    set_num(L, "decodes_worker", w.decodes);
    set_num(L, "us_decode_worker", us_of(w.t_decode));
    set_num(L, "us_decode_worker_max", us_of(w.t_decode_max));
    {
        EnterCriticalSection(&g_qlock);
        unsigned long const dn = g_dec_n, df = g_dec_fail, dc = g_dec_cancel;
        long long const dt = g_dec_t, dm = g_dec_t_max;
        g_dec_n = g_dec_fail = g_dec_cancel = 0;
        g_dec_t = g_dec_t_max = 0;
        LeaveCriticalSection(&g_qlock);
        set_num(L, "decodes_bg", dn);
        set_num(L, "us_decode_bg", us_of(dt));
        set_num(L, "us_decode_bg_max", us_of(dm));
        set_num(L, "decode_failed", df);
        set_num(L, "decode_cancelled", dc);
        set_num(L, "decodes_pending", g_jobs);
        prune_threads();
        set_num(L, "decode_threads", double(g_threads.size()));
    }
    set_num(L, "worker_tid", GetCurrentThreadId());
    return 1;
}

// us() -> microseconds since the module was opened, from the performance counter (1.2.0). Whole
// microseconds converted in integers, so the number is exact whatever the thread's FPU precision;
// a difference of two readings is exact below 2^24 us (16 s) even at 24-bit precision.
int __cdecl l_us(lua_State* L) {
    long long const t = qpc() - g_qpc0;
    long long const us = (t / g_qpc_f) * 1000000 + ((t % g_qpc_f) * 1000000) / g_qpc_f;
    g_lua.pushnumber(L, double(us));
    return 1;
}

// screen(w, h [, auto [, f]]) -> true | nil, why: the coordinate space Lua uses (mouse / Windower
// pixels). With auto, the draw is scaled by render-target width / w; otherwise drawn 1:1. f (0.25-4)
// multiplies that: one of Lua's units is f screen px (the game's UI scale, or a simulated screen).
int __cdecl l_screen(lua_State* L) {
    service_wants();
    if (g_lua.gettop(L) < 2 || g_lua.type(L, 1) != kTNumber || g_lua.type(L, 2) != kTNumber) {
        g_lua.pushnil(L);
        g_lua.pushstring(L, "screen expects (w, h [, auto])");
        return 2;
    }
    double const w = g_lua.tonumber(L, 1), h = g_lua.tonumber(L, 2);
    if (!(w >= 0 && w <= 16384 && h >= 0 && h <= 16384)) {
        g_lua.pushnil(L);
        g_lua.pushstring(L, "screen size out of range");
        return 2;
    }
    wlock();
    g_screen_w = int(w);
    g_screen_h = int(h);
    g_scale_auto = g_lua.gettop(L) >= 3 && g_lua.toboolean(L, 3);
    double const f = g_lua.gettop(L) >= 4 && g_lua.type(L, 4) == kTNumber ? g_lua.tonumber(L, 4) : 1.0;
    g_view_f = (f >= 0.25 && f <= 4.0) ? float(f) : 1.0f;
    wunlock();
    g_lua.pushboolean(L, 1);
    return 1;
}

// 1.2.5 (review HOST-1): every Lua function is called through a guard. An exception (out of memory)
// leaves any lock the Lua thread holds and returns nil plus a reason, the API's usual failure shape.
int guard_call(lua_CFunction f, lua_State* L) {
    char const* why = "native error";
    try {
        return f(L);
    } catch (std::bad_alloc const&) {
        why = "out of memory";
    } catch (...) {
    }
    InterlockedIncrement(&g_native_errors);
    leave_held_locks();
    g_lua.pushnil(L);
    g_lua.pushstring(L, why);
    return 2;
}

template <lua_CFunction F>
int __cdecl guarded(lua_State* L) {
    return guard_call(F, L);
}

// the module's own functions (host_open's extra), each behind one of these fixed slots
constexpr int kExtraSlots = 16;
lua_CFunction g_extra_fn[kExtraSlots] = {};
template <int I>
int __cdecl guarded_extra(lua_State* L) {
    return guard_call(g_extra_fn[I], L);
}
lua_CFunction const g_extra_tramp[kExtraSlots] = {
    guarded_extra<0>, guarded_extra<1>, guarded_extra<2>, guarded_extra<3>, guarded_extra<4>, guarded_extra<5>,
    guarded_extra<6>, guarded_extra<7>, guarded_extra<8>, guarded_extra<9>, guarded_extra<10>, guarded_extra<11>,
    guarded_extra<12>, guarded_extra<13>, guarded_extra<14>, guarded_extra<15>};

}  // namespace

int host_open(lua_State* L, HostConfig const& cfg, HostFn const* extra, int n_extra) {
    if (!bind_lua()) return 0;
    g_cfg = &cfg;
    pad_set_name(cfg.name);
    key_set_name(cfg.name);
    if (!g_lock_ready) {
        InitializeCriticalSection(&g_lock);
        InitializeCriticalSection(&g_plock);
        InitializeCriticalSection(&g_qlock);
        g_lock_ready = true;
        LARGE_INTEGER f;
        QueryPerformanceFrequency(&f);
        g_qpc_f = f.QuadPart > 0 ? f.QuadPart : 1;
        g_qpc_us = 1e6 / double(g_qpc_f);
        g_qpc0 = qpc();
        g_pw.t0 = g_qpc0;
    }
    g_lua.createtable(L, 0, 32 + (n_extra > 0 ? n_extra : 0));
    static HostFn const fns[] = {{"version", guarded<l_version>}, {"start", guarded<l_start>}, {"stop", guarded<l_stop>},
                                 {"status", guarded<l_status>}, {"screen", guarded<l_screen>}, {"layer", guarded<l_layer>},
                                 {"layer_pos", guarded<l_layer_pos>}, {"tex_load", guarded<l_tex_load>},
                                 {"tex_free", guarded<l_tex_free>}, {"icon", guarded<l_icon>},
                                 {"icon_pixels", guarded<l_icon_pixels>}, {"metrics", guarded<l_metrics>},
                                 {"wintype", guarded<l_wintype>}, {"wtfind", guarded<l_wtfind>},
                                 {"wtwatch", guarded<l_wtwatch>}, {"wtread", guarded<l_wtread>},
                                 {"prof", guarded<l_prof>}, {"us", guarded<l_us>},
                                 // the controller (pad.hpp)
                                 {"pad_start", guarded<l_pad_start>}, {"pad", guarded<l_pad>},
                                 {"pad_capture", guarded<l_pad_capture>}, {"pad_chord", guarded<l_pad_chord>},
                                 {"pad_config", guarded<l_pad_config>},
                                 {"pad_status", guarded<l_pad_status>}, {"pad_stop", guarded<l_pad_stop>},
                                 // keys hidden from the game alone (key.hpp)
                                 {"key_start", guarded<l_key_start>}, {"key_hide", guarded<l_key_hide>},
                                 {"key_status", guarded<l_key_status>}, {"key_stop", guarded<l_key_stop>}};
    for (HostFn const& fn : fns) {
        g_lua.pushcclosure(L, fn.f, 0);
        g_lua.setfield(L, -2, fn.name);
    }
    for (int i = 0; extra && i < n_extra; ++i) {
        lua_CFunction f = extra[i].f;
        if (i < kExtraSlots) {            // more than 16 extra functions: the rest unguarded, as before 1.2.5
            g_extra_fn[i] = f;
            f = g_extra_tramp[i];
        }
        g_lua.pushcclosure(L, f, 0);
        g_lua.setfield(L, -2, extra[i].name);
    }
    return 1;
}

void host_detach() {
    // the one teardown that runs however the addon goes away; never wait here (loader lock)
    g_running = false;
    uihook_unregister(g_bus, g_slot, false);
    g_slot = -1;
    pad_detach();      // the pad hook's dispatch handed on before this code unmaps
    key_detach();      // and the key hook's
    nc_detach();       // holder bits and the cache client slot, lock-free; textures stay for a sweep
}

}  // namespace nui
