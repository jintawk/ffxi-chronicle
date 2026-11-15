--[[
    test_input.lua - input and lifecycle fixes of the 2026-11-07 review, on the real chronicle.lua through test/harness.lua
    (fake Windower, recording fake of the DLL). Each check names its review id; each fails on the code before the fix.

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_input.lua
]]

local H = dofile('test/harness.lua')

local pass, fail = 0, 0
local function check(name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print('FAIL ' .. name .. (detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end

-- keep the user's saved places and page state out of the way (per character since review LIFE-6, and the shared files before),
-- backed up on disk so a killed run loses nothing (H.protect)
local KEEP = {'data/places_berrant.lua', 'data/pages_berrant.lua', 'data/places.lua', 'data/pages.lua'}
local restore = H.protect(KEEP)
-- the player's own files, as they are before this run: a test must never change them (see harness.lua H.DATA_DIR)
local REAL = {'data/places.lua', 'data/pages.lua', 'data/places_berrant.lua', 'data/pages_berrant.lua',
    'data/progress/Berrant.tsv', 'data/settings.xml'}
local function slurp(p) local f = io.open(p, 'rb') if not f then return nil end local s = f:read('*a') f:close() return s end
local real_before = {}
for _, p in ipairs(REAL) do real_before[p] = slurp(p) or false end

local function chat_has(env, s)
    for _, l in ipairs(env.chat) do if l:find(s, 1, true) then return true end end
    return false
end

local function shown(opts)
    opts = opts or {}
    opts.settings = opts.settings or {visible_on_load = false}
    local env = H.load(opts)
    env.cmd('show')
    env.packets(H.fixture_packets(530))
    return env, env.win(), env.app
end

-- a point of the window with no hit (the content's empty margin), in screen px (view factor 1)
local function blank(win)
    for y = win.vp.y1 - 4, win.vp.y0 + 4, -3 do
        for x = win.vp.x0 + 2, win.vp.x1 - 2, 5 do
            if not win:hit_at(x, y) then return win.x + x, win.y + y end
        end
    end
end

---------------------------------------------------------------------------------------------------------------------------
-- LIFE-2: a release is acted on and swallowed only when its press was the window's
do
    local env, win, app = shown()
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    local x, y = blank(win)
    check('LIFE-2: a blank point in the window', x ~= nil)
    check('LIFE-2: a left press outside is not consumed', env.fire('mouse', 1, 5, 5, 0, false) == nil)
    check('LIFE-2: its release over the window is not consumed', env.fire('mouse', 2, x, y, 0, false) == nil)
    check('LIFE-2: a right press outside is not consumed', env.fire('mouse', 4, 5, 5, 0, false) == nil)
    check('LIFE-2: its release over the window is not consumed', env.fire('mouse', 5, x, y, 0, false) == nil)
    check('LIFE-2: and does not go back', app.view.name == 'area', app.view.name)
    check('LIFE-2: a right press over the window is consumed', env.fire('mouse', 4, x, y, 0, false) == true)
    check('LIFE-2: its release goes back', env.fire('mouse', 5, x, y, 0, false) == true and app.view.name == 'home', app.view.name)
    check('LIFE-2: a left press over the window is consumed', env.fire('mouse', 1, x, y, 0, false) == true)
    check('LIFE-2: its release outside is consumed too', env.fire('mouse', 2, 5, 5, 0, false) == true)
    check('LIFE-2: a press another addon blocked is not taken', env.fire('mouse', 1, x, y, 0, true) == nil)
    check('LIFE-2: nor its release', env.fire('mouse', 2, x, y, 0, false) == nil)
    check('LIFE-2: a middle press outside, its release over the window: not consumed',
        env.fire('mouse', 7, 5, 5, 0, false) == nil and env.fire('mouse', 8, x, y, 0, false) == nil)
end

---------------------------------------------------------------------------------------------------------------------------
-- UI-4: a key-up is swallowed only when its key-down was; a click outside clears the focus even when another addon blocked it
do
    local env, win, app = shown()
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    local sx, sy
    for _, h in ipairs(win.chrome_b.hits) do
        if h.id == 'search' then sx, sy = win.x + (h.x0 + h.x1) / 2, win.y + (h.y0 + h.y1) / 2 end
    end
    env.fire('keyboard', 0x11, true, 0, false)                   -- W held (the game sees it go down) ...
    env.fire('mouse', 1, sx, sy, 0, false) env.fire('mouse', 2, sx, sy, 0, false)
    check('UI-4: search focused', win.focus == 'search')
    check('UI-4: the release of a key held before the focus reaches the game', env.fire('keyboard', 0x11, false, 0, false) == nil)
    check('UI-4: a key pressed in the box is consumed', env.fire('keyboard', 0x14, true, 0, false) == true)
    check('UI-4: and its release', env.fire('keyboard', 0x14, false, 0, false) == true)
    check('UI-4: Escape consumed (blurs)', env.fire('keyboard', 0x01, true, 0, false) == true and win.focus == nil)
    check('UI-4: its release after the blur is still swallowed', env.fire('keyboard', 0x01, false, 0, false) == true)
    env.fire('mouse', 1, sx, sy, 0, false) env.fire('mouse', 2, sx, sy, 0, false)
    check('UI-4: focused again', win.focus == 'search')
    env.fire('mouse', 1, 5, 5, 0, true)                          -- a click outside another addon blocked
    check('UI-4: a blocked click outside clears the focus', win.focus == nil)
    env.fire('mouse', 2, 5, 5, 0, true)
end

---------------------------------------------------------------------------------------------------------------------------
-- UI-5: the enlarged picture goes with its screen and with hide; hide ends a thumb drag
do
    local env, win, app = shown()
    local ops = package.loaded['ui/ops']
    local N = env.N
    local function popup() local b = ops.new() b:rect(0, 0, 10, 10, {0, 0, 0, 255}) win:open_picture(b) end
    popup()
    check('UI-5: the popup is up', N.layers[4] ~= nil and win.picture)
    app:go('area', {cat = 'mission', area = 'cop'}, 0)
    check('UI-5: a new screen closes the popup', N.layers[4] == nil and not win.picture)
    popup()
    env.cmd('hide') env.cmd('show')
    check('UI-5: hide forgets the popup', not win.picture)
    check('UI-5: so a release in the game world afterwards is not swallowed', env.fire('mouse', 2, 5, 5, 0, false) == nil)
    app:entry('mission', 'cop', 'Three Paths', 530)
    local th = win.thumb
    check('UI-5: a page with a scrollbar', th ~= nil)
    if th then
        env.fire('mouse', 1, win.x + (th.x0 + th.x1) / 2, win.y + (th.thumb0 + th.thumb1) / 2, 0, false)
        check('UI-5: thumb drag started', win.thumb_drag ~= nil)
        env.cmd('hide')
        check('UI-5: hide ends the thumb drag', win.thumb_drag == nil)
        env.cmd('show')
        local s0 = win.scroll
        env.fire('mouse', 0, win.x + 10, win.y + 600, 0, false) env.frame()
        check('UI-5: the page no longer follows the mouse', win.scroll == s0, s0 .. ' -> ' .. win.scroll)
    end
end

---------------------------------------------------------------------------------------------------------------------------
-- UI-6: the thumb follows the cursor: dragged by the track's free length it reaches the end exactly
do
    local env, win, app = shown()
    app:entry('mission', 'cop', 'Three Paths', 530)
    win:scroll_to(0) win:flush()
    local th = win.thumb
    local vh = win.vp.y1 - win.vp.y0
    local free = (th.y1 - th.y0) - (th.thumb1 - th.thumb0)
    check('UI-6: the track is shorter than the viewport', th.y1 - th.y0 < vh, (th.y1 - th.y0) .. ' ' .. vh)
    local tx, ty = win.x + (th.x0 + th.x1) / 2, win.y + (th.thumb0 + th.thumb1) / 2
    env.fire('mouse', 1, tx, ty, 0, false)
    env.fire('mouse', 0, tx, ty + free / 2, 0, false) env.frame()
    local want = (win.content_h - vh) / 2
    check('UI-6: half the free track is half the scroll', math.abs(win.scroll - want) < 1, win.scroll .. ' want ' .. want)
    env.fire('mouse', 2, tx, ty + free / 2, 0, false)
end

---------------------------------------------------------------------------------------------------------------------------
-- UI-7: each Shift key on its own, reset when the game loses focus
do
    local env = shown()
    local keys = package.loaded['ui/keys']
    keys.char(0x2A, true) keys.char(0x36, true) keys.char(0x36, false)
    check('UI-7: left Shift still held after the right one is released', keys.char(0x1E, true) == 'A')
    env.fire('lose focus')
    check('UI-7: focus lost resets Shift', keys.char(0x1E, true) == 'a')
    keys.char(0x2A, true) env.fire('gain focus')
    check('UI-7: focus gained resets Shift', keys.char(0x1E, true) == 'a')
end

---------------------------------------------------------------------------------------------------------------------------
-- LIFE-1: while the hook is missing, start is retried after 5 s, 30 s, 2 min, then given up with one line; the window type's
-- assets are loaded once, not at every try
do
    local env = H.load({settings = {visible_on_load = true}, fake = {fail = 'not hooked: signature not found', retry_ms = 5000}})
    local N = env.N
    for _ = 1, 600 do env.frame(1) end                          -- ten minutes
    check('LIFE-1: four tries in ten minutes', N.starts == 4, N.starts)
    check('LIFE-1: the window type loaded once', N.wintypes == 1, N.wintypes)
    check('LIFE-1: said when it gave up', chat_has(env, 'gave up'))
    local lines = 0
    for _, l in ipairs(env.chat) do if l:find('not hooked', 1, true) then lines = lines + 1 end end
    check('LIFE-1: two lines in all (waiting, gave up)', lines == 2, lines)
    env.fake_opts.fail = nil
    env.cmd('show')
    check('LIFE-1: a show command tries again', N.starts == 5 and env.win() ~= nil, N.starts)
end

---------------------------------------------------------------------------------------------------------------------------
-- LIFE-4: no input is taken while the module does not draw; status() is asked at most once a second
do
    local env, win = shown({fake = {drawing = false}})
    local N = env.N
    local s0 = N.statuses
    for _ = 1, 120 do env.frame() end                           -- two seconds
    check('LIFE-4: status asked about once a second', N.statuses - s0 <= 3, N.statuses - s0)
    local x, y = blank(win)
    check('LIFE-4: a press over a window that does not draw is not consumed', env.fire('mouse', 1, x, y, 0, false) == nil)
    env.fire('mouse', 2, x, y, 0, false)
    check('LIFE-4: nor the wheel', env.fire('mouse', 10, x, y, -1, false) == nil)
    env.fake_opts.drawing = true
    for _ = 1, 70 do env.frame() end
    check('LIFE-4: drawing again: consumed', env.fire('mouse', 1, x, y, 0, false) == true)
    env.fire('mouse', 2, x, y, 0, false)
    local env2, win2 = shown()                                  -- a DLL without the field: drawing
    for _ = 1, 70 do env2.frame() end
    local x2, y2 = blank(win2)
    check('LIFE-4: no drawing field counts as drawing', env2.fire('mouse', 1, x2, y2, 0, false) == true)
end

---------------------------------------------------------------------------------------------------------------------------
-- LIFE-6: a settings.xml config.load cannot parse: the addon loads on defaults, saves nothing, and tries again at login
do
    local ok, env = pcall(H.load, {settings = {visible_on_load = false, size = 2}, config_error = 'XML error: unexpected end', config_errors = 1})
    check('LIFE-6: the addon loads', ok, env)
    if ok then
        check('LIFE-6: said so', chat_has(env, 'settings.xml unreadable'))
        check('LIFE-6: defaults in use', env.app.settings.size == 1.0 and env.app.settings.visible_on_load == true)
        env.cmd('autoshow')
        check('LIFE-6: nothing saved', env.saves == 0, env.saves)
        env.fire('login', 'Berrant')
        check('LIFE-6: loaded at login', env.app.settings.size == 2, env.app.settings.size)
        env.cmd('autoshow')
        check('LIFE-6: saved from then on', env.saves == 1, env.saves)
    end
end

---------------------------------------------------------------------------------------------------------------------------
-- LIFE-7: not shown at load before login
do
    local env = H.load({settings = {visible_on_load = true}, logged_in = false})
    check('LIFE-7: no window at the title screen', next(env.N.layers) == nil and env.win() == nil)
    env.fire('login', 'Berrant')
    check('LIFE-7: shown at login', env.N.layers[1] ~= nil)
end

---------------------------------------------------------------------------------------------------------------------------
-- LIFE-9: the new character's window type pin is applied at login
do
    local env = H.load({settings = {visible_on_load = true, wintype = 0}, fake = {game_type = 6}})
    check('LIFE-9: follows the game first', env.N.wt == 6)
    env.app.settings.wintype = 3                                -- what config.reload reads for the next character
    env.fire('logout')
    env.fire('login', 'Berrant')
    check('LIFE-9: the pin applied at login', env.N.wt == 3, env.N.wt)
    check('LIFE-9: nothing about texture sharing (unchanged)', not chat_has(env, 'texture sharing'))
    env.app.settings.share_textures = false
    env.fire('login', 'Berrant')
    check('LIFE-9: a sharing change is said to wait for a reload', chat_has(env, 'texture sharing off'))
end

---------------------------------------------------------------------------------------------------------------------------
-- CORE-7 (call site): the incoming text event's chat mode reaches progress.on_text
do
    local env = H.load({settings = {visible_on_load = false}})
    local progress = package.loaded['core/progress']
    local got
    local real = progress.on_text
    progress.on_text = function(text, mode) got = {text, mode} end
    env.fire('incoming text', 'You obtain a key item.', 'You obtain a key item.', 151, 151, false)
    progress.on_text = real
    check('CORE-7: text and mode passed', got and got[1] == 'You obtain a key item.' and got[2] == 151, got and tostring(got[2]))
end

---------------------------------------------------------------------------------------------------------------------------
-- UI-3: the sticky tab bar takes clicks on all of it, not only on its labels
do
    local env, win, app = shown()
    app:entry('mission', 'cop', 'Three Paths', 530)
    win:scroll_to(win.content_h) win:flush()
    local bar
    for _, h in ipairs(win.overlay_b and win.overlay_b.hits or {}) do if h.sticky and h.i then bar = h end end
    check('UI-3: the sticky bar is up', bar ~= nil)
    if bar then
        local lx, ly = win.vp.x1 - 3, bar.y0 + 14              -- right of the last label
        local h = win:hit_at(lx, ly)
        check('UI-3: a blank part of the bar is the bar', h and h.sticky and not h.content, h and h.id)
        local urls, view, sc = #env.urls, app.view.name, win.scroll
        env.fire('mouse', 1, win.x + lx, win.y + ly, 0, false) env.fire('mouse', 2, win.x + lx, win.y + ly, 0, false)
        check('UI-3: a click there opens nothing', #env.urls == urls and app.view.name == view and win.scroll == sc)
    end
end

---------------------------------------------------------------------------------------------------------------------------
-- UI-2: break_word ends when what must follow the word is wider than a line (was an endless loop)
do
    local D = require('ui/doc')
    local done, parts = false, nil
    debug.sethook(function() error('break_word did not end') end, '', 1e7)
    local ok, err = pcall(function() parts = D.break_word('abcdefghijklmnop', 40, 60, 200) done = true end)
    debug.sethook()
    check('UI-2: ends', ok and done, err)
    check('UI-2: every character kept', parts and table.concat(parts) == 'abcdefghijklmnop', parts and table.concat(parts, '|'))
    local plain = D.break_word('abcdefghijklmnop', 40, 60, 0)
    check('UI-2: a normal break unchanged', table.concat(plain) == 'abcdefghijklmnop' and #plain >= 2)
end

---------------------------------------------------------------------------------------------------------------------------
-- 2.0.2: a piece of the game's art that could not be read is never silent. Drawing no longer needs all of
-- it (nui 1.2.10 draws a plain panel without the window frame), so a start that succeeds with something
-- missing has to say so, with the file and the reason, once a session and not on every start.
do
    local log = 'widths from FFXiMain.dll; window art missing (ROM\\0\\19.DAT: newtex 256x256 not 128x128); '
        .. 'moji; window title font; title font; gauge; in C:\\FFXI\\'
    local env = H.load({settings = {visible_on_load = true}, fake = {assets = log}})
    check('ASSETS: a missing piece is said', chat_has(env, 'drawing without some of the game art'))
    check('ASSETS: the file is named', chat_has(env, '19.DAT'))
    check('ASSETS: the reason is named', chat_has(env, '256x256 not 128x128'))
    check('ASSETS: where to report is named', chat_has(env, 'ffxi-chronicle/issues'))
    local n = 0
    for _, l in ipairs(env.chat) do if l:find('drawing without', 1, true) then n = n + 1 end end
    env.cmd('hide') env.cmd('show')
    local n2 = 0
    for _, l in ipairs(env.chat) do if l:find('drawing without', 1, true) then n2 = n2 + 1 end end
    check('ASSETS: said once, not on every start', n == 1 and n2 == 1, n .. '/' .. n2)
end
do
    local clean = 'widths from FFXiMain.dll; window type 6 + win00 recipe; moji; window title font; title font; gauge'
    local env = H.load({settings = {visible_on_load = true}, fake = {assets = clean}})
    check('ASSETS: nothing said when every piece loaded', not chat_has(env, 'drawing without'))
    check('ASSETS: and no report line either', not chat_has(env, 'ffxi-chronicle/issues'))
    env.cmd('status')
    check('ASSETS: status reports the art either way', chat_has(env, 'game art: '))
end

restore()
---------------------------------------------------------------------------------------------------------------------------
-- the run wrote only into its own data folder: the player's data/ is exactly as it was (a killed run or two runs at once can lose
-- nothing, because nothing of theirs is moved)
check('data: the addon writes into the run\'s own folder', windower.chronicle_data_dir == H.DATA_DIR
    and not H.DATA_DIR:find('chronicle%-v2/data', 1) and H.DATA_DIR:find('chronicle_testdata', 1, true) ~= nil)
for _, p in ipairs(REAL) do
    check('data: ' .. p .. ' untouched', (slurp(p) or false) == real_before[p])
end
print(('test_input: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)
