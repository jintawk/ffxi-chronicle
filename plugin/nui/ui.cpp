// ui.cpp - see ui.hpp
#include "ui.hpp"

#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstring>

namespace nui {

void DrawList::push_clip(Rect r) {
    r = {r.x0 + ox, r.y0 + oy, r.x1 + ox, r.y1 + oy};
    Rect const& c = clip.back();
    clip.push_back({std::max(r.x0, c.x0), std::max(r.y0, c.y0), std::min(r.x1, c.x1), std::min(r.y1, c.y1)});
}

namespace {
// D3D8 has no scissor rectangle, so clipping is done here: the quad is cut to the clip rect and
// its texture coordinates and colours are cut with it (bilinear in both).
uint32_t lerp_col(uint32_t a, uint32_t b, float t) {
    uint32_t out = 0;
    for (int s = 0; s < 32; s += 8) {
        float const x = float((a >> s) & 0xFF), y = float((b >> s) & 0xFF);
        out |= uint32_t(std::lround(x + (y - x) * t)) << s;
    }
    return out;
}
}  // namespace

void DrawList::quad(int tex, int filter, float x0, float y0, float x1, float y1, float u0, float v0, float u1,
                    float v1, uint32_t const c[4]) {
    x0 += ox; x1 += ox; y0 += oy; y1 += oy;
    Rect const& r = clip.back();
    float const cx0 = std::max(x0, r.x0), cy0 = std::max(y0, r.y0);
    float const cx1 = std::min(x1, r.x1), cy1 = std::min(y1, r.y1);
    if (cx0 >= cx1 || cy0 >= cy1 || x1 <= x0 || y1 <= y0) return;
    float const tx0 = (cx0 - x0) / (x1 - x0), tx1 = (cx1 - x0) / (x1 - x0);
    float const ty0 = (cy0 - y0) / (y1 - y0), ty1 = (cy1 - y0) / (y1 - y0);
    auto col = [&](float tx, float ty) { return lerp_col(lerp_col(c[0], c[1], tx), lerp_col(c[2], c[3], tx), ty); };
    float const U0 = u0 + (u1 - u0) * tx0, U1 = u0 + (u1 - u0) * tx1;
    float const V0 = v0 + (v1 - v0) * ty0, V1 = v0 + (v1 - v0) * ty1;
    uint32_t k[4];
#ifndef NUI_TEST_REFERENCE                // the tests' reference build: every colour lerped, as before 1.2.0
    // Colour fast paths (1.2.0), exact by arithmetic: lerp(x, y, 0) = x + (y - x) * 0 = x and
    // lerp(x, y, 1) = x + (y - x) = y for 0-255 integers at any FPU precision, and lerp(x, x, t) =
    // x + 0 * t = x for any finite t, so lround returns the corner colours unchanged. An unclipped
    // quad (t exactly 0 and 1) keeps its four corners, a one-colour quad its colour; only a clipped
    // gradient pays the 48 lround of the bilinear cut. Proved against the reference in test_build.
#ifndef NUI_FAULT_FAST_CLIPPED            // self-test: the fast path also taken on a vertically clipped gradient
    if (tx0 == 0 && tx1 == 1 && ty0 == 0 && ty1 == 1) {
#else
    if (tx0 == 0 && tx1 == 1) {
#endif
        k[0] = c[0]; k[1] = c[1]; k[2] = c[2]; k[3] = c[3];
    } else if (c[0] == c[1] && c[0] == c[2] && c[0] == c[3] && tx0 - tx0 == 0 && tx1 - tx1 == 0 && ty0 - ty0 == 0 &&
               ty1 - ty1 == 0) {          // t finite (x - x == 0 fails for inf and NaN, where 0 * t is NaN)
        k[0] = k[1] = k[2] = k[3] = c[0];
    } else
#endif
    {
        k[0] = col(tx0, ty0); k[1] = col(tx1, ty0); k[2] = col(tx0, ty1); k[3] = col(tx1, ty1);
    }
    Vtx q[4] = {
        {cx0, cy0, 0, 1, k[0], U0, V0}, {cx1, cy0, 0, 1, k[1], U1, V0},
        {cx0, cy1, 0, 1, k[2], U0, V1}, {cx1, cy1, 0, 1, k[3], U1, V1}};
    if (batches.empty() || batches.back().tex != tex || batches.back().filter != filter || batches.back().blend != blend)
        batches.push_back({tex, filter, blend, uint32_t(v.size()), 0});
    for (int i : {0, 1, 2, 2, 1, 3}) v.push_back(q[i]);
    batches.back().count += 6;
}

// ---------------------------------------------------------------------------------------------
// Batch merge (1.2.0). A layer's rows alternate states (alpha rects, additive text, linear atlas,
// pictures, icons), so the list breaks into hundreds of batches of a few quads. merge_batches
// reorders the quads into state groups while keeping the order of every pair of quads that overlap.
//
// Why that is pixel-identical: the backend maps every vertex through the same monotone function
// (x * scale - 0.5, then the rasteriser's snap to its sub-pixel grid, both monotone), with no depth,
// stencil or alpha test, and an axis-aligned quad covers exactly the samples inside its half-open box
// [x0, x1) x [y0, y1) (the top-left fill rule, at pixel centres or any multisample position). So two
// quads whose boxes do not overlap (strict test: a shared edge, x1 == x0', is no overlap) write
// disjoint samples, and their order cannot change a pixel; quads that do overlap keep their order.
//
// A quad joins the last batch of its state if no batch after that one holds a quad it overlaps, else
// it opens a new batch at the end (the greedy rule of the phase-1 prototype; never more batches than
// before). Quads are kept in chunks of kChunk with a box per chunk and per batch, so the overlap scan
// skips whole batches and chunks. Runs on the thread that builds the layer, never in a draw. A list
// with a NaN coordinate (no box) is left in its order.
namespace {
constexpr int kChunk = 16;
struct Box { float x0, y0, x1, y1; };
inline bool overlap(Box const& a, Box const& b) { return a.x0 < b.x1 && b.x0 < a.x1 && a.y0 < b.y1 && b.y0 < a.y1; }
inline void grow(Box& a, Box const& b) {
    a.x0 = std::min(a.x0, b.x0); a.y0 = std::min(a.y0, b.y0);
    a.x1 = std::max(a.x1, b.x1); a.y1 = std::max(a.y1, b.y1);
}
struct Chunk {
    Box box;
    int prev, next, n;
    int q[kChunk];
    Box qb[kChunk];
};
struct MBatch {
    int tex, filter, blend;
    Box box;
    int first, last;     // chunks
};
inline bool same_state(int tex, int filter, int blend, MBatch const& m) {
#ifndef NUI_FAULT_MERGE_GREY              // self-test: a merge that ignores the grey flag of the filter
    return m.tex == tex && m.filter == filter && m.blend == blend;
#else
    return m.tex == tex && (m.filter & kLinear) == (filter & kLinear) && m.blend == blend;
#endif
}
}  // namespace

int merge_batches(DrawList& dl) {
    std::size_t const nb = dl.batches.size();
    if (nb < 2) return int(nb);
    // only a list made of whole quads in order (what DrawList::quad makes) is reordered
    uint32_t at = 0;
    for (Batch const& b : dl.batches) {
        if (b.first != at || b.count % 6 != 0) return int(nb);
        at += b.count;
    }
    if (at != dl.v.size()) return int(nb);
    std::size_t const nq = dl.v.size() / 6;
    std::vector<Chunk> ch;
    ch.reserve(nq / kChunk + nb + 1);
    std::vector<MBatch> mb;
    mb.reserve(nb);
    Vtx const* const v = dl.v.data();
    for (Batch const& b : dl.batches) {
        int last_same = -1;                        // the last merged batch of this state
        for (int j = int(mb.size()) - 1; j >= 0; --j)
            if (same_state(b.tex, b.filter, b.blend, mb[std::size_t(j)])) { last_same = j; break; }
        for (uint32_t i = b.first; i < b.first + b.count; i += 6) {
            // the box: corners 0 and 5 when the six vertices have DrawList::quad's shape (checked on the
            // coordinates' bits, cheap on the x87), else the min / max of all six
            Box qb {v[i].x, v[i].y, v[i + 5].x, v[i + 5].y};
            uint32_t u[12];                   // x, y bits of vertices 0-5: 1 = (x5, y0), 2 = (x0, y5), 3 = 2, 4 = 1
            for (int k = 0; k < 6; ++k) { std::memcpy(&u[2 * k], &v[i + k].x, 4); std::memcpy(&u[2 * k + 1], &v[i + k].y, 4); }
            bool const shape = ((u[2] ^ u[10]) | (u[3] ^ u[1]) | (u[4] ^ u[0]) | (u[5] ^ u[11]) | (u[6] ^ u[4]) | (u[7] ^ u[5]) |
                                (u[8] ^ u[2]) | (u[9] ^ u[3])) == 0;
            if (!(shape && qb.x0 <= qb.x1 && qb.y0 <= qb.y1)) {
                qb = Box {v[i].x, v[i].y, v[i].x, v[i].y};
                for (uint32_t k = i + 1; k < i + 6; ++k) grow(qb, Box {v[k].x, v[k].y, v[k].x, v[k].y});
            }
            if (!(qb.x0 <= qb.x1 && qb.y0 <= qb.y1)) return int(nb);     // a NaN coordinate: no box, keep the list as it is
            bool blocked = last_same < 0;
#ifndef NUI_FAULT_MERGE_OVERLAP           // self-test: a merge that ignores overlaps
            for (int j = int(mb.size()) - 1; !blocked && j > last_same; --j) {
                MBatch const& m = mb[std::size_t(j)];
                if (!overlap(qb, m.box)) continue;
                for (int c = m.last; c >= 0 && !blocked; c = ch[std::size_t(c)].prev) {
                    Chunk const& k = ch[std::size_t(c)];
                    if (!overlap(qb, k.box)) continue;
                    for (int e = k.n - 1; e >= 0; --e)
                        if (overlap(qb, k.qb[e])) { blocked = true; break; }
                }
            }
#endif
            if (blocked) {
                mb.push_back(MBatch {b.tex, b.filter, b.blend, qb, -1, -1});
                last_same = int(mb.size()) - 1;
            }
            MBatch& m = mb[std::size_t(last_same)];
            grow(m.box, qb);
            if (m.last < 0 || ch[std::size_t(m.last)].n == kChunk) {
                ch.push_back(Chunk {qb, m.last, -1, 0, {}, {}});
                int const c = int(ch.size()) - 1;
                if (m.last >= 0) ch[std::size_t(m.last)].next = c; else m.first = c;
                m.last = c;
            }
            Chunk& k = ch[std::size_t(m.last)];
            grow(k.box, qb);
            k.q[k.n] = int(i / 6);
            k.qb[k.n] = qb;
            ++k.n;
        }
    }
    if (mb.size() == nb) {
        // as many batches as before: unchanged if every quad is still in place
        int want = 0;
        bool same = true;
        for (MBatch const& m : mb)
            for (int c = m.first; c >= 0 && same; c = ch[std::size_t(c)].next)
                for (int e = 0; e < ch[std::size_t(c)].n; ++e)
                    if (ch[std::size_t(c)].q[e] != want++) { same = false; break; }
        if (same) return int(nb);
    }
    std::vector<Vtx> nv;
    nv.reserve(dl.v.size());                  // insert, not resize: no zero fill
    std::vector<Batch> out;
    out.reserve(mb.size());
    for (MBatch const& m : mb) {
        Batch nb2 {m.tex, m.filter, m.blend, uint32_t(nv.size()), 0};
        for (int c = m.first; c >= 0; c = ch[std::size_t(c)].next) {
            Chunk const& k = ch[std::size_t(c)];
            for (int e = 0; e < k.n; ++e) {
                Vtx const* const q = v + std::size_t(k.q[e]) * 6;
                nv.insert(nv.end(), q, q + 6);
            }
        }
        nb2.count = uint32_t(nv.size()) - nb2.first;
        out.push_back(nb2);
    }
    dl.v.swap(nv);
    dl.batches.swap(out);
    return int(dl.batches.size());
}

namespace {
// How the client draws a 'menu    win00' quad, measured on the game's own log window in all eight window
// types (4K captures of 2026-10-23, linearised through the capture's transfer curve):
// - colour: 0x80 = 1.0 (the PS2 convention);
// - alpha: 1.5 x the same convention (0x80 = 1.5, clamped to 1): the bodies of types 1, 3, 5 and 8 fit 1.50 x their
//   recipe alpha in every row (1.0 x left the scene 25-50 levels off between types; 1.46-1.52 per type), type 7's
//   is opaque, the rules' light rows need it too;
// - blend: each quad's own PS2 blend from its record (SpriteQuad::mode): rules and corners add to what is under them
//   ((Cs - 0) x As + Cd: type 6's black texel row under the gold leaves the body as it is), type 7's are blended,
//   bodies are blended or drawn without blending, and so is type 7's right rule (its clear texels stay clear: the
//   client alpha-tests them).
enum FrameBlend { kOpaque, kAlphaBlend, kAdditive };

FrameBlend frame_blend(SpriteQuad const& q) {
#ifdef NUI_FAULT_FRAME_BLEND              // self-test: every quad blended, as before 1.2.3
    (void)q;
    return kAlphaBlend;
#else
    if (q.mode[0] == 0) return kOpaque;
    if (q.mode[1] == 0 && q.mode[2] == 2 && q.mode[3] == 1) return kAdditive;
    return kAlphaBlend;                   // (Cs - Cd) x As + Cd, and any selectors no recipe uses
#endif
}

#ifndef NUI_FAULT_FRAME_ALPHA
float const kFrameAlpha = 3.0f;           // recipe alpha -> D3D alpha: 0x80 = 1.5
#else
float const kFrameAlpha = 2.0f;           // self-test: 0x80 = 1.0 for alpha too, as before 1.2.3
#endif

uint32_t frame_alpha(int a, FrameBlend b) {
    return b == kOpaque ? 255u : uint32_t(std::min(255.0f, float(a) * kFrameAlpha));
}

uint32_t frame_col(uint8_t const* c, FrameBlend b) {
    return (frame_alpha(c[3], b) << 24) | (argb(c[0] * 2, c[1] * 2, c[2] * 2) & 0xFFFFFFu);
}
}  // namespace

void Ui::rect(float x0, float y0, float x1, float y1, uint32_t c) {
    dl.quad(kTexAtlas, kPoint, x0, y0, x1, y1, kWhiteX + 2, kWhiteY + 2, kWhiteX + 6, kWhiteY + 6, c);
}

// The type-N window from its own recipe ('menu    win00', ROM/0/(13+N).DAT): a 128 x 128 template
// whose pieces are stretched to the window: the body tile repeats, the corners (24 x 24) stay at the
// corners, the rules (hfr1 / vfr1) run between them. Texels map 1:1 to pixels, as the game draws its
// UI at the user's 4K setting (a 128 px body period in screenshots).
void Ui::window(float x, float y, float w, float h, char const* title, bool active) {
    auto const& F = a.frame;
    if (!frame_recipe_ok(F)) return;              // review REND-8: never read a sprite that has no quad
    auto const& body = F[active && F.size() > 9 && !F[9].empty() ? 9 : 0][0];
    int const old_blend = dl.blend;
    // body: tiled, vertex colour interpolated over the window's height (top -> bottom)
    FrameBlend const bb = frame_blend(body);
    dl.blend = bb == kAdditive ? 1 : 0;
    // The alpha is scaled after the interpolation and clamps per pixel in the client, so a gradient that passes 1.0
    // inside the window has a knee there (types 1, 3 and 8: from about 83% of the height down the body is opaque):
    // a tile is split at that row and the colour interpolated on each side of it.
    uint32_t const rgb_t = frame_col(body.col[0], kOpaque) & 0xFFFFFFu, rgb_b = frame_col(body.col[2], kOpaque) & 0xFFFFFFu;
    float const at = bb == kOpaque ? 255.0f : float(body.col[0][3]) * kFrameAlpha;
    float const ab = bb == kOpaque ? 255.0f : float(body.col[2][3]) * kFrameAlpha;
    auto body_col = [&](float f) {
        float const al = std::min(255.0f, at + (ab - at) * f);
        return (lerp_col(rgb_t, rgb_b, f) & 0xFFFFFFu) | (uint32_t(std::lround(al)) << 24);
    };
    float const knee = (at < 255.0f) != (ab < 255.0f) ? (255.0f - at) / (ab - at) * h : -1.0f;
    for (float ty = 0; ty < h; ty += 128) {
        float const te = std::min(ty + 128.0f, h);
        float const cut[3] = {ty, knee > ty && knee < te ? knee : te, te};
        for (int k = 0; k < 2; ++k) {
            float const y0 = cut[k], y1 = cut[k + 1];
            if (y1 <= y0) continue;
            uint32_t const c0 = body_col(y0 / h), c1 = body_col(y1 / h);
            for (float tx = 0; tx < w; tx += 128) {
                float const tw = std::min(128.0f, w - tx);
                uint32_t const cc[4] = {c0, c0, c1, c1};
                dl.quad(kTexAtlas, kPoint, x + tx, y + y0, x + tx + tw, y + y1, kBodyX + body.u, kBodyY + body.vv + (y0 - ty),
                        kBodyX + body.u + tw, kBodyY + body.vv + (y1 - ty), cc);
            }
        }
    }
    // a frame piece from sprite s, placed at (px, py) with size (pw, ph); repeats its texels
    auto piece = [&](int s, int ox, int oy, float px, float py, float pw, float ph, float a0 = -1, float a1 = -1) {
        SpriteQuad const& q = F[s][0];
        FrameBlend const fb = frame_blend(q);
        dl.blend = fb == kAdditive ? 1 : 0;
        uint32_t c[4] = {frame_col(q.col[0], fb), frame_col(q.col[1], fb), frame_col(q.col[2], fb), frame_col(q.col[3], fb)};
        if (a0 >= 0) {          // override a horizontal alpha ramp (title gap fades), in recipe units
            for (int i : {0, 2}) c[i] = (c[i] & 0xFFFFFFu) | (frame_alpha(int(a0), fb) << 24);
            for (int i : {1, 3}) c[i] = (c[i] & 0xFFFFFFu) | (frame_alpha(int(a1), fb) << 24);
        }
        // the sprite's texture name, ignoring case: window type 1's recipe spells them "MENU    hfr1"
        // (every other type "menu    hfr1"), and a case-sensitive test drew its rules as one quad
        // whose texels ran the window's width across the atlas, into the font sheet (2026-10-19)
        auto tex_is = [&](char const* want) {
            for (int i = 0; want[i]; ++i)
#ifndef NUI_FAULT_WT1_CASE                // self-test: the case-sensitive compare of before 2026-10-19
                if (std::tolower(static_cast<unsigned char>(q.tex[i])) != want[i]) return false;
#else
                if (q.tex[i] != want[i]) return false;
#endif
            return true;
        };
        bool const horiz = tex_is("menu    hfr1");
        bool const vert = tex_is("menu    vfr1");
        float const step = horiz ? 32.0f : vert ? 32.0f : 1e9f;
        if (horiz) {
            for (float sx = 0; sx < pw; sx += step) {
                float const sw = std::min(step, pw - sx);
                float const t0 = sx / pw, t1 = (sx + sw) / pw;
                uint32_t cc[4] = {lerp_col(c[0], c[1], t0), lerp_col(c[0], c[1], t1), lerp_col(c[2], c[3], t0), lerp_col(c[2], c[3], t1)};
                dl.quad(kTexAtlas, kPoint, px + sx, py, px + sx + sw, py + ph, ox + q.u, oy + q.vv, ox + q.u + sw, oy + q.vv + ph, cc);
            }
        } else if (vert) {
            for (float sy = 0; sy < ph; sy += step) {
                float const sh = std::min(step, ph - sy);
                dl.quad(kTexAtlas, kPoint, px, py + sy, px + pw, py + sy + sh, ox + q.u, oy + q.vv, ox + q.u + pw, oy + q.vv + sh, c);
            }
        } else {
            dl.quad(kTexAtlas, kPoint, px, py, px + pw, py + ph, ox + q.u, oy + q.vv, ox + q.u + pw, oy + q.vv + ph, c);
        }
    };
    float const cs = 24;
    piece(4, kVfrX, kVfrY, x, y + cs, 5, h - 2 * cs);
    piece(5, kVfrX, kVfrY, x + w - 5, y + cs, 5, h - 2 * cs);
    piece(1, kCornerX, kCornerY, x, y, cs, cs);
    piece(3, kCornerX, kCornerY, x + w - cs, y, cs, cs);
    piece(6, kCornerX, kCornerY, x, y + h - cs, cs, cs);
    piece(8, kCornerX, kCornerY, x + w - cs, y + h - cs, cs, cs);
    // bottom rule: its 5 texel rows end on the window's last row, as the right rule's columns end on its
    // last column (texel 29 then meets the corners' rule row). Before 1.2.2 it sat one row lower: every
    // type but 6 (whose last texel row is clear) drew row y + h, below its rectangle (2026-10-23)
#ifndef NUI_FAULT_FRAME_BELOW            // self-test: the bottom rule of before 1.2.2
    piece(7, kHfrX, kHfrY, x + cs, y + h - 5, w - 2 * cs, 5);
#else
    piece(7, kHfrX, kHfrY, x + cs, y + h - 4, w - 2 * cs, 5);
#endif
    // top rule, opened for the title as the game's log window opens it (4K shots of 2026-10-23, all eight types):
    // the title's advances end 47 px left of the right edge; the rule is clear from one pixel into the title to one
    // pixel before its end, fades over 16 px on either side of that, and runs 8 px from the right fade to the corner
    float const ra = float(F[2][0].col[0][3]);
#ifndef NUI_FAULT_TITLE_OLD               // self-test: the italic title 22 px from the end with 8 px fades of before 1.2.3
    if (title && *title && a.have_wtitle) {
        float const tx1 = x + w - 47, tx0 = tx1 - wtitle_width(title);
        float const gl = tx0 + 1, gr = tx1 - 1;            // the clear stretch of the rule
        float const l0 = x + cs, f0 = std::max(l0, gl - 16);
        if (f0 > l0) piece(2, kHfrX, kHfrY, l0, y, f0 - l0, 5);
        if (gl > f0) piece(2, kHfrX, kHfrY, f0, y, gl - f0, 5, ra * (gl - f0) / 16, 0);
        piece(2, kHfrX, kHfrY, gr, y, 16, 5, 0, ra);
        piece(2, kHfrX, kHfrY, gr + 16, y, x + w - cs - gr - 16, 5);
        dl.blend = old_blend;
        wtitle_text(tx0, y, title);
    } else
#endif
    if (title && *title && a.title_ok()) {
        float const px = 9;
        float const tw = title_width(title, px);
        float const gx1 = x + w - 22, gx0 = gx1 - tw - 6;
        piece(2, kHfrX, kHfrY, x + cs, y, gx0 - 8 - (x + cs), 5);
        piece(2, kHfrX, kHfrY, gx0 - 8, y, 8, 5, ra, 0);
        piece(2, kHfrX, kHfrY, gx1, y, 8, 5, 0, ra);
        piece(2, kHfrX, kHfrY, gx1 + 8, y, x + w - cs - gx1 - 8, 5);
        dl.blend = old_blend;
        title_text(gx0 + 3, y - 3, title, px, argb(224, 224, 224));
    } else {
        piece(2, kHfrX, kHfrY, x + cs, y, w - 2 * cs, 5);
    }
    dl.blend = old_blend;
}

float Ui::text_width(std::string const& s) const {
    float w = 0;
    for (unsigned char ch : s) w += a.widths[(ch >= 0x20 && ch < 0x80 ? ch : '?') - 0x20];
    return w;
}

float Ui::text(float x, float y, std::string const& s, uint32_t c, int align) {
    float const w = text_width(s);
    if (align == 1) x -= w;
    else if (align == 2) x -= std::floor(w / 2);
    x = std::round(x);
    y = std::round(y);
    // The client draws chat / menu text ADDITIVELY (measured: every glyph pixel on screen is the
    // glyph plus the window behind it), so the baked dark outline vanishes on a dark body.
    int const old = dl.blend;
    dl.blend = 1;
    for (unsigned char ch : s) {
        int const i = (ch >= 0x20 && ch < 0x80 ? ch : '?') - 0x20;
        float const u = float(kMojiX + (i % 64) * 16), v = float(kMojiY + (i / 64) * 16);
        if (ch != ' ') dl.quad(kTexAtlas, kPoint, x, y, x + 16, y + 16, u, v, u + 16, v + 16, c);
        x += a.widths[i];
    }
    dl.blend = old;
    return w;
}

float Ui::wtitle_width(std::string const& s) const {
    float w = 0;
    for (unsigned char ch : s) w += a.wtitle[(ch >= 0x20 && ch < 0x7F ? ch : '?') - 0x20].adv;
    return w;
}

// A window title in the game's title font, 1:1, its left end at x and its x-height on the top rule (y = the
// window's top edge). The log window draws "Window2" with colour 0x60 (0.75 x the texels: the fill reads 180-191
// in every window type whatever the body under it) and alpha 0x60 x 1.5 (opaque), blended: c's default.
float Ui::wtitle_text(float x, float y, std::string const& s, uint32_t c) {
    float const x0 = x;
    int const old = dl.blend;
    dl.blend = 0;
    for (unsigned char ch : s) {
        WGlyph const& g = a.wtitle[(ch >= 0x20 && ch < 0x7F ? ch : '?') - 0x20];
        if (g.w > 0)
            dl.quad(kTexAtlas, kPoint, x, y + g.top, x + g.w, y + g.top + g.h, g.u0, g.v0, g.u0 + g.w, g.v0 + g.h, c);
        x += g.adv;
    }
    dl.blend = old;
    return x - x0;
}

// The title font missing, or an 'M' of no height (a client update): nothing is drawn and the width is
// 0, never px / 0 (review REND-9: inf and NaN vertices).
float Ui::title_width(std::string const& s, float px) const {
#ifndef NUI_FAULT_TITLE_NO_GUARD          // self-test: px / 0 when the title font is missing (before 1.2.6)
    if (!a.title_ok()) return 0;
#endif
    float const k = px / a.title['M' - 0x20].lh;
    float w = 0;
    for (unsigned char ch : s) w += (ch == ' ' ? 4.0f : a.title[(ch >= 0x20 && ch < 0x7F ? ch : '?') - 0x20].lw) * k;
    return w;
}

float Ui::title_text(float x, float y, std::string const& s, float px, uint32_t c, int align) {
#ifndef NUI_FAULT_TITLE_NO_GUARD
    if (!a.title_ok()) return 0;
#endif
    float const k = px / a.title['M' - 0x20].lh;
    float const top_m = a.title['M' - 0x20].top;
    float const w = title_width(s, px);
    if (align == 1) x -= w;
    else if (align == 2) x -= w / 2;
    for (unsigned char ch : s) {
        if (ch == ' ') { x += 4.0f * k; continue; }
        Glyph const& g = a.title[(ch >= 0x20 && ch < 0x7F ? ch : '?') - 0x20];
        float const gy = y + (g.top - top_m) * k;
        dl.quad(kTexAtlas, kLinear, x, gy, x + g.lw * k, gy + g.lh * k, g.u0, g.v0, g.u1, g.v1, c);
        x += g.lw * k;
    }
    return w;
}

// The HUD gauge from 'menu    gauge', as the client draws its own: a dark groove and steel
// edges from one clean texel column, the fill tinted, the game's two caps untinted.
void Ui::gauge(float x, float y, float w, float h, float frac, uint32_t fill) {
    if (!a.have_gauge) { rect(x, y, x + w * frac, y + h, fill); return; }
    float const gx = kGaugeX, gy = kGaugeY;
    float const cw = std::max(1.0f, std::round(h / 2)), bx = x + cw, bw = std::max(1.0f, w - 2 * cw);
    float const inset = std::max(1.0f, std::round(h / 6));
    float const col = gx + 16.5f;
    dl.quad(kTexAtlas, kLinear, bx, y, bx + bw, y + h, col, gy + 9.5f, col, gy + 14.5f, argb(40, 62, 84, 230));
    dl.quad(kTexAtlas, kLinear, bx, y, bx + bw, y + inset, col, gy + 9.5f, col, gy + 9.5f, argb(93, 143, 167));
    dl.quad(kTexAtlas, kLinear, bx, y + h - inset, bx + bw, y + h, col, gy + 14.5f, col, gy + 14.5f, argb(93, 143, 167));
    float const fw = std::round(bw * std::max(0.0f, std::min(1.0f, frac)));
    if (fw > 0) dl.quad(kTexAtlas, kLinear, bx, y + inset, bx + fw, y + h - inset, col, gy + 10.5f, col, gy + 13.5f, fill);
    dl.quad(kTexAtlas, kLinear, x, y, x + cw, y + h, gx + 9.25f, gy + 9.25f, gx + 11.75f, gy + 14.75f, 0xFFFFFFFFu);
    dl.quad(kTexAtlas, kLinear, bx + bw, y, bx + bw + cw, y + h, gx + 60.25f, gy + 9.25f, gx + 62.75f, gy + 14.75f, 0xFFFFFFFFu);
}

void Ui::icon_frame(float x, float y, float size, uint32_t c) {
    rect(x - 1, y - 1, x + size + 1, y, c);
    rect(x - 1, y + size, x + size + 1, y + size + 1, c);
    rect(x - 1, y, x, y + size, c);
    rect(x + size, y, x + size + 1, y + size, c);
}

}  // namespace nui
