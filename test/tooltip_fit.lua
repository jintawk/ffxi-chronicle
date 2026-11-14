--[[
    test/tooltip_fit.lua - does a tooltip's text fit the box drawn for it (rule 206)? Reads the commands of a builder the way the
    DLL will: the last window (W) is the tooltip, every title (H) and text (T) after it is one row, the icon (I) sits beside the
    rows it shares height with. Widths are ops' own, the ones the DLL draws with, so this is the box the reader sees.

        local fit = dofile('test/tooltip_fit.lua')
        fit.problems(commands, ops [, window_w, window_h]) -> {message, ...}   commands: a builder's .o; window_w, _h: the box fits them too
]]

local fit = {}

fit.FRAME = 6          -- px of the box the window's frame art takes on every side (qa_render's covers use the same)
fit.ROOM = 2           -- px between the frame and the text: nothing touches the border
local ROW_H = 16       -- a row of body text
local ICON_GAP = 2

function fit.problems(commands, ops, window_w, window_h)
    local start
    for i, line in ipairs(commands) do if line:sub(1, 1) == 'W' then start = i end end
    if not start then return {'no tooltip window drawn'} end
    local x, y, w, h = commands[start]:match('^W\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)')
    x, y, w, h = tonumber(x), tonumber(y), tonumber(w), tonumber(h)
    local right, bottom = x + w - fit.FRAME - fit.ROOM, y + h - fit.FRAME
    local rows, icon = {}, nil
    for i = start + 1, #commands do
        local line = commands[i]
        local k = line:sub(1, 1)
        if k ~= 'T' and k ~= 'H' and k ~= 'I' then break end        -- what the window draws after the tooltip (the grip)
        if k == 'T' then
            local tx, ty, s = line:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
            rows[#rows + 1] = {x = tonumber(tx), y = tonumber(ty), s = s, w = ops.text_w(s), h = ROW_H}
        elseif k == 'H' then
            local tx, ty, px, s = line:match('^H\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
            px = tonumber(px)
            rows[#rows + 1] = {x = tonumber(tx), y = tonumber(ty), s = s, w = ops.title_w(s, px), h = px}
        elseif k == 'I' then
            local ix, iy, size = line:match('^I\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)')
            icon = {x = tonumber(ix), y = tonumber(iy), size = tonumber(size)}
        end
    end
    local out = {}
    for _, r in ipairs(rows) do
        if r.x + r.w > right then
            out[#out + 1] = ('tooltip text "%s" ends at %d, past the room in its box (%d)'):format(r.s, math.ceil(r.x + r.w - x), right - x)
        end
        if r.y + r.h > bottom then
            out[#out + 1] = ('tooltip text "%s" is below its box'):format(r.s)
        end
        if icon and r.y < icon.y + icon.size and r.y + r.h > icon.y and r.x < icon.x + icon.size + ICON_GAP then
            out[#out + 1] = ('tooltip text "%s" is drawn over the icon'):format(r.s)
        end
    end
    if icon and icon.y + icon.size > bottom then out[#out + 1] = 'the tooltip icon is below its box' end
    if window_w and (x < 0 or x + w > window_w) then
        out[#out + 1] = ('tooltip box %d to %d is outside the %d px window'):format(x, math.ceil(x + w), window_w)
    end
    if window_h and (y < 0 or y + h > window_h) then
        out[#out + 1] = ('tooltip box %d to %d is below the %d px window'):format(y, math.ceil(y + h), window_h)
    end
    return out
end

return fit
