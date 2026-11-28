--[[
    test_keys.lua - the keyboard driver: K takes the arrows, Enter, Backspace, Escape, Tab, PgUp/PgDn and Home/End from the game
    and drives the controller's cursor; on the real chronicle.lua through test/harness.lua (fake Windower, fake DLL).
    env.fire('keyboard', dik, down, 0, false) returns true when Chronicle keeps the key from the game. Each rule has its own
    named check (KEYS-1 ...), and each fails on the code without it.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_keys.lua
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
local B = require('ui/pad').B

local K, UP, DOWN, LEFT, RIGHT = 0x25, 0xC8, 0xD0, 0xCB, 0xCD
local ENTER, BKSP, ESC, TAB, PGUP, PGDN, HOME, END = 0x1C, 0x0E, 0x01, 0x0F, 0xC9, 0xD1, 0xC7, 0xCF
local LSHIFT, LCTRL, W_KEY = 0x2A, 0x1D, 0x11

local function shown(opts)
    opts = opts or {}
    opts.settings = opts.settings or {visible_on_load = false}
    local env = H.load(opts)
    env.cmd('show')
    env.packets(H.fixture_packets(530))
    env.frame()
    return env, env.win(), env.app
end

-- -> true when Chronicle kept the key from the game
local function key(env, dik, down) return env.fire('keyboard', dik, down, 0, false) == true end
local function tap(env, dik) local a = key(env, dik, true) local b = key(env, dik, false) return a and b end

local function chat_has(env, s)
    for _, l in ipairs(env.chat) do if l:find(s, 1, true) then return true end end
    return false
end

---------------------------------------------------------------------------------------------------------------------------
-- K takes the keys; the cursor and its keys
do
    local env, win, app = shown()
    local N = env.N
    check('KEYS-0: an arrow is the game\'s before K', not tap(env, DOWN) and not win.pad_mode)
    check('KEYS-1: K is kept from the game (press and release)', tap(env, K))
    check('KEYS-1: K shows the cursor', win.pad_mode and win.cursor and win.cursor.id == 'card', win.cursor and win.cursor.id)
    check('KEYS-1: the hint line names the keys', N.layers[3] and N.layers[3].text:find('K Done', 1, true) ~= nil)
    check('KEYS-1: the pad is not taken with the keys', not N.pad_holding)
    local first = win.cursor
    check('KEYS-2: Right is kept', tap(env, RIGHT))
    check('KEYS-2: Right moves to the card beside', win.cursor and win.cursor.x0 > first.x0 and win.cursor.y0 == first.y0)
    tap(env, LEFT)
    tap(env, DOWN)
    check('KEYS-2: Down moves to the card under', win.cursor and win.cursor.y0 > first.y0)
    tap(env, UP)
    check('KEYS-2: Up comes back', win.cursor and win.cursor.area == first.area)
    local area = win.cursor.area
    check('KEYS-3: Enter is kept', tap(env, ENTER))
    check('KEYS-3: Enter opens the card', app.view.name == 'area' and app.view.params.area == area, app.view.name)
    check('KEYS-4: Backspace is kept', tap(env, BKSP))
    check('KEYS-4: Backspace goes back, onto the card', app.view.name == 'home' and win.cursor and win.cursor.area == area)
    tap(env, ENTER)
    check('KEYS-4: Escape is kept', tap(env, ESC))
    check('KEYS-4: Escape goes back too', app.view.name == 'home')
    local tab = app.settings.active_tab
    check('KEYS-5: Tab is kept', tap(env, TAB))
    check('KEYS-5: Tab is the next section', app.settings.active_tab ~= tab, app.settings.active_tab)
    key(env, LSHIFT, true)
    tap(env, TAB)
    key(env, LSHIFT, false)
    check('KEYS-5: Shift + Tab is the previous section', app.settings.active_tab == tab, app.settings.active_tab)
    -- a page: PgDn, PgUp, End, Home
    app:entry('mission', 'cop', 'Three Paths', 530)
    local vh = win.vp.y1 - win.vp.y0
    local maxs = win.content_h - vh
    check('KEYS-6: PgDn is kept and pages down', tap(env, PGDN) and win.scroll > 0, win.scroll)
    local s1 = win.scroll
    check('KEYS-6: PgUp pages up', tap(env, PGUP) and win.scroll < s1, win.scroll)
    check('KEYS-6: End goes to the bottom', tap(env, END) and math.abs(win.scroll - maxs) < 1, win.scroll .. ' of ' .. maxs)
    check('KEYS-6: Home goes to the top', tap(env, HOME) and win.scroll == 0, win.scroll)
    -- a held arrow repeats on Chronicle's clock
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    env.frame()
    local y0 = win.cursor and win.cursor.y0
    key(env, DOWN, true)
    local y1 = win.cursor and win.cursor.y0
    for _ = 1, 20 do env.frame(1 / 60) end
    local y2 = win.cursor and win.cursor.y0
    for _ = 1, 30 do env.frame(1 / 60) end
    local y3 = win.cursor and win.cursor.y0
    key(env, DOWN, false)
    for _ = 1, 30 do env.frame(1 / 60) end
    local y4 = win.cursor and win.cursor.y0
    check('KEYS-7: a press moves once', y0 and y1 and y1 > y0, tostring(y0) .. ' ' .. tostring(y1))
    check('KEYS-7: no repeat before the delay', y2 == y1, tostring(y1) .. ' ' .. tostring(y2))
    check('KEYS-7: held past the delay it repeats', y3 and y3 > y2, tostring(y2) .. ' ' .. tostring(y3))
    check('KEYS-7: released, it stops', y4 == y3, tostring(y3) .. ' ' .. tostring(y4))
    check('KEYS-7: a repeat from Windower is kept, and moves nothing', (function()
        key(env, DOWN, true)
        local c = win.cursor and win.cursor.y0
        local kept = key(env, DOWN, true)
        local same = (win.cursor and win.cursor.y0) == c
        key(env, DOWN, false)
        return kept and same
    end)())
    -- Escape at a section's home gives the keys back; the window stays
    app:home()
    check('KEYS-8: Escape at the root is kept', tap(env, ESC))
    check('KEYS-8: and gives the keys back', not win.pad_mode and not win.pad_held, tostring(win.pad_mode))
    check('KEYS-8: the window stays', win.visible)
    check('KEYS-8: the arrows are the game\'s again', not tap(env, DOWN))
    check('KEYS-8: no hint line', not N.layers[3].text:find('K Done', 1, true))
    tap(env, K)
    check('KEYS-8: K takes them again', win.pad_mode)
    tap(env, K)
    check('KEYS-8: K gives them back', not win.pad_mode and not tap(env, DOWN))
end

---------------------------------------------------------------------------------------------------------------------------
-- the rules for a press: the game keeps what it saw go down; Chronicle keeps what it took
do
    local env, win = shown()
    check('KEYS-R1: an arrow pressed before K reaches the game', not key(env, DOWN, true))
    tap(env, K)
    local c = win.cursor and win.cursor.y0
    check('KEYS-R1: its repeat after K is still the game\'s', not key(env, DOWN, true))
    check('KEYS-R1: and does not move the cursor', (win.cursor and win.cursor.y0) == c)
    for _ = 1, 60 do env.frame() end
    check('KEYS-R1: nor does holding it', (win.cursor and win.cursor.y0) == c)
    check('KEYS-R1: its release reaches the game', not key(env, DOWN, false))
    check('KEYS-R1: pressed again, it is Chronicle\'s', tap(env, DOWN))

    check('KEYS-R2: an arrow taken while the keys are held', key(env, DOWN, true))
    tap(env, K)
    check('KEYS-R2: the keys went back', not win.pad_mode)
    check('KEYS-R2: its repeat is still kept from the game', key(env, DOWN, true))
    check('KEYS-R2: its release is kept too', key(env, DOWN, false))
    check('KEYS-R2: the next press is the game\'s', not tap(env, DOWN))
    -- the same for Enter, which the game would act on: never half a press
    tap(env, K)
    check('KEYS-R2: Enter taken', key(env, ENTER, true))
    env.cmd('nav')
    check('KEYS-R2: //cr nav gave the keys back', not win.pad_mode)
    check('KEYS-R2: Enter\'s release after that is kept', key(env, ENTER, false))
end

---------------------------------------------------------------------------------------------------------------------------
-- the search box comes first; a press the driver took stays the driver's even when the box takes the focus
do
    local env, win, app = shown()
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    tap(env, K)
    -- up to the header, then along it to Search
    for _ = 1, 20 do
        if win.cursor and win.cursor.id == 'search' then break end
        if win.cursor and win.cursor.content then tap(env, UP) else tap(env, RIGHT) end
    end
    if not (win.cursor and win.cursor.id == 'search') then
        for _ = 1, 20 do
            if win.cursor and win.cursor.id == 'search' then break end
            tap(env, LEFT)
        end
    end
    check('KEYS-S: the cursor reaches Search', win.cursor and win.cursor.id == 'search', win.cursor and win.cursor.id)
    check('KEYS-S: Enter on Search is kept', key(env, ENTER, true))
    check('KEYS-S: and focuses the box', win.focus == 'search')
    check('KEYS-S: a repeat of that Enter is not the box\'s (it would blur it)', key(env, ENTER, true) and win.focus == 'search')
    check('KEYS-S: its release is kept', key(env, ENTER, false))
    check('KEYS-S: K types into the box', tap(env, K) and app.search == 'k' and win.pad_mode, app.search)
    check('KEYS-S: Down goes to the box, not the cursor', tap(env, DOWN) and win.cursor and win.cursor.id == 'search')
    check('KEYS-S: Escape clears the box, it does not go back', tap(env, ESC) and win.focus == nil and app.view.name == 'area')
    check('KEYS-S: the keys are still held after the box', win.pad_mode and tap(env, DOWN))
end

---------------------------------------------------------------------------------------------------------------------------
-- the chat line, Ctrl and Alt
do
    local env, win = shown()
    env.chat_open = true
    check('KEYS-C: K is the chat\'s while the chat line is open', not tap(env, K) and not win.pad_mode)
    env.chat_open = false
    tap(env, K)
    check('KEYS-C: held', win.pad_mode)
    check('KEYS-C: an arrow taken before the chat line opened', key(env, DOWN, true))
    env.chat_open = true
    check('KEYS-C: no new press is taken while it is open', not tap(env, BKSP) and not tap(env, LEFT) and not tap(env, K))
    check('KEYS-C: the arrow taken before stays kept to its release', key(env, DOWN, true) and key(env, DOWN, false))
    env.chat_open = false
    check('KEYS-C: closed again, the keys are taken', tap(env, DOWN))
    tap(env, K)
    key(env, LCTRL, true)
    check('KEYS-C: Ctrl + K is the game\'s', not tap(env, K) and not win.pad_mode)
    key(env, LCTRL, false)
    check('KEYS-C: K alone again takes the keys', tap(env, K) and win.pad_mode)
end

---------------------------------------------------------------------------------------------------------------------------
-- the keys go back with the window, at logout, on lose focus, at unload, on the command and the setting
do
    local env, win, app = shown()
    tap(env, K)
    env.cmd('hide')
    check('KEYS-E: hide gives the keys back', not tap(env, DOWN))
    check('KEYS-E: K shows the window and takes them', tap(env, K) and win.visible and win.pad_mode)
    env.fire('lose focus')
    check('KEYS-E: lose focus gives them back', not win.pad_mode and not tap(env, DOWN))
    tap(env, K)
    key(env, DOWN, true)
    env.fire('lose focus') env.fire('gain focus')
    check('KEYS-E: a key released while the game had no focus is not kept forever', not tap(env, DOWN))
    tap(env, K)
    env.fire('logout')
    check('KEYS-E: logout gives them back', not win.pad_mode and not tap(env, DOWN))
    env.cmd('show')
    tap(env, K)
    env.fire('unload')
    check('KEYS-E: unload gives them back', not tap(env, DOWN))
    -- the setting
    local env2, win2, app2 = shown()
    tap(env2, K)
    app2.prefs.change('nav')
    check('KEYS-E: the setting off gives them back', app2.settings.nav == false and not win2.pad_mode)
    check('KEYS-E: off, K is the game\'s', not tap(env2, K) and not win2.pad_mode)
    env2.cmd('nav')
    check('KEYS-E: off, //cr nav says so', chat_has(env2, 'keyboard off') and not win2.pad_mode)
    app2.prefs.change('nav')
    check('KEYS-E: on again, K takes them', tap(env2, K) and win2.pad_mode)
    env2.cmd('nav')
    check('KEYS-E: //cr nav gives them back', not win2.pad_mode)
    env2.cmd('nav')
    check('KEYS-E: //cr nav takes them', win2.pad_mode)
    -- the Settings row
    local settings = require('ui/screens/settings')
    local row
    for _, r in ipairs(settings.rows(app2)) do if r.key == 'nav' then row = r end end
    check('KEYS-E: a Settings row', row and row.label == 'Keyboard' and row.value == 'On', row and row.value)
end

---------------------------------------------------------------------------------------------------------------------------
-- one cursor, two holds: the pad and the keys are taken and given back on their own
do
    local env, win = shown()
    local N = env.N
    local function press(buttons) N.padstate.buttons = buttons N.padstate.seq = N.padstate.seq + 1 env.frame() end
    local function take_pad() press(B.l3) press(B.l3 + B.r3) press(0) end
    take_pad()
    check('KEYS-T: the pad held', N.pad_holding and win.pad_mode)
    check('KEYS-T: the pad does not take the arrows', not tap(env, DOWN))
    tap(env, K)
    check('KEYS-T: K takes the keys too', tap(env, DOWN))
    check('KEYS-T: the hint is the keyboard\'s', N.layers[3].text:find('K Done', 1, true) ~= nil)
    press(B.down) press(0)
    check('KEYS-T: a pad press shows the pad\'s hint', N.layers[3].text:find('L3+R3 Done', 1, true) ~= nil)
    local c = win.cursor
    tap(env, K)
    check('KEYS-T: K gives back only the keys', N.pad_holding and win.pad_mode and win.cursor == c and not tap(env, DOWN))
    check('KEYS-T: the pad\'s hint stays', N.layers[3].text:find('L3+R3 Done', 1, true) ~= nil)
    tap(env, K)
    press(B.l3) press(B.l3 + B.r3) press(0)
    check('KEYS-T: L3 + R3 gives back only the pad', not N.pad_holding and win.pad_mode and tap(env, DOWN))
    check('KEYS-T: the hint is the keyboard\'s again', N.layers[3].text:find('K Done', 1, true) ~= nil)
    tap(env, K)
    check('KEYS-T: neither holds: no cursor', not win.pad_mode and not win.pad_held)
end

---------------------------------------------------------------------------------------------------------------------------
-- a window that does not draw takes no key (review LIFE-4)
do
    local env, win = shown({fake = {drawing = false}})
    for _ = 1, 70 do env.frame() end
    tap(env, K)
    check('KEYS-D: held', win.pad_mode)
    check('KEYS-D: an arrow is the game\'s while the window does not draw', not tap(env, DOWN))
end

---------------------------------------------------------------------------------------------------------------------------
-- keeping keys from the game: returning true does not do it in game, so the whole keyboard is blocked (keyboard_blockinput)
-- while the keys are held or the search box has focus; the block changes only while no key is down
local function blocks(env)
    local n = 0
    for _, c in ipairs(env.commands) do if c:find('^keyboard_blockinput') then n = n + 1 end end
    return n
end
do
    local env, win, app = shown()
    for _, k in ipairs({DOWN, UP, ENTER, PGDN, W_KEY}) do tap(env, k) end
    for _ = 1, 30 do env.frame() end
    check('BLOCK-0: never used, nothing is sent', blocks(env) == 0, blocks(env))
    check('BLOCK-1: K held: not blocked yet (the game saw K go down)', key(env, K, true) and not env.blockinput)
    key(env, K, false)
    check('BLOCK-1: K released: the keyboard is blocked', env.blockinput and win.pad_mode)
    key(env, K, true)
    check('BLOCK-2: K gives the keys back, still blocked while K is down', not win.pad_mode and env.blockinput)
    key(env, K, false)
    check('BLOCK-2: K released: unblocked', not env.blockinput)
    -- a key the game saw, held when K takes the keys
    key(env, W_KEY, true)
    tap(env, K)
    check('BLOCK-3: a key the game saw is held: not blocked yet', win.pad_mode and not env.blockinput)
    env.frame(0.1)
    key(env, W_KEY, false)
    check('BLOCK-3: it is released: blocked', env.blockinput)
    tap(env, K)
    key(env, W_KEY, true)
    tap(env, K)
    for _ = 1, 40 do env.frame(1 / 60) end
    check('BLOCK-4: held past the wait, the block starts anyway', env.blockinput)
    key(env, W_KEY, false)
    -- a key pressed under the block, held when the keys go back
    check('BLOCK-5: an arrow pressed under the block', key(env, DOWN, true) and env.blockinput)
    tap(env, K)
    check('BLOCK-5: the keys went back, still blocked while it is down', not win.pad_mode and env.blockinput)
    env.frame(0.5)
    check('BLOCK-5: still blocked a moment later', env.blockinput)
    key(env, DOWN, false)
    check('BLOCK-5: released: unblocked', not env.blockinput)
    -- a key whose release was lost does not block the keyboard for good
    tap(env, K)
    key(env, DOWN, true)
    tap(env, K)
    for _ = 1, 150 do env.frame(1 / 60) end
    check('BLOCK-6: a key still down after the wait: unblocked anyway', not env.blockinput)
    key(env, DOWN, false)
    -- the search box: letters typed there no longer open the game's menus
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    local sx, sy
    for _, h in ipairs(win.chrome_b.hits) do
        if h.id == 'search' then sx, sy = win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2 end
    end
    env.fire('mouse', 1, sx, sy, 0, false) env.fire('mouse', 2, sx, sy, 0, false)
    env.frame()
    check('BLOCK-7: the search box focused: blocked', win.focus == 'search' and env.blockinput)
    key(env, ESC, true)
    check('BLOCK-7: Escape leaves the box, still blocked while it is down', win.focus == nil and env.blockinput)
    key(env, ESC, false)
    check('BLOCK-7: released: unblocked', not env.blockinput)
    -- the ways out that cannot wait
    env.fire('mouse', 1, sx, sy, 0, false) env.fire('mouse', 2, sx, sy, 0, false)
    env.frame()
    key(env, W_KEY, true)
    check('BLOCK-8: typing in the box, blocked', env.blockinput)
    env.fire('lose focus')
    check('BLOCK-8: lose focus unblocks at once, with a key down and the box focused', not env.blockinput)
    env.fire('gain focus')
    win.focus = nil
    tap(env, K)
    check('BLOCK-9: taken again', env.blockinput)
    env.cmd('hide')
    check('BLOCK-9: hide unblocks', not env.blockinput)
    env.cmd('show')
    tap(env, K)
    key(env, DOWN, true)
    env.fire('unload')
    check('BLOCK-10: unload unblocks at once, with a key down', not env.blockinput)
end
do
    local env, win = shown({fake = {drawing = false}})
    for _ = 1, 70 do env.frame() end
    tap(env, K)
    for _ = 1, 5 do env.frame() end
    check('BLOCK-11: a window that does not draw blocks nothing', blocks(env) == 0 and not env.blockinput)
end

---------------------------------------------------------------------------------------------------------------------------
-- the nav key is the player's choice: the command, or the Settings row that takes the next key pressed
local N_KEY, F10, F9 = 0x31, 0x44, 0x43
local function chord(env, mod, dik)
    key(env, mod, true)
    local kept = tap(env, dik)
    key(env, mod, false)
    return kept
end
do
    local env, win, app = shown()
    local N = env.N
    env.cmd('nav', 'key')
    check('KEY-1: //cr nav key names the key', chat_has(env, 'K takes the keys'))
    env.cmd('nav', 'key', 'ctrl+n')
    check('KEY-1: //cr nav key ctrl+n', app.settings.nav_key == 'ctrl+n' and chat_has(env, 'Ctrl+N takes the keys'),
        app.settings.nav_key)
    check('KEY-1: K is the game\'s now', not tap(env, K) and not win.pad_mode)
    check('KEY-1: N alone does nothing', not tap(env, N_KEY) and not win.pad_mode)
    check('KEY-1: Ctrl + N takes the keys', chord(env, LCTRL, N_KEY) and win.pad_mode)
    check('KEY-1: the hint line names it', N.layers[3].text:find('Ctrl+N Done', 1, true) ~= nil)
    local c = win.cursor
    check('KEY-1: Ctrl + an arrow is not the cursor\'s', not chord(env, LCTRL, DOWN) and win.cursor == c)
    check('KEY-1: blocked', env.blockinput)
    check('KEY-1: Ctrl + N gives them back under the block (a Windower bind cannot)', chord(env, LCTRL, N_KEY)
        and not win.pad_mode and not env.blockinput)
    env.cmd('nav', 'key', '^', 'f10')
    check('KEY-2: Windower\'s notation, spaces and all', app.settings.nav_key == 'ctrl+f10', app.settings.nav_key)
    env.cmd('nav', 'key', 'banana')
    check('KEY-2: a name that is no key is refused', app.settings.nav_key == 'ctrl+f10' and chat_has(env, 'not a key name'))
    env.cmd('nav', 'key', 'up')
    check('KEY-2: a key that moves the cursor needs a modifier', app.settings.nav_key == 'ctrl+f10'
        and chat_has(env, 'moves the cursor'), app.settings.nav_key)
    env.cmd('nav', 'key', 'k')
    key(env, LSHIFT, true)
    check('KEY-2: Shift + K is still K', tap(env, K) and win.pad_mode)
    key(env, LSHIFT, false)
    tap(env, K)
    -- the Settings row: the next key pressed, with its modifiers
    app:go('settings', {}, 0)
    local settings = require('ui/screens/settings')
    local function row()
        for _, r in ipairs(settings.rows(app)) do if r.key == 'nav_key' then return r end end
    end
    check('KEY-3: a Settings row names the key', row() and row().label == 'Keyboard key' and row().value == 'K',
        row() and row().value)
    app.prefs.change('nav_key')
    env.frame()
    check('KEY-3: clicked, it waits for a key', row().value == 'Press a key')
    check('KEY-3: the keyboard is blocked while it waits', env.blockinput)
    check('KEY-3: F10 is taken', tap(env, F10))
    check('KEY-3: and is the key now', app.settings.nav_key == 'f10' and row().value == 'F10', app.settings.nav_key)
    check('KEY-3: unblocked again', not env.blockinput)
    check('KEY-3: F10 takes the keys', tap(env, F10) and win.pad_mode)
    tap(env, F10)
    app.prefs.change('nav_key')
    key(env, LCTRL, true)
    tap(env, N_KEY)
    key(env, LCTRL, false)
    check('KEY-3: with a modifier', app.settings.nav_key == 'ctrl+n', app.settings.nav_key)
    app.prefs.change('nav_key')
    local lines = #env.chat
    check('KEY-3: Escape keeps the old key', tap(env, ESC) and app.settings.nav_key == 'ctrl+n' and row().value == 'Ctrl+N')
    check('KEY-3: and says nothing (Escape cancels, it is not refused)', #env.chat == lines, env.chat[#env.chat])
    check('KEY-3: and the screen stays', app.view.name == 'settings')
    app.prefs.change('nav_key')
    tap(env, UP)
    check('KEY-3: a key that moves the cursor is refused there too', app.settings.nav_key == 'ctrl+n')
    -- another character's settings: read at the next key
    app.settings.nav_key = 'f9'
    check('KEY-4: a changed setting is read at the next key', tap(env, F9) and win.pad_mode)
    tap(env, F9)
    app.settings.nav_key = 'nonsense'
    check('KEY-4: a setting that is no key falls back to K', tap(env, K) and win.pad_mode)
end

---------------------------------------------------------------------------------------------------------------------------
-- nui 1.6.0: the key hook hides only Chronicle's keys, so nav mode sends no keyboard_blockinput. The search box and the
-- "Keyboard key" row still block the whole keyboard (typed text reaches the chat line as window messages). Each rule has
-- its own named check (HOOK-0 ...).
local NAV_KEYS = {UP, DOWN, LEFT, RIGHT, ENTER, 0x9C, BKSP, ESC, TAB, PGUP, PGDN, HOME, END}
local function hides(env, list)
    for _, k in ipairs(list) do if not env.N.key_hidden[k] then return false end end
    return true
end
local function hidden_count(env) local n = 0 for _ in pairs(env.N.key_hidden) do n = n + 1 end return n end
do
    local env, win, app = shown({fake = {key = true}})
    local N = env.N
    check('HOOK-0: joined on the first frame', N.key_joined and N.key_starts == 1, N.key_starts)
    check('HOOK-1: the nav key is hidden while nav is on', N.key_hidden[K] and hidden_count(env) == 1, hidden_count(env))
    key(env, K, true)
    check('HOOK-2: K takes the keys: the nav keys are hidden at once (before the next frame)', win.pad_mode and hides(env, NAV_KEYS)
        and hidden_count(env) == #NAV_KEYS + 1, hidden_count(env))
    key(env, K, false)
    env.frame()
    check('HOOK-0: nav mode blocks nothing', blocks(env) == 0 and not env.blockinput, blocks(env))
    check('HOOK-2: the arrows are still Chronicle\'s', tap(env, DOWN) and win.pad_mode)
    local before = N.key_hides
    for _ = 1, 5 do env.frame() end
    check('HOOK-4: renewed every frame (the heartbeat)', N.key_hides >= before + 5, N.key_hides - before)
    -- the chat line: nothing new hidden while it is open
    env.chat_open = true
    for _ = 1, 10 do env.frame(1 / 60) end
    check('HOOK-5: chat open: nothing is hidden', hidden_count(env) == 0 and win.pad_mode, hidden_count(env))
    local n_open = N.key_hides
    env.frame(1 / 60)
    check('HOOK-5: and the empty list is sent once, not every frame', N.key_hides == n_open)
    env.chat_open = false
    key(env, W_KEY, true)
    check('HOOK-5: closed again: hidden again (the next key asks at once)', hides(env, NAV_KEYS) and N.key_hidden[K])
    key(env, W_KEY, false)
    -- Ctrl or Alt held: a macro, nothing new hidden
    key(env, LCTRL, true)
    check('HOOK-6: Ctrl held: neither the nav keys nor K are hidden', hidden_count(env) == 0, hidden_count(env))
    check('HOOK-6: Ctrl + Down is the game\'s', not tap(env, DOWN))
    key(env, LCTRL, false)
    check('HOOK-6: Ctrl released: hidden again', hides(env, NAV_KEYS) and N.key_hidden[K])
    -- the keys go back: K alone
    tap(env, K)
    check('HOOK-3: K gives the keys back: only K stays hidden', not win.pad_mode and N.key_hidden[K] and hidden_count(env) == 1,
        hidden_count(env))
    -- the search box blocks the whole keyboard, the hook or not
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    local sx, sy
    for _, h in ipairs(win.chrome_b.hits) do
        if h.id == 'search' then sx, sy = win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2 end
    end
    env.fire('mouse', 1, sx, sy, 0, false) env.fire('mouse', 2, sx, sy, 0, false)
    env.frame()
    check('HOOK-8: the search box focused: the whole keyboard is blocked', win.focus == 'search' and env.blockinput)
    tap(env, ESC)
    env.frame()
    check('HOOK-8: left: unblocked', win.focus == nil and not env.blockinput)
    -- the Settings row "Keyboard key" waits for any key: blocked too
    app.prefs.change('nav_key')
    env.frame()
    check('HOOK-9: the Keyboard key row waiting: blocked', env.blockinput)
    tap(env, ESC)
    env.frame()
    check('HOOK-9: done: unblocked', not env.blockinput)
    -- the Settings row "Controller buttons" waits for two buttons: only Escape is hidden, nothing is blocked
    for _ = 1, 3 do env.frame() end
    app.prefs.change('pad_chord')
    env.frame()
    check('HOOK-10: the Controller buttons row waiting: Escape hidden, no block', N.key_hidden[ESC] and not env.blockinput,
        tostring(env.blockinput))
    tap(env, ESC)
    env.frame()
    check('HOOK-10: done: Escape no longer hidden', not N.key_hidden[ESC] and N.key_hidden[K])
    -- a window that does not draw: the nav keys go to the game, K stays (it shows the window)
    tap(env, K)
    env.N.opts.drawing = false
    for _ = 1, 70 do env.frame() end
    key(env, W_KEY, true) key(env, W_KEY, false)
    check('HOOK-12: not drawing: the nav keys are not hidden, K is', not N.key_hidden[DOWN] and N.key_hidden[K])
    env.N.opts.drawing = nil
    for _ = 1, 70 do env.frame() end
    tap(env, K)
    -- nav off: nothing hidden
    env.cmd('nav', 'off')
    env.frame()
    check('HOOK-11: nav off: nothing hidden', hidden_count(env) == 0)
    env.cmd('nav', 'on')
    env.frame()
    check('HOOK-11: nav on: K hidden again', N.key_hidden[K] and hidden_count(env) == 1)
    -- the status says how the keys are kept
    local lines = #env.chat
    env.cmd('nav', 'status')
    local said = table.concat(env.chat, '\n', lines + 1)
    check('HOOK-16: //cr nav status names the hook', said:find("keys kept by nui's key hook", 1, true) ~= nil
        and said:find('device Hook.dll', 1, true) ~= nil, said)
    lines = #env.chat
    env.cmd('status')
    said = table.concat(env.chat, '\n', lines + 1)
    check('HOOK-16: //cr status has the keyboard line', said:find("keys kept by nui's key hook", 1, true) ~= nil)
    -- lose focus empties the list at once; unload leaves the hook
    tap(env, K)
    env.fire('lose focus')
    check('HOOK-13: lose focus: nothing hidden at once', hidden_count(env) == 0)
    env.fire('gain focus')
    env.frame()
    check('HOOK-13: gain focus: K hidden again', N.key_hidden[K])
    env.fire('unload')
    check('HOOK-14: unload leaves the key hook', not N.key_joined)
end
-- the nav key with Ctrl: hidden only while Ctrl is held
do
    local env, win = shown({fake = {key = true}, settings = {visible_on_load = false, nav_key = 'ctrl+n'}})
    local N = env.N
    check('HOOK-7: Ctrl+N: plain N is not hidden', not N.key_hidden[N_KEY] and hidden_count(env) == 0, hidden_count(env))
    key(env, LCTRL, true)
    check('HOOK-7: Ctrl held: N is hidden', N.key_hidden[N_KEY] and hidden_count(env) == 1)
    tap(env, N_KEY)
    check('HOOK-7: Ctrl+N takes the keys, the nav keys are not hidden while Ctrl is held', win.pad_mode and not N.key_hidden[DOWN])
    key(env, LCTRL, false)
    check('HOOK-7: Ctrl released: the nav keys hidden, N not', hides(env, NAV_KEYS) and not N.key_hidden[N_KEY])
    check('HOOK-0: no block in nav mode with Ctrl+N either', blocks(env) == 0)
end
-- the fallback: nui refuses the hook, or the DLL has none
do
    local env, win = shown()
    tap(env, K)
    env.frame()
    check('HOOK-15: refused: nav mode blocks the whole keyboard', win.pad_mode and env.blockinput)
    local lines = #env.chat
    env.cmd('nav', 'status')
    local said = table.concat(env.chat, '\n', lines + 1)
    check('HOOK-15: and the status says why', said:find('keys kept by keyboard_blockinput', 1, true) ~= nil
        and said:find('were not found (fake)', 1, true) ~= nil, said)
    check('HOOK-15: tried once, not every frame', env.N.key_starts == 1, env.N.key_starts)
end
do
    local env, win = shown({fake = {no_key = true}})
    tap(env, K)
    env.frame()
    check('HOOK-15: no key hook in the DLL: blocked as before', win.pad_mode and env.blockinput)
    local lines = #env.chat
    env.cmd('nav', 'status')
    check('HOOK-15: the status says the DLL has none', table.concat(env.chat, '\n', lines + 1):find('has no keyboard hook', 1, true) ~= nil)
end
do
    local env = shown({fake = {key = true, key_retry_ms = 1000}})
    check('HOOK-17: asked to retry: not joined yet', not env.N.key_joined and env.N.key_starts == 1)
    for _ = 1, 30 do env.frame(1 / 60) end
    check('HOOK-17: not before the retry time', env.N.key_starts == 1)
    env.frame(1)
    check('HOOK-17: joined after it', env.N.key_joined and env.N.key_starts == 2 and env.N.key_hidden[K])
end

restore()
print(('test_keys: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)
