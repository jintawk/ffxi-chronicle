// assets.cpp - see assets.hpp. DAT reading follows the client's own chunked DAT layout (the chunk
// walk, DXT1/DXT3 decodes and the fontshp glyph table are the same code paths, made stand-alone).
#include "assets.hpp"

#include "client.hpp"

#define WIN32_LEAN_AND_MEAN
#ifndef NOMINMAX
#define NOMINMAX
#endif
#include <windows.h>

#include <cstdio>
#include <cstring>

namespace nui {
namespace {

// The whole file in one read of its size (review HOST-5: before 1.2.6 an istreambuf_iterator copied
// FFXiMain.dll's 2.9 MB and the menu DAT's 4.3 MB a byte at a time). 1.2.10: opened wide
// (client.hpp), so a path the ANSI codepage cannot spell still reads.
bool slurp(std::string const& path, std::vector<unsigned char>& out) {
    return file_read(path, out, 256u << 20);
}

// The moji advance widths found in FFXiMain.dll, per install directory (review HOST-5): read once, so
// a window type switch or the render thread's atlas fallback never reads the 2.9 MB DLL again.
struct WidthCache {
    volatile LONG lock = 0;
    std::string dir;
    signed char widths[96] {};
    bool from_game = false, valid = false;
};
WidthCache g_widths;
volatile LONG g_dll_reads = 0;

void wc_lock() { while (InterlockedCompareExchange(&g_widths.lock, 1, 0) != 0) Sleep(0); }
void wc_unlock() { InterlockedExchange(&g_widths.lock, 0); }

bool read_bytes(std::string const& path, size_t off, void* dst, size_t n) {
    return file_read_at(path, off, dst, n);
}

// ROM path of a DAT file id from VTABLE.DAT / FTABLE.DAT
std::string dat_path(std::string const& ffxi, unsigned fid) {
    unsigned char rom = 0;
    unsigned short e = 0;
    if (!read_bytes(ffxi + "VTABLE.DAT", fid, &rom, 1) || rom == 0) return {};
    if (!read_bytes(ffxi + "FTABLE.DAT", fid * 2, &e, 2)) return {};
    char p[64];
    if (rom == 1) std::snprintf(p, sizeof(p), "ROM\\%u\\%u.DAT", e >> 7, e & 0x7F);
    else std::snprintf(p, sizeof(p), "ROM%u\\%u\\%u.DAT", rom, e >> 7, e & 0x7F);
    return ffxi + p;
}

// a DAT path without the install folder in front of it, for a chat line that has to stay short
std::string short_path(std::string const& ffxi, std::string const& path) {
    return path.compare(0, ffxi.size(), ffxi) == 0 ? path.substr(ffxi.size()) : path;
}

uint32_t rgb565(unsigned c) {
    unsigned const r = ((c >> 11) & 0x1F) * 255 / 31;
    unsigned const g = ((c >> 5) & 0x3F) * 255 / 63;
    unsigned const b = (c & 0x1F) * 255 / 31;
    return (r << 16) | (g << 8) | b;
}

// DXT3 -> ARGB into dst (stride in pixels). FFXI alpha nibble: >= 8 opaque, else nibble << 5.
void dxt3(unsigned char const* src, uint32_t* dst, int width, int rows, int stride) {
    int const bw = width / 4;
    for (int by = 0; by < rows / 4; ++by)
        for (int bx = 0; bx < bw; ++bx) {
            unsigned char const* b = src + (by * bw + bx) * 16;
            unsigned const c0 = b[8] | (b[9] << 8), c1 = b[10] | (b[11] << 8);
            uint32_t pal[4] = {rgb565(c0), rgb565(c1), 0, 0};
            for (int k = 0; k < 2; ++k) {
                uint32_t const p0 = pal[k], p1 = pal[1 - k];
                uint32_t m = 0;
                for (int s = 0; s < 24; s += 8)
                    m |= static_cast<uint32_t>((2 * ((p0 >> s) & 0xFF) + ((p1 >> s) & 0xFF) + 1) / 3) << s;
                pal[2 + k] = m;
            }
            uint32_t const bits = b[12] | (b[13] << 8) | (b[14] << 16) | (uint32_t(b[15]) << 24);
            for (int i = 0; i < 16; ++i) {
                unsigned const nib = (b[i / 2] >> ((i & 1) * 4)) & 0xF;
                unsigned const a = nib >= 8 ? 255u : nib << 5;
                dst[(by * 4 + (i >> 2)) * stride + bx * 4 + (i & 3)] = (a << 24) | pal[(bits >> (2 * i)) & 3];
            }
        }
}

void dxt1(unsigned char const* src, uint32_t* dst, int width, int rows, int stride) {
    int const bw = width / 4;
    for (int by = 0; by < rows / 4; ++by)
        for (int bx = 0; bx < bw; ++bx) {
            unsigned char const* b = src + (by * bw + bx) * 8;
            unsigned const c0 = b[0] | (b[1] << 8), c1 = b[2] | (b[3] << 8);
            uint32_t pal[4] = {rgb565(c0) | 0xFF000000u, rgb565(c1) | 0xFF000000u, 0, 0};
            bool const four = c0 > c1;
            uint32_t m2 = 0, m3 = 0;
            for (int s = 0; s < 24; s += 8) {
                unsigned const a = (pal[0] >> s) & 0xFF, c = (pal[1] >> s) & 0xFF;
                m2 |= uint32_t(four ? (2 * a + c + 1) / 3 : (a + c) / 2) << s;
                m3 |= uint32_t(four ? (2 * c + a + 1) / 3 : 0) << s;
            }
            pal[2] = m2 | 0xFF000000u;
            pal[3] = four ? (m3 | 0xFF000000u) : 0u;
            uint32_t const bits = b[4] | (b[5] << 8) | (b[6] << 16) | (uint32_t(b[7]) << 24);
            for (int i = 0; i < 16; ++i)
                dst[(by * 4 + (i >> 2)) * stride + bx * 4 + (i & 3)] = pal[(bits >> (2 * i)) & 3];
        }
}

struct Chunk {
    size_t off, len;
    unsigned type;
};

std::vector<Chunk> walk(std::vector<unsigned char> const& buf) {
    std::vector<Chunk> out;
    size_t off = 0;
    while (off + 16 <= buf.size()) {
        uint32_t info;
        std::memcpy(&info, &buf[off + 4], 4);
        size_t const len = ((info >> 7) & 0x7FFFF) * 16;
        if (len < 16 || off + len > buf.size()) break;
        out.push_back({off, len, info & 0x7F});
        off += len;
    }
    return out;
}

bool name_is(std::vector<unsigned char> const& buf, size_t at, char const* name16) {
    return at + 16 <= buf.size() && std::memcmp(&buf[at], name16, 16) == 0;
}

// DXT5 -> ARGB into dst (stride in pixels): DXT3's colour block behind an interpolated alpha block.
// DXT4 is the same bits with the colour premultiplied by that alpha, and DXT2 is DXT3's; both are
// decoded as their straight-alpha twin, which is what they are apart from the premultiply.
void dxt5(unsigned char const* src, uint32_t* dst, int width, int rows, int stride) {
    int const bw = width / 4;
    for (int by = 0; by < rows / 4; ++by)
        for (int bx = 0; bx < bw; ++bx) {
            unsigned char const* b = src + (by * bw + bx) * 16;
            unsigned a[8] = {b[0], b[1], 0, 0, 0, 0, 0, 0};
            if (a[0] > a[1])
                for (int k = 1; k <= 6; ++k) a[1 + k] = ((7 - k) * a[0] + k * a[1] + 3) / 7;
            else {
                for (int k = 1; k <= 4; ++k) a[1 + k] = ((5 - k) * a[0] + k * a[1] + 2) / 5;
                a[6] = 0;
                a[7] = 255;
            }
            uint64_t abits = 0;
            for (int i = 0; i < 6; ++i) abits |= uint64_t(b[2 + i]) << (8 * i);
            unsigned const c0 = b[8] | (b[9] << 8), c1 = b[10] | (b[11] << 8);
            uint32_t pal[4] = {rgb565(c0), rgb565(c1), 0, 0};
            for (int k = 0; k < 2; ++k) {
                uint32_t const p0 = pal[k], p1 = pal[1 - k];
                uint32_t m = 0;
                for (int s = 0; s < 24; s += 8)
                    m |= static_cast<uint32_t>((2 * ((p0 >> s) & 0xFF) + ((p1 >> s) & 0xFF) + 1) / 3) << s;
                pal[2 + k] = m;
            }
            uint32_t const bits = b[12] | (b[13] << 8) | (b[14] << 16) | (uint32_t(b[15]) << 24);
            for (int i = 0; i < 16; ++i)
                dst[(by * 4 + (i >> 2)) * stride + bx * 4 + (i & 3)] =
                    (a[(abits >> (3 * i)) & 7] << 24) | pal[(bits >> (2 * i)) & 3];
        }
}

// The client's alpha convention, the one DXT3 above uses too: 0x80 is opaque, so a byte doubles and
// clamps.
uint32_t alpha8(unsigned a) { return (a >= 0x80 ? 255u : a * 2) << 24; }

// An uncompressed image's top `rows` rows -> ARGB. Those rows are stored bottom to top, so row y
// here is stored row h - 1 - y; 4 and 8 bit are palette indices (the palette is 4 bytes a colour,
// B G R A), 16 bit is A1R5G5B5, 24 bit is B G R and 32 bit is B G R A.
void raw_rows(unsigned char const* px, unsigned char const* pal, unsigned bits, int w, int h, int rows,
              uint32_t* dst, int stride) {
    for (int y = 0; y < rows; ++y) {
        int const sy = h - 1 - y;
        uint32_t* out = dst + size_t(y) * stride;
        for (int x = 0; x < w; ++x) {
            size_t const p = size_t(sy) * size_t(w) + size_t(x);
            unsigned idx = 0;
            if (bits <= 8) {
                // the client reads a 4 bit row's even pixel from the high nibble, the odd one from
                // the low nibble of the same byte (Render_CreateTextureFromDat case 4)
                idx = bits == 4 ? ((px[p / 2] >> ((p & 1) ? 0 : 4)) & 0xF) : px[p];
                unsigned char const* e = pal + size_t(idx) * 4;
                out[x] = alpha8(e[3]) | (uint32_t(e[2]) << 16) | (uint32_t(e[1]) << 8) | e[0];
            } else if (bits == 16) {
                unsigned const v = px[p * 2] | (px[p * 2 + 1] << 8);
                uint32_t const r = ((v >> 10) & 0x1F) * 255 / 31, g = ((v >> 5) & 0x1F) * 255 / 31,
                               b = (v & 0x1F) * 255 / 31;
                out[x] = ((v & 0x8000) ? 0xFF000000u : 0u) | (r << 16) | (g << 8) | b;
            } else if (bits == 24) {
                unsigned char const* e = px + p * 3;
                out[x] = 0xFF000000u | (uint32_t(e[2]) << 16) | (uint32_t(e[1]) << 8) | e[0];
            } else {
                unsigned char const* e = px + p * 4;
                out[x] = alpha8(e[3]) | (uint32_t(e[2]) << 16) | (uint32_t(e[1]) << 8) | e[0];
            }
        }
    }
}

std::string hex32(uint32_t v) {
    char b[11];
    std::snprintf(b, sizeof(b), "%08lx", static_cast<unsigned long>(v));
    return b;
}

// The texture formats the game's own loader takes (Render_CreateTextureFromDat, FFXiMain
// 0x10039e50): a DXT fourcc, or an uncompressed image whose depth is the header's `bits` field.
// Before 1.2.10 only DXT1 and DXT3 were read, the two the author's own install happens to use for
// these pieces, so an install that stores the window art or the gauge any other way loaded none of
// it and the addon refused to draw at all (ffxi-chronicle issue 10).
struct TexInfo {
    int w = 0, h = 0;
    unsigned bits = 0;             // uncompressed depth; 0 = a DXT fourcc
    uint32_t fourcc = 0;
    size_t pal = 0, px = 0;        // palette and first pixel byte
};

// The texture header of a 0x20 chunk sits at chunk + 0x21: width at +4, height at +8, the
// uncompressed depth at +14, the fourcc at +40, then the palette (4 and 8 bit) or the pixels.
bool tex_info(std::vector<unsigned char> const& buf, Chunk const& c, int rows, TexInfo& t, std::string& why) {
    size_t const h = c.off + 0x21;
    if (h + 52 > buf.size()) { why = "header past the end of the DAT"; return false; }
    int32_t w = 0, hh = 0;
    uint16_t bits = 0;
    uint32_t fmt = 0;
    std::memcpy(&w, &buf[h + 4], 4);
    std::memcpy(&hh, &buf[h + 8], 4);
    std::memcpy(&bits, &buf[h + 14], 2);
    std::memcpy(&fmt, &buf[h + 40], 4);
    t.w = w;
    t.h = hh;
    // A size from the file bounds every count below: without this a header claiming 0x2000000 rows
    // makes `need` wrap to 0 in 32 bits, the byte check passes and the decode reads off the end.
    // 4096 is the client's own largest texture (the atlas is 1024 x 512).
    if (w <= 0 || hh <= 0 || w > 4096 || hh > 4096) {
        why = "size " + std::to_string(w) + "x" + std::to_string(hh);
        return false;
    }
    size_t need = 0;
#ifdef NUI_FAULT_DXT_ONLY                 // self-test: the two formats of before 1.2.10 (issue 10)
    if (fmt != 0x44585431 && fmt != 0x44585433) { why = "format " + hex32(fmt); return false; }
#endif
    if (fmt >= 0x44585431 && fmt <= 0x44585435) {                 // DXT1 .. DXT5
        t.fourcc = fmt;
        t.px = h + 44 + 8;
        need = size_t(w / 4) * size_t(rows / 4) * (fmt == 0x44585431 ? 8 : 16);   // only the rows read
    } else if (bits == 4 || bits == 8 || bits == 16 || bits == 24 || bits == 32) {
        t.bits = bits;
        t.pal = h + 44;
        t.px = t.pal + (bits == 4 ? 64 : bits == 8 ? 1024 : 0);
        need = (size_t(w) * size_t(hh) * bits) / 8;               // all of it: the rows run bottom to top
    } else {
        why = "format " + hex32(fmt) + " depth " + std::to_string(bits);
        return false;
    }
    if (t.px + need > buf.size()) { why = "pixels past the end of the DAT"; return false; }
    return true;
}

// a 0x20 texture chunk -> its top `rows` rows decoded into the atlas at (ax, ay); `why` takes the
// reason it could not be (assets missing: it names the piece that stopped the load)
bool blit_texture(std::vector<unsigned char> const& buf, Chunk const& c, int want_w, int rows,
                  std::vector<uint32_t>& atlas, int ax, int ay, std::string* why = nullptr) {
    std::string reason;
    TexInfo t;
    if (!tex_info(buf, c, rows, t, reason)) {
        if (why) *why = reason;
        return false;
    }
    if (t.w != want_w || t.h < rows) {
        if (why)
            *why = std::to_string(t.w) + "x" + std::to_string(t.h) + " not " + std::to_string(want_w) + "x" +
                   std::to_string(rows);
        return false;
    }
    if (atlas.empty()) return true;     // metrics only (the atlas is in the shared cache): checked, not decoded
    uint32_t* dst = &atlas[size_t(ay) * kAtlasW + ax];
    switch (t.fourcc) {
        case 0x44585431: dxt1(&buf[t.px], dst, t.w, rows, kAtlasW); return true;
        case 0x44585432:                // premultiplied DXT3
        case 0x44585433: dxt3(&buf[t.px], dst, t.w, rows, kAtlasW); return true;
        case 0x44585434:                // premultiplied DXT5
        case 0x44585435: dxt5(&buf[t.px], dst, t.w, rows, kAtlasW); return true;
        default: raw_rows(&buf[t.px], &buf[t.pal], t.bits, t.w, t.h, rows, dst, kAtlasW); return true;
    }
}

// 0x31 sprite sheet payload -> sprites
std::vector<std::vector<SpriteQuad>> parse_sheet(std::vector<unsigned char> const& buf, Chunk const& c) {
    std::vector<std::vector<SpriteQuad>> out;
    size_t p = c.off + 16 + 16;
    size_t const end = c.off + c.len;
    if (p >= end) return out;
    unsigned const ntex = buf[p];
    p += 1 + 16 * ntex;
    if (p + 2 > end) return out;
    unsigned const n = buf[p] | (buf[p + 1] << 8);
    p += 2;
    for (unsigned i = 0; i < n && p < end; ++i) {
        unsigned const nq = buf[p++];
        std::vector<SpriteQuad> s;
        for (unsigned k = 0; k < nq && p + 61 <= end; ++k, p += 61) {
            SpriteQuad q {};
            std::memcpy(q.v, &buf[p], 16);
            std::memcpy(&q.w, &buf[p + 16], 2);
            std::memcpy(&q.h, &buf[p + 18], 2);
            std::memcpy(&q.u, &buf[p + 20], 2);
            std::memcpy(&q.vv, &buf[p + 22], 2);
            std::memcpy(q.col, &buf[p + 25], 16);
            std::memcpy(q.mode, &buf[p + 41], 4);
            std::memcpy(q.tex, &buf[p + 45], 16);
            s.push_back(q);
        }
        out.push_back(s);
    }
    return out;
}

signed char const kFallbackWidths[96] = {
    7, 7, 7, 10, 8, 13, 11, 5, 8, 8, 9, 9, 5, 8, 5, 7, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 5, 5,
    9, 9, 9, 9, 11, 11, 11, 10, 10, 10, 9, 11, 10, 6, 9, 11, 10, 12, 10, 11, 10, 12, 11, 10,
    10, 10, 11, 14, 11, 11, 11, 8, 8, 8, 9, 9, 7, 9, 9, 9, 9, 9, 7, 9, 9, 5, 6, 9, 5, 12, 9,
    10, 9, 9, 6, 8, 7, 9, 9, 11, 9, 9, 8, 7, 6, 7, 12, 7};

}  // namespace

// The window title font: 'menu    menu2fon' (256 x 256 DXT3, menu DAT), the slab serif of the game's window titles.
// The client has no glyph map for it in FFXiMain or a sheet (its fixed windows use pre-composed titles, 'menu
// windowps' / 'comwin'), so the cells are this font's own rows: capitals at v 161, 'YZ' and the lower case at
// v 173-175, the italic digits at v 101; cut at the columns where neighbouring outlines meet. top = the cell's top
// row against the window's top edge (lower case -1: their x-height on the top rule's five rows, as the log
// window's "Window2"; ascenders and capitals -3; descenders hang to +8); adv = the last bright column + 1, except
// 'W' 'd' 'w', set to where the game puts the next glyph: fitted on the log window's "Window2" and "Window1:Say"
// (4K shots of 2026-10-23, window types 2, 4 and 6 agree to the pixel). Anything else falls back to the 1:1
// punctuation of 'font    fontshp' (from 'font    font').
struct WCell { char c; unsigned char u, v, w, h; signed char top, adv; };
WCell const kWCells[] = {
    {'0', 148, 101, 7, 10, -3, 6}, {'1', 157, 101, 7, 10, -3, 5}, {'2', 164, 101, 8, 10, -3, 7},
    {'3', 173, 101, 8, 10, -3, 6}, {'4', 182, 101, 8, 10, -3, 6}, {'5', 191, 101, 7, 10, -3, 6},
    {'6', 200, 101, 7, 10, -3, 5}, {'7', 208, 101, 8, 10, -3, 7}, {'8', 216, 101, 8, 10, -3, 6},
    {'9', 225, 101, 8, 10, -3, 6},
    {'A', 2, 161, 10, 9, -3, 9}, {'B', 12, 161, 10, 9, -3, 9}, {'C', 23, 161, 10, 9, -3, 8},
    {'D', 33, 161, 11, 9, -3, 9}, {'E', 44, 161, 10, 9, -3, 9}, {'F', 54, 161, 10, 9, -3, 9},
    {'G', 65, 161, 10, 9, -3, 9}, {'H', 75, 161, 11, 9, -3, 10}, {'I', 86, 161, 7, 9, -3, 6},
    {'J', 93, 161, 10, 9, -3, 9}, {'K', 103, 161, 11, 9, -3, 10}, {'L', 114, 161, 9, 9, -3, 7},
    {'M', 123, 161, 13, 9, -3, 11}, {'N', 136, 161, 11, 9, -3, 9}, {'O', 147, 161, 10, 9, -3, 9},
    {'P', 157, 161, 10, 9, -3, 9}, {'Q', 168, 161, 10, 9, -3, 9}, {'R', 178, 161, 11, 9, -3, 9},
    {'S', 190, 161, 10, 9, -3, 7}, {'T', 199, 161, 10, 9, -3, 9}, {'U', 210, 161, 10, 9, -3, 8},
    {'V', 220, 161, 11, 9, -3, 9}, {'W', 231, 161, 11, 9, -3, 9}, {'X', 242, 161, 12, 9, -3, 10},
    {'Y', 2, 173, 10, 9, -3, 9}, {'Z', 12, 173, 10, 9, -3, 8},
    {'a', 22, 175, 8, 7, -1, 6}, {'b', 31, 173, 8, 9, -3, 7}, {'c', 40, 175, 8, 7, -1, 7},
    {'d', 49, 173, 8, 9, -3, 6}, {'e', 58, 175, 8, 7, -1, 7}, {'f', 67, 173, 7, 9, -3, 7},
    {'g', 74, 175, 9, 9, -1, 7}, {'h', 83, 173, 9, 9, -3, 7}, {'i', 93, 173, 6, 9, -3, 4},
    {'j', 100, 173, 6, 11, -3, 4}, {'k', 106, 173, 10, 9, -3, 8}, {'l', 116, 173, 6, 9, -3, 4},
    {'m', 122, 175, 12, 7, -1, 10}, {'n', 135, 175, 9, 7, -1, 8}, {'o', 145, 175, 9, 7, -1, 7},
    {'p', 155, 175, 8, 9, -1, 7}, {'q', 164, 175, 8, 9, -1, 7}, {'r', 173, 175, 8, 7, -1, 6},
    {'s', 181, 175, 8, 7, -1, 6}, {'t', 190, 174, 6, 8, -2, 5}, {'u', 197, 175, 8, 7, -1, 7},
    {'v', 206, 175, 10, 7, -1, 8}, {'w', 216, 175, 10, 7, -1, 10}, {'x', 226, 175, 10, 7, -1, 8},
    {'y', 236, 175, 9, 9, -1, 7}, {'z', 245, 175, 8, 7, -1, 7},
};

bool frame_recipe_ok(std::vector<std::vector<SpriteQuad>> const& frame) {
#ifdef NUI_FAULT_RECIPE_LAST              // self-test: only the sprite count (before 1.2.6)
    return frame.size() >= 9;
#endif
    if (frame.size() < 9) return false;
    for (std::size_t s = 0; s < frame.size() && s < 10; ++s)
        if (frame[s].empty()) return false;
    return true;
}

long assets_dll_reads() { return g_dll_reads; }

bool Assets::load(std::string const& ffxi, int window_type, unsigned menu_fid, bool want_pixels) {
    atlas.clear();
    if (want_pixels) {
        atlas.assign(size_t(kAtlasW) * kAtlasH, 0);
        for (int y = 0; y < 8; ++y)
            for (int x = 0; x < 8; ++x) atlas[size_t(kWhiteY + y) * kAtlasW + kWhiteX + x] = 0xFFFFFFFFu;
    }

    // advance widths: the table is plain in FFXiMain.dll's .data; read once per install (HOST-5)
    std::memcpy(widths, kFallbackWidths, 96);
    bool cached = false;
#ifndef NUI_FAULT_NO_WIDTH_CACHE          // self-test: FFXiMain.dll read on every load (before 1.2.6)
    wc_lock();
    if (g_widths.valid && g_widths.dir == ffxi) {
        std::memcpy(widths, g_widths.widths, 96);
        widths_from_game = g_widths.from_game;
        cached = true;
    }
    wc_unlock();
#endif
    if (!cached) {
        std::vector<unsigned char> dll;
        InterlockedIncrement(&g_dll_reads);
        if (slurp(ffxi + "FFXiMain.dll", dll)) {
            static unsigned char const pat[] = {0x0B, 0, 0, 0, 0, 0, 0, 0, 0x07, 0x07, 0x07, 0x0A, 0x08, 0x0D, 0x0B, 0x05};
            for (size_t i = 0; i + sizeof(pat) + 96 <= dll.size(); ++i) {
                if (std::memcmp(&dll[i], pat, sizeof(pat)) == 0) {
                    std::memcpy(widths, &dll[i + 8], 96);
                    widths_from_game = true;
                    break;
                }
            }
            wc_lock();                    // a DLL that could not be read is not cached: tried again next load
            g_widths.dir = ffxi;
            std::memcpy(g_widths.widths, widths, 96);
            g_widths.from_game = widths_from_game;
            g_widths.valid = true;
            wc_unlock();
        }
    }
    log += widths_from_game ? "widths from FFXiMain.dll; " : "widths built-in; ";

    // window type pieces + recipe. `why` says what stopped it, so a report of a window that draws
    // nothing arrives with the file and the reason in it instead of only "missing" (issue 10).
    unsigned const wfid = unsigned(13 + window_type);
    std::string const wpath = dat_path(ffxi, wfid);
    std::string why;
    std::vector<unsigned char> wb;
    if (wpath.empty()) why = "no DAT holds file " + std::to_string(wfid);
    else if (!slurp(wpath, wb)) why = short_path(ffxi, wpath) + " cannot be read";
    else {
        int got = 0;
        auto one = [&](Chunk const& c, char const* name, int w, int rows, int ax, int ay) {
            std::string r;
            if (blit_texture(wb, c, w, rows, atlas, ax, ay, &r)) ++got;
            else if (why.empty()) why = short_path(ffxi, wpath) + ": " + name + " " + r;
        };
        for (auto const& c : walk(wb)) {
            size_t const nm = c.off + 17;
            if (c.type == 0x20) {
                if (name_is(wb, nm, "menu    newtex  ")) one(c, "newtex", 128, 128, kBodyX, kBodyY);
                else if (name_is(wb, nm, "menu    hfr1    ")) one(c, "hfr1", 32, 32, kHfrX, kHfrY);
                else if (name_is(wb, nm, "menu    vfr1    ")) one(c, "vfr1", 32, 32, kVfrX, kVfrY);
                else if (name_is(wb, nm, "menu    corner  ")) one(c, "corner", 32, 32, kCornerX, kCornerY);
            } else if (c.type == 0x31) {
#ifndef NUI_FAULT_RECIPE_LAST             // self-test: the last sprite sheet, whatever its name (before 1.2.6)
                if (name_is(wb, c.off + 16, "menu    win00   ")) frame = parse_sheet(wb, c);   // review REND-8: by name
#else
                frame = parse_sheet(wb, c);
#endif
            }
        }
        have_window = got == 4 && frame_recipe_ok(frame);
        if (!have_window && why.empty())
            why = short_path(ffxi, wpath) + (got == 4 ? ": no win00 recipe" : ": " + std::to_string(got) + " of 4 pieces");
    }
    log += have_window ? "window type " + std::to_string(window_type) + " + win00 recipe; "
                       : "window art missing (" + why + "); ";

    // menu DAT: fonts and gauge
    std::string const mpath = dat_path(ffxi, menu_fid);
    std::string mwhy, gwhy;
    std::vector<unsigned char> mb;
    if (mpath.empty()) mwhy = gwhy = "no DAT holds file " + std::to_string(menu_fid);
    else if (!slurp(mpath, mb)) mwhy = gwhy = short_path(ffxi, mpath) + " cannot be read";
    else {
        mwhy = short_path(ffxi, mpath) + ": no font    moji";
        gwhy = short_path(ffxi, mpath) + ": no menu    gauge";
        for (auto const& c : walk(mb)) {
            size_t const nm = c.off + 17;
            if (c.type == 0x20 && !have_moji && name_is(mb, nm, "font    moji    "))
                have_moji = blit_texture(mb, c, 1024, 32, atlas, kMojiX, kMojiY, &mwhy);
            else if (c.type == 0x20 && !have_gauge && name_is(mb, nm, "menu    gauge   "))
                have_gauge = blit_texture(mb, c, 64, 64, atlas, kGaugeX, kGaugeY, &gwhy);
            else if (c.type == 0x20 && name_is(mb, nm, "font    font    "))
                blit_texture(mb, c, 256, 256, atlas, kFontX, kFontY);
            else if (c.type == 0x20 && !have_wtitle && name_is(mb, nm, "menu    menu2fon"))
                have_wtitle = blit_texture(mb, c, 256, 256, atlas, kM2fX, kM2fY);
            else if (c.type == 0x31 && !have_title && name_is(mb, c.off + 16, "font    fontshp ")) {
                auto sh = parse_sheet(mb, c);
                if (sh.size() >= 95) {
                    have_title = true;
                    for (int i = 0; i < 95; ++i) {
                        if (sh[i].empty()) { have_title = false; break; }
                        SpriteQuad const& q = sh[i][0];
                        Glyph& g = title[i];
                        g.u0 = float(kFontX + q.u);
                        g.v0 = float(kFontY + q.vv);
                        g.u1 = float(kFontX + q.u + q.w);
                        g.v1 = float(kFontY + q.vv + q.h);
                        g.lw = float(q.v[6] - q.v[0]);
                        g.lh = float(q.v[7] - q.v[1]);
                        g.top = float(q.v[1]);
                    }
                }
            }
        }
    }
    // the window title font: menu2fon's cells, the rest from fontshp's 1:1 (small) glyphs, spaces 4 px
    if (have_wtitle) {
        for (int i = 0; i < 95; ++i) {
            WGlyph& g = wtitle[i];
            g = WGlyph {0, 0, 0, 0, 0, 4};
            Glyph const& t = title[i];
            if (have_title && i > 0 && t.u1 - t.u0 == t.lw && t.v1 - t.v0 == t.lh)
                g = WGlyph {t.u0, t.v0, t.lw, t.lh, -3, t.lw - 1};
        }
        for (WCell const& c : kWCells)
            wtitle[c.c - 0x20] = WGlyph {float(kM2fX + c.u), float(kM2fY + c.v), float(c.w), float(c.h), float(c.top), float(c.adv)};
    }
    log += have_moji ? "moji; " : "moji missing (" + mwhy + "); ";
    log += have_wtitle ? "window title font; " : "window title font missing; ";
    log += have_title ? "title font; " : "title font missing; ";
    log += have_gauge ? "gauge" : "gauge missing (" + gwhy + ")";
    // Anything missing: say where the game was read from, so one chat line carries the whole answer.
    if (!(have_window && have_moji && have_wtitle && have_title && have_gauge)) log += "; in " + ffxi;
    // The floor is the text font: without it nothing can be read, and the module says so and draws
    // nothing. Everything else has a fallback - built-in advance widths, a plain frame in place of
    // the window art (ui.cpp), a flat bar in place of the gauge - so a client whose art cannot be
    // read still gets a usable window instead of no addon at all (1.2.10, issue 10).
    return have_moji;
}

}  // namespace nui
