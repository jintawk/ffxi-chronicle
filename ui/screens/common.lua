--[[
    Chronicle: what every screen shares. The frame (the game's window in its current type, titled
    Chronicle), the breadcrumb row and the three controls at its right: settings, collapse, close.
    Chrome hits with `tip` get a tooltip from the window.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')

local common = {}

common.PAD = 20
common.TOP = 16                 -- the breadcrumb / tab row
common.CTRL = 22                -- control button size

local C = kit.C

local function hovered(ctx, id) return ctx.hover and ctx.hover.id == id end
local function pressed(ctx, id) return ctx.pressed and ctx.pressed.id == id end
common.hovered, common.pressed = hovered, pressed

-- the frame and the controls; -> the x where the controls start (the row's right limit)
function common.frame(b, ctx, title)
    b:win(0, 0, ctx.w, ctx.h, title or 'Chronicle')
    local s = common.CTRL
    local x = ctx.w - common.PAD - 3 * s - 8
    local y = common.TOP - 2
    local function ctrl(id, tip, draw)
        kit.button(b, x, y, s, s, '', {hover = hovered(ctx, id), pressed = pressed(ctx, id)}, {id = id, tip = tip})
        draw(x, y, hovered(ctx, id) and C.gold or C.bold)
        x = x + s + 4
    end
    ctrl('settings', 'Settings', function(cx, cy, col)
        for i = 0, 2 do b:rect(cx + 6, cy + 6 + i * 4, cx + 16, cy + 8 + i * 4, col) end
    end)
    ctrl('collapse', ctx.collapsed and 'Expand' or 'Collapse', function(cx, cy, col)
        if ctx.collapsed then
            b:rect(cx + 6, cy + 10, cx + 16, cy + 12, col)
            b:rect(cx + 10, cy + 6, cx + 12, cy + 16, col)
        else
            b:rect(cx + 6, cy + 10, cx + 16, cy + 12, col)
        end
    end)
    ctrl('close', 'Hide', function(cx, cy, col)
        for i = 0, 7 do
            b:rect(cx + 7 + i, cy + 7 + i, cx + 9 + i, cy + 9 + i, col)
            b:rect(cx + 14 - i, cy + 7 + i, cx + 16 - i, cy + 9 + i, col)
        end
    end)
    return ctx.w - common.PAD - 3 * s - 8
end

-- the breadcrumb row (every screen but Home)
function common.crumbs(b, ctx, app, right)
    local items = app:crumbs()
    local h = ctx.hover and ctx.hover.id == 'crumb' and ctx.hover.i or nil
    kit.crumbs(b, common.PAD, common.TOP, items, right - common.PAD - 12, h)
end

-- the controls' clicks, shared by every screen; -> true when handled
function common.click(hit, ctx, app)
    if hit.id == 'settings' then
        if app.view.name ~= 'settings' then app:go('settings', {}, ctx.scroll) end
        return true
    elseif hit.id == 'collapse' then
        ctx.win:toggle_collapse()
        return true
    elseif hit.id == 'close' then
        if app.on_hide then app.on_hide() end
        return true
    elseif hit.id == 'crumb' then
        if hit.crumb and hit.crumb.go then hit.crumb.go() end
        return true
    end
    return false
end

-- a centred message in the content (empty states)
function common.message(b, w, y, text, col)
    local tw = ops.text_w(text)
    b:text(math.floor((w - tw) / 2), y, col or C.dim, text)
end

-- the hover of a content hit: a light wash over the row / card and a gold edge on its left
function common.wash(b, hit, to_win)
    local x0, y0 = to_win(hit.x0, hit.y0)
    local x1, y1 = to_win(hit.x1, hit.y1)
    b:rect(x0, y0, x1, y1, C.hover)
    b:rect(x0, y0, x0 + 2, y1, C.gold)
end

return common
