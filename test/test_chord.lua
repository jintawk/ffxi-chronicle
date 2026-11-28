--[[
    test_chord.lua - the controller chord is the player's choice (settings.pad_chord): the parser in ui/pad.lua, the decoder,
    and chronicle.lua's edge test, hook mask, hint and status text, the command, and the Settings row that waits for two
    buttons, on the real addon through test/harness.lua with the fake DLL's pad (N.padstate, N.pad_holding, N.chord). Each
    rule has its own named check (CHORD-1 ...), and each fails on the code without it.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_chord.lua
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
local ESC = 0x01

local function shown(opts)
    opts = opts or {}
    opts.settings = opts.settings or {visible_on_load = false}
    local env = H.load(opts)
    env.cmd('show')
    env.packets(H.fixture_packets(530))
    env.frame()
    return env, env.win(), env.app
end

local function press(env, buttons, dt)
    local p = env.N.padstate
    p.buttons = buttons or 0
    p.seq = p.seq + 1
    env.frame(dt)
end
local function tap(env, buttons) press(env, buttons) press(env, 0) end
local function chord(env, a, b) press(env, a) press(env, a + b) press(env, 0) end
local function key(env, dik, down) return env.fire('keyboard', dik, down, 0, false) == true end

local function chat_has(env, s)
    for _, l in ipairs(env.chat) do if l:find(s, 1, true) then return true end end
    return false
end
local function said_since(env, n, s)
    for i = n + 1, #env.chat do if env.chat[i]:find(s, 1, true) then return true end end
    return false
end
local function has(list, a) for _, v in ipairs(list) do if v == a then return true end end return false end

local settings_screen = require('ui/screens/settings')
local function row(app, k)
    for _, r in ipairs(settings_screen.rows(app)) do if r.key == k then return r end end
end

---------------------------------------------------------------------------------------------------------------------------
-- the parser (an error in it is a failed check, not a stopped run)
do
    local function parse(n)
        local ok, c, why = pcall(pad.parse_chord, n)
        if not ok then return nil, 'error: ' .. tostring(c) end
        return c, why or ''
    end
    local c = parse('l3+r3')
    check('CHORD-2: l3+r3', c and c.mask == B.l3 + B.r3 and c.label == 'L3+R3' and c.name == 'l3+r3')
    c = parse('R3 + L3')
    check('CHORD-2: any order and case, spaces', c and c.name == 'l3+r3' and c.label == 'L3+R3', c and c.name)
    c = parse('lb+rb')
    check('CHORD-2: lb+rb', c and c.mask == B.lb + B.rb and c.label == 'LB+RB')
    c = parse('start+back')
    check('CHORD-2: back+start, in a fixed order', c and c.mask == B.back + B.start and c.label == 'Back+Start'
        and c.name == 'back+start', c and c.label)
    c = parse('select+x')
    check('CHORD-2: select is Back', c and c.mask == B.back + B.x and c.label == 'Back+X', c and c.label)
    local ok, why = parse('l3')
    check('CHORD-3: one button is refused', not ok and why:find('two buttons', 1, true), why)
    ok, why = parse('l3+r3+a')
    check('CHORD-3: three buttons are refused', not ok and why:find('two buttons', 1, true), why)
    ok, why = parse('l3+banana')
    check('CHORD-3: a name that is no button is refused', not ok and why:find('not a button name', 1, true), why)
    ok, why = parse('a+a')
    check('CHORD-3: the same button twice is refused', not ok and why:find('two different', 1, true), why)
    ok, why = parse('up+a')
    check('CHORD-3: the D-pad is refused', not ok and why:find('D-pad', 1, true), why)
    ok, why = parse('left+right')
    check('CHORD-3: the D-pad is refused (two directions)', not ok and why:find('D-pad', 1, true), why)
    ok, why = parse('lt+rt')
    check('CHORD-3: a trigger is refused (nui holds back only the button word)', not ok and why:find('trigger', 1, true), why)
    ok, why = parse('a+rt')
    check('CHORD-3: one trigger is refused too', not ok and why:find('trigger', 1, true), why)
    ok = parse('guide+a')
    check('CHORD-3: Guide is no button (XInputGetState does not report it)', not ok)
end

---------------------------------------------------------------------------------------------------------------------------
-- the decoder: the chord's buttons act on release alone, and R3 is Top
do
    local out = {}
    local d = pad.new()
    local function feed(t, b) return d:feed(t, b, 0, 0, 0, 0, 0, 0, out) end
    -- the default: exactly as before
    feed(0, B.r3)
    check('CHORD-8: L3+R3: R3 is not Top on press', not has(out, 'top'))
    check('CHORD-8: L3+R3: R3 alone is Top on release', has(feed(0.1, 0), 'top'))
    feed(0.2, B.l3)
    check('CHORD-8: L3+R3: L3 alone does nothing on release', #feed(0.3, 0) == 0)
    -- LB + RB: LB alone is the previous section on its release, never on its press
    d:set_chord(B.lb + B.rb)
    feed(1.0, B.lb)
    check('CHORD-5: a chord button does not act on its press', not has(out, 'tab_prev'))
    check('CHORD-5: alone, it acts on its release', has(feed(1.1, 0), 'tab_prev'))
    feed(1.2, B.lb)
    check('CHORD-5: with its partner it is the chord', has(feed(1.3, B.lb + B.rb), 'toggle') and not has(out, 'tab_next'))
    check('CHORD-5: and then neither acts on release', #feed(1.4, 0) == 0)
    feed(1.5, B.l3)
    check('CHORD-5: L3 + R3 is not the chord then', not has(feed(1.6, B.l3 + B.r3), 'toggle'))
    feed(1.7, 0)
    check('CHORD-8: R3 out of the chord is Top on press', has(feed(1.8, B.r3), 'top'))
    check('CHORD-8: and not again on release', not has(feed(1.9, 0), 'top'))
    -- R3 in another chord: Top on release alone, as now
    d:set_chord(B.r3 + B.y)
    feed(2.0, B.r3)
    check('CHORD-8: R3 + Y: R3 not Top on press', not has(out, 'top'))
    check('CHORD-8: R3 + Y: R3 alone Top on release', has(feed(2.1, 0), 'top'))
    feed(2.2, B.y)
    check('CHORD-8: R3 + Y: Y waits for its release', not has(out, 'filter'))
    check('CHORD-8: R3 + Y: Y alone is Show on release', has(feed(2.3, 0), 'filter'))
    -- the conflict check follows the chord's buttons (padsin ids: 3 A, 1 X, 10 L3, 13 R3)
    local sin = {}
    for i = 0, 26 do sin[#sin + 1] = (i == 7 and 3) or 16 end
    local cfg = {padsin = table.concat(sin, ',')}
    check('CHORD-7: A in the chord, mapped in the game: a conflict', #pad.chord_conflicts(cfg, B.a + B.x) == 1)
    check('CHORD-7: L3 + R3 not mapped: none', #pad.chord_conflicts(cfg, B.l3 + B.r3) == 0)
end

---------------------------------------------------------------------------------------------------------------------------
-- the setting, the command, the edge test, the hook's mask, the hint and the status
do
    local env, win, app = shown()
    local N = env.N
    check('CHORD-1: the default is l3+r3', app.settings.pad_chord == 'l3+r3', app.settings.pad_chord)
    env.cmd('pad', 'chord')
    check('CHORD-1: //cr pad chord names it', chat_has(env, 'L3+R3 takes and gives back'))
    local saves = env.saves
    env.cmd('pad', 'chord', 'lb', '+', 'rb')
    check('CHORD-1: //cr pad chord lb + rb sets it, and saves it', app.settings.pad_chord == 'lb+rb' and env.saves > saves
        and chat_has(env, 'LB+RB takes and gives back'), app.settings.pad_chord)
    check('CHORD-6: the hook keeps the new chord from the game', N.chord == B.lb + B.rb, N.chord)
    local n = #env.chat
    env.cmd('pad', 'chord', 'up+a')
    check('CHORD-3: the command refuses the D-pad and keeps the chord', app.settings.pad_chord == 'lb+rb'
        and said_since(env, n, 'D-pad') and N.chord == B.lb + B.rb)
    env.cmd('pad', 'chord', 'lt+rt')
    check('CHORD-3: and a trigger', app.settings.pad_chord == 'lb+rb' and said_since(env, n, 'trigger'))
    chord(env, B.l3, B.r3)
    check('CHORD-5: L3 + R3 no longer takes the pad', not N.pad_holding)
    chord(env, B.lb, B.rb)
    check('CHORD-5: LB + RB takes it', N.pad_holding and win.pad_mode)
    check('CHORD-7: the hint names the chord', N.layers[3].text:find('LB+RB Done', 1, true) ~= nil)
    check('CHORD-7: the first take names the chord in chat', chat_has(env, 'controller: LB+RB gives it back to the game'))
    local tab = app.settings.active_tab
    tap(env, B.rb)
    check('CHORD-5: RB alone is the next section, on release', app.settings.active_tab ~= tab and N.pad_holding)
    tap(env, B.lb)
    check('CHORD-5: LB alone the previous', app.settings.active_tab == tab)
    env.cmd('pad', 'status')
    check('CHORD-7: status says held', chat_has(env, 'controller held'))
    chord(env, B.lb, B.rb)
    check('CHORD-5: LB + RB gives it back', not N.pad_holding)
    env.cmd('pad', 'status')
    check('CHORD-7: status names the chord', chat_has(env, 'ready (LB+RB)'))
    app:go('settings', {}, 0)
    check('CHORD-7: the Settings row is "Controller"', row(app, 'pad') and row(app, 'pad').label == 'Controller')
    check('CHORD-7: and "Controller buttons" names the chord', row(app, 'pad_chord').label == 'Controller buttons'
        and row(app, 'pad_chord').value == 'LB+RB', row(app, 'pad_chord').value)
    -- changed while held: the hint follows at once
    chord(env, B.lb, B.rb)
    env.cmd('pad', 'chord', 'back+start')
    check('CHORD-7: a chord changed while held: the hint follows', N.layers[3].text:find('Back+Start Done', 1, true) ~= nil)
    check('CHORD-6: and the hook follows', N.chord == B.back + B.start)
    chord(env, B.back, B.start)
    check('CHORD-5: Back + Start gives it back', not N.pad_holding)
    -- another character's settings: read at the next frame
    app.settings.pad_chord = 'x+y'
    env.frame()
    check('CHORD-6: a changed setting reaches the hook at the next frame', N.chord == B.x + B.y, N.chord)
    chord(env, B.x, B.y)
    check('CHORD-5: and takes the pad', N.pad_holding)
    chord(env, B.x, B.y)
    app.settings.pad_chord = 'nonsense'
    env.frame()
    check('CHORD-4: a setting that is no chord falls back to L3 + R3', N.chord == B.l3 + B.r3, N.chord)
    chord(env, B.l3, B.r3)
    check('CHORD-4: and L3 + R3 takes the pad', N.pad_holding and N.layers[3].text:find('L3+R3 Done', 1, true) ~= nil)
    chord(env, B.l3, B.r3)
end

-- joined with another chord saved: the hook gets that one, and the status line names its conflict
do
    local sin = {}
    for i = 0, 26 do sin[#sin + 1] = (i == 7 and 3) or (i == 5 and 0) or 16 end
    local env = shown({settings = {visible_on_load = false, pad_chord = 'a+x'},
                       fake = {pad_config = {key = 'test', padmode = '1,0,1,1,0,1', padsin = table.concat(sin, ',')}}})
    check('CHORD-6: joined: the hook gets the saved chord', env.N.chord == B.a + B.x, env.N.chord)
    env.cmd('pad', 'status')
    check('CHORD-7: status names the conflict with its buttons', chat_has(env, 'A/X also mapped in the game'))
end

---------------------------------------------------------------------------------------------------------------------------
-- the Settings row "Controller buttons": the next two buttons held together
do
    local env, win, app = shown()
    local N = env.N
    app:go('settings', {}, 0)
    env.frame()
    -- clicked with the mouse, while the pad is the game's
    app.prefs.change('pad_chord')
    check('CHORD-9: clicked, it waits for two buttons', row(app, 'pad_chord').value == 'Press two buttons')
    check('CHORD-15: the pad is kept from the game while it waits', N.pad_holding)
    env.frame()
    check('CHORD-15: so is the keyboard (Escape must not reach the game)', env.blockinput)
    press(env, B.lb)
    check('CHORD-9: one button is not yet a chord', row(app, 'pad_chord').value == 'Press two buttons' and N.pad_holding)
    press(env, B.lb + B.rb)
    check('CHORD-9: two held together are the chord', app.settings.pad_chord == 'lb+rb' and N.chord == B.lb + B.rb,
        app.settings.pad_chord)
    check('CHORD-9: the row names it', row(app, 'pad_chord').value == 'LB+RB')
    check('CHORD-9: chat names it', chat_has(env, 'LB+RB takes and gives back'))
    check('CHORD-15: the pad goes back to the game', not N.pad_holding)
    env.frame()
    check('CHORD-15: and the keyboard', not env.blockinput)
    press(env, B.lb + B.rb)
    check('CHORD-15: the chord still held does not take the pad', not N.pad_holding)
    press(env, 0)
    chord(env, B.lb, B.rb)
    check('CHORD-9: pressed again, it takes the pad', N.pad_holding)
    chord(env, B.lb, B.rb)

    -- Escape on the keyboard keeps the old chord, quietly
    app.prefs.change('pad_chord')
    local n = #env.chat
    check('CHORD-10: Escape is kept from the game', key(env, ESC, true) and key(env, ESC, false))
    check('CHORD-10: Escape keeps the old chord', app.settings.pad_chord == 'lb+rb' and row(app, 'pad_chord').value == 'LB+RB')
    check('CHORD-10: and says nothing', #env.chat == n, env.chat[#env.chat])
    check('CHORD-10: the pad goes back', not N.pad_holding)
    check('CHORD-10: the screen stays', app.view.name == 'settings')

    -- a second click cancels
    app.prefs.change('pad_chord')
    app.prefs.change('pad_chord')
    check('CHORD-9: a second click cancels', row(app, 'pad_chord').value == 'LB+RB' and not N.pad_holding)

    -- Cancel alone keeps the old chord; Cancel with a partner is a chord
    app.prefs.change('pad_chord')
    press(env, B.b)
    check('CHORD-11: Cancel held is not yet a cancel', row(app, 'pad_chord').value == 'Press two buttons')
    press(env, 0)
    check('CHORD-11: Cancel alone keeps the old chord', app.settings.pad_chord == 'lb+rb' and not N.pad_holding
        and row(app, 'pad_chord').value == 'LB+RB')
    app.prefs.change('pad_chord')
    press(env, B.b)
    press(env, B.b + B.x)
    check('CHORD-11: Cancel with a partner is a chord', app.settings.pad_chord == 'b+x', app.settings.pad_chord)
    press(env, 0)
    env.cmd('pad', 'chord', 'lb+rb')

    -- about 5 s with nothing keeps the old chord; a press starts the 5 s again
    app.prefs.change('pad_chord')
    for _ = 1, 4 do env.frame(1) end
    check('CHORD-12: still waiting after 4 s', row(app, 'pad_chord').value == 'Press two buttons')
    press(env, B.x)
    press(env, 0)
    for _ = 1, 4 do env.frame(1) end
    check('CHORD-12: a press starts the wait again', row(app, 'pad_chord').value == 'Press two buttons')
    n = #env.chat
    for _ = 1, 2 do env.frame(1) end
    check('CHORD-12: after 5 s with nothing it keeps the old chord', row(app, 'pad_chord').value == 'LB+RB'
        and app.settings.pad_chord == 'lb+rb' and not N.pad_holding)
    check('CHORD-12: and says so', said_since(env, n, 'nothing pressed, LB+RB kept'))

    -- a refused pair says why and keeps the old chord
    app.prefs.change('pad_chord')
    n = #env.chat
    press(env, B.up + B.a)
    check('CHORD-13: the D-pad is refused', app.settings.pad_chord == 'lb+rb' and said_since(env, n, 'D-pad')
        and said_since(env, n, 'LB+RB kept'))
    check('CHORD-13: the wait ends, the pad goes back', row(app, 'pad_chord').value == 'LB+RB' and not N.pad_holding)
    press(env, 0)
    app.prefs.change('pad_chord')
    press(env, B.a + B.lt)
    check('CHORD-13: a trigger is refused', app.settings.pad_chord == 'lb+rb' and said_since(env, n, 'trigger'))
    press(env, 0)
    app.prefs.change('pad_chord')
    press(env, B.a + B.x + B.y)
    check('CHORD-13: three at once are refused', app.settings.pad_chord == 'lb+rb' and said_since(env, n, 'two buttons'))
    press(env, 0)

    -- a lapsed hold while it waits is taken again
    app.prefs.change('pad_chord')
    N.pad_holding = false
    env.frame()
    check('CHORD-15: a lapsed hold is taken again while it waits', N.pad_holding)
    -- hiding the window ends the wait and gives the pad back
    env.cmd('hide')
    check('CHORD-15: hide ends the wait, the pad goes back', not N.pad_holding and row(app, 'pad_chord').value == 'LB+RB')
    env.cmd('show')
end

-- chosen from the pad: the Confirm that chose the row counts only once released, and the pad stays Chronicle's after
do
    local env, win, app = shown()
    local N = env.N
    chord(env, B.l3, B.r3)
    tap(env, B.start)
    check('CHORD-15: Settings from the pad', app.view.name == 'settings' and N.pad_holding)
    for _ = 1, 30 do
        if win.cursor and win.cursor.key == 'pad_chord' then break end
        tap(env, B.down)
    end
    check('CHORD-15: the cursor reaches "Controller buttons"', win.cursor and win.cursor.key == 'pad_chord',
        win.cursor and win.cursor.key)
    press(env, B.a)
    check('CHORD-15: Confirm on the row starts the wait', row(app, 'pad_chord').value == 'Press two buttons')
    press(env, B.a + B.x)
    check('CHORD-15: the Confirm held from before does not count', row(app, 'pad_chord').value == 'Press two buttons'
        and app.settings.pad_chord == 'l3+r3')
    press(env, 0)
    check('CHORD-15: nor does the lone X with it', row(app, 'pad_chord').value == 'Press two buttons')
    local view = app.view.name
    press(env, B.lb)
    press(env, B.lb + B.rb)
    check('CHORD-15: then two buttons are the chord', app.settings.pad_chord == 'lb+rb', app.settings.pad_chord)
    check('CHORD-15: the pad stays Chronicle\'s', N.pad_holding and win.pad_held)
    local tab = app.settings.active_tab
    press(env, 0)
    check('CHORD-15: the new chord\'s buttons do not act on their release', app.view.name == view
        and app.settings.active_tab == tab and N.pad_holding)
    check('CHORD-15: the hint names the new chord', N.layers[3].text:find('LB+RB Done', 1, true) ~= nil)
    chord(env, B.lb, B.rb)
    check('CHORD-15: the new chord gives it back', not N.pad_holding)
end

-- not joined: it says so and does not wait
do
    local env, win, app = shown({fake = {pad_fail = 'XInputGetState is not hot-patchable: not patched'}})
    local N = env.N
    app:go('settings', {}, 0)
    app.prefs.change('pad_chord')
    check('CHORD-14: not joined: it says so', chat_has(env, 'not reading the controller'))
    check('CHORD-14: and does not wait', row(app, 'pad_chord').value == 'L3+R3' and N.captures == 0)
    env.frame()
    check('CHORD-14: nor block the keyboard', not env.blockinput)
end

restore()
print(('test_chord: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)
