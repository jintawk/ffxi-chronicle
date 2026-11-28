// pad.cpp - see pad.hpp
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include "pad.hpp"

#include "PadHook/PadHook.h"

#include <cstdio>
#include <cstring>

namespace nui {
namespace {

LuaApi& L_ = lua();
PadBus* g_pbus = nullptr;
int g_pslot = -1;
char g_pname[16] = "nui";

void set_num(lua_State* L, char const* k, double v) { L_.pushnumber(L, v); L_.setfield(L, -2, k); }
void set_str(lua_State* L, char const* k, char const* v) { L_.pushstring(L, v); L_.setfield(L, -2, k); }
void set_bool(lua_State* L, char const* k, bool v) { L_.pushboolean(L, v ? 1 : 0); L_.setfield(L, -2, k); }

char const* state_name(int st) {
    switch (st) {
    case PADHOOK_LIVE: return "live";
    case PADHOOK_WAIT: return "waiting";
    case PADHOOK_BLOCKED: return "blocked";
    default: return "no bus";
    }
}

// The client's own settings: HKLM\SOFTWARE\PlayOnline<region>\SquareEnix\FinalFantasyXI (the 32-bit view),
// values padmode000 and padsin000 as the client's config tool writes them (comma-separated numbers).
bool read_value(HKEY key, char const* name, char* out, DWORD cap) {
    DWORD type = 0, size = cap - 1;
    if (RegQueryValueExA(key, name, nullptr, &type, reinterpret_cast<BYTE*>(out), &size) != ERROR_SUCCESS) return false;
    if (type != REG_SZ && type != REG_EXPAND_SZ) return false;
    out[size < cap ? size : cap - 1] = 0;
    return true;
}

}  // namespace

void pad_set_name(char const* name) {
    if (!name) return;
    std::strncpy(g_pname, name, sizeof(g_pname) - 1);
    g_pname[sizeof(g_pname) - 1] = 0;
}

void pad_detach() {
    if (g_pbus && g_pslot >= 0) padhook_unregister(g_pbus, g_pslot, false);
    g_pslot = -1;
}

void pad_release() {
    if (g_pbus && g_pslot >= 0) padhook_unregister(g_pbus, g_pslot, true);
    g_pslot = -1;
}

int __cdecl l_pad_start(lua_State* L) {
    bool simulate = false;
    if (L_.gettop(L) >= 1 && L_.type(L, 1) == kTString) {
        char const* f = L_.tolstring(L, 1, nullptr);
        simulate = f && std::strstr(f, "nosig") != nullptr;
    }
    if (g_pslot >= 0 && !simulate) {
        L_.pushboolean(L, 1);
        L_.pushstring(L, "joined");
        return 2;
    }
    if (!g_pbus) g_pbus = padhook_attach();
    int const r = padhook_join(g_pbus, g_pname, simulate);
    if (r >= 0) {
        g_pslot = r;
        L_.pushboolean(L, 1);
        L_.pushstring(L, g_pbus->status);
        return 2;
    }
    L_.pushboolean(L, 0);
    L_.pushstring(L, r == PADHOOK_JOIN_NO_BUS ? "pad bus unavailable" : (r == PADHOOK_JOIN_FULL ? "pad bus full" : g_pbus->status));
    if (r == PADHOOK_JOIN_RETRY) {
        L_.pushnumber(L, PADHOOK_RETRY_MS);
        return 3;
    }
    return 2;
}

int __cdecl l_pad(lua_State* L) {
    if (!g_pbus || g_pslot < 0) { L_.pushnil(L); return 1; }
    padhook_alive(g_pbus, g_pslot);
    padhook_pin(g_pbus);                  // route 1: pins the client's shim once it is loaded (one read until then)
    LONG idx = g_pbus->last_index;
    if (idx < 0 || idx >= PADHOOK_INDEXES) idx = 0;
    PadState s {};
    if (!padhook_read(g_pbus, static_cast<int>(idx), &s)) {     // torn for now: the last value stays as it was
        L_.pushnumber(L, -1);
        return 1;
    }
    bool const on = s.connected != 0;
    L_.pushnumber(L, s.seq);
    L_.pushnumber(L, on ? s.buttons : 0);
    L_.pushnumber(L, on ? s.lt : 0);
    L_.pushnumber(L, on ? s.rt : 0);
    L_.pushnumber(L, on ? s.lx : 0);
    L_.pushnumber(L, on ? s.ly : 0);
    L_.pushnumber(L, on ? s.rx : 0);
    L_.pushnumber(L, on ? s.ry : 0);
    L_.pushnumber(L, on ? idx : -1);
    L_.pushboolean(L, padhook_holding(g_pbus, g_pslot) ? 1 : 0);
    return 10;
}

int __cdecl l_pad_capture(lua_State* L) {
    bool const on = L_.gettop(L) >= 1 && L_.toboolean(L, 1) != 0;
    if (!g_pbus || g_pslot < 0) { L_.pushboolean(L, 0); return 1; }
    padhook_capture(g_pbus, g_pslot, on);
    L_.pushboolean(L, 1);
    return 1;
}

int __cdecl l_pad_chord(lua_State* L) {
    double const v = L_.gettop(L) >= 1 && L_.type(L, 1) == kTNumber ? L_.tonumber(L, 1) : 0;
    if (!g_pbus || g_pslot < 0) { L_.pushboolean(L, 0); return 1; }
    padhook_chord(g_pbus, g_pslot, v > 0 ? static_cast<unsigned long>(v) & 0x3FFFFul : 0);
    L_.pushboolean(L, 1);
    return 1;
}

int __cdecl l_pad_config(lua_State* L) {
    static char const* const keys[] = {"SOFTWARE\\PlayOnlineUS\\SquareEnix\\FinalFantasyXI",
                                       "SOFTWARE\\PlayOnlineEU\\SquareEnix\\FinalFantasyXI",
                                       "SOFTWARE\\PlayOnline\\SquareEnix\\FinalFantasyXI"};
    for (char const* path : keys) {
        HKEY key = nullptr;
        if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, path, 0, KEY_READ | KEY_WOW64_32KEY, &key) != ERROR_SUCCESS) continue;
        char mode[128] = {}, sin[512] = {};
        bool const has_mode = read_value(key, "padmode000", mode, sizeof(mode));
        bool const has_sin = read_value(key, "padsin000", sin, sizeof(sin));
        RegCloseKey(key);
        if (!has_mode && !has_sin) continue;
        L_.createtable(L, 0, 3);
        set_str(L, "key", path);
        if (has_mode) set_str(L, "padmode", mode);
        if (has_sin) set_str(L, "padsin", sin);
        return 1;
    }
    L_.pushnil(L);
    L_.pushstring(L, "the game's pad settings were not found in the registry");
    return 2;
}

