// assets.hpp - the game's own UI art, read from the install (read-only) into one CPU atlas.
//
// Everything here is the client's pixels and the client's recipes:
//   - window type N frame + body: ROM/0/(13+N).DAT ('menu    newtex', 'hfr1', 'vfr1', 'corner') and
//     the frame recipe in the same file, the 0x31 sprite sheet 'menu    win00' (10 sprites: body
//     with vertex colours, four corners with alpha fades, top/bottom rules, side rules);
//   - the chat / menu text font 'font    moji' (ASCII rows) + its advance widths from FFXiMain.dll;
//   - the italic serif title / nameplate font 'font    font' + 'font    fontshp' glyph table;
//   - the window title font 'menu    menu2fon' (the log window's "window1:say"), glyph cells below;
//   - the HUD gauge 'menu    gauge'.
// Nothing decoded is ever written to disk by the renderer itself.
#pragma once
#include <cstdint>
#include <string>
#include <vector>

namespace nui {

// Atlas layout (1024 x 512, A8R8G8B8, origin top-left)
constexpr int kAtlasW = 1024, kAtlasH = 512;
constexpr int kMojiX = 0, kMojiY = 0;                 // 1024 x 32: ASCII 0x20-0x7F, 16 px cells
constexpr int kBodyX = 0, kBodyY = 32;                // 128 x 128 newtex
constexpr int kHfrX = 128, kHfrY = 32;                // 32 x 32
constexpr int kVfrX = 160, kVfrY = 32;                // 32 x 32
constexpr int kCornerX = 192, kCornerY = 32;          // 32 x 32
constexpr int kGaugeX = 224, kGaugeY = 32;            // 64 x 64
constexpr int kWhiteX = 296, kWhiteY = 40;            // 8 x 8 opaque white
constexpr int kFontX = 512, kFontY = 32;              // 256 x 256 'font    font'
constexpr int kM2fX = 768, kM2fY = 32;                // 256 x 256 'menu    menu2fon' (window titles, 1.2.3)

// One quad of a 0x31 sprite: logical vertices TL TR BL BR, texel rect, 4 vertex colours
// (FFXI convention: 0x80 = 1.0 for colour and alpha).
struct SpriteQuad {
    int16_t v[8];
    uint16_t w, h, u, vv;
    uint8_t col[4][4];      // per vertex R G B A
    // the PS2 blend the client draws the quad with (record bytes 41-44, copied to the cell's +0x2D..+0x30 and
    // handed to the client's blend setup 0x1011F300): blending on, then the selectors A, B, D of
    // (A - B) * As + D, each 0 = the texture (source), 1 = the frame buffer, 2 = zero
    uint8_t mode[4];
    char tex[17];
};

struct Glyph {                 // title font glyph (ASCII 0x20 + i)
    float u0, v0, u1, v1;      // atlas pixels
    float lw, lh, top;         // logical size and top offset
};

struct WGlyph {                // window title glyph (ASCII 0x20 + i): the font of the game's own window titles
    float u0, v0;              // atlas pixels (top-left); drawn 1:1, w x h texels
    float w, h, top, adv;      // size, top relative to the window's top edge, advance; w == 0: none (spaces advance)
};

struct Assets {
    std::vector<uint32_t> atlas;            // kAtlasW * kAtlasH, 0xAARRGGBB
    signed char widths[96] {};              // moji advance widths, ASCII 0x20..0x7F
    bool widths_from_game = false;
    Glyph title[95] {};
    WGlyph wtitle[95] {};
    bool have_wtitle = false;
    bool have_title = false, have_gauge = false, have_window = false, have_moji = false;
    std::vector<std::vector<SpriteQuad>> frame;   // 'menu    win00' sprites
    std::string log;

    // ffxi_dir ends with a backslash; window_type 1-8. want_pixels false: everything but the atlas
    // pixels (fonts' widths and glyph table, the frame recipe; atlas stays empty), for a module that
    // finds the atlas in the shared cache (cache.hpp)
    bool load(std::string const& ffxi_dir, int window_type, unsigned menu_fid = 39542, bool want_pixels = true);
    // the title font can be drawn: its glyphs were read and 'M' has a height (review REND-9)
    bool title_ok() const { return have_title && title['M' - 0x20].lh > 0; }
};

// The frame recipe Ui::window can draw from (review REND-8): sprites 0-8 each have a quad, and sprite 9
// (the active window's body) either has one or is absent.
bool frame_recipe_ok(std::vector<std::vector<SpriteQuad>> const& frame);

// Times FFXiMain.dll was read for the font's advance widths in this module (tests). 1.2.6 (review
// HOST-5): read once per install directory, then kept.
long assets_dll_reads();

}  // namespace nui
