--[[
    test_perf.lua - Chronicle's performance budgets (2026-10-22 perf pass), on the real chronicle.lua + ui/ + core/
    (test/harness.lua's fake Windower) and the real DLL (CR_DLL or libs/_chronicle.dll) through the test host, so every
    N.layer / N.layer_pos is the real parse and build. The game thread waits for Chronicle's mouse, keyboard and packet
    handlers, so the budgets are per handler.

        lua test/test_perf.lua <FFXiMain.dll copy> <folder holding cr_testhost.dll> [--fault <name>]

    Every budget prints its measured value, its limit and a [tag]. --fault <name> puts one piece of the old behaviour back,
    in this test only, and the run must fail on that piece's tag (plugin/test/build_test.sh runs each):

        memo      pages.MEMO = false: every relayout lays the page out          -> [memo] [repaint]
        skip      W.SKIP_SAME = false: unchanged layers are sent again          -> [skip]
        tokens    D.TOKEN_MEMO = false: words measured, a table a word, a layout -> [alloc]
        ops       the old vararg command builder (REF below)                     -> [alloc]
        resize    W.RESIZE_S = 0: a layout every frame of a resize              -> [resize]
        coalesce  W.COALESCE = false: drags and wheel notches inside the event  -> [drag] [wheel]
        bands     W.BANDS = false: every content hit scanned on every move      -> [bands]
        docs      pages.DOCS = 0: a page read and decoded on every open          -> [docs]
        known     pics.KNOWN = false: picture files opened on every layout       -> [known]
        heap      pages.DOCS = 1000: decoded pages kept without a bound          -> [heap]
        slow      memo + skip + tokens + ops + coalesce together                 -> [time]
]]

local copy, hostdir = arg[1], arg[2]
local FAULT = nil
for i = 3, #arg do if arg[i] == '--fault' then FAULT = arg[i + 1] end end
if not (copy and hostdir) then
    print('usage: lua test/test_perf.lua <FFXiMain.dll copy> <folder holding cr_testhost.dll> [--fault name]')
    os.exit(2)
end
package.cpath = './libs/?.dll;' .. hostdir .. '/?.dll;' .. package.cpath
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]

local pass, fail = 0, 0
local function check(tag, name, cond, detail)
    if cond then pass = pass + 1 else
        fail = fail + 1
        print(('FAIL [%s] %s%s'):format(tag, name, detail ~= nil and (': ' .. tostring(detail)) or ''))
    end
end
-- a budget: value against limit (value <= limit), printed either way
local function budget(tag, name, value, limit, unit)
    print(('  %-8s %-62s %10.1f %-3s (limit %s)'):format('[' .. tag .. ']', name, value, unit or '', tostring(limit)))
    check(tag, name, value <= limit, ('%.1f > %s'):format(value, tostring(limit)))
end

package.loadlib(copy, 'luaopen_none')               -- loads and unpacks the FFXiMain copy (the symbol lookup fails)
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()
local T = require('cr_testhost')
check('setup', 'a real D3D8 device', T.make_device() == true)

local H = dofile('test/harness.lua')
-- the user's saved places and page state out of the way, backed up on disk so a killed run loses nothing (H.protect)
local restore = H.protect({'data/places_berrant.lua', 'data/pages_berrant.lua', 'data/places.lua', 'data/pages.lua'})
local env = H.load({native = 'real', settings = {visible_on_load = false}, items = {inventory = {{id = 1012, count = 1}}}})
package.loaded['core/nui'].ffxi_dir = FFXI
env.cmd('show')
env.packets(H.fixture_packets(530))
local app, win, N = env.app, env.win(), env.N
app.updated = '12:00'
if not (win and N and N.us) then
    print('test_perf: the DLL has no us() clock (nui 1.2.0 or later needed) or did not start')
    restore()
    os.exit(1)
end
local us = N.us
local ops = require('ui/ops')
local D = require('ui/doc')
local W = require('ui/window')
local pages = package.loaded['core/pages']
local pics = package.loaded['core/pics']
local mouse = env.events['mouse'][1]
local prerender = env.events['prerender'][1]
local chunk = env.events['incoming chunk'][1]
local function frame() env.advance(1 / 60) prerender() end
local pkt = string.rep('\0', 64)

