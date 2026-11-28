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
    check('KEYS-E: a Settings row', row and row.label == 'Keyboard (K)' and row.value == 'On', row and row.value)
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

restore()
print(('test_keys: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)
