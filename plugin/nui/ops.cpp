// ops.cpp - draws a list of drawing commands produced elsewhere (Chronicle's Lua layout), so the
// layout lives in the addon while the pixels come from the native widgets. One command a line,
// fields separated by tabs, colours RRGGBBAA:
//   W x y w h title [active]          window in the game's look
//   T x y col text                    chat-font text (additive, as the game draws it)
//   H x y px col text                 title / nameplate font, px = cap height
//   R x0 y0 x1 y1 col                 flat rectangle
//   Q tex x0 y0 x1 y1 u0 v0 u1 v1 col filter    textured quad (a texture handle; uv in texels);
//                                     filter 0 point, 1 linear, + 2 grey (1.1.0: the texture desaturated,
//                                     luma times col); any other value is 0, as before 1.1.0
//   I x y size id col [fx]            an item's icon from the game's DATs (one texture per icon);
//                                     fx 2 = grey (1.1.0), absent or anything else = colour
//   G x y w h frac col                the HUD gauge
//   C x0 y0 x1 y1                     push a clip rectangle;   c   pop it
#include "ops.hpp"

#include "client.hpp"

#include <algorithm>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <sstream>

namespace nui {
namespace {

// Review REND-7: a command's numbers kept to what a layout can mean. A coordinate (and texel, item id,
// gauge fraction) is clamped to +-65536 and a size (window, gauge, icon, title px) to 0..16384, and
// inf or NaN becomes 0, so no widget loop runs for 1e10 / 128 tiles. Q's texture handle only loses
// inf and NaN. Applied by both parsers, so the reference build's records stay comparable.
float finite_or_0(float v) { return v - v == 0.0f ? v : 0.0f; }
float clamp_to(float v, float lo, float hi) {
    v = finite_or_0(v);
    return v < lo ? lo : v > hi ? hi : v;
}
void sanitize(Cmd& c) {
#ifdef NUI_FAULT_NO_CLAMP                 // self-test: numbers used as parsed (before 1.2.6)
#ifndef NUI_TEST_REFERENCE
    (void)c;
    return;
#endif
#endif
    float const kCoord = 65536.0f, kSize = 16384.0f;
    auto coord = [&](int i0, int i1) { for (int i = i0; i <= i1; ++i) c.f[i] = clamp_to(c.f[i], -kCoord, kCoord); };
    auto size = [&](int i0, int i1) { for (int i = i0; i <= i1; ++i) c.f[i] = clamp_to(c.f[i], 0.0f, kSize); };
    switch (c.k) {
    case 'W': coord(0, 1); size(2, 3); break;
    case 'T': case 'M': coord(0, 1); break;
    case 'H': coord(0, 1); size(2, 2); break;
    case 'R': case 'C': coord(0, 3); break;
    case 'Q': c.f[0] = clamp_to(c.f[0], -1e9f, 1e9f); coord(1, 8); c.f[9] = finite_or_0(c.f[9]); break;
    case 'I': coord(0, 1); size(2, 2); coord(3, 3); break;
    case 'G': coord(0, 1); size(2, 3); coord(4, 4); break;
    }
}

#ifdef NUI_TEST_REFERENCE                 // the tests' reference build: the parser of before 1.2.0
uint32_t col(std::string const& s) {
    unsigned long v = std::strtoul(s.c_str(), nullptr, 16);
    unsigned const r = (v >> 24) & 0xFF, g = (v >> 16) & 0xFF, b = (v >> 8) & 0xFF, a = v & 0xFF;
    return argb(int(r), int(g), int(b), int(a));
}

float f(std::string const& s) { return float(std::atof(s.c_str())); }

bool parse_reference(std::string const& text, std::vector<Cmd>& out, std::string& err) {
    out.clear();
    std::size_t pos = 0;
    int lineno = 0;
    std::vector<std::string> a;
    while (pos <= text.size()) {
        std::size_t nl = text.find('\n', pos);
        if (nl == std::string::npos) nl = text.size();
        std::string line = text.substr(pos, nl - pos);
        pos = nl + 1;
        ++lineno;
        if (!line.empty() && line.back() == '\r') line.pop_back();
        if (line.empty() || line[0] == '#') { if (nl == text.size()) break; continue; }
        a.clear();
        std::size_t s = 0;
        for (;;) {
            std::size_t t = line.find('\t', s);
            if (t == std::string::npos) { a.push_back(line.substr(s)); break; }
            a.push_back(line.substr(s, t - s));
            s = t + 1;
        }
        Cmd c {};
        c.k = a[0].empty() ? '?' : a[0][0];
        auto need = [&](size_t m) {
            if (a.size() < m) { char b[64]; std::snprintf(b, sizeof(b), "line %d: %c needs %u fields", lineno, c.k, unsigned(m)); err = b; }
            return a.size() >= m;
        };
        auto nums = [&](int from, int n) { for (int i = 0; i < n; ++i) c.f[i] = f(a[from + i]); };
        switch (c.k) {
        case 'W': if (!need(6)) return false; nums(1, 4); c.s = a[5]; c.f[4] = a.size() > 6 && a[6] == "1"; break;
        case 'T': if (!need(5)) return false; nums(1, 2); c.col = col(a[3]); c.s = a[4]; break;
        case 'H': if (!need(6)) return false; nums(1, 3); c.col = col(a[4]); c.s = a[5]; break;
        case 'M': if (!need(5)) return false; nums(1, 2); c.col = col(a[3]); c.s = a[4]; break;   // 1.2.3, kept in step
        case 'R': if (!need(6)) return false; nums(1, 4); c.col = col(a[5]); break;
        case 'Q': if (!need(12)) return false; nums(1, 9); c.col = col(a[10]); c.f[9] = f(a[11]); break;
        case 'I': if (!need(6)) return false; nums(1, 4); c.col = col(a[5]); c.f[4] = a.size() > 6 && f(a[6]) == 2.0f ? 1.0f : 0.0f; break;
        case 'G': if (!need(7)) return false; nums(1, 5); c.col = col(a[6]); break;
        case 'C': if (!need(5)) return false; nums(1, 4); break;
        case 'c': break;
        default: { char b[64]; std::snprintf(b, sizeof(b), "line %d: unknown command", lineno); err = b; return false; }
        }
        sanitize(c);
        out.push_back(std::move(c));
        if (nl == text.size()) break;
    }
    return true;
}
#else
// In-place parse (1.2.0): fields are (pointer, length) into the caller's text; no copy of the text,
// no string per line or field. Numbers go through exactly the functions of before (atof, strtoul base
// 16) on a NUL-terminated copy of the field on the stack, so every value is bit-identical, including
// empty fields, leading blanks, "inf", "1e5" and embedded NULs. Two fast paths for what the consumers
// send, each exact and checked against atof / strtoul in test_build: a decimal integer of 1-7 digits
// with an optional '-' (the float is the integer; "-0" is -0.0), and a colour of exactly 8 hex digits.
struct Field {
    char const* p;
    std::size_t n;
};

float num(Field const& a) {
    char const* p = a.p;
    std::size_t const n = a.n;
    bool const neg = n > 0 && p[0] == '-';
    std::size_t const d0 = neg ? 1 : 0;
    if (n > d0 && n - d0 <= 7) {
        long v = 0;
        std::size_t i = d0;
        for (; i < n && p[i] >= '0' && p[i] <= '9'; ++i) v = v * 10 + (p[i] - '0');
        if (i == n) return neg ? (v == 0 ? -0.0f : -float(v)) : float(v);
    }
#ifndef NUI_FAULT_PARSE_NO_TERM           // self-test: atof straight on the text (reads past an empty field)
    char buf[64];
    if (n < sizeof(buf)) {
        std::memcpy(buf, p, n);
        buf[n] = 0;
        return float(std::atof(buf));
    }
    return float(std::atof(std::string(p, n).c_str()));
#else
    return float(std::atof(p));
#endif
}

int hexd(char ch) {
    return ch >= '0' && ch <= '9' ? ch - '0' : ch >= 'a' && ch <= 'f' ? ch - 'a' + 10 : ch >= 'A' && ch <= 'F' ? ch - 'A' + 10 : -1;
}

uint32_t colour(Field const& a) {
    unsigned long v = 0;
    bool fast = a.n == 8;
    for (std::size_t i = 0; fast && i < 8; ++i) {
        int const h = hexd(a.p[i]);
        if (h < 0) fast = false; else v = (v << 4) | unsigned(h);
    }
    if (!fast) {
        char buf[64];
        if (a.n < sizeof(buf)) {
            std::memcpy(buf, a.p, a.n);
            buf[a.n] = 0;
            v = std::strtoul(buf, nullptr, 16);
        } else {
            v = std::strtoul(std::string(a.p, a.n).c_str(), nullptr, 16);
        }
    }
    unsigned const r = (v >> 24) & 0xFF, g = (v >> 16) & 0xFF, b = (v >> 8) & 0xFF, al = v & 0xFF;
    return argb(int(r), int(g), int(b), int(al));
}
#endif

}  // namespace

#ifdef NUI_TEST_REFERENCE
bool ops_parse(std::string const& text, std::vector<Cmd>& out, std::string& err) { return parse_reference(text, out, err); }
bool ops_parse(char const* text, std::size_t n, std::vector<Cmd>& out, std::string& err) {
    return parse_reference(std::string(text, n), out, err);
}
#else
bool ops_parse(std::string const& text, std::vector<Cmd>& out, std::string& err) {
    return ops_parse(text.data(), text.size(), out, err);
}

bool ops_parse(char const* text, std::size_t n, std::vector<Cmd>& out, std::string& err) {
    out.clear();
    char const* const end = text + n;
    std::size_t lines = 1;
    for (char const* p = text; p < end && (p = static_cast<char const*>(std::memchr(p, '\n', std::size_t(end - p)))) != nullptr; ++p)
        ++lines;
    out.reserve(lines);
    constexpr std::size_t kMax = 16;           // fields kept; the commands read at most 12 (all are counted)
    Field a[kMax];
    int lineno = 0;
    char const* p = text;
    for (;;) {
        char const* nl = static_cast<char const*>(std::memchr(p, '\n', std::size_t(end - p)));
        bool const last = nl == nullptr;
        if (last) nl = end;
        ++lineno;
        char const* le = nl;
        if (le > p && le[-1] == '\r') --le;
        if (le == p || *p == '#') {
            if (last) break;
            p = nl + 1;
            continue;
        }
        std::size_t na = 0;
        for (char const* s = p;;) {
            char const* t = static_cast<char const*>(std::memchr(s, '\t', std::size_t(le - s)));
            char const* fe = t ? t : le;
            if (na < kMax) a[na] = Field {s, std::size_t(fe - s)};
            ++na;
            if (!t) break;
            s = t + 1;
        }
        Cmd c {};
        c.k = a[0].n == 0 ? '?' : a[0].p[0];
        auto need = [&](size_t m) {
            if (na < m) { char b[64]; std::snprintf(b, sizeof(b), "line %d: %c needs %u fields", lineno, c.k, unsigned(m)); err = b; }
            return na >= m;
        };
        auto nums = [&](int from, int k) { for (int i = 0; i < k; ++i) c.f[i] = num(a[from + i]); };
        auto str = [&](int i) { c.s.assign(a[i].p, a[i].n); };
        switch (c.k) {
        case 'W': if (!need(6)) return false; nums(1, 4); str(5); c.f[4] = na > 6 && a[6].n == 1 && a[6].p[0] == '1'; break;
        case 'T': if (!need(5)) return false; nums(1, 2); c.col = colour(a[3]); str(4); break;
        case 'H': if (!need(6)) return false; nums(1, 3); c.col = colour(a[4]); str(5); break;
        case 'M': if (!need(5)) return false; nums(1, 2); c.col = colour(a[3]); str(4); break;
        case 'R': if (!need(6)) return false; nums(1, 4); c.col = colour(a[5]); break;
        case 'Q': if (!need(12)) return false; nums(1, 9); c.col = colour(a[10]); c.f[9] = num(a[11]); break;
        case 'I': if (!need(6)) return false; nums(1, 4); c.col = colour(a[5]); c.f[4] = na > 6 && num(a[6]) == 2.0f ? 1.0f : 0.0f; break;
        case 'G': if (!need(7)) return false; nums(1, 5); c.col = colour(a[6]); break;
        case 'C': if (!need(5)) return false; nums(1, 4); break;
        case 'c': break;
        default: { char b[64]; std::snprintf(b, sizeof(b), "line %d: unknown command", lineno); err = b; return false; }
        }
        sanitize(c);
        out.push_back(std::move(c));
        if (last) break;
        p = nl + 1;
    }
    return true;
}
#endif

void ops_icons(std::vector<Cmd> const& cmds, std::set<int>& ids) {
    for (Cmd const& c : cmds)
        if (c.k == 'I') ids.insert(int(c.f[3]));
}

#ifndef NUI_TEST_REFERENCE
namespace {
// an upper bound of the quads a command list makes (1.2.0: the list is reserved once instead of
// doubling from empty); only an allocation hint, so odd values are clamped, never trusted
std::size_t quads_upper(std::vector<Cmd> const& cmds) {
    auto cells = [](float len, float step) {
        return len > 0 && len < 1e5f ? std::size_t(len / step) + 1 : std::size_t(0);
    };
    std::size_t n = 0;
    for (Cmd const& c : cmds) {
        switch (c.k) {
        case 'W': n += cells(c.f[2], 128) * (cells(c.f[3], 128) + 1) + 2 * cells(c.f[3], 32) + 2 * cells(c.f[2], 32) + 12 + c.s.size(); break;
        case 'T': case 'H': case 'M': n += c.s.size(); break;
        case 'G': n += 6; break;
        case 'R': case 'Q': case 'I': n += 1; break;
        }
    }
    return std::min<std::size_t>(n, 1 << 17);
}
}  // namespace
#endif

void ops_replay(Ui& ui, std::vector<Cmd> const& cmds, TextureStore* store, bool (*have_icon)(int, std::uint64_t)) {
    ops_draw(ui, cmds, store, have_icon);
#ifndef NUI_TEST_REFERENCE                // the tests' reference build: the batches of before 1.2.0
    merge_batches(ui.dl);
#endif
}

void ops_draw(Ui& ui, std::vector<Cmd> const& cmds, TextureStore* store, bool (*have_icon)(int, std::uint64_t)) {
#ifndef NUI_TEST_REFERENCE
    std::size_t const q = quads_upper(cmds);
    ui.dl.v.reserve(ui.dl.v.size() + 6 * q);
    ui.dl.batches.reserve(ui.dl.batches.size() + q / 2 + 16);
#endif
    for (Cmd const& c : cmds) {
        float const* v = c.f;
        switch (c.k) {
        case 'W': ui.window(v[0], v[1], v[2], v[3], c.s.c_str(), v[4] != 0); break;
        case 'T': ui.text(v[0], v[1], c.s, c.col); break;
        case 'H': ui.title_text(v[0], v[1], c.s, v[2], c.col); break;
        case 'M': ui.wtitle_text(v[0], v[1], c.s, c.col); break;
        case 'R': ui.rect(v[0], v[1], v[2], v[3], c.col); break;
        case 'Q': {
            // 0 point, 1 linear, 2 / 3 the same in grey; anything else drew point before 1.1.0 and still does
            int const raw = int(v[9]);
            int const fl = raw == kLinear || raw == kGrey || raw == (kLinear | kGrey) ? raw : int(kPoint);
            ui.dl.quad(int(v[0]), fl, v[1], v[2], v[3], v[4], v[5], v[6], v[7], v[8], c.col);
            break;
        }
        case 'I': {
            // one texture per icon (cache.hpp, C.8): a run of icons is a run of batches
            int const id = int(v[3]);
            if (!store || !store->icon_exists(id, have_icon)) break;
            ui.dl.quad(icon_handle(id), (v[2] == kIconCell ? kPoint : kLinear) | (v[4] != 0 ? kGrey : 0), v[0], v[1], v[0] + v[2], v[1] + v[2], 0, 0,
                       kIconCell, kIconCell, c.col);
            break;
        }
        case 'G': ui.gauge(v[0], v[1], v[2], v[3], v[4], c.col); break;
        case 'C': ui.dl.push_clip({v[0], v[1], v[2], v[3]}); break;
        case 'c': ui.dl.pop_clip(); break;
        }
    }
}

int ops_text(Ui& ui, std::string const& text, std::string& err, TextureStore* store) {
    std::vector<Cmd> cmds;
    if (!ops_parse(text, cmds, err)) return -1;
    ops_replay(ui, cmds, store, nullptr);
    return int(cmds.size());
}

int ops_scene(Ui& ui, std::string const& path, std::string& err, TextureStore* store) {
    std::vector<unsigned char> buf;
    if (!file_read(path, buf, 64u << 20)) { err = "cannot open " + path; return -1; }
    return ops_text(ui, std::string(buf.begin(), buf.end()), err, store);
}

}  // namespace nui
