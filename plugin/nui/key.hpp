// key.hpp - the keyboard half of the module table: keys hidden from the game alone, through the shared
// KeyHook (KeyHook/KeyHook.h). Windower still sees every key, and its events, binds and console keep working.
//
//   key_start([flags]) -> ok, msg [, retry_ms]   join the hook (patching the client's two keyboard reads if nobody
//        has). No retry_ms when it can never work in this process (the reads were not found, are not unique, or
//        have other bytes): use another way to keep keys from the game then. flags "nosig": the not-found path,
//        always (the fail-closed test).
//   key_hide(code, ...) -> ok                    the DirectInput key codes to hide from the game (numbers 0..255,
//        one argument each, so Lua passes unpack(list); none: hide nothing), and the heartbeat. A press is
//        decided when the game first reads it: hidden if its key is in the list then. A hidden press stays hidden until its release, and a press the
//        game saw stays the game's until its release, whatever the list says meanwhile. The list lapses by itself
//        250 ms after the last key_hide, so call it every frame while it holds keys.
//   key_status() -> table                        state, describe, joined, hiding, hidden, dropped, ended, reads,
//        events, lapses, clients, rev, device (the module of the device the game reads: "Hook.dll" for
//        Windower's wrapper), ...
//   key_stop()                                   leave the hook (also done by stop() and in DllMain)
#pragma once
#include "luaapi.hpp"

namespace nui {

void key_set_name(char const* name);      // the client name on the bus (host_open)
void key_detach();                        // DllMain(DLL_PROCESS_DETACH): leave without waiting
void key_release();                       // stop(): give the keys back and leave

int __cdecl l_key_start(lua_State* L);
int __cdecl l_key_hide(lua_State* L);
int __cdecl l_key_status(lua_State* L);
int __cdecl l_key_stop(lua_State* L);

}  // namespace nui
