--[[
    Chronicle, a Records category: its sub-categories, one row each.

    The middle level of the three the client's menu tree has. The client's own names for these
    ("Job Levels 1", "Quests 1", "Content (Dynamis 1)") say nothing on their own, so every row
    carries a line derived from the objectives inside it, its count, its gauge and how many of
    them the server is counting for you right now.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')

local S = {}
local C = kit.C

function S.chrome(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local right = common.frame(b, ctx)
    local start = common.nav(b, ctx, app, right)
    if ctx.collapsed then return nil, 40 end
    local x0, x1 = common.PAD, ctx.w - common.PAD
    local y = start
    local roe = app.roe
    local s = roe and roe.cat_summary(p.ci)
    if not s then return {x0 = x0, y0 = y, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30 end
    local pct = kit.pct(s.completed, s.total)
    local ps = s.has_data and (pct .. '%') or '--'
    local pw = ops.title_w(ps, 18)
    b:title(x1 - pw, y, 18, s.has_data and kit.tier(pct) or C.faint, ps)
    b:title(x0, y + 2, 14, C.bold, ops.fit_title(s.name, 14, x1 - x0 - pw - 30))
    y = y + 26
    local cs = s.has_data and (s.completed .. ' / ' .. s.total) or (s.pool .. ' records')
    b:text(x1 - ops.text_w(cs), y, C.dim, cs)
    local sub = #(app.roe.index().cats[p.ci].subs) .. ' sub-categories'
    if s.locked > 0 then sub = sub .. ', ' .. s.locked .. ' not unlocked yet' end
    b:text(x0, y, C.dim, ops.fit(sub, x1 - x0 - ops.text_w(cs) - 20))
    y = y + 22
    b:gauge(x0, y, x1 - x0, 7, s.total > 0 and s.completed / s.total or 0,
            s.has_data and kit.tier(pct) or C.faint)
    y = y + 18
    return {x0 = x0, y0 = y, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
end

function S.content(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local w = ctx.vw
    local roe = app.roe
    local ix = roe and roe.index()
    local c = ix and ix.cats[p.ci]
    if not c then
        common.message(b, w, 30, 'No such category')
        return 80
    end
    local y = 0
    for si = 1, #c.subs do
        local s = roe.sub_summary(p.ci, si)
        kit.subrow(b, 0, y, w, si, s, false)
        b:hit({x0 = 0, y0 = y, x1 = w, y1 = y + kit.SUBROW_H - 2, id = 'sub', ci = p.ci, si = si})
        y = y + kit.SUBROW_H
    end
    return y
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'sub' then common.wash(b, hit, to_win) end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    if hit.id == 'sub' then
        app:go('rsub', {ci = hit.ci, si = hit.si}, ctx.scroll)
    end
end

function S.right(hit, ctx, app) app:back() end

return S
