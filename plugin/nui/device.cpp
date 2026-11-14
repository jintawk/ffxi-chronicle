// device.cpp - see device.hpp
#include "device.hpp"

#include <cstring>

namespace nui {

bool page_readable(DWORD protect) {
    if (protect & (PAGE_GUARD | PAGE_NOACCESS)) return false;
    switch (protect & 0xFF) {
    case PAGE_READONLY: case PAGE_READWRITE: case PAGE_WRITECOPY:
    case PAGE_EXECUTE_READ: case PAGE_EXECUTE_READWRITE: case PAGE_EXECUTE_WRITECOPY:
        return true;
    default:
        return false;
    }
}

bool span_readable(std::uintptr_t address, std::size_t size) {
    if (address == 0 || size == 0) return false;
    MEMORY_BASIC_INFORMATION region {};
    if (!VirtualQuery(reinterpret_cast<void const*>(address), &region, sizeof(region))) return false;
    if (region.State != MEM_COMMIT || !page_readable(region.Protect)) return false;
    std::uintptr_t const low = reinterpret_cast<std::uintptr_t>(region.BaseAddress);
    return address >= low && address + size <= low + region.RegionSize;
}

bool exec_page(std::uintptr_t a) {
    MEMORY_BASIC_INFORMATION r {};
    if (!a || !VirtualQuery(reinterpret_cast<void const*>(a), &r, sizeof(r)) || r.State != MEM_COMMIT) return false;
    DWORD const p = r.Protect & 0xFF;
    return p == PAGE_EXECUTE || p == PAGE_EXECUTE_READ || p == PAGE_EXECUTE_READWRITE || p == PAGE_EXECUTE_WRITECOPY;
}

bool DeviceCheck::plausible(std::uintptr_t dev) {
    if (dev == checked) return ok;
    checked = dev;
    ok = false;
    std::uint32_t vt = 0;
    if (!span_readable(dev, 4)) return false;
    std::memcpy(&vt, reinterpret_cast<void const*>(dev), 4);
    if (!span_readable(vt, 4 * 97)) return false;     // IDirect3DDevice8 has 97 methods
    // AddRef, Release, CreateTexture, GetRenderTarget, EndScene, Set/GetViewport, Set/GetRenderState,
    // Get/SetTexture, Get/SetTextureStageState, DrawPrimitiveUP, Set/GetVertexShader, Set/GetPixelShader
    static int const slots[] = {1, 2, 20, 32, 35, 40, 41, 50, 51, 60, 61, 62, 63, 72, 76, 77, 88, 89};
    for (int s : slots) {
        std::uint32_t e = 0;
        std::memcpy(&e, reinterpret_cast<void const*>(vt + s * 4), 4);
        if (!exec_page(e)) return false;
    }
    ok = true;
    return true;
}

}  // namespace nui
