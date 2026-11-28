--[[
    test_autohide.lua - the setting auto_hide: Cancel at a root view (the pad's Cancel, the keyboard's Escape or Backspace)
    hides the window instead of only giving that input back. On the real chronicle.lua through test/harness.lua (fake
    Windower, fake DLL). Each rule has its own named check (HIDE-1 ...), and each fails on the code without it.

    The fake DLL releases the pad at once on pad_capture(false). nui's hook keeps a press made under the capture hidden from
    the game until its release, also after the capture ends (docs/controller-handoff.md §3). game_sees() below models that
    rule, so HIDE-7 can say what the game would see.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_autohide.lua
]]

local H = dofile('test/harness.lua')

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

local KEEP = {'data/places_berrant.lua', 'data/pages_berrant.lua', 'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)

package.path = './?.lua;' .. package.path
local pad = require('ui/pad')
local ops = require('ui/ops')
local B = pad.B
local band = pad.band

local K, DOWN, UP, RIGHT, LEFT, ENTER, BKSP, ESC = 0x25, 0xD0, 0xC8, 0xCD, 0xCB, 0x1C, 0x0E, 0x01

local function shown(opts)
    opts = opts or {}
    opts.settings = opts.settings or {visible_on_load = false}
    local env = H.load(opts)
    env.cmd('show')
    env.packets(H.fixture_packets(530))
    env.frame()
    env.hidden = 0
    return env, env.win(), env.app
end

-- the hook's rule, modelled: a press made while Chronicle holds the pad stays hidden until its release; with no hook
-- (pad_stop) nothing is hidden
local function game_sees(env)
    local N = env.N
    if not N.pad_joined then return N.padstate.buttons end
    return N.padstate.buttons - band(N.padstate.buttons, env.hidden)
end
local function press(env, buttons, dt)
    local N, p = env.N, env.N.padstate
    buttons = buttons or 0
    local new = buttons - band(buttons, p.buttons)
    env.hidden = band(env.hidden, buttons)                               -- a release ends a hidden press
    if N.pad_holding then env.hidden = env.hidden + new - band(new, env.hidden) end   -- read under the capture: hidden
    p.buttons = buttons
    p.seq = p.seq + 1
    env.frame(dt)
    if not N.pad_joined then env.hidden = 0 end
end
local function tap(env, buttons) press(env, buttons) press(env, 0) end
local function take_pad(env) press(env, B.l3) press(env, B.l3 + B.r3) press(env, 0) end

local function key(env, dik, down) return env.fire('keyboard', dik, down, 0, false) == true end
local function ktap(env, dik) local a = key(env, dik, true) local b = key(env, dik, false) return a and b end

local function chat_has(env, s)
    for _, l in ipairs(env.chat) do if l:find(s, 1, true) then return true end end
    return false
end
local function last_block(env)
    for i = #env.commands, 1, -1 do
        if env.commands[i]:find('^keyboard_blockinput') then return i, env.commands[i] end
    end
end

local settings_screen = require('ui/screens/settings')
local function row(app, k)
    for _, r in ipairs(settings_screen.rows(app)) do if r.key == k then return r end end
end
local function gone(env, win) return not win.visible and env.N.layers[1] == nil end

---------------------------------------------------------------------------------------------------------------------------
-- the setting and its row
do
    local env, win, app = shown()
    check('HIDE-1: off by default', app.settings.auto_hide == false, tostring(app.settings.auto_hide))
    local r = row(app, 'auto_hide')
    check('HIDE-1: a Settings row "Hide on Back", Off', r and r.label == 'Hide on Back' and r.value == 'Off', r and r.value)
    local order = {}
    for i, x in ipairs(settings_screen.rows(app)) do order[x.key] = i end
    check('HIDE-1: the row follows "Keyboard key", before "Place and size"', order.auto_hide == order.nav_key + 1
        and order.reset == order.auto_hide + 1)
    local saves = env.saves
    app.prefs.change('auto_hide')
    check('HIDE-1: the row turns it on, and saves', app.settings.auto_hide == true and env.saves > saves
        and row(app, 'auto_hide').value == 'On')
    check('HIDE-1: turning it on does not hide the window', win.visible)
    app.prefs.change('auto_hide')
    check('HIDE-1: and off again', app.settings.auto_hide == false and row(app, 'auto_hide').value == 'Off')
    -- drawn on the Settings screen
    app:go('settings', {}, 0)
    env.frame()
    check('HIDE-1: the Settings screen draws the row', env.N.layers[2].text:find('Hide on Back', 1, true) ~= nil)
    -- saved per character: a saved value is read
    local env2 = shown({settings = {visible_on_load = false, auto_hide = true}})
    check('HIDE-1: a saved On is read', env2.app.settings.auto_hide == true and row(env2.app, 'auto_hide').value == 'On')
end

---------------------------------------------------------------------------------------------------------------------------
-- off: Cancel at the root gives that input back, and the window stays (as before)
do
    local env, win, app = shown()
    local N = env.N
    take_pad(env)
    tap(env, B.b)
    check('HIDE-2: off: the pad\'s Cancel at the root gives the pad back', not N.pad_holding and not win.pad_mode)
    check('HIDE-2: off: the window stays', win.visible and N.layers[1] ~= nil)
    ktap(env, K)
    check('HIDE-2: off: Escape at the root is kept', ktap(env, ESC))
    check('HIDE-2: off: and gives the keys back', not win.pad_mode and not ktap(env, DOWN))
    check('HIDE-2: off: the window stays', win.visible)
    ktap(env, K)
    ktap(env, BKSP)
    check('HIDE-2: off: Backspace at the root gives the keys back, the window stays', not win.pad_mode and win.visible)
end

---------------------------------------------------------------------------------------------------------------------------
-- on: Cancel at the root hides
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    local N = env.N
    take_pad(env)
    check('HIDE-3: the pad held', N.pad_holding and win.pad_mode)
    tap(env, B.b)
    check('HIDE-3: the pad\'s Cancel at the root hides the window', gone(env, win))
    check('HIDE-3: and gives the pad back', not N.pad_holding and not win.pad_mode)
    -- the player's own Cancel from the game's pad config (Confirm B, Cancel A)
    local sin = {}
    for i = 0, 26 do sin[#sin + 1] = (i == 7 and 0) or (i == 5 and 3) or 16 end
    local env2, win2 = shown({settings = {visible_on_load = false, auto_hide = true},
                              fake = {pad_config = {key = 'test', padmode = '1,0,1,1,0,1', padsin = table.concat(sin, ',')}}})
    take_pad(env2)
    tap(env2, B.b)
    check('HIDE-3: with Cancel on A, B is Confirm and does not hide', win2.visible)
    env2.app:home()
    env2.frame()
    tap(env2, B.a)
    check('HIDE-3: the game\'s own Cancel (A) at the root hides', gone(env2, win2) and not env2.N.pad_holding)

    -- the keyboard: Escape and Backspace
    env.cmd('show')
    ktap(env, K)
    check('HIDE-4: Escape at the root is kept', ktap(env, ESC))
    check('HIDE-4: Escape at the root hides the window', gone(env, win))
    check('HIDE-4: and gives the keys back', not win.pad_mode and not ktap(env, DOWN))
    ktap(env, K)
    check('HIDE-4: K shows the window again', win.visible and win.pad_mode)
    check('HIDE-4: Backspace at the root is kept', ktap(env, BKSP))
    check('HIDE-4: Backspace at the root hides the window', gone(env, win))
    check('HIDE-4: and gives the keys back', not ktap(env, DOWN))
end

---------------------------------------------------------------------------------------------------------------------------
-- on: a Cancel that goes back a screen, closes a picture or leaves the search box does not hide
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    local N = env.N
    -- the pad
    take_pad(env)
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    env.frame()
    tap(env, B.b)
    check('HIDE-5: the pad\'s Cancel goes back a screen, the window stays', app.view.name == 'home' and win.visible
        and N.pad_holding)
    local function popup() local b = ops.new() b:rect(0, 0, 10, 10, {0, 0, 0, 255}) win:open_picture(b) end
    popup()
    check('HIDE-5: a picture is open', win.picture)
    tap(env, B.b)
    check('HIDE-5: the pad\'s Cancel closes the picture, the window stays', not win.picture and win.visible and N.pad_holding)
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    env.frame()
    local sx, sy
    for _, h in ipairs(win.chrome_b.hits) do
        if h.id == 'search' then sx, sy = win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2 end
    end
    local function focus_search()
        env.fire('mouse', 1, sx, sy, 0, false) env.fire('mouse', 2, sx, sy, 0, false)
        env.frame()
    end
    -- Home has no search box, so the box is focused on an area list: the Cancel must only leave the box
    focus_search()
    check('HIDE-5: the search box focused', win.focus == 'search')
    tap(env, B.b)
    check('HIDE-5: the pad\'s Cancel leaves the search box, the window stays', win.focus == nil and win.visible
        and app.view.name == 'area')
    tap(env, B.b)
    check('HIDE-5: then goes back a screen, the window stays', app.view.name == 'home' and win.visible)
    tap(env, B.b)
    check('HIDE-5: then at the root it hides', gone(env, win))

    -- the keyboard
    ktap(env, K)
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    env.frame()
    check('HIDE-5: Escape goes back a screen, the window stays', ktap(env, ESC) and app.view.name == 'home' and win.visible
        and win.pad_mode)
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    env.frame()
    check('HIDE-5: Backspace goes back a screen, the window stays', ktap(env, BKSP) and app.view.name == 'home'
        and win.visible)
    popup()
    check('HIDE-5: Escape closes the picture, the window stays', ktap(env, ESC) and not win.picture and win.visible
        and win.pad_mode)
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    env.frame()
    focus_search()
    check('HIDE-5: Escape leaves the search box, the window stays', ktap(env, ESC) and win.focus == nil and win.visible
        and app.view.name == 'area')
    ktap(env, ESC)
    check('HIDE-5: Escape again goes back a screen', app.view.name == 'home' and win.visible)
    ktap(env, ESC)
    check('HIDE-5: then at the root it hides', gone(env, win))
end

---------------------------------------------------------------------------------------------------------------------------
-- on: the chord, the nav key and the commands give back without hiding
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    local N = env.N
    take_pad(env)
    take_pad(env)
    check('HIDE-6: the chord gives the pad back, the window stays', not N.pad_holding and win.visible)
    ktap(env, K)
    ktap(env, K)
    check('HIDE-6: the nav key gives the keys back, the window stays', not win.pad_mode and win.visible)
    take_pad(env)
    env.cmd('pad')
    check('HIDE-6: //cr pad gives the pad back, the window stays', not N.pad_holding and win.visible)
    env.cmd('nav')
    env.cmd('nav')
    check('HIDE-6: //cr nav gives the keys back, the window stays', not win.pad_mode and win.visible)
    env.cmd('autohide', 'on')
    env.cmd('pad', 'chord', 'lb+rb')
    env.cmd('nav', 'key', 'f10')
    env.cmd('autoshow')
    env.cmd('autoshow')
    check('HIDE-6: other commands do not hide', win.visible)
    -- the Settings rows that wait for a press: Escape there keeps the old value, it is no Cancel
    app:go('settings', {}, 0)
    env.frame()
    app.prefs.change('nav_key')
    ktap(env, ESC)
    check('HIDE-6: Escape while "Keyboard key" waits does not hide', win.visible and app.view.name == 'settings')
    app.prefs.change('pad_chord')
    ktap(env, ESC)
    check('HIDE-6: Escape while "Controller buttons" waits does not hide', win.visible and app.view.name == 'settings')
    app.prefs.change('pad_chord')
    tap(env, B.b)
    check('HIDE-6: Cancel alone while "Controller buttons" waits does not hide', win.visible and app.view.name == 'settings')
end

---------------------------------------------------------------------------------------------------------------------------
-- on: the pad's Cancel that hid the window stays away from the game until its release
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    local N = env.N
    take_pad(env)
    local caps = N.captures
    press(env, B.b)
    check('HIDE-7: Cancel pressed: the window hides on the press', gone(env, win))
    check('HIDE-7: the capture ends while Cancel is still down', not N.pad_holding and N.captures == caps + 1
        and N.padstate.buttons == B.b)
    check('HIDE-7: the hook is still there to hide the press (no pad_stop)', N.pad_joined)
    check('HIDE-7: the game does not see Cancel while it is held', band(game_sees(env), B.b) == 0)
    for _ = 1, 30 do press(env, B.b) end
    check('HIDE-7: nor half a second later', band(game_sees(env), B.b) == 0 and not N.pad_holding and not win.visible)
    press(env, 0)
    check('HIDE-7: its release acts on nothing (the window stays hidden, the pad the game\'s)', not win.visible
        and not N.pad_holding and N.captures == caps + 1)
    press(env, B.b)
    check('HIDE-7: the next Cancel is the game\'s', band(game_sees(env), B.b) ~= 0 and not N.pad_holding and not win.visible)
    press(env, 0)
end

---------------------------------------------------------------------------------------------------------------------------
-- on: Escape that hid the window stays blocked until its release
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    ktap(env, K)
    check('HIDE-8: the keys held: the keyboard blocked', env.blockinput and win.pad_mode)
    local n0 = #env.commands
    check('HIDE-8: Escape down is kept', key(env, ESC, true))
    check('HIDE-8: the window hides on the press', gone(env, win))
    check('HIDE-8: still blocked while Escape is down', env.blockinput and #env.commands == n0)
    env.frame(0.5)
    env.frame(0.5)
    check('HIDE-8: still blocked a second later', env.blockinput and #env.commands == n0)
    check('HIDE-8: the release is kept', key(env, ESC, false))
    local i, c = last_block(env)
    check('HIDE-8: keyboard_blockinput 0 comes with the release', not env.blockinput and i == n0 + 1
        and c == 'keyboard_blockinput 0', c)
    check('HIDE-8: then the keys are the game\'s', not ktap(env, DOWN) and not ktap(env, ESC))
    -- Backspace the same
    ktap(env, K)
    local n1 = #env.commands
    key(env, BKSP, true)
    check('HIDE-8: Backspace: hidden, still blocked while it is down', gone(env, win) and env.blockinput
        and #env.commands == n1)
    key(env, BKSP, false)
    check('HIDE-8: Backspace released: unblocked', not env.blockinput)
end

---------------------------------------------------------------------------------------------------------------------------
-- on: both held, a Cancel at the root hides and gives back both
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    local N = env.N
    take_pad(env)
    ktap(env, K)
    check('HIDE-9: both held', N.pad_holding and win.pad_mode and env.blockinput)
    tap(env, B.b)
    check('HIDE-9: the pad\'s Cancel at the root hides', gone(env, win))
    check('HIDE-9: the pad goes back', not N.pad_holding)
    check('HIDE-9: the keys go back (no key was down: unblocked at once)', not env.blockinput and not ktap(env, DOWN))
    env.cmd('show')
    take_pad(env)
    ktap(env, K)
    key(env, ESC, true)
    check('HIDE-9: Escape at the root hides, with both held', gone(env, win))
    check('HIDE-9: the pad goes back', not N.pad_holding)
    check('HIDE-9: the keys stay blocked until Escape\'s release', env.blockinput)
    key(env, ESC, false)
    check('HIDE-9: then unblocked', not env.blockinput and not ktap(env, DOWN))
end

---------------------------------------------------------------------------------------------------------------------------
-- on: showing again works as before
do
    local env, win, app = shown({settings = {visible_on_load = false, auto_hide = true}})
    local N = env.N
    take_pad(env)
    tap(env, B.b)
    check('HIDE-10: hidden', gone(env, win))
    take_pad(env)
    check('HIDE-10: the chord shows the window and takes the pad', win.visible and N.layers[1] ~= nil and N.pad_holding
        and win.pad_mode)
    check('HIDE-10: the hint line is back', N.layers[3] and N.layers[3].text:find('L3+R3 Done', 1, true) ~= nil)
    check('HIDE-10: the cursor is on a card', win.cursor and win.cursor.id == 'card', win.cursor and win.cursor.id)
    tap(env, B.right)
    tap(env, B.a)
    check('HIDE-10: the cursor works', app.view.name == 'area')
    tap(env, B.b)
    check('HIDE-10: Cancel goes back', app.view.name == 'home' and win.visible)
    tap(env, B.b)
    check('HIDE-10: and hides again at the root', gone(env, win))
    ktap(env, K)
    check('HIDE-10: K shows the window and takes the keys', win.visible and win.pad_mode and env.blockinput)
    check('HIDE-10: the arrows move the cursor', ktap(env, DOWN) and win.cursor ~= nil)
    ktap(env, ESC)
    check('HIDE-10: Escape hides again', gone(env, win) and not env.blockinput)
    env.cmd('show')
    check('HIDE-10: //cr show shows it, nothing held', win.visible and not win.pad_mode and not N.pad_holding)
    tap(env, B.b)
    check('HIDE-10: a Cancel with nothing held does not hide', win.visible)
    check('HIDE-10: Escape with nothing held is the game\'s', not ktap(env, ESC) and win.visible)
end

---------------------------------------------------------------------------------------------------------------------------
-- the command
do
    local env, win, app = shown()
    local saves = env.saves
    env.cmd('autohide')
    check('HIDE-11: //cr autohide turns it on, and saves', app.settings.auto_hide == true and env.saves > saves
        and chat_has(env, 'hide on Back on'))
    env.cmd('autohide')
    check('HIDE-11: again turns it off', app.settings.auto_hide == false and chat_has(env, 'hide on Back off'))
    env.cmd('autohide', 'on')
    check('HIDE-11: //cr autohide on', app.settings.auto_hide == true)
    env.cmd('autohide', 'on')
    check('HIDE-11: on stays on', app.settings.auto_hide == true)
    env.cmd('autohide', 'OFF')
    check('HIDE-11: //cr autohide off (any case)', app.settings.auto_hide == false)
    local n = #env.chat
    env.cmd('autohide', 'banana')
    check('HIDE-11: anything else is refused, and changes nothing', app.settings.auto_hide == false and #env.chat == n + 1
        and env.chat[#env.chat]:find('autohide [on | off]', 1, true) ~= nil, env.chat[#env.chat])
    check('HIDE-11: autoshow is still its own command', (function()
        local v = app.settings.visible_on_load
        env.cmd('autoshow')
        local ok = app.settings.visible_on_load ~= v and app.settings.auto_hide == false
        env.cmd('autoshow')
        return ok
    end)())
    app:go('settings', {}, 0)
    env.frame()
    local sent = env.N.sent[2]
    env.cmd('autohide', 'on')
    check('HIDE-11: the Settings screen follows the command', env.N.sent[2] > sent and row(app, 'auto_hide').value == 'On',
        tostring(env.N.sent[2]) .. ' ' .. tostring(sent))
    local h = #env.chat
    env.cmd('help')
    local listed = false
    for i = h + 1, #env.chat do
        if env.chat[i]:find('//cr autohide [on | off]', 1, true) and env.chat[i]:find('hides the window', 1, true) then listed = true end
    end
    check('HIDE-11: help names it', listed)
end

restore()
print(('test_autohide: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)
