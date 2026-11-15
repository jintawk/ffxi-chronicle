// ChronicleModule.cpp - _chronicle.dll, the native half of Chronicle: the glue around the
// vendored nui library (plugin/nui, canonical source tools/nui in the Windower repository).
//
// Everything the module does is the library's generic host (nui/host.hpp): it joins UiHook (one
// shared patch of FFXiMain's EndScene wrapper for every native-UI module) and draws Chronicle's
// layers in the game's own look above the game's UI. Owns no game logic and no input. The Lua API
// (start, stop, status, screen, layer, layer_pos, tex_load, tex_free, icon, icon_pixels, metrics,
// wintype, wtfind, wtwatch, wtread, version) is listed in nui/host.hpp. start() returns a third
// value, retry_ms, while the hook is not there yet (core/nui.lua starts again after it).

#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include "host.hpp"

namespace {
nui::HostConfig const kConfig {"chronicle", "2.0.1"};
}  // namespace

BOOL WINAPI DllMain(HINSTANCE, DWORD reason, LPVOID) {
    if (reason == DLL_PROCESS_DETACH) nui::host_detach();
    return TRUE;
}

extern "C" __declspec(dllexport) int __cdecl luaopen__chronicle(lua_State* L) {
    return nui::host_open(L, kConfig);
}