int __cdecl l_pad_status(lua_State* L) {
    PadBus* b = g_pbus ? g_pbus : padhook_attach();
    L_.createtable(L, 0, 16);
    int const st = padhook_state(b);
    set_str(L, "state", state_name(st));
    // rev 3: which route is live ("wrapper": FFXiMain's XInput wrapper, "export": xinput1_3.dll's export)
    set_str(L, "route", st != PADHOOK_LIVE ? "none" : (b->route == PADHOOK_ROUTE_WRAPPER ? "wrapper" : "export"));
    char line[256];
    padhook_describe(b, line, sizeof(line));
    set_str(L, "describe", line);
    set_bool(L, "joined", g_pslot >= 0);
    if (!b) return 1;
    set_num(L, "calls", b->calls);
    set_num(L, "installs", b->installs);
    set_num(L, "handovers", b->handovers);
    set_num(L, "lapses", b->lapses);
    set_num(L, "chord", b->chord.buttons);
    set_num(L, "clients", padhook_active_clients(b));
    set_num(L, "owner_rev", b->owner_rev);
    set_num(L, "rev", PADHOOK_REV);
    set_num(L, "slot", g_pslot);
    set_num(L, "index", b->last_index);
    set_bool(L, "holding", padhook_holding(b, g_pslot));
    set_bool(L, "shim", padhook_shim_loaded(b));      // route 1: the client has loaded xinputdll.dll
    set_bool(L, "pinned", padhook_pin(b));            // route 1: and this module has pinned it
    LONG const i = b->last_index >= 0 && b->last_index < PADHOOK_INDEXES ? b->last_index : 0;
    set_num(L, "masked", b->masks[i].masked);
    set_num(L, "hidden", b->masks[i].hidden);
    set_num(L, "reads", b->pads[i].reads);
    set_str(L, "source", b->pads[i].source == PADHOOK_SRC_XINPUT ? "xinput" : (b->pads[i].source == PADHOOK_SRC_DINPUT ? "dinput" : "none"));
    char site[16];
    std::snprintf(site, sizeof(site), "%08lX", static_cast<unsigned long>(b->site));
    set_str(L, "site", site);
    return 1;
}

int __cdecl l_pad_stop(lua_State* L) {
    pad_release();
    L_.pushstring(L, "stopped");
    return 1;
}

}  // namespace nui
