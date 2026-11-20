--[[
    Chronicle, a Records sub-category: its objectives, one row each.

    The same list pipeline as a quest area (core/app.lua roe_items): search, Sort, Show. A row
    carries the status mark, the objective's name, what it is about, and on the right the
    server's own count when the objective is in one of your slots.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')
local App = require('core/app')

local S = {focusable = {search = true}}
local C = kit.C

-- what the row says under the name
local function subtitle(it)
    if it.wrap_name then return 'Completes ' .. it.wrap_name end
    local d = it.desc
    if not d or d == '' then return nil end
    return (d:match('^[^\n]*'))
end

function S.chrome(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local right = common.frame(b, ctx)
    local start = common.nav(b, ctx, app, right)
    if ctx.collapsed then return nil, 40 end
    local x0, x1 = common.PAD, ctx.w - common.PAD
    local y = start
    local roe = app.roe
    local s = roe and roe.sub_summary(p.ci, p.si)
    if not s then return {x0 = x0, y0 = y, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30 end
    local pct = kit.pct(s.completed, s.total)
    local ps = s.has_data and (pct .. '%') or '--'
    local pw = ops.title_w(ps, 18)
    b:title(x1 - pw, y, 18, s.has_data and kit.tier(pct) or C.faint, ps)
    b:title(x0, y + 2, 14, C.bold, ops.fit_title(s.name, 14, x1 - x0 - pw - 30))
    y = y + 26
    local cs = s.has_data and (s.completed .. ' / ' .. s.total) or (s.pool .. ' records')
    b:text(x1 - ops.text_w(cs), y, C.dim, cs)
    b:text(x0, y, C.dim, ops.fit(s.hint or '', x1 - x0 - ops.text_w(cs) - 20))
    y = y + 22
    b:gauge(x0, y, x1 - x0, 7, s.total > 0 and s.completed / s.total or 0,
            s.has_data and kit.tier(pct) or C.faint)
    y = y + 18
    local show_s = 'Show: ' .. App.ROE_FILTERS[app:roe_filter()]
    local sort_s = 'Sort: ' .. App.ROE_SORTS[app:roe_sort()]
    local show_w, sort_w = kit.button_w(show_s, 8), kit.button_w(sort_s, 8)
    local sx = x1 - show_w
    kit.button(b, sx, y, show_w, 22, show_s,
        {hover = common.hovered(ctx, 'filter'), pressed = common.pressed(ctx, 'filter')},
        {id = 'filter', tip = 'Click to change'})
    sx = sx - 8 - sort_w
    kit.button(b, sx, y, sort_w, 22, sort_s,
        {hover = common.hovered(ctx, 'sort'), pressed = common.pressed(ctx, 'sort')},
        {id = 'sort', tip = 'Click to change'})
    local iw = math.max(120, math.min(240, sx - 12 - x0))
    kit.input(b, x0, y, iw, app.search, 'Search...', ctx.focus == 'search', ctx.caret,
              common.hovered(ctx, 'search'))
    y = y + 32
    return {x0 = x0, y0 = y, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
end

function S.content(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local w = ctx.vw
    local roe = app.roe
    if not (roe and roe.index()) then
        common.message(b, w, 30, 'No Records catalogue')
        return 80
    end
    local items, sub = app:roe_items(p.ci, p.si)
    if not sub then
        common.message(b, w, 30, 'No such sub-category')
        return 80
    end
    if #items == 0 then
        common.message(b, w, 30, 'No matching records')
        return 80
    end
    local y = 0
    for n, it in ipairs(items) do
        local row = {name = it.name, status = it.status, sub = subtitle(it), rep = it.repeatable}
        if it.count and it.goal > 1 then
            row.badge = it.count .. ' / ' .. it.goal
            row.bar = it.count / it.goal
            row.badge_col = C.active
        elseif it.status == 'locked' then
            row.badge = 'LOCKED'
        elseif it.goal > 1 then
            row.badge = '0 / ' .. it.goal
            row.badge_col = C.faint
        end
        kit.row(b, 0, y, w, n, row, false)
        b:hit({x0 = 0, y0 = y, x1 = w, y1 = y + kit.ROW_H - 2, id = 'obj', oid = it.id})
        y = y + kit.ROW_H
    end
    return y
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'obj' then common.wash(b, hit, to_win) end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    local p = app.view.params
    if hit.id == 'filter' then
        app.settings.roe_filter_mode = app:roe_filter() % #App.ROE_FILTERS + 1
        app.save()
        ctx.win:scroll_to(0)
        ctx.win:invalidate('all')
    elseif hit.id == 'sort' then
        app.settings.roe_sort_mode = app:roe_sort() % #App.ROE_SORTS + 1
        app.save()
        ctx.win:scroll_to(0)
        ctx.win:invalidate('all')
    elseif hit.id == 'obj' then
        app:go('robj', {ci = p.ci, si = p.si, id = hit.oid}, ctx.scroll)
    end
end

function S.right(hit, ctx, app) app:back() end

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
