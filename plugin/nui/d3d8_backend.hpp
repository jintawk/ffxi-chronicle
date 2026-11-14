// d3d8_backend.hpp - draws nui::DrawLists on an IDirect3DDevice8. The same code runs inside the
// game (from a hook after the game's own UI pass) and in the offline renderer (offline.cpp).
// Chronicle v2: textures by handle (textures.hpp), several lists per frame under one state save.
#pragma once
#include "cache.hpp"
#include "ui.hpp"

#include <d3d8.h>

#include <cstdint>
#include <map>
#include <vector>

namespace nui {

struct D3D8Backend {
    IDirect3DDevice8* dev = nullptr;
    // handle -> texture (0 the atlas). Every texture is a cache ref (cache.hpp): shared (borrowed
    // from the cache) or private (this module's own), given back with nc_release.
    struct Tex { IDirect3DTexture8* t = nullptr; int w = 0, h = 0; NcRef ref {}; };
    std::map<int, Tex> tex;
    // in game: the render target's size; > 0 sets a full-target viewport for the draw and restores
    // the game's afterwards. Offline it stays 0 and the viewport is not touched.
    int rt_w = 0, rt_h = 0;
    float scale = 1.0f;          // draw-list pixels -> render-target pixels (1 = 1:1)
    int grey_caps = -1;          // kGrey batches: drawn grey (1), in colour (0: the device lacks the ops), not asked yet (-1)
    // 1.2.0: bumped by every attach / drop / release, so a kept list knows its UVs may be stale
    unsigned tex_gen = 0;
    // 1.2.0: the last draw(): batches drawn, DrawPrimitiveUP calls, vertices; lists transformed anew (total)
    unsigned long last_batches = 0, last_dps = 0, last_verts = 0, xform_builds = 0;

    bool init(IDirect3DDevice8* d);
    void attach(int handle, NcRef const& ref);     // takes the ref (a texture from nc_acquire)
    void drop(int handle);                         // nc_release it (a private texture: queued, see pending)
    bool has(int handle) const { return tex.count(handle) != 0; }
    IDirect3DTexture8* get(int handle) const { auto it = tex.find(handle); return it == tex.end() ? nullptr : it->second.t; }
    // saves every state it changes and restores it afterwards; lists in order (back to front)
    void draw(std::vector<DrawList const*> const& lists) { draw(lists, nullptr); }
    void draw(DrawList const& dl) { draw(std::vector<DrawList const*>{&dl}); }
    // 1.2.0: keys[i] names lists[i]'s content (a new key for every rebuilt list, never reused): its
    // vertices are kept transformed (scale, half pixel) and UV-normalised, and made again only when
    // the key, the scale or a texture (tex_gen) changed. keys null: every list made anew each draw.
    void draw(std::vector<DrawList const*> const& lists, std::vector<std::uint64_t> const* keys);
    void release();                                // nc_release every texture (private ones: queued)
    // 1.2.5: private textures (this module's own reference, entry < 0) dropped or released here wait
    // in `pending` until flush_pending() on the render thread. The game's device is not created
    // multithreaded, so no Release may run on the Lua thread while the game draws (review REND-5).
    // Shared refs are a lock-free holder-bit clear and go at once. Callers hold the host's g_lock.
    std::vector<NcRef> pending;
    void flush_pending();
    // 1.2.5: the last draw() ran out of memory (or threw) part way: the game's state was restored,
    // the vertex cache dropped, and the rest of that frame not drawn (review HOST-1)
    bool last_failed = false;

    struct Xform {               // one list's vertices as drawn
        std::uint64_t key = 0;
        float scale = 0;
        unsigned tex_gen = 0;
        bool used = false;
        std::vector<Vtx> v;
    };
    std::vector<Xform> xcache;
};

// A managed A8R8G8B8 texture holding argb (w x h rows, top first), with one reference: the body of
// every cache create callback. Null on failure.
IDirect3DTexture8* create_texture(IDirect3DDevice8* dev, uint32_t const* argb, int w, int h);

}  // namespace nui
