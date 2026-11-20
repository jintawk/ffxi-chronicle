--[[
    test/qa_render.lua - the pixel half of Chronicle's page QA (the page QA tool is the other
    half). Draws every walkthrough page in pages/index.lua, and a fixed set of screens, through the
    real _chronicle.dll on a real D3D8 device and the patched EndScene wrapper of a FFXiMain.dll copy
    (as test_e2e.lua): what it writes are the game's own frames.

    For each page / screen, window size (minimum, medium, large), open tab, and scroll position (top
    to bottom, one viewport less 36 px at a time):
      <shot>.full.raw     the window as the game draws it, over a flat background
      <shot>.content.raw  the same frame with only the content layer (no frame, header or overlay)
    and manifest.json: each shot's rectangles and the text lines the layout put in view, so qa.py can
    check that every pixel of the page stays in its viewport and every line in view has ink.

        lua test/qa_render.lua <FFXiMain.dll copy> <dir with cr_testhost.dll> <out dir> [page key]

    Which pages and screens (the frame chooser chooses; the frames of a page do not depend on which
    others are drawn in the same run):
      no page key, no env     every page and every screen
      page key                that page only, no screens
      CR_QA_PAGES_FILE=<f>    the page keys listed in f (one per line; empty file = no pages), and the screens
                              unless CR_QA_SCREENS=0
      CR_QA_SCREENS=1 | 0     screens in or out, whatever the pages
    manifest.json also lists "pages" (the keys drawn) and "screens" (whether they were), so qa.py approves exactly
    what this run rendered.

    The screens include a link hovered on a page at each window size (tip_*, rule 206): the tooltip's text is drawn alone on the real
    device and any ink outside its box stops the render, so the widths the layout measured are checked against what the DLL drew.
]]

local copy, hostdir, out, only = arg[1], arg[2], arg[3], arg[4]
package.cpath = './libs/?.dll;' .. hostdir .. '/?.dll;' .. package.cpath
local FFXI = [[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]]
local BG = 0x203040

package.loadlib(copy, 'luaopen_none')
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()      -- CR_DLL: a build other than libs/_chronicle.dll
local T = require('cr_testhost')
assert(T.make_device())

local H = dofile('test/harness.lua')
local KEEP = {'data/places.lua', 'data/pages.lua'}
local restore_data = H.protect(KEEP)   -- the run's own data folder; the player's data/ is never touched

