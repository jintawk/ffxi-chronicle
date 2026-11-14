// luaapi.hpp - the Lua 5.1 C API, bound by name from whichever Lua is in the process (the host's
// approach): Windower's LuaCore.dll, or the stock interpreter's lua51.dll / lua5.1.dll for the
// offline tests. No Lua headers or import library: a module links against nothing Lua-specific.
//
//     if (!nui::bind_lua()) return 0;          // in luaopen_<name>
//     nui::lua().pushnumber(L, 1);
#pragma once
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#include <cstddef>

struct lua_State;

namespace nui {

using lua_CFunction = int(__cdecl*)(lua_State*);

struct LuaApi {
    void(__cdecl* createtable)(lua_State*, int, int) = nullptr;
    void(__cdecl* pushcclosure)(lua_State*, lua_CFunction, int) = nullptr;
    void(__cdecl* setfield)(lua_State*, int, char const*) = nullptr;
    void(__cdecl* getfield)(lua_State*, int, char const*) = nullptr;
    void(__cdecl* pushvalue)(lua_State*, int) = nullptr;
    void(__cdecl* pushstring)(lua_State*, char const*) = nullptr;
    void(__cdecl* pushlstring)(lua_State*, char const*, std::size_t) = nullptr;
    void(__cdecl* pushnumber)(lua_State*, double) = nullptr;
    void(__cdecl* pushboolean)(lua_State*, int) = nullptr;
    void(__cdecl* pushnil)(lua_State*) = nullptr;
    void(__cdecl* settop)(lua_State*, int) = nullptr;
    void(__cdecl* rawseti)(lua_State*, int, int) = nullptr;
    int(__cdecl* gettop)(lua_State*) = nullptr;
    int(__cdecl* type)(lua_State*, int) = nullptr;
    int(__cdecl* toboolean)(lua_State*, int) = nullptr;
    double(__cdecl* tonumber)(lua_State*, int) = nullptr;
    char const*(__cdecl* tolstring)(lua_State*, int, std::size_t*) = nullptr;

    bool ready() const {
        return createtable && pushcclosure && setfield && getfield && pushvalue && pushstring && pushlstring && pushnumber &&
               pushboolean && pushnil && settop && rawseti && gettop && type && toboolean && tonumber && tolstring;
    }
};

constexpr int kLuaGlobalsIndex = -10002;
constexpr int kTNil = 0, kTBoolean = 1, kTNumber = 3, kTString = 4, kTTable = 5;

// One instance per module (an inline function's static is shared by every file of one DLL).
inline LuaApi& lua() {
    static LuaApi api;
    return api;
}

namespace luaapi_detail {
template <typename T>
inline void bind(HMODULE m, T& fn, char const* name) {
    fn = reinterpret_cast<T>(reinterpret_cast<void*>(GetProcAddress(m, name)));
}
}  // namespace luaapi_detail

// Binds every function above from the first Lua host found. False when none is loaded.
inline bool bind_lua() {
    LuaApi& g = lua();
    if (g.ready()) return true;
    using luaapi_detail::bind;
    static char const* const hosts[] = {"LuaCore.dll", "lua51.dll", "lua5.1.dll"};
    for (char const* host : hosts) {
        HMODULE m = GetModuleHandleA(host);
        if (!m) continue;
        bind(m, g.createtable, "lua_createtable");
        bind(m, g.pushcclosure, "lua_pushcclosure");
        bind(m, g.setfield, "lua_setfield");
        bind(m, g.getfield, "lua_getfield");
        bind(m, g.pushvalue, "lua_pushvalue");
        bind(m, g.pushstring, "lua_pushstring");
        bind(m, g.pushlstring, "lua_pushlstring");
        bind(m, g.pushnumber, "lua_pushnumber");
        bind(m, g.pushboolean, "lua_pushboolean");
        bind(m, g.pushnil, "lua_pushnil");
        bind(m, g.settop, "lua_settop");
        bind(m, g.rawseti, "lua_rawseti");
        bind(m, g.gettop, "lua_gettop");
        bind(m, g.type, "lua_type");
        bind(m, g.toboolean, "lua_toboolean");
        bind(m, g.tonumber, "lua_tonumber");
        bind(m, g.tolstring, "lua_tolstring");
        if (g.ready()) return true;
    }
    return false;
}

}  // namespace nui
