--[[
    Chronicle: walkthrough pages, one entry at a time.

    pages/index.lua lists the entries that have a page ({['mission|cop|530'] = 'pages/missions/cop/530.lua'},
    written by the page converter). A page is read and decoded when its guide opens and
    dropped when it closes, so only the open entry's tables live in the heap; its pictures are
    released with it (core/pics.lua).

    Tabs: each tab group remembers the active tab and every tab its own scroll position, per entry,
    in data/pages_<character>.lua. A link to one of the page's own paths switches tab; a mission or quest link
    opens in Chronicle when Chronicle lists it; everything else opens BG-wiki in the browser.

        pages.attach(app, win, native, dir)
        pages.open(params) -> true if the entry has a page     pages.close()
        pages.tick(now)  pages.restyle()  pages.status()

    Performance (2026-10-22 pass; test/test_perf.lua holds the budgets):
      - the page-body memo: the walkthrough's drawing is kept and reused while nothing it is drawn from changed (memo_key
        below). A 0x055, a bag change or the 0x056 refresh lay the guide out again but no longer the page under it.
      - the last DOCS decoded pages are kept: back and forth between entries skips the read and the decode (about 250 KB a big
        page, so at most DOCS of them).
]]

local D = require('ui/doc')
local ops = require('ui/ops')
local pics = require('core/pics')
local card = require('core/card')
local fsave = require('core/fsave')

local pages = {}

local WIKI = 'https://www.bg-wiki.com/ffxi/'
local STATE_FILE = 'data/pages.lua'     -- the old shared file: read for a character with no file of its own

local app, win, N, dir = nil, nil, nil, ''
local index = nil
local cur = nil         -- {key, doc, tabs = {[group] = i}, scroll = {page = y}, names, strip = {[group] = y}}
local by_title = nil     -- the record pages by wiki title (pages.record_by_title)
local saved = nil       -- data/pages.lua

local function read(rel)
    local f = loadfile(dir .. rel)
    if not f then return nil end
    local ok, t = pcall(f)
    return ok and type(t) == 'table' and t or nil
end

-- The last DOCS decoded pages, most recent first ({path, doc}). The layout reads a doc and writes only two flags it sets afresh on
-- every layout before reading them (a heading's pic_next, a floated run's clear), so a kept doc lays out as a fresh decode does.
pages.DOCS = 3
local docs = {}
local function decoded(path)
    for i, e in ipairs(docs) do
        if e.path == path then
            table.remove(docs, i)
            table.insert(docs, 1, e)
            return e.doc
        end
    end
    local mk = read(path)
    if not mk or type(mk.body) ~= 'string' then return nil end
    local doc = D.decode(mk)
    table.insert(docs, 1, {path = path, doc = doc})
    while #docs > math.max(0, pages.DOCS) do table.remove(docs) end
    return doc
end

