--[[
    Chronicle, one Records objective.

    Most objectives need no walkthrough: the client's own description is the whole thing, and
    the screen is that description, the goal, the rewards, the repeat flag, and the server's own
    count while the objective is in one of your slots.

    About one in six wraps a quest or mission Chronicle already documents ("San d'Oria Rank 1-1"
    is "Smash the Orcish Scouts"). Those get a link into that entry, which carries its
    walkthrough and its step progress; nothing is written here for them.

    An objective the client would not offer yet says what unlocks it, by name, because the thing
    that unlocks it is another record and the client ships every record's name.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')

local S = {}
local C = kit.C

S.TITLE_PITCH = 20
S.TITLE_LINES = 2

local BADGE = {completed = 'COMPLETED', active = 'ACTIVE', ['repeat'] = 'COMPLETED & ACTIVE',
               not_started = 'NOT STARTED', locked = 'LOCKED'}

local function num(n)
    local s = tostring(n or 0)
    local out = s:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^,', '')
    return out
end
S.num = num

-- what a failed requirement is waiting for, in one line
function S.lock_text(app, why)
    if not why then return nil end
    if why.kind == 'record' then
        return 'Unlocked by the record "' .. (why.name or ('#' .. tostring(why.id))) .. '"'
    elseif why.kind == 'unity' then
        return 'Offered only to one Unity, which is not yours'
    elseif why.kind == 'rotation_shared' then
        return 'Part of a Unity (Shared) set that is not the one being offered'
    elseif why.kind == 'rotation_leader' then
        return "Part of a Unity set your leader is not offering"
    elseif why.kind == 'client_state' then
        return 'The client is not offering this at the moment'
    end
    return 'Not offered yet'
end

function S.chrome(b, ctx)
    local app = ctx.app
    local right = common.frame(b, ctx)
    common.crumbs(b, ctx, app, right)
    if ctx.collapsed then return nil, 40 end
    local p = app.view.params
    local roe = app.roe
    local x0, x1 = common.PAD, ctx.w - common.PAD
    local y = common.TOP + 30
    local name = roe and roe.index() and roe.index().name[p.id] or '?'
    local status = roe and roe.status(p.id) or 'not_started'
    local bw = kit.badge(b, x1, y + 2, BADGE[status] or 'UNKNOWN', C[status] or C.unknown)
    local lines = ops.wrap_title(name, 16, x1 - x0 - bw - 16, x1 - x0, S.TITLE_LINES)
    for i, l in ipairs(lines) do b:title(x0, y + 2 + (i - 1) * S.TITLE_PITCH, 16, C.bold, l) end
    local top = y + 32 + (#lines - 1) * S.TITLE_PITCH
    return {x0 = x0, y0 = top, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
end

local function heading(b, w, y, text)
    return y + kit.heading(b, 0, y, w, text)
end

-- wrapped body text; -> the y under it
local function para(b, w, y, text, col)
    for _, line in ipairs(ops.wrap(text, w)) do
        b:text(0, y, col or C.text, line)
        y = y + kit.LINE
    end
    return y
end

-- "Label   value", a row of the details block
local function kv(b, w, y, label, value, col)
    b:text(0, y, C.dim, label)
    local vx = math.max(ops.text_w(label) + 14, math.min(130, math.floor(w * 0.34)))
    b:text(vx, y, col or C.text, ops.fit(value, w - vx))
    return y + kit.LINE
end

function S.content(b, ctx)
    local app = ctx.app
    local p = app.view.params
    local w = ctx.vw
    local roe = app.roe
    local o = roe and roe.objective(p.id)
    if not o then
        common.message(b, w, 30, 'No such record')
        return 80
    end
    local y = 0
    local why = roe.locked(p.id)
    if why then
        local text = S.lock_text(app, why)
        local h = kit.LINE * #ops.wrap(text, w - 20) + 10
        b:rect(0, y, w, y + h, C.well)
        kit.frame(b, 0, y, w, y + h, kit.alpha(C.locked, 110))
        para(b, w - 20, y + 5, text, C.locked)
        y = y + h + 10
    end

    -- the description: the client's own text, which for most objectives is the whole guide
    if o.desc and o.desc ~= '' then
        for _, chunk in ipairs(S.split_lines(o.desc)) do
            y = para(b, w, y, chunk, C.text)
        end
        y = y + 8
    end

    -- progress: the server's exact count while the objective is slotted, and nothing claimed
    -- when it is not, because no packet carries a count for an objective you do not have set
    if o.goal > 1 then
        y = heading(b, w, y + 4, 'Progress')
        local count = roe.progress(p.id)
        if count then
            local cs = num(count)
            local gs = ' / ' .. num(o.goal)
            local cw = ops.title_w(cs, 18)
            b:text(0, y + 4, C.dim, 'Counted by the server')
            b:title(w - cw - ops.text_w(gs), y, 18, C.active, cs)
            b:text(w - ops.text_w(gs), y + 4, C.dim, gs)
            y = y + 24
            b:gauge(0, y, w, 7, math.max(0, math.min(1, count / o.goal)), C.active)
            y = y + 16
        else
            y = para(b, w, y, 'Needs ' .. num(o.goal) ..
                     '. The server reports a count only for the records you have set, so there is '
                     .. 'none to show here.', C.faint)
            y = y + 4
        end
    end

    -- details
    y = heading(b, w, y + 6, 'Details')
    local ix = roe.index()
    local c = ix.cats[p.ci]
    y = kv(b, w, y, 'Category', (c and c.n or '?') .. '  >  ' .. ((c and c.subs[p.si] and c.subs[p.si].n) or '?'))
    y = kv(b, w, y, 'Required', o.goal > 1 and (num(o.goal) .. ' times') or 'Once')
    y = kv(b, w, y, 'Repeatable', o.repeatable and 'Yes' or 'No')
    local rw = {}
    if (o.sparks or 0) > 0 then rw[#rw + 1] = num(o.sparks) .. ' sparks' end
    if (o.exp or 0) > 0 then rw[#rw + 1] = num(o.exp) .. ' exp' end
    if (o.cp or 0) > 0 then rw[#rw + 1] = num(o.cp) .. ' capacity' end
    if (o.acc or 0) > 0 then rw[#rw + 1] = num(o.acc) .. ' accolades' end
    y = kv(b, w, y, 'Rewards', #rw > 0 and table.concat(rw, ' . ') or 'None',
           #rw > 0 and C.item or C.faint)

    -- a requirement Chronicle cannot read: say what it is, never that it is locked
    local unk = roe.unknown_gates(p.id)
    if unk then
        for _, g in ipairs(unk) do
            if g.kind == 'zone' then
                y = kv(b, w, y, 'Needs', 'a visit to ' .. (g.name or ('zone ' .. tostring(g.id)))
                       .. (roe.state.zones[g.id] and ' (seen this session)' or ''), C.zone)
            end
        end
    end
    y = y + 10

    -- the walkthrough: a link when the objective wraps an entry Chronicle documents
    y = heading(b, w, y, 'Walkthrough')
    if o.wrap then
        local cat, area, id = o.wrap:match('^([^|]+)|([^|]+)|(%-?%d+)$')
        id = tonumber(id)
        local label = (cat == 'mission' and 'Mission' or 'Quest') .. ': ' .. (o.wrap_name or '?')
        local h = 26
        b:rect(0, y, w, y + h, C.well)
        kit.frame(b, 0, y, w, y + h, C.edge)
        b:text(8, y + 4, C.npc, ops.fit(label, w - 100))
        local open = 'open in Chronicle'
        b:text(w - 8 - ops.text_w(open), y + 4, C.faint, open)
        b:hit({x0 = 0, y0 = y, x1 = w, y1 = y + h, id = 'xlink', cat = cat, area = area,
               entry = id, name = o.wrap_name})
        y = y + h + 6
        local steps = app:step_summary(cat, area, id)
        if steps then
            local cs = steps.done .. ' / ' .. steps.total
            b:text(w - ops.text_w(cs), y + 1, C.active, cs)
            local sw = kit.seg_w(steps.total, math.floor(w * 0.5), 9, 2)
            if sw then
                local sx = w - ops.text_w(cs) - 10 - (steps.total * (sw + 2) - 2)
                for k, st in ipairs(steps.states) do
                    kit.step_seg(b, sx + (k - 1) * (sw + 2), y + 1, sw, st)
                end
            end
            b:text(0, y + 1, C.dim, 'Steps')
            y = y + 20
            if steps.text then
                local lead = 'Next: '
                b:text(0, y, C.active, lead)
                b:text(ops.text_w(lead), y, C.text, ops.fit_words(steps.text, w - ops.text_w(lead)))
                y = y + kit.LINE
            end
        end
        y = para(b, w, y + 2,
                 'The steps are the linked entry\'s own; nothing is written here for this record.',
                 C.faint)
    else
        y = para(b, w, y, 'None needed. The description above is the whole record.', C.faint)
    end
    return y + 10
end

-- The client's descriptions carry real newlines ("...complete \"Bat Hunt.\"\nRequirements: ...")
function S.split_lines(s)
    local out = {}
    for chunk in (s .. '\n'):gmatch('([^\n]*)\n') do
        if chunk ~= '' then out[#out + 1] = chunk end
    end
    if #out == 0 then out[1] = s end
    return out
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'xlink' then
        local x0, y0 = to_win(hit.x0, hit.y0)
        local x1, y1 = to_win(hit.x1, hit.y1)
        kit.frame(b, x0, y0, x1, y1, C.hover_edge)
        b:rect(x0 + 1, y0 + 1, x1 - 1, y1 - 1, {255, 255, 255, 22})
    end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    if hit.id == 'xlink' then
        app:entry(hit.cat, hit.area, hit.name, hit.entry)
    end
end

function S.right(hit, ctx, app) app:back() end

return S
