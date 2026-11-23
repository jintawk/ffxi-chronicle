--[[
    Chronicle: walkthrough pages. From the layout proof of concept (PM 4-3, which
    passed in game), changed to draw into a ui/ops builder inside the guide's content
    and extended with:
      - tab groups (@tabs / @tab / @head / @end): a strip of tabs; only the active panel is laid out,
        under its own header (the panel's infobox fields)
      - links with a resolved third field (a mission / quest's Chronicle name, an item's id), item
        icons by id (drawn from the game's DATs), key items as a small gold mark
      - pictures from core/pics.lua: drawn when present, a frame saying "Loading" while fetched,
        the caption alone if the download failed
      - h5 headings, numbered lists

        local D = require('ui/doc')
        local doc = D.decode(page_table)                -- the markup -> blocks
        local h, tops = D.draw(b, doc, x0, y0, W, opts) -- lay out and draw at content (x0, y0)
    opts = {tabs = {[group] = index}, pics = function(file) -> tex | 'loading' | 'failed', card = set of the guide
            card's fields with a value (core/card.shown): the page header leaves those out}
    Hits: {id = 'link', span}, {id = 'picture', file}, {id = 'tab', group, i}.
]]

local ops = require('ui/ops')
local kit = require('ui/kit')

local D = {}

local LINE = 18
local ICON = 18
local INDENT = 20
local FLOAT_MIN = 540
local PIC_FLOAT = 168             -- the width of a picture floated at the right
local GALLERY_PIC = 160           -- the width a gallery's picture is aimed at in a wide window (three across at the first width that floats)
-- A picture at least this much wider than tall (two screenshots side by side, 746 x 285) is not floated at 168 px, where nothing in
-- it can be read: it is a block of its own, up to 460 px wide.
local WIDE_PIC = 1.7
local C = kit.C
local alpha = kit.alpha

local text_w, title_w = ops.text_w, ops.title_w
local ascii = ops.ascii

-- ------------------------------------------------------------------------------------- decode
local KIND = {n = 'npc', z = 'zone', i = 'item', k = 'ki', m = 'mob', q = 'quest', M = 'mission', s = 'spell', p = 'page'}

local function unesc(s) return (s:gsub('\\(.)', '%1')) end

-- a table row's cells: split at '|' outside {...} (a link's own fields are split by '|' inside its braces)
local function cells_of(s)
    local out, cur, i, depth = {}, {}, 1, 0
    while i <= #s do
        local ch = s:sub(i, i)
        if ch == '\\' then cur[#cur + 1] = s:sub(i, i + 1) i = i + 2
        else
            if ch == '{' then depth = depth + 1 elseif ch == '}' and depth > 0 then depth = depth - 1 end
            if ch == '|' and depth == 0 then out[#out + 1] = table.concat(cur) cur = {}
            else cur[#cur + 1] = ch end
            i = i + 1
        end
    end
    out[#out + 1] = table.concat(cur)
    return out
end

local function fields(s)
    local out, cur, i = {}, {}, 1
    while i <= #s do
        local ch = s:sub(i, i)
        if ch == '\\' then cur[#cur + 1] = s:sub(i, i + 1) i = i + 2
        elseif ch == '|' then out[#out + 1] = table.concat(cur) cur = {} i = i + 1
        else cur[#cur + 1] = ch i = i + 1 end
    end
    out[#out + 1] = table.concat(cur)
    return out
end

function D.inline(s)
    local spans, buf = {}, {}
    local bold, ital = false, false
    local function style(t)
        if bold then t.b = true end
        if ital then t.i = true end
        return t
    end
    local function flush()
        if #buf > 0 then spans[#spans + 1] = style({t = 'text', s = table.concat(buf)}) buf = {} end
    end
    local i = 1
    while i <= #s do
        local ch = s:sub(i, i)
        if ch == '\\' then
            buf[#buf + 1] = s:sub(i + 1, i + 1) i = i + 2
        elseif s:sub(i, i + 1) == '**' then
            flush() bold = not bold i = i + 2
        elseif s:sub(i, i + 1) == '__' then
            flush() ital = not ital i = i + 2
        elseif ch == '{' then
            local j = i + 1
            while j <= #s and s:sub(j, j) ~= '}' do j = j + (s:sub(j, j) == '\\' and 2 or 1) end
            local body = s:sub(i + 1, j - 1)
            flush()
            if body == 'br' then spans[#spans + 1] = {t = 'br'}
            elseif body == 'R' then spans[#spans + 1] = {t = 'tag', s = 'Rare'}
            elseif body == 'E' then spans[#spans + 1] = {t = 'tag', s = 'Ex'}
            elseif body == '@k' then spans[#spans + 1] = {t = 'icon', icon = 'ki', label = 'Key Item'}
            elseif body:sub(1, 3) == '@i:' then
                local f = fields(body:sub(4))
                spans[#spans + 1] = {t = 'icon', icon = 'item', name = unesc(f[1]), id = tonumber(f[2])}
            elseif body:sub(1, 1) == '@' then
                local f = fields(body:sub(4))
                spans[#spans + 1] = {t = 'icon', icon = body:sub(2, 2) == 'a' and 'aggro' or 'img',
                                     label = unesc(f[1]), hint = f[2] and unesc(f[2]) or nil}
            elseif body:sub(1, 2) == 'c=' then
                local c, txt = body:match('^c=([^:]+):(.*)$')
                spans[#spans + 1] = style({t = 'text', s = unesc(txt or ''), color = c})
            else
                local code, rest = body:match('^(%a):(.*)$')
                local f = fields(rest or '')
                local text = unesc(f[1])
                local to = (f[2] and f[2] ~= '') and unesc(f[2]) or text
                local kind = KIND[code] or 'page'
                local sp = style({t = 'link', s = text, to = to, kind = kind})
                if f[3] then
                    if kind == 'item' then sp.id = tonumber(f[3]) else sp.name = unesc(f[3]) end
                end
                spans[#spans + 1] = sp
            end
            i = j + 1
        else
            buf[#buf + 1] = ch i = i + 1
        end
    end
    flush()
    local out = {}
    for _, sp in ipairs(spans) do
        if sp.t == 'text' and not sp.color and sp.s:find('%(%u%-%d%d?%)') then
            local pos = 1
            for a, e in function() return sp.s:find('%(%u%-%d%d?%)', pos) end do
                if a > pos then local t = {} for k, v in pairs(sp) do t[k] = v end t.s = sp.s:sub(pos, a - 1) out[#out + 1] = t end
                out[#out + 1] = {t = 'coord', s = sp.s:sub(a, e)}
                pos = e + 1
            end
            if pos <= #sp.s then local t = {} for k, v in pairs(sp) do t[k] = v end t.s = sp.s:sub(pos) out[#out + 1] = t end
        else
            out[#out + 1] = sp
        end
    end
    return out
end

-- page table (pages/<cat>s/<area>/<id>.lua) -> {title, meta, blocks, images, tabs = {groups}}
function D.decode(mk)
    local doc = {page = mk.page, title = mk.title, source = mk.source, images = mk.images or {}, meta = {}, blocks = {}}
    for k, v in pairs(mk.meta or {}) do doc.meta[k] = D.inline(v) end
    -- the page's infobox in the infobox's own order (mk.meta_order; a Lua table has none): drawn as a header
    -- on a page without tabs
    doc.head = {}
    do
        local seen = {}
        for _, k in ipairs(mk.meta_order or {}) do
            if doc.meta[k] and not seen[k] then seen[k] = true doc.head[#doc.head + 1] = {key = k, spans = doc.meta[k]} end
        end
        local rest = {}
        for k in pairs(doc.meta) do if not seen[k] then rest[#rest + 1] = k end end
        table.sort(rest)
        for _, k in ipairs(rest) do doc.head[#doc.head + 1] = {key = k, spans = doc.meta[k]} end
    end
    local stack = {doc.blocks}
    local list, list_stack
    local tbl
    local group, panel = nil, nil
    local groups = 0
    local function target() return stack[#stack] end
    for line in (mk.body .. '\n'):gmatch('([^\n]*)\n') do
        local lead, marks, rest = line:match('^(:*)([%*%+]+) (.*)$')
        if marks then
            local depth = #marks
            if not list or list.indent ~= #lead then
                list = {k = 'list', ordered = marks:sub(1, 1) == '+', indent = #lead, items = {}}
                target()[#target() + 1] = list
                list_stack = {list.items}
            end
            while #list_stack > depth do table.remove(list_stack) end
            local item = {spans = D.inline(rest), children = {}}
            local parent = list_stack[depth] or list_stack[#list_stack]
            parent[#parent + 1] = item
            list_stack[depth + 1] = item.children
        else
            list = nil
            local was_tbl = tbl
            tbl = nil
            if line == '' then
            elseif line:sub(1, 1) == '|' then
                -- a table row: '|' ('^' after it for a header row), then the cells split by '|'. A cell may start '~r2c3h~':
                -- rowspan 2, colspan 3, a th cell (h)
                tbl = was_tbl
                if not tbl then
                    tbl = {k = 'table', rows = {}}
                    target()[#target() + 1] = tbl
                end
                local f = cells_of(line:sub(2))
                local head = false
                if f[1]:sub(1, 1) == '^' then head = true f[1] = f[1]:sub(2) end
                local cells = {}
                for _, raw in ipairs(f) do
                    local mark, text = raw:match('^~(%w*)~(.*)$')
                    local cell = {rs = 1, cs = 1, th = head}
                    if mark then
                        cell.rs = tonumber(mark:match('r(%d+)')) or 1
                        cell.cs = tonumber(mark:match('c(%d+)')) or 1
                        if mark:find('h') then cell.th = true end
                    end
                    cell.spans = D.inline(mark and text or raw)
                    cells[#cells + 1] = cell
                end
                tbl.rows[#tbl.rows + 1] = {head = head, cells = cells}
            elseif line == '@tabs' then
                groups = groups + 1
                group = {k = 'tabs', group = groups, tabs = {}}
                target()[#target() + 1] = group
            elseif line:sub(1, 5) == '@tab ' and group then
                if panel then table.remove(stack) end
                local f = fields(line:sub(6))
                panel = {label = unesc(f[1]), sub = unesc(f[2] or ''), head = {}, blocks = {}}
                group.tabs[#group.tabs + 1] = panel
                stack[#stack + 1] = panel.blocks
            elseif line:sub(1, 6) == '@head ' and panel then
                local f = fields(line:sub(7))
                local key = unesc(f[1])
                local val = table.concat(f, '|', 2)
                panel.head[#panel.head + 1] = {key = key, spans = D.inline(val)}
            elseif line == '@end' then
                if panel then table.remove(stack) end
                group, panel = nil, nil
            elseif line:match('^=%d ') then
                target()[#target() + 1] = {k = 'h', level = tonumber(line:sub(2, 2)), spans = D.inline(line:sub(4))}
            elseif line:sub(1, 1) == '>' then
                target()[#target() + 1] = {k = 'sub', spans = D.inline(line:sub(2))}
            elseif line == '----' then
                target()[#target() + 1] = {k = 'rule'}
            elseif line:sub(1, 1) == '!' then
                local f = fields(line:sub(2))
                target()[#target() + 1] = {k = 'image', file = unesc(f[1]), float = f[2] ~= '' and f[2] or nil,
                                           caption = D.inline(f[3] or '')}
            elseif line:sub(1, 1) == '[' then
                local box = {k = 'box', title = D.inline(line:sub(2)), blocks = {}}
                target()[#target() + 1] = box
                stack[#stack + 1] = box.blocks
            elseif line == ']' then
                table.remove(stack)
            else
                if line:sub(1, 1) == '\\' then line = line:sub(2) end
                target()[#target() + 1] = {k = 'p', spans = D.inline(line)}
            end
        end
    end
    doc.tabbed = groups > 0
    return doc
end

-- a step bullet's text folded for its fingerprint (core/progress_engine: icon spans skipped, lower case, words only)
function D.fold(spans) return require('core/progress_engine').fold(spans or {}) end

-- The text of a step's bullet as the page shows it (icons left out, one line), found as D.draw counts steps: the n-th item of
-- the lists directly in the tab labelled `tab` (nil: the page outside tabs). nil when there is no such bullet or it no
-- longer starts with fp.
function D.step_text(doc, tab, n, fp)
    local found
    local function walk(blocks, sec)
        local k = 0
        for _, bl in ipairs(blocks) do
            if bl.k == 'list' then
                for _, it in ipairs(bl.items) do
                    k = k + 1
                    if sec == (tab or '') and k == n then found = it end
                end
            elseif bl.k == 'tabs' then
                for _, t in ipairs(bl.tabs) do walk(t.blocks, t.label or '') end
            end
        end
    end
    walk(doc.blocks, '')
    if not found or (fp and D.fold(found.spans):sub(1, #fp) ~= fp) then return nil end
    local t = {}
    for _, sp in ipairs(found.spans) do if sp.t ~= 'icon' then t[#t + 1] = sp.s or '' end end
    return (ascii(table.concat(t)):gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', ''))
end

-- every tab label of the page -> {group, index} (a link to a path switches to its tab)
function D.tab_names(doc)
    local out = {}
    local function walk(bs)
        for _, b in ipairs(bs) do
            if b.k == 'tabs' then
                for i, t in ipairs(b.tabs) do
                    out[t.label:lower()] = {group = b.group, i = i}
                    for _, h in ipairs(t.head) do
                        if h.key == 'Name' then
                            local s = ''
                            for _, sp in ipairs(h.spans) do s = s .. (sp.s or '') end
                            out[s:lower()] = {group = b.group, i = i}
                        end
                    end
                    walk(t.blocks)
                end
            elseif b.k == 'box' then walk(b.blocks) end
        end
    end
    walk(doc.blocks)
    return out
end

-- the labels a panel header draws for its infobox fields (the field name otherwise)
D.HEAD_LABEL = {['Starting NPC'] = 'Start', Description = 'Story', ['Previous Mission'] = 'Previous',
                ['Next Mission'] = 'Next', ['Previous Quest'] = 'Previous', ['Next Quest'] = 'Next', Rewards = 'Reward',
                ['Required Fame'] = 'Fame', ['Level Restriction'] = 'Limit'}

-- The guide screen's card (core/card.lua) already shows these infobox fields from Chronicle's own data: wiki
-- field -> the card fields that must all have a real value. Position and wording the card lacks stay in the
-- header (Starting NPC needs both the NPC and the zone). Previous / Next Quest: the card's chain links.
-- Repeatable is not here: the wiki wins where it and the card's own (v1) data disagree (sandoria 84-89, 94-96 and 5 say "Yes,
-- after Memory reset" / "Yes" where the card prints "No"), so a Repeatable stays hidden only when it says what the card prints
-- (D.CARD_PRINTED); one that differs is drawn beside the card's value.
D.CARD_FIELD = {['Required Fame'] = {'fame'}, ['Starting NPC'] = {'npc', 'zone'},
                Description = {'description'}, Rewards = {'reward'},
                Requirements = {'requirements'}, ['Previous Quest'] = {'previous'}, ['Next Quest'] = {'next'}}
-- Requirements is the one CARD_FIELD entry with a second test below (D.REQ_EXTRA): the card's list holds only the items
-- Chronicle has ids for, so a wiki row that also carries a skill, a level, a rank or a condition is not a repeat of it.
-- Title is not here either: a title list ("Royal Wedding Planner" and "Consort Candidate") shows whole beside the card's one.
-- wiki field -> the card field whose printed text (card.printed) it must not repeat: hidden only when it says the same
-- A mission's Previous / Next Mission are the card's chain links (the quests' Previous / Next Quest are in D.CARD_FIELD); they are hidden when
-- the card draws the same names, one that differs (a mission with two ways in) is drawn beside the card's (2026-10-21, rule 67: the
-- Series box of every toau mission repeated the Previous / Next the card draws under it).
D.CARD_PRINTED = {Repeatable = 'repeatable', Title = 'title', ['Previous Mission'] = 'previous', ['Next Mission'] = 'next',
                  -- rule 126 (assault pages): the guide card's intro is its description (v1 data), which the page's Objective or Mission Orders row
                  -- repeats word for word (51 of the 52 assault pages); hidden only when it has the card's letters (D.HIDE_ORDERS = false: the
                  -- drawing before 126)
                  Objective = 'description', ['Mission Orders'] = 'description'}
D.HIDE_ORDERS = true


-- a field's text as compared with what the card prints: lower case, letters and digits only (the card's own marks, a full stop,
-- the spacing do not count); nil when the field holds more than text (an icon)
local function plain_text(h)
    local s = ''
    for _, sp in ipairs(h.spans) do
        if sp.t == 'br' then s = s .. ' '
        elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' or sp.t == 'tag' then s = s .. (sp.s or '')
        else return nil end
    end
    return (s:lower():gsub('[^%w]', ''))
end

-- Rule 180 (quest sandoria 98, Methods Create Madness): the card's Requirements list showed "Sahagin Key" and the wiki's own
-- Requirements row, "Polearm skill 240+, Level 71" over that same key, was dropped whole as a repeat of it, so the skill and the
-- level were drawn nowhere. The card's list is built (core/meta: requirement_rows) from the item, key-item and quest-item links of
-- that row alone, one row per link; a line of the row with none of those links -- a skill, a level, a rank, a nation's control of a
-- region, "A fishing rod" -- becomes no card row and lives in no other field, so it is drawn on its own under the card. A line that
-- does hold such a link is the card's own row and stays undrawn: its words would print the item's name a second time (the first
-- cut of this rule drew the row whole and broke 145 pages, test_pages' own word count catching every one).
-- 214 pages of 1,915 have such a line; on 85 more the only extra words sit inside an item's own line and are still dropped.
-- D.REQ_EXTRA = false is the old drawing.
D.REQ_EXTRA = true
-- is this line of a Requirements row one the card's item list already carries?
local function req_carded(line)
    for _, sp in ipairs(line) do
        if sp.t == 'icon' and sp.icon == 'item' then return true end
        if sp.t == 'link' and (sp.kind == 'item' or sp.kind == 'ki' or sp.kind == 'quest') then return true end
    end
    return false
end
-- what a line says beyond a quantity or a separator: '' when it says nothing of its own
local function req_words(line)
    local s = ''
    for _, sp in ipairs(line) do
        if sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' or sp.t == 'tag' then s = s .. (sp.s or '')
        elseif sp.t ~= 'br' then return 'x' end     -- an icon (a key item's): more than words
    end
    s = s:lower():gsub('x%d+', ' ')                 -- "x10": the card's row carries the count
    s = s:gsub('%f[%a]and%f[%A]', ' '):gsub('%f[%a]or%f[%A]', ' ')   -- the card has an "or" row of its own
    return (s:gsub('[%s%d,;:/%+%-%.%*%(%)]', ''))
end
-- The spans of a Requirements row the card cannot carry, nil when it has none: the lines with no item link, in their
-- own order, the line breaks between them closed up.
function D.req_extra(h)
    if not D.REQ_EXTRA or h.key ~= 'Requirements' then return nil end
    local lines, cur = {}, {}
    for _, sp in ipairs(h.spans) do
        if sp.t == 'br' then lines[#lines + 1] = cur cur = {} else cur[#cur + 1] = sp end
    end
    lines[#lines + 1] = cur
    local keep = {}
    for _, line in ipairs(lines) do
        if not req_carded(line) and req_words(line) ~= '' then
            if #keep > 0 then keep[#keep + 1] = {t = 'br'} end
            for _, sp in ipairs(line) do keep[#keep + 1] = sp end
        end
    end
    return #keep > 0 and keep or nil
end
-- The spans to draw for a header field: all of them, but for a Requirements row the card's list already covers (and which
-- D.head_hidden therefore keeps only for the lines above) just those lines.
function D.head_spans(h, title, card)
    if not (D.REQ_EXTRA and h.key == 'Requirements' and title and card) then return h.spans end
    for _, k in ipairs(D.CARD_FIELD.Requirements) do if not card[k] then return h.spans end end
    return D.req_extra(h) or h.spans
end

-- Does a field say nothing: no text, "None", "Unknown" or "--" (and no link or icon)?
function D.head_empty(h)
    local s = ''
    for _, sp in ipairs(h.spans) do
        if sp.t == 'br' then
        elseif sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' or sp.t == 'tag' then s = s .. (sp.s or '')
        else return false end
    end
    s = s:lower():gsub('^%s+', ''):gsub('%s+$', '')
    return s == '' or s == 'none' or s == '--' or s == 'unknown'      -- "Fame Unknown" repeated the card's "--" (jeuno 41, 2026-10-20)
end

-- A tab panel's infobox (one path of a mission with several) next to the guide card: a field stays undrawn when it says what the card
-- prints (cop 530's panels repeated the card's Repeatable, Next and Reward, 2026-10-20); a path's own Starting NPC, Title, Previous and
-- the like differ from the card's and stay. wiki field -> the card.printed field holding the text the card draws for it:
D.PANEL_PRINTED = {Repeatable = 'repeatable', Title = 'title', Description = 'description', Rewards = 'reward',
                   ['Starting NPC'] = 'start', ['Required Fame'] = 'fame',
                   ['Previous Mission'] = 'previous', ['Next Mission'] = 'next', ['Previous Quest'] = 'previous', ['Next Quest'] = 'next'}
-- an empty field ("None", "--") where the card prints "--" for it: card.shown's flags of what the card has a value for
D.PANEL_EMPTY = {Rewards = {'reward'}, Description = {'description'}, Title = {'title'}, ['Required Fame'] = {'fame'},
                 ['Starting NPC'] = {'npc', 'zone'}, Requirements = {'requirements'},
                 ['Previous Mission'] = {'previous'}, ['Next Mission'] = {'next'}, ['Previous Quest'] = {'previous'}, ['Next Quest'] = {'next'}}

-- Rule 178 (vision wave qcw4, quest wotg 69: three nation tabs, each with its own quest infobox): a panel drew "Pack Wings of the Goddess"
-- under a card whose FAME is the pack, "Rewards [KI] Large memory fragment" under a card REWARD "[Key Item] Large memory fragment", and
-- "Level Restriction None", a field that says nothing and has no card field. The page header already hides all three (rule 176, D.CARD_FIELD,
-- D.head_empty). A panel now leaves out a Starting NPC / Pack row that repeats the card (rule 176's test), reads a key-item icon as its label
-- "Key Item" when it compares a field with the card's text, and leaves out an empty field that has no card field. D.PANEL_REPEAT = false is
-- the drawing before 178.
D.PANEL_REPEAT = true
local repeats_card        -- rule 176's test, below
-- Rule 179 (vision wave qot4, quest other 24: two quest tabs under a card with FAME "Other" and REWARD "Support Jobs"): each panel drew "Fame
-- Other Fame Level: Unknown" and the second "Reward Support Job". A Required Fame row "<fame> Fame Level: <n>" whose fame has the letters of
-- the card's and whose level is unknown, none or the card's own says nothing the card does not (a page header hides it for the card's
-- FAME, and core/meta.lua reads the same row shape); a field that differs from the card's text only by a final "s" (the wiki's "Support Job" on
-- one page, "Support Jobs" on the other) is the card's. D.PANEL_FAME = false is the drawing before 179.
D.PANEL_FAME = true
local function fame_repeats(h, printed)
    local t = ''
    for _, sp in ipairs(h.spans) do
        if sp.t == 'text' or sp.t == 'link' or sp.t == 'tag' then t = t .. (sp.s or '') elseif sp.t ~= 'br' then return false end
    end
    local f, lvl = t:match('^(.-)%s*Fame Level:%s*(.-)%s*$')
    if not f then return false end
    local function letters(x) return (x:lower():gsub('[^%w]', '')) end
    local want = letters(lvl)
    for _, p in ipairs(printed) do
        local name, plvl = p:match('^(.-)%s*%(Lvl%s*(%d+)%)%s*$')
        name = name or p
        if letters(name) == letters(f) and (want == '' or want == 'unknown' or want == 'none' or want == 'na' or want == plvl) then return true end
    end
    return false
end
local function panel_text(h)
    if not D.PANEL_REPEAT then return plain_text(h) end
    local spans = {}
    for i, sp in ipairs(h.spans) do
        spans[i] = (sp.t == 'icon' and sp.icon == 'ki') and {t = 'text', s = (sp.label or 'Key Item') .. ' '} or sp
    end
    return plain_text({spans = spans})
end

function D.panel_hidden(h, card)
    if h.key == 'Name' then return true end            -- the tab says it
    if type(card) ~= 'table' then return false end     -- no card, nothing to repeat
    if D.head_empty(h) then
        local need = D.PANEL_EMPTY[h.key]
        if not need then return D.PANEL_REPEAT and D.CARD_FIELD[h.key] == nil and D.PANEL_PRINTED[h.key] == nil end
        for _, k in ipairs(need) do if card[k] then return false end end
        return true
    end
    if D.PANEL_REPEAT and repeats_card(h, card) then return true end
    local field = D.PANEL_PRINTED[h.key]
    local printed = field and card.printed and card.printed[field]
    if printed == nil then return false end
    local mine = panel_text(h)
    if not mine or mine == '' then return false end
    if type(printed) ~= 'table' then printed = {printed} end
    if D.PANEL_FAME and h.key == 'Required Fame' and fame_repeats(h, printed) then return true end
    for _, p in ipairs(printed) do
        local theirs = plain_text({spans = {{t = 'text', s = p}}})
        if mine == theirs then return true end
        if D.PANEL_FAME and mine:gsub('s$', '') == theirs:gsub('s$', '') then return true end
    end
    return false
end

-- Rule 176 (vision wave qcw2, quest wotg 81 to 86 and 79 more): the header box drew "Start Voidwatch Officer" (a row with no zone) and
-- "Pack Wings of the Goddess" right under a card that prints NPC Voidwatch Officer and FAME Wings of the Goddess (v1's meta keeps the pack in
-- `fame`). A Starting NPC row with the letters of the card's NPC, and a Pack row with the letters of the card's printed FAME, repeat the card
-- and are left out; a card with no fame keeps the Pack row (it is the only place the pack shows). D.HIDE_CARD_REPEAT = false is the old drawing.
D.HIDE_CARD_REPEAT = true
function repeats_card(h, card)
    local pr = card and card.printed
    if not D.HIDE_CARD_REPEAT or type(pr) ~= 'table' then return false end
    local mine = plain_text(h)
    if not mine or mine == '' then return false end
    local list
    if h.key == 'Starting NPC' then list = {pr.npc}
    elseif h.key == 'Pack' then list = type(pr.fame) == 'table' and pr.fame or {pr.fame}
    else return false end
    for _, p in ipairs(list) do
        if type(p) == 'string' and mine == plain_text({spans = {{t = 'text', s = p}}}) then return true end
    end
    return false
end

-- Does a header field stay undrawn? Always the Name of a tab panel (the tab says it; title = nil). On a page
-- header (title = the page's title): the Name when it is the title; a field with nothing in it; a field the
-- guide card shows already (card = the set core/card.shown gives; without one nothing is dropped for that).
function D.head_hidden(h, title, card)
    if not title then return D.panel_hidden(h, card) end
    if h.key == 'Name' then
        local s = ''
        for _, sp in ipairs(h.spans) do s = s .. (sp.s or '') end
        return s == title
    end
    if D.head_empty(h) then return true end
    if repeats_card(h, card) then return true end
    -- a field with the very text the card prints (Repeatable: No, where the card says 'No' for want of a value)
    local field = D.CARD_PRINTED[h.key]
    if field == 'description' and not D.HIDE_ORDERS then field = nil end
    local printed = field and card and card.printed and card.printed[field]
    if field then   -- the card prints this field's text: hidden when it says that, and only then
        return printed ~= nil and plain_text(h) == plain_text({spans = {{t = 'text', s = printed}}})
    end
    local need = card and D.CARD_FIELD[h.key]
    if need then
        for _, k in ipairs(need) do if not card[k] then return false end end
        -- the card's Requirements list is items only: a row that says more than that keeps its words
        if D.req_extra(h) then return false end
        return true
    end
    return false
end

-- ------------------------------------------------------------------------------------- layout
local function style_of(s)
    if s.t == 'link' then return C[s.kind] or C.page, s.kind end
    if s.t == 'coord' then return C.coord, 'coord' end
    if s.color then return C.red, nil end
    if s.b then return C.bold, nil end
    return C.text, nil
end

-- An icon that is not an item (aggro: "Sight", "Magic") shows its label, unless the text right
-- after it already says it: "aggro to [icon] Sight" would read "Sight Sight" (2026-10-19).
function D.icon_shows_label(spans, i)
    local s, nxt = spans[i], spans[i + 1]
    -- past the blank text between an icon and the word it stands for ("[Ice] **Ice**": the space is a span of its own, jeuno 67)
    local j = i + 1
    while nxt and nxt.t == 'text' and nxt.s and not nxt.s:find('%S') do j = j + 1 nxt = spans[j] end
    if not (nxt and nxt.s) then return true end
    local first = function(t) return ((t or ''):match("^%s*([%w']+)") or ''):lower() end
    local last = function(t) return ((t or ''):match("([%w']+)[^%w']*$") or ''):lower() end
    -- the label says the word when it starts with it ("Sight" before "Sight") or ends with it ("Element: Ice" before "Ice", bastok 67)
    return first(s.label) == '' or (first(s.label) ~= first(nxt.s) and last(s.label) ~= first(nxt.s))
end

-- Is an icon inside a sentence: words (text, a link) before it and after it, past any blank text? (windurst 75: "is Red [Element: Fire]. Hot spells",
-- 68: "Use [Two-Hour ability] Manafont"; a chip there splits the sentence.) An icon at the start of a line or a cell, or after a break, is not.
-- Rule 118 (2026-10-22, cop 228 Lightsday / Darksday, tvr 352): two icons side by side in a sentence ("... + Door + - - [Element: Light]
-- [Element: Dark] .") are each inline: the other icon, a label-only icon like it, is looked through when finding the words before and
-- after, so the pair draws as the plain words "Light Darkness" and not as two named chips. An item or key-item icon (a picture) is not
-- looked through. D.ICON_PAIRS = false is the rule before 118.
D.ICON_PAIRS = true
function D.icon_inline(spans, i)
    local function blank(x)
        return (x.t == 'text' and x.s and not x.s:find('%S'))
            or (D.ICON_PAIRS and x.t == 'icon' and x.icon ~= 'item' and x.icon ~= 'ki' and (x.label or '') ~= '')
    end
    local function words(x) return x and (x.t == 'text' or x.t == 'link' or x.t == 'coord') and (x.s or '') ~= '' end
    local j = i - 1
    while spans[j] and blank(spans[j]) do j = j - 1 end
    local before = words(spans[j])
    j = i + 1
    while spans[j] and blank(spans[j]) do j = j + 1 end
    return before and words(spans[j]) or false
end

-- What an icon that has no picture of its own (not an item, not a key item) draws: nil (the diamond mark: the word after it says it),
-- else its label and whether it is drawn as plain words. A label in a sentence is the plain word, without the template's prefix
-- ("Element: Fire" is "Fire"), not a chip that would split the sentence. D.INLINE_CHIPS = true is the old behaviour (a chip anywhere).
D.INLINE_CHIPS = false

-- Rule 82 (2026-10-21, adoulin 212): a box whose title is empty (a wiki table of one cell and no header row) draws its frame and wash
-- but no 20 px red bar. D.EMPTY_BAR = true is the old drawing (the bar over nothing).
D.EMPTY_BAR = false

-- Rule 83: the header's label column is at most this share of the box (45%); nil is the old reading (as wide as the longest label).
D.HEAD_LABEL_CAP = 0.45

-- Rule 86 (2026-10-21, adoulin 212): text inside a box keeps the same inset from the box's right border as its left padding (10 px).
-- The box branch laid the inner blocks out 10 px in from the left and to the column edge on the right, so a wrapped line ran up to the
-- border (1 to 5 px at several widths; adoulin 212, cop 530, bastok 78, jeuno 77 and 89, windurst 34), and in a box narrowed by a picture
-- floated beside its top, lines lower down ran past the box's border altogether (cop 530). The inner blocks are laid out up to the box's
-- right border minus this. D.BOX_RIGHT_PAD = 0 is the old reading.
D.BOX_RIGHT_PAD = 10
-- Rule 120 (2026-10-22, tvr 362 380 414 430 484 516 592 602 624): a gallery in a box stops at the box's right inset (above), not at the
-- border: two or more pictures at the narrowest width ran up to the border and painted over it. D.GALLERY_INSET = false is the old
-- reading (the column's right edge).
D.GALLERY_INSET = true
function D.icon_text(spans, i)
    if not D.icon_shows_label(spans, i) then return nil end
    local label = ascii(spans[i].label or '')
    if not D.INLINE_CHIPS and D.icon_inline(spans, i) then
        local bare = label:gsub('^%a+:%s*', '')
        return bare ~= '' and bare or label, true
    end
    return label, false
end

-- An icon's label wider than this, or of five words or more, is drawn as words that wrap (D.CHIP_WRAP = false is the old
-- behaviour: a chip that cannot wrap, wider than the column; test_pages' self-test turns it off to see the check catch it).
D.CHIP_WRAP = true
D.HEAD_HITS = true
D.HEAD_ICONS = true       -- rule 170: a labelled icon in a heading draws its label; false = the old drawing (the icon dropped)
D.WRAP_HEADINGS = true     -- rule 95: false = the old one-line heading
local CHIP_MAX = 260
-- A closing mark with a space before it (the wiki's "using /clock )") is set against the word before it: a line never
-- starts with ")" (windurst 75). D.GLUE_CLOSERS = false is the old behaviour.
-- Not "???": two question marks or more are an interaction point's name (a word, the space before it is the reader's), and a run
-- of them taken for a closing mark glued "a ???" to "a???" on a hundred pages (2026-10-20). D.GLUE_PLACEHOLDER = true is that old behaviour.
D.GLUE_CLOSERS = true
D.GLUE_PLACEHOLDER = false
D.COMPACT_TABLES = true       -- false: the old rule (a table that does not fit at 8 px a side runs its cells together)
D.COMPACT_PAD = {4, 2}     -- the margin a side tried in turn
-- Rule 124 (2026-10-22, assault 2 and 3 at w440, and 31 more assault pages): only a table of five columns or fewer may give up cell margin
-- to fit. The eight-column Enemies table fitted its 440 px at a margin of 2 or 4 px a side: "Link Drops" and "Steal Spawns" ran together
-- in the header, "Too Weak" and "Mamool Ja Training Grounds" wrapped to two to four lines. A wider grid that does not fit at the full
-- margin is a card per row (rule 121). D.COMPACT_COLS = 99 is the old behaviour (test_pages: a grid of 6+ columns at a margin under 8 fails).
D.COMPACT_COLS = 5
local CLOSER = '^[%)%]%.,;:!%?]+$'
local function closer(word)
    return word:find(CLOSER) ~= nil and (D.GLUE_PLACEHOLDER or not word:find('%?%?'))
end
-- Rule 195 (vision wave camp2, mission campaign 233 "seems to have around ? HP", wotg 23 "Level ? Holy"): a lone "?" with a space on each side
-- is an unknown number, not a closing mark, and the closing-mark glue above took the space before it away ("around? HP", "Level? Holy"). A word
-- that is only "?" and is followed by a space and more text (a bracket or a word) keeps its space; the held-sign rule still keeps it with the word
-- before it, so a line never starts with it. D.QMARK_PLACEHOLDER = false is the old drawing.
D.QMARK_PLACEHOLDER = true
local function qmark_placeholder(word, after, more)
    return D.QMARK_PLACEHOLDER and word == '?' and (after:find('^ +[%w%(%[]') ~= nil or (more and after:find('^ +$') ~= nil))
end
-- Rule 94: a sign that is no word, with a full stop or bracket at its end (the wiki's "on this page >>."), is kept on the line of the
-- word before it, space and all: a line never holds ">>." alone (zilart 26). D.HOLD_SIGNS = false is the old behaviour.
D.HOLD_SIGNS = true
-- Rule 157 (vision wave qad1, quest adoulin 127): a range written "21:00 - 3:00" broke after its dash and left "3:00." alone on the next line.
-- The start, the dash and the end of a range of clock times (a word that ends in "h:mm", a lone "-" or "~", a word that starts with "h:mm") are one
-- run, so the line breaks before the range, as a held sign stays with the word before it. Only clock times, in prose and in cells: any number range ("65 - 68") would widen
-- table columns and move 9 committed pages (cop 358, bastok 82, jeuno 175 ...). D.HOLD_RANGES = false is the old behaviour.
D.HOLD_RANGES = true
-- Rule 159 (vision wave qad2, quest adoulin 111): an item's "+1" ("Midras's Helm +1.") is part of its name, and the line broke before it and left
-- "+1." alone on the next line. The last word of an item's name that is a plus sign and digits is held to the word before it, as a closing sign
-- is (an item link only: "gives +1 skill" and "Magic Accuracy +5" in prose are left as they were, which moved 5 more pages).
-- D.HOLD_PLUS = false is the old layout.
D.HOLD_PLUS = true
-- Rule 113: a table column is never narrower than a run of tokens with no space between them (a link and the bracket or full stop after
-- it: `Old Troll ({p:RNG})`, assault 25), which the flow keeps on one line; measured per token, the ")" was wider than the room and
-- broke alone. D.MIN_RUNS = false is the measure before 113.
D.MIN_RUNS = true
D.DRIFT_FLOATS = true
-- Rule 150 (F4): a picture, or a run of pictures, that is the only content of a box (the wiki's map box; titled or not) is not floated at the
-- right at 168 px (the box's left side stood empty: quest other 20, tvr 138 and 24 more); it is drawn as the narrow window draws it, in the
-- box's width and no wider than the picture itself. Pictures anywhere else, and a box with any text, are placed as before. D.LONE_PICTURE =
-- false is the layout before 150.
D.LONE_PICTURE = true
-- Rule 130 (asa 8 and 11): a heading of a new section is never drawn beside the picture of the section before it. A float knows the level of
-- the heading it was floated under (`level`); a heading of that level or a higher one (a sibling, not a subsection) starts below the float
-- when more than D.CLEAR_MIN px of it would still stand beside the heading, and only when the new section opens with a picture of its own
-- (`pic_next`, set by blocks_at: the heading reads as that picture's title, and beside the wrong picture it reads as the other's; a section
-- that opens with text keeps flowing beside the float, as in the wiki). A subsection stays beside its parent's picture, and a picture before
-- any heading (the page's lead picture, with its Enemies / Notes / Walkthrough beside it on the Assault pages) is the wiki's own two columns
-- and is never cleared. D.CLEAR_HEADINGS = false is the layout before 130.
D.CLEAR_HEADINGS = true
D.CLEAR_MIN = 24
-- Rule 102: whatever quotes surround it ('glowing "???".', rov 191). A word with no letter or digit, a stop, bracket or question mark in it
-- and nothing after that but closing quotes is a held sign, unless it is the placeholder in the shape the fragments check lets stand on a
-- line of its own ("???", "(???)."). A quote alone is no sign: it is the opening of the next word and stays with it.
-- D.HOLD_QUOTED = false is the rule before 102 (any word with "??" in it was left to break away, and a quote after the stop was no sign).
D.HOLD_QUOTED = true
local function sign_tail(word)
    if closer(word) or word:find('%w') then return false end
    if D.HOLD_QUOTED then
        if word:find('^[%(%[]*%?%?%?[%.,;:!%)%]]*$') then return false end
        return word:find("[%)%]%.,;:!%?][\"']*$") ~= nil
    end
    return not word:find('%?%?') and word:find('[%)%]%.,;:!%?]$') ~= nil
end

-- Rule 119 (2026-10-22, assault 52): in a table cell, "???" (an interaction point's name, a word) keeps the word after it, the way an
-- icon does: the Type column of the Drops table measured its narrowest as the longest word, so it was narrower than "??? Footwear" and
-- the line broke between "???" and "Footwear", "???" alone above the type. The glued run is also the cell's narrowest, so the column
-- gets the room. Only in table cells (a "???" that ends a line of prose is the line filling up). D.GLUE_QQQ = false is the old behaviour.
D.GLUE_QQQ = true

-- Rule 121 (2026-10-22, assault 1 4 7 8 12 17 23 27 29 33 38 48 49 at w440): a table whose columns do not fit even at their narrowest (an
-- eight-column Enemies table in a 480 px window) was drawn as run-on rows, the cells of a row running together with thin bars between them
-- and wrapping anywhere, which a reader takes for raw pipes and cannot tell column from column. Each body row is now a card: its name cell
-- (the row's head: a bold or header cell, else the first link, else the first cell) as a line, then "Label value" pairs for the other
-- cells with the label from the column's header cell(s) in the dim colour (a column headed "Name" is the name cell; two header rows named
-- in the first column, "Room:" and "NPC Faces:", are said once above the cards and the labels read "North / North"). A cell with nothing in it is left out; one with anything in it
-- ("?" and "None" too) stays, so nothing the wiki says is dropped. Header rows are not drawn on their own except a title band across
-- the table. D.CARDS = false is the old run-on drawing (test_pages: any run-on table fails).
D.CARDS = true

-- Rule 122 (2026-10-22, assault 1 4 7 ... 49 at w440): the card's "Label value" pairs were drawn "Label" and "value" touching ("ZonePeriqia").
-- The label is glued to its value so a line never breaks between them, and `flow` placed a glued run without the space token between its
-- parts (the column measure counted it, the drawing did not). A glued run now keeps the space it holds, as the held signs do (rule 94).
-- D.CARD_SPACE = false is the old drawing (test_pages: a card label touching its value fails).
D.CARD_SPACE = true
-- Rule 123 (2026-10-22, assault 7 to 12 drop tables at w440): the same for rule 119's "???" held to the next word ("???Box").
-- D.QQQ_SPACE = false is the old drawing (test_pages: a placeholder touching its word fails).
D.QQQ_SPACE = true
-- Rule 131 (2026-10-22, assault 33 at w440): a card label of two header cells ("Center / South") broke after the slash ("Center /" at the
-- end of a line, "South Ryaaf" on the next): only the label's last token was held to the value, the parts and the "/" between them were
-- free to wrap. Every word of a multi-part label is held to the next (the spaces and the "/" kept), so label and value are one run.
-- D.CARD_LABEL = false is the old drawing (test_pages: a held pair broken over two lines fails).
D.CARD_LABEL = true
-- Rule 132 (2026-10-22, assault 42 at w440): the pair after a multi-line cell (the Drops list) was joined to the list's last line with the
-- 16 px spacer ("Water Crystal  Steal None  Spawns 1"), so "Steal None" read as a value of the last drop. A pair that follows a multi-line
-- value starts on its own line. D.CARD_AFTER_LIST = false is the old drawing (test_pages: a pair after a list on the list's line fails).
D.CARD_AFTER_LIST = true
-- Rule 143 (2026-10-28, quest other 11 Fisherman's Heart, vision wave qot2 "Fish List rows are ragged"): a table with no header row at all
-- (eight fish a row, the wiki's own grid) drawn as cards made the first cell of every row a title and put it alone on its line above the
-- other seven. With no header there is no label and no title: the cells of a row run on one after another, 16 px apart, each held in one
-- piece when it is a few words. D.PLAIN_GRID = false is the old drawing (test_pages: a headerless row with a line break after its first
-- cell fails).
D.PLAIN_GRID = true
function D.glue_placeholders(toks)
    for i, t in ipairs(toks) do
        if t.k == 'w' and t.s and t.s:find('^[%(%[]*%?%?%?+$') and toks[i + 1] and toks[i + 1].k == 'sp'
            and toks[i + 2] and toks[i + 2].k ~= 'sp' and toks[i + 2].k ~= 'br' then
            t.glue = true
            t.qqq = true
            t.spaced = D.QQQ_SPACE        -- rule 123: and the space between them is kept
        end
    end
end

-- The token memo (2026-10-22 perf pass). A token list depends only on its spans, the rules above (D's fields), the font's widths
-- (ops.metrics) and kit's colours (constant), never on the width: a page laid out again (a 0x055, a resize, a tab, a picture that
-- arrived) measured every word again and made a table per word, 12-16% of a layout and most of its garbage. So the lists of the
-- page being laid out are kept, keyed by their spans table, for that one document (another document, D.release(), or any change
-- to a field of D or to the metrics starts the memo afresh: test_pages' self-test switches rules off and on between layouts).
-- The layout writes x, ly, next_same and pre on the tokens it places (and the context-fixed col / glue / qqq / spaced, the same
-- every time): a list handed out again has those four cleared first, so every layout starts from tokens as tokens_raw makes them.
-- Bounded: one document's lists (a big page, about 1-1.5 MB), dropped when its page closes (core/pages.lua calls D.release).
-- D.TOKEN_MEMO = false is the behaviour before (test/test_perf.lua's fault run).
D.TOKEN_MEMO = true
local tok_memo = nil            -- spans -> tokens, while D.draw lays out tok_doc (nil outside D.draw or with the memo off)
local tok_cache, tok_doc = nil, nil
local shadow, shadow_m = {}, nil
-- the outputs D.draw itself replaces on every call (for the tests): not a change of the rules. D.draw resets exactly these,
-- so a new output added here is never also seen by D.rules_rev (a field missing from this list bumped the rules on every
-- draw, and no memo ever hit: review UI-1).
local PER_DRAW = {
    runon = true,       -- the column counts of the tables drawn as run-on rows (test_pages: none may be, rule 121)
    held = true,        -- the pairs of words held together across a space {a, b, sp, label}: drawn, b.x - (a.x + a.w) must be at least sp (rules 122, 123)
    grids = true,       -- the tables drawn as columns (rule 124): {tb, ncols, pad = the margin a side, wrapped = cells whose text runs to a second line}
    labels = true,      -- the card pairs {label = its tokens, value = the first token of the value} (test_pages: one line, rule 131)
    afterlist = true,   -- the card pairs that follow a multi-line value {a = its last token, b = the pair's first token} (rule 132)
    cards = true,       -- the tables drawn as a card per row (rule 121): {tb = the table block, drawn = {word = times} of the header words drawn}
    plain = true,       -- the card rows of a table with no header row and more than one cell {brs = line breaks drawn, own = line breaks the cells hold} (rule 143)
}

-- D.rules_rev() -> a number that changes whenever any field of D (a rule, a table of rules, a function a test swapped in) or the
-- font metrics changed since the last call. The token memo and core/pages.lua's page memo are keyed on it. (A rule table changed
-- in place, D.COMPACT_PAD[1] = 6, is not seen: replace the table, as the tests do.)
local rules_rev = 0
function D.rules_rev()
    local changed = false
    for k, v in pairs(D) do
        if not PER_DRAW[k] and shadow[k] ~= v then shadow[k] = v changed = true end
    end
    for k in pairs(shadow) do
        if D[k] == nil then shadow[k] = nil changed = true end
    end
    local m = ops.metrics()
    if m ~= shadow_m then shadow_m = m changed = true end
    if changed then rules_rev = rules_rev + 1 end
    return rules_rev
end
local tok_rev = nil

-- forget the token memo (the page closed)
function D.release() tok_cache, tok_doc, tok_memo = nil, nil, nil end

local tokens_raw
local function tokens(spans)
    local memo = tok_memo
    if memo then
        local t = memo[spans]
        if t then
            for i = 1, #t do
                local k = t[i]
                if k.x ~= nil then k.x = nil end
                if k.ly ~= nil then k.ly = nil end
                if k.next_same ~= nil then k.next_same = nil end
                if k.pre ~= nil then k.pre = nil end
            end
            return t
        end
        t = tokens_raw(spans)
        memo[spans] = t
        return t
    end
    return tokens_raw(spans)
end

tokens_raw = function(spans)
    local out = {}
    for si, s in ipairs(spans) do
        if s.t == 'br' then
            out[#out + 1] = {k = 'br'}
        elseif s.t == 'icon' then
            if s.icon == 'item' or s.icon == 'ki' then
                out[#out + 1] = {k = 'icon', w = ICON + 3, glue = true, span = s}
            elseif D.icon_text(spans, si) then
                local label, plain = D.icon_text(spans, si)
                local _, nwords = label:gsub('%S+', '')
                if plain or (D.CHIP_WRAP and (nwords >= 5 or text_w(label) > CHIP_MAX)) then
                    -- a sentence the wiki gave an icon as its alt text (bastok 28: "The chance of seeing drop is increased after procing
                    -- yellow abilities on the monster.") is a note, not a chip: it wraps like text, in the dim colour; so is an icon's
                    -- label in the middle of a sentence
                    for word in label:gmatch('%S+') do
                        if #out > 0 and out[#out].k ~= 'br' and out[#out].k ~= 'sp' then out[#out + 1] = {k = 'sp', w = text_w(' ')} end
                        out[#out + 1] = {k = 'w', s = word, w = text_w(word), col = C.dim, span = s}
                    end
                else
                    out[#out + 1] = {k = 'chip', s = label, w = text_w(label) + 9, span = s}
                end
            else
                out[#out + 1] = {k = 'mark', w = 12, glue = true, span = s}
            end
        elseif s.t == 'tag' then
            out[#out + 1] = {k = 'tag', s = s.s, w = text_w(s.s) + 7, col = s.s == 'Rare' and C.rare or C.ex}
        else
            local col, kind = style_of(s)
            local str = ascii(s.s or '')
            local i = 1
            while i <= #str do
                local a, e = str:find(' +', i)
                if a == i then
                    out[#out + 1] = {k = 'sp', w = text_w(' ') * (e - a + 1)}
                    i = e + 1
                else
                    local stop = (a or #str + 1) - 1
                    local word = str:sub(i, stop)
                    -- no space before a closing mark: the space token before it goes (the mark then sits in the run of the word before)
                    local qph = qmark_placeholder(word, str:sub(stop + 1), si < #spans and spans[si + 1].t ~= 'br')
                    if D.GLUE_CLOSERS and closer(word) and #out > 1 and out[#out].k == 'sp' and out[#out - 1].k ~= 'br' and not qph then
                        out[#out] = nil
                    end
                    local held = D.HOLD_SIGNS and (sign_tail(word) or qph) and #out > 1 and out[#out].k == 'sp' and out[#out - 1].k == 'w'
                    -- rule 159: "Helm +1." stays together
                    if D.HOLD_PLUS and not held and kind == 'item' and #out > 1 and out[#out].k == 'sp' and out[#out - 1].k == 'w'
                        and out[#out - 1].span == s and word:find('^%+%d+[%.,;:!%?%)%]]*$') then
                        held = true
                    end
                    -- rule 157: "21:00 - 3:00" is one run; the dash and the end of the range stay with the start
                    local range = false
                    if D.HOLD_RANGES and word:find('^%d+:%d%d') and #out >= 4 and out[#out].k == 'sp' and out[#out - 1].k == 'w'
                        and (out[#out - 1].s == '-' or out[#out - 1].s == '~') and out[#out - 2].k == 'sp'
                        and out[#out - 3].k == 'w' and out[#out - 3].s:find('%d:%d%d[%)%]]?$') then
                        out[#out - 1].hold, out[#out - 1].range = true, true
                        range = true
                    end
                    out[#out + 1] = {k = 'w', s = word, w = text_w(word), col = col, kind = kind, span = s, hold = (held or range) or nil, range = range or nil}
                    i = stop + 1
                end
            end
        end
    end
    return out
end

-- A word wider than the column (a long address) is broken across lines. D.BREAK_LONG = false is the old
-- behaviour (test_pages' self-test turns it off to see the check catch it).
D.BREAK_LONG = true
local BREAK_AFTER = {['/'] = true, ['.'] = true, ['-'] = true, ['?'] = true, ['='] = true, ['&'] = true,
                     ['_'] = true, [','] = true, [':'] = true, ['%'] = true}

-- word -> the pieces that go on successive lines. The first goes in `first` px, the rest in `full` px a
-- line; `reserve` px of what follows the word in its run (a bracket, a full stop) must fit after the last
-- piece. A piece ends after a '/', '.', '-', '?', '=' ... when one is in the second half of what fits, else
-- wherever the room ends. The first piece is '' when not even one character fits on the current line.
-- Rule 97: the last piece of a broken word is never only a closing mark or full stop: mkd 12's "(north/.../etc.)." broke after
-- "etc." and drew ")." alone. A break stays before the word's last letter or digit. D.BREAK_TAIL = false is the old behaviour.
D.BREAK_TAIL = true
function D.break_word(word, first, full, reserve)
    local out = {}
    local rest, room = word, first
    -- review UI-2: what follows can be wider than a whole line (a long word glued to a long link). It is held to a line, the loop
    -- ends when the word is used up, and it never runs more passes than the word has characters (each pass takes at least one).
    if reserve > full then reserve = full end
    for _ = 1, #word + 2 do
        if text_w(rest) + reserve <= room then out[#out + 1] = rest break end
        if rest == '' then break end
        local n = 0
        for k = 1, #rest - 1 do
            if text_w(rest:sub(1, k)) <= room then n = k else break end
        end
        if D.BREAK_TAIL and n >= 1 and not rest:sub(n + 1):find('%w') then
            local last = 0
            for q = #rest, 1, -1 do if rest:sub(q, q):find('%w') then last = q break end end
            if last >= 2 then n = last - 1 end
        end
        for k = n, math.max(1, math.floor(n / 2)), -1 do
            if BREAK_AFTER[rest:sub(k, k)] then n = k break end
        end
        if n < 1 then
            if #out == 0 and room < full then          -- not a character of room left on this line: start a new one
                out[1] = ''
                room = full
            else
                n = 1                                   -- a column narrower than a character: one at a time
            end
        end
        if n >= 1 then
            out[#out + 1] = rest:sub(1, n)
            rest = rest:sub(n + 1)
            room = full
        end
    end
    return out
end

-- Lay the document out and draw it into builder b, at content (X0, Y0), W wide.
-- -> the y after it, block tops (for keeping the reading place)
function D.draw(b, doc, X0, Y0, W, opts)
    opts = opts or {}
    -- the token memo: this document's lists, unless the rules or metrics changed (see tokens)
    local rev = D.rules_rev()
    if D.TOKEN_MEMO then
        if rev ~= tok_rev or tok_doc ~= doc or not tok_cache then tok_cache, tok_doc, tok_rev = {}, doc, rev end
        tok_memo = tok_cache
    else
        tok_cache, tok_doc, tok_memo = nil, nil, nil
    end
    for k in pairs(PER_DRAW) do D[k] = {} end
    local y = Y0
    local tops = {}
    local floats = {}
    local get_pic = opts.pics or function() return 'failed' end
    local tabs_state = opts.tabs or {}

    local rcap = nil               -- rule 86: the right limit of the box being laid out (its border less the inset); nil outside a box

    local function column_right() return rcap and math.min(X0 + W, rcap) or X0 + W end

    local function right_edge(y0, y1)
        local r = column_right()
        for _, f in ipairs(floats) do
            if y1 > f.y0 and y0 < f.y1 then r = math.min(r, f.x0 - 14) end
        end
        return r
    end

    local function flow(toks, x0, y0, first_x, maxr)
        local x, ly = first_x or x0, y0
        local line = {}
        local function emit()
            for n, t in ipairs(line) do
                local nt = line[n + 1]
                t.ly = ly                -- the line it stands on (test_pages: a held pair must share one, rule 131)
                t.next_same = (nt and nt.k == 'w' and nt.span == t.span) and nt or nil
            end
            for _, t in ipairs(line) do
                if t.k == 'w' then
                    if t.kind == 'coord' then b:rect(t.x - 2, ly + 1, t.x + t.w + 1, ly + 16, alpha(C.coord, 26)) end
                    b:text(t.x, ly, t.col, t.s)
                    if t.kind and t.kind ~= 'coord' then
                        local nx = t.next_same and t.next_same.x or t.x + t.w
                        b:hit({x0 = t.x, y0 = ly, x1 = nx, y1 = ly + 16, id = 'link', span = t.span, to = t.span.to})
                        if t.kind == 'quest' or t.kind == 'mission' then
                            b:rect(t.x, ly + 15, nx, ly + 16, alpha(t.col, 110))
                        end
                    end
                elseif t.k == 'icon' then
                    if t.span.icon == 'item' and t.span.id then
                        b:icon(t.x, ly - 1, ICON, t.span.id)
                    elseif t.span.icon == 'ki' then
                        -- a key item: a small gold diamond
                        for i = 0, 4 do b:rect(t.x + 8 - i, ly + 4 + i, t.x + 10 + i, ly + 5 + i, C.ki) end
                        for i = 0, 4 do b:rect(t.x + 4 + i, ly + 9 + i, t.x + 14 - i, ly + 10 + i, C.ki) end
                    end
                elseif t.k == 'mark' then
                    -- the icon stands for the word after it: a small grey diamond
                    for i = 0, 3 do b:rect(t.x + 4 - i, ly + 5 + i, t.x + 6 + i, ly + 6 + i, C.dim) end
                    for i = 0, 3 do b:rect(t.x + 1 + i, ly + 9 + i, t.x + 9 - i, ly + 10 + i, C.dim) end
                elseif t.k == 'chip' then
                    b:rect(t.x, ly + 2, t.x + t.w - 3, ly + 15, {255, 255, 255, 22})
                    b:text(t.x + 3, ly, C.dim, t.s)
                elseif t.k == 'tag' then
                    b:rect(t.x, ly + 2, t.x + t.w - 3, ly + 15, alpha(t.col, 48))
                    b:text(t.x + 2, ly, t.col, t.s)
                elseif t.k == 'bar' then
                    b:rect(t.x, ly + 3, t.x + 1, ly + 15, C.rule)
                end
            end
            line = {}
        end
        local i = 1
        while i <= #toks do
            local t = toks[i]
            if t.k == 'br' then
                emit() ly = ly + LINE x = x0
            elseif t.k == 'sp' then
                if #line > 0 then x = x + t.w end
            else
                -- the run that must stay on one line: tokens with no space between them (a link and
                -- the bracket or full stop after it), and an icon with the word after it
                local run, w, j = {t}, t.w, i
                while true do
                    local nxt = toks[j + 1]
                    if not nxt or nxt.k == 'br' then break end
                    if nxt.k ~= 'sp' then
                        j = j + 1
                    elseif toks[j].glue and toks[j + 2] and toks[j + 2].k ~= 'sp' and toks[j + 2].k ~= 'br' then
                        if toks[j].spaced then
                            w = w + nxt.w                -- the space between the two goes with them (rules 122, 123)
                            toks[j + 2].pre = nxt.w
                        end
                        if toks[j].lab or toks[j].qqq then
                            D.held[#D.held + 1] = {a = toks[j], b = toks[j + 2], sp = nxt.w, label = toks[j].lab}
                        end
                        j = j + 2
                    elseif toks[j + 2] and toks[j + 2].hold then
                        w = w + nxt.w                -- the space before the sign goes with it
                        toks[j + 2].pre = nxt.w
                        j = j + 2
                    else
                        break
                    end
                    run[#run + 1] = toks[j]
                    w = w + toks[j].w
                end
                local r = maxr or right_edge(ly, ly + LINE)
                if x + w > r and #line > 0 then
                    emit() ly = ly + LINE x = x0
                    r = maxr or right_edge(ly, ly + LINE)
                end
                if D.BREAK_LONG and x + w > r and w > r - x0 then
                    -- wider than the column even on a line of its own: break the word, every piece keeping
                    -- the link (hit) and the colour
                    for n, rt in ipairs(run) do
                        x = x + (rt.pre or 0)
                        if rt.k == 'w' and x + rt.w > r then
                            local reserve = 0
                            for m = n + 1, #run do reserve = reserve + run[m].w end
                            local parts = D.break_word(rt.s, r - x, r - x0, reserve)
                            for pi, pc in ipairs(parts) do
                                if pi > 1 then
                                    emit() ly = ly + LINE x = x0
                                    r = maxr or right_edge(ly, ly + LINE)
                                end
                                if pc ~= '' then
                                    line[#line + 1] = {k = 'w', s = pc, w = text_w(pc), col = rt.col, kind = rt.kind,
                                                       span = rt.span, x = x}
                                    x = x + text_w(pc)
                                end
                            end
                        else
                            rt.x = x
                            line[#line + 1] = rt
                            x = x + rt.w
                        end
                    end
                else
                    for _, rt in ipairs(run) do
                        x = x + (rt.pre or 0)
                        rt.x = x
                        line[#line + 1] = rt
                        x = x + rt.w
                    end
                end
                i = j
            end
            i = i + 1
        end
        emit()
        return ly + LINE
    end

    -- Rule 95: a heading wider than the column wraps (asa 11: "Tablets locations in Den of Rancor (Sacrificial Chamber side - See Zilart
    -- Mission 4 for guide):" was one 809 px line). It breaks between words, a word wider than the column breaks inside it, every line
    -- keeps the title's size and colour and the hit areas of its links, one per word and line. A heading that fits is drawn as it was.
    -- D.WRAP_HEADINGS = false is the old behaviour (the self-test turns it off to see the check catch it).
    local section_level = nil        -- the level of the last heading laid out (rule 130)
    -- Rule 170 (2026-10-31, quest wotg 80): a labelled icon in a heading ("[Bastok crest] - Indigo stratum abyssite") draws its label, as the
    -- plain word it is in a sentence; the heading is one title string and dropped the icon, so the nation was missing from the section it
    -- names. -> the text a span adds to the heading. D.HEAD_ICONS = false is the old drawing (the icon left out).
    local function head_piece(spans, si)
        local s = spans[si]
        if D.HEAD_ICONS and s.t == 'icon' and s.icon ~= 'item' and s.icon ~= 'ki' then
            local lab = D.icon_text(spans, si)
            if lab and lab ~= '' then
                local nxt = spans[si + 1]
                return ascii(lab) .. ((nxt and nxt.s and not nxt.s:find('^%s')) and ' ' or '')
            end
            return ''
        end
        return ascii(s.s or '')
    end
    local function heading(hb, x0)
        local text = ''
        for si = 1, #hb.spans do text = text .. head_piece(hb.spans, si) end
        text = ascii(text)
        local px = hb.level == 2 and 13 or (hb.level >= 5 and 10 or 11)
        local pitch = px + 4
        local margin = hb.level == 2 and 18 or 12
        if D.CLEAR_HEADINGS then
            local clear = y
            for _, f in ipairs(floats) do
                if hb.pic_next and f.level and hb.level <= f.level and f.y1 - (y + margin) > D.CLEAR_MIN and f.y1 > clear then clear = f.y1 end
            end
            y = clear
        end
        y = y + margin
        section_level = hb.level
        if opts.float_log then opts.float_log[#opts.float_log + 1] = {k = 'heading', level = hb.level, y = y, x0 = x0, text = text} end    -- test_pages (rule 130)
        -- the lines, as ranges {s, e} of the text
        local lines
        if not D.WRAP_HEADINGS or title_w(text, px) <= column_right() - x0 then
            lines = {{s = 1, e = #text}}
        else
            lines = {}
            local cur
            local function room() return right_edge(y + #lines * pitch, y + #lines * pitch + px + 2) - x0 end
            for a1, e1 in (function()
                local pos = 1
                return function()
                    local a, e = text:find('%S+', pos)
                    if not a then return nil end
                    pos = e + 1
                    return a, e
                end
            end)() do
                local a = a1
                while a <= e1 do
                    local r = room()
                    if not cur then cur = {s = a, e = a - 1} end
                    if title_w(text:sub(cur.s, e1), px) <= r then
                        cur.e = e1
                        a = e1 + 1
                    elseif cur.e >= cur.s then
                        lines[#lines + 1] = cur
                        cur = nil
                    else
                        local k = a
                        while k < e1 and title_w(text:sub(a, k + 1), px) <= r do k = k + 1 end
                        cur.e = k
                        lines[#lines + 1] = cur
                        cur = nil
                        a = k + 1
                    end
                end
            end
            if cur then lines[#lines + 1] = cur end
            if #lines == 0 then lines[1] = {s = 1, e = #text} end
        end
        local col = hb.level == 2 and C.gold or C.gold_soft
        for n, L in ipairs(lines) do
            b:title(x0, y + (n - 1) * pitch, px, col, text:sub(L.s, L.e))
        end
        -- a link in a heading (a zone named as the section title) keeps its hit area: one per word, where the word is drawn
        -- (jeuno 42: three zone headings were links that did nothing). D.HEAD_HITS = false is the old behaviour.
        if D.HEAD_HITS then
            local done = 0
            for si, s in ipairs(hb.spans) do
                local str = head_piece(hb.spans, si)
                if s.t == 'link' and s.kind and s.to then
                    local pos = 1
                    while true do
                        local a1, e1 = str:find('%S+', pos)
                        if not a1 then break end
                        local ga, ge = done + a1, done + e1
                        for n, L in ipairs(lines) do
                            local lo, hi = math.max(ga, L.s), math.min(ge, L.e)
                            if lo <= hi then
                                local ly = y + (n - 1) * pitch
                                local x_a = x0 + title_w(text:sub(L.s, lo - 1), px)
                                local x_b = x0 + title_w(text:sub(L.s, hi), px)
                                b:hit({x0 = x_a, y0 = ly, x1 = x_b, y1 = ly + px + 2, id = 'link', span = s, to = s.to})
                            end
                        end
                        pos = e1 + 1
                    end
                end
                done = done + #str
            end
        end
        if hb.level == 2 then
            local n = #lines
            local ly = y + (n - 1) * pitch
            local x_a = x0 + title_w(text:sub(lines[n].s, lines[n].e), px) + 10
            local x_b = right_edge(ly, ly + px + 10)
            if n == 1 or x_b - x_a >= 20 then
                b:rect(x_a, ly + math.floor(px * 0.6), x_b, ly + math.floor(px * 0.6) + 1, C.rule)
            end
        end
        y = y + (#lines - 1) * pitch + px + 10
    end

    -- Step progress (opts.progress, core/progress.lua for_page): a mapped step's top-level bullet becomes a checkbox in its
    -- state, where the bullet was. Steps are addressed by the ordinal of the bullet among the items of the lists directly in
    -- their tab (or the page outside tabs: tab nil), in walkthrough order; bullets in boxes are not counted and keep their
    -- bullet; a step whose bullet no longer starts with its fingerprint (fp) is not marked.
    local prog = nil                -- 'tab|n' -> step
    if opts.progress and opts.progress.steps then
        prog = {}
        for _, s in ipairs(opts.progress.steps) do prog[(s.tab or '') .. '|' .. s.n] = s end
    end
    local sec, counts, in_box = '', {}, 0
    local function step_marks(items_)
        if in_box > 0 then return nil end
        local base = counts[sec] or 0
        counts[sec] = base + #items_
        if not prog then return nil end
        local marks
        for i, it in ipairs(items_) do
            local s = prog[sec .. '|' .. (base + i)]
            if s and s.fp and D.fold(it.spans):sub(1, #s.fp) == s.fp then
                marks = marks or {}
                marks[i] = s.shown
            end
        end
        return marks
    end

    local block
    local function list(items_, level, x_base, ordered, marks)
        for n, it in ipairs(items_) do
            local x = x_base + INDENT * level
            local by = y
            if marks and marks[n] and level == 1 then
                kit.step_box(b, x - 17, by + 3, marks[n])
            elseif ordered and level == 1 then
                local num = n .. '.'
                b:text(x - 6 - text_w(num), by, C.gold, num)
            elseif level == 1 then b:rect(x - 13, by + 6, x - 8, by + 11, C.gold)
            elseif level == 2 then b:rect(x - 12, by + 7, x - 8, by + 11, alpha(C.gold_soft, 170))
            elseif level == 3 then b:rect(x - 13, by + 8, x - 7, by + 9, C.dim)
            else b:rect(x - 11, by + 8, x - 9, by + 10, C.dim) end
            y = flow(tokens(it.spans), x, y) + 2
            if it.children and #it.children > 0 then list(it.children, level + 1, x_base, false) end
        end
    end

    -- The texture of a picture is asked for only when the picture is near the view (opts.view = {y0, y1} in content coordinates;
    -- none: every picture): a page lays out one buffer and a texture the pass does not ask for is not held (core/pics.lua). The
    -- size of every picture is asked for, in view or not: the layout needs the ratio. opts.pic_rects, when given, is filled with
    -- {file, y0, y1, asked} for each picture (asked: a texture was asked for), so the window can tell when it has scrolled to one drawn with none.
    -- Each also holds x0, x1 and the one command that is the picture (`line`: its quad, or the dark rect of a picture out of view): the
    -- only command near() decides, so core/pages.lua can redraw a kept layout for another view by replacing just those (D.pic_line).
    local view = opts.view
    local function near(y0, y1) return not view or (y1 >= view.y0 and y0 <= view.y1) end
    local function note(file, y0, y1, asked, x0, x1, t)
        if opts.pic_rects then
            opts.pic_rects[#opts.pic_rects + 1] = {file = file, y0 = y0, y1 = y1, asked = asked, x0 = x0, x1 = x1, line = b.o[#b.o],
                tex = type(t) == 'table' and t.h and {h = t.h, w = t.w, h_px = t.h_px} or nil}
        end
    end
    local function picture(pb, x0)
        local pic = get_pic(pb.file, false)
        local wide = type(pic) == 'table' and pic.h_px > 0 and pic.w / pic.h_px >= WIDE_PIC
        local inline = W < FLOAT_MIN or wide
        local tw = inline and math.min(column_right() - x0, wide and 460 or 260) or PIC_FLOAT
        local th
        if type(pic) == 'table' then
            th = math.floor(tw * pic.h_px / pic.w + 0.5)
        else
            th = math.floor(tw * 0.66)
        end
        local fy = y + (inline and 4 or 0)
        for _, f in ipairs(floats) do if f.y1 > fy then fy = f.y1 + 8 end end
        -- Rule 99 (asa 11): a picture that has to wait below the one floated before it takes the text after it down with it. Left as it
        -- was, the text beside it ran on at the old y, short of the column, and every map fell further behind its own labels until the
        -- last three stood at the right with nothing at their left (414 px). Only the first picture of a run (`clear`: set by
        -- blocks_at), so a run's text still starts beside its first picture. D.DRIFT_FLOATS = false is the old behaviour.
        if D.DRIFT_FLOATS and pb.clear and not inline and fy > y then y = fy end
        local fx = inline and x0 + math.floor((column_right() - x0 - tw) / 2) or column_right() - tw
        b:rect(fx - 1, fy - 1, fx + tw + 1, fy + th + 1, C.rule)
        if type(pic) == 'table' then
            local t = near(fy, fy + th) and get_pic(pb.file) or nil
            if type(t) == 'table' and t.h then
                b:quad(t.h, fx, fy, fx + tw, fy + th, 0, 0, t.w, t.h_px, {255, 255, 255}, 1)
            else
                b:rect(fx, fy, fx + tw, fy + th, {0, 0, 0, 90})      -- out of view: the page is laid out again when it is scrolled to
            end
            note(pb.file, fy, fy + th, near(fy, fy + th), fx, fx + tw, t)
            b:hit({x0 = fx, y0 = fy, x1 = fx + tw, y1 = fy + th, id = 'picture', file = pb.file})
        else
            b:rect(fx, fy, fx + tw, fy + th, {0, 0, 0, 90})
            local msg = pic == 'loading' and 'Loading' or 'Picture unavailable'
            b:text(fx + math.floor((tw - text_w(msg)) / 2), fy + math.floor(th / 2) - 8, C.faint, msg)
            b:hit({x0 = fx, y0 = fy, x1 = fx + tw, y1 = fy + th, id = 'picture', file = pb.file, missing = true})
        end
        local cap = tokens(pb.caption)
        for _, t in ipairs(cap) do if t.k == 'w' then t.col = C.dim end end
        local saved = floats
        floats = {}
        local cw = 0
        for _, t in ipairs(cap) do cw = cw + (t.w or 0) end
        local cy = flow(cap, fx, fy + th + 4, cw < tw and fx + math.floor((tw - cw) / 2) or fx, fx + tw)
        floats = saved
        if opts.float_log then opts.float_log[#opts.float_log + 1] = {k = 'pic', file = pb.file, x0 = fx, y0 = fy, y1 = cy + 6, inline = inline, flow_y = y} end    -- test_pages (rule 130)
        if inline then y = cy + 8
        else floats[#floats + 1] = {x0 = fx, y0 = fy - 4, y1 = cy + 6, level = section_level} end
    end

    -- The infobox as a header: a tab panel's (the tab says its Name) or the page's own (page_title: its Name
    -- stays unless it is the title).
    local function head_rows(head, x0, page_title)
        local LABEL = D.HEAD_LABEL
        local top = y
        y = y + 8
        local lw = 0
        for _, h in ipairs(head) do
            if not D.head_hidden(h, page_title, opts.card) then lw = math.max(lw, text_w(ascii(LABEL[h.key] or h.key))) end
        end
        -- rule 83 (2026-10-21, adoulin 368): the label column is at most D.HEAD_LABEL_CAP of the box; a longer label wraps inside it
        -- (the longest on any other page is 103 px, the cap is 189 px at the narrowest window). nil is the old column (the longest label).
        if D.HEAD_LABEL_CAP then lw = math.min(lw, math.floor(D.HEAD_LABEL_CAP * (X0 + W - x0 - 20))) end
        for _, h in ipairs(head) do
            if not D.head_hidden(h, page_title, opts.card) then
                local label = LABEL[h.key] or h.key
                local lines = text_w(ascii(label)) <= lw and {label} or ops.wrap(label, lw)
                for n, line in ipairs(lines) do b:text(x0 + 10, y + LINE * (n - 1), C.faint, line) end
                local toks = tokens(D.head_spans(h, page_title, opts.card))
                if h.key == 'Description' then for _, t in ipairs(toks) do if t.k == 'w' then t.col = {170, 214, 236} end end end
                local vy = flow(toks, x0 + lw + 24, y, nil, X0 + W - 10)
                y = math.max(vy, y + LINE * #lines)
            end
        end
        y = y + 6
        b:rect(x0, top, X0 + W, y, {0, 0, 0, 50})
        kit.frame(b, x0, top, X0 + W, y, C.edge)
        y = y + 10
    end

    -- Too narrow to float pictures: a run of consecutive pictures is one row of thumbnails (up to
    -- three across, captions under each), never a stack the reader has to scroll past
    -- (2026-10-19: three maps stacked at the narrowest width; test_pages' gap check).
    local function gallery(run, x0, lone)
        local avail = (D.GALLERY_INSET and column_right() or X0 + W) - x0
        local per = math.min(3, #run)
        local gap = 8
        local cw = math.min(260, math.floor((avail - gap * (per - 1)) / per))
        if lone and W >= FLOAT_MIN then      -- rule 150: never wider than the smallest picture of the run itself
            for _, pb in ipairs(run) do
                local pic = get_pic(pb.file, false)
                if type(pic) == 'table' and pic.w > 0 then cw = math.min(cw, pic.w) end
            end
        end
        local left = x0 + math.floor((avail - (per * cw + gap * (per - 1))) / 2)   -- a short row is centred
        if W >= FLOAT_MIN and not lone then
            -- a window wide enough to float pictures, a run of them that the text beside could not fill (jeuno 77: forty faces, 128: thirteen
            -- maps, 2026-10-20): rows of as many as fit at about 160 px, the rows as even as they can be, from the left edge of the text,
            -- below whatever is floated already
            local fit = math.max(1, math.floor((avail + gap) / (GALLERY_PIC + gap)))
            local rows = math.ceil(#run / math.min(#run, fit))
            per = math.ceil(#run / rows)
            cw = math.min(260, math.floor((avail - gap * (per - 1)) / per))
            left = x0
            for _, f in ipairs(floats) do if f.y1 > y then y = f.y1 + 8 end end
            floats = {}
        end
        local i = 1
        y = y + 4
        while i <= #run do
            local row_bottom = y
            for k = 0, per - 1 do
                local pb = run[i + k]
                if not pb then break end
                local pic = get_pic(pb.file, false)
                local fx = left + k * (cw + gap)
                local th = type(pic) == 'table' and math.floor(cw * pic.h_px / pic.w + 0.5) or math.floor(cw * 0.66)
                b:rect(fx - 1, y - 1, fx + cw + 1, y + th + 1, C.rule)
                if type(pic) == 'table' then
                    local t = near(y, y + th) and get_pic(pb.file) or nil
                    if type(t) == 'table' and t.h then
                        b:quad(t.h, fx, y, fx + cw, y + th, 0, 0, t.w, t.h_px, {255, 255, 255}, 1)
                    else
                        b:rect(fx, y, fx + cw, y + th, {0, 0, 0, 90})
                    end
                    note(pb.file, y, y + th, near(y, y + th), fx, fx + cw, t)
                    b:hit({x0 = fx, y0 = y, x1 = fx + cw, y1 = y + th, id = 'picture', file = pb.file})
                else
                    b:rect(fx, y, fx + cw, y + th, {0, 0, 0, 90})
                    local msg = pic == 'loading' and 'Loading' or 'Unavailable'
                    b:text(fx + math.max(0, math.floor((cw - text_w(msg)) / 2)), y + math.floor(th / 2) - 8, C.faint, msg)
                    b:hit({x0 = fx, y0 = y, x1 = fx + cw, y1 = y + th, id = 'picture', file = pb.file, missing = true})
                end
                local cap = tokens(pb.caption)
                for _, t in ipairs(cap) do if t.k == 'w' then t.col = C.dim end end
                local wsum = 0
                for _, t in ipairs(cap) do wsum = wsum + (t.w or 0) end
                local saved = floats
                floats = {}
                local cy = flow(cap, fx, y + th + 4, wsum < cw and fx + math.floor((cw - wsum) / 2) or fx, fx + cw)
                floats = saved
                if cy > row_bottom then row_bottom = cy end
            end
            y = row_bottom + 8
            i = i + per
        end
    end

    -- a loaded picture that is much wider than tall: it gets a row of its own, not a third of one
    local function wide_pic(file)
        local pic = get_pic(file, false)
        return type(pic) == 'table' and pic.h_px > 0 and pic.w / pic.h_px >= WIDE_PIC
    end

    -- How tall is the text that would sit beside a column of floated pictures: the paragraphs and lists after the run (up to the next
    -- block of any other kind), laid out in the room the column leaves. An estimate by the words' widths, in whole lines.
    local function text_beside(list, j, x0)
        local width = math.max(60, W - (x0 - X0) - PIC_FLOAT - 14)
        local function lines_of(spans, w)
            local n, line = 1, 0
            for _, t in ipairs(tokens(spans)) do
                if t.k == 'br' then n = n + 1 line = 0
                else
                    line = line + (t.w or 0)
                    if line > w then n = n + 1 line = t.k == 'sp' and 0 or (t.w or 0) end
                end
            end
            return n
        end
        local h = 0
        while list[j] do
            local bl = list[j]
            if bl.k == 'p' or bl.k == 'sub' then
                h = h + lines_of(bl.spans, width) * LINE + 8
            elseif bl.k == 'list' then
                local function items(its, level)
                    for _, it in ipairs(its) do
                        h = h + lines_of(it.spans, width - INDENT * level) * LINE + 2
                        if it.children then items(it.children, level + 1) end
                    end
                end
                items(bl.items, 1 + (bl.indent or 0))
            else
                break
            end
            j = j + 1
        end
        return h
    end

    -- Does a run of pictures floated at the right stay beside text? Not when the text that follows it is shorter than the column
    -- of pictures: the left side would stand empty for screens (jeuno 128: thirteen maps under a heading and nothing after;
    -- jeuno 77: the faces under their race and hair labels, a list of their own after them). D.FLOAT_RUNS = true is the old
    -- behaviour: every run floats.
    local function run_floats(run, list, j, x0)
        if D.FLOAT_RUNS or #run < 2 then return true end
        local col = 0
        for _, pb in ipairs(run) do
            local pic = get_pic(pb.file, false)
            local th = type(pic) == 'table' and pic.w > 0 and math.floor(PIC_FLOAT * pic.h_px / pic.w + 0.5) or math.floor(PIC_FLOAT * 0.66)
            col = col + th + 4 + 18 + 8
        end
        return text_beside(list, j, x0) >= col
    end

    -- lay out a list of blocks, grouping runs of pictures into galleries when narrow or when the text beside could not fill the column
    local function blocks_at(list, x0, record, lone)
        local i = 1
        while i <= #list do
            local bl = list[i]
            if record then tops[#tops + 1] = y end
            if bl.k == 'h' then       -- rule 130: does the section open with a picture of its own (one that floats)?
                local nx = list[i + 1]
                bl.pic_next = nx ~= nil and nx.k == 'image' and not wide_pic(nx.file)
            end
            if bl.k == 'image' and not wide_pic(bl.file) then
                local run, j = {}, i
                while list[j] and list[j].k == 'image' and not wide_pic(list[j].file) do run[#run + 1] = list[j] j = j + 1 end
                if W < FLOAT_MIN or lone or not run_floats(run, list, j, x0) then
                    gallery(run, x0, lone)
                else                                 -- the whole run floats: decided once, not again for what is left of it
                    for k = i, j - 1 do
                        if record and k > i then tops[#tops + 1] = y end
                        list[k].clear = k == i
                        block(list[k], x0)
                    end
                end
                i = j
            else
                block(bl, x0)
                i = i + 1
            end
        end
    end

    -- A table block: its cells placed on a grid as a browser does (rowspan, colspan), the columns as wide as their text and no
    -- wider than the window allows (a cell wraps inside its column), header rows in the title bar, a th cell in the label colour,
    -- a cell that spans rows kept across them, thin rules between rows.
    local PADX, PADY = 8, 3
    local function table_block(tb, x0)
        PADX = 8
        local nrows = #tb.rows
        local occ, ents, ncols = {}, {}, 0
        for r, row in ipairs(tb.rows) do
            local c = 1
            for _, cell in ipairs(row.cells) do
                while occ[r * 1000 + c] do c = c + 1 end
                local rs, cs = math.min(cell.rs or 1, nrows - r + 1), cell.cs or 1
                local e = {cell = cell, r = r, c = c, rs = rs, cs = cs, head = row.head}
                ents[#ents + 1] = e
                for rr = r, r + rs - 1 do
                    for cc = c, c + cs - 1 do occ[rr * 1000 + cc] = e end
                end
                c = c + cs
                if c - 1 > ncols then ncols = c - 1 end
            end
        end
        if ncols == 0 then return end
        for _, e in ipairs(ents) do
            local toks = tokens(e.cell.spans)
            if D.GLUE_QQQ then D.glue_placeholders(toks) end
            for _, t in ipairs(toks) do
                if t.k == 'w' and not t.kind then
                    if e.head then t.col = C.bold elseif e.cell.th then t.col = C.label end
                end
            end
            local line, nat, mn = 0, 0, 0
            for i, t in ipairs(toks) do
                if t.k == 'br' then
                    if line > nat then nat = line end
                    line = 0
                else
                    line = line + (t.w or 0)
                    if t.k ~= 'sp' then
                        local run = t.w or 0
                        -- a job list ("BRD/RDM/BLU/PUP/RUN") breaks after a slash: its narrowest is its longest piece
                        if t.k == 'w' and t.s and (t.w or 0) > 90 and t.s:find('/', 1, true) then
                            run = 0
                            for piece in t.s:gmatch('[^/]+/?') do run = math.max(run, text_w(piece)) end
                        end
                        local j = i
                        while toks[j].glue and toks[j + 1] and (toks[j + 1].k ~= 'br') do     -- an icon holds on to the word after it
                            local nx = toks[j + 1]
                            if nx.k == 'sp' then
                                if toks[j + 2] and toks[j + 2].k ~= 'sp' and toks[j + 2].k ~= 'br' then run = run + nx.w j = j + 2 run = run + toks[j].w
                                else break end
                            else j = j + 1 run = run + nx.w end
                        end
                        if D.MIN_RUNS then       -- rule 113: the tokens with no space after it (a link and the bracket after it) are one run
                            while toks[j + 1] and toks[j + 1].k ~= 'sp' and toks[j + 1].k ~= 'br' do j = j + 1 run = run + toks[j].w end
                        end
                        if toks[j + 1] and toks[j + 1].k == 'sp' and toks[j + 2] and toks[j + 2].hold then     -- a sign held to this word (rule 94)
                            run = run + toks[j + 1].w + toks[j + 2].w
                            j = j + 2
                            -- a range's dash and its end (rule 157)
                            while toks[j].range and toks[j + 1] and toks[j + 1].k == 'sp' and toks[j + 2] and toks[j + 2].range do
                                run = run + toks[j + 1].w + toks[j + 2].w
                                j = j + 2
                            end
                        end
                        if run > mn then mn = run end
                    end
                end
            end
            if line > nat then nat = line end
            e.toks, e.nat, e.min = toks, nat, mn
        end
        -- column widths: as wide as the widest cell (cw_nat); when that does not fit, shared out between the columns by how
        -- much each can give (down to its longest word, cw_min); below that the words break (the window is narrower than a table)
        local cw_nat, cw_min, tot_n, tot_m
        local function column_widths()
            cw_nat, cw_min = {}, {}
            for c = 1, ncols do cw_nat[c], cw_min[c] = 0, 0 end
            for _, e in ipairs(ents) do
                if e.cs == 1 then
                    cw_nat[e.c] = math.max(cw_nat[e.c], e.nat + 2 * PADX)
                    cw_min[e.c] = math.max(cw_min[e.c], e.min + 2 * PADX)
                end
            end
            for _, e in ipairs(ents) do
                if e.cs > 1 then
                    local have_n, have_m = 0, 0
                    for c = e.c, e.c + e.cs - 1 do have_n = have_n + cw_nat[c] have_m = have_m + cw_min[c] end
                    if e.nat + 2 * PADX > have_n then
                        for c = e.c, e.c + e.cs - 1 do cw_nat[c] = cw_nat[c] + (e.nat + 2 * PADX - have_n) / e.cs end
                    end
                    if e.min + 2 * PADX > have_m then
                        for c = e.c, e.c + e.cs - 1 do cw_min[c] = cw_min[c] + (e.min + 2 * PADX - have_m) / e.cs end
                    end
                end
            end
            tot_n, tot_m = 0, 0
            for c = 1, ncols do tot_n = tot_n + cw_nat[c] tot_m = tot_m + cw_min[c] end
        end
        local avail = right_edge(y, y + 10000) - x0 - (x0 > X0 and not rcap and 10 or 0)   -- inside a box the box's right inset (rule 86) is that margin
        column_widths()
        -- Too narrow at the full padding: the cells' own margins give up half (the personality table of jeuno 77 fits a 480 px
        -- window at 4 px a side and did not at 8, and ran its cells together with bars; bastok 74's rewards likewise).
        if D.COMPACT_TABLES and ncols <= D.COMPACT_COLS then
            for _, pad in ipairs(D.COMPACT_PAD) do
                if tot_m <= avail then break end
                PADX = pad
                column_widths()
            end
        end
        -- Not beside a picture floated at the right: below it, when the columns fit the full width (jeuno 77 at 600 px: the table sat
        -- beside the last face picture and ran its cells on in the room left)
        if tot_m > avail then
            local clear = y
            for _, f in ipairs(floats) do if f.y1 > clear then clear = f.y1 end end
            if clear > y and clear - y <= 400 then
                local full = right_edge(clear, clear + 10000) - x0 - (x0 > X0 and not rcap and 10 or 0)
                if tot_m <= full then y = clear + 4 avail = full end
            end
        end
        if tot_m > avail and D.CARDS then
            -- rule 121: a card per row
            PADX = 8
            local CPADY = 5
            local ww = avail - 2 * PADX
            local function copy_tok(t) local n = {} for k, v in pairs(t) do n[k] = v end return n end
            local function has_ink(toks)
                for _, t in ipairs(toks) do if t.k ~= 'sp' and t.k ~= 'br' then return true end end
                return false
            end
            local function key_of(toks)
                local k = ''
                for _, t in ipairs(toks) do if t.s then k = k .. t.s end end
                return (k:lower():gsub('[^%w]', ''))
            end
            local by_row = {}
            for _, e in ipairs(ents) do by_row[e.r] = by_row[e.r] or {} table.insert(by_row[e.r], e) end
            -- the rows in order: a title band (a header row of one cell across the table), or a body row with the header rows above it
            local items, group, after_body = {}, {}, false
            for r = 1, nrows do
                local es = by_row[r] or {}
                if tb.rows[r].head then
                    if after_body then group = {} after_body = false end
                    if #es == 1 and es[1].cs >= ncols and ncols > 1 then items[#items + 1] = {band = es[1]}
                    else group[#group + 1] = r end
                else
                    after_body = true
                    items[#items + 1] = {row = r, group = group}
                end
            end
            local drawn = {}
            local function count(toks)
                for _, t in ipairs(toks) do
                    if (t.k == 'w' or t.k == 'chip' or t.k == 'tag') and t.s then
                        for w in t.s:gmatch('%S+') do drawn[w] = (drawn[w] or 0) + 1 end
                    end
                end
            end
            local function title_of(es, grp)
                local first
                for _, e in ipairs(es) do if has_ink(e.toks) then first = e break end end
                if not first then return nil end
                -- a column headed "Name" is the row's name, whatever else in the row is a link (a zone)
                for _, e in ipairs(es) do
                    if has_ink(e.toks) then
                        for _, g in ipairs(grp) do
                            local h = occ[g * 1000 + e.c]
                            if h and key_of(h.toks) == 'name' then return e end
                        end
                    end
                end
                if first.cell.th then return first end
                local bold, plain = false, false
                for _, sp in ipairs(first.cell.spans) do
                    if sp.t == 'text' and (sp.s or ''):find('%S') then
                        if sp.b then bold = true else plain = true end
                    elseif sp.t == 'link' then plain = true end
                end
                if bold and not plain then return first end
                for _, e in ipairs(es) do
                    if has_ink(e.toks) then
                        for _, sp in ipairs(e.cell.spans) do if sp.t == 'link' then return e end end
                    end
                end
                return first
            end
            -- the label over a column: its header cells, one above the other joined by "/" (the same text twice is said once, unless the
            -- header rows are named, see `legend`: then each row says its part, "North / North")
            local function label_of(c, grp, named)
                local parts, used = {}, {}
                for _, g in ipairs(grp) do
                    local e = occ[g * 1000 + c]
                    if e and has_ink(e.toks) then
                        local k = named and (g .. key_of(e.toks)) or key_of(e.toks)
                        if not used[k] then used[k] = true parts[#parts + 1] = {toks = e.toks, key = k} end
                    end
                end
                return parts
            end
            local function label_toks(parts)
                local out = {}
                local function add(t) local n = copy_tok(t) if n.k == 'w' and not n.kind then n.col = C.label end out[#out + 1] = n end
                for i, p in ipairs(parts) do
                    if i > 1 then
                        out[#out + 1] = {k = 'sp', w = text_w(' ')}
                        out[#out + 1] = {k = 'w', s = '/', w = text_w('/'), col = C.label, hold = true}
                        out[#out + 1] = {k = 'sp', w = text_w(' ')}
                    end
                    for _, t in ipairs(p.toks) do add(t) end
                end
                if D.CARD_LABEL then
                    -- rule 131: the whole label is one run, each word held to the next across its space (the last, to the value)
                    for n = 1, #out - 1 do
                        local t = out[n]
                        if t.k ~= 'sp' and t.k ~= 'br' then t.glue = true t.lab = true t.spaced = D.CARD_SPACE end
                    end
                end
                if #out > 0 then out[#out].glue = true out[#out].lab = true out[#out].spaced = D.CARD_SPACE end
                return out
            end
            local function card_toks(it)
                local es = by_row[it.row] or {}
                local te = title_of(es, it.group)
                if not te then return nil end
                -- header rows named in the first column ("Room:", "NPC Faces:") over a table whose row names are that column: the names are
                -- said once, as a line above the cards, and each label is its header cells in that order
                local legend
                if te.c == 1 and #it.group >= 2 then
                    local ok, seen = true, {}
                    for _, g in ipairs(it.group) do
                        local e = occ[g * 1000 + 1]
                        local k = e and has_ink(e.toks) and key_of(e.toks)
                        if not k or seen[k] then ok = false break end
                        seen[k] = true
                    end
                    if ok then
                        legend = {}
                        for i, g in ipairs(it.group) do
                            local nt = {}
                            for _, t in ipairs(occ[g * 1000 + 1].toks) do nt[#nt + 1] = copy_tok(t) end
                            local last = nt[#nt]
                            while last and last.k == 'sp' do nt[#nt] = nil last = nt[#nt] end
                            if last and last.k == 'w' and last.s:sub(-1) == ':' and #last.s > 1 then
                                last.s = last.s:sub(1, -2) last.w = text_w(last.s)
                            end
                            if i > 1 then
                                legend[#legend + 1] = {k = 'sp', w = text_w(' ')}
                                legend[#legend + 1] = {k = 'w', s = '/', w = text_w('/'), col = C.bold, hold = true}
                                legend[#legend + 1] = {k = 'sp', w = text_w(' ')}
                            end
                            for _, t in ipairs(nt) do if t.k == 'w' and not t.kind then t.col = C.bold end legend[#legend + 1] = t end
                        end
                    end
                end
                it.legend = legend
                local ink, own = 0, 0
                for _, e in ipairs(es) do
                    if has_ink(e.toks) then
                        ink = ink + 1
                        for _, t in ipairs(e.toks) do if t.k == 'br' then own = own + 1 end end
                    end
                end
                local plain = #it.group == 0 and ink > 1      -- rule 143: no header row, so no label and no title
                local function note_plain(toks)
                    if not plain then return toks end
                    local brs = 0
                    for _, t in ipairs(toks) do if t.k == 'br' then brs = brs + 1 end end
                    D.plain[#D.plain + 1] = {brs = brs, own = own}
                    return toks
                end
                if plain and D.PLAIN_GRID then
                    -- the row's cells run on, 16 px apart, each held in one piece when it is a few words
                    local toks = {}
                    for _, e in ipairs(es) do
                        if has_ink(e.toks) then
                            if #toks > 0 then toks[#toks + 1] = {k = 'sp', w = 16} end
                            local words, n0 = 0, #toks
                            for _, t in ipairs(e.toks) do
                                if t.k == 'w' then words = words + 1 end
                                toks[#toks + 1] = copy_tok(t)
                            end
                            if words >= 2 and words <= 4 then
                                for n = n0 + 1, #toks - 2 do
                                    if toks[n].k == 'w' and toks[n + 1].k == 'sp' and toks[n + 2].k == 'w' then
                                        toks[n].glue = true toks[n].spaced = true
                                    end
                                end
                            end
                        end
                    end
                    return note_plain(toks)
                end
                local toks = {}
                for _, t in ipairs(te.toks) do
                    local n = copy_tok(t)
                    if n.k == 'w' and not n.kind then n.col = C.bold end
                    toks[#toks + 1] = n
                end
                local npairs, prev_multi, after_multi = 0, false, nil
                for _, e in ipairs(es) do
                    if e ~= te and has_ink(e.toks) then
                        local multi = false
                        for _, t in ipairs(e.toks) do if t.k == 'br' then multi = true end end
                        if npairs == 0 or multi or (prev_multi and D.CARD_AFTER_LIST) then toks[#toks + 1] = {k = 'br'}
                        else toks[#toks + 1] = {k = 'sp', w = 16} end
                        npairs = npairs + 1
                        prev_multi = multi
                        local parts, seen = {}, {}
                        for c = e.c, e.c + e.cs - 1 do
                            for _, p in ipairs(label_of(c, it.group, legend ~= nil)) do
                                if not seen[p.key] then seen[p.key] = true parts[#parts + 1] = p end
                            end
                        end
                        local lt = label_toks(parts)
                        count(lt)
                        local before = #toks
                        for _, t in ipairs(lt) do toks[#toks + 1] = t end
                        if #lt > 0 then toks[#toks + 1] = {k = 'sp', w = text_w(' ')} end
                        for _, t in ipairs(e.toks) do toks[#toks + 1] = copy_tok(t) end
                        for n = before + #lt + 1, #toks do
                            if toks[n].k ~= 'sp' then D.labels[#D.labels + 1] = {label = lt, value = toks[n]} break end
                        end
                        if after_multi and toks[before + 1] then     -- (test_pages, rule 132) where the pair stands against the list before it
                            D.afterlist[#D.afterlist + 1] = {a = after_multi, b = toks[before + 1]}
                        end
                        after_multi = nil
                        if multi then
                            for n = #toks, before + 1, -1 do if toks[n].k ~= 'sp' and toks[n].k ~= 'br' then after_multi = toks[n] break end end
                        end
                    end
                end
                return note_plain(toks)
            end
            local real_b, real_floats = b, floats
            b = ops.new()
            floats = {}
            local shown_items, announced = {}, nil
            local function add_item(it)
                it.h = flow(it.toks, 0, 0, nil, ww) + 2 * it.pady
                shown_items[#shown_items + 1] = it
            end
            for _, it in ipairs(items) do
                if it.band then
                    local toks = {}
                    for _, t in ipairs(it.band.toks) do toks[#toks + 1] = copy_tok(t) end
                    count(toks)
                    it.toks = toks
                    it.pady = PADY
                else
                    it.toks = card_toks(it)
                    it.pady = CPADY
                end
                if it.toks then
                    if it.legend and announced ~= it.group then
                        announced = it.group
                        count(it.legend)
                        add_item({band = true, toks = it.legend, pady = PADY})
                    end
                    add_item(it)
                end
            end
            b, floats = real_b, real_floats
            D.cards[#D.cards + 1] = {tb = tb, drawn = drawn}
            local top, yy = y, y
            for _, it in ipairs(shown_items) do yy = yy + it.h end
            b:rect(x0, top, x0 + avail, yy, {0, 0, 0, 60})
            yy = y
            for n, it in ipairs(shown_items) do
                if it.band then
                    b:rect(x0, yy, x0 + avail, yy + it.h, {120, 52, 52, 200})
                elseif n > 1 and not shown_items[n - 1].band then
                    b:rect(x0, yy, x0 + avail, yy + 1, C.rule)
                end
                flow(it.toks, x0 + PADX, yy + it.pady, nil, x0 + PADX + ww)
                yy = yy + it.h
            end
            kit.frame(b, x0, top, x0 + avail, yy, alpha(C.gold, 110))
            y = yy + 10
            return
        end
        if tot_m > avail then
            -- Too narrow for the columns even at their narrowest: each row runs its cells on, thin bars between them, wrapping
            -- at word breaks (a word is never cut for a column). Header rows stay in the title bar.
            D.runon[#D.runon + 1] = ncols
            local ww = avail - 2 * PADX
            local rows_toks, rowh = {}, {}
            local real_b, real_floats = b, floats
            b = ops.new()
            floats = {}
            for r = 1, nrows do
                local toks = {}
                for _, e in ipairs(ents) do
                    if e.r == r then
                        if #toks > 0 then
                            toks[#toks + 1] = {k = 'sp', w = 8}
                            toks[#toks + 1] = {k = 'bar', w = 1}
                            toks[#toks + 1] = {k = 'sp', w = 8}
                        end
                        for _, t in ipairs(e.toks) do toks[#toks + 1] = t end
                    end
                end
                rows_toks[r] = toks
                rowh[r] = flow(toks, 0, 0, nil, ww) + 2 * PADY
            end
            b, floats = real_b, real_floats
            local top, yy = y, y
            for r = 1, nrows do yy = yy + rowh[r] end
            b:rect(x0, top, x0 + avail, yy, {0, 0, 0, 60})
            yy = y
            for r = 1, nrows do
                if tb.rows[r].head then
                    b:rect(x0, yy, x0 + avail, yy + rowh[r], {120, 52, 52, 200})
                elseif r > 1 and not tb.rows[r - 1].head then
                    b:rect(x0, yy, x0 + avail, yy + 1, C.rule)
                end
                flow(rows_toks[r], x0 + PADX, yy + PADY, nil, x0 + PADX + ww)
                yy = yy + rowh[r]
            end
            kit.frame(b, x0, top, x0 + avail, yy, alpha(C.gold, 110))
            y = yy + 10
            return
        end
        local cw = {}
        if tot_n <= avail then
            for c = 1, ncols do cw[c] = math.ceil(cw_nat[c]) end
        elseif tot_m >= avail then
            for c = 1, ncols do cw[c] = math.max(24, math.floor(cw_min[c] * avail / tot_m)) end
        else
            for c = 1, ncols do
                cw[c] = math.floor(cw_min[c] + (cw_nat[c] - cw_min[c]) * (avail - tot_m) / (tot_n - tot_m))
            end
        end
        local tw = 0
        for c = 1, ncols do tw = tw + cw[c] end
        while tw > avail do                       -- rounding, or the 24 px floor: take it from the widest column
            local wi = 1
            for c = 2, ncols do if cw[c] > cw[wi] then wi = c end end
            if cw[wi] <= 20 then break end
            cw[wi] = cw[wi] - 1
            tw = tw - 1
        end
        local colx = {}
        local xx = x0
        for c = 1, ncols do colx[c] = xx xx = xx + cw[c] end
        local function cell_w(e)
            local w = 0
            for c = e.c, math.min(ncols, e.c + e.cs - 1) do w = w + cw[c] end
            return w - 2 * PADX
        end
        -- heights: each cell laid out once into a builder that is thrown away
        local real_b, real_floats = b, floats
        b = ops.new()
        floats = {}
        for _, e in ipairs(ents) do e.h = flow(e.toks, 0, 0, nil, cell_w(e)) end
        do       -- for rule 124 (test_pages): how this grid came out
            local wrapped, hw = 0, 0
            for _, e in ipairs(ents) do
                if e.h > LINE then wrapped = wrapped + (e.head and 0 or 1) end
            end
            D.grids[#D.grids + 1] = {tb = tb, ncols = ncols, pad = PADX, wrapped = wrapped, cells = #ents, avail = avail, need = tot_n}
        end
        b, floats = real_b, real_floats
        local rowh = {}
        for r = 1, nrows do rowh[r] = LINE + 2 * PADY end
        for _, e in ipairs(ents) do
            if e.rs == 1 and e.h + 2 * PADY > rowh[e.r] then rowh[e.r] = e.h + 2 * PADY end
        end
        for _, e in ipairs(ents) do
            if e.rs > 1 then
                local have = 0
                for r = e.r, e.r + e.rs - 1 do have = have + rowh[r] end
                if e.h + 2 * PADY > have then
                    rowh[e.r + e.rs - 1] = rowh[e.r + e.rs - 1] + (e.h + 2 * PADY - have)
                end
            end
        end
        local rowy = {}
        local yy = y
        for r = 1, nrows do rowy[r] = yy yy = yy + rowh[r] end
        local top, bottom = y, yy
        b:rect(x0, top, x0 + tw, bottom, {0, 0, 0, 60})
        for r = 1, nrows do
            if tb.rows[r].head then b:rect(x0, rowy[r], x0 + tw, rowy[r] + rowh[r], {120, 52, 52, 200}) end
        end
        for r = 1, nrows - 1 do
            if not tb.rows[r].head then
                for c = 1, ncols do
                    if occ[r * 1000 + c] ~= occ[(r + 1) * 1000 + c] then
                        b:rect(colx[c], rowy[r + 1], colx[c] + cw[c], rowy[r + 1] + 1, C.rule)
                    end
                end
            end
        end
        for _, e in ipairs(ents) do
            local ex = colx[e.c] + PADX
            flow(e.toks, ex, rowy[e.r] + PADY, nil, ex + cell_w(e))
        end
        kit.frame(b, x0, top, x0 + tw, bottom, alpha(C.gold, 110))
        y = bottom + 10
    end

    local function tabs_block(tb, x0)
        local active = tabs_state[tb.group] or 1
        if active > #tb.tabs then active = 1 end
        -- the strip: one button per path, wrapping when narrow
        tops.strip = tops.strip or {}
        tops.strip[tb.group] = y
        local x, ty = x0, y + 6
        local bh = 40
        for i, t in ipairs(tb.tabs) do
            local lab, sub = ascii(t.label), ascii(t.sub)
            local w = math.max(title_w(lab, 11), text_w(sub)) + 24
            if x > x0 and x + w > X0 + W then x, ty = x0, ty + bh + 6 end
            local on = i == active
            b:rect(x, ty, x + w, ty + bh, on and {0, 0, 0, 120} or {0, 0, 0, 60})
            kit.frame(b, x, ty, x + w, ty + bh, on and C.press_edge or C.edge)
            if on then b:rect(x + 1, ty + bh - 3, x + w - 1, ty + bh - 1, C.gold) end
            b:title(x + 12, ty + 6, 11, on and C.gold or C.bold, lab)
            b:text(x + 12, ty + 20, on and C.gold_soft or C.dim, sub)
            b:hit({x0 = x, y0 = ty, x1 = x + w, y1 = ty + bh, id = 'tab', group = tb.group, i = i, label = lab})
            x = x + w + 6
        end
        y = ty + bh + 12
        local p = tb.tabs[active]
        local any = false          -- a box with nothing left in it is not drawn
        for _, h in ipairs(p.head) do if not D.head_hidden(h, nil, opts.card) then any = true end end
        if any then head_rows(p.head, x0) end
        local saved_sec = sec
        sec = p.label or ''                -- steps in a tab are counted per tab
        blocks_at(p.blocks, x0, true)
        sec = saved_sec
        for _, f in ipairs(floats) do if f.y1 > y then y = f.y1 end end
        floats = {}
    end

    block = function(bl, x0)
        if bl.k == 'h' then heading(bl, x0)
        elseif bl.k == 'p' then
            y = flow(tokens(bl.spans), x0, y) + 8
        elseif bl.k == 'sub' then
            y = y + 4
            local toks = tokens(bl.spans)
            for _, t in ipairs(toks) do if t.k == 'w' and not t.kind then t.col = C.label end end
            y = flow(toks, x0, y) + 4
        elseif bl.k == 'list' then
            list(bl.items, 1 + (bl.indent or 0), x0, bl.ordered, step_marks(bl.items))
            y = y + 6
        elseif bl.k == 'rule' then
            y = y + 4
            b:rect(x0, y, right_edge(y, y + 1), y + 1, C.rule)
            y = y + 9
        elseif bl.k == 'image' then
            picture(bl, x0)
        elseif bl.k == 'table' then
            table_block(bl, x0)
        elseif bl.k == 'tabs' then
            tabs_block(bl, x0)
        elseif bl.k == 'box' then
            local r = right_edge(y, y + 60)
            local bx0, bx1 = x0, r
            local top = y
            local title = ''
            for _, s in ipairs(bl.title) do title = title .. (s.s or '') end
            title = ascii(title)
            -- a title wider than the box wraps in its bar (the bar grows a line at a time) instead of running out of the column
            local tlines = text_w(title) <= bx1 - bx0 - 16 and {title} or ops.wrap(title, bx1 - bx0 - 16)
            -- rule 82: a box with no title (a wiki table of one cell and no header row) draws no bar: its frame and wash only
            local titled = title:find('%S') ~= nil or D.EMPTY_BAR
            local bar = titled and 20 + 18 * (#tlines - 1) or 0
            -- frame under the content: the builder keeps order, so draw the frame first with a guessed
            -- height, then patch it: lay the inside out into its own builder and copy it after
            local inner = ops.new()
            local saved_b = b
            b = inner
            y = y + (titled and 24 + 18 * (#tlines - 1) or 6)
            local saved_cap = rcap
            if (D.BOX_RIGHT_PAD or 0) > 0 then rcap = bx1 - D.BOX_RIGHT_PAD end      -- rule 86: the same room from the right border as the left padding
            in_box = in_box + 1               -- a box's bullets are not steps
            -- rule 150: a box holding nothing but pictures (the wiki's map box) draws them in the box's width, not floated
            local lone = false
            if D.LONE_PICTURE and #bl.blocks > 0 then
                lone = true
                for _, c in ipairs(bl.blocks) do if c.k ~= 'image' then lone = false break end end
            end
            blocks_at(bl.blocks, x0 + 10, false, lone)
            in_box = in_box - 1
            rcap = saved_cap
            for _, f in ipairs(floats) do          -- a picture floated inside the box is part of it
                if f.y0 >= top - 10 and f.y1 > y then y = f.y1 end
            end
            y = y - 2
            b = saved_b
            b:rect(bx0, top, bx1, y, {0, 0, 0, 60})
            if titled then
                b:rect(bx0, top, bx1, top + bar, {120, 52, 52, 200})
                for n, line in ipairs(tlines) do b:text(bx0 + 8, top + 2 + 18 * (n - 1), C.bold, line) end
            end
            for _, line in ipairs(inner.o) do b.o[#b.o + 1] = line end
            for _, h in ipairs(inner.hits) do b.hits[#b.hits + 1] = h end
            kit.frame(b, bx0, top, bx1, y, alpha(C.gold, 110))
            if opts.box_rects then opts.box_rects[#opts.box_rects + 1] = {x0 = bx0, y0 = top, x1 = bx1, y1 = y} end      -- test_pages (rule 86)
            y = y + 10
        end
    end

    -- a page without tabs starts with its infobox (a quest's start NPC, requirements, rewards); a page with
    -- tabs shows each panel's own
    if not doc.tabbed and #doc.head > 0 then
        local any = false
        for _, h in ipairs(doc.head) do if not D.head_hidden(h, doc.title, opts.card) then any = true end end
        if any then head_rows(doc.head, X0, doc.title or '') end
    end
    blocks_at(doc.blocks, X0, true)
    for _, f in ipairs(floats) do if f.y1 > y then y = f.y1 end end
    tok_memo = nil
    return y + 10, tops
end

-- The command a picture's rect (opts.pic_rects) draws for texture t: its quad, or (t not a texture: a picture out of view, or the
-- textures a pass may hold were all taken) the dark rect. The very calls picture() and gallery() make, so the very same text.
function D.pic_line(r, t)
    local b = ops.new()
    if type(t) == 'table' and t.h then
        b:quad(t.h, r.x0, r.y0, r.x1, r.y1, 0, 0, t.w, t.h_px, {255, 255, 255}, 1)
    else
        b:rect(r.x0, r.y0, r.x1, r.y1, {0, 0, 0, 90})
    end
    return b.o[1]
end

-- a compact bar of a group's tabs at the top of the viewport (window-local x0, y0, width w)
function D.sticky(b, doc, group, active, x0, y0, w, hover_i)
    local tabs
    local function find(bs)
        for _, bl in ipairs(bs) do
            if bl.k == 'tabs' and bl.group == group then tabs = bl.tabs return end
            if bl.k == 'box' then find(bl.blocks) end
        end
    end
    find(doc.blocks)
    if not tabs then return end
    b:rect(x0 - 4, y0, x0 + w + 2, y0 + 28, {8, 12, 24, 255})        -- opaque: the page must not show through (qa showthrough)
    b:rect(x0 - 4, y0 + 28, x0 + w + 2, y0 + 29, C.rule)
    -- the whole bar takes the mouse, first so the labels' hits (scanned last to first) win: a click on its blank part must not
    -- reach the link drawn under it (review UI-3). It draws nothing.
    b:hit({x0 = x0 - 4, y0 = y0, x1 = x0 + w + 2, y1 = y0 + 29, id = 'sticky_bar', group = group, sticky = true})
    local x = x0 + 4
    for i, t in ipairs(tabs) do
        local lab = ascii(t.label)
        local tw = title_w(lab, 10)
        if x + tw > x0 + w then break end
        local on = i == active
        b:title(x, y0 + 8, 10, on and C.gold or (hover_i == i and C.gold_soft or C.dim), lab)
        if on then b:rect(x, y0 + 24, x + tw, y0 + 26, C.gold) end
        b:hit({x0 = x - 6, y0 = y0, x1 = x + tw + 6, y1 = y0 + 28, id = 'tab', group = group, i = i, sticky = true})
        x = x + tw + 22
    end
end

-- ------------------------------------------------------------------------------------- hover
local KINDS = {npc = 'NPC', zone = 'Area', item = 'Item', ki = 'Key Item', mob = 'Monster', spell = 'Spell', page = 'Wiki page'}

-- underline every word of the hovered link
function D.overlay(b, hits, hit, to_win)
    if hit.id == 'link' then
        local col = C[hit.span.kind] or C.page
        for _, h in ipairs(hits) do
            if h.span == hit.span then
                local x0, y0 = to_win(h.x0, h.y1 - 1)
                local x1, y1 = to_win(h.x1, h.y1)
                b:rect(x0, y0, x1, y1, col)
            end
        end
    elseif hit.id == 'picture' or hit.id == 'tab' then
        local x0, y0 = to_win(hit.x0, hit.y0)
        local x1, y1 = to_win(hit.x1, hit.y1)
        kit.frame(b, x0, y0, x1, y1, C.hover_edge)
    end
end

-- the tooltip: what the link is and where a click goes. opens(span) -> 'Chronicle' | 'this page' | 'BG-wiki' | 'the browser'
-- y: under the link; above: its top, where the tooltip goes when under it would pass screen_h
function D.tooltip(b, hit, mx, y, screen_w, opens, screen_h, above)
    if hit.id == 'link' then
        local sp = hit.span
        local kind = sp.kind == 'mission' and 'Mission' or (sp.kind == 'quest' and 'Quest' or KINDS[sp.kind] or 'Wiki page')
        local name = sp.name or sp.to or sp.s
        kit.tooltip(b, mx + 14, y + 8, name, {{kind .. '  (opens in ' .. opens(sp) .. ')', C[sp.kind] or C.page}},
            sp.kind == 'item' and sp.id or nil, screen_w, screen_h, above)
    elseif hit.id == 'picture' then
        kit.tooltip(b, mx + 14, y + 8, hit.file, {{hit.missing and 'Click to open in BG-wiki' or 'Click to enlarge', C.dim}}, nil, screen_w, screen_h, above)
    end
end

-- the enlarged picture: a window titled by its caption, the picture at its loaded size (512 px max)
function D.enlarged(b, pic, title, sw, sh, wx, wy, ww)
    local pw, ph = pic.w, pic.h_px
    local ox = math.max(0, math.min(wx + math.floor((ww - pw) / 2) - 16, sw - pw - 32))
    local oy = math.max(0, math.min(wy + 120, sh - ph - 60))
    b:win(ox, oy, pw + 32, ph + 60, title, true)
    b:quad(pic.h, ox + 16, oy + 18, ox + 16 + pw, oy + 18 + ph, 0, 0, pw, ph, {255, 255, 255}, 0)
    local cap = 'Click to close'
    b:text(ox + 16 + pw - text_w(cap), oy + ph + 30, C.dim, cap)
end

return D
