// textures.cpp - see textures.hpp
#include "textures.hpp"

#include "cache.hpp"

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include <algorithm>
#include <cstdio>
#include <cstring>
#include <fstream>

#define STBI_ONLY_PNG
#define STBI_ONLY_JPEG
#define STBI_ONLY_BMP
#define STBI_NO_STDIO_WRITE
#define STBI_MAX_DIMENSIONS 8192      // 1.2.4: stb's own cap (default 1 << 24) as a second line behind kMaxSourcePixels
#define STB_IMAGE_IMPLEMENTATION
#if defined(__GNUC__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
#pragma GCC diagnostic ignored "-Wmisleading-indentation"
#endif
#include "stb_image.h"
#if defined(__GNUC__)
#pragma GCC diagnostic pop
#endif

namespace nui {

void fit_size(int iw, int ih, int max_w, int max_h, int& w, int& h) {
    double k = 1.0;
    if (max_w > 0 && iw > max_w) k = double(max_w) / iw;
    if (max_h > 0 && ih * k > max_h) k = double(max_h) / ih;
    w = iw * k < 1 ? 1 : int(iw * k + 0.5);
    h = ih * k < 1 ? 1 : int(ih * k + 0.5);
}

namespace {

// stb's RGBA -> ARGB fitted inside max_w x max_h by area averaging (alpha-weighted colour)
bool fit_pixels(unsigned char* src, int iw, int ih, int max_w, int max_h, std::vector<uint32_t>& px, int& w,
                int& h, std::string& err) {
    fit_size(iw, ih, max_w, max_h, w, h);
    if (w > 4096 || h > 4096) {
        stbi_image_free(src);
        err = "image larger than 4096 px";
        return false;
    }
    px.assign(std::size_t(w) * h, 0);
    for (int y = 0; y < h; ++y) {
        int const sy0 = int(double(y) * ih / h), sy1 = std::max(sy0 + 1, int(double(y + 1) * ih / h));
        for (int x = 0; x < w; ++x) {
            int const sx0 = int(double(x) * iw / w), sx1 = std::max(sx0 + 1, int(double(x + 1) * iw / w));
            // 64-bit sums (review REND-13): 32 bits wrap past 66,049 opaque source pixels per output pixel
#ifndef NUI_FAULT_SUM32                   // self-test: the 32-bit sums of before 1.2.6
            unsigned long long r = 0, g = 0, b = 0, a = 0, cnt = 0;
#else
            unsigned long r = 0, g = 0, b = 0, a = 0, cnt = 0;
#endif
            for (int sy = sy0; sy < sy1 && sy < ih; ++sy)
                for (int sx = sx0; sx < sx1 && sx < iw; ++sx) {
                    unsigned char const* p = src + (std::size_t(sy) * iw + sx) * 4;
                    r += p[0] * p[3]; g += p[1] * p[3]; b += p[2] * p[3]; a += p[3]; ++cnt;
                }
            uint32_t c = 0;
            if (a) c = (uint32_t(a / cnt) << 24) | (uint32_t(r / a) << 16) | (uint32_t(g / a) << 8) | uint32_t(b / a);
            px[std::size_t(y) * w + x] = c;
        }
    }
    stbi_image_free(src);
#ifdef NUI_FAULT_PICTURE_PIXEL           // self-test: a decode change without a kFmtPicture bump
    if (!px.empty()) px[0] ^= 0x01010101u;
#endif
    return true;
}

// The file's size and up to `limit` bytes from its start (all of it when limit is 0). Files over
// 64 MiB are refused.
bool slurp(std::string const& path, std::vector<unsigned char>& out, std::size_t limit = 0, std::streamoff* size = nullptr) {
    std::ifstream f(path, std::ios::binary);
    if (!f) return false;
    f.seekg(0, std::ios::end);
    std::streamoff const n = f.tellg();
    if (n < 0 || n > (64 << 20)) return false;
    if (size) *size = n;
    std::streamoff const take = limit && std::streamoff(limit) < n ? std::streamoff(limit) : n;
    f.seekg(0);
    out.resize(std::size_t(take));
    f.read(reinterpret_cast<char*>(out.data()), take);
    return f.gcount() == take;
}

}  // namespace

bool read_file(std::string const& path, std::vector<unsigned char>& out) { return slurp(path, out); }

bool image_signature_ok(unsigned char const* p, std::size_t n) {
#ifdef NUI_FAULT_NO_SIGNATURE             // self-test: every file handed to stb_image (before 1.2.6)
    (void)p; (void)n;
    return true;
#endif
    static unsigned char const png[8] = {0x89, 'P', 'N', 'G', 0x0D, 0x0A, 0x1A, 0x0A};
    if (n >= 8 && std::memcmp(p, png, 8) == 0) return true;
    if (n >= 3 && p[0] == 0xFF && p[1] == 0xD8 && p[2] == 0xFF) return true;          // JPEG: SOI, then a marker
    if (n >= 18 && p[0] == 'B' && p[1] == 'M') {                                        // BMP: a known DIB header size
        std::uint32_t const hsz = std::uint32_t(p[14]) | (std::uint32_t(p[15]) << 8) | (std::uint32_t(p[16]) << 16) |
                                  (std::uint32_t(p[17]) << 24);
        return hsz == 12 || hsz == 40 || hsz == 56 || hsz == 108 || hsz == 124;
    }
    return false;
}

std::string decode_error(std::string const& path, std::string const& err) {
#ifdef NUI_FAULT_ERR_SUBSTR               // self-test: the message cut at the first ':' (throws when there is none)
    return "cannot decode " + path + err.substr(err.find(':'));
#endif
    static char const kPre[] = "cannot decode: ";
    std::string reason = err.empty() ? std::string("?") : err;
    if (reason.compare(0, sizeof(kPre) - 1, kPre) == 0) reason.erase(0, sizeof(kPre) - 1);
    return "cannot decode " + path + ": " + reason;
}

// 1.2.4: the largest source picture decoded. stb decodes at full size before fit_pixels scales down, and a PNG peaks at
// about twice w * h * 4 bytes, so a small file declaring 15000 x 15000 (it compresses to under 1 MB) asked a 32-bit
// client that dies near 2 GB for about 1.8 GB (review REND-1). 16 MP (4096 x 4096) peaks near 128 MB.
constexpr long long kMaxSourcePixels = 16LL * 1024 * 1024;

static bool source_size_ok(int iw, int ih, std::string& err) {
    if (iw > 0 && ih > 0 && (long long)iw * ih <= kMaxSourcePixels) return true;
    char buf[96];
    std::snprintf(buf, sizeof(buf), "picture too large (%d x %d, at most 16 megapixels)", iw, ih);
    err = buf;
    return false;
}

bool decode_image_mem(unsigned char const* data, std::size_t n, int max_w, int max_h, std::vector<uint32_t>& px,
                      int& w, int& h, std::string& err) {
    if (!image_signature_ok(data, n)) {
        err = "cannot decode: not a PNG, JPEG or BMP file";
        return false;
    }
    int iw = 0, ih = 0, comp = 0;
    if (n <= 0x7FFFFFFF && stbi_info_from_memory(data, int(n), &iw, &ih, &comp)) {
        std::string why;
        if (!source_size_ok(iw, ih, why)) {
            err = "cannot decode: " + why;
            return false;
        }
    }
    unsigned char* src = n <= 0x7FFFFFFF ? stbi_load_from_memory(data, int(n), &iw, &ih, &comp, 4) : nullptr;
    if (!src) {
        err = std::string("cannot decode: ") + (stbi_failure_reason() ? stbi_failure_reason() : "?");
        return false;
    }
    return fit_pixels(src, iw, ih, max_w, max_h, px, w, h, err);
}

bool decode_image(std::string const& path, int max_w, int max_h, std::vector<uint32_t>& px, int& w, int& h,
                  std::string& err) {
    std::vector<unsigned char> bytes;
    if (!slurp(path, bytes)) {
        err = "cannot decode " + path + ": cannot open the file";
        return false;
    }
    if (!decode_image_mem(bytes.data(), bytes.size(), max_w, max_h, px, w, h, err)) {
        err = decode_error(path, err);
        return false;
    }
    return true;
}

namespace {

// item id ranges -> DAT (ROM-relative) and record base; records are 0x1400 bytes in today's DATs
struct IconDat { int lo, hi; char const* path; int off; };
IconDat const kIconDats[] = {
    {0x0001, 0x0FFF, "ROM\\118\\106.DAT", -1}, {0x1000, 0x1FFF, "ROM\\118\\107.DAT", 0},
    {0x2000, 0x21FF, "ROM\\118\\110.DAT", 0}, {0x2200, 0x27FF, "ROM\\301\\115.DAT", 0},
    {0x2800, 0x3FFF, "ROM\\118\\109.DAT", 0}, {0x4000, 0x59FF, "ROM\\118\\108.DAT", 0},
    {0x5A00, 0x6FFF, "ROM\\286\\73.DAT", 0},  {0x7000, 0x73FF, "ROM\\217\\21.DAT", 0},
    {0x7400, 0x77FF, "ROM\\288\\80.DAT", 0},  {0xF000, 0xF1FF, "ROM\\288\\67.DAT", 0}};

// the item DATs' byte scramble: a 5-bit rotate
inline unsigned dec(unsigned char b) { return unsigned((b % 0x20) * 8 + b / 0x20); }

// one icon record (0x800 bytes from 0x2BD) -> ARGB rows top first
void icon_from_record(unsigned char const* data, uint32_t out[kIconCell * kIconCell]) {
    uint32_t pal[256];
    for (int i = 0; i < 256; ++i) {
        unsigned const b = dec(data[i * 4]), g = dec(data[i * 4 + 1]), r = dec(data[i * 4 + 2]);
        unsigned a = dec(data[i * 4 + 3]) * 2;
        if (a > 255) a = 255;
        pal[i] = (uint32_t(a) << 24) | (r << 16) | (g << 8) | b;
    }
    for (int i = 0; i < kIconCell * kIconCell; ++i) {       // BMP order: bottom row first
        int const x = i % kIconCell, y = kIconCell - 1 - i / kIconCell;
        out[y * kIconCell + x] = pal[dec(data[0x400 + i])];
    }
#ifdef NUI_FAULT_ICON_PIXEL              // self-test: a decode change without a kFmtIcon bump
    out[0] ^= 0x01010101u;
#endif
}

int icon_dat(int item_id) {
    for (int i = 0; i < int(sizeof(kIconDats) / sizeof(kIconDats[0])); ++i)
        if (item_id >= kIconDats[i].lo && item_id <= kIconDats[i].hi) return i;
    return -1;
}
std::streamoff icon_offset(int item_id, IconDat const& d) {
    return std::streamoff(item_id - (d.lo + d.off)) * 0x1400 + 0x2BD;
}

}  // namespace

bool item_icon(std::string const& ffxi, int item_id, uint32_t out[kIconCell * kIconCell]) {
    int const di = icon_dat(item_id);
    if (di < 0) return false;
    IconDat const& d = kIconDats[di];
    std::ifstream f(ffxi + d.path, std::ios::binary);
    if (!f) return false;
    f.seekg(icon_offset(item_id, d));
    unsigned char data[0x800];
    f.read(reinterpret_cast<char*>(data), sizeof(data));
    if (f.gcount() != std::streamsize(sizeof(data))) return false;
    icon_from_record(data, out);
    return true;
}

bool IconDatReader::read(std::string const& ffxi_dir, int item_id, uint32_t out[kIconCell * kIconCell]) {
    int const di = icon_dat(item_id);
    if (di < 0) return false;
    if (ffxi_dir != ffxi) {
        close();
        ffxi = ffxi_dir;
    }
    IconDat const& d = kIconDats[di];
    if (!h[di]) {
        // shared for read, write and delete: an open handle never stands in anyone's way
        HANDLE const f = CreateFileA((ffxi + d.path).c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
                                     nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
        if (f == INVALID_HANDLE_VALUE) return false;
        h[di] = f;
    }
    unsigned char data[0x800];
    OVERLAPPED ov {};
    long long const off = icon_offset(item_id, d);
    ov.Offset = DWORD(off & 0xFFFFFFFF);
    ov.OffsetHigh = DWORD(off >> 32);
    DWORD got = 0;
    if (!ReadFile(static_cast<HANDLE>(h[di]), data, sizeof(data), &got, &ov) || got != sizeof(data)) return false;
    icon_from_record(data, out);
    return true;
}

void IconDatReader::close() {
    for (void*& f : h)
        if (f) {
            CloseHandle(static_cast<HANDLE>(f));
            f = nullptr;
        }
    ffxi.clear();
}

void TextureStore::clear() {
    pics.clear();
    icons.clear();
#ifdef NUI_FAULT_HANDLES_RESTART          // self-test: handles start again at 2 after stop() (before 1.2.6)
    next = 2;
#endif
    dat.close();
}

bool TextureStore::prepare(std::string const& path, int max_w, int max_h, Picture& out, std::string& err,
                           std::vector<unsigned char>* bytes_out) {
    std::vector<unsigned char> bytes;
    std::streamoff size = 0;
    // 1.2.6 (review HOST-10): a large file is sized from its head here and read on the decode thread
#ifndef NUI_FAULT_LUA_READS_ALL           // self-test: every file read and hashed whole on this thread (before 1.2.6)
    std::size_t const head = kReadAllBytes;
#else
    std::size_t const head = 0;
#endif
    if (!slurp(path, bytes, head, &size)) {
        err = "cannot decode " + path + ": cannot open the file";
        return false;
    }
    bool deferred = std::streamoff(bytes.size()) < size;
    if (!image_signature_ok(bytes.data(), bytes.size())) {
        err = "cannot decode " + path + ": not a PNG, JPEG or BMP file";
        return false;
    }
    int iw = 0, ih = 0, comp = 0;
    bool info = bytes.size() <= 0x7FFFFFFF && stbi_info_from_memory(bytes.data(), int(bytes.size()), &iw, &ih, &comp);
    if (!info && deferred) {              // the header lies past the head (a JPEG's metadata): read it all
        deferred = false;
        info = slurp(path, bytes) && bytes.size() <= 0x7FFFFFFF && stbi_info_from_memory(bytes.data(), int(bytes.size()), &iw, &ih, &comp);
    }
    if (!info) {
        err = "cannot decode " + path + ": " + (stbi_failure_reason() ? stbi_failure_reason() : "?");
        return false;
    }
    std::string why;
    if (!source_size_ok(iw, ih, why)) {
        err = "cannot decode " + path + ": " + why;
        return false;
    }
    out = Picture();
    out.path = path;
    out.max_w = max_w;
    out.max_h = max_h;
    out.read = bytes.size();
    out.deferred = deferred;
    out.hash = deferred ? 0 : nc_fnv1a64(bytes.data(), bytes.size());
    if (deferred) std::vector<unsigned char>().swap(bytes);
    fit_size(iw, ih, max_w, max_h, out.w, out.h);
    if (out.w > 4096 || out.h > 4096) {
        err = "image larger than 4096 px";
        return false;
    }
    if (bytes_out) bytes_out->swap(bytes);
    return true;
}

bool TextureStore::free(int handle) {
    return handle >= 2 && pics.erase(handle) > 0;
}

bool TextureStore::icon_exists(int item_id, bool (*have_it)(int, std::uint64_t)) {
    if (item_id <= 0 || item_id > 65535 || ffxi.empty()) return false;
    auto it = icons.find(item_id);
    if (it != icons.end()) return it->second.exists;
    Icon& ic = icons[item_id];
    if (have_it && have_it(item_id, install)) {
        ic.exists = true;
        return true;
    }
    uint32_t px[kIconCell * kIconCell];
    ic.exists = item_icon(ffxi, item_id, px);
    if (ic.exists) ic.px.assign(px, px + kIconCell * kIconCell);
    return ic.exists;
}

bool TextureStore::cut_icon(int item_id, std::vector<uint32_t>& px) {
    uint32_t cell[kIconCell * kIconCell];
    if (ffxi.empty() || !dat.read(ffxi, item_id, cell)) return false;
    px.assign(cell, cell + kIconCell * kIconCell);
    return true;
}

bool TextureStore::picture_pixels(int handle, std::vector<uint32_t>& px, int& w, int& h) {
    auto it = pics.find(handle);
    if (it == pics.end()) return false;
    Picture const& p = it->second;
    if (!p.px.empty()) {
        px = p.px;
        w = p.w;
        h = p.h;
        return true;
    }
    std::string err;
    if (p.path.empty() || !decode_image(p.path, p.max_w, p.max_h, px, w, h, err)) return false;
#ifndef NUI_FAULT_NO_SIZE_CHECK           // self-test: a re-read file of another size is used (before 1.2.6)
    if (w != p.w || h != p.h) {           // the file changed since tex_load (review REND-4)
        std::vector<uint32_t>().swap(px);
        return false;
    }
#endif
    return true;
}

bool TextureStore::icon_pixels(int item_id, std::vector<uint32_t>& px) {
    auto it = icons.find(item_id);
    if (it == icons.end() || !it->second.exists) return false;
    if (!it->second.px.empty()) {
        px = it->second.px;
        return true;
    }
    uint32_t cell[kIconCell * kIconCell];
    if (!item_icon(ffxi, item_id, cell)) return false;
    px.assign(cell, cell + kIconCell * kIconCell);
    return true;
}

void TextureStore::made(int handle) {
    if (is_icon_handle(handle)) {
        auto it = icons.find(icon_of(handle));
        if (it != icons.end()) std::vector<uint32_t>().swap(it->second.px);
        return;
    }
    auto it = pics.find(handle);
    if (it != pics.end()) std::vector<uint32_t>().swap(it->second.px);
}

}  // namespace nui
