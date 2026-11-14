--[[
    Chronicle, one entry: name and status, the uncompletable notice, the description, the
    metadata card (NPC, zone, reward, fame, repeatable, title; wrapped, never cut), requirements
    checked against every bag and key item (item icons from the game), the chain (previous / next,
    opening in Chronicle), then the walkthrough: a page when the entry has one (pages/), otherwise
    a blank page.
]]

local kit = require('ui/kit')
local ops = require('ui/ops')
local common = require('ui/screens/common')
local App = require('core/app')
local card = require('core/card')
local D = require('ui/doc')

local S = {TITLE_LINES = 3, TITLE_PITCH = 22,      -- the quest's name: up to three lines of the title font, 22 px apart
    HANG = 10}      -- rule 87: a wrapped line of a multi-line card value (reward, titles) hangs this far in; 0 is the old card
local C = kit.C
local LINE = kit.LINE

-- The card's FAME. An entry with a level and no nation (v1 has "level 2" and no name for quest other 2, 3, 4, 8, 9; the page's row is empty) read
-- "-- (Lvl 2)", a dash standing for the nation (rule 141); it reads "Lvl 2". S.LVL_ONLY = false is the old card.
S.LVL_ONLY = true
-- Rule 145 (vision wave qots1, quest other 34 and outlands 103, 104): v1 has the level "N/A" for these (the Voidwatch ops and Monstrosity have no
-- fame), and the card read "N/A (Lvl N/A)"; a level that holds no number is no level, so the card reads "N/A". S.LVL_NUMBER = false is the old card.
S.LVL_NUMBER = true
-- Rule 146 (vision, quest other 1 18 19 21 23, outlands 3 6 202, toau 2, sandoria 117, jeuno 129): the Requirements counter and each row's
-- "(owned/count)" read the bags, and a finished quest has used its items up: "0 / 5" and "Beetle Shell (0/5)" beside a COMPLETED badge. A
-- completed entry (not repeatable, not any other status: those need the items again) draws no counter, every row Chronicle found as done,
-- and a quantity as " x5". S.DONE_REQS = false is the old card.
S.DONE_REQS = true
function S.fame_text(entry, v)
    local fame = v.fame
    local lvl = entry.fame_level
    if lvl ~= nil and S.LVL_NUMBER and not tostring(lvl):find('%d') then lvl = nil end
    if lvl then
        if fame then fame = fame .. ' (Lvl ' .. lvl .. ')'
        elseif S.LVL_ONLY then fame = 'Lvl ' .. lvl
        else fame = '-- (Lvl ' .. lvl .. ')' end
    end
    return fame or '--'
end

-- Rule 163 (vision wave qab1, quest abyssea 0 to 12, 31 to 35, 52, 60, 64, 65, 159 and more, 100+ views of 127 pages): the fame level wrapped inside
-- its bracket, "Abyssea - La Theine (Lvl" over "1)", the number alone on a line. The level is a tail that stays whole: it shares the last
-- line of the nation when it fits, else it takes a line of its own (wrap_with_tail). S.FAME_TAIL = false is the old card.
S.FAME_TAIL = true
-- the card's FAME as the cell's text and its "(Lvl N)" tail (nil when the value has no level after a nation)
function S.fame_parts(entry, v)
    local text = S.fame_text(entry, v)
    if not S.FAME_TAIL then return text end
    local head, tail = text:match('^(.-)%s+(%(Lvl %S+%))$')
    if head and head ~= '' then return head, tail, true end
    return text
end

local function current(app)
    local p = app.view.params
    local entry, status = app:guide_entry(p)
    return p, entry, status
end