-- A value as a string that two equal values share: tables by sorted keys (the memo key below). A table nested deeper than 6, or met
-- again inside itself, is named by its identity (a key that can only miss more often, never one that hits wrongly).
local function ser(v, out, depth, seen)
    local t = type(v)
    if t == 'string' then
        out[#out + 1] = ('%q'):format(v)
    elseif t == 'table' then
        if depth > 6 or seen[v] then out[#out + 1] = tostring(v) return end
        seen[v] = true
        local ks = {}
        for k in pairs(v) do ks[#ks + 1] = k end
        if #ks > 1 then
            table.sort(ks, function(a, c)
                local ta, tc = type(a), type(c)
                if ta ~= tc then return ta < tc end
                if ta == 'number' or ta == 'string' then return a < c end
                return tostring(a) < tostring(c)
            end)
        end
        out[#out + 1] = '{'
        for _, k in ipairs(ks) do
            ser(k, out, depth + 1, seen)
            out[#out + 1] = '='
            ser(v[k], out, depth + 1, seen)
            out[#out + 1] = ','
        end
        out[#out + 1] = '}'
        seen[v] = nil
    else
        out[#out + 1] = t:sub(1, 1) .. tostring(v)      -- a number, a boolean; a function or userdata by its identity
    end
end

-- The page-body memo's key: everything D.draw's output depends on except the pictures (their answers: pics.rev; which of them are
-- near the view: same_near) and the document (the memo lives on cur, one per open page). Every field of D.draw's opts is in it but
-- pics, view and pic_rects, so a field added to opts later (the quest-progress branch's opts.progress) joins the key with no change
-- here, as long as it is plain data (tables of strings, numbers, booleans; a function in it is keyed by identity, so a fresh closure
-- per layout only misses). Plus the place (y) and width, D's rules and the font metrics (D.rules_rev). IF YOU ADD AN INPUT TO THE
-- WALKTHROUGH'S LAYOUT THAT IS NOT IN opts (a global D.draw reads, a field of ctx), ADD IT HERE.
local SKIP_OPTS = {pics = true, view = true, pic_rects = true}
local function memo_key(opts, y, w)
    local out = {tostring(y), tostring(w), tostring(D.rules_rev())}
    local ks = {}
    for k in pairs(opts) do if not SKIP_OPTS[k] then ks[#ks + 1] = k end end
    table.sort(ks)
    for _, k in ipairs(ks) do
        out[#out + 1] = k
        ser(opts[k], out, 0, {})
    end
    return table.concat(out, '|')
end

-- the pictures a layout asked a texture for are the ones near the view now (D.draw's near(); r.asked is what it answered then)
local function same_near(rects, view)
    for i = 1, #rects do
        local r = rects[i]
        if (r.y1 >= view.y0 and r.y0 <= view.y1) ~= (r.asked and true or false) then return false end
    end
    return true
end

-- After a layout: where each picture's one view-dependent command (D.pic_line) is in the memo's drawing (r.idx). false when that
-- cannot be told for certain (a command that is not what D.pic_line makes for it, the same text twice, the tests' TEX_DIMS fault
-- whose sizes follow the textures held): then the memo is reused only for the very same pictures near the view.
local function index_pictures(mo, rects)
    if #rects == 0 then return true end
    if pics.TEX_DIMS then return false end
    local by_line = {}
    for _, r in ipairs(rects) do
        if not r.line or by_line[r.line] or D.pic_line(r, r.tex) ~= r.line then return false end
        by_line[r.line] = r
    end
    local found = 0
    for i = 1, #mo do
        local r = by_line[mo[i]]
        if r then
            if r.idx then return false end
            r.idx = i
            found = found + 1
        end
    end
    return found == #rects
end

-- The kept drawing for another view: what a layout at this view would draw, as it would draw it. The layout's only view-dependent
-- commands are the pictures' (a quad when near the view and its texture is had, else the dark rect), and it asks pics.get for a
-- texture for each picture near the view, in the order of the page; nothing else it asks depends on the view or changes the
-- pictures' state (pics.rev is unchanged, or the memo is not used). So the same asks in the same order, inside a pass, give the same
-- textures held and freed, and the same commands.
local function repaint(m, view)
    pics.begin_pass()
    for _, r in ipairs(m.rects) do
        local near = r.y1 >= view.y0 and r.y0 <= view.y1
        local t = near and pics.get(r.file) or nil
        local line = D.pic_line(r, t)
        m.o[r.idx] = line
        r.line, r.asked = line, near
        r.tex = type(t) == 'table' and t.h and {h = t.h, w = t.w, h_px = t.h_px} or nil
    end
    pics.end_pass()
    m.rev = pics.rev
end

pages.MEMO = true       -- false: lay the page out every time (the behaviour before; test/test_perf.lua's fault run)
pages.stats = {hits = 0, repaints = 0, misses = 0}

function pages.url(title)
    local t = title:gsub(' ', '_'):gsub("[^%w_%-%.~'%(%):,!]", function(c)
        return string.format('%%%02X', c:byte())
    end)
    return WIKI .. t
end

-- where a click on a link goes in the browser: an http(s) address as it is, a wiki title under the BG-wiki base
function pages.link_url(sp)
    local to = sp.to or sp.s
    if to:find('^https?://') then return to end
    return pages.url(to)
end

function pages.key(p)
    return (p.cat or '') .. '|' .. tostring(p.area) .. '|' .. tostring(p.id or p.name)
end

-- The page state is one file per character, saved through a temp file and a rename (review CORE-12: one shared file, read once
-- a session and rewritten whole, so every save erased what the other clients had saved). A character with no file of its own yet
-- starts from the old shared data/pages.lua, which is never rewritten.
local function who()
    local p = windower and windower.ffxi and windower.ffxi.get_player and windower.ffxi.get_player()
    return p and p.name and p.name:lower() or 'global'
end
local function state_file(name) return ('data/pages_%s.lua'):format(name:gsub('[^%w_%-]', '_')) end
pages.state_file = function() return state_file(who()) end

local function read_state(path)
    local f = io.open(path, 'r')
    if not f then return nil end
    local fn = loadstring(f:read('*a'))
    f:close()
    if fn then
        setfenv(fn, {})
        local ok, t = pcall(fn)
        if ok and type(t) == 'table' then return t end
    end
    return {}
end

local saved_for = nil   -- the character `saved` belongs to
local function load_saved()
    local name = who()
    if saved and saved_for == name then return saved end
    saved_for = name
    local d = fsave.data_dir(dir)
    saved = read_state(d .. state_file(name)) or read_state(d .. STATE_FILE) or {}
    return saved
end

local function save_entry(key, tabs, scroll)
    local all = load_saved()
    all[key] = {tabs = tabs, scroll = scroll}
    local out = {'-- Chronicle: the open tab and each tab\'s scroll, per walkthrough page, for one character (core/pages.lua)', 'return {'}
    local keys = {}
    for k in pairs(all) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, k in ipairs(keys) do
        local v = all[k]
        local t, s = {}, {}
        if type(v) == 'table' then
            for g, i in pairs(type(v.tabs) == 'table' and v.tabs or {}) do if tonumber(g) and tonumber(i) then t[#t + 1] = ('[%d] = %d'):format(g, i) end end
            for g, y in pairs(type(v.scroll) == 'table' and v.scroll or {}) do if tonumber(y) then s[#s + 1] = ('[%q] = %d'):format(tostring(g), y) end end
        end
        table.sort(t) table.sort(s)
        out[#out + 1] = ('    [%q] = {tabs = {%s}, scroll = {%s}},'):format(k, table.concat(t, ', '), table.concat(s, ', '))
    end
    out[#out + 1] = '}'
    local d = fsave.data_dir(dir)
    fsave.mkdir(d .. 'data')              -- io.open does not create folders
    return (fsave.write(d .. state_file(saved_for), table.concat(out, '\n') .. '\n'))
end

local function save_state()
    if not cur then return end
    save_entry(cur.key, cur.tabs, cur.scroll)
end

-- tests only (review CORE-12): save one entry's state, read the state back, forget what was read
pages._save_entry, pages._saved = save_entry, function() return load_saved() end
pages._forget = function(d) saved, saved_for = nil, nil if d then dir = d end end

function pages.attach(a, w, native, d)
    app, win, N, dir = a, w, native, d or ''
    index = read('pages/index.lua') or {}
    by_title = nil
    local okm, meta = pcall(require, 'core/meta')
    if okm and type(meta) == 'table' and meta.set_page_index then meta.set_page_index(index) end      -- read once (review CORE-8)
    local ok, net = pcall(require, 'core/net')
    pics.setup(dir, N, ok and net or nil)
    pics.on_ready = function()
        if cur and win and win.visible then
            win.keep_place = true
            win:invalidate('content')
            win:flush()
        end
    end
end

-- tests only: render other pages under these keys (the QA calibration's known-bad pages)
function pages.set_index(t) index = t by_title = nil end

-- -> the page's file for an entry, or nil
function pages.find(p)
    if not index then return nil end
    return index[pages.key(p)] or index[(p.cat or '') .. '|' .. tostring(p.area) .. '|' .. tostring(p.name)]
end

-- where a link goes: 'this page' (one of its own tabs), 'Chronicle', 'the browser' (an address outside
-- the wiki) or 'BG-wiki'
-- The Records objectives with a page (record|roe|<id>), by the page's wiki title: the wiki names some of them as quests of their own
-- ("To Kill Mocking Birds" is the record Grudge, "Teleports by Twilight" is Telepoint Pilgrimage), and the pages link to each other by
-- those names. Read once, on the first link asked about; the lowest id wins for a page several records share (Ygnas Directive 1-6).
-- (by_title is declared with the module state above)
local function norm_title(s) return (s or ''):gsub('_', ' '):lower() end
function pages.record_by_title(title)
    if not by_title then
        by_title = {}
        for k, path in pairs(index or {}) do
            local id = tonumber(k:match('^record|roe|(%d+)$'))
            local t = id and read(path)
            local key = t and type(t.page) == 'string' and norm_title(t.page)
            if key and (not by_title[key] or id < by_title[key]) then by_title[key] = id end
        end
    end
    return by_title[norm_title(title)]
end

local function target(sp)
    local rid = sp.kind ~= 'item' and sp.kind ~= 'ki' and app.roe and pages.record_by_title(sp.to or sp.s)
    if rid then return 'Chronicle', {record = rid} end
    if sp.kind == 'mission' or sp.kind == 'quest' then
        local name = (sp.name or sp.s):lower()
        if cur and (cur.names[name] or cur.names[sp.s:lower()]) then return 'this page', cur.names[name] or cur.names[sp.s:lower()] end
        local area = sp.kind == 'mission' and app.data.find_mission_area(sp.name or sp.s, app.view.params.area)
            or (sp.kind == 'quest' and app.data.find_quest_area(sp.name or sp.s, app.view.params.area))
        if area then return 'Chronicle', area end
    end
    if (sp.to or sp.s):find('^https?://') then return 'the browser' end
    return 'BG-wiki'
end

-- Switch a tab group to tab i. From the strip in view, the page does not move: only the panel
-- under the strip changes (the scroll is kept, clamped if the new panel is shorter). From
-- elsewhere (the sticky bar, a link to a path) the strip comes to the top of the view, so the
-- path starts in sight. (In-game 2026-10-17: restoring a remembered place per tab made the page
-- jump on every click.)
local function set_tab(group, i, bring_strip)
    if not cur then return end
    local was = cur.tabs[group] or 1
    if was == i then return end
    local keep = win.scroll
    cur.tabs[group] = i
    win:invalidate('content')
    win:flush()
    local strip = cur.strip and cur.strip[group]
    if bring_strip and strip then win:scroll_to(math.max(0, strip - 6)) else win:scroll_to(keep) end
    win:flush()
    save_state()
end
pages.set_tab = set_tab

function pages.open(p)
    pages.close()
    local path = pages.find(p)
    if not path then return false end
    local doc = decoded(path)
    if not doc then return false end
    local key = pages.key(p)
    local st = load_saved()[key] or {}
    cur = {key = key, doc = doc, tabs = st.tabs or {}, scroll = st.scroll or {}, names = D.tab_names(doc)}

    app.walkthrough = function(b, ctx, params, y, w)
        -- the card the header must not repeat: the guide's (from the entry), or one the screen passes (a Records objective's details)
        local entry = not ctx.card and ctx.app and ctx.app.guide_entry and ctx.app:guide_entry(params)
        -- textures only for the pictures near the view (core/pics.lua): a quarter of a view above it, a view and three quarters below
        local sc, vh = ctx.scroll or 0, ctx.vh or 0
        local view = {y0 = sc - vh * 0.25, y1 = sc + vh * 1.75}
        local opts = {tabs = cur.tabs, pics = pics.get, card = ctx.card or card.shown(entry), view = view,
            progress = ctx.progress}     -- step checkboxes (ui/doc.lua); plain data, so it joins the memo key
        -- the memo: the same key, no picture changed, the same pictures near the view -> the last drawing, its hits and block tops
        -- (no picture pass either: the textures the last layout asked for are still held, nothing freed them)
        local mkey = pages.MEMO and memo_key(opts, y, w) or nil
        local m = cur.memo
        if m and m.key == mkey and m.rev == pics.rev and (m.pictures or same_near(m.rects, view)) then
            if not same_near(m.rects, view) then
                repaint(m, view)        -- the reader scrolled to other pictures (or a 0x055 came after a scroll)
                pages.stats.repaints = pages.stats.repaints + 1
            end
            local o, hits = b.o, b.hits
            local n = #o
            for i = 1, #m.o do o[n + i] = m.o[i] end
            n = #hits
            for i = 1, #m.hits do hits[n + i] = m.hits[i] end
            cur.rects, cur.strip = m.rects, m.strip
            pages.stats.hits = pages.stats.hits + 1
            return m.h, m.tops
        end
        cur.memo = nil
        cur.rects = {}
        opts.pic_rects = cur.rects
        local o0, h0 = #b.o, #b.hits
        pics.begin_pass()
        local h, tops = D.draw(b, cur.doc, 0, y, w, opts)
        pics.end_pass()
        cur.strip = tops.strip
        pages.stats.misses = pages.stats.misses + 1
        if mkey then
            local mo, mh = {}, {}
            for i = o0 + 1, #b.o do mo[i - o0] = b.o[i] end
            for i = h0 + 1, #b.hits do mh[i - h0] = b.hits[i] end
            cur.memo = {key = mkey, rev = pics.rev, rects = cur.rects, o = mo, hits = mh, h = h, tops = tops, strip = tops.strip,
                        pictures = index_pictures(mo, cur.rects)}
        end
        return h, tops
    end
    -- the reader scrolled: a picture in view that the layout drew with no texture (it was far from the view then)? -> lay out again
    app.walkthrough_view = function(ctx)
        if not (cur and cur.rects) then return false end
        local sc, vh = ctx.scroll or 0, ctx.vh or 0
        for _, r in ipairs(cur.rects) do
            if not r.asked and r.y1 >= sc and r.y0 <= sc + vh then return true end
        end
        return false
    end
    app.walkthrough_sticky = function(b, ctx)
        local w = ctx.win
        if not (cur.strip and w.vp) then return end
        for g, y in pairs(cur.strip) do
            if w.scroll > y + 46 then
                local h = w.hover
                D.sticky(b, cur.doc, g, cur.tabs[g] or 1, w.vp.x0, w.vp.y0, w.vp.x1 - w.vp.x0,
                    h and h.sticky and h.group == g and h.i or nil)
            end
        end
    end
    app.walkthrough_overlay = function(b, ctx, hit, to_win)
        D.overlay(b, ctx.win.content_b.hits, hit, to_win)
    end
    app.walkthrough_tooltip = function(b, ctx, hit, to_win)
        local _, y0 = to_win(hit.x0, hit.y0)
        local _, y1 = to_win(hit.x0, hit.y1)
        local mx = ctx.win.mouse_at and ctx.win.mouse_at.x or to_win(hit.x0, 0)
        D.tooltip(b, hit, mx, y1, ctx.w, function(sp) return (target(sp)) end, ctx.h, y0)
    end
    app.walkthrough_click = function(hit, ctx)
        if hit.id == 'tab' then
            set_tab(hit.group, hit.i, hit.sticky)
        elseif hit.id == 'link' then
            local sp = hit.span
            local where, arg = target(sp)
            if where == 'this page' then
                set_tab(arg.group, arg.i, true)
            elseif where == 'Chronicle' and type(arg) == 'table' and arg.record then
                app:roe_objective(arg.record, win.scroll, true)        -- a step forward: back returns to this page
            elseif where == 'Chronicle' then
                app:go('guide', {cat = sp.kind, area = arg, name = app:link_name(sp.kind, arg, sp.name or sp.s)}, win.scroll)
            else
                windower.open_url(pages.link_url(sp))
            end
        elseif hit.id == 'picture' then
            local pic = pics.get(hit.file)
            if type(pic) == 'table' then
                local b = ops.new()
                local title = hit.file:gsub('%.%a+$', ''):gsub('[-_]', ' ')
                D.enlarged(b, pic, title, ctx.screen_w, ctx.screen_h, win.x, win.y, win.w)
                win:open_picture(b)
            else
                windower.open_url(pages.url('File:' .. hit.file))
            end
        end
    end
    return true
end

-- before leaving the page: remember where the reader was in the open tab
function pages.close()
    if cur and win then
        cur.scroll = {page = win.scroll}
        save_state()
    end
    cur = nil
    D.release()
    pics.release()
    if app then
        app.walkthrough, app.walkthrough_overlay, app.walkthrough_tooltip, app.walkthrough_click, app.walkthrough_sticky, app.walkthrough_view = nil, nil, nil, nil, nil, nil
    end
end

function pages.current() return cur end
function pages.kept() return #docs end          -- the decoded pages kept (DOCS at most)

-- the scroll the open page was left at, or nil
function pages.saved_scroll()
    if not cur then return nil end
    return cur.scroll.page
end
function pages.tick(now) end
function pages.restyle() end
function pages.status()
    if not cur then return 'no page open' end
    local st = pages.stats
    return ('page %s (%d pictures resident, %d downloads, %d layouts, %d reused, %d repainted, %d pages kept)'):format(cur.key,
        pics.resident(), pics.fetches, st.misses, st.hits, st.repaints, #docs)
end

return pages
