--[[
    Chronicle: moving a cursor over what is clickable, for the controller. No drawing and no input here: the
    window (ui/window.lua) asks it for targets and moves, and draws the cursor itself.

    Every widget already registers its hit rectangles with what a click does (ui/kit.lua), so the targets
    are those hits:
        head   the chrome's hits (tabs, the way back, Settings / Collapse / Hide, Search, Sort, Show) and
               the sticky path-tab bar's tabs, in window-local coordinates
        body   the content's hits, in content coordinates (all of them, not only those in view)
    minus the resize grips, the sticky bar's background and the Settings value that does nothing. The
    rectangles of one link wrapped over several lines (the same span) are one target.

    A move is spatial: the candidates lie beyond the cursor's edge in the direction pressed, scored by the
    gap along it plus twice the offset across it (none when they overlap across it); left and right only
    move within the row. Ties go to reading order.

        nav.targets(win) -> list of {h, zone, x0, y0, x1, y1, key}
        nav.pick(list, cur, dir) -> the best target from cur (any {x0, y0, x1, y1}) in dir, or nil
        nav.key(h) -> the hit's identity without coordinates (it survives a re-layout)
]]

local nav = {}

local SKIP = {noop = true, sticky_bar = true}
nav.SKIP = SKIP

local function s(v) return v == nil and '' or tostring(v) end

-- a hit's identity: what it is and what it opens, never where it is drawn
function nav.key(h)
    local it = h.item
    return table.concat({s(h.id), s(h.span), s(h.group), s(h.i), s(h.area), s(h.cat), s(h.ci), s(h.si), s(h.oid),
        s(it and (it.id or it.name)), s(h.name), s(h.file), s(h.step), s(h.dir), s(h.key), s(h.entry),
        h.sticky and 's' or ''}, '|')
end

local function usable(h) return h.id ~= nil and not h.resize and not SKIP[h.id] end
nav.usable = usable

-- One builder's targets, made once per builder (a builder is one layout: its hits never change after it is sent). Weak keys: a
-- layout that is gone takes its list with it. A walkthrough of a thousand links builds its keys once, not on every move.
local memo = setmetatable({}, {__mode = 'k'})
local function list_of(b, zone, sticky_only)
    local l = memo[b]
    if l then return l end
    l = {}
    local seen, count = {}, {}
    for _, h in ipairs(b.hits) do
        if usable(h) and (not sticky_only or h.sticky) and not (h.span and seen[h.span]) then
            if h.span then seen[h.span] = true end
            local k = nav.key(h)
            local n = (count[k] or 0) + 1
            count[k] = n
            l[#l + 1] = {h = h, zone = zone, x0 = h.x0, y0 = h.y0, x1 = h.x1, y1 = h.y1, key = n > 1 and (k .. '#' .. n) or k}
        end
    end
    memo[b] = l
    return l
end

-- every target of the window as it was last flushed
function nav.targets(win)
    local out = {}
    local function add(l) for i = 1, #l do out[#out + 1] = l[i] end end
    if win.chrome_b then add(list_of(win.chrome_b, 'head')) end
    if win.overlay_b then add(list_of(win.overlay_b, 'head', true)) end
    if win.vp and win.content_b then add(list_of(win.content_b, 'body')) end
    return out
end

local function gap(a0, a1, b0, b1)
    if a1 <= b0 then return b0 - a1 end
    if b1 <= a0 then return a0 - b1 end
    return 0
end
nav.gap = gap

local TOL = 4
-- -> score (lower is better) when c lies in direction dir from cur, else nil
local function score(c, cur, dir)
    if dir == 'down' then
        if not (c.y0 > cur.y0 and c.y0 >= cur.y1 - TOL) then return nil end
        return math.max(0, c.y0 - cur.y1) + 2 * gap(c.x0, c.x1, cur.x0, cur.x1)
    elseif dir == 'up' then
        if not (c.y1 < cur.y1 and c.y1 <= cur.y0 + TOL) then return nil end
        return math.max(0, cur.y0 - c.y1) + 2 * gap(c.x0, c.x1, cur.x0, cur.x1)
    elseif dir == 'right' then
        if not (c.x0 > cur.x0 and c.x0 >= cur.x1 - TOL) or gap(c.y0, c.y1, cur.y0, cur.y1) > 0 then return nil end
        return c.x0 - cur.x1
    elseif dir == 'left' then
        if not (c.x1 < cur.x1 and c.x1 <= cur.x0 + TOL) or gap(c.y0, c.y1, cur.y0, cur.y1) > 0 then return nil end
        return cur.x0 - c.x1
    end
end

function nav.pick(list, cur, dir)
    local best, bs
    for _, c in ipairs(list) do
        if c ~= cur and c.key ~= cur.key then
            local v = score(c, cur, dir)
            if v and (not bs or v < bs or (v == bs and (c.y0 < best.y0 or (c.y0 == best.y0 and c.x0 < best.x0)))) then
                best, bs = c, v
            end
        end
    end
    return best
end

-- the targets of one zone, optionally moved into window-local coordinates (body: by the viewport and scroll)
function nav.zone(list, zone, to_win)
    local out = {}
    for _, c in ipairs(list) do
        if c.zone == zone then
            if to_win then
                local x0, y0 = to_win(c.x0, c.y0)
                local x1, y1 = to_win(c.x1, c.y1)
                out[#out + 1] = {h = c.h, zone = c.zone, key = c.key, x0 = x0, y0 = y0, x1 = x1, y1 = y1, src = c}
            else
                out[#out + 1] = c
            end
        end
    end
    return out
end

-- the first target in reading order whose rectangle is inside [y0, y1] (body coordinates)
function nav.first_in(list, y0, y1)
    local best
    for _, c in ipairs(list) do
        if c.zone == 'body' and c.y0 >= y0 and c.y1 <= y1 then
            if not best or c.y0 < best.y0 or (c.y0 == best.y0 and c.x0 < best.x0) then best = c end
        end
    end
    return best
end

-- the target of a zone nearest to content y (and x), for a cursor whose hit is gone after a re-layout
function nav.nearest(list, zone, x, y)
    local best, bd
    for _, c in ipairs(list) do
        if c.zone == zone then
            local d = gap(c.y0, c.y1, y, y + 1) * 4 + gap(c.x0, c.x1, x, x + 1)
            if not bd or d < bd then best, bd = c, d end
        end
    end
    return best
end

function nav.find(list, key)
    if not key then return nil end
    for _, c in ipairs(list) do if c.key == key then return c end end
    return nil
end

return nav
