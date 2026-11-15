// client.cpp - see client.hpp
#include "client.hpp"

#include <cstring>

namespace nui {

namespace {
std::string from_wide(std::wstring const& w) {
    int const n = WideCharToMultiByte(CP_UTF8, 0, w.c_str(), int(w.size()), nullptr, 0, nullptr, nullptr);
    if (n <= 0) return {};
    std::string out(std::size_t(n), '\0');
    WideCharToMultiByte(CP_UTF8, 0, w.c_str(), int(w.size()), &out[0], n, nullptr, nullptr);
    return out;
}

std::wstring widen(std::string const& s, UINT cp, DWORD flags) {
    int const n = MultiByteToWideChar(cp, flags, s.c_str(), int(s.size()), nullptr, 0);
    if (n <= 0) return {};
    std::wstring out(std::size_t(n), L'\0');
    MultiByteToWideChar(cp, flags, s.c_str(), int(s.size()), &out[0], n);
    return out;
}
}  // namespace

std::wstring to_wide(std::string const& path) {
    std::wstring w = widen(path, CP_UTF8, MB_ERR_INVALID_CHARS);
    if (w.empty() && !path.empty()) w = widen(path, CP_ACP, 0);     // not UTF-8: Lua handed ANSI
    // \\?\ turns off the MAX_PATH limit, but only for a full drive path with no forward slash in it
    if (w.size() >= MAX_PATH && w.size() > 3 && w[1] == L':' && w[2] == L'\\' &&
        w.find(L'/') == std::wstring::npos && w.compare(0, 4, L"\\\\?\\") != 0)
        w.insert(0, L"\\\\?\\");
    return w;
}

void* file_open(std::string const& path) {
#ifdef NUI_FAULT_ANSI_PATHS               // self-test: the ANSI opens of before 1.2.10 (issue 10)
    return CreateFileA(path.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr,
                       OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
#else
    std::wstring const w = to_wide(path);
    if (w.empty()) return INVALID_HANDLE_VALUE;
    return CreateFileW(w.c_str(), GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE, nullptr,
                       OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
#endif
}

bool file_read(std::string const& path, std::vector<unsigned char>& out, std::uint64_t cap, std::size_t limit,
               std::uint64_t* size) {
    HANDLE const f = static_cast<HANDLE>(file_open(path));
    if (f == INVALID_HANDLE_VALUE) return false;
    LARGE_INTEGER n {};
    if (!GetFileSizeEx(f, &n) || n.QuadPart < 0 || std::uint64_t(n.QuadPart) > cap) {
        CloseHandle(f);
        return false;
    }
    if (size) *size = std::uint64_t(n.QuadPart);
    std::uint64_t const take = limit && std::uint64_t(limit) < std::uint64_t(n.QuadPart) ? std::uint64_t(limit)
                                                                                        : std::uint64_t(n.QuadPart);
    out.resize(std::size_t(take));
    std::uint64_t done = 0;
    while (done < take) {                       // ReadFile can return short on a huge read
        DWORD const want = DWORD(take - done > 0x1000000u ? 0x1000000u : take - done);
        DWORD got = 0;
        if (!ReadFile(f, out.data() + done, want, &got, nullptr) || got == 0) break;
        done += got;
    }
    CloseHandle(f);
    return done == take;
}

bool file_read_at(std::string const& path, std::uint64_t off, void* dst, std::size_t n) {
    HANDLE const f = static_cast<HANDLE>(file_open(path));
    if (f == INVALID_HANDLE_VALUE) return false;
    OVERLAPPED ov {};
    ov.Offset = DWORD(off & 0xFFFFFFFFu);
    ov.OffsetHigh = DWORD(off >> 32);
    DWORD got = 0;
    bool const ok = ReadFile(f, dst, DWORD(n), &got, &ov) != 0 && got == n;
    CloseHandle(f);
    return ok;
}

bool find_ffxi_dir(std::string& out) {
    HMODULE m = GetModuleHandleA("FFXiMain.dll");
    if (!m) return false;
    std::wstring path(MAX_PATH, L'\0');
    for (;;) {
        DWORD const n = GetModuleFileNameW(m, &path[0], DWORD(path.size()));
        if (n == 0) return false;
        if (n < path.size()) {                  // n == size: truncated (and ERROR_INSUFFICIENT_BUFFER)
            path.resize(n);
            break;
        }
        if (path.size() >= 0x8000) return false;
        path.resize(path.size() * 2);
    }
    std::size_t const slash = path.find_last_of(L'\\');
    if (slash == std::wstring::npos) return false;
    path.resize(slash + 1);
    out = from_wide(path);
    return !out.empty();
}

std::uintptr_t ffxi_base() { return reinterpret_cast<std::uintptr_t>(GetModuleHandleA("FFXiMain.dll")); }

std::vector<Section> ffxi_sections() {
    std::vector<Section> out;
    std::uintptr_t const base = ffxi_base();
    if (!base || !span_readable(base, sizeof(IMAGE_DOS_HEADER))) return out;
    auto const* dos = reinterpret_cast<IMAGE_DOS_HEADER const*>(base);
    if (dos->e_magic != IMAGE_DOS_SIGNATURE) return out;
    std::uintptr_t const nt_at = base + static_cast<std::uintptr_t>(dos->e_lfanew);
    if (!span_readable(nt_at, sizeof(IMAGE_NT_HEADERS32))) return out;
    auto const* nt = reinterpret_cast<IMAGE_NT_HEADERS32 const*>(nt_at);
    if (nt->Signature != IMAGE_NT_SIGNATURE) return out;
    auto const* sec = IMAGE_FIRST_SECTION(nt);
    for (unsigned i = 0; i < nt->FileHeader.NumberOfSections; ++i, ++sec) {
        out.push_back({base + sec->VirtualAddress, sec->Misc.VirtualSize,
                       (sec->Characteristics & IMAGE_SCN_MEM_EXECUTE) != 0,
                       (sec->Characteristics & IMAGE_SCN_MEM_WRITE) != 0});
    }
    return out;
}

// The UI size: `A1 <ptr> 66 8B 40 18 C3` (mov eax,[ptr]; mov ax,[eax+18h]; ret), the client's getter
// 0x10015680; width u16 at [ptr]+0x18, height at +0x1A. Searched for once.
namespace {
std::uintptr_t g_ui_ptr = 0;
bool g_ui_searched = false;
std::uintptr_t g_cfg_ptr = 0;
bool g_cfg_searched = false;
}  // namespace

std::uintptr_t ui_size_global() { return g_ui_ptr; }
std::uintptr_t config_global() { return g_cfg_ptr; }

bool read_ui_size(int& w, int& h) {
    w = h = 0;
    if (!g_ui_searched) {
        g_ui_searched = true;
        int count = 0;
        std::uintptr_t ptr = 0;
        for (Section const& sec : ffxi_sections()) {
            if (!sec.exec) continue;
            each_readable_run(sec.start, sec.start + sec.size, [&](std::uintptr_t, unsigned char const* b, std::size_t n) {
                for (std::size_t i = 0; i + 10 <= n; ++i) {
                    if (b[i] == 0xA1 && b[i + 5] == 0x66 && b[i + 6] == 0x8B && b[i + 7] == 0x40 && b[i + 8] == 0x18 &&
                        b[i + 9] == 0xC3) {
                        std::uint32_t p = 0;
                        std::memcpy(&p, b + i + 1, 4);
                        if (count == 0) ptr = p;
                        ++count;
                    }
                }
            });
        }
        g_ui_ptr = count == 1 ? ptr : 0;
    }
    if (!g_ui_ptr || !span_readable(g_ui_ptr, 4)) return false;
    std::uint32_t obj = 0;
    std::memcpy(&obj, reinterpret_cast<void const*>(g_ui_ptr), 4);
    if (!span_readable(obj, 0x1C)) return false;
    std::uint16_t uw = 0, uh = 0;
    std::memcpy(&uw, reinterpret_cast<void const*>(obj + 0x18), 2);
    std::memcpy(&uh, reinterpret_cast<void const*>(obj + 0x1A), 2);
    w = uw;
    h = uh;
    return true;
}

// The client's config table. Its registration function 0x10193800 begins
//   8B 0D <mgr> 85 C9 74 ?? 8B 44 24 0C 8B 54 24 08 50 8B 44 24 08 52 50 E8 ?? ?? ?? ?? B8 01 00 00 00
//   C3 83 C8 FF C3
// (unique in .text). [mgr] is the config manager; [[mgr]+4] its 0x2C-byte entries, indexed by config
// id: +4 the id, +8 the value (define 0x10195460, lookup 0x101954d0). Window type is id 18, 0-7
// (0-based; defined with max 7, changed through callback 0x101aaa90 case 5 -> 0x10160440, which loads
// ROM/0/(value + 14).DAT).
bool read_config(int id, int& value) {
    if (!g_cfg_searched) {
        g_cfg_searched = true;
        static int const sig[] = {0x8B, 0x0D, -1, -1, -1, -1, 0x85, 0xC9, 0x74, -1, 0x8B, 0x44, 0x24, 0x0C, 0x8B, 0x54,
                                  0x24, 0x08, 0x50, 0x8B, 0x44, 0x24, 0x08, 0x52, 0x50, 0xE8, -1, -1, -1, -1, 0xB8, 0x01,
                                  0x00, 0x00, 0x00, 0xC3, 0x83, 0xC8, 0xFF, 0xC3};
        std::size_t const n = sizeof(sig) / sizeof(sig[0]);
        int count = 0;
        std::uintptr_t ptr = 0;
        for (Section const& sec : ffxi_sections()) {
            if (!sec.exec) continue;
            each_readable_run(sec.start, sec.start + sec.size, [&](std::uintptr_t, unsigned char const* b, std::size_t len) {
                for (std::size_t i = 0; i + n <= len; ++i) {
                    if (b[i] != 0x8B || b[i + 1] != 0x0D) continue;
                    std::size_t k = 0;
                    while (k < n && (sig[k] < 0 || b[i + k] == sig[k])) ++k;
                    if (k == n) {
                        std::uint32_t p = 0;
                        std::memcpy(&p, b + i + 2, 4);
                        if (count == 0) ptr = p;
                        ++count;
                    }
                }
            });
        }
        g_cfg_ptr = count == 1 ? ptr : 0;
    }
    if (!g_cfg_ptr || !span_readable(g_cfg_ptr, 4)) return false;
    std::uint32_t mgr = 0, entries = 0;
    std::memcpy(&mgr, reinterpret_cast<void const*>(g_cfg_ptr), 4);
    if (!span_readable(mgr + 4, 4)) return false;
    std::memcpy(&entries, reinterpret_cast<void const*>(mgr + 4), 4);
    std::uintptr_t const e = entries + std::uintptr_t(id) * 0x2C;
    if (!entries || !span_readable(e + 4, 8)) return false;
    std::int32_t got_id = 0, v = 0;
    std::memcpy(&got_id, reinterpret_cast<void const*>(e + 4), 4);
    std::memcpy(&v, reinterpret_cast<void const*>(e + 8), 4);
    if (got_id != id) return false;              // not the table we think it is: fail closed
    value = v;
    return true;
}

}  // namespace nui
