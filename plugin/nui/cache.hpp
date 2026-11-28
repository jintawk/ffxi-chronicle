// cache.hpp - how the renderer uses the shared texture cache (NuiCache/NuiCache.h, design C): the
// one include for every library file that touches it (so every translation unit of a module sees
// the same NUICACHE_* settings), the per-kind keys and their pixel format versions.
//
// What goes through the cache, per kind (C.3):
//   NC_ATLAS      a = window type 1-8, hash = the install folder: the game art atlas, i.e. the
//                 window type's frame + body, the chat font (moji), the title font and the gauge
//   NC_ITEM_ICON  a = item id, hash = the install folder: one 32 x 32 icon per entry (C.8)
//   NC_PICTURE    a, b = max w, h asked for, hash = FNV-1a 64 of the file's bytes (content, not path)
// fmt is the kind's pixel format version: bump it whenever the decode of that kind changes a single
// output byte, so two library versions that decode differently never share a texture.
// test/golden_fmt.json holds each kind's pixel hash with its fmt; test_render fails when the
// pixels change and the fmt does not.
// A change that lets a load succeed where it failed before changes the output too, even when a stock
// install decodes exactly as it did. The golden only sees a stock install, so it cannot catch that: bump
// the fmt by hand (atlas 3, below).
#pragma once

#ifdef NUI_TEST_CLOCK                    // test: every module of a test reads the driver's clock
extern "C" unsigned long __cdecl nui_test_now();
#define NUICACHE_NOW() nui_test_now()
#endif
#include "NuiCache/NuiCache.h"

#include <cstdint>
#include <string>

namespace nui {

// atlas 2 (1.2.3): + 'menu    menu2fon'. atlas 3: an HD texture pack's art, boxed down to the game's
// size. 1.2.10 cannot read it, so under atlas 2 a module on each version would share one entry, and the
// first to create it would decide whether the other drew any window art.
constexpr std::uint32_t kFmtAtlas = 3, kFmtIcon = 1, kFmtPicture = 1;

inline NcKey atlas_key(int window_type, std::uint64_t install) {
    return NcKey {NC_ATLAS, kFmtAtlas, std::uint32_t(window_type), 0, install};
}
inline NcKey icon_key(int item_id, std::uint64_t install) {
    return NcKey {NC_ITEM_ICON, kFmtIcon, std::uint32_t(item_id), 0, install};
}
inline NcKey picture_key(int max_w, int max_h, std::uint64_t content) {
    return NcKey {NC_PICTURE, kFmtPicture, std::uint32_t(max_w), std::uint32_t(max_h), content};
}

}  // namespace nui