-- the old command builder (Chronicle's ui/ops.lua before the 2026-10-22 pass): the reference for the text and the 'ops' fault
local REF = {}
do
    local ascii = ops.ascii
    local function hex(c) return string.format('%02X%02X%02X%02X', c[1], c[2], c[3], c[4] or 255) end
    local function num(v)
        if v == math.floor(v) then return tostring(v) end
        return string.format('%.2f', v)
    end
    function REF:add(...)
        local t = {...}
        for i = 2, #t do
            if type(t[i]) == 'number' then t[i] = num(t[i]) end
        end
        self.o[#self.o + 1] = table.concat(t, '\t')
    end
    function REF:win(x, y, w, h, title, active) self:add('W', x, y, w, h, ascii(title or ''), active and '1' or '0') end
    function REF:text(x, y, col, s) s = ascii(s) if s ~= '' then self:add('T', x, y, hex(col), s) end end
    function REF:title(x, y, px, col, s) s = ascii(s) if s ~= '' then self:add('H', x, y, px, hex(col), s) end end
    function REF:rect(x0, y0, x1, y1, col) if x1 > x0 and y1 > y0 then self:add('R', x0, y0, x1, y1, hex(col)) end end
    function REF:quad(tex, x0, y0, x1, y1, u0, v0, u1, v1, col, filter)
        self:add('Q', tex, x0, y0, x1, y1, u0, v0, u1, v1, hex(col or {255, 255, 255}), filter or 1)
    end
    function REF:icon(x, y, size, id, col) self:add('I', x, y, size, id, hex(col or {255, 255, 255})) end
    function REF:gauge(x, y, w, h, frac, col) self:add('G', x, y, w, h, string.format('%.4f', math.max(0, math.min(1, frac))), hex(col)) end
    function REF:clip(x0, y0, x1, y1) self:add('C', x0, y0, x1, y1) end
end
local NEW = {}
for k, v in pairs(ops.B) do NEW[k] = v end
local function use_builder(t) for k, v in pairs(t) do ops.B[k] = v end end

-- the faults
local function apply_fault(f)
    if f == 'memo' or f == 'slow' then pages.MEMO = false end
    if f == 'skip' or f == 'slow' then W.SKIP_SAME = false end
    if f == 'tokens' or f == 'slow' then D.TOKEN_MEMO = false end
    if f == 'ops' or f == 'slow' then use_builder(REF) end
    if f == 'resize' then W.RESIZE_S = 0 end
    if f == 'coalesce' or f == 'slow' then W.COALESCE = false end
    if f == 'bands' then W.BANDS = false end
    if f == 'docs' then pages.DOCS = 0 end
    if f == 'known' then pics.KNOWN = false end
    if f == 'heap' then pages.DOCS = 1000 end
end
if FAULT then print('  fault: ' .. FAULT) end

local function name_of(cat, area, id)
    for _, it in ipairs(app.data.get_area_status(cat, area).items) do if it.id == id then return it.name end end
end
local function size(w, h) win.x, win.y, win.w, win.h = 100, 100, w, h win:invalidate('all') win:flush() end
local function open(p, w, h)
    size(w or 760, h or 960)
    app:entry(p[1], p[2], name_of(p[1], p[2], p[3]), p[3])
    win:flush()
    frame()
end
local A52, C530, S5, J130 = {'mission', 'assault', 52}, {'mission', 'cop', 530}, {'mission', 'sandoria', 5}, {'quest', 'jeuno', 130}

-- the DLL calls per layer
local sent, placed = {0, 0, 0, 0}, {0, 0, 0, 0}
do
    local real_layer, real_pos = N.layer, N.layer_pos
    N.layer = function(id, z, text) if z ~= nil then sent[id] = sent[id] + 1 end return real_layer(id, z, text) end
    N.layer_pos = function(id, ...) placed[id] = placed[id] + 1 return real_pos(id, ...) end
end
local function best(n, fn) local b = math.huge for _ = 1, n do b = math.min(b, fn()) end return b end

---------------------------------------------------------------------------------------------------------------------------
-- 1. The new builder writes the old builder's text, byte for byte: four big pages at three widths (content and chrome), Home,
--    an area list, the settings screen. (Before any fault: it compares the two builders, whatever the run.)
do
    local cases = {}
    for _, p in ipairs({A52, C530, S5, J130}) do
        for _, w in ipairs({480, 760, 1100}) do cases[#cases + 1] = {p[2] .. ' ' .. p[3] .. ' w' .. w, function() open(p, w, 960) end} end
    end
    cases[#cases + 1] = {'home', function() size(620, 760) app:home() win:flush() end}
    cases[#cases + 1] = {'area cop', function() size(760, 960) app:area_list('mission', 'cop') win:flush() end}
    cases[#cases + 1] = {'area jeuno', function() size(480, 960) app:area_list('quest', 'jeuno') win:flush() end}
    local same, bytes = 0, 0
    pages.MEMO = false
    for _, c in ipairs(cases) do
        c[2]()
        for _, part in ipairs({'content', 'chrome'}) do
            local function draw()
                local b = ops.new()
                if part == 'content' then win.S.content(b, win:ctx()) else win.S.chrome(b, win:ctx()) end
                return b:text_out()
            end
            use_builder(REF)
            local a = draw()
            use_builder(NEW)
            local b = draw()
            bytes = bytes + #a
            if a == b then same = same + 1 else check('identity', 'the builder text of ' .. c[1] .. ' ' .. part .. ' equals the old builder\'s', false) end
        end
    end
    pages.MEMO = true
    print(('  [identity] %d drawings, %.1f MB of command text: %d byte-identical to the old builder'):format(#cases * 2, bytes / 1048576, same))
    check('identity', 'every drawing identical', same == #cases * 2, same)
end

apply_fault(FAULT)

---------------------------------------------------------------------------------------------------------------------------
-- 2. A 0x055, the scheduled add-item check and the 0x056 refresh with a big page open: the page is not laid out again, the
--    unchanged content layer is not sent again, and each handler stays within its budget (best of 3 runs of 10).
do
    local worst = 0
    for _, p in ipairs({A52, C530, J130}) do
        open(p) win:scroll_to(520) win:flush() frame()
        chunk(0x055, pkt)       -- a page with pictures: the first one after a scroll may swap pictures for the new view (a real change)
        local m0, s0 = pages.stats.misses, sent[2]
        for _, ev in ipairs({
            {'0x055', function() chunk(0x055, pkt) end},
            {'add item', function() env.fire('add item') env.run_scheduled() end},
            {'refresh', function() env.cmd('refresh') end},
        }) do
            local t = best(3, function()
                local mx = 0
                for _ = 1, 10 do
                    local t0 = us() ev[2]() local d = us() - t0
                    if d > mx then mx = d end
                end
                return mx
            end)
            if t > worst then worst = t end
        end
        check('memo', ('%s %d: 0x055 / add item / refresh lay the page out again'):format(p[2], p[3]), pages.stats.misses == m0, pages.stats.misses - m0)
        check('skip', ('%s %d: 0x055 / add item / refresh send the unchanged content'):format(p[2], p[3]), sent[2] == s0, sent[2] - s0)
    end
    budget('handler', 'worst 0x055 / add item / refresh, big page open (best of 3)', worst, 2500, 'us')
end

---------------------------------------------------------------------------------------------------------------------------
-- 3. A layout of the page body (the memo off): allocation, GC stopped (assault 52 at 760)
do
    open(A52)
    local was = pages.MEMO
    pages.MEMO = false
    win.S.content(ops.new(), win:ctx())            -- the token memo filled (as after the page's first layout)
    collectgarbage('collect') collectgarbage('stop')
    local k0 = collectgarbage('count')
    for _ = 1, 4 do win.S.content(ops.new(), win:ctx()) end
    local kb = (collectgarbage('count') - k0) / 4
    collectgarbage('restart')
    pages.MEMO = was
    budget('alloc', 'KB a layout of assault 52 at 760 (page memo off)', kb, 1400, 'KB')
end

---------------------------------------------------------------------------------------------------------------------------
-- 4. Scrolling a page with pictures: the kept layout is repainted (pictures near the view swapped), never laid out again, and
--    draws what a fresh layout at that place draws
do
    for _, p in ipairs({J130, C530}) do
        open(p) win:scroll_to(0) win:flush() frame()
        local m0, r0 = pages.stats.misses, pages.stats.repaints
        local ok, steps = true, 0
        local y = 0
        while y < (win.content_h or 0) do
            y = y + 300
            win:scroll_to(y) win:flush() frame()
            chunk(0x055, pkt)
            steps = steps + 1
            local kept = win.content_b:text_out()
            if pages.MEMO then
                -- a fresh layout here (the memo off) must draw the same; then the memo as it was (the fresh layout asked the
                -- same textures in the same pass, so the pictures' state is what the memo was made with)
                local cur = pages.current()
                local memo, rects = cur.memo, cur.rects
                pages.MEMO = false
                win:invalidate('content') win:flush()
                if win.content_b:text_out() ~= kept then ok = false end
                pages.MEMO = true
                cur.memo, cur.rects = memo, rects
                m0 = m0 + 1               -- that layout was the test's own
            end
        end
        print(('  [repaint] %s %d: %d scroll stops + 0x055: %d layouts, %d repaints, drawn as a fresh layout: %s'):format(p[2], p[3], steps,
            pages.stats.misses - m0, pages.stats.repaints - r0, tostring(ok)))
        check('repaint', ('%s %d: %d scroll stops + 0x055 draw what a fresh layout draws'):format(p[2], p[3], steps), ok)
        check('memo', ('%s %d: scrolling lays the page out again'):format(p[2], p[3]), pages.stats.misses == m0, pages.stats.misses - m0)
        check('repaint', ('%s %d: pictures repainted while scrolling'):format(p[2], p[3]), pages.stats.repaints > r0 or not pages.MEMO)
    end
end

---------------------------------------------------------------------------------------------------------------------------
-- 5. Resize: a grip move every frame for 2 s re-lays the content out at most every W.RESIZE_S; the release is a cheap event; the
--    next frame lays it out at the final width, the same text as a fresh layout there
do
    open(A52) win:scroll_to(520) win:flush() frame()
    local grip
    for _, h in ipairs(win.chrome_b.hits) do if h.resize == 'xy' then grip = h end end
    local gx, gy = win.x + (grip.x0 + grip.x1) / 2, win.y + (grip.y0 + grip.y1) / 2
    mouse(1, gx, gy, 0, false)
    local ly0, worst = win.stats.layouts, 0
    for i = 1, 120 do
        mouse(0, gx + (i % 30) * 4, gy, 0, false)
        frame()
    end
    local n = win.stats.layouts - ly0
    local t0 = us()
    mouse(2, gx + 4, gy, 0, false)
    local rel = us() - t0
    frame()
    local final = win.content_b:text_out()
    pages.MEMO = false
    win:invalidate('content') win:flush()
    local fresh = win.content_b:text_out()
    if FAULT ~= 'memo' and FAULT ~= 'slow' then pages.MEMO = true end
    budget('resize', 'content layouts over 120 frames of grip moves', n, 24, '')
    budget('resize', 'the release (us)', rel, 3000, 'us')
    check('resize', 'after the release the content is laid out at the final width', final == fresh)
end

---------------------------------------------------------------------------------------------------------------------------
-- 6. Drags: 4 mouse moves a frame for 60 frames. The content / chrome layer is placed once a frame, not once a move, the moves
--    cost next to nothing, and the release leaves the page / window where the last move put it
do
    open(A52) win:scroll_to(0) win:flush() frame()
    local th = win.thumb
    local tx, ty = win.x + (th.x0 + th.x1) / 2, win.y + (th.thumb0 + th.thumb1) / 2
    mouse(1, tx, ty, 0, false)
    local p0, mv = placed[2], 0
    local vh = win.vp.y1 - win.vp.y0
    local last
    for i = 1, 60 do
        for m = 1, 4 do
            local d = (i * 4 + m) % 200
            last = ty + (d < 100 and d or 200 - d) * 2
            local t0 = us()
            mouse(0, tx, last, 0, false)
            mv = math.max(mv, us() - t0)
        end
        frame()
    end
    local track = (th.y1 - th.y0) - (th.thumb1 - th.thumb0)      -- the track the scrollbar drew (review UI-6)
    local want = math.max(0, math.min(0 + (last - ty) * (win.content_h - vh) / track, win.content_h - vh))
    mouse(2, tx, last, 0, false)
    budget('drag', 'thumb drag: content placements over 60 frames of 4 moves', placed[2] - p0, 70, '')
    budget('drag', 'thumb drag: the slowest move (us)', mv, 150, 'us')
    check('drag', 'thumb drag: the page ends where the last move put it', math.abs(win.scroll - want) < 1e-6, win.scroll .. ' ' .. want)

    local ex, ey
    for y = 4, (win.drag_h or 40) - 2, 2 do
        for x = 20, win.w - 20, 7 do if not ex and not win:hit_at(x, y) then ex, ey = win.x + x, win.y + y end end
    end
    local x0, y0 = win.x, win.y
    mouse(1, ex, ey, 0, false)
    p0, mv = placed[1], 0
    local lx, ly
    for i = 1, 60 do
        for m = 1, 4 do
            lx, ly = ex + 10 + (i * 4 + m) % 40, ey + 10 + m
            local t0 = us()
            mouse(0, lx, ly, 0, false)
            mv = math.max(mv, us() - t0)
        end
        frame()
    end
    mouse(2, lx, ly, 0, false)
    budget('drag', 'window drag: chrome placements over 60 frames of 4 moves', placed[1] - p0, 70, '')
    budget('drag', 'window drag: the slowest move (us)', mv, 150, 'us')
    check('drag', 'window drag: the window ends where the last move put it', win.x == x0 + lx - ex and win.y == y0 + ly - ey,
        win.x .. ',' .. win.y)
    win.x, win.y = 100, 100
    win:invalidate('all') win:flush()
end

---------------------------------------------------------------------------------------------------------------------------
-- 7. The wheel: 4 notches a frame for 30 frames. The first notch of a frame is drawn at once, the rest by the frame; the scroll is
--    the one notch-by-notch scrolling gives (each clamped)
do
    open(A52) win:scroll_to(0) win:flush() frame()
    local wx, wy = win.x + win.w / 2, win.y + win.h / 2
    local p0 = placed[2]
    local model = win.scroll
    local vh = win.vp.y1 - win.vp.y0
    local ok = true
    for i = 1, 30 do
        for m = 1, 4 do
            local dir = (i <= 20) and -1 or 1
            mouse(10, wx, wy, dir, false)
            model = math.max(0, math.min(model - dir * 54, math.max(0, win.content_h - vh)))
            if win.scroll ~= model then ok = false end
        end
        frame()
    end
    budget('wheel', 'content placements over 30 frames of 4 notches', placed[2] - p0, 66, '')
    check('wheel', 'the scroll after every notch is the notch-by-notch scroll', ok)
end

---------------------------------------------------------------------------------------------------------------------------
-- 8. The hit test: the banded lookup answers as the scan of every hit does, and a mouse move over the content is cheap
do
    open(A52) win:scroll_to(math.floor(win.content_h / 3)) win:flush() frame()
    local vp, hits = win.vp, win.content_b.hits
    local seed, same, n = 7, 0, 20000
    local bands = W.BANDS
    for _ = 1, n do
        seed = (seed * 1103515245 + 12345) % 2147483648
        local lx = vp.x0 + (seed % ((vp.x1 - vp.x0) * 4)) / 4             -- quarter-pixel points: the view scale makes them fractional
        seed = (seed * 1103515245 + 12345) % 2147483648
        local ly = vp.y0 + (seed % ((vp.y1 - vp.y0) * 4)) / 4
        W.BANDS = bands
        local a = win:hit_at(lx, ly)
        W.BANDS = false                   -- the scan of every hit
        local b = win:hit_at(lx, ly)
        if a == b then same = same + 1 end
    end
    W.BANDS = bands
    check('bands', ('the hit under %d points equals the scan of every hit'):format(n), same == n, same)
    local link
    for _, h in ipairs(hits) do
        local _, y = win:to_win(0, h.y0)
        if h.id == 'link' and y > vp.y0 + 30 and y < vp.y1 - 120 then link = h break end
    end
    local x, y = win:to_win((link.x0 + link.x1) / 2, (link.y0 + link.y1) / 2)
    x, y = win.x + x, win.y + y
    mouse(0, x, y, 0, false)
    local t = best(3, function()
        local t0 = us()
        for i = 1, 2000 do mouse(0, x + (i % 2), y, 0, false) end
        return (us() - t0) / 2000
    end)
    budget('bands', 'a mouse move over a link, the same hit (us, best of 3)', t, 10, 'us')
end

---------------------------------------------------------------------------------------------------------------------------
-- 9. Decoded pages kept: back to a page opened two pages ago reads and decodes nothing
do
    local reads = 0
    local real_loadfile = loadfile
    loadfile = function(path, ...)
        -- core/pages.lua's own reads (core/meta.lua reads page headers when an area's metadata loads: not the page open)
        local src = debug.getinfo(2, 'S').source or ''
        if type(path) == 'string' and path:find('pages[/\\]') and src:find('core[/\\]pages') then reads = reads + 1 end
        return real_loadfile(path, ...)
    end
    open(A52) open(C530) open(S5)
    local r0 = reads
    open(A52)
    loadfile = real_loadfile
    check('docs', 'opening assault 52 again (kept) reads its page file', reads == r0, reads - r0)
end

---------------------------------------------------------------------------------------------------------------------------
-- 10. Picture files: a layout after the first one opens none of them
do
    open(J130)
    local opens = 0
    local real_open = io.open
    io.open = function(path, ...)
        if type(path) == 'string' and path:find('data[/\\]pics[/\\]') then opens = opens + 1 end
        return real_open(path, ...)
    end
    local was = pages.MEMO
    pages.MEMO = false
    for _ = 1, 3 do win:invalidate('content') win:flush() end
    pages.MEMO = was
    io.open = real_open
    budget('known', 'picture files opened by 3 layouts of jeuno 130', opens, 0, '')
end

---------------------------------------------------------------------------------------------------------------------------
-- 11. The heap: what a page open keeps, and what twelve more pages and Home leave (full collects)
do
    size(760, 960)
    app:home() win:flush()
    collectgarbage('collect') collectgarbage('collect')
    local home = collectgarbage('count')
    open(A52)
    collectgarbage('collect') collectgarbage('collect')
    local page = collectgarbage('count')
    local index = dofile('pages/index.lua')
    local keys = {}
    for k in pairs(index) do keys[#keys + 1] = k end
    table.sort(keys)
    for i = 1, #keys, math.floor(#keys / 24) do
        local cat, area, id = keys[i]:match('^(%a+)|([%w_]+)|(%d+)$')
        id = tonumber(id)
        local nm = name_of(cat, area, id)
        if nm then app:entry(cat, area, nm, id) win:flush() end
    end
    app:home() win:flush()
    collectgarbage('collect') collectgarbage('collect')
    local after = collectgarbage('count')
    print(('  heap: Home %.0f KB, assault 52 open %.0f KB, Home after 24 more pages %.0f KB'):format(home, page, after))
    budget('heap', 'KB kept by a big page while it is open (assault 52)', page - home, 2500, 'KB')
    budget('heap', 'decoded pages kept after 24 more pages', pages.kept(), 3, '')

end

---------------------------------------------------------------------------------------------------------------------------
-- 12. A session (GC running, as in game): open a page, wheel through it a notch every 4 frames, hover links, a 0x055 and a bag
--     change; the worst waited handler other than the page opens (best of 3 sessions)
do
    local function session()
        local worst = 0
        local function rec(fn)
            local t0 = us()
            fn()
            local d = us() - t0
            if d > worst then worst = d end
        end
        for _, p in ipairs({A52, C530}) do
            open(p) win:scroll_to(0) win:flush()
            for _ = 1, 10 do frame() end
            local wx, wy = win.x + win.w / 2, win.y + win.h / 2
            for _ = 1, 15 do rec(function() mouse(10, wx, wy, -1, false) end) for _ = 1, 4 do frame() end end
            local links = {}
            for _, h in ipairs(win.content_b.hits) do
                local _, y = win:to_win(0, h.y0)
                if h.id == 'link' and y > win.vp.y0 + 20 and y < win.vp.y1 - 80 then links[#links + 1] = h end
            end
            for i = 1, math.min(#links, 15) do
                local x, y = win:to_win((links[i].x0 + links[i].x1) / 2, (links[i].y0 + links[i].y1) / 2)
                rec(function() mouse(0, win.x + x, win.y + y, 0, false) end)
                frame()
            end
            rec(function() chunk(0x055, pkt) end)
            for _ = 1, 30 do frame() end
            rec(function() env.fire('add item') env.run_scheduled() end)
            for _ = 1, 30 do frame() end
        end
        return worst
    end
    budget('time', 'worst waited handler in a session, page opens aside (us, best of 3)', best(3, session), 2500, 'us')
end

N.stop()
restore()
print(('test_perf: %d passed, %d failed%s'):format(pass, fail, FAULT and (' (fault ' .. FAULT .. ')') or ''))
os.exit(fail == 0 and 0 or 1)
