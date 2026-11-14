// ui.hpp - an immediate-mode 2D draw list and the widgets that build FFXI-looking windows from the
// game's own art (assets.hpp). No Direct3D here: the same list is drawn by the D3D8 backend in game
// and offline, which is what makes an offline render the in-game render.
//
// Textures are handles (0 = the atlas, others from
// textures.hpp), and texture coordinates stay in texels until the backend draws a batch, so a list
// does not need to know any texture's size.
#pragma once
#include "assets.hpp"

#include <cstdint>
#include <string>
#include <vector>

namespace nui {

enum Tex : int { kTexAtlas = 0 };
// a batch's filter: kPoint or kLinear, plus the kGrey flag (1.1.0): the quad's texture drawn
// desaturated (Rec. 601 luma, then times the vertex colour), by the backend's fixed-function stages
enum Filter : int { kPoint = 0, kLinear = 1, kGrey = 2 };

struct Vtx {
    float x, y, z, rhw;
    uint32_t col;      // D3DCOLOR 0xAARRGGBB
    float u, v;        // texels in a DrawList; normalised by the backend
};

struct Batch {
    int tex, filter, blend;      // filter: Filter bits (kGrey breaks a batch like any change); blend 0 = alpha, 1 = additive (the game's text)
    uint32_t first, count;   // vertices (triangle list)
};

struct Rect {
    float x0, y0, x1, y1;
};

inline uint32_t argb(int r, int g, int b, int a = 255) {
    auto c = [](int v) { return uint32_t(v < 0 ? 0 : v > 255 ? 255 : v); };
    return (c(a) << 24) | (c(r) << 16) | (c(g) << 8) | c(b);
}

struct DrawList {
    std::vector<Vtx> v;
    std::vector<Batch> batches;
    std::vector<Rect> clip {{-1e9f, -1e9f, 1e9f, 1e9f}};
    int blend = 0;               // applied to the quads that follow
    float ox = 0, oy = 0;        // translation applied to every quad that follows

    // empty, with `base` as the outermost clip rectangle
    void clear(Rect base = {-1e9f, -1e9f, 1e9f, 1e9f}) { v.clear(); batches.clear(); clip.assign(1, base); ox = oy = 0; }
    void push_clip(Rect r);
    void pop_clip() { if (clip.size() > 1) clip.pop_back(); }
    // a textured quad in pixels; uv in texture pixels; c[4] = TL TR BL BR colours
    void quad(int tex, int filter, float x0, float y0, float x1, float y1, float u0, float v0, float u1,
              float v1, uint32_t const c[4]);
    void quad(int tex, int filter, float x0, float y0, float x1, float y1, float u0, float v0, float u1,
              float v1, uint32_t c) { uint32_t cc[4] = {c, c, c, c}; quad(tex, filter, x0, y0, x1, y1, u0, v0, u1, v1, cc); }
};

// Reorder a finished list's quads into as few batches as overlap allows (1.2.0; ui.cpp says why the
// pixels are identical). Returns the batch count. ops_replay calls it; call it yourself after
// drawing into a list with the widgets directly. Lists not made of whole quads are left alone.
int merge_batches(DrawList& dl);

// Widgets. Coordinates are screen pixels (the game's UI at 1:1, as on the user's 4K client).
struct Ui {
    Assets const& a;
    DrawList& dl;

    // a window in the game's own type-N look, assembled from 'menu    win00' at any size
    void window(float x, float y, float w, float h, char const* title, bool active = false);
    void rect(float x0, float y0, float x1, float y1, uint32_t c);
    // moji text at 1:1; align 0 left, 1 right (x = right edge), 2 centre
    float text(float x, float y, std::string const& s, uint32_t c, int align = 0);
    float text_width(std::string const& s) const;
    // the italic serif title / nameplate font, `px` = cap height in pixels
    float title_text(float x, float y, std::string const& s, float px, uint32_t c, int align = 0);
    float title_width(std::string const& s, float px) const;
    // a window title in the game's window title font ('menu    menu2fon', 1:1): x = its left end, y = the
    // window's top edge; c multiplies the texels (Ui::window's titles: 0x60 grey, the game's)
    float wtitle_text(float x, float y, std::string const& s, uint32_t c = 0xFFC0C0C0u);
    float wtitle_width(std::string const& s) const;
    // the HUD gauge, h ~ 7 at 1:1; fill colour tints the bar like the game's HP/MP/TP gauges
    void gauge(float x, float y, float w, float h, float frac, uint32_t fill);
    void icon_frame(float x, float y, float size, uint32_t c);
};

}  // namespace nui
