--[[
    Chronicle, an area's list: the area name, completion and flavour line, a gauge, the toolbar
    (search, Sort, Show; both saved) and two-line rows (status mark, name, the starting NPC and
    zone). v1's pipeline: core/app.lua list_items.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')
local App = require('core/app')

local S = {focusable = {search = true}}
local C = kit.C

S.NEXT_H = 18                  -- the third line of an active row with a next step

function S.chrome(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local right = common.frame(b, ctx)
    common.crumbs(b, ctx, app, right)
    if ctx.collapsed then return nil, 40 end
    local x0, x1 = common.PAD, ctx.w - common.PAD
    local y = common.TOP + 30
    local name = app.data.get_area_name(p.area, p.cat)
    local s = app.data.get_area_status(p.cat, p.area)
    local done, total = app:adjusted(s)
    local pct = kit.pct(done, total)
    local ps = s.has_data and (pct .. '%') or '--'
    local pw = ops.title_w(ps, 18)
    b:title(x1 - pw, y, 18, s.has_data and kit.tier(pct) or C.faint, ps)
    b:title(x0, y + 2, 14, C.bold, ops.fit_title(name, 14, x1 - x0 - pw - 30))
    y = y + 26
    local cs = s.has_data and (done .. ' / ' .. total) or (total .. ' entries')
    b:text(x1 - ops.text_w(cs), y, C.dim, cs)
    b:text(x0, y, C.dim, ops.fit(App.SUBTITLES[p.area] or '', x1 - x0 - ops.text_w(cs) - 20))
    y = y + 22
    b:gauge(x0, y, x1 - x0, 7, total > 0 and done / total or 0, s.has_data and kit.tier(pct) or C.faint)
    y = y + 18
    -- toolbar: search on the left, Show and Sort on the right
    local show_uc = app:show_uc()
    local f = app.settings.filter_mode or 1
    if f > (show_uc and 5 or 4) then f = 1 end
    local sort = app.settings.sort_mode or 1
    local show_s = 'Show: ' .. App.FILTERS[f]
    local sort_s = 'Sort: ' .. App.SORTS[sort]
    local show_w, sort_w = kit.button_w(show_s, 8), kit.button_w(sort_s, 8)
    local sx = x1 - show_w
    kit.button(b, sx, y, show_w, 22, show_s,
        {hover = common.hovered(ctx, 'filter'), pressed = common.pressed(ctx, 'filter')}, {id = 'filter', tip = 'Click to change'})
    sx = sx - 8 - sort_w
    kit.button(b, sx, y, sort_w, 22, sort_s,
        {hover = common.hovered(ctx, 'sort'), pressed = common.pressed(ctx, 'sort')}, {id = 'sort', tip = 'Click to change'})
    local iw = math.max(120, math.min(240, sx - 12 - x0))
    kit.input(b, x0, y, iw, app.search, 'Search...', ctx.focus == 'search', ctx.caret, common.hovered(ctx, 'search'))
    y = y + 32
    return {x0 = x0, y0 = y, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
end

function S.content(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local w = ctx.vw
    if not app.data.is_loaded() then
        common.message(b, w, 30, 'Waiting for data...', C.gold)
        common.message(b, w, 52, 'Zone or complete an objective to populate.', C.dim)
        return 100
    end
    local items, s = app:list_items(p.cat, p.area)
    if #s.items == 0 then
        common.message(b, w, 30, s.has_data and 'No entries for this area' or 'No data -- zone to load')
        return 80
    end
    if #items == 0 then
        common.message(b, w, 30, p.cat == 'mission' and 'No matching missions' or 'No matching quests')
        return 80
    end
    local y = 0
    for n, it in ipairs(items) do
        -- an active row with a next step: a third line, "Next:" and the count
        local st = it.status == 'active' and app:step_summary(p.cat, p.area, it.id) or nil
        local h = kit.ROW_H + (st and st.text and S.NEXT_H or 0)
        kit.row(b, 0, y, w, n, it, false)
        if st and st.text then
            if n % 2 == 0 then b:rect(0, y + kit.ROW_H - 2, w, y + h - 2, C.stripe) end
            local cs = st.done .. '/' .. st.total
            local lead = 'Next: '
            b:text(w - 8 - ops.text_w(cs), y + 35, C.active, cs)
            b:text(26, y + 35, C.active, lead)
            local tx = 26 + ops.text_w(lead)
            b:text(tx, y + 35, C.text, ops.fit_words(st.text, w - 8 - ops.text_w(cs) - 12 - tx))
        end
        b:hit({x0 = 0, y0 = y, x1 = w, y1 = y + h - 2, id = 'row', item = it})
        y = y + h
    end
    return y
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'row' then common.wash(b, hit, to_win) end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    local p = app.view.params
    if hit.id == 'filter' then
        local n = app:show_uc() and 5 or 4
        local f = app.settings.filter_mode or 1
        app.settings.filter_mode = f % n + 1
        app.save()
        ctx.win:scroll_to(0)
        ctx.win:invalidate('all')
    elseif hit.id == 'sort' then
        app.settings.sort_mode = (app.settings.sort_mode or 1) % #App.SORTS + 1
        app.save()
        ctx.win:scroll_to(0)
        ctx.win:invalidate('all')
    elseif hit.id == 'row' then
        local it = hit.item
        app:go('guide', {cat = p.cat, area = p.area, name = it.name, id = it.id, status = it.status}, ctx.scroll)
    end
end

function S.right(hit, ctx, app) app:back() end

-- the search box: printable keys type, Backspace deletes, Enter keeps the text, Escape clears;
-- -> false to give up the focus
function S.key(focus, dik, ch, ctx, app)
    if dik == 1 then                    -- Escape
        app.search = ''
        ctx.win:scroll_to(0)
        ctx.win:invalidate('content')
        return false
    elseif dik == 28 or dik == 156 then -- Enter
        return false
    elseif dik == 14 then               -- Backspace
        app.search = app.search:sub(1, -2)
    elseif ch and #app.search < 40 then
        app.search = app.search .. ch
    else
        return true
    end
    ctx.win:scroll_to(0)
    ctx.win:invalidate('content')
    return true
end

return S