function S.chrome(b, ctx)
    local app = ctx.app
    local right = common.frame(b, ctx)
    common.crumbs(b, ctx, app, right)
    if ctx.collapsed then return nil, 40 end
    local p, _, status = current(app)
    local x0, x1 = common.PAD, ctx.w - common.PAD
    local y = common.TOP + 30
    local badge = App.STATUS_TEXT[status] or 'UNKNOWN'
    local bw = kit.badge(b, x1, y + 2, badge, C[status] or C.unknown)
    -- the name wraps (a "(qualifier)" stays whole) rather than being cut: "Lure of the Wildcat (San d'Oria)" lost its
    -- qualifier at the minimum window (2026-10-20). Only the first line shares its row with the badge.
    local lines = ops.wrap_title(p.name or '?', 16, x1 - x0 - bw - 16, x1 - x0, S.TITLE_LINES)
    for i, l in ipairs(lines) do b:title(x0, y + 2 + (i - 1) * S.TITLE_PITCH, 16, C.bold, l) end
    local top = y + 32 + (#lines - 1) * S.TITLE_PITCH
    local prog = S.progress(app, p)
    if prog then top = S.strip(b, x0, x1, top, prog, p) end
    return {x0 = x0, y0 = top, x1 = x1, y1 = ctx.h - 18}, common.TOP + 30
end

-- The entry's step progress (core/progress.lua for_page), or nil when it has no step mapping (then nothing changes).
function S.progress(app, p)
    if not (app.progress and app.progress.for_page) then return nil end
    return app.progress.for_page((p.cat or '') .. '|' .. tostring(p.area) .. '|' .. tostring(p.id or p.name))
end

-- The step strip under the title (window-local, its top at y): one row per group of steps, a segment per step in its
-- state, then "Step N of M:" and the next step's bullet text, cut to fit; with nothing next, the count. Several rows
-- (a page with paths): each row's label and count, then the first next step under them. A joined row (core/progress.lua, one
-- segment per one-step group) has no order to number: its lead is the count, "Any order" while several steps are open at once
-- (never on route alternatives, where one at most is). -> the new top of the viewport.
S.STRIP_LH = 20
function S.strip(b, x0, x1, y, prog, p)
    local rows = prog.rows or {}
    if #rows == 0 then return y end
    local LH, gap = S.STRIP_LH, 3
    local pages = package.loaded['core/pages']
    local cur = pages and pages.current and pages.current()
    local doc = cur and cur.key == (p.cat or '') .. '|' .. tostring(p.area) .. '|' .. tostring(p.id or p.name) and cur.doc or nil
    local function info(r)
        local states, done, nk, ns, open = {}, 0, nil, nil, 0
        for k, i in ipairs(r.steps) do
            local st = prog.steps[i]
            states[k] = st.shown
            if st.shown == 'done' then done = done + 1 end
            if st.shown == 'next' then
                open = open + 1
                if not nk then nk, ns = k, st end
            end
        end
        return states, done, nk, ns, open
    end
    local function joined_lead(done, n, open) return (open > 1 and 'Any order, ' or '') .. done .. '/' .. n .. ': ' end
    local function step_line(tx, yy, lead, st)
        local text = doc and D.step_text(doc, st.tab, st.n, st.fp)
        if not text then lead = lead:gsub(': $', '') end
        b:text(tx, yy, C.active, ops.fit(lead, x1 - tx))
        local lx = tx + ops.text_w(lead)
        if text and x1 - lx > 30 then b:text(lx, yy, C.text, ops.fit_words(text, x1 - lx)) end       -- rule 147: cut at a word (ops.WORD_FIT = false: mid-word)
    end
    local lw = 0
    for _, r in ipairs(rows) do if r.label then lw = math.max(lw, ops.text_w(r.label)) end end
    local sx = x0 + (lw > 0 and lw + 12 or 0)
    y = y - 4
    if #rows == 1 then
        local states, done, nk, ns, open = info(rows[1])
        local n = #states
        local sw = math.max(4, math.min(22, math.floor((x1 - sx) * 0.4 / math.max(1, n)) - gap))
        if rows[1].label then b:text(x0, y + 1, C.dim, rows[1].label) end
        for k, st in ipairs(states) do kit.step_seg(b, sx + (k - 1) * (sw + gap), y + 1, sw, st) end
        local tx = sx + n * (sw + gap) - gap + 12
        if ns then
            step_line(tx, y + 1, rows[1].joined and joined_lead(done, n, open) or 'Step ' .. nk .. ' of ' .. n .. ': ', ns)
        else
            b:text(tx, y + 1, done == n and C.completed or C.dim, done .. '/' .. n)
        end
        y = y + LH
    else
        local maxn = 1
        for _, r in ipairs(rows) do maxn = math.max(maxn, #r.steps) end
        local cw = ops.text_w('00/00')
        local sw = math.max(4, math.min(22, math.floor((x1 - cw - 12 - sx + gap) / maxn) - gap))
        local first
        for _, r in ipairs(rows) do
            local states, done, nk, ns, open = info(r)
            if r.label then b:text(x0, y + 1, C.dim, ops.fit(r.label, lw)) end
            for k, st in ipairs(states) do kit.step_seg(b, sx + (k - 1) * (sw + gap), y + 1, sw, st) end
            local cs = done .. '/' .. #states
            b:text(x1 - ops.text_w(cs), y + 1, done == #states and C.completed or (ns and C.active or C.dim), cs)
            if ns and not first then
                first = {st = ns, lead = r.joined and joined_lead(done, #states, open)
                    or (r.label and r.label .. ', step ' or 'Step ') .. nk .. ' of ' .. #states .. ': '}
            end
            y = y + LH
        end
        if first then
            step_line(x0, y + 1, first.lead, first.st)
            y = y + LH
        end
    end
    y = y + 4
    b:rect(x0, y, x1, y + 1, C.rule)
    return y + 10
end

-- A value wrapped to width with a tail that stays on the line of its last word: the zone and its grid square
-- ("Southern San d'Oria (K-6)") never leave "(K-6)" alone on a line (2026-10-19, 20 San d'Oria cards).
local function wrap_with_tail(text, tail, width, whole)
    local lines = ops.wrap(text, width)
    if not tail then return lines end
    if #lines == 0 then return {tail} end
    local last = lines[#lines]
    if ops.text_w(last .. ' ' .. tail) <= width then
        lines[#lines] = last .. ' ' .. tail
        return lines
    end
    if whole then        -- rule 163: a tail of two words ("(Lvl 1)") stands whole on a line of its own
        lines[#lines + 1] = tail
        return lines
    end
    local head, word = last:match('^(.*)%s(%S+)$')
    if head then
        lines[#lines] = head
        lines[#lines + 1] = word .. ' ' .. tail
    else
        lines[#lines + 1] = tail
    end
    return lines
end

-- Rule 151 (F3): a value of many lines (REWARD of 18, 17, 12 lines) made a very tall card with the second column almost empty. A list cell
-- of S.LIST_MIN items or more (counting wrapped lines moved 301 entries and 8 items 22; 10 items is the 7 tall cards, the next is 9) spans the card and its items flow into columns (read down, then across; an item is never
-- cut or reordered); its partner cell of the row takes a row of its own. Fewer than two columns would fit: the old card. S.LIST_COLUMNS = false is the old card.
S.LIST_COLUMNS = true
S.LIST_MIN = 10
S.LIST_MAXCOLS = 4

-- Rule 164 (vision wave qab1, quest abyssea 31, 54, 56, 59, 72, 75 and more): a reward that ends in a job tag, "Ravager's Seal: Feet (WAR)",
-- wrapped before the tag and left "(WAR)" alone on a line. The three-letter job tag at the end of an item keeps its last word:
-- "Feet (WAR)" is one line (wrap_with_tail). S.JOB_TAIL = false is the old card.
S.JOB_TAIL = true
-- Rule 167 (vision wave qab1, quest abyssea 124 to 126 at 520, committed jeuno 174 and other 18 at 440): a value that ends in a bracket
-- ("Resistance Credits (Max: 70)") wrapped inside it and left only the closing fragment ("70)", "x3)") alone on a line. A last line that is
-- a closing fragment (no opening bracket, ends in ")", one or two words) takes the last word of the line above down with it, until it
-- holds three words or an opening bracket ("(Max: 70)" moves whole). width_of(i) is the room of line i; a word that would not fit stays.
-- S.PAREN_TAIL = false is the old card.
S.PAREN_TAIL = true
local function words_of(line)
    local n = 0
    for _ in line:gmatch('%S+') do n = n + 1 end
    return n
end
local function mend_paren_tail(lines, width_of)
    if not S.PAREN_TAIL then return lines end
    while #lines >= 2 do
        local last = lines[#lines]
        if type(last) ~= 'string' or not last:find('%)$') or last:find('%(') or words_of(last) > 2 then break end
        local head, word = lines[#lines - 1]:match('^(.*%S)%s+(%S+)$')
        if not head or ops.text_w(word .. ' ' .. last) > width_of(#lines) then break end
        lines[#lines - 1] = head
        lines[#lines] = word .. ' ' .. last
    end
    return lines
end

-- Rule 173 (vision wave qcw1, quest wotg 7, 8, 9, and 21 to 23): a campaign ribbon's rank is a word of its own after "Service" ("Bronze Ribbon of
-- Service S", "Brass Ribbon of Service SS": the wiki's section signs, drawn as S), so the card wrapped before it and left the rank alone on a line.
-- A value that ends in "Service" and one to four S keeps its last word with the rank. S.RANK_TAIL = false is the old card.
S.RANK_TAIL = true
local function rank_split(text)
    if not S.RANK_TAIL or type(text) ~= 'string' then return nil end
    local head, rank = ops.ascii(text):gsub('%s+', ' '):match('^(.-Service)%s(S+)$')
    if head and #rank <= 4 then return head, rank end
end

local function wrap_item(one, cw)
    local rhead, rrank = rank_split(one)
    if rhead then return wrap_with_tail(rhead, rrank, cw) end
    if S.JOB_TAIL then
        local head, tag = ops.ascii(one):gsub('%s+', ' '):match('^(.-%S)%s(%(%u%u%u%))$')
        if head then return wrap_with_tail(head, tag, cw) end
    end
    return mend_paren_tail(ops.wrap(one, cw), function() return cw end)
end

-- one list item at a column width: its lines; a wrapped rest hangs in as {text} (rule 87)
local function item_lines(one, cw)
    local pieces = wrap_item(one, cw)
    if #pieces > 1 and S.HANG > 0 then
        local s = ops.ascii(one):gsub('%s+', ' '):gsub('^ ', '')
        local rest = s:sub(#pieces[1] + 1):gsub('^ ', '')
        pieces = {pieces[1]}
        local more = wrap_item(rest, cw - S.HANG)
        if S.PAREN_TAIL and #more == 1 then      -- the whole rest is a closing fragment: it takes a word of the first line
            local joined = mend_paren_tail({pieces[1], more[1]}, function(i) return i == 1 and cw or cw - S.HANG end)
            pieces[1], more[1] = joined[1], joined[2]
        end
        for _, l in ipairs(more) do pieces[#pieces + 1] = {l} end
    end
    return pieces
end

local function cell_lines(cell, col_w)
    local lines
    if type(cell[2]) == 'table' then       -- a value of several lines (the reward): each wraps on its own
        lines = {}
        for _, one in ipairs(cell[2]) do
            for _, l in ipairs(item_lines(one, col_w)) do lines[#lines + 1] = l end
        end
    else
        local rhead, rrank = rank_split(cell[2])
        if rhead and not cell[3] then
            lines = wrap_with_tail(rhead, rrank, col_w)
        else
            lines = wrap_with_tail(cell[2], cell[3], col_w, cell[4])
        end
        mend_paren_tail(lines, function() return col_w end)
    end
    if #lines == 0 then lines = {'--'} end
    return lines
end

-- a list over n columns of the card's full width: the most columns (up to S.LIST_MAXCOLS) in which no item wraps, else two. returns the
-- columns ({lines...} each), their width and the tallest one's line count; nil when there is no room for two columns or only one item
local function list_columns(list, W, gap)
    if #list < 2 then return nil end
    local n, cw, groups = 2, 0, nil
    for k = math.min(S.LIST_MAXCOLS, #list), 2, -1 do
        local kw = math.floor((W - gap * (k - 1)) / k)
        local g, wraps = {}, 0
        for i, one in ipairs(list) do
            g[i] = item_lines(one, kw)
            if #g[i] > 1 then wraps = wraps + 1 end
        end
        if wraps == 0 or k == 2 then n, cw, groups = k, kw, g if wraps == 0 then break end end
    end
    local total, tallest = 0, 0
    for _, g in ipairs(groups) do total = total + #g tallest = math.max(tallest, #g) end
    local H = math.max(tallest, math.ceil(total / n))
    while true do
        local cols, h = {{}}, 0
        for _, g in ipairs(groups) do
            if h + #g > H and h > 0 then cols[#cols + 1] = {} h = 0 end
            for _, l in ipairs(g) do cols[#cols][#cols[#cols] + 1] = l end
            h = h + #g
        end
        if #cols <= n then return cols, cw, H end
        H = H + 1
    end
end

-- label / value pairs in two columns; values wrap inside their column ({label, text, tail}: see wrap_with_tail)
local function meta_card(b, y, w, rows)
    local pad, gap = 10, 14
    local col_w = math.floor((w - pad * 2 - gap) / 2)
    local top = y
    local items = {}
    local cy = y + pad
    local function plain_row(cells)      -- cells side by side, values wrapped in their column
        local lh = 0
        for c, cell in ipairs(cells) do
            local lines = cell_lines(cell, col_w)
            items[#items + 1] = {x = pad + (c - 1) * (col_w + gap), y = cy, label = cell[1], lines = lines}
            lh = math.max(lh, #lines)
        end
        cy = cy + 16 + lh * LINE + 6
    end
    for _, r in ipairs(rows) do
        local wide
        if S.LIST_COLUMNS then
            for c = 1, 2 do
                if not wide and type(r[c][2]) == 'table' and #r[c][2] >= S.LIST_MIN then
                    local cols, cw, H = list_columns(r[c][2], w - pad * 2, gap)
                    if cols then wide = {c = c, cols = cols, cw = cw, H = H} end
                end
            end
        end
        if wide then
            local function span()
                items[#items + 1] = {x = pad, y = cy, label = r[wide.c][1], cols = wide.cols, cw = wide.cw, gap = gap}
                cy = cy + 16 + wide.H * LINE + 6
            end
            if wide.c == 2 then plain_row({r[1]}) span() else span() plain_row({r[2]}) end
        else
            plain_row({r[1], r[2]})
        end
    end
    local h = cy - top + pad - 6
    b:rect(0, top, w, top + h, C.well)
    kit.frame(b, 0, top, w, top + h, C.edge)
    local function draw_lines(x, y0, lines)
        for i, l in ipairs(lines) do
            if type(l) == 'table' then b:text(x + S.HANG, y0 + (i - 1) * LINE, C.bold, l[1])
            else b:text(x, y0 + (i - 1) * LINE, C.bold, l) end
        end
    end
    for _, it in ipairs(items) do
        b:text(it.x, it.y, C.faint, it.label)
        if it.cols then
            for k, col in ipairs(it.cols) do draw_lines(it.x + (k - 1) * (it.cw + it.gap), it.y + 16, col) end
        else
            draw_lines(it.x, it.y + 16, it.lines)
        end
    end
    return top + h
end

function S.content(b, ctx)
    local app = ctx.app
    local w = ctx.vw
    local p, entry, status = current(app)
    local blocks = {}
    local y = 0
    if not entry then
        common.message(b, w, 20, p.cat == 'mission' and 'No data available for this mission.'
            or 'No data available for this quest.', C.unknown)
        return 60
    end
    if status == 'uncompletable' then
        b:rect(0, y, w, y + 24, kit.alpha(C.uncompletable, 46))
        b:text(8, y + 4, C.uncompletable, 'This quest cannot currently be completed.')
        y = y + 32
    end
    if entry.description and entry.description ~= '' then
        blocks[#blocks + 1] = y
        for _, l in ipairs(ops.wrap(entry.description, w - 8)) do
            b:text(4, y, {170, 214, 236}, l)
            y = y + LINE
        end
        y = y + 8
    end
    -- metadata
    blocks[#blocks + 1] = y
    local v = card.fields(entry)
    local reward = card.reward_lines(v.reward) or '--'
    y = meta_card(b, y, w, {
        {{'NPC', v.npc or '--'}, {'ZONE', card.zone_parts(entry)}},
        {{'REWARD', reward}, {'FAME', S.fame_parts(entry, v)}},
        {{'REPEATABLE', card.printed(entry).repeatable}, {'TITLE', card.title_lines(v.title) or '--'}},
    }) + 14
    -- requirements
    local reqs = app:requirements(p.cat .. '|' .. tostring(p.area) .. '|' .. tostring(p.name), entry, app.check_requirements)
    if reqs and #reqs > 0 then
        blocks[#blocks + 1] = y
        -- the counter adds up what the rows below count: units owned of units needed, over the rows Chronicle can
        -- find (a dash row cannot be counted, so a list of dashes has no counter; 2026-10-19: "0 / 0", and "0 / 1"
        -- above "Rabbit Hide (0/3)")
        local done = S.DONE_REQS and status == 'completed'
        local have, need = 0, 0
        for _, r in ipairs(reqs) do
            if r.found and not r.choice then
                local c = r.count or 1
                need = need + c
                have = have + math.min(r.owned, c)
            end
        end
        local counter = need > 0 and not done and (have .. ' / ' .. need) or nil
        y = y + kit.heading(b, 0, y, w - (counter and ops.text_w(counter) + 14 or 0), 'Requirements')
        if counter then b:text(w - ops.text_w(counter), y - 21, have >= need and C.completed or C.active, counter) end
        for i, r in ipairs(reqs) do
            local req = entry.requirements[i]
            local x = 8
            if r.sep then
                -- the "or" between alternatives: a word of its own, no mark
                b:text(x + 26, y, C.faint, 'or')
                y = y + LINE + 2
            else
                local owned = done and r.found and r.count or r.owned       -- a finished entry has what it needed
                if r.found and req and req.id and not req.ki then
                    b:icon(x, y - 1, 18, req.id)
                elseif r.found then
                    kit.mark(b, x + 4, y + 3, owned >= r.count and 'completed' or 'active')
                else
                    b:text(x, y, C.faint, '-')
                end
                x = x + 26
                local label = r.name
                if r.count and r.count > 1 then
                    label = label .. (done and r.found and (' x' .. r.count) or (' (' .. r.owned .. '/' .. r.count .. ')'))
                end
                local col = not r.found and C.dim or (owned >= r.count and C.completed or C.active)
                local lines = ops.wrap(label, w - x)
                for _, l in ipairs(lines) do b:text(x, y, col, l) y = y + LINE end
                y = y + 2
            end
        end
        y = y + 10
    end
    -- the chain
    local function chain(label, names, dir)
        if not names or #names == 0 then return end
        b:text(0, y, C.dim, label)
        local x = 90
        for _, n in ipairs(names) do
            local s = ops.fit(n, w - x)
            local tw = ops.text_w(s)
            if app:chain_target(p.cat, p.area, n) then
                b:text(x, y, C.quest, s)
                b:rect(x, y + 15, x + tw, y + 16, kit.alpha(C.quest, 110))
                b:hit({x0 = x, y0 = y, x1 = x + tw, y1 = y + 16, id = 'chain', name = n, dir = dir})
            else
                -- a quest Chronicle has no entry for ("Petals of Recollection"): its name, not a link that finds nothing
                b:text(x, y, C.dim, s)
            end
            y = y + LINE
        end
        y = y + 4
    end
    if entry.previous or entry.next then
        blocks[#blocks + 1] = y
        chain('< Previous', entry.previous, 'prev')
        chain('> Next', entry.next, 'next')
        y = y + 10
    end
    -- the walkthrough
    blocks[#blocks + 1] = y
    if app.walkthrough then             -- a page opens with its own "Walkthrough" heading
        ctx.progress = S.progress(app, p)          -- the step checkboxes (ui/doc.lua), nil without a step mapping
        local h, wblocks = app.walkthrough(b, ctx, p, y, w)
        if h then
            for _, by in ipairs(wblocks or {}) do blocks[#blocks + 1] = by end
            return h + 10, blocks
        end
    end
    y = y + kit.heading(b, 0, y, w, 'Walkthrough')
    b:text(0, y, C.faint, 'No walkthrough yet.')
    y = y + LINE + 10
    return y, blocks
end

-- the reader scrolled: does the walkthrough have a picture in view that it drew with no texture? Then it is laid out again.
function S.scrolled(ctx)
    return ctx.app.walkthrough_view ~= nil and ctx.app.walkthrough_view(ctx) or false
end

function S.overlay(b, ctx, hit, to_win)
    if hit.id == 'chain' then
        local x0, y0 = to_win(hit.x0, hit.y0)
        local x1, y1 = to_win(hit.x1, hit.y1)
        b:rect(x0, y1 - 1, x1, y1, C.gold)
    elseif ctx.app.walkthrough_overlay then
        ctx.app.walkthrough_overlay(b, ctx, hit, to_win)
    end
end

function S.tooltip(b, ctx, hit, to_win)
    if hit.id == 'chain' then
        local _, y0 = to_win(hit.x0, hit.y0)
        local _, y1 = to_win(hit.x0, hit.y1)
        local mx = ctx.win.mouse_at and ctx.win.mouse_at.x or to_win(hit.x0, 0)
        local kind = ctx.app.view.params.cat == 'mission' and 'Mission' or 'Quest'
        kit.tooltip(b, mx + 14, y1 + 8, hit.name, {{kind .. '  (opens in Chronicle)', C.quest}}, nil, ctx.w, ctx.h, y0)
    elseif ctx.app.walkthrough_tooltip then
        ctx.app.walkthrough_tooltip(b, ctx, hit, to_win)
    end
end

-- the walkthrough's sticky tab bar, when its tab strip has scrolled out of view
function S.sticky(b, ctx)
    if ctx.app.walkthrough_sticky then ctx.app.walkthrough_sticky(b, ctx) end
end

function S.click(hit, ctx, app)
    if common.click(hit, ctx, app) then return end
    local p = app.view.params
    if hit.id == 'chain' then
        if not app:open_chain(p.cat, p.area, hit.name) and app.say then app.say('Not found: ' .. hit.name) end
    elseif app.walkthrough_click then
        app.walkthrough_click(hit, ctx)
    end
end

function S.right(hit, ctx, app) app:back() end

return S
