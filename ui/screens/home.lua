--[[
    Chronicle, Home: Missions / Quests tabs, the overall completion for the active tab (with
    uncompletable entries left out unless shown), and a two-column grid of area cards. "Waiting for
    data" until the first 0x056 packet.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')

local S = {}
local C = kit.C

local TABS = {'Missions', 'Quests'}
local CATS = {'mission', 'quest'}
local GAP = 8

local function cat_of(app) return app.settings.active_tab == 'quest' and 'quest' or 'mission' end

function S.chrome(b, ctx)
    local app = ctx.app
    local right = common.frame(b, ctx)
    if ctx.collapsed then
        b:title(common.PAD, common.TOP + 3, 11, C.gold, 'Chronicle')
        return nil, 40
    end
    local active = cat_of(app) == 'quest' and 2 or 1
    local hover = ctx.hover and ctx.hover.id == 'tab' and ctx.hover.i or nil
    kit.tabs(b, common.PAD, common.TOP - 2, TABS, active, hover, 'tab')
    local x0, x1 = common.PAD, ctx.w - common.PAD
    local y = common.TOP + 38
    if not app.data.is_loaded() then
        return {x0 = x0, y0 = y, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
    end
    local sum = app.data.get_summary()[cat_of(app)]
    local done, total = app:adjusted(sum)
    local pct = kit.pct(done, total)
    b:text(x0, y, C.dim, 'Overall Completion')
    local ps = pct .. '%'
    local pw = ops.title_w(ps, 18)
    b:title(x1 - pw, y - 4, 18, kit.tier(pct), ps)
    local cs = done .. ' / ' .. total
    b:text(x1 - pw - 14 - ops.text_w(cs), y, C.dim, cs)
    if pct >= 100 and app.tex and app:tex('trophy') then
        local t = app:tex('trophy')
        b:quad(t.h, x1 - pw - 34 - ops.text_w(cs), y, x1 - pw - 18 - ops.text_w(cs), y + 16, 0, 0, t.w, t.h_px, C.tier_full, 1)
    end
    b:gauge(x0, y + 24, x1 - x0, 8, total > 0 and done / total or 0, kit.tier(pct))
    return {x0 = x0, y0 = y + 44, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
end

function S.content(b, ctx)
    local app = ctx.app
    local w = ctx.vw
    if not app.data.is_loaded() then
        common.message(b, w, 40, 'Waiting for data...', C.gold)
        common.message(b, w, 62, 'Zone or complete an objective to populate.', C.dim)
        return 120
    end
    local cat = cat_of(app)
    local sum = app.data.get_summary()[cat]
    local cw = math.floor((w - GAP) / 2)
    -- one row height for the grid: taller when a name needs two lines at this width (a cut name hid half of it)
    local CARD_H = kit.CARD_H
    for _, a in ipairs(sum.areas) do
        if #kit.card_name_lines(a.name, cw, app.tex and app:tex(a.area) ~= nil) > 1 then CARD_H = kit.CARD_H_TALL end
    end
    local y = 0
    for i, a in ipairs(sum.areas) do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        local x = col * (cw + GAP)
        y = row * (CARD_H + GAP)
        local done, total = app:adjusted(a)
        local s = {name = a.name, completed = done, total = total, has_data = a.has_data}
        kit.card(b, x, y, cw, CARD_H, s, app.tex and app:tex(a.area), false, app.tex and app:tex('trophy'))
        b:hit({x0 = x, y0 = y, x1 = x + cw, y1 = y + CARD_H, id = 'card', area = a.area, cat = cat})
    end
    y = y + CARD_H + 16
    return S.in_progress(b, app, cat, sum, y, w)
end

-- The open tab's entries in progress, under the cards: a boxed row each, the name, where it belongs, its step segments and count,
-- then its next step. An entry with no step known (no mapping, or no next step) is the name line alone.
S.SEG_W, S.SEG_GAP = 9, 2
function S.in_progress(b, app, cat, sum, y, w)
    local list = app:in_progress(cat, sum)
    if #list == 0 then return y end
    y = y + 6
    y = y + kit.heading(b, 0, y, w, 'In progress')
    for _, e in ipairs(list) do
        local st = e.steps
        local h = st and st.text and 38 or 20
        b:rect(0, y, w, y + h, C.well)
        kit.frame(b, 0, y, w, y + h, C.edge)
        kit.mark(b, 8, y + 5, 'active')
        local right = w - 8
        if st then
            local cs = st.done .. '/' .. st.total
            right = right - ops.text_w(cs)
            b:text(right, y + 1, C.active, cs)
            local sw = kit.seg_w(st.total, math.floor(w * 0.4), S.SEG_W, S.SEG_GAP)
            if sw then
                right = right - 10 - (st.total * (sw + S.SEG_GAP) - S.SEG_GAP)
                for k, s in ipairs(st.states) do kit.step_seg(b, right + (k - 1) * (sw + S.SEG_GAP), y + 1, sw, s) end
            end
            right = right - 12
        end
        local name = ops.fit(e.name, right - 26)
        b:text(26, y + 1, C.bold, name)
        local wx = 26 + ops.text_w(name) + 8
        if e.where and wx + 20 < right then b:text(wx, y + 1, C.faint, ops.fit(e.where, right - wx)) end
        if st and st.text then
            local lead = 'Next: '
            b:text(26, y + 19, C.active, lead)
            b:text(26 + ops.text_w(lead), y + 19, C.text, ops.fit_words(st.text, w - 34 - ops.text_w(lead)))
        end
        b:hit({x0 = 0, y0 = y, x1 = w, y1 = y + h, id = 'progress', cat = e.cat, area = e.area, name = e.name, entry = e.id})
        y = y + h + 2
    end
    return y + 8
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'card' or hit.id == 'progress' then
        local x0, y0 = to_win(hit.x0, hit.y0)
        local x1, y1 = to_win(hit.x1, hit.y1)
        kit.frame(b, x0, y0, x1, y1, kit.C.hover_edge)
        b:rect(x0 + 1, y0 + 1, x1 - 1, y1 - 1, {255, 255, 255, 22})
    end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    if hit.id == 'tab' then
        app.settings.active_tab = CATS[hit.i]
        app.save()
        ctx.win:scroll_to(0)
        ctx.win:invalidate('all')
    elseif hit.id == 'card' then
        app:go('area', {cat = hit.cat, area = hit.area}, ctx.scroll)
    elseif hit.id == 'progress' then
        app:go('guide', {cat = hit.cat, area = hit.area, name = hit.name, id = hit.entry, status = 'active'}, ctx.scroll)
    end
end

function S.right(hit, ctx, app) app:back() end

return S
