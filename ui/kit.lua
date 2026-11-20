--[[
    Chronicle: widgets drawn with ui/ops builders, in the look verified in game
    (buttons, list rows, scrollbar and menu from its probe scene; link colours, rules and bullets
    from its Chronicle page). Every widget draws into a builder and registers its own hit
    rectangles, so what is clicked is exactly what is drawn.

    Hits carry an `id` (what the screen does on a click) and optional fields; `hover` arguments are
    true when the widget is under the mouse.
]]

local ops = require('ui/ops')

local kit = {}

local text_w, title_w, fit = ops.text_w, ops.title_w, ops.fit

kit.LINE = 18

local C = {
    text = {205, 211, 222}, bold = {255, 255, 255}, dim = {150, 160, 178}, faint = {120, 128, 144},
    red = {255, 118, 106}, gold = {227, 195, 111}, gold_soft = {236, 216, 160}, label = {255, 224, 150},
    npc = {130, 202, 255}, zone = {140, 226, 150}, item = {255, 205, 120}, ki = {255, 214, 92},
    mob = {255, 142, 130}, quest = {196, 172, 255}, mission = {196, 172, 255}, spell = {120, 214, 255},
    page = {214, 218, 232}, coord = {118, 232, 232}, rare = {255, 186, 118}, ex = {150, 200, 255},
    rule = {138, 124, 79, 150}, edge = {255, 255, 255, 48}, well = {0, 0, 0, 80}, well_dark = {0, 0, 0, 110},
    stripe = {255, 255, 255, 10}, hover = {255, 255, 255, 34}, hover_edge = {224, 200, 140, 170},
    press = {0, 0, 0, 170}, press_edge = {224, 200, 140, 230},
    -- status
    completed = {140, 226, 150}, active = {255, 205, 120}, ['repeat'] = {118, 232, 232},
    not_started = {150, 160, 178}, uncompletable = {255, 160, 90}, unknown = {255, 118, 106},
    -- a Records objective the client would not offer yet: the same orange as uncompletable,
    -- because it is the same thing to the eye -- not something you can do right now
    locked = {255, 160, 90},
    -- completion tiers (v1's: red < 25, cyan < 75, green < 100, gold at 100)
    tier_low = {255, 118, 106}, tier_mid = {118, 214, 232}, tier_high = {140, 226, 150}, tier_full = {255, 214, 92},
}
kit.C = C

function kit.alpha(c, a) return {c[1], c[2], c[3], a} end
local alpha = kit.alpha

function kit.tier(pct)
    if pct >= 100 then return C.tier_full end
    if pct >= 75 then return C.tier_high end
    if pct >= 25 then return C.tier_mid end
    return C.tier_low
end

function kit.pct(n, d)
    if not d or d == 0 then return 0 end
    return math.floor(n / d * 100)
end

-- a 1 px outline
function kit.frame(b, x0, y0, x1, y1, col)
    b:rect(x0, y0, x1, y0 + 1, col)
    b:rect(x0, y1 - 1, x1, y1, col)
    b:rect(x0, y0 + 1, x0 + 1, y1 - 1, col)
    b:rect(x1 - 1, y0 + 1, x1, y1 - 1, col)
end

-- the probe's button: a dark well, a light edge; hover lifts it, a press darkens it and turns the
-- label gold. -> its hit
function kit.button(b, x, y, w, h, label, st, hit)
    st = st or {}
    local fill = st.pressed and C.press or (st.hover and {255, 255, 255, 46} or C.well)
    local edge = (st.pressed or st.on) and C.press_edge or (st.hover and C.hover_edge or C.edge)
    b:rect(x, y, x + w, y + h, fill)
    kit.frame(b, x, y, x + w, y + h, edge)
    local off = st.pressed and 1 or 0
    local col = (st.pressed or st.on) and C.gold or (st.dim and C.dim or C.bold)
    b:text(x + math.floor((w - text_w(label)) / 2) + off, y + math.floor((h - 16) / 2) + off, col, label)
    hit = hit or {}
    hit.x0, hit.y0, hit.x1, hit.y1 = x, y, x + w, y + h
    return b:hit(hit)
end

-- a button sized to its label
function kit.button_w(label, pad) return text_w(label) + 2 * (pad or 10) end

-- "Label: Value" that cycles on click. -> hit, width
function kit.cycle(b, x, y, label, value, st, hit)
    local s = label .. ': ' .. value
    local w = kit.button_w(s, 8)
    return kit.button(b, x, y, w, 22, s, st, hit), w
end

-- tabs: labels side by side, the active one gold with a gold rule under it. -> width
function kit.tabs(b, x, y, labels, active, hover, id)
    local cx = x
    for i, label in ipairs(labels) do
        local w = title_w(label, 11)
        local on = i == active
        local col = on and C.gold or (hover == i and C.gold_soft or C.dim)
        b:title(cx, y + 3, 11, col, label)
        if on then b:rect(cx, y + 20, cx + w, y + 22, C.gold) end
        b:hit({x0 = cx - 6, y0 = y, x1 = cx + w + 6, y1 = y + 24, id = id, i = i})
        cx = cx + w + 26
    end
    return cx - x - 26
end


-- the search box; caret drawn when focused and `caret` is on
function kit.input(b, x, y, w, text, placeholder, focused, caret, hover)
    local h = 22
    b:rect(x, y, x + w, y + h, C.well_dark)
    kit.frame(b, x, y, x + w, y + h, focused and C.press_edge or (hover and C.hover_edge or C.edge))
    local shown = text
    -- keep the end of a long entry visible
    while #shown > 0 and text_w(shown) > w - 16 do shown = shown:sub(2) end
    if shown == '' and not focused then
        b:text(x + 7, y + 3, C.faint, placeholder)
    else
        b:text(x + 7, y + 3, C.bold, shown)
    end
    if focused and caret then
        local cx = x + 7 + text_w(shown) + 1
        b:rect(cx, y + 4, cx + 1, y + 18, C.gold)
    end
    return b:hit({x0 = x, y0 = y, x1 = x + w, y1 = y + h, id = 'search'})
end

-- A small status mark: a filled square in the status colour (hollow when not started). A repeatable
-- record carries a second square behind it, offset up and to the right, so the shape says there is
-- another one after this one. Shape, not colour: the five status colours are already spoken for,
-- and repeatable is a property of the record, not a sixth state it can be in.
function kit.mark(b, x, y, status, rep)
    local col = C[status] or C.unknown
    if rep then kit.frame(b, x + 4, y - 4, x + 14, y + 6, alpha(col, 170)) end
    if status == 'not_started' then
        kit.frame(b, x, y, x + 10, y + 10, alpha(col, 200))
    else
        b:rect(x, y, x + 10, y + 10, alpha(col, 230))
        if status == 'active' then b:rect(x + 3, y + 3, x + 7, y + 7, {0, 0, 0, 120}) end
    end
end

-- Step progress (core/progress.lua): three states, told apart by shape as well as colour, nothing animated.
-- A 12 x 12 checkbox with its top-left at (x, y): done = a ticked box, next = an empty box in the active gold,
-- todo = a plain dim empty box.
local TICK = {{2, 6}, {3, 7}, {4, 8}, {5, 7}, {6, 6}, {7, 5}, {8, 4}, {9, 3}}
function kit.step_box(b, x, y, state)
    if state == 'done' then
        kit.frame(b, x, y, x + 12, y + 12, alpha(C.completed, 200))
        for _, p in ipairs(TICK) do b:rect(x + p[1], y + p[2], x + p[1] + 2, y + p[2] + 2, C.completed) end
    elseif state == 'next' then
        b:rect(x + 1, y + 1, x + 11, y + 11, alpha(C.active, 40))
        kit.frame(b, x, y, x + 12, y + 12, C.active)
        kit.frame(b, x + 1, y + 1, x + 11, y + 11, alpha(C.active, 140))
    else
        kit.frame(b, x, y, x + 12, y + 12, alpha(C.faint, 150))
    end
end

-- a step segment w wide in the text line that starts at y (18 px): done filled, next a taller gold block, todo an outline
function kit.step_seg(b, x, y, w, state)
    if state == 'done' then
        b:rect(x, y + 4, x + w, y + 14, alpha(C.completed, 230))
    elseif state == 'next' then
        b:rect(x, y + 2, x + w, y + 16, C.active)
    else
        kit.frame(b, x, y + 4, x + w, y + 14, alpha(C.faint, 150))
    end
end

-- The width of a segment when n of them share at most `room` px: `sw` when they fit, narrower down to 3, nil when even that is
-- too wide (the count alone then says it)
function kit.seg_w(n, room, sw, gap)
    if n * (sw + gap) - gap <= room then return sw end
    local w = math.floor((room + gap) / n) - gap
    return w >= 3 and w or nil
end

kit.ROW_H = 38
-- a two-line list row: mark, name, the NPC line under it; striped, lit on hover
function kit.row(b, x, y, w, n, item, hover)
    local h = kit.ROW_H
    if hover then b:rect(x, y, x + w, y + h - 2, C.hover)
    elseif n % 2 == 0 then b:rect(x, y, x + w, y + h - 2, C.stripe) end
    kit.mark(b, x + 8, y + 5, item.status, item.rep)
    local done = item.status == 'completed' or item.status == 'uncompletable' or item.status == 'locked'
    local right = item.badge and text_w(item.badge) + 16 or 0
    local name = fit(item.name, w - 40 - right)
    b:text(x + 26, y + 1, hover and C.gold or (done and C.dim or C.bold), name)
    if item.sub then b:text(x + 26, y + 18, C.faint, fit(item.sub, w - 34 - right)) end
    if item.badge then
        local bw = text_w(item.badge)
        b:text(x + w - bw - 8, y + 1, item.badge_col or C[item.status] or C.dim, item.badge)
        -- a counter the server is reporting: its bar under the count
        if item.bar then
            local gw = math.max(40, math.min(76, bw))
            b:gauge(x + w - 8 - gw, y + 21, gw, 6, math.max(0, math.min(1, item.bar)),
                    item.badge_col or C[item.status] or C.active)
        end
    end
end

-- The middle level of the Records tab: one row per sub-category, carrying what is inside it.
-- Denser than a card grid, which matters because a category holds up to 21 of them, and visibly
-- a different kind of screen from the cards above it.
kit.SUBROW_H = 42
kit.SUBROW_GAUGE, kit.SUBROW_PCT = 80, 42
function kit.subrow(b, x, y, w, n, s, hover)
    local h = kit.SUBROW_H
    if hover then b:rect(x, y, x + w, y + h - 2, C.hover)
    elseif n % 2 == 0 then b:rect(x, y, x + w, y + h - 2, C.stripe) end
    local pct = kit.pct(s.completed, s.total)
    local ps = s.has_data and (pct .. '%') or '--'
    local col = s.has_data and kit.tier(pct) or C.faint
    -- right to left: the percentage, then the gauge with its count under it
    local xr = x + w - 8
    b:text(xr - text_w(ps), y + 6, col, ps)
    xr = xr - math.max(kit.SUBROW_PCT, text_w(ps) + 8)
    local gw = kit.SUBROW_GAUGE
    local cs = s.has_data and (s.completed .. ' / ' .. s.total) or (s.pool .. ' records')
    if w > 320 then
        b:gauge(xr - gw, y + 7, gw, 6, s.has_data and s.total > 0 and s.completed / s.total or 0, col)
        b:text(xr - gw + math.max(0, gw - text_w(cs)), y + 19, C.dim, cs)
        xr = xr - gw - 12
    else
        b:text(xr - text_w(cs), y + 12, C.dim, cs)
        xr = xr - text_w(cs) - 12
    end
    local name = fit(s.name, xr - x - 10)
    b:text(x + 8, y + 3, hover and C.gold or C.bold, name)
    -- the client's own sub-category names say nothing ("Job Levels 1", "Quests 1"); the line
    -- under the name is derived from the objectives inside and is what makes this level usable
    local hint = s.hint or ''
    if s.active and s.active > 0 then
        local lead = hint ~= '' and (hint .. '  ') or ''
        local tail = s.active .. ' active'
        local room = xr - x - 10
        lead = fit(lead, math.max(0, room - text_w(tail) - 4))
        b:text(x + 8, y + 21, C.faint, lead)
        b:text(x + 8 + text_w(lead), y + 21, C.active, tail)
    elseif hint ~= '' then
        b:text(x + 8, y + 21, C.faint, fit(hint, xr - x - 10))
    end
end

kit.CARD_H, kit.CARD_H_TALL = 58, 72
local EMBLEM = 56
local PITCH = 17

-- the card's name as it is drawn: wrapped to the room the emblem leaves, at most two lines (the second cut with '..'),
-- never one cut line when a second would hold the rest (2026-10-19: "Chains of Proma..", "Treasures of Aht..")
function kit.card_name_lines(name, w, has_emblem)
    local avail = w - (has_emblem and EMBLEM + 10 or 10) - 8
    local lines = ops.wrap(name, avail)
    if #lines > 2 then lines = {lines[1], fit(table.concat(lines, ' ', 2), avail)} end
    if #lines == 0 then lines = {''} end
    return lines
end

-- an area card: emblem, name (one or two lines), the count and percentage, the gauge. h is kit.CARD_H, or
-- kit.CARD_H_TALL when a name in the same grid needs two lines
function kit.card(b, x, y, w, h, s, emblem, hover, trophy)
    b:rect(x, y, x + w, y + h, hover and {255, 255, 255, 30} or C.well)
    kit.frame(b, x, y, x + w, y + h, hover and C.hover_edge or C.edge)
    local tx = x + 10
    if emblem then
        local ey = y + math.floor((h - EMBLEM) / 2)
        b:quad(emblem.h, x + 1, ey, x + 1 + EMBLEM, ey + EMBLEM, 0, 0, emblem.w, emblem.h_px, {255, 255, 255, 150}, 1)
        tx = x + EMBLEM + 10
    end
    local pct = kit.pct(s.completed, s.total)
    local pct_s = s.has_data and (pct .. '%') or '--'
    local pw = text_w(pct_s)
    local lines = kit.card_name_lines(s.name, w, emblem and true or false)
    local top = math.max(2, math.floor((h - 13 - (#lines + 1) * PITCH) / 2) - 1)
    for i, l in ipairs(lines) do b:text(tx, y + top + (i - 1) * PITCH, hover and C.gold or C.bold, l) end
    local sy = y + top + #lines * PITCH
    local sub = s.has_data and (s.completed .. ' / ' .. s.total) or (s.total .. ' entries')
    b:text(tx, sy, C.dim, sub)
    b:text(x + w - 10 - pw, sy, s.has_data and kit.tier(pct) or C.faint, pct_s)
    if trophy and s.has_data and pct >= 100 then
        b:quad(trophy.h, x + w - 30 - pw, sy, x + w - 14 - pw, sy + 16, 0, 0, trophy.w, trophy.h_px, C.tier_full, 1)
    end
    b:gauge(tx, y + h - 13, x + w - 10 - tx, 7, s.has_data and pct / 100 or 0, s.has_data and kit.tier(pct) or C.faint)
end

-- a status badge, right-aligned at xr
function kit.badge(b, xr, y, text, col)
    local w = text_w(text)
    b:rect(xr - w - 12, y, xr, y + 18, alpha(col, 46))
    kit.frame(b, xr - w - 12, y, xr, y + 18, alpha(col, 120))
    b:text(xr - w - 6, y + 1, col, text)
    return w + 12
end

-- a scrollbar: a 4 px track, a gold thumb. -> thumb rectangle (or nil when it all fits)
function kit.scrollbar(b, x, y0, y1, view_h, content_h, scroll)
    if content_h <= view_h then return nil end
    local track = y1 - y0
    local thumb = math.max(30, math.floor(track * view_h / content_h))
    local pos = math.floor((track - thumb) * scroll / (content_h - view_h))
    b:rect(x, y0, x + 4, y1, {0, 0, 0, 110})
    b:rect(x, y0 + pos, x + 4, y0 + pos + thumb, C.gold)
    return {x0 = x - 4, y0 = y0, x1 = x + 8, y1 = y1, thumb0 = y0 + pos, thumb1 = y0 + pos + thumb}
end

-- a tooltip window under (x, y), kept on screen: title (title font), lines {text, col}, an item icon. The title and the first line
-- sit beside the icon, the other lines under it: each row is measured from the x it is drawn at, and cut to the room the screen
-- leaves (an external link's title is its whole address). Past the bottom it goes above `above`, the top of what it explains. Rule 206.
function kit.tooltip(b, x, y, title, lines, icon, screen_w, screen_h, above)
    local left, right = 16, 20
    local beside = icon and 54 or left
    local max_w = (screen_w or 1e9) - 8
    title = ops.fit_title(title, 11, max_w - beside - right)
    local tw = beside + title_w(title, 11) + right
    local rows = {}
    for i, l in ipairs(lines) do
        local rx = i == 1 and beside or left
        local s = fit(l[1], max_w - rx - right)
        rows[i] = {rx, s, l[2] or C.dim}
        tw = math.max(tw, rx + text_w(s) + right)
    end
    local th = 34 + 18 * #lines
    if icon then th = math.max(th, 58) end
    x = math.max(0, math.min(x, max_w - tw))
    if screen_h and above and y + th > screen_h - 8 then y = math.max(0, above - th - 8) end
    b:win(x, y, tw, th, '')
    if icon then b:icon(x + 14, y + 12, 32, icon) end
    b:title(x + beside, y + 14, 11, C.bold, title)
    for i, r in ipairs(rows) do b:text(x + r[1], y + 12 + 18 * i, r[3], r[2]) end
    return {x0 = x, y0 = y, x1 = x + tw, y1 = y + th}
end

-- the resize grip in the bottom-right corner, and hits for it and the right / bottom edges
function kit.grip(b, W, H, active, hover)
    local col = active and C.gold or (hover and C.gold_soft or alpha(C.gold, 150))
    for _, d in ipairs({{8, 8}, {12, 8}, {8, 12}, {16, 8}, {12, 12}, {8, 16}}) do
        b:rect(W - d[1] - 2, H - d[2] - 2, W - d[1], H - d[2], col)
    end
end
function kit.grip_hits(b, W, H)
    b:hit({x0 = W - 6, y0 = 24, x1 = W + 3, y1 = H - 20, resize = 'x'})
    b:hit({x0 = 24, y0 = H - 6, x1 = W - 20, y1 = H + 3, resize = 'y'})
    b:hit({x0 = W - 22, y0 = H - 22, x1 = W + 3, y1 = H + 3, resize = 'xy'})
end

-- a section heading in the title font with a rule to the right edge (the page's level-2 heading)
function kit.heading(b, x, y, w, text, px)
    px = px or 11
    b:title(x, y, px, C.gold, text)
    local tw = title_w(text, px)
    b:rect(x + tw + 10, y + math.floor(px * 0.6), x + w, y + math.floor(px * 0.6) + 1, C.rule)
    return px + 10
end

return kit
