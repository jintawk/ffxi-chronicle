// pad.hpp - the controller half of the module table: the pad the game reads, through the
// shared PadHook (PadHook/PadHook.h), and holding it while the addon uses it.
//
//   pad_start([flags]) -> ok, msg [, retry_ms]   join the hook, patching it if nobody has: the client's own
//        XInput wrapper in FFXiMain.dll first (route 1), else xinput1_3.dll!XInputGetState (route 0).
//        retry_ms while neither can be patched yet (no wrapper, and xinput1_3.dll not loaded); no retry_ms
//        when it can never work in this process (no wrapper, and the export not hot-patchable or already
//        hooked). flags "nosig": the not-found path, always (the fail-closed test).
//   pad() -> seq, buttons, lt, rt, lx, ly, rx, ry, index, holding
//        what the game last read, raw (before the mask), from the user index that last read connected.
//        seq changes with every change; 0 = no pad read yet. buttons: XINPUT_GAMEPAD_* bits, and
//        0x10000 / 0x20000 for LT / RT held. Each call is also the capture's heartbeat. nil when not started.
//   pad_capture(on)                              hold the pad (the game stops seeing new presses, the
//        sticks and the triggers) or give it back. A capture lapses by itself 250 ms after the last pad().
//   pad_chord(buttons)                           (rev 2) the buttons that take the pad together (e.g. L3 + R3:
//        0xC0); the hook keeps that chord from the game, even where the game maps those buttons itself.
//        A chord button pressed alone reaches the game up to 150 ms late; tapped alone, it still does.
//   pad_config() -> {key, padmode, padsin} | nil, why   the game's own pad settings (registry, read only)
//   pad_status() -> table                        state, describe, calls, clients, holding, masked, hidden, lapses, ...
//   pad_stop()                                   leave the hook (also done by stop() and in DllMain)
#pragma once
#include "luaapi.hpp"

namespace nui {

void pad_set_name(char const* name);      // the client name on the bus (host_open)
void pad_detach();                        // DllMain(DLL_PROCESS_DETACH): leave without waiting
void pad_release();                       // stop(): give the pad back and leave

int __cdecl l_pad_start(lua_State* L);
int __cdecl l_pad(lua_State* L);
int __cdecl l_pad_capture(lua_State* L);
int __cdecl l_pad_chord(lua_State* L);
int __cdecl l_pad_config(lua_State* L);
int __cdecl l_pad_status(lua_State* L);
int __cdecl l_pad_stop(lua_State* L);

}  // namespace nui
