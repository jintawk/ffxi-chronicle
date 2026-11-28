--[[
    Chronicle, Settings: what v1 set only by commands, in one place. Each row is a label and a
    button that changes it; everything is saved at once.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')

local S = {}
local C = kit.C

local ROW = 34

-- the rows: label, current value text, what a click does (app.prefs holds the actions)
local function rows(app)
    local s, pr = app.settings, app.prefs
    local wt = pr.wintype()
    return {
        {key = 'visible_on_load', label = 'Show on load', value = s.visible_on_load and 'On' or 'Off'},
        {key = 'show_uncompletable', label = 'Show uncompletable', value = s.show_uncompletable and 'On' or 'Off'},
        {key = 'size', label = 'Size', value = string.format('%.1f', s.size or 1), steps = true},
        {key = 'scale', label = 'Scale', value = pr.scale_name()},
        {key = 'wintype', label = 'Window type', value = wt},
        {key = 'pad', label = 'Controller', value = s.pad ~= false and 'On' or 'Off'},
        {key = 'pad_chord', label = 'Controller buttons', value = pr.pad_chord and pr.pad_chord() or 'L3+R3'},
        {key = 'nav', label = 'Keyboard', value = s.nav ~= false and 'On' or 'Off'},
        {key = 'nav_key', label = 'Keyboard key', value = pr.nav_key and pr.nav_key() or 'K'},
        {key = 'auto_hide', label = 'Hide on Back', value = s.auto_hide == true and 'On' or 'Off'},
        {key = 'reset', label = 'Place and size', value = 'Reset'},
    }
end
S.rows = rows

function S.chrome(b, ctx)
    local right = common.frame(b, ctx)
    common.nav(b, ctx, ctx.app, right)
    if ctx.collapsed then return nil, 40 end
    local y = common.TOP + 34
    return {x0 = common.PAD, y0 = y, x1 = ctx.w - common.PAD, y1 = ctx.h - 18}, common.TOP + 30
end

function S.content(b, ctx)
    local app = ctx.app
    local w = ctx.vw
    local y = 0
    for n, r in ipairs(rows(app)) do
        if n % 2 == 0 then b:rect(0, y, w, y + ROW - 2, C.stripe) end
        b:text(10, y + 8, C.bold, r.label)
        local bw = math.max(90, kit.button_w(r.value, 10))
        local x = w - 10 - bw
        if r.steps then
            x = x - 30
            kit.button(b, x - 30, y + 5, 26, 22, '-', {}, {id = 'set', key = r.key, step = -1})
            kit.button(b, x, y + 5, bw, 22, r.value, {dim = true}, {id = 'noop'})
            kit.button(b, x + bw + 4, y + 5, 26, 22, '+', {}, {id = 'set', key = r.key, step = 1})
        else
            kit.button(b, x, y + 5, bw, 22, r.value, {}, {id = 'set', key = r.key})
        end
        y = y + ROW
    end
    y = y + 12
    b:text(10, y, C.faint, 'Right-click: back.  //' .. (app.short or 'cr') .. ' help: commands.')
    return y + 30
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'set' then
        local x0, y0 = to_win(hit.x0, hit.y0)
        local x1, y1 = to_win(hit.x1, hit.y1)
        kit.frame(b, x0, y0, x1, y1, C.hover_edge)
    end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    if hit.id == 'set' then
        app.prefs.change(hit.key, hit.step)
        ctx.win:invalidate('all')
    end
end

function S.right(hit, ctx, app) app:back() end

return S
