// client.hpp - facts read from the game client's memory (FFXiMain.dll), read-only and fail-closed:
// its folder, its sections, the UI size and the config table (window type = config id 18). Each
// signature is searched for once per module; nothing is ever written.
#pragma once
#include "device.hpp"

#include <cstdint>
#include <string>
#include <vector>

namespace nui {

// The folder holding FFXiMain.dll, ending with a backslash. False when the game is not loaded.
bool find_ffxi_dir(std::string& out);

std::uintptr_t ffxi_base();

struct Section {
    std::uintptr_t start, size;
    bool exec, write;
};
std::vector<Section> ffxi_sections();

// Calls fn(address, bytes, n) for each committed readable run inside [begin, end).
template <typename Fn>
void each_readable_run(std::uintptr_t begin, std::uintptr_t end, Fn fn) {
    std::uintptr_t a = begin;
    while (a < end) {
        MEMORY_BASIC_INFORMATION r {};
        if (!VirtualQuery(reinterpret_cast<void const*>(a), &r, sizeof(r))) break;
        std::uintptr_t const re = reinterpret_cast<std::uintptr_t>(r.BaseAddress) + r.RegionSize;
        if (re <= a) break;
        std::uintptr_t const lim = re < end ? re : end;
        if (r.State == MEM_COMMIT && page_readable(r.Protect))
            fn(a, reinterpret_cast<unsigned char const*>(a), std::size_t(lim - a));
        a = re;
    }
}

// The game's UI size (its menu resolution). False until the client has set it up, or when the
// getter's signature is not found exactly once.
bool read_ui_size(int& w, int& h);
std::uintptr_t ui_size_global();      // the global the getter reads, 0 = not found (status)

// A value in the client's config table by config id. False when the table is not there yet, the
// signature is not unique, or the entry at that index does not carry that id.
bool read_config(int id, int& value);
std::uintptr_t config_global();       // the config manager global, 0 = not found (status)

}  // namespace nui
