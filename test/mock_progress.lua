--[[
    test/mock_progress.lua - MOCK-UPS ONLY: quest / mission step progress in Chronicle, drawn into the real UI at
    render time without changing ui/ or core/. Driven by test/render_progress.lua.

        local P = dofile('test/mock_progress.lua')
        P.install(env)          -- wraps D.draw, guide.chrome, home.content, area.content, data.get_area_status
        P.mode = 'on' | nil     (nil: the real UI, nothing added)

    The chosen design (user, 2026-10-22, second round):
      - a checkbox on each top-level step bullet of the walkthrough, and the path tabs' counts on a tabbed page
        (drawn through a proxy builder that swaps the level-1 bullet, a 5 x 5 rect in C.gold from ui/doc.lua
        list(), for the box)
      - a step strip under the guide's title: segments and "Step N of M:" with the next step's text; one row per
        path on a tabbed page
      - Home: the open tab's entries in progress under the area cards, each with its next step and segments
      - the area list: a "Next:" line and the count under an active row with progress
      - no legend anywhere

    Three display states, from what is known per step (seen done, inferred done, unknown, ...):
        done   a step seen or inferred done, or any step before a done one        ticked box     / filled segment
        next   the first step after the last done one                             gold empty box / gold segment
        todo   everything after it (an unknown step with nothing done after it)  dim empty box  / faint outline
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local D = require('ui/doc')
local C = kit.C
local text_w, title_w, fit = ops.text_w, ops.title_w, ops.fit

local P = {mode = nil, record = {}, tabline = {}}

-- ---------------------------------------------------------------------------------------------- mock data
-- What is known per step, before the display rule (obs = seen done, inf = inferred done, cur = the step the
-- tracker believes is open, unk = no evidence, todo = not done). Steps are the walkthrough's top-level bullets,
-- picked by ordinal within a section ('page' = outside any tab, 'tab<i>' = that panel); a bullet with no state
-- is not a step (notes, optional, how-to) and keeps its bullet.
P.PAGES = {
    ['The Siren\'s Tear'] = {
        page = {[1] = 'obs', [2] = 'inf', [3] = 'inf', [4] = 'obs', [5] = 'cur'},
    },
    ['Three Paths'] = {
        paths = {'Louverance', 'Tenzen', 'Ulmia'},
        page = {[1] = 'obs'},
        tab1 = {[2] = 'obs', [3] = 'inf', [4] = 'inf', [6] = 'obs', [9] = 'obs', [10] = 'inf', [11] = 'obs', [12] = 'inf', [13] = 'obs'},
        tab2 = {[2] = 'inf', [3] = 'inf', [6] = 'obs', [7] = 'obs', [8] = 'cur', [9] = 'todo', [10] = 'todo', [11] = 'todo',
                [13] = 'todo', [14] = 'todo', [15] = 'todo', [19] = 'todo', [20] = 'todo'},
        -- the backfill case: two unknown steps before a seen one (shown done done done next ...)
        tab3 = {[2] = 'unk', [3] = 'unk', [4] = 'obs', [5] = 'cur', [6] = 'todo', [8] = 'todo', [9] = 'todo', [10] = 'todo'},
    },
}

-- entries in progress, per Home tab, most recently advanced first; `short` is the terse next-step text the step
-- mapping would carry
P.RECENT = {
    mission = {
        {name = 'Three Paths', where = 'CoP 5-3, Tenzen', known = P.PAGES['Three Paths'].tab2,
         short = 'Speak with Pherimociel, Ru\'Lude Gardens'},
    },
    quest = {
        {name = 'The Siren\'s Tear', where = 'Bastok', known = P.PAGES['The Siren\'s Tear'].page,
         short = 'Trade the Siren\'s Tear to Wahid'},
        {name = 'Love and Ice', where = 'Bastok', known = {'unk', 'obs', 'cur', 'todo'},
         short = 'Mirror Pond, Beaucedine Glacier (G-10), at night'},
    },
}

-- the area list's active rows with progress (by entry name)
P.LIST = {}
for _, cat in pairs(P.RECENT) do for _, e in ipairs(cat) do P.LIST[e.name] = e end end

-- an ordinal-keyed known table -> the known states in order (the bullets that are steps)
local function ordered(known)
    local ks = {}
    for k in pairs(known) do ks[#ks + 1] = k end
    table.sort(ks)
    local out = {}
    for i, k in ipairs(ks) do out[i] = known[k] end
    return out, ks
end

-- the display rule: everything up to the last done step is done, the step after it is next, the rest to do
function P.collapse(known)
    local last = 0
    for i, s in ipairs(known) do if s == 'obs' or s == 'inf' then last = i end end
    local out = {}
    for i = 1, #known do
        out[i] = i <= last and 'done' or (i == last + 1 and 'next' or 'todo')
    end
    return out
end

local function count(states)
    local d = 0
    for _, s in ipairs(states) do if s == 'done' then d = d + 1 end end
    return d, #states
end

-- ----------------------------------------------------------------------------------------------- marks
local function tick(b, x, y, col)
    -- a 2 px check mark inside a 12 x 12 box at (x, y)
    for _, p in ipairs({{2, 6}, {3, 7}, {4, 8}, {5, 7}, {6, 6}, {7, 5}, {8, 4}, {9, 3}}) do
        b:rect(x + p[1], y + p[2], x + p[1] + 2, y + p[2] + 2, col)
    end
end

-- a 12 x 12 checkbox with its top-left at (x, y)
function P.mark(b, x, y, st)
    if st == 'done' then
        kit.frame(b, x, y, x + 12, y + 12, kit.alpha(C.completed, 200))
        tick(b, x, y, C.completed)
    elseif st == 'next' then
        b:rect(x + 1, y + 1, x + 11, y + 11, kit.alpha(C.active, 40))
        kit.frame(b, x, y, x + 12, y + 12, C.active)
        kit.frame(b, x + 1, y + 1, x + 11, y + 11, kit.alpha(C.active, 140))
    else
        kit.frame(b, x, y, x + 12, y + 12, kit.alpha(C.faint, 150))
    end
end

-- a step segment in a text line starting at y (18 px), w wide
function P.seg(b, x, y, w, st)
    if st == 'done' then
        b:rect(x, y + 4, x + w, y + 14, kit.alpha(C.completed, 230))
    elseif st == 'next' then
        b:rect(x, y + 2, x + w, y + 16, C.active)
    else
        kit.frame(b, x, y + 4, x + w, y + 14, kit.alpha(C.faint, 150))
    end
end

function P.segs(b, x, y, sw, gap, states)
    for i, st in ipairs(states) do P.seg(b, x + (i - 1) * (sw + gap), y, sw, st) end
    return #states * (sw + gap) - gap
end

-- ------------------------------------------------------------------------------------- the page's steps
local function plain(spans)
    local s = ''
    for _, sp in ipairs(spans or {}) do s = s .. (sp.s or '') end
    return (ops.ascii(s):gsub('%s+', ' '):gsub('^ ', ''))
end

-- the level-1 bullets in the order ui/doc.lua draws them (outside boxes, which draw into a builder of their own;
-- the open tab only), each {sec, n}
local function bullet_order(doc, tabs)
    local out, n = {}, {}
    local function walk(blocks, sec)
        for _, bl in ipairs(blocks) do
            if bl.k == 'list' and (bl.indent or 0) == 0 and not bl.ordered then
                for _ in ipairs(bl.items) do
                    n[sec] = (n[sec] or 0) + 1
                    out[#out + 1] = {sec = sec, n = n[sec]}
                end
            elseif bl.k == 'tabs' then
                local a = (tabs or {})[bl.group] or 1
                if a > #bl.tabs then a = 1 end
                walk(bl.tabs[a].blocks, 'tab' .. a)
            end
        end
    end
    walk(doc.blocks, 'page')
    return out
end

-- the steps of a section in order, with their display state: {state, text, n (bullet ordinal), i (step number)}
function P.steps(doc, map, sec)
    local known = map[sec] or {}
    local ks, ords = ordered(known)
    local shown = P.collapse(ks)
    local by = {}
    for i, o in ipairs(ords) do by[o] = i end
    local out, n = {}, 0
    local function walk(blocks, s)
        for _, bl in ipairs(blocks) do
            if bl.k == 'list' and (bl.indent or 0) == 0 and not bl.ordered then
                for _, it in ipairs(bl.items) do
                    if s == sec then
                        n = n + 1
                        local i = by[n]
                        if i then out[#out + 1] = {state = shown[i], text = plain(it.spans), n = n, i = i} end
                    end
                end
            elseif bl.k == 'tabs' then
                for t, tab in ipairs(bl.tabs) do walk(tab.blocks, 'tab' .. t) end
            end
        end
    end
    walk(doc.blocks, 'page')
    return out
end

local function states_of(steps)
    local s = {}
    for i, st in ipairs(steps) do s[i] = st.state end
    return s
end

local function next_of(steps)
    for _, st in ipairs(steps) do if st.state == 'next' then return st end end
end

-- the first sentence of a step's text
local function first_clause(s)
    local a = s:match('^(.-[%.!])%s') or s
    return (a:gsub('[%.!]$', ''))
end

-- --------------------------------------------------------------------------- the walkthrough: proxy builder
local function proxy(real, doc, map, opts)
    local order = bullet_order(doc, opts.tabs)
    local shown = {}            -- sec -> {[bullet ordinal] = display state}
    local function state(sec, n)
        if not shown[sec] then
            shown[sec] = {}
            for _, st in ipairs(P.steps(doc, map, sec)) do shown[sec][st.n] = st.state end
        end
        return shown[sec][n]
    end
    local q = 0
    local px = setmetatable({o = real.o, hits = real.hits}, {__index = function(_, k)
        local f = real[k]
        if type(f) == 'function' then return function(_, ...) return f(real, ...) end end
        return f
    end})
    function px:title(x, y, size, col, s)
        if not P.record.walk_y and size == 13 and col == C.gold and s == 'Walkthrough' then P.record.walk_y = y end
        return real:title(x, y, size, col, s)
    end
    function px:rect(x0, y0, x1, y1, col)
        if P.mode and col == C.gold and x1 - x0 == 5 and y1 - y0 == 5 then          -- a level-1 bullet (ui/doc.lua list())
            q = q + 1
            local b = order[q]
            local st = b and state(b.sec, b.n)
            if st then
                P.mark(real, x0 - 4, y0 - 3, st)
                return
            end
        end
        return real:rect(x0, y0, x1, y1, col)
    end
    function px:hit(h)
        if h.id == 'tab' and not h.sticky and P.mode then
            local s = states_of(P.steps(doc, map, 'tab' .. h.i))
            local d, n = count(s)
            if n > 0 then
                local cs = d .. '/' .. n
                local col = d == n and C.completed or C.active
                local tx = h.x1 - 12 - text_w(cs)
                local ly = (P.tabline[h.i] or 1) == 2 and h.y0 + 20 or h.y0 + 3
                real:text(tx, ly, col, cs)
                P.mark(real, tx - 16, ly + 3, d == n and 'done' or 'next')
            end
        end
        return real:hit(h)
    end
    return px
end

-- ------------------------------------------------------------------------------------------ installing
function P.install(env)
    local app = env.app
    local pages = package.loaded['core/pages']
    local G = package.loaded['ui/screens/guide']
    local Home = package.loaded['ui/screens/home']
    local Area = package.loaded['ui/screens/area']

    -- the mock's entries are in progress in every mode (baselines too, so frames differ by the progress alone); in the
    -- area's own status table, so Sort: Status and Show: Active see them (the fixture's flags are random)
    local guide_entry = app.guide_entry
    app.guide_entry = function(self, p)
        local e, st = guide_entry(self, p)
        if P.PAGES[p.name] or P.LIST[p.name] then st = 'active' end
        return e, st
    end
    local get_area_status = app.data.get_area_status
    app.data.get_area_status = function(cat, area)
        local s = get_area_status(cat, area)
        for _, it in ipairs(s and s.items or {}) do if P.LIST[it.name] then it.status = 'active' end end
        return s
    end

    -- the walkthrough through the proxy
    local draw = D.draw
    D.draw = function(b, doc, X0, Y0, W, opts)
        local map = P.PAGES[doc.title or '']
        if not map then return draw(b, doc, X0, Y0, W, opts) end
        opts = opts or {}
        P.record = {}
        P.tabline = {}
        -- a tab's count goes on the title's line when it has room, else on the second line, else the button is
        -- widened (its second line padded with spaces) for it on the title's line
        local padded = {}
        if P.mode then
            for _, bl in ipairs(doc.blocks) do
                if bl.k == 'tabs' then
                    for i, t in ipairs(bl.tabs) do
                        local d, n = count(states_of(P.steps(doc, map, 'tab' .. i)))
                        if n > 0 then
                            local need = 12 + 16 + text_w(d .. '/' .. n)
                            local tw, sw = title_w(ops.ascii(t.label), 11), text_w(ops.ascii(t.sub))
                            local inner = math.max(tw, sw)
                            if inner - tw >= need then P.tabline[i] = 1
                            elseif inner - sw >= need then P.tabline[i] = 2
                            else
                                P.tabline[i] = 1
                                padded[t] = t.sub
                                local sub = ops.ascii(t.sub)
                                while text_w(sub) < tw + need do sub = sub .. ' ' end
                                t.sub = sub
                            end
                        end
                    end
                end
            end
        end
        local h, tops = draw(proxy(b, doc, map, opts), doc, X0, Y0, W, opts)
        for t, s in pairs(padded) do t.sub = s end
        return h, tops
    end

    -- the step strip under the guide's title
    local chrome = G.chrome
    G.chrome = function(b, ctx)
        local vp, dh = chrome(b, ctx)
        if not P.mode or not vp then return vp, dh end
        local cur = pages.current()
        local map = cur and P.PAGES[cur.doc.title or '']
        if not map then return vp, dh end
        local x0, x1 = vp.x0, vp.x1
        local y = vp.y0 - 4
        local LH = 20
        local function step_line(yy, lead, st)
            b:text(x0, yy, C.active, lead)
            b:text(x0 + text_w(lead), yy, C.text, fit(first_clause(st.text), x1 - x0 - text_w(lead)))
        end
        if map.paths then
            local active = cur.tabs[1] or 1
            local lw = 0
            for _, n in ipairs(map.paths) do lw = math.max(lw, text_w(n)) end
            local rows = {}
            local maxn = 0
            for i, name in ipairs(map.paths) do
                local steps = P.steps(cur.doc, map, 'tab' .. i)
                rows[i] = {name = name, steps = steps, s = states_of(steps), next = next_of(steps)}
                maxn = math.max(maxn, #steps)
            end
            local sx = x0 + lw + 12
            local gap = 3
            local sw = math.min(22, math.floor((x1 - text_w('00/00') - 12 - sx + gap) / maxn) - gap)
            for i, r in ipairs(rows) do
                local on = i == active
                if on then
                    b:rect(x0 - 6, y, x1 + 6, y + LH - 1, {255, 255, 255, 14})
                    b:rect(x0 - 6, y, x0 - 4, y + LH - 1, C.gold)
                end
                b:text(x0, y + 1, on and C.gold or C.dim, r.name)
                P.segs(b, sx, y + 1, sw, gap, r.s)
                local d, n = count(r.s)
                local cs = d .. '/' .. n
                b:text(x1 - text_w(cs), y + 1, d == n and C.completed or C.active, cs)
                y = y + LH
            end
            -- the next step of the open path, or of the first path that has one
            local r = rows[active].next and rows[active] or nil
            if not r then for _, rr in ipairs(rows) do if rr.next then r = rr break end end end
            if r then
                step_line(y + 2, r.name .. ', step ' .. r.next.i .. ' of ' .. #r.s .. ': ', r.next)
                y = y + LH
            end
        else
            local steps = P.steps(cur.doc, map, 'page')
            local w = P.segs(b, x0, y + 1, 22, 3, states_of(steps))
            local st = next_of(steps)
            local tx = x0 + w + 12
            if st then
                local lead = 'Step ' .. st.i .. ' of ' .. #steps .. ': '
                b:text(tx, y + 2, C.active, lead)
                b:text(tx + text_w(lead), y + 2, C.text, fit(first_clause(st.text), x1 - tx - text_w(lead)))
            end
            y = y + LH
        end
        y = y + 4
        b:rect(x0, y, x1, y + 1, C.rule)
        vp.y0 = y + 10
        return vp, dh
    end

    -- Home: the open tab's entries in progress under the area cards
    local home_content = Home.content
    Home.content = function(b, ctx)
        -- the chosen design drops the 'Last updated' line from Home
        local updated = ctx.app.updated
        if P.mode then ctx.app.updated = nil end
        local h = home_content(b, ctx)
        ctx.app.updated = updated
        if not P.mode or not ctx.app.data.is_loaded() then return h end
        local list = P.RECENT[ctx.app.settings.active_tab == 'quest' and 'quest' or 'mission'] or {}
        if #list == 0 then return h end
        local w = ctx.vw
        local y = h + 6
        y = y + kit.heading(b, 0, y, w, 'In progress')
        local RH = 40
        for i, e in ipairs(list) do
            local s = P.collapse(ordered(e.known))
            local top = y
            b:rect(0, top, w, top + RH - 2, C.well)
            kit.frame(b, 0, top, w, top + RH - 2, C.edge)
            kit.mark(b, 8, top + 5, 'active')
            local d, n = count(s)
            local cs = d .. '/' .. n
            local sw = 9
            local segw = #s * (sw + 2) - 2
            local right = w - 8
            b:text(right - text_w(cs), top + 1, C.active, cs)
            local sx = right - text_w(cs) - 10 - segw
            local name = fit(e.name, sx - 12 - 26)
            b:text(26, top + 1, C.bold, name)
            local wx = 26 + text_w(name) + 8
            if wx + 20 < sx - 8 then b:text(wx, top + 1, C.faint, fit(e.where, sx - 8 - wx)) end
            P.segs(b, sx, top + 1, sw, 2, s)
            b:text(26, top + 19, C.active, 'Next:')
            b:text(26 + text_w('Next: '), top + 19, C.text, fit(e.short, w - 34 - text_w('Next: ')))
            b:hit({x0 = 0, y0 = top, x1 = w, y1 = top + RH - 2, id = 'progress', i = i})
            y = y + RH
        end
        return y + 8
    end

    -- the area list: a "Next:" line under an active row with progress (area.content's loop, rows of two heights)
    local area_content = Area.content
    Area.content = function(b, ctx)
        local a = ctx.app
        if not P.mode or not a.data.is_loaded() then return area_content(b, ctx) end
        local p = a.view.params
        local w = ctx.vw
        local items, s = a:list_items(p.cat, p.area)
        if #s.items == 0 or #items == 0 then return area_content(b, ctx) end
        local y = 0
        for n, it in ipairs(items) do
            local pr = it.status == 'active' and P.LIST[it.name]
            local h = kit.ROW_H + (pr and 18 or 0)
            kit.row(b, 0, y, w, n, it, false)
            if pr then
                if n % 2 == 0 then b:rect(0, y + kit.ROW_H - 2, w, y + h - 2, C.stripe) end
                local d, nn = count(P.collapse(ordered(pr.known)))
                local cs = d .. '/' .. nn
                b:text(w - 8 - text_w(cs), y + 35, C.active, cs)
                b:text(26, y + 35, C.active, 'Next:')
                local tx = 26 + text_w('Next: ')
                b:text(tx, y + 35, C.text, fit(pr.short, w - 8 - text_w(cs) - 12 - tx))
            end
            b:hit({x0 = 0, y0 = y, x1 = w, y1 = y + h - 2, id = 'row', item = it})
            y = y + h
        end
        return y
    end
end

return P
