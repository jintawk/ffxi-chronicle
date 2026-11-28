// key.cpp - see key.hpp
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include "key.hpp"

#include "KeyHook/KeyHook.h"

#include <cstdio>
#include <cstring>

namespace nui {
namespace {

LuaApi& L_ = lua();
KeyBus* g_kbus = nullptr;
int g_kslot = -1;
char g_kname[16] = "nui";

void set_num(lua_State* L, char const* k, double v) { L_.pushnumber(L, v); L_.setfield(L, -2, k); }
void set_str(lua_State* L, char const* k, char const* v) { L_.pushstring(L, v); L_.setfield(L, -2, k); }
void set_bool(lua_State* L, char const* k, bool v) { L_.pushboolean(L, v ? 1 : 0); L_.setfield(L, -2, k); }

char const* state_name(int st) {
    switch (st) {
    case KEYHOOK_LIVE: return "live";
    case KEYHOOK_WAIT: return "waiting";
    case KEYHOOK_BLOCKED: return "blocked";
    default: return "no bus";
    }
}

}  // namespace

void key_set_name(char const* name) {
    if (!name) return;
    std::strncpy(g_kname, name, sizeof(g_kname) - 1);
    g_kname[sizeof(g_kname) - 1] = 0;
}

void key_detach() {
    if (g_kbus && g_kslot >= 0) keyhook_unregister(g_kbus, g_kslot, false);
    g_kslot = -1;
}

void key_release() {
    if (g_kbus && g_kslot >= 0) keyhook_unregister(g_kbus, g_kslot, true);
    g_kslot = -1;
}

int __cdecl l_key_start(lua_State* L) {
    bool simulate = false;
    if (L_.gettop(L) >= 1 && L_.type(L, 1) == kTString) {
        char const* f = L_.tolstring(L, 1, nullptr);
        simulate = f && std::strstr(f, "nosig") != nullptr;
    }
    if (g_kslot >= 0 && !simulate) {
        L_.pushboolean(L, 1);
        L_.pushstring(L, "joined");
        return 2;
    }
    if (!g_kbus) g_kbus = keyhook_attach();
    int const r = keyhook_join(g_kbus, g_kname, simulate);
    if (r >= 0) {
        g_kslot = r;
        L_.pushboolean(L, 1);
        L_.pushstring(L, g_kbus->status);
        return 2;
    }
    L_.pushboolean(L, 0);
    L_.pushstring(L, r == KEYHOOK_JOIN_NO_BUS ? "key bus unavailable" : (r == KEYHOOK_JOIN_FULL ? "key bus full" : g_kbus->status));
    if (r == KEYHOOK_JOIN_RETRY) {
        L_.pushnumber(L, KEYHOOK_RETRY_MS);
        return 3;
    }
    return 2;
}

int __cdecl l_key_hide(lua_State* L) {
    if (!g_kbus || g_kslot < 0) { L_.pushboolean(L, 0); return 1; }
    unsigned long mask[KEYHOOK_WORDS] = {0, 0, 0, 0, 0, 0, 0, 0};
    int const n = L_.gettop(L);
    for (int i = 1; i <= n; ++i) {
        if (L_.type(L, i) != kTNumber) continue;
        double const v = L_.tonumber(L, i);
        if (v < 0 || v >= KEYHOOK_KEYS) continue;
        unsigned const code = static_cast<unsigned>(v);
        mask[code >> 5] |= 1ul << (code & 31u);
    }
    keyhook_hide(g_kbus, g_kslot, mask);
    L_.pushboolean(L, 1);
    return 1;
}

int __cdecl l_key_status(lua_State* L) {
    KeyBus* b = g_kbus ? g_kbus : keyhook_attach();
    L_.createtable(L, 0, 20);
    int const st = keyhook_state(b);
    set_str(L, "state", state_name(st));
    char line[256];
    keyhook_describe(b, line, sizeof(line));
    set_str(L, "describe", line);
    set_bool(L, "joined", g_kslot >= 0);
    if (!b) return 1;
    set_num(L, "calls", b->calls);
    set_num(L, "installs", b->installs);
    set_num(L, "handovers", b->handovers);
    set_num(L, "lapses", b->lapses);
    set_num(L, "clients", keyhook_active_clients(b));
    set_num(L, "owner_rev", b->owner_rev);
    set_num(L, "rev", KEYHOOK_REV);
    set_num(L, "slot", g_kslot);
    set_bool(L, "hiding", keyhook_hiding(b, g_kslot));
    set_num(L, "keys", g_kslot >= 0 && keyhook_hiding(b, g_kslot) ? keyhook_count(b->clients[g_kslot].hide) : 0);
    set_num(L, "held_hidden", keyhook_count(b->keys.hid));    // presses hidden now, until their release
    set_num(L, "reads", b->keys.state_reads);
    set_num(L, "events", b->keys.event_reads);
    set_num(L, "hidden", b->keys.hidden);
    set_num(L, "dropped", b->keys.dropped);
    set_num(L, "ended", b->keys.ended);
    char dev[64];
    set_str(L, "device", keyhook_device_module(b, dev, sizeof(dev)) ? dev : "");
    char site[24];
    std::snprintf(site, sizeof(site), "%08lX", static_cast<unsigned long>(b->site_state));
    set_str(L, "site_state", site);
    std::snprintf(site, sizeof(site), "%08lX", static_cast<unsigned long>(b->site_events));
    set_str(L, "site_events", site);
    return 1;
}

int __cdecl l_key_stop(lua_State* L) {
    key_release();
    L_.pushstring(L, "stopped");
    return 1;
}

}  // namespace nui
