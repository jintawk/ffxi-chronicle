// textures.hpp - what a module's textures are made from, by handle, for the draw list's quads.
//
//   handle 0                    the atlas (assets.hpp), owned by Assets
//   handle 2+                   pictures decoded from PNG / JPEG / BMP files (stb_image), downscaled
//   icon_handle(id)             one item icon, 32 x 32, cut from the game's item DATs (read-only)
//
// The GPU textures themselves come from the shared cache (cache.hpp) at draw time; this store only
// keeps what is needed to make one: pixels decoded ahead of the first frame (dropped once the
// texture exists) and the recipe to make it again (the file, the icon id). 1.2.1: a picture whose
// texture another module holds is not decoded at all (the module's hold on it waits in `held`), and
// any other picture is decoded on the host's decode thread (`job`), never on the Lua thread.
#pragma once
#include "cache.hpp"

#include <cstdint>
#include <map>
#include <set>
#include <string>
#include <vector>

namespace nui {

constexpr int kIconCell = 32;
constexpr int kTexIconBase = 0x01000000;           // icon handles: kTexIconBase + item id (1-65535)
inline int icon_handle(int item_id) { return kTexIconBase + item_id; }
inline bool is_icon_handle(int h) { return h > kTexIconBase && h <= kTexIconBase + 65535; }
inline int icon_of(int h) { return h - kTexIconBase; }

struct Picture {
    std::string path;
    int max_w = 0, max_h = 0;
    int w = 0, h = 0;                // the fitted size
    std::uint64_t hash = 0;          // FNV-1a 64 of the file's bytes (the cache key)
    std::vector<uint32_t> px;        // decoded ahead of the first frame; empty once the texture exists
    NcRef held {};                   // 1.2.1: a hold on the cache entry another module made (no decode), until attached
    std::uint64_t job = 0;           // 1.2.1: its decode on the decode thread, until the pixels arrive (0 none)
    bool bad = false;                // 1.2.1: the decode thread could not decode it: never drawn
    bool deferred = false;           // 1.2.6: a file over kReadAllBytes: read and hashed on the decode thread (hash 0 until then)
    std::size_t read = 0;            // 1.2.6: bytes prepare() read on the calling thread
};

// 1.2.6 (review HOST-10): tex_load reads and hashes a file of up to this many bytes on the Lua thread
// (a typical picture: about a millisecond); of a larger one only this many, for the header, and the
// decode thread reads, hashes and decodes it.
constexpr std::size_t kReadAllBytes = 1u << 20;

// 1.2.6 (review REND-2): the first bytes are a PNG, JPEG or BMP signature (the only formats stb_image is
// built with), checked before any of stb's parsers sees the file.
bool image_signature_ok(unsigned char const* data, std::size_t n);
// "cannot decode <path>: <reason>" from a decode error (review REND-4: never throws, whatever err holds)
std::string decode_error(std::string const& path, std::string const& err);

struct Icon {
    bool exists = false;
    std::vector<uint32_t> px;        // 32 x 32, cut ahead of the first frame; empty once it exists
};

// The size a w x h image is fitted to inside max_w x max_h (0 = no limit), keeping its aspect.
void fit_size(int iw, int ih, int max_w, int max_h, int& w, int& h);

// Decodes an image file (or its bytes) into ARGB, fitted inside max_w x max_h by area averaging.
bool decode_image(std::string const& path, int max_w, int max_h, std::vector<uint32_t>& px, int& w, int& h,
                  std::string& err);
bool decode_image_mem(unsigned char const* data, std::size_t n, int max_w, int max_h, std::vector<uint32_t>& px,
                      int& w, int& h, std::string& err);
// Reads a whole file of at most 64 MiB. false when it cannot be opened or read, or is larger.
bool read_file(std::string const& path, std::vector<unsigned char>& out);

// One 32 x 32 item icon from the game's item DATs (ffxi ends with a backslash), ARGB rows top first.
// Opens the DAT for this one read.
bool item_icon(std::string const& ffxi, int item_id, uint32_t out[kIconCell * kIconCell]);

// The same cut through one open handle per icon DAT (1.2.0): a seek and a 2 KB read instead of an
// open. One reader per thread: the host keeps one, used only on the Lua (worker) thread.
struct IconDatReader {
    std::string ffxi;
    void* h[16] = {};                // HANDLE per kIconDats entry, null until first used
    bool read(std::string const& ffxi_dir, int item_id, uint32_t out[kIconCell * kIconCell]);
    void close();
    ~IconDatReader() { close(); }
};

struct TextureStore {
    std::map<int, Picture> pics;     // handle 2+ -> picture
    std::map<int, Icon> icons;       // item id -> icon (exists or not), learned on first use
    int next = 2;                    // never reset (review HOST-8): a handle is never reused, not even after stop()
    std::string ffxi;
    std::uint64_t install = 0;       // nc_hash_path(ffxi): the icon / atlas cache keys
    IconDatReader dat;               // the Lua thread's open icon DATs (cut_icon)

    // Reads the file, hashes it and fits its size from its header (stb_image's info); never decodes
    // (1.2.1). The file's bytes are handed to `bytes` when it is not null (the decode thread decodes
    // them). A file over kReadAllBytes (1.2.6) is only sized from its first kReadAllBytes: out.deferred,
    // hash 0, `bytes` empty. -> false with err ("cannot decode <path>: ...").
    static bool prepare(std::string const& path, int max_w, int max_h, Picture& out, std::string& err,
                        std::vector<unsigned char>* bytes);
    bool free(int handle);
    // whether the item has an icon; the first time an id is seen its icon is cut from the DATs
    // (unless have_it says a module holds it already)
    bool icon_exists(int item_id, bool (*have_it)(int item_id, std::uint64_t install));
    // pixels to make a texture from: the ones decoded ahead, or decoded again now (false when the
    // file now decodes to another size than the picture's: its quads were laid out for that size)
    bool picture_pixels(int handle, std::vector<uint32_t>& px, int& w, int& h);
    bool icon_pixels(int item_id, std::vector<uint32_t>& px);
    // an icon's pixels through `dat` (Lua thread only): false when the item has no icon
    bool cut_icon(int item_id, std::vector<uint32_t>& px);
    void made(int handle);           // the texture exists: drop the CPU copy
    void clear();
};

}  // namespace nui
