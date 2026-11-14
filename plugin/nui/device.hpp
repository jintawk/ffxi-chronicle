// device.hpp - guarded memory reads (VirtualQuery only: no loader lock, safe on the render thread)
// and the plausibility check for the D3D8 device a draw callback is handed.
#pragma once
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include <cstddef>
#include <cstdint>

namespace nui {

bool page_readable(DWORD protect);
// [address, address + size) committed, readable and inside one region
bool span_readable(std::uintptr_t address, std::size_t size);
// a committed executable page holds address
bool exec_page(std::uintptr_t address);

// The device the game is about to EndScene: its vtable must be readable and the slots the backend
// calls executable. The answer is kept per pointer (checked once per new device).
struct DeviceCheck {
    std::uintptr_t checked = 0;      // last pointer checked
    bool ok = false;                 // its answer
    bool plausible(std::uintptr_t dev);
    void reset() { checked = 0; }
};

}  // namespace nui
