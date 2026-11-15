// client.hpp - facts read from the game client's memory (FFXiMain.dll), read-only and fail-closed:
// its folder, its sections, the UI size and the config table (window type = config id 18). Each
// signature is searched for once per module; nothing is ever written.
#pragma once
#include "device.hpp"

#include <cstdint>
#include <string>
#include <vector>

namespace nui {

// The folder holding FFXiMain.dll, ending with a backslash, as UTF-8. False when the game is not
// loaded. 1.2.10: read wide and with no fixed buffer, so an install whose path the system ANSI
// codepage cannot spell, or one deeper than MAX_PATH, still resolves.
bool find_ffxi_dir(std::string& out);

// A path as the OS wants it. The narrow paths this library carries are UTF-8 when nui made them
// (find_ffxi_dir) and the system ANSI codepage when they came from Lua (Windower hands ANSI), so
// this reads UTF-8 and falls back to ANSI when the bytes are not valid UTF-8; an ASCII path, which
// is every ordinary install, is the same either way. A path at or over MAX_PATH that names a drive
// gets the \\?\ prefix. Every file nui opens goes through here: before 1.2.10 they went through the
// ANSI CRT, so an install under a folder the codepage cannot spell read nothing at all.
std::wstring to_wide(std::string const& path);

// An open read handle, shared for read, write and delete so it never stands in anyone's way.
// INVALID_HANDLE_VALUE when the file cannot be opened.
void* file_open(std::string const& path);

// The whole file in one read, refused over `cap` bytes; `limit` (0 = all) caps what is copied out,
// `size` (optional) takes the file's real size. False when it cannot be opened or read in full.
bool file_read(std::string const& path, std::vector<unsigned char>& out, std::uint64_t cap,
               std::size_t limit = 0, std::uint64_t* size = nullptr);

// `n` bytes at `off`. False when the file cannot be opened or holds fewer.
bool file_read_at(std::string const& path, std::uint64_t off, void* dst, std::size_t n);

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
