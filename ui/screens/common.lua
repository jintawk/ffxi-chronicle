--[[
    Chronicle: what every screen shares. The frame (the game's window in its current type, titled
    Chronicle), the tab row with the way back under it, and the three controls at its right:
    settings, collapse, close.
    Chrome hits with `tip` get a tooltip from the window.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')

local common = {}

common.PAD = 20
common.TOP = 16                 -- the tab row
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

common.TABS = {'Missions', 'Quests', 'Records'}
common.CATS = {'mission', 'quest', 'records'}
common.UP_H = 16                -- the parent line under the tabs

-- Which tab is lit: what the screen on show belongs to, not only what the setting says. A
-- cross-link opens a record from a quest page and a quest from a record, and a tab that stayed
-- on the setting would then name the wrong section on screen.
function common.tab_index(app)
    local v = app.view or {}
    local t = app.settings.active_tab
    if v.name == 'rcat' or v.name == 'rsub' or v.name == 'robj' then
        t = 'records'
    elseif v.name == 'area' or v.name == 'guide' then
        t = (v.params and v.params.cat) or t
    end
    for i, n in ipairs(common.CATS) do if n == t then return i end end
    return 1
end

-- The header every screen shares: the three tabs, and under them the way back.
--
-- The tabs never leave, so the screen you are on always says which of the three sections it
-- belongs to, and each tab is that section's home button. That is why nothing draws a "Home"
-- crumb any more: home is the lit tab. A screen one level in (an area, a record category) has
-- nothing above it but home, so it draws no line at all; deeper screens draw their parent.
--
-- -> the y the screen's own title starts at.
function common.nav(b, ctx, app, right)
    -- 'navtab', not 'tab': a walkthrough page's own path tabs use 'tab' in the content
    local hover = ctx.hover and ctx.hover.id == 'navtab' and ctx.hover.i or nil
    kit.tabs(b, common.PAD, common.TOP - 2, common.TABS, common.tab_index(app), hover, 'navtab')
    local items = app:crumbs()
    -- items[1] is the tab's own home, items[#items] is this screen
    if #items < 3 then return common.TOP + 30 end
    local up = items[#items - 1]
    if not up.go then return common.TOP + 30 end
    local y = common.TOP + 24
    local on = hovered(ctx, 'up')
    local label = '< ' .. ops.fit_tail(up.label, math.max(40, right - common.PAD - 24))
    local w = ops.text_w(label)
    b:text(common.PAD, y, on and C.gold_soft or C.npc, label)
    if on then b:rect(common.PAD, y + 15, common.PAD + w, y + 16, C.gold_soft) end
    b:hit({x0 = common.PAD - 4, y0 = y - 2, x1 = common.PAD + w + 4, y1 = y + common.UP_H,
           id = 'up', crumb = up})
    return common.TOP + 30 + common.UP_H
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
    elseif hit.id == 'crumb' or hit.id == 'up' then
        if hit.crumb and hit.crumb.go then hit.crumb.go() end
        return true
    elseif hit.id == 'navtab' then
        -- a tab is its section's home from any depth, so it always lands on that home rather
        -- than on whatever was last open there: one tab, one meaning, everywhere
        app.settings.active_tab = common.CATS[hit.i] or 'mission'
        app.save()
        if app.view.name ~= 'home' then app:home() end
        ctx.win:scroll_to(0)
        ctx.win:invalidate('all')
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
