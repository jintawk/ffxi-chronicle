--[[
    test_pad.lua - the controller: the decoder (ui/pad.lua), the cursor (ui/nav.lua, ui/window.lua) and the lifecycle in
    chronicle.lua (the L3+R3 chord, giving the pad back, the heartbeat, settings), on the real addon through test/harness.lua
    with the fake DLL's pad (N.padstate, N.pad_holding).

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_pad.lua
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
local B = pad.B

---------------------------------------------------------------------------------------------------------------------------
-- the decoder, alone
do
    local d = pad.new()
    local out = {}
    local function feed(t, b, lx, ly, ry) return d:feed(t, b, 0, 0, lx or 0, ly or 0, 0, ry or 0, out) end
    local function has(list, a) for _, v in ipairs(list) do if v == a then return true end end return false end
    check('decoder: idle is nothing', #feed(0, 0) == 0)
    check('decoder: A is Confirm', has(feed(0.1, B.a), 'confirm'))
    check('decoder: held is not again', #feed(0.2, B.a) == 0)
    feed(0.3, 0)
    check('decoder: B is Cancel', has(feed(0.4, B.b), 'cancel'))
    feed(0.5, 0)
    check('decoder: X Sort, Y Show', has(feed(0.6, B.x), 'sort') and has(feed(0.7, B.x + B.y), 'filter'))
    feed(0.8, 0)
    check('decoder: LB / RB', has(feed(0.9, B.lb), 'tab_prev') and has(feed(1.0, B.lb + B.rb), 'tab_next'))
    feed(1.1, 0)
    check('decoder: LT / RT', has(feed(1.2, B.lt), 'page_up') and has(feed(1.3, B.lt + B.rt), 'page_down'))
    feed(1.4, 0)
    check('decoder: Start / Back', has(feed(1.5, B.start), 'settings') and has(feed(1.6, B.start + B.back), 'collapse'))
    feed(1.7, 0)
    -- a direction repeats after REPEAT_DELAY, then every REPEAT_EVERY
    check('decoder: down at once', has(feed(2.0, B.down), 'down'))
    check('decoder: no repeat before the delay', #feed(2.2, B.down) == 0)
    check('decoder: repeat after the delay', has(feed(2.0 + pad.REPEAT_DELAY + 0.01, B.down), 'down'))
    check('decoder: then quickly', has(feed(2.0 + pad.REPEAT_DELAY + 0.09, B.down), 'down'))
    feed(3, 0)
    -- the left stick, with hysteresis
    check('decoder: stick down', has(feed(3.1, 0, 0, -20000), 'down'))
    check('decoder: stick held inside the on-threshold', #feed(3.2, 0, 0, -12000) == 0 and d.dir == 'down')
    feed(3.3, 0, 0, -10000)
    check('decoder: stick released inside the off-threshold', d.dir == nil)
    check('decoder: stick right', has(feed(3.4, 0, 30000, 2000), 'right'))
    feed(3.5, 0)
    -- the chord; R3 alone is Top on release
    feed(4.0, B.l3)
    check('decoder: L3 + R3 is the chord', has(feed(4.1, B.l3 + B.r3), 'toggle'))
    feed(4.2, 0)
    feed(4.3, B.r3)
    check('decoder: R3 alone is Top, on release', has(feed(4.4, 0), 'top'))
    feed(4.5, B.r3)
    check('decoder: R3 then L3 is the chord, not Top', has(feed(4.6, B.r3 + B.l3), 'toggle') and not has(feed(4.7, 0), 'top'))
    -- held when the pad was taken: nothing until released
    d:latch(B.a)
    check('decoder: a latched button does not act', #feed(5.0, B.a) == 0)
    feed(5.1, 0)
    check('decoder: after its release it does', has(feed(5.2, B.a), 'confirm'))
    feed(5.3, 0)
    -- the right stick scrolls: up is up, faster further out
    local _, s1 = feed(6.0, 0, 0, 0, 20000)
    local _, s2 = feed(6.1, 0, 0, 0, 20000)
    local _, s3 = feed(6.2, 0, 0, 0, 32767)
    check('decoder: right stick up scrolls up', s2 < 0, s2)
    check('decoder: further is faster', s3 < s2, s2 .. ' ' .. s3)
    local _, s4 = feed(6.3, 0, 0, 0, -32767)
    check('decoder: right stick down scrolls down', s4 > 0)
    local _, s5 = feed(6.4, 0, 0, 0, 3000)
    check('decoder: inside the dead zone nothing', s5 == 0)
    -- the game's own Confirm / Cancel (padsin000 slot 7 / 5, XInput ids 0 B, 3 A)
    local sin = {}
    for i = 0, 26 do sin[#sin + 1] = (i == 7 and 0) or (i == 5 and 3) or 16 end
    local c, x, xi = pad.from_config({padmode = '1,0,1,1,0,1', padsin = table.concat(sin, ',')})
    check('config: a B-confirm layout swaps them', c == 'b' and x == 'a' and xi == true, tostring(c) .. tostring(x))
    c, x, xi = pad.from_config({padmode = '1,0,1,1,0,0', padsin = table.concat(sin, ',')})
    check('config: DirectInput mode: the defaults', c == 'a' and x == 'b' and xi == false)
    c, x = pad.from_config(nil)
    check('config: none: A / B', c == 'a' and x == 'b')
    sin[1] = 10
    check('config: L3 mapped in the game is a conflict', #pad.chord_conflicts({padsin = table.concat(sin, ',')}) == 1)
end

---------------------------------------------------------------------------------------------------------------------------
-- the window, through the real addon
local function shown(opts)
    opts = opts or {}
    opts.settings = opts.settings or {visible_on_load = false}
    local env = H.load(opts)
    env.cmd('show')
    env.packets(H.fixture_packets(530))
    if env.run_scheduled then env.run_scheduled() end
    return env, env.win(), env.app
end

local function press(env, buttons, extra)
    local p = env.N.padstate
    p.buttons = buttons or 0
    p.lx, p.ly, p.rx, p.ry = 0, 0, 0, 0
    for k, v in pairs(extra or {}) do p[k] = v end
    p.seq = p.seq + 1
    env.frame()
end
local function tap(env, buttons) press(env, buttons) press(env, 0) end
local function take(env) press(env, B.l3) press(env, B.l3 + B.r3) press(env, 0) end

do
    local env, win, app = shown()
    local N = env.N
    env.frame()
    check('lifecycle: joined on the first frame', N.pad_joined and N.pad_starts == 1)
    check('lifecycle: the hook keeps L3 + R3 from the game', N.chord == B.l3 + B.r3, N.chord)
    env.frame()
    check('lifecycle: not held before the chord', not N.pad_holding and not win.pad_mode)
    tap(env, B.a)
    check('lifecycle: buttons do nothing before the chord', app.view.name == 'home' and not N.pad_holding)
    take(env)
    check('lifecycle: the chord takes the pad', N.pad_holding and win.pad_mode and win.pad_held)
    check('lifecycle: a hint line', N.layers[3] and N.layers[3].text:find('L3+R3 Done', 1, true) ~= nil)
    local cur = win.cursor
    check('cursor: on the first card', cur and cur.id == 'card', cur and cur.id)
    local first = cur
    tap(env, B.right)
    check('cursor: right is the card beside it', win.cursor and win.cursor.id == 'card' and win.cursor.x0 > first.x0
        and win.cursor.y0 == first.y0)
    tap(env, B.down)
    check('cursor: down is the card under it', win.cursor and win.cursor.id == 'card' and win.cursor.y0 > first.y0
        and win.cursor.x0 > first.x0)
    tap(env, B.left)
    tap(env, B.up)
    check('cursor: back on the first card', win.cursor and win.cursor.area == first.area)
    tap(env, B.up)
    check('cursor: up from the top row is the header', win.cursor and not win.cursor.content, win.cursor and win.cursor.id)
    check('cursor: the header draws it (chrome hover)', win.hover == win.cursor)
    tap(env, B.down)
    check('cursor: down from the header is the content again', win.cursor and win.cursor.id == 'card')
    -- open a card, come back to it
    local area = win.cursor.area
    tap(env, B.a)
    check('confirm: the card opens its area', app.view.name == 'area' and app.view.params.area == area)
    check('confirm: the first row has the cursor', win.cursor and win.cursor.id == 'row', win.cursor and win.cursor.id)
    for _ = 1, 30 do tap(env, B.down) end
    check('area: moving down scrolls the list', win.scroll > 0, win.scroll)
    local vh = win.vp.y1 - win.vp.y0
    local c = win.cursor
    check('area: the cursor stays in view', c and c.y0 >= win.scroll and c.y1 <= win.scroll + vh, c and (c.y0 .. ' ' .. win.scroll))
    tap(env, B.b)
    check('cancel: back home', app.view.name == 'home')
    check('cancel: on the card it left', win.cursor and win.cursor.id == 'card' and win.cursor.area == area,
        win.cursor and win.cursor.area)
    -- sections
    local tab = app.settings.active_tab
    tap(env, B.rb)
    check('RB: the next section', app.settings.active_tab ~= tab, app.settings.active_tab)
    tap(env, B.lb)
    check('LB: back to the first', app.settings.active_tab == tab)
    -- Start: Settings; a row's button; Cancel back
    tap(env, B.start)
    check('Start: Settings', app.view.name == 'settings')
    check('Settings: a row has the cursor', win.cursor and win.cursor.id == 'set', win.cursor and win.cursor.id)
    tap(env, B.b)
    check('Settings: Cancel goes back', app.view.name == 'home')
    -- Cancel with nowhere to go back to gives the pad back to the game
    tap(env, B.b)
    check('cancel at the root: the pad goes back', not N.pad_holding and not win.pad_mode)
    check('cancel at the root: the window stays', win.visible)
    check('given back: no hint line', not N.layers[3].text:find('L3+R3 Done', 1, true))
    -- the chord again takes it, and gives it back
    take(env)
    check('chord: taken again', N.pad_holding)
    press(env, B.l3) press(env, B.l3 + B.r3)
    check('chord: given back', not N.pad_holding)
    press(env, 0)
end

---------------------------------------------------------------------------------------------------------------------------
-- a walkthrough: links, path tabs, long stretches of text
do
    local env, win, app = shown()
    local N = env.N
    env.frame()
    app:entry('mission', 'cop', 'Three Paths', 530)
    take(env)
    check('page: held', N.pad_holding)
    local seen, max_scroll, steps = {}, 0, 0
    for _ = 1, 400 do
        tap(env, B.down)
        if win.cursor then seen[win.cursor.id] = true end
        if win.scroll > max_scroll then max_scroll = win.scroll end
        steps = steps + 1
        if win.scroll >= (win.content_h or 0) - (win.vp.y1 - win.vp.y0) then break end
    end
    check('page: down reaches the end', win.scroll >= (win.content_h or 0) - (win.vp.y1 - win.vp.y0) - 1,
        win.scroll .. ' of ' .. tostring(win.content_h))
    check('page: links take the cursor', seen.link == true)
    check('page: path tabs take the cursor', seen.tab == true)
    local s0 = win.scroll
    tap(env, B.lt)
    check('LT: a page up', win.scroll < s0)
    press(env, B.r3) press(env, 0)
    check('R3: the top', win.scroll == 0)
    -- the right stick scrolls, and the cursor stays in view
    for _ = 1, 30 do press(env, 0, {ry = -32767}) end
    press(env, 0)
    check('right stick: scrolls', win.scroll > 0)
    local c, vh = win.cursor, win.vp.y1 - win.vp.y0
    check('right stick: the cursor in view, or parked', (not c) or (c.y1 > win.scroll and c.y0 < win.scroll + vh))
    -- a link's tooltip follows the cursor
    for _ = 1, 40 do
        if win.cursor and win.cursor.id == 'link' then break end
        tap(env, B.down)
    end
    check('tooltip: a link under the cursor is described', win.cursor and win.cursor.id == 'link'
        and N.layers[3].text:find('opens in', 1, true) ~= nil)
    -- the path tab under the cursor switches the path
    win:pad_scroll(0, true)
    local tabhit
    for _ = 1, 60 do
        tap(env, B.down)
        if win.cursor and win.cursor.id == 'tab' then tabhit = win.cursor break end
    end
    if tabhit then
        tap(env, B.right)
        local to = win.cursor
        tap(env, B.a)
        local cur = package.loaded['core/pages'].current()
        check('tab: Confirm switches the path', to and to.id == 'tab' and cur and cur.tabs[to.group] == to.i)
    else
        check('tab: reached by moving down', false)
    end
end

---------------------------------------------------------------------------------------------------------------------------
-- giving it back: hide, focus, the mouse, the heartbeat, settings
do
    local env, win, app = shown()
    local N = env.N
    env.frame()
    take(env)
    env.cmd('hide')
    check('hide: the pad goes back', not N.pad_holding)
    env.cmd('show')
    take(env)
    env.fire('lose focus')
    check('lose focus: the pad goes back', not N.pad_holding)
    take(env)
    -- the mouse takes the hover; the next pad action gives it back to the cursor
    local x, y = win.x + 40, win.y + 200
    env.fire('mouse', 0, x, y, 0, false)
    env.fire('mouse', 0, x + 1, y, 0, false)
    check('mouse: a jiggle leaves the cursor', win.pad_mode)
    env.fire('mouse', 0, 3, 3, 0, false)
    env.fire('mouse', 0, 60, 3, 0, false)
    check('mouse: a move elsewhere on the screen leaves the cursor', win.pad_mode)
    env.fire('mouse', 0, x, y, 0, false)
    env.fire('mouse', 0, x + 30, y + 30, 0, false)
    check('mouse: a move takes the hover', not win.pad_mode and N.pad_holding)
    tap(env, B.down)
    check('mouse: a pad action brings the cursor back', win.pad_mode and win.cursor ~= nil)
    -- a lapsed hold (Lua stalled past the heartbeat) is taken again on the next frame, and what is held waits
    N.pad_holding = false
    local before = N.captures
    press(env, B.a)
    check('heartbeat: taken again', N.pad_holding and N.captures == before + 1)
    check('heartbeat: the held button did not act', app.view.name == 'home')
    press(env, 0)
    -- settings: off gives it back and leaves the hook; nothing is read
    app.prefs.change('pad')
    check('settings: off', app.settings.pad == false and not N.pad_holding and not N.pad_joined)
    local starts = N.pad_starts
    for _ = 1, 5 do env.frame() end
    check('settings: off reads nothing', N.pad_starts == starts)
    app.prefs.change('pad')
    env.frame()
    check('settings: on joins again', N.pad_joined)
    env.cmd('pad')
    check('//cr pad takes it', N.pad_holding)
    env.cmd('pad')
    check('//cr pad gives it back', not N.pad_holding)
end

-- the game reads a DirectInput pad: xinput1_3.dll never loads; asked again only every few seconds, and //cr pad says why
do
    local env = shown({fake = {pad_fail = 'xinput1_3.dll is not loaded (the game reads the pad with DirectInput, or not yet)',
                       pad_retry_ms = 5000}})
    local N = env.N
    for _ = 1, 30 do env.frame() end
    check('not loaded: tried once, not every frame', N.pad_starts == 1, N.pad_starts)
    env.cmd('pad')
    local said = false
    for _, l in ipairs(env.chat) do if l:find('Enable XInput', 1, true) then said = true end end
    check('not loaded: //cr pad says what to do', said)
end

-- the game's own Confirm on B: B opens, A goes back
do
    local sin = {}
    for i = 0, 26 do sin[#sin + 1] = (i == 7 and 0) or (i == 5 and 3) or 16 end
    local env, win, app = shown({fake = {pad_config = {key = 'test', padmode = '1,0,1,1,0,1', padsin = table.concat(sin, ',')}}})
    env.frame()
    take(env)
    check('swap: hint names B', env.N.layers[3].text:find('B Open', 1, true) ~= nil)
    tap(env, B.b)
    check('swap: B opens', app.view.name == 'area', app.view.name)
    tap(env, B.a)
    check('swap: A goes back', app.view.name == 'home')
end

restore()
print(('test_pad: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)
