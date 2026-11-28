// host.hpp - the generic native-UI module: everything a `_<name>.dll` Lua module does, so the
// module itself is only glue (luaopen__<name> + DllMain).
//
// It joins UiHook (UiHook/UiHook.h, one shared patch of FFXiMain's EndScene wrapper for every
// module) and, each time the wrapper runs, draws the module's layers with the D3D8 backend on the
// device the game is about to EndScene. Lua lays every window out and sends drawing commands
// (ops.cpp) as LAYERS: up to 16, drawn back to front by z. Each layer's commands are parsed once
// and kept, so moving or scrolling a layer (layer_pos) only replays them with an offset and a clip.
// Textures are handles: 0 the atlas of game art (window type art, fonts, gauge), 2+ pictures
// decoded from files, one handle per item icon (cut from the item DATs on demand). Every texture
// comes from the per-process shared cache (cache.hpp, NuiCache/NuiCache.h): modules that draw the
// same atlas, icon or picture (same bytes) hold ONE texture; a module that finds one there decodes
// nothing and holds it (1.2.1: nc_hold, so no sweep loses it before this module's first frame). No texture keeps a CPU copy once made; a new device (any module may see it first) makes
// them again. Every render state touched is restored. Assets come from the game install,
// read-only. DllMain(DLL_PROCESS_DETACH) (host_detach) releases the UiHook slot and the cache's
// holder bits unconditionally, without waiting and without a D3D call.
//
// The module table host_open pushes (Lua):
//   version()                                  the module's version string
//   start([ffxi_dir [, flags]]) -> ok, msg [, retry_ms]
//        loads the art, then joins UiHook. retry_ms (UIHOOK_RETRY_MS) when the hook is not there
//        yet and calling start again later can succeed; no retry_ms when it never can (an ABI 1
//        pre-release patch, the bus full). flags (any of, in one string): "nosig" search for a
//        deliberately wrong signature (the fail-closed test); "noshare" keep this module's own
//        textures, not the shared cache's (an escape hatch; the pixels are the same). ffxi_dir
//        (offline tests) overrides the folder of FFXiMain.dll.
//   stop() -> "stopped"                        leave UiHook and the cache, release every texture and layer
//   status() -> table                          counters, hook state (hook, hook_state, describe,
//                                              owner_rev, clients, installs, owner, site, slot), ...,
//                                              1.2.6: drawing (running and not held back by a failed
//                                              atlas upload, which is retried after a 2 s backoff),
//                                              cache = {shared, why, slot, gen, shared_textures,
//                                              private_textures, hits, creates, live_entries, live_kb,
//                                              unheld_kb, clients = {"chronicle 2.0.0", ...}, ...}
//   screen(w, h [, auto [, f]])                the coordinate space Lua uses
//   layer(id, z, text) | layer(id)             a layer's commands, or remove it
//                                              (ops.cpp; 1.1.0: Q filter + 2 and I fx 2 draw grey)
//   layer_pos(id, ox, oy [, x0, y0, x1, y1])   move / clip a layer without re-sending it
//   tex_load(path [, max_w, max_h]) -> h, w, h | tex_free(h)
//                                              1.2.1: reads, hashes and sizes the file (header only);
//                                              held from the cache when a module has it, else decoded on
//                                              the module's decode thread and drawn from the first frame
//                                              after the pixels arrive. A body that does not decode is
//                                              never drawn (prof decode_failed), no error. 1.2.6: a
//                                              file over 1 MiB is read and hashed on the decode thread
//                                              (and so never held from another module's cache entry).
//   icon(item_id) -> bool | icon_pixels(item_id) -> 4096-byte BGRA string
//   metrics() -> {moji, title, wtitle, from_game, title_font}  the fonts, for Lua's layout (wtitle: window
//                                              title advances, 1.2.3; 1.2.6: title_font false = no title
//                                              font, every title glyph {0, 1, 0})
//   wintype(n)                                 draw in window type n (1-8)
//   wtread() -> type, "config" | "watch"       the game's window type (config id 18)
//   wtfind(v [, restart]) / wtwatch(rva, enc)  fallback scanner for wtread on a future client
//   prof() -> table                            1.2.0: the profiler's counters since the last prof(),
//                                              then reset (a POD copy; costs nothing between calls):
//        render thread: wall_ms, calls, draws, calls_bb, calls_other, no_device, bb_fallback (now),
//        bb_fallback_n (times it engaged), fallback_draws, rt_sizes = {{w, h, n}, ...} (up to 8 sizes
//        of the target bound per call) + rt_more, us_draw_avg / us_draw_max (per draw), us_skip (total
//        in calls not drawn), wait_avg_us / wait_max_us / waits_over_50 (waiting for g_lock), batches /
//        draw_calls / verts (per draw), xform_builds (lists transformed anew), uploads + us_upload_max
//        (textures made), reads_render + us_read_render(_max) (files read on the render thread: the
//        worker had not supplied the pixels), wants (pixels asked of the worker), render_tid;
//        worker (Lua) thread: layers, removes, layer_us_avg / layer_us_max, layer_pos, pos_same (no
//        rebuild), builds, us_build, w_locks, w_wait_avg_us / w_wait_max_us / w_waits_over_50,
//        w_hold_avg_us / w_hold_max_us, reads_worker + us_read_worker(_max), worker_tid;
//        1.2.1: tex_loads, us_tex_load_max, holds (pictures / atlases held from the cache, not decoded),
//        decodes_worker + us_decode_worker(_max) (decoded on the Lua thread: wintype's atlas when
//        nobody holds it), held_attached (render: holds drawn); the decode thread: decodes_bg,
//        us_decode_bg(_max), decode_failed, decode_cancelled, decodes_pending (now), decode_threads (now);
//        1.2.6: tex_load_read_max (bytes: the most one tex_load read on the Lua thread)
//   us() -> number                             1.2.0: microseconds since the module was opened (QPC)
//   pad_start, pad, pad_capture, pad_chord, pad_config, pad_status, pad_stop
//                                              the controller the game reads (pad.hpp)
//
// Threads (1.2.0): Lua runs on the addon's worker thread, the draw on the game's render thread.
// The worker parses and builds a layer and cuts icons before it locks, then swaps the finished work
// in; pictures are decoded on a decode thread of the module's own (1.2.1); the render thread draws once per displayed frame (the call that has the
// device's back buffer bound; on every call if none has for 500 ms: status().prof_rule "bb" | "all",
// bb_fallback) and never reads a file unless the worker failed to supply pixels for a second.
#pragma once
#include "luaapi.hpp"

namespace nui {

struct HostConfig {
    char const* name;        // UiHook client name (up to 15 chars, status only): "chronicle"
    char const* version;     // version() and status().version
};

struct HostFn {
    char const* name;
    lua_CFunction f;
};

// luaopen__<name>: binds Lua, pushes the module table (the functions above, then `extra`) and
// returns 1; 0 when no Lua host is loaded. cfg must outlive the module (a static).
int host_open(lua_State* L, HostConfig const& cfg, HostFn const* extra = nullptr, int n_extra = 0);

// DllMain(DLL_PROCESS_DETACH): leaves UiHook without waiting (loader lock). Nothing else.
void host_detach();

}  // namespace nui
