// ops.hpp - drawing commands built by Lua, parsed once and replayed into a DrawList (ops.cpp).
#pragma once
#include "textures.hpp"
#include "ui.hpp"

#include <cstddef>
#include <cstdint>
#include <set>
#include <string>
#include <vector>

namespace nui {

struct Cmd {
    char k;
    float f[10];
    uint32_t col;
    std::string s;
};

// text -> commands, or false with err ("line N: ...")
bool ops_parse(std::string const& text, std::vector<Cmd>& out, std::string& err);
// the same on n bytes at text (1.2.0: parsed in place, so a Lua string needs no copy; text[n] is never read)
bool ops_parse(char const* text, std::size_t n, std::vector<Cmd>& out, std::string& err);
// item ids drawn by I commands
void ops_icons(std::vector<Cmd> const& cmds, std::set<int>& ids);
// commands -> quads; an I command draws icon_handle(id) when the store says the item has an icon
// (learned from the DATs the first time, or from have_icon: a module holds it in the shared cache)
void ops_replay(Ui& ui, std::vector<Cmd> const& cmds, TextureStore* store,
                bool (*have_icon)(int item_id, std::uint64_t install) = nullptr);
// ops_replay = ops_draw, then merge_batches(ui.dl) (1.2.0). ops_draw alone leaves the batches in
// command order (the tests compare it with the reference build)
void ops_draw(Ui& ui, std::vector<Cmd> const& cmds, TextureStore* store,
              bool (*have_icon)(int item_id, std::uint64_t install) = nullptr);
// parse + replay in one go (the offline renderer); count, or -1 with err
int ops_text(Ui& ui, std::string const& text, std::string& err, TextureStore* store = nullptr);
int ops_scene(Ui& ui, std::string const& path, std::string& err, TextureStore* store = nullptr);

}  // namespace nui
