--[[
Copyright (c) 2026, Jintawk
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of
      conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.
    * Neither the name of Chronicle nor the names of its contributors may be used to endorse or
      promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JINTAWK BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]

--[[
    Chronicle: the quest and mission tracker drawn in the game's own windows.

    libs/_chronicle.dll (source plugin/) draws above the game's UI with the game's window art and
    fonts (core/nui.lua); everything else is Lua: data (core/data.lua, from packet 0x056), metadata
    per area (core/meta.lua), screens (ui/screens/), the window (ui/window.lua). While it lives beside
    v1 its names come from core/ident.lua.
]]

local HERE = windower.addon_path:gsub('\\', '/')
if HERE:sub(-1) ~= '/' then HERE = HERE .. '/' end
package.path = HERE .. '?.lua;' .. package.path

local ident = require('core/ident')

_addon.name = ident.name
_addon.author = 'Jintawk'
_addon.version = ident.version
_addon.commands = ident.commands

local config = require('config')
local packets = require('packets')

local meta = require('core/meta')
meta.set_root(HERE)
local data = require('core/data')
local wiki = require('core/wiki')
local nui = require('core/nui')
local App = require('core/app')
local places = require('core/places')
local ops = require('ui/ops')
local keys = require('ui/keys')
local pad = require('ui/pad')
local Window = require('ui/window')
local screens = {
    home = require('ui/screens/home'),
    area = require('ui/screens/area'),
    guide = require('ui/screens/guide'),
    settings = require('ui/screens/settings'),
    -- Records of Eminence: one level deeper than the other two tabs
    rcat = require('ui/screens/rcat'),
    rsub = require('ui/screens/rsub'),
    robj = require('ui/screens/robj'),
}
local pages = require('core/pages')
local progress = require('core/progress')
local roe = require('core/roe')

local function char_name()
    local p = windower.ffxi.get_player()
    return p and p.name and p.name:lower() or 'global'
end

local function say(s, col) windower.add_to_chat(col or 207, ident.title .. ': ' .. s) end

---------------------------------------------------------------------------
-- Settings (config library, per character)
---------------------------------------------------------------------------
local defaults = {
    visible_on_load = true,
    collapsed_on_load = false,
    size = 1.0,             -- view factor multiplier (v1's `scale`)
    scale_mode = 'one',     -- one | ui | sim
    rt_auto = true,         -- scale by render target / screen width (Windower supersampling)
    sim_w = 2560, sim_h = 1440,
    wintype = 0,            -- 0 follows the game's Config, 1-8 pins a type
    sort_mode = 1,
    filter_mode = 1,
    roe_sort_mode = 1,
    roe_filter_mode = 1,
    active_tab = 'mission',
    show_uncompletable = false,
    share_textures = true,  -- false: keep this addon's own textures (start 'noshare'), not the shared cache
    pad = true,             -- the controller: the chord takes it (nui's pad hook, XInput only); false never hooks it
    pad_chord = 'l3+r3',    -- that chord: two buttons, a name for ui/pad.lua's pad.parse_chord ('l3+r3', 'lb+rb', 'back+start')
    nav = true,             -- the keyboard: the nav key takes the arrows, Enter, Backspace, Escape, Tab, PgUp/PgDn, Home/End; false never takes a key
    nav_key = 'k',          -- that key: a name for ui/keys.lua's keys.parse ('k', 'ctrl+n', 'f10')
    auto_hide = false,      -- Cancel at a root view (pad or keyboard) hides the window, and so gives back both inputs
}
-- A settings.xml the stock config library cannot parse (half written by another client) makes config.load throw, and the addon
-- would not load (review LIFE-6): the defaults are used instead, the file is left alone and nothing is saved until a load works
-- (tried again at the next login).
local settings, settings_ok
local function load_settings()
    local ok, s = pcall(config.load, defaults)
    if ok and type(s) == 'table' then
        settings, settings_ok = s, true
        return true
    end
    if not settings then
        settings = {}
        for k, v in pairs(defaults) do settings[k] = v end
    end
    settings_ok = false
    return false, s
end
do
    local ok, err = load_settings()
    if not ok then say('data/settings.xml unreadable, defaults in use: ' .. tostring(err):match('^[^\r\n]*'), 167) end
end
local function save() if settings_ok then settings:save() end end

---------------------------------------------------------------------------
-- The native layer, the app, the window
---------------------------------------------------------------------------
nui.load(HERE, ident.native)

local app = App.new(data, settings, save)
app.short = ident.short
app.say = say
app.check_requirements = wiki.check_requirements
data.set_show_uncompletable(settings.show_uncompletable)

-- Records of Eminence: the client's own catalogue (roe/), read on first use, plus the live
-- state of packets 0x110 / 0x111 / 0x112
roe.attach(HERE)
app.roe = roe

-- quest step progress: observed read-only, kept per character in data/progress/
app.progress = progress
do
    local p = windower.ffxi.get_player()
    progress.init(data, say, p and p.name)
end

local win = nil

local function apply_view()
    nui.view.mode = settings.scale_mode == 'sim' and 'sim' or (settings.scale_mode == 'ui' and 'ui' or 'one')
    nui.view.sim_w, nui.view.sim_h = settings.sim_w, settings.sim_h
    nui.view.auto = settings.rt_auto ~= false
    nui.view.size = settings.size or 1
    local _, why = nui.apply()
    if why then say(why) end
end

local function save_place()
    if not win then return end
    local sw, sh = nui.screen()
    places.save(HERE, char_name(), sw, sh, {x = win.x, y = win.y, w = win.w, h = win.h})
end

local function place_window()
    local sw, sh = nui.screen()
    local p = places.load(HERE, char_name(), sw, sh)
    win:set_screen_size(sw, sh)
    win:resend()            -- a new screen or scale: every layer sent again, as before the identical-text skip (ui/window.lua)
    if p then
        win.w, win.h = Window.clamp_size(p.w, p.h, sw, sh)
        win.x = math.max(0, math.min(p.x, sw - 60))
        win.y = math.max(0, math.min(p.y, sh - 40))
    end
end

local function show_screen(scroll, cursor)
    if not win then return end
    pages.close()                       -- first: it keeps the scroll the page is left at
    win:set_screen(screens[app.view.name] or screens.home, scroll, cursor)
    if app.view.name == 'guide' and pages.open(app.view.params) then
        win:flush()
        local y = pages.saved_scroll()
        if y then win:scroll_to(y) end
    end
    win:flush()
end
app.on_change = show_screen

-- While the UI hook is not there yet (no native-UI module has found the game's EndScene wrapper), start again from prerender,
-- after retry_s seconds, then 30 s, then 2 minutes, then give up with one line (review LIFE-1: a signature an SE update broke
-- never comes back, and each try stalls the game). Said once when it starts waiting; a command that shows the window starts over.
local RETRY_AFTER = {nil, 30, 120}         -- [1] is the DLL's own retry_s
local retry = {at = nil, said = false, show = false, n = 0}
local said_assets = false         -- the art warning below is said once a session, not every start

local function start(again)
    if win then return true end
    if not again then retry.n = 0 end
    apply_view()
    local flags = settings.share_textures == false and 'noshare' or nil
    local ok, msg, retry_s = nui.start(flags)
    if not ok then
        retry.n = retry.n + 1
        local wait = retry_s and (retry.n == 1 and retry_s or RETRY_AFTER[retry.n])
        if wait then
            if not retry.said then say(tostring(msg) .. '; retrying', 167) retry.said = true end
            retry.at = os.clock() + wait
        elseif retry_s then
            retry.at, retry.said = nil, false
            say(tostring(msg) .. '; gave up (//' .. ident.short .. ' show tries again)', 167)
        else
            retry.at, retry.said = nil, false
            say(tostring(msg), 167)
        end
        return false
    end
    if retry.said then say('hooked') end
    retry.at, retry.said, retry.n = nil, false, 0
    retry.flags = flags
    -- Drawing no longer needs every piece of the game's art: without the window frame Chronicle
    -- draws a plain panel, without the gauge a flat bar. Say so, once, with the file and the
    -- reason, so a piece that could not be read is never silent and the line goes into an issue.
    if not said_assets then
        local st = nui.N.status()
        local a = type(st) == 'table' and st.assets
        if type(a) == 'string' and a:find('missing', 1, true) then
            said_assets = true
            say('drawing without some of the game art: ' .. a, 167)
            say('please report that line at ' .. ident.issues, 167)
        end
    end
    ops.set_metrics(nui.N.metrics())
    if settings.wintype and settings.wintype > 0 then nui.pin_type(settings.wintype) else nui.pin_type(nil) end
    win = Window.new(nui.N, {app = app, on_place = save_place})
    app.win = win
    place_window()
    pages.attach(app, win, nui.N, HERE)
    win.collapsed = settings.collapsed_on_load == true
    show_screen(0)
    return true
end

local function show()
    retry.show = true
    if not start() then return end
    win:show()
end
local pad_give, kbd_give        -- the controller and the keyboard go back to the game with the window (below)
local function hide()
    retry.show = false
    if pad_give then pad_give() end
    if kbd_give then kbd_give() end
    if win then win:hide() end
end
local function toggle()
    if win and win.visible then hide() else show() end
end
app.on_hide = hide

---------------------------------------------------------------------------
-- The controller: nui's pad hook (the pad the game reads; while Chronicle holds it, new presses, the sticks and the
-- triggers are kept from the game). The chord (L3 + R3 unless the player chose another) takes it and gives it back; so does
-- //cr pad.
---------------------------------------------------------------------------
local padc = {dec = pad.new(), joined = false, held = false, retry_at = 0, why = nil, prev = 0, acts = {}, frac = 0,
              said = false, conflicts = {}, wait = nil}
local PAD_WAIT_S = 5            -- the Settings row "Controller buttons" waits this long for a press, then keeps the old chord

-- The chord (settings.pad_chord), parsed again whenever the setting changes (a login reads the next character's). A name that
-- does not parse falls back to L3 + R3. A new chord goes to the decoder, to the conflict check and, once joined, to the hook.
local function pad_chord()
    local want = settings.pad_chord or 'l3+r3'
    if padc.chord and padc.chord_src == want then return padc.chord end
    padc.chord, padc.chord_src = pad.parse_chord(want) or pad.parse_chord('l3+r3'), want
    padc.dec:set_chord(padc.chord.mask)
    padc.conflicts = pad.chord_conflicts(padc.cfg, padc.chord.mask)
    if padc.joined and nui.N and nui.N.pad_chord then nui.N.pad_chord(padc.chord.mask) end
    return padc.chord
end

local function pad_hint()
    local ok, back = padc.dec:labels()
    return ok .. ' Open  ' .. back .. ' Back  LB RB Section  LT RT Page  ' .. pad_chord().label .. ' Done'
end

-- the game's own Confirm and Cancel, and whether it also uses L3 or R3. A registry read that needs no hook, so it runs
-- once per load, before the hook is tried: a refused hook still shows the player's own buttons and says why
local function pad_read_config()
    if padc.cfg_read or not (nui.N and nui.N.pad_config) then return end
    padc.cfg_read = true
    local cfg = nui.N.pad_config()
    padc.cfg = type(cfg) == 'table' and cfg or nil
    padc.dec.confirm, padc.dec.cancel, padc.xinput = pad.from_config(padc.cfg)
    padc.conflicts = pad.chord_conflicts(padc.cfg, pad_chord().mask)
end

-- join the hook. On the client's own XInput wrapper (nui 1.5.0) that works at once. On the fallback, while xinput1_3.dll is
-- not loaded, it is tried again every few seconds, quietly
local function pad_join(now)
    if padc.joined then return true end
    if not (nui.N and nui.N.pad_start) then padc.why = '_chronicle.dll has no controller support' return false end
    pad_read_config()
    local ok, msg, retry_ms = nui.N.pad_start()
    if ok then
        padc.joined, padc.why = true, nil
        -- nui 1.4.0: the hook keeps the chord from the game itself, so L3 + R3 never sits the player down or turns the
        -- camera (a lone chord button reaches the game up to 150 ms late; a tap of one still does)
        if nui.N.pad_chord then nui.N.pad_chord(pad_chord().mask) end
        return true
    end
    padc.why = msg
    padc.retry_at = retry_ms and (now + retry_ms / 1000) or math.huge
    return false
end

local kbd_hint                  -- the keyboard's line of keys (below): the hint again when the pad goes and the keys stay
local pad_wait_end              -- the Settings row's wait for two buttons (below)
pad_give = function()
    if padc.wait then pad_wait_end() end
    if not padc.held then return end
    padc.held = false
    if nui.N and nui.N.pad_capture then nui.N.pad_capture(false) end
    if win then win:pad_leave('pad', kbd_hint()) end
end

local function pad_take(buttons)
    if padc.held or not padc.joined then return end
    if not (win and win.visible) then show() end
    if not (win and win.visible) then return end
    nui.N.pad_capture(true)
    padc.held = true
    padc.dec:latch(buttons)               -- the chord's own buttons (and anything else held) act only once released
    padc.dec.prev = buttons or 0
    padc.frac = 0
    win:pad_enter(pad_hint(), 'pad')
    if not padc.said then
        padc.said = true
        local c = pad_chord()
        say('controller: ' .. c.label .. ' gives it back to the game')
        if #padc.conflicts > 0 and not nui.N.pad_chord then
            say(('your FFXI pad config also uses %s or %s: pressing both does that too (a newer _chronicle.dll stops it)')
                :format(pad.CHORD_LABEL[c.name:match('^[^+]+')], pad.CHORD_LABEL[c.name:match('[^+]+$')]), 167)
        end
    end
end

local function pad_off()
    pad_give()
    if nui.N and nui.N.pad_stop then nui.N.pad_stop() end
    padc.joined, padc.retry_at = false, 0
end

-- An action of the cursor, from either input. give: what gives that input back (Cancel at the root, the toggle); hint: its
-- line of keys, which the hint line shows while it is the input that acts. With settings.auto_hide, Cancel at the root hides
-- the window instead: hide() gives back the pad and the keys alike, and the press rules hold as for give (the hook keeps the
-- pad's Cancel hidden until its release, and the keyboard block waits for the key's release)
local TAB_STEP = {tab_prev = -1, tab_next = 1}
local MOVES = {up = true, down = true, left = true, right = true}
local function nav_act(a, give, hint)
    if a == 'toggle' then give() return end
    if not (win and win.visible) then return end
    win:pad_hint_for(hint)
    if MOVES[a] then win:pad_move(a)
    elseif a == 'confirm' then win:pad_activate()
    elseif a == 'cancel' then
        if win:pad_back() == 'root' then                     -- nothing to go back to: the input goes back to the game
            if settings.auto_hide == true then hide() else give() end
        end
    elseif TAB_STEP[a] then
        local common = require('ui/screens/common')
        local i = (common.tab_index(app) - 1 + TAB_STEP[a]) % #common.CATS + 1
        win:pad_click({id = 'navtab', i = i})
    elseif a == 'sort' or a == 'filter' or a == 'settings' then win:pad_click({id = a})
    elseif a == 'collapse' then win:toggle_collapse()
    elseif a == 'page_up' or a == 'page_down' then
        local vh = win.vp and (win.vp.y1 - win.vp.y0) or 0
        win:pad_scroll((a == 'page_up' and -1 or 1) * math.max(36, vh - 36))
    elseif a == 'top' then win:pad_scroll(0, true)
    elseif a == 'bottom' then win:pad_scroll(win.content_h or 0, true) end
end

-- prerender: one read of the pad (numbers, no table); nothing else unless something changed. Not holding the pad, only the
-- chord is looked for.
local pad_wait_tick              -- the Settings row's wait for two buttons (below)
local function pad_tick(now)
    if settings.pad == false or not (nui.N and nui.N.pad) then return end
    if not padc.joined then
        if now < padc.retry_at or not pad_join(now) then return end
    end
    local seq, buttons, lt, rt, lx, ly, rx, ry, _, holding = nui.N.pad()
    if not seq or seq < 0 then return end
    buttons = buttons or 0
    local C = pad_chord().mask
    if padc.wait then
        pad_wait_tick(now, buttons, holding)
        padc.prev = buttons
        return
    end
    if not padc.held then
        if pad.band(buttons, C) == C and pad.band(padc.prev, C) ~= C then pad_take(buttons) end
        padc.prev = buttons
        return
    end
    -- the hold lapsed while Lua was not running (a long stall): take it again, and what is held now waits for its release
    if not holding then
        nui.N.pad_capture(true)
        padc.dec:latch(buttons)
    end
    padc.prev = buttons
    local acts, scroll = padc.dec:feed(now, buttons, lt, rt, lx, ly, rx, ry, padc.acts)
    for i = 1, #acts do
        nav_act(acts[i], pad_give, pad_hint())
        if not padc.held or padc.wait then break end
    end
    if padc.held and scroll ~= 0 and win then
        padc.frac = padc.frac + scroll
        local whole = padc.frac >= 0 and math.floor(padc.frac) or -math.floor(-padc.frac)
        if whole ~= 0 then
            padc.frac = padc.frac - whole
            win:pad_scroll(whole)
        end
    end
end

local XINPUT_OFF = 'Enable XInput is off in the FFXI Config (Gamepad), so the game reads the pad with DirectInput, ' ..
    'which Chronicle cannot read yet. Turn it on to use the controller here'

-- nui 1.5.0, on the client's XInput wrapper: the client has not loaded its XInput shim, so no pad state can arrive
local function pad_no_shim()
    local st = nui.N and nui.N.pad_status and nui.N.pad_status()
    return type(st) == 'table' and st.route == 'wrapper' and st.shim == false
end

local function pad_status_lines()
    if settings.pad == false then say('controller off (//' .. ident.short .. ' pad on)') return end
    local st = nui.N and nui.N.pad_status and nui.N.pad_status()
    if not st then say('controller: _chronicle.dll has no controller support', 167) return end
    pad_read_config()                      -- in case nothing has tried the hook yet
    local c = pad_chord()
    say(('controller %s | %s | %s'):format(padc.held and 'held' or (padc.joined and ('ready (' .. c.label .. ')') or 'not joined'),
        tostring(st.describe), padc.why and ('why: ' .. padc.why) or ('reads ' .. tostring(st.reads))))
    local ok, back = padc.dec:labels()
    say(('game pad config: %s | XInput %s | Confirm %s, Cancel %s%s'):format(padc.cfg and padc.cfg.key or 'not found',
        padc.xinput == nil and '?' or (padc.xinput and 'on' or 'off'), ok, back,
        #padc.conflicts > 0 and (' | ' .. c.label:gsub('%+', '/') .. ' also mapped in the game') or ''))
end

-- A new chord (the command, or the Settings row's wait). -> the chord, or nil and why
local function pad_set_chord(name)
    local c, why = pad.parse_chord(name)
    if not c then return nil, why end
    settings.pad_chord = c.name
    save()
    pad_chord()
    if padc.held and win then win:pad_hint_for(pad_hint()) win:flush() end
    return c
end

-- The Settings row "Controller buttons": the next two buttons held together are the chord. While it waits, Chronicle holds
-- the pad (the hook's rules: a button the game saw go down stays the game's until released, and a press made while Chronicle
-- holds the pad stays hidden until released, also after the pad goes back), so the game sees none of it. Buttons held when the
-- wait starts (the Confirm that chose the row) count only once released. Escape, Cancel pressed alone, or PAD_WAIT_S with
-- nothing pressed keeps the old chord.
local function pad_wait_start()
    if settings.pad == false then say('controller off (//' .. ident.short .. ' pad on)', 167) return end
    if not padc.joined then
        say('controller: Chronicle is not reading the controller, so it cannot wait for buttons (//' .. ident.short ..
            ' pad status says why)', 167)
        return
    end
    padc.wait = {latched = padc.prev or 0, one = 0, until_ = os.clock() + PAD_WAIT_S}
    nui.N.pad_capture(true)
end

-- the wait is over: the pad goes back unless Chronicle holds it for the cursor; what is held now acts only once released
pad_wait_end = function(buttons)
    if not padc.wait then return end
    padc.wait = nil
    buttons = buttons or padc.prev or 0
    if padc.held then
        padc.dec:latch(buttons)
        padc.dec.prev = buttons
    elseif nui.N and nui.N.pad_capture then
        nui.N.pad_capture(false)
    end
    if win then win:invalidate('all') win:flush() end
end

pad_wait_tick = function(now, buttons, holding)
    local w = padc.wait
    if not holding then nui.N.pad_capture(true) end      -- the hold lapsed (a long stall): take it again
    w.latched = pad.band(w.latched, buttons)
    local live = buttons - pad.band(buttons, w.latched)
    local n = pad.count(live)
    if n >= 2 then
        local old = pad_chord().label
        local c, why = pad_set_chord(pad.chord_name(live))
        if c then say('controller: ' .. c.label .. ' takes and gives back the controller')
        else say('controller: ' .. why .. '. ' .. old .. ' kept', 167) end
        pad_wait_end(buttons)
        return
    end
    if n == 1 then
        w.one, w.until_ = live, now + PAD_WAIT_S
        return
    end
    if w.one ~= 0 and w.one == pad.B[padc.dec.cancel] then pad_wait_end(buttons) return end    -- Cancel alone: keep it
    w.one = 0
    if now >= w.until_ then
        say('controller: nothing pressed, ' .. pad_chord().label .. ' kept')
        pad_wait_end(buttons)
    end
end

---------------------------------------------------------------------------
-- The keyboard: K takes the keys below and drives the same cursor as the controller; K again gives them back. The pad and
-- the keyboard are held on their own (one cursor, two holds). A held arrow repeats on Chronicle's own clock (the pad's delay
-- and rate), whether or not Windower repeats the key-down.
--
-- Keeping keys from the game. In game (2026-11-27), returning true from the keyboard event kept no key from the game: the
-- arrows still turned the camera, and letters typed in the search box opened the game's menus. Two things do keep keys:
--   - nui's key hook (1.6.0, kbd_hide_sync): it hides only the keys Chronicle names, from the game's actions, after Windower
--     has seen them. So chat, macros and Windower binds still work in nav mode. It hides the nav key, the nav keys while they
--     are held, and Escape while the Settings row waits for two buttons. The hook's own rules keep a press whole: a press the
--     game saw stays the game's, and a hidden press stays hidden, until its release.
--   - Windower's keyboard_blockinput 1 (kbd_block): it keeps every key from the game, and the keyboard event still sees them.
--     The search box and the Settings row "Keyboard key" use it, because typed text reaches the game's chat line as window
--     messages, which the hook does not see. Without the hook (an older DLL, or nui refused it) it also covers nav mode.
-- The block changes only while no key is down, so the game never sees half a press:
--   - a key whose press the game saw stays the game's until its release (the block waits, at most BLOCK_WAIT_ON seconds)
--   - a key pressed under the block stays away from the game until its release (the block stays, at most BLOCK_WAIT_OFF)
-- Losing focus and unloading lift the block and empty the hook's list at once. The handler still returns true for what it
-- takes, as before.
-- Which keys the driver acts on: the focused search box comes first; while the chat line is open, and with Ctrl or Alt held,
-- no new press is taken (kbd.game: a press the game saw; kbd.took: a press the driver took).
---------------------------------------------------------------------------
local KEY_ESC = 0x01
local KEY_ACT = {
    [0xC8] = 'up', [0xD0] = 'down', [0xCB] = 'left', [0xCD] = 'right',
    [0x1C] = 'confirm', [0x9C] = 'confirm',              -- Enter, the number pad's Enter
    [0x0E] = 'cancel', [0x01] = 'cancel',                -- Backspace, Escape
    [0x0F] = 'tab_next',                                 -- Tab (Shift + Tab: tab_prev)
    [0xC9] = 'page_up', [0xD1] = 'page_down', [0xC7] = 'top', [0xCF] = 'bottom',
}
local kbd = {held = false, took = {}, game = {}, dir = nil, dir_key = nil, next_at = 0,
             down = {}, ndown = 0, block = false, wait_since = nil,
             hook = nil, hook_why = nil, hook_retry = 0, hiding = false, hide_key = nil, hide_list = nil,
             chat = false, chat_at = -1}
local KEY_ACT_LIST = {}         -- the nav keys, for the key hook (sorted, so the list is the same every time)
for dik in pairs(KEY_ACT) do KEY_ACT_LIST[#KEY_ACT_LIST + 1] = dik end
table.sort(KEY_ACT_LIST)
local CHAT_EVERY = 0.1          -- prerender asks the game about its chat line at most this often (each key asks too)
local BLOCK_WAIT_ON = 0.5       -- a key the game saw, still held after this: the block starts anyway (the game sees it released)
local BLOCK_WAIT_OFF = 2        -- a key still down after this (its release lost): the block ends anyway
local KBD_HINT

-- The nav key (settings.nav_key), parsed again whenever the setting changes (a login reads the next character's). A name that
-- does not parse falls back to K.
local function kbd_key()
    local want = settings.nav_key or 'k'
    if kbd.key and kbd.key_src == want then return kbd.key end
    kbd.key, kbd.key_src = keys.parse(want) or keys.parse('k'), want
    KBD_HINT = 'Enter Open  Bksp Back  Tab Section  PgUp PgDn Page  ' .. kbd.key.label .. ' Done'
    return kbd.key
end
kbd_hint = function() return kbd.held and (kbd_key() and KBD_HINT) or nil end

local function chat_open()
    local info = windower.ffxi.get_info()
    return info and info.chat_open == true
end

local kbd_block                 -- the block follows the hold (below)
kbd_give = function()
    kbd.dir, kbd.dir_key = nil, nil
    if not kbd.held then return end
    kbd.held = false
    if win then win:pad_leave('keys', padc.held and pad_hint() or nil) end
    kbd_block(os.clock())
end

local function kbd_take()
    if kbd.held then return end
    if not (win and win.visible) then show() end
    if not (win and win.visible) then return end
    kbd.held = true
    kbd_key()
    win:pad_enter(KBD_HINT, 'keys')
end

-- A new nav key (the command, or the Settings row's capture). -> the key, or nil and why. A key that moves the cursor needs a
-- modifier, or it could never move it.
local function kbd_set_key(name)
    local k, why = keys.parse(name)
    if not k then return nil, why end
    if KEY_ACT[k.dik] and not (k.ctrl or k.alt or k.shift) then return nil, k.label .. ' moves the cursor: add Ctrl, Alt or Shift' end
    settings.nav_key = k.name
    save()
    kbd_key()
    if kbd.held and win then win:pad_hint_for(KBD_HINT) win:flush() end
    return k
end

-- the Settings row "Keyboard key": the next key pressed (with its modifiers) is the nav key; Escape keeps the old one
local function kbd_capture(dik)
    kbd.capture = false
    if dik ~= KEY_ESC then
        local name = keys.name_now(dik)
        local k, why = kbd_set_key(name or '')
        if k then say('keyboard: ' .. k.label .. ' takes the keys') else say('keyboard: ' .. (why or 'that key has no name'), 167) end
    end
    if win then win:invalidate('all') win:flush() end
end

local function kbd_act(a, now)
    if a == 'tab_next' and keys.shift() then a = 'tab_prev' end
    if MOVES[a] then kbd.dir, kbd.next_at = a, now + pad.REPEAT_DELAY end
    nav_act(a, kbd_give, KBD_HINT)
end

-- a key-down nobody before took -> true: Chronicle keeps it
local function kbd_down(dik, now)
    if kbd.took[dik] then return true end                -- held (Windower repeating it): the arrow repeats on our clock
    if kbd.game[dik] then return false end               -- the game saw this press: its repeats are the game's too
    if padc.wait and dik == KEY_ESC then                 -- the Settings row waits for two buttons: Escape keeps the old chord
        kbd.took[dik] = true
        pad_wait_end()
        return true
    end
    if kbd.capture and not keys.modifier(dik) then
        kbd.took[dik] = true
        kbd_capture(dik)
        return true
    end
    if settings.nav == false or chat_open() then return false end
    local nk = kbd_key()
    if dik == nk.dik and keys.ctrl() == nk.ctrl and keys.alt() == nk.alt and (keys.shift() or not nk.shift) then
        if kbd.held then kbd_give() else kbd_take() end
        if not kbd.held and not (win and win.visible) then return false end   -- no window to take the keys to: the game's key
        kbd.took[dik] = true
        return true
    end
    if keys.ctrl_alt() then return false end
    local a = KEY_ACT[dik]
    if not (a and kbd.held and win and win.visible and nui.drawing) then return false end
    kbd.took[dik] = true
    if MOVES[a] then kbd.dir_key = dik end
    kbd_act(a, now)
    return true
end

-- prerender: a held arrow repeats (nothing to do while no arrow is held)
local function kbd_tick(now)
    if not kbd.dir then return end
    if not (kbd.held and kbd.took[kbd.dir_key]) then kbd.dir, kbd.dir_key = nil, nil return end
    if now >= kbd.next_at then
        kbd.next_at = now + pad.REPEAT_EVERY
        nav_act(kbd.dir, kbd_give, KBD_HINT)
    end
end

-- the whole keyboard kept from the game, or given back (Windower's keyboard_blockinput)
local function kbd_set_block(on)
    kbd.block, kbd.wait_since = on, nil
    windower.send_command('keyboard_blockinput ' .. (on and '1' or '0'))
end

-- the block Chronicle wants: the search box focused or the Settings row "Keyboard key" waiting, on a window that draws. Without
-- the key hook, also the keys held and the Settings row "Controller buttons" waiting.
local function kbd_want_block()
    local typing = kbd.capture or (win and win.focus ~= nil)
    local want = typing or (kbd.hook ~= true and (kbd.held or padc.wait))
    return want and win and win.visible and nui.drawing and true or false
end

-- nui 1.6.0: join the key hook. True while it is joined. An older DLL, or a hook nui refuses, leaves the block to do the work.
local function kbd_hook_join(now)
    if kbd.hook ~= nil then return kbd.hook end
    if now < kbd.hook_retry then return false end
    if not (nui.N and nui.N.key_start) then
        kbd.hook, kbd.hook_why = false, '_chronicle.dll has no keyboard hook'
        return false
    end
    local ok, msg, retry_ms = nui.N.key_start()
    if ok then kbd.hook, kbd.hook_why = true, nil return true end
    kbd.hook_why = tostring(msg)
    if retry_ms then kbd.hook_retry = now + retry_ms / 1000 else kbd.hook = false end
    return false
end

-- the game's chat line: asked again on each key, and at most every CHAT_EVERY seconds from prerender
local function kbd_chat(now, fresh)
    if fresh or now - kbd.chat_at >= CHAT_EVERY or now < kbd.chat_at then
        kbd.chat, kbd.chat_at = chat_open(), now
    end
    return kbd.chat
end

-- What the hook should hide now, as bits: 1 the nav key, 2 the nav keys, 4 Escape. The same rules as kbd_down: nothing new
-- while the chat line is open; the nav key only with its own Ctrl and Alt; the nav keys only while held, with neither Ctrl nor
-- Alt, on a window that draws. Escape while the Settings row waits for two buttons, whatever else holds.
local function kbd_hide_want(now, fresh)
    local s = padc.wait and 4 or 0
    if settings.nav == false or kbd_chat(now, fresh) then return s end
    local nk = kbd_key()
    local ctrl, alt = keys.ctrl(), keys.alt()
    if ctrl == nk.ctrl and alt == nk.alt and (keys.shift() or not nk.shift) then s = s + 1 end
    if kbd.held and not (ctrl or alt) and win and win.visible and nui.drawing then s = s + 2 end
    return s
end

-- the key codes for those bits (made once per bits and nav key, not every frame)
local function kbd_hide_list(s)
    local nk = kbd_key()
    local id = s * 256 + nk.dik
    if kbd.hide_key == id then return kbd.hide_list end
    local t = {}
    if s % 2 == 1 then t[#t + 1] = nk.dik end
    if math.floor(s / 2) % 2 == 1 then for _, d in ipairs(KEY_ACT_LIST) do t[#t + 1] = d end end
    if s >= 4 then t[#t + 1] = KEY_ESC end
    kbd.hide_key, kbd.hide_list = id, t
    return t
end

-- after every key and once a frame: the hook's list follows what is wanted. While it holds keys, every frame renews it (its
-- heartbeat: a list not renewed for 250 ms lapses). When it holds none, it is emptied once.
local function kbd_hide_sync(now, fresh)
    if not kbd_hook_join(now) then return end
    local s = kbd_hide_want(now, fresh)
    if s == 0 then
        if kbd.hiding then nui.N.key_hide() kbd.hiding = false end
        return
    end
    nui.N.key_hide(unpack(kbd_hide_list(s)))
    kbd.hiding = true
end

-- lose focus: nothing new is hidden while the game has no focus
local function kbd_hide_clear()
    if kbd.hook == true and kbd.hiding then nui.N.key_hide() end
    kbd.hiding = false
end

-- How Chronicle keeps the keys, for //cr nav status and //cr status
local function kbd_status_lines()
    if settings.nav == false then say('keyboard off (//' .. ident.short .. ' nav on)') return end
    local nk = kbd_key()
    local st = kbd.hook == true and nui.N.key_status and nui.N.key_status()
    if kbd.hook == true and type(st) == 'table' then
        say(('keyboard %s (%s) | keys kept by nui\'s key hook: %s%s'):format(kbd.held and 'held' or 'ready', nk.label,
            tostring(st.describe), (st.device and st.device ~= '') and (' | device ' .. st.device) or ''))
        say('keyboard: the search box and the Keyboard key row block the whole keyboard (keyboard_blockinput)')
    else
        say(('keyboard %s (%s) | keys kept by keyboard_blockinput (the whole keyboard) | why: %s'):format(
            kbd.held and 'held' or 'ready', nk.label, tostring(kbd.hook_why or 'the key hook is not joined yet')))
    end
end

-- after every key and once a frame: the block follows what is wanted, but changes only while no key is down
kbd_block = function(now)
    local want = kbd_want_block()
    if want == kbd.block then kbd.wait_since = nil return end
    if kbd.ndown > 0 then
        kbd.wait_since = kbd.wait_since or now
        if now - kbd.wait_since < (want and BLOCK_WAIT_ON or BLOCK_WAIT_OFF) then return end
    end
    kbd_set_block(want)
end

-- the game window lost or gained focus: a key released elsewhere never sent its key-up. Losing focus also lifts the block at
-- once: no key is down in a window without focus
local function kbd_reset()
    kbd.took, kbd.game, kbd.dir, kbd.dir_key = {}, {}, nil, nil
    kbd.down, kbd.ndown = {}, 0
end
local function kbd_unblock_now()
    if kbd.block then kbd_set_block(false) end
    kbd_hide_clear()
end

-- textures: area emblems and the trophy, loaded once and kept (64 px: 16 KB each)
local tex_cache = {}
function app:tex(name)
    if tex_cache[name] ~= nil then return tex_cache[name] or nil end
    tex_cache[name] = false
    if not nui.N or not nui.running then return nil end
    for _, ext in ipairs({'.png', '.PNG', '.jpg'}) do
        local h, w, hh = nui.N.tex_load(HERE .. 'assets/' .. name .. ext, 64, 64)
        if h then
            tex_cache[name] = {h = h, w = w, h_px = hh}
            return tex_cache[name]
        end
    end
    return nil
end

-- the Settings screen's actions
local SCALES = {'one', 'ui', 'sim'}
app.prefs = {
    wintype = function()
        if not settings.wintype or settings.wintype == 0 then return 'Auto (' .. nui.wt.type .. ')' end
        return tostring(settings.wintype)
    end,
    -- the Settings row "Keyboard key": the key, or the prompt while the next key press is awaited
    nav_key = function() return kbd.capture and 'Press a key' or kbd_key().label end,
    -- the Settings row "Controller buttons": the chord, or the prompt while two buttons are awaited
    pad_chord = function() return padc.wait and 'Press two buttons' or pad_chord().label end,
    scale_name = function()
        local m = settings.scale_mode or 'one'
        if m == 'sim' then return ('Sim %dx%d'):format(settings.sim_w, settings.sim_h) end
        return ({one = 'One', ui = 'Game UI'})[m] or m
    end,
    change = function(key, step)
        if key == 'visible_on_load' or key == 'show_uncompletable' or key == 'auto_hide' then
            settings[key] = not settings[key]
            if key == 'show_uncompletable' then data.set_show_uncompletable(settings[key]) end
        elseif key == 'size' then
            settings.size = math.max(0.5, math.min(3, math.floor(((settings.size or 1) + 0.1 * (step or 1)) * 10 + 0.5) / 10))
            apply_view()
            place_window()
        elseif key == 'scale' then
            local i = 1
            for n, m in ipairs(SCALES) do if m == settings.scale_mode then i = n end end
            settings.scale_mode = SCALES[i % #SCALES + 1]
            apply_view()
            place_window()
        elseif key == 'wintype' then
            settings.wintype = ((settings.wintype or 0) + 1) % 9
            if settings.wintype == 0 then nui.pin_type(nil) else nui.pin_type(settings.wintype) end
        elseif key == 'pad' then
            settings.pad = settings.pad == false
            if settings.pad == false then pad_off() end
        elseif key == 'nav' then
            settings.nav = settings.nav == false
            if settings.nav == false then kbd_give() kbd.capture = false end
        elseif key == 'pad_chord' then
            if padc.wait then pad_wait_end() else pad_wait_start() end    -- a second click cancels
        elseif key == 'nav_key' then
            kbd.capture = not kbd.capture       -- the next key pressed is the nav key (kbd_capture); a second click cancels
        elseif key == 'reset' then
            win.x, win.y, win.w, win.h = 200, 150, 620, 760
            place_window()
            win.x, win.y = 200, 150
            save_place()
        end
        save()
    end,
}

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
-- input is taken only while the module draws (review LIFE-4: an invisible window must not swallow clicks); nui.drawing is read
-- from the DLL once a second in prerender, never here
windower.register_event('mouse', function(t, x, y, delta, blocked)
    if not win or not win.visible or not nui.drawing then return end
    -- x and y are UI px; nui.view.mf turns them into the window's Lua units (core/nui.lua)
    local m = nui.view.mf or 1
    if win:mouse(t, x * m, y * m, delta, blocked) then return true end
end)

-- The search box first (review UI-4), then the keyboard driver. A release is swallowed when its press was: by the box, or by the
-- driver (each clears its own record of the press, whoever swallows it)
local function kbd_event(dik, down, ch)
    if not down then
        local mine = kbd.took[dik]
        kbd.took[dik], kbd.game[dik] = nil, nil
        if win and win:key(dik, down, ch) then return true end
        if mine then return true end
        return
    end
    if kbd.took[dik] then return true end                -- the driver's press, held: never the box's or the game's
    if win and nui.drawing and win:key(dik, down, ch) then return true end
    if kbd_down(dik, os.clock()) then return true end
    kbd.game[dik] = true
end
windower.register_event('keyboard', function(dik, down, flags, blocked)
    local ch = keys.char(dik, down)
    if down then
        if not kbd.down[dik] then kbd.down[dik], kbd.ndown = true, kbd.ndown + 1 end
    elseif kbd.down[dik] then
        kbd.down[dik], kbd.ndown = nil, kbd.ndown - 1
    end
    local keep = kbd_event(dik, down, ch)
    kbd_block(os.clock())
    kbd_hide_sync(os.clock(), true)        -- the next read already hides what this key changed (the nav key, Ctrl, Alt)
    if keep then return true end
end)

-- a Shift released while the game had no focus never sent its key-up (review UI-7); the controller and the keyboard go back to
-- the game, which (with "gamepad works when inactive") would otherwise lose the pad to a window nobody is looking at
windower.register_event('lose focus', function() keys.reset() kbd_reset() pad_give() kbd_give() kbd_unblock_now() end)
windower.register_event('gain focus', function() keys.reset() kbd_reset() end)

-- the restyle after a change of the game's window type (made once, not a closure every pass)
local function restyled()
    win:resend()            -- every layer sent again (the DLL rebuilds them too)
    if win.visible then win:flush() end
    pages.restyle()
end

windower.register_event('prerender', function()
    -- the keyboard block first: an error further on must never keep the game's keyboard blocked
    if kbd.block or kbd.held or kbd.capture or padc.wait or (win and win.focus) then kbd_block(os.clock()) end
    kbd_hide_sync(os.clock())
    pad_tick(os.clock())
    kbd_tick(os.clock())
    if not win then
        if retry.at and os.clock() >= retry.at then
            retry.at = nil
            if start(true) and retry.show then win:show() end
        end
        return
    end
    local now = os.clock()
    nui.poll_drawing(now)
    win:tick(now)
    nui.tick(now, restyled)
    pages.tick(now)
end)

local refresh_due, reqs_due = nil, nil
local function refresh()
    progress.on_log()
    if win and win.visible then
        win:invalidate('all')
        win:flush()
    end
end

-- what shows step progress (a page, Home, an area list) redraws when a step's evidence arrives
progress.on_change = function()
    local v = app.view.name
    if win and win.visible and (v == 'guide' or v == 'home' or v == 'area') then win:invalidate('all') win:flush() end
end

windower.register_event('incoming chunk', function(id, original)
    if id == 0x032 or id == 0x034 then
        local info = windower.ffxi.get_info()
        progress.on_event(id, original, info and info.zone)
        return
    end
    if id == 0x00A then
        progress.on_zonein(original)
        return
    end
    if id == 0x110 or id == 0x111 or id == 0x112 or id == 0x061 then
        local ok, changed = pcall(roe.on_packet, id, original)
        if ok and changed and win and win.visible and app.settings.active_tab == 'records' then
            win:invalidate('all')
            win:flush()
        end
        return
    end
    if id == 0x055 then
        progress.on_0x055(original)
        app:requirements_changed()
        if win and win.visible and app.view.name == 'guide' then win:invalidate('content') win:flush() end
        return
    end
    if id ~= 0x056 then return end
    local ok, err = pcall(function() data.parse_packet(packets.parse('incoming', original)) end)
    if not ok then say('packet parse error: ' .. tostring(err), 167) end
    -- the log arrives in a burst: redraw once, 2 s after the first
    if not refresh_due then
        refresh_due = true
        coroutine.schedule(function() refresh_due = nil refresh() end, 2)
    end
end)

-- the chat mode lets progress skip lines no step pattern can match (review CORE-7)
windower.register_event('incoming text', function(original, modified, mode)
    progress.on_text(original, mode)
end)

windower.register_event('remove item', function(bag, index, id, count)
    progress.on_item(id, -(count or 1))
end)

windower.register_event('add item', function(bag, index, id, count)
    progress.on_item(id, count or 1)
    if reqs_due then return end
    reqs_due = true
    coroutine.schedule(function()
        reqs_due = nil
        app:requirements_changed()
        if win and win.visible and app.view.name == 'guide' then win:invalidate('content') win:flush() end
    end, 1)
end)

windower.register_event('zone change', function(new_id)
    data.on_zone_change()
    roe.on_zone(new_id)
end)

windower.register_event('login', function(name)
    data.on_login(name)
    progress.on_login(name)
    roe.reset()
    local info = windower.ffxi.get_info()
    roe.on_zone(info and info.zone)
    -- the new character's settings (review LIFE-6: a settings.xml that failed to load is tried again)
    if settings_ok then
        if not pcall(config.reload, settings) then say('data/settings.xml unreadable, settings kept', 167) end
    elseif load_settings() then
        app.settings = settings
    end
    data.set_show_uncompletable(settings.show_uncompletable)
    if win then
        -- review LIFE-9: the new character's window type pin; texture sharing is chosen at start, so a change waits for a reload
        local wt = nui.wt.type
        if settings.wintype and settings.wintype > 0 then nui.pin_type(settings.wintype) else nui.pin_type(nil) end
        if nui.wt.type ~= wt then win:resend() pages.restyle() end
        local flags = settings.share_textures == false and 'noshare' or nil
        if flags ~= retry.flags then say('texture sharing ' .. (flags and 'off' or 'on') .. ' after a reload', 167) end
        apply_view()
        place_window()
        win.collapsed = settings.collapsed_on_load == true
        app:home()
        if settings.visible_on_load then show() else hide() end
    elseif settings.visible_on_load then
        show()
    end
end)

windower.register_event('logout', function()
    roe.reset()
    progress.flush()
    save_place()
    data.on_logout()
    meta.release()
    hide()
end)

-- The native side stops first (review HOST-2): stop() leaves UiHook and waits until the render thread is out of the DLL. Were
-- it last, an error in a save below would skip it, and Windower would free the DLL while the game may still be drawing with it.
-- The saves are guarded so one failing does not skip the others.
windower.register_event('unload', function()
    if nui.N then pcall(nui.stop) end
    kbd_give()
    kbd_unblock_now()
    pcall(progress.flush)
    pcall(save_place)
    pcall(pages.close)
end)

---------------------------------------------------------------------------
-- Commands
---------------------------------------------------------------------------
local function status()
    if not nui.N then say('_chronicle.dll did not load: ' .. tostring(nui.error), 167) return end
    local s = nui.N.status()
    -- the addon's version and the drawing layer's are separate: the DLL only moves when the
    -- drawing does, so they are both named rather than assumed equal
    say(('%s | _chronicle.dll %s %s | %s | hook %s | clients %s, installs %s'):format(ident.version,
        s.version, s.running and 'running' or 'stopped',
        s.message, s.hook, tostring(s.clients), tostring(s.installs)))
    say(('UiHook %s | driver rev %s'):format(tostring(s.describe), tostring(s.owner_rev)))
    -- the game's own art, and what of it could not be read: the one line a report needs
    if type(s.assets) == 'string' and s.assets ~= '' then
        say('game art: ' .. s.assets, s.assets:find('missing', 1, true) and 167 or 207)
        if s.assets:find('missing', 1, true) then say('please report that line at ' .. ident.issues, 167) end
    end
    say(('draw %.0f us (max %.0f) | layers %d, %d quads, %d batches | build %.0f us | uploads %d'):format(
        s.last_us, s.max_us, s.layers, s.quads, s.batches, s.build_us, s.uploads))
    say(('textures %d KB, CPU pixels %d KB, vertices %d KB, pictures %d'):format(s.texture_kb, s.cpu_pixels_kb,
        s.vertex_kb, s.pictures))
    local c = s.cache
    if c then
        say(('texture cache %s | %d shared, %d own | %d entries, %d KB (%d KB unheld) | %s'):format(
            c.shared and 'shared' or ('private (' .. tostring(c.why) .. ')'), c.shared_textures, c.private_textures,
            c.live_entries, c.live_kb, c.unheld_kb, table.concat(c.clients or {}, ', ')))
    end
    collectgarbage()
    local n, idx = meta.resident()
    say(('Lua heap %d KB | areas resident %d%s | %s'):format(collectgarbage('count'), n, idx and ' + index' or '',
        pages.status()))
    local gt, src = nui.N.wtread()
    local us = nui.uiscale()
    say(('window type %d (%s) | game %s (%s) | UI size %s | uiscale %s | screen %dx%d px, view x%.3f (%s, size %.1f), mouse x%.3f'):format(
        nui.wt.type, nui.wt.follow and 'auto' or 'pinned', tostring(gt), src or 'not found',
        s.ui_found and (s.ui_w .. 'x' .. s.ui_h) or 'not found', us and ('%.3f'):format(us) or 'not reported',
        s.rt_w, s.rt_h, nui.view.f, nui.view.mode, nui.view.size, nui.view.mf or 1))
    pad_status_lines()
    kbd_status_lines()
    if win then
        local st = win.stats
        say(('window %dx%d at %d,%d | sent chrome %d content %d overlay %d, %d unchanged not sent | last layout %.1f ms'):format(
            win.w, win.h, win.x, win.y, st.sent[1], st.sent[2], st.sent[3], st.skipped, st.content_ms))
    end
end

local HELP = {
    '  //%s              toggle the window',
    '  //%s show | hide  show or hide',
    '  //%s compact      collapse or expand',
    '  //%s reset        reset place and size',
    '  //%s refresh      redraw with current data',
    '  //%s home         back to Home',
    '  //%s records      the Records of Eminence tab',
    '  //%s autoshow     toggle showing on load',
    '  //%s autohide [on | off]   Back at a section\'s home hides the window',
    '  //%s size [+|-|n|reset]   the window size (0.5 - 3.0)',
    '  //%s scale one | ui | sim <w> <h> | auto | off',
    '  //%s wintype auto | 1-8',
    '  //%s uncompletable   toggle uncompletable quests',
    '  //%s pad [on | off | status]   take the controller (L3+R3, or your chord, does too)',
    '  //%s pad chord [name]   the two buttons that take it: l3+r3, lb+rb, back+start ...',
    '  //%s nav [on | off | status | key <name>]   take the keyboard\'s arrows (the nav key, K, does too)',
    '  //%s q [area] | m [area]   summaries in chat',
    '  //%s progress [log | debug]   quest step progress',
    '  //%s unknown | debug | status | help',
}

windower.register_event('addon command', function(...)
    local args = {...}
    local cmd = args[1] and args[1]:lower() or 'toggle'
    local a, b, c = args[2] and args[2]:lower(), args[3], args[4]
    if cmd == 'toggle' or cmd == '' then toggle()
    elseif cmd == 'show' then show()
    elseif cmd == 'hide' then hide()
    elseif cmd == 'compact' then if win then win:toggle_collapse() end
    elseif cmd == 'reset' then if start() then app.prefs.change('reset') win:invalidate('all') win:flush() end
    elseif cmd == 'refresh' then refresh()
    elseif cmd == 'home' then app:home()
    elseif cmd == 'records' or cmd == 'roe' or cmd == 'r' then
        settings.active_tab = 'records'
        save()
        if start() then
            app:home()
            win:show()
        end
    elseif cmd == 'autoshow' then
        settings.visible_on_load = not settings.visible_on_load
        save()
        say('show on load ' .. (settings.visible_on_load and 'on' or 'off'))
    elseif cmd == 'autohide' then
        if a == 'on' or a == 'off' then settings.auto_hide = a == 'on'
        elseif a then say('autohide [on | off]', 167) return
        else settings.auto_hide = not settings.auto_hide end
        save()
        say('hide on Back ' .. (settings.auto_hide and 'on' or 'off'))
        if win and win.visible and app.view.name == 'settings' then win:invalidate('all') win:flush() end
    elseif cmd == 'q' or cmd == 'quests' then
        if a then data.print_area('quest', a) else data.print_type_summary('quest') end
    elseif cmd == 'm' or cmd == 'missions' then
        if a then data.print_area('mission', a) else data.print_type_summary('mission') end
    elseif cmd == 'size' then
        if not a then say(('size %.1f'):format(settings.size or 1)) return end
        local v
        if a == '+' or a == 'up' then v = (settings.size or 1) + 0.1
        elseif a == '-' or a == 'down' then v = (settings.size or 1) - 0.1
        elseif a == 'reset' then v = 1
        else v = tonumber(a) end
        if not v then say('size + | - | <0.5-3> | reset', 167) return end
        settings.size = math.max(0.5, math.min(3, math.floor(v * 10 + 0.5) / 10))
        save()
        apply_view()
        if win then place_window() win:flush() end
        say(('size %.1f'):format(settings.size))
    elseif cmd == 'scale' then
        if a == 'sim' then
            local w, h = tonumber(b), tonumber(c)
            if not (w and h and w >= 640 and h >= 480) then say('scale sim <w> <h>, e.g. 2560 1440', 167) return end
            settings.sim_w, settings.sim_h = w, h
        elseif a == 'auto' or a == 'off' then
            settings.rt_auto = a == 'auto'
        elseif not (a == 'one' or a == 'ui') then
            say('scale one | ui | sim <w> <h> | auto | off', 167) return
        end
        if a ~= 'auto' and a ~= 'off' then settings.scale_mode = a end
        save()
        apply_view()
        if win then place_window() win:flush() end
        local sw, sh = nui.screen()
        say(('scale %s: view x%.3f, the window sees a %dx%d screen'):format(a, nui.view.f, sw, sh))
    elseif cmd == 'wintype' then
        local n = tonumber(a)
        if a == 'auto' then
            settings.wintype = 0
            local ok, why = nui.pin_type(nil)
            if not ok and why then say(why, 167) end
        elseif n and n >= 1 and n <= 8 then
            settings.wintype = n
            nui.pin_type(n)
        else
            say('wintype auto | 1-8', 167) return
        end
        save()
        if win then win:resend() win:flush() pages.restyle() end
        say('window type ' .. nui.wt.type .. (settings.wintype == 0 and ' (follows the game)' or ''))
    elseif cmd == 'uncompletable' then
        settings.show_uncompletable = not settings.show_uncompletable
        data.set_show_uncompletable(settings.show_uncompletable)
        save()
        say('uncompletable ' .. (settings.show_uncompletable and 'shown' or 'hidden'))
        refresh()
    elseif cmd == 'progress' then
        if a == 'log' then progress.recent(tonumber(b) or 10)
        elseif a == 'debug' then
            progress.debug = not progress.debug
            say('progress: each observation in chat ' .. (progress.debug and 'on' or 'off'))
        else
            for _, key in ipairs(progress.keys()) do say('progress ' .. key .. ':') progress.report(key) end
        end
    elseif cmd == 'pad' or cmd == 'controller' then
        if a == 'chord' then
            if not b then
                say('controller: ' .. pad_chord().label .. ' takes and gives back the controller (//' .. ident.short ..
                    ' pad chord <name>)')
                return
            end
            local ch, why = pad_set_chord(table.concat(args, ' ', 3))
            if ch then say('controller: ' .. ch.label .. ' takes and gives back the controller')
            else say('controller: ' .. why, 167) end
            if win and app.view.name == 'settings' then win:invalidate('all') win:flush() end
        elseif a == 'on' or a == 'off' then
            settings.pad = a == 'on'
            save()
            if a == 'off' then pad_off() else padc.retry_at = 0 end
            say('controller ' .. a)
        elseif a == 'status' then
            pad_status_lines()
        elseif settings.pad == false then
            say('controller off (//' .. ident.short .. ' pad on)', 167)
        elseif padc.held then
            pad_give()
        elseif not pad_join(os.clock()) then
            local why = tostring(padc.why)
            if padc.xinput == false then         -- the game's own config says so: no guessing between the two causes
                why = why .. '. ' .. XINPUT_OFF
            elseif why:find('not loaded', 1, true) then
                why = why .. '. Turn on Enable XInput in the FFXI Config (Gamepad), or press a pad button first'
            end
            say('controller: ' .. why, 167)
        elseif pad_no_shim() then
            -- nui 1.5.0 joins the client's XInput wrapper before the client loads its XInput shim, and in DirectInput mode
            say('controller: ' .. (padc.xinput == false and XINPUT_OFF
                or 'the game has not loaded its XInput shim (xinputdll.dll) yet. Try again in a moment'), 167)
        else
            local _, b = nui.N.pad()
            pad_take(b or 0)
        end
    elseif cmd == 'nav' or cmd == 'keys' then
        if a == 'key' then
            if not b then say('keyboard: ' .. kbd_key().label .. ' takes the keys (//' .. ident.short .. ' nav key <name>)') return end
            local k, why = kbd_set_key(table.concat(args, ' ', 3))
            if k then say('keyboard: ' .. k.label .. ' takes the keys') else say('keyboard: ' .. why, 167) end
            if win and app.view.name == 'settings' then win:invalidate('all') win:flush() end
        elseif a == 'on' or a == 'off' then
            settings.nav = a == 'on'
            save()
            if a == 'off' then kbd_give() kbd.capture = false end
            say('keyboard ' .. a .. (a == 'on' and (' (' .. kbd_key().label .. ' takes the arrows)') or ''))
        elseif a == 'status' then
            kbd_status_lines()
        elseif settings.nav == false then
            say('keyboard off (//' .. ident.short .. ' nav on)', 167)
        elseif kbd.held then
            kbd_give()
        else
            kbd_take()
        end
    elseif cmd == 'debug' then data.toggle_debug()
    elseif cmd == 'unknown' then data.print_unknown_ids()
    elseif cmd == 'status' then status()
    elseif cmd == 'help' then
        say('commands:')
        for _, l in ipairs(HELP) do windower.add_to_chat(207, l:format(ident.short)) end
    else
        say(('unknown command "%s"; //%s help'):format(cmd, ident.short), 167)
    end
end)

-- the tests' handle on the app (test/harness.lua sets CHRONICLE_TEST before loading)
if rawget(_G, 'CHRONICLE_TEST') then CHRONICLE_TEST.app = app end

-- shown at load only in game (review LIFE-7: an addon loaded at the title screen waits for the login event)
do
    local info = windower.ffxi.get_info()
    if settings.visible_on_load and info and info.logged_in then show() end
end
say(('v%s loaded. //%s to toggle. Zone to load data.'):format(_addon.version, ident.short))