-- CR_NOSHARE=1: the same frames with the shared texture cache off (each texture this module's own)
local env = H.load({native = 'real', settings = {visible_on_load = false, share_textures = os.getenv('CR_NOSHARE') ~= '1'},
    items = {inventory = {{id = 1012, count = 1}}}})
package.loaded['core/nui'].ffxi_dir = FFXI
env.cmd('show')
env.packets(H.fixture_packets(530))
H.feed_roe(env)                 -- the Records tab's three packets, the same state every run
local app, win, N = env.app, env.win(), env.N
local ops = require('ui/ops')
local site = N.status().site
env.fire('mouse', 0, 3, 3, 0, false)              -- no hover anywhere

local SIZES = {{'min', 480, 480}, {'mid', 760, 960}, {'max', 1100, 1500}}
local X, Y = 100, 100

local shots = {}

local function json_str(s)
    return '"' .. tostring(s):gsub('[%c"\\]', function(c) return string.format('\\u%04x', c:byte()) end) .. '"'
end

-- the text lines of the content in view, relative to the dump's origin
local function visible_text(rx0, ry0)
    local vp = win.vp
    local items = {}
    if not (win.content_b and vp) then return items end
    for _, line in ipairs(win.content_b.o) do
        if line:sub(1, 1) == 'T' then
            local x, y, s = line:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
            x, y = tonumber(x), tonumber(y)
            local wx, wy = vp.x0 + x, vp.y0 + y - win.scroll
            if wy >= vp.y0 and wy + 16 <= vp.y1 then
                local _, chars = s:gsub('%S', '')
                items[#items + 1] = ('[%d,%d,%d,%d]'):format(win.x + wx - rx0, win.y + wy - ry0, ops.text_w(s), chars)
            end
        end
    end
    return items
end

-- CR_QA_FAULT (qa_selftest.sh only): break one thing, so the checks are seen to catch it
local FAULT = os.getenv('CR_QA_FAULT')
package.loaded['core/pics'].refetch_disabled = true      -- CORE-3's refetch would delete the cached file and read as 'loading': the harness keeps the failed path
if FAULT == 'nogif' then package.loaded['core/pics'].NO_GIF = true end     -- the renderer given a GIF as it is: the check for a picture that cannot be shown
if FAULT == 'tipfit' then       -- every tooltip's box 40 px short (the icon's width left out of it): the check for text outside its box
    local kit = package.loaded['ui/kit']
    local real = kit.tooltip
    kit.tooltip = function(b, ...)
        local r = real(b, ...)
        for i = #b.o, 1, -1 do
            local head, w, tail = b.o[i]:match('^(W\t[%-%d%.]+\t[%-%d%.]+\t)([%-%d%.]+)(.*)$')
            if head then b.o[i] = head .. (tonumber(w) - 40) .. tail break end
        end
        return r
    end
end

-- a picture quad in view names a texture the page still holds (core/pics.lua frees textures a layout does not ask for: a quad that
-- names a freed one draws a flat olive square; jeuno 130, 2026-10-20). Stops the render on the first one: its frame would be wrong.
local pics_mod = package.loaded['core/pics']
local function check_textures(name)
    if not (name:find('^page_') and win.content_b and win.vp) then return end       -- a screen's quads are its own art (emblems, the atlas)
    local vh = win.vp.y1 - win.vp.y0
    for _, line in ipairs(win.content_b.o) do
        local tex, y0, y1 = line:match('^Q	(%d+)	[%-%d%.]+	([%-%d%.]+)	[%-%d%.]+	([%-%d%.]+)')
        if tex and tonumber(y1) >= win.scroll and tonumber(y0) <= win.scroll + vh and not pics_mod.live(tonumber(tex)) then
            io.stderr:write(('qa_render: %s draws a picture with texture %s, which is not held (a blank frame)' .. string.char(10)):format(name, tex))
            os.exit(1)
        end
    end
end

-- a picture of the page the renderer could not decode (or that never arrived) is drawn as a "failed" box of another height than the
-- picture's: the reader never sees it and the page's height moves under the scroll (rule 79, 2026-10-21: adoulin 280's two GIFs, which
-- the renderer does not read). Stops the render, as check_textures does.
local function check_pictures(name)
    if not (name:find('^page_') and win.content_b) then return end
    local bad = pics_mod.failed()
    for _, f in ipairs(pics_mod.loading()) do bad[#bad + 1] = f .. ' (still loading)' end      -- no downloads run here
    if #bad > 0 then
        io.stderr:write(('qa_render: %s has a picture that cannot be shown (not decoded, or not fetched): %s' .. string.char(10)):format(name, table.concat(bad, ', ')))
        os.exit(1)
    end
end

local function shoot(name)
    check_textures(name)
    check_pictures(name)
    if FAULT == 'bleed' and win.content_b then
        N.layer_pos(2, win.x + win.vp.x0, win.y + win.vp.y0 - win.scroll)     -- no clip
    elseif FAULT == 'ink' and win.vp then
        N.layer(5, 9, ('R	%d	%d	%d	%d	203040FF'):format(win.x + win.vp.x0, win.y + win.vp.y0 + 40,
            win.x + win.vp.x1, win.y + win.vp.y0 + 60))
        N.layer_pos(5, 0, 0)
    elseif FAULT == 'showthrough' and win.vp then
        N.layer(5, 9, ('R	%d	%d	%d	%d	08101880'):format(win.x + win.vp.x0, win.y + win.vp.y0 + 80,
            win.x + win.vp.x1, win.y + win.vp.y0 + 120))
        N.layer_pos(5, 0, 0)
        win.overlay_b.o[#win.overlay_b.o + 1] = ('R	%d	%d	%d	%d	081018FF'):format(win.vp.x0, win.vp.y0 + 80, win.vp.x1, win.vp.y0 + 120)
    elseif FAULT == 'outside' then
        N.layer(5, 9, ('R	%d	%d	%d	%d	FF0000FF'):format(win.x + win.w + 20, win.y, win.x + win.w + 24, win.y + 4))
        N.layer_pos(5, 0, 0)
    end
    local rx0, ry0 = win.x - 8, win.y - 8
    local rx1, ry1 = win.x + win.w + 8, win.y + (win.collapsed and 46 or win.h) + 8
    local file = out .. '/' .. name
    T.fill(BG) T.frame(site)
    T.dump_rect(file .. '.full.raw', rx0, ry0, rx1, ry1)
    -- anything on the whole screen outside the window (the title on the top rule may sit 6 px above)
    local sn, sx0, sy0, sx1, sy1 = T.stray(BG, win.x - 1, win.y - 6, win.x + win.w + 1, win.y + (win.collapsed and 46 or win.h) + 1)
    -- everything but the content: inside whatever the overlay draws to cover the page (sticky
    -- bars, tooltips: rectangles at least 200/255 opaque, and windows), this must equal the full frame
    local covers = {}
    if win.overlay_b then
        for _, line in ipairs(win.overlay_b.o) do
            local k = line:sub(1, 1)
            if k == 'R' then
                local x0, y0, x1, y1, a = line:match('^R	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	%x%x%x%x%x%x(%x%x)')
                if a and tonumber(a, 16) >= 200 and (y1 - y0) >= 12 and (x1 - x0) >= 40 then
                    covers[#covers + 1] = ('[%d,%d,%d,%d]'):format(win.x + x0 - rx0, win.y + y0 - ry0, win.x + x1 - rx0, win.y + y1 - ry0)
                end
            elseif k == 'W' then
                local x, y, w, h = line:match('^W	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)')
                covers[#covers + 1] = ('[%d,%d,%d,%d]'):format(win.x + x + 6 - rx0, win.y + y + 6 - ry0, win.x + x + w - 6 - rx0, win.y + y + h - 6 - ry0)
            end
        end
    end
    N.layer(2)
    T.fill(BG) T.frame(site)
    T.dump_rect(file .. '.nocontent.raw', rx0, ry0, rx1, ry1)
    win:invalidate('content')
    win:flush()
    if FAULT == 'bleed' and win.content_b then        -- the re-send above restored the clip
        N.layer_pos(2, win.x + win.vp.x0, win.y + win.vp.y0 - win.scroll)
    end
    -- only the content layer: drop the chrome and overlay for one frame
    N.layer(1) N.layer(3)
    T.fill(BG) T.frame(site)
    T.dump_rect(file .. '.content.raw', rx0, ry0, rx1, ry1)
    win.dirty.chrome = true
    win:flush()
    local vp = win.vp or {x0 = 0, y0 = 0, x1 = 0, y1 = 0}
    shots[#shots + 1] = ('{"name":%s,"stray":[%d,%d,%d,%d,%d],"w":%d,"h":%d,"win":[%d,%d,%d,%d],"vp":[%d,%d,%d,%d],"scroll":%d,"content_h":%d,"covers":[%s],"text":[%s]}')
        :format(json_str(name), sn, sx0, sy0, sx1, sy1, rx1 - rx0, ry1 - ry0, win.x - rx0, win.y - ry0, win.x + win.w - rx0,
            win.y + win.h - ry0, win.x + vp.x0 - rx0, win.y + vp.y0 - ry0, win.x + vp.x1 - rx0, win.y + vp.y1 - ry0,
            win.scroll, win.content_h or 0, table.concat(covers, ','), table.concat(visible_text(rx0, ry0), ','))
end

-- every scroll position, top to bottom
local function scroll_through(base)
    local vh = win.vp and (win.vp.y1 - win.vp.y0) or 0
    local max = math.max(0, (win.content_h or 0) - vh)
    local y, n = 0, 0
    while true do
        win:scroll_to(y) win:flush()
        shoot(('%s.s%02d'):format(base, n))
        n = n + 1
        if y >= max then break end
        y = math.min(max, y + vh - 36)
        if FAULT == 'coverage' and n == 1 then y = math.min(max, y + vh) end     -- skips a viewport
    end
end

local function sized(label, open, tabs)
    for _, sz in ipairs(SIZES) do
        win.x, win.y, win.w, win.h = X, Y, sz[2], sz[3]
        win:invalidate('all')
        open()
        win.x, win.y, win.w, win.h = X, Y, sz[2], sz[3]
        win:invalidate('all') win:flush()
        if tabs then
            tabs(function(tag) scroll_through(('%s.%s.%s'):format(label, sz[1], tag)) end)
        else
            scroll_through(('%s.%s'):format(label, sz[1]))
        end
    end
end

local pages = package.loaded['core/pages']

-- which pages and screens this run draws (see the header)
local wanted
if os.getenv('CR_QA_PAGES_FILE') then
    wanted = {}
    for line in io.lines(os.getenv('CR_QA_PAGES_FILE')) do
        line = line:gsub('%s+$', '')
        if line ~= '' then wanted[line] = true end
    end
end
local with_screens
if os.getenv('CR_QA_SCREENS') then with_screens = os.getenv('CR_QA_SCREENS') == '1'
else with_screens = not only and not wanted end
local drawn = {}

-- every page: every tab of every group (the others on their first)
-- CR_QA_INDEX: another index (the vision calibration: known-bad pages under real entries' keys)
local index = dofile(os.getenv('CR_QA_INDEX') or 'pages/index.lua')
if os.getenv('CR_QA_INDEX') then pages.set_index(index) end
local keys = {}
for k in pairs(index) do keys[#keys + 1] = k end
table.sort(keys)
if wanted then
    local have = {}
    for _, k in ipairs(keys) do have[k] = true end
    for k in pairs(wanted) do
        if not have[k] then error('CR_QA_PAGES_FILE lists a page the index does not have: ' .. k, 0) end
    end
end
local unlisted = {}
for _, key in ipairs(keys) do
    if (not only and not wanted or only == key) or (wanted and wanted[key]) then
        drawn[#drawn + 1] = key
        local cat, area, id = key:match('^(%a+)|([%w_]+)|(%d+)$')
        id = tonumber(id)
        local label = ('page_%s_%s_%d'):format(cat, area, id)
        local name
        for _, it in ipairs(app.data.get_area_status(cat, area).items) do if it.id == id then name = it.name end end
        -- rule 104: a page of an entry Chronicle does not list is a data fault; say so and go on drawing (it used to crash the chunk and
        -- leave the pages after it undrawn), the run fails at the end
        if not name then unlisted[#unlisted + 1] = key end
        if name then sized(label, function() app:entry(cat, area, name, id) end, function(each)
            -- the groups and their tab counts, from the page as drawn
            local groups = {}
            for _, h in ipairs(win.content_b.hits) do
                if h.id == 'tab' then groups[h.group] = math.max(groups[h.group] or 0, h.i) end
            end
            each('t1')
            for g, n in pairs(groups) do
                for i = 2, n do
                    pages.set_tab(g, i)
                    each(('g%dt%d'):format(g, i))
                end
                pages.set_tab(g, 1)
            end
        end) end
    end
end

-- the screens around the pages
-- rule 206: the hovered tooltip's text on its own, on the real device: no ink outside the box less its frame. Stops the render, as
-- check_textures does. f: the view scale of the check (a Lua unit is f pixels).
local tooltip_fit = dofile('test/tooltip_fit.lua')
local function check_tooltip_ink(name, f)
    local o = win.overlay_b and win.overlay_b.o or {}
    local start
    for i, line in ipairs(o) do if line:sub(1, 1) == 'W' then start = i end end
    if not start then
        io.stderr:write(('qa_render: %s hovers a link and no tooltip was drawn' .. string.char(10)):format(name))
        os.exit(1)
    end
    local x, y, w, h = o[start]:match('^W\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)')
    x, y, w, h = tonumber(x), tonumber(y), tonumber(w), tonumber(h)
    local rows = {}
    for i = start + 1, #o do
        if not o[i]:match('^[THI]\t') then break end
        rows[#rows + 1] = o[i]
    end
    N.layer(1) N.layer(2) N.layer(3)
    N.layer(5, 9, table.concat(rows, string.char(10)))
    N.layer_pos(5, win.x, win.y)
    T.fill(BG) T.frame(site)
    local m = tooltip_fit.FRAME
    local n, sx0, sy0, sx1, sy1 = T.stray(BG, math.floor((win.x + x + m) * f), math.floor((win.y + y + m) * f),
        math.ceil((win.x + x + w - m - tooltip_fit.ROOM) * f), math.ceil((win.y + y + h - m) * f))
    local ink = T.stray(BG, 0, 0, 0, 0)         -- no text at all would pass the line below
    N.layer(5)
    win:invalidate('all') win:flush()
    if ink == 0 then
        io.stderr:write(('qa_render: %s drew a tooltip with no ink' .. string.char(10)):format(name))
        os.exit(1)
    end
    if n > 0 then
        io.stderr:write(('qa_render: %s has tooltip text outside its box: %d px, %d,%d to %d,%d' .. string.char(10)):format(name, n, sx0, sy0, sx1, sy1))
        os.exit(1)
    end
end

local nui = package.loaded['core/nui']
-- a link hovered at a window size: the first one `pick` likes
local function hover_link(cat, area, id, pick, sz)
    local name
    for _, it in ipairs(app.data.get_area_status(cat, area).items) do if it.id == id then name = it.name end end
    win.x, win.y, win.w, win.h = X, Y, sz[2], sz[3]
    win:invalidate('all')
    app:entry(cat, area, name, id)
    win.x, win.y, win.w, win.h = X, Y, sz[2], sz[3]
    win:invalidate('all') win:flush()
    local hit
    for _, h in ipairs(win.content_b.hits) do
        if h.id == 'link' and pick(h.span) then hit = h break end
    end
    assert(hit, 'qa_render: no such link on ' .. tostring(name))
    win:scroll_to(math.max(0, hit.y0 - 40)) win:flush()
    local x, y = win:to_win((hit.x0 + hit.x1) / 2, (hit.y0 + hit.y1) / 2)
    env.fire('mouse', 0, (win.x + x) * nui.view.f, (win.y + y) * nui.view.f, 0, false)
    win:flush()
end
local function unhover()
    env.fire('mouse', 0, 3, 3, 0, false)
    win:invalidate('all') win:flush()
end
local TIPS = {
    {'tip_item', 'quest', 'sandoria', 109, function(sp) return sp.kind == 'item' and sp.id and sp.s == 'Treasury Gold' end},
    {'tip_npc', 'quest', 'sandoria', 109, function(sp) return sp.kind == 'npc' end},
    {'tip_url', 'quest', 'toau', 72, function(sp) return tostring(sp.to):find('^https?:') end},
}

if with_screens then
    for _, tip in ipairs(TIPS) do
        for _, sz in ipairs(SIZES) do
            hover_link(tip[2], tip[3], tip[4], tip[5], sz)
            local name = ('%s.%s.s00'):format(tip[1], sz[1])
            check_tooltip_ink(name, 1)
            shoot(name)
            unhover()
        end
    end
    -- the same check at the game's UI scales (a Lua unit is f pixels): no frames, the box and its text only have to scale together
    local sw, sh = nui.screen_px()
    for _, k in ipairs({1.5, 2}) do
        nui.set_scale('sim', sw / k, sh / k)
        for _, tip in ipairs(TIPS) do
            hover_link(tip[2], tip[3], tip[4], tip[5], SIZES[1])
            check_tooltip_ink(('%s at scale %g'):format(tip[1], k), nui.view.f)
            unhover()
        end
    end
    nui.set_scale('one')
    win:invalidate('all') win:flush()
    sized('home_missions', function() app.settings.active_tab = 'mission' app:home() end)
    sized('home_quests', function() app.settings.active_tab = 'quest' app:home() end)
    app.settings.active_tab = 'mission'
    sized('area_cop', function() app:area_list('mission', 'cop') end)
    sized('area_campaign', function() app:area_list('mission', 'campaign') end)
    sized('guide_nopage', function() app:entry('mission', 'toau', "Sentinel's Honor") end)
    sized('guide_reqs', function() app:entry('quest', 'jeuno', 'Fistful of Fury') end)
    sized('settings', function() app:go('settings', {}, 0) end)

    -- Records of Eminence: the four screens of the third tab. The ids are fixed so the frames
    -- are: 1 is completed, 16 is a counter the server is reporting, 1313 wraps a mission
    -- Chronicle documents, 11 is locked behind a record the fixture has not completed.
    app.settings.active_tab = 'records'
    sized('home_records', function() app.settings.active_tab = 'records' app:home() end)
    sized('records_cat', function() app:roe_cat(1) end)
    sized('records_sub', function() app:roe_sub(1, 1) end)
    -- the longest list in the tab, for a screen of nothing but rows
    local big_ci, big_si, big_n = 1, 1, 0
    for ci, c in ipairs(app.roe.index().cats) do
        for si, sub in ipairs(c.subs) do
            if #sub.o > big_n then big_ci, big_si, big_n = ci, si, #sub.o end
        end
    end
    sized('records_sub_big', function() app:roe_sub(big_ci, big_si) end)
    -- a list carrying both kinds of record: the two Tutorial lists above are all one-shot,
    -- so without this the repeatable mark has no frame of its own
    sized('records_sub_rep', function() app:roe_sub(3, 1) end)
    sized('records_obj', function() app:roe_objective(1) end)
    sized('records_obj_counter', function() app:roe_objective(16) end)
    sized('records_obj_link', function() app:roe_objective(1313) end)
    sized('records_obj_locked', function() app:roe_objective(11) end)
    app.settings.active_tab = 'mission'
end

local f = assert(io.open(out .. '/manifest.json', 'w'))
f:write('{"shots":[\n', table.concat(shots, ',\n'), '\n]}\n')
f:close()
local cache = N.status().cache or {}
N.stop()
restore_data()
print(('qa_render: %d shots (texture cache %s: %s shared, %s own textures)'):format(#shots,
    cache.shared and 'shared' or ('private, ' .. tostring(cache.why)), tostring(cache.shared_textures),
    tostring(cache.private_textures)))
if #unlisted > 0 then
    io.stderr:write('qa_render: ' .. #unlisted .. ' page(s) of entries Chronicle does not list, not drawn: ' .. table.concat(unlisted, ' ') .. '\n')
    os.exit(1)
end
