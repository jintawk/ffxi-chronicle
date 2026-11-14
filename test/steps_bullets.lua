--[[
    test/steps_bullets.lua - the step bullets of one Chronicle page, as JSON, for the step mapping proposer
    (the step proposer). Data only; draws nothing.

        cd addons/chronicle
        "/c/Program Files (x86)/Lua/5.1/lua.exe" test/steps_bullets.lua pages/quests/sandoria/27.lua

    One object per top-level bullet, counted exactly as ui/doc.lua's checkbox drawing counts step bullets (D.draw's
    step_marks, D.step_text): the items of every list directly in the page's blocks or in a tab's blocks, numbered per
    tab label ('' outside tabs) in page order; lists inside boxes are not counted. Every counted bullet is printed (not
    only the Walkthrough's), with `head` = the last heading above it in its tab, so the reader can filter.

      {n, tab, head, indent, fp, fold, text, npcs[], zones[], items[{name,id}], key_items[], quests[], mobs[], pages[],
       sub[{depth, text, npcs[], ...}]}

    indent > 0: the bullet's list is indented (':*' in the markup); ui/doc.lua counts it but draws no checkbox on it
    (a checkbox needs level 1), so it can never be a step.

    fp = the first six words of core/progress_engine's fold of the bullet's spans (the mapping's fingerprint).
]]

package.path = './?.lua;' .. package.path
local D = require('ui/doc')
local E = require('core/progress_engine')

local path = arg[1]
if not path then io.stderr:write('usage: lua test/steps_bullets.lua <page file>\n') os.exit(2) end
local ok, page = pcall(dofile, path)
if not ok or type(page) ~= 'table' then io.stderr:write('cannot load ' .. path .. ': ' .. tostring(page) .. '\n') os.exit(1) end
local doc = D.decode(page)

-- ------------------------------------------------------------------ JSON
local function jstr(s)
    s = tostring(s)
    s = s:gsub('[%c"\\]', function(c)
        if c == '"' then return '\\"' elseif c == '\\' then return '\\\\'
        elseif c == '\n' then return '\\n' elseif c == '\t' then return '\\t' end
        return ('\\u%04x'):format(c:byte())
    end)
    return '"' .. s .. '"'
end
local json
local function is_array(t)
    if next(t) == nil then return true end
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n == #t
end
json = function(v)
    local ty = type(v)
    if ty == 'nil' then return 'null'
    elseif ty == 'number' or ty == 'boolean' then return tostring(v)
    elseif ty == 'string' then return jstr(v)
    elseif ty == 'table' then
        local out = {}
        if v.__keys then
            for _, k in ipairs(v.__keys) do out[#out + 1] = jstr(k) .. ":" .. json(v[k]) end
            return '{' .. table.concat(out, ',') .. '}'
        elseif is_array(v) then
            for _, x in ipairs(v) do out[#out + 1] = json(x) end
            return '[' .. table.concat(out, ',') .. ']'
        end
        local keys = {}
        for k in pairs(v) do keys[#keys + 1] = k end
        table.sort(keys)
        for _, k in ipairs(keys) do out[#out + 1] = jstr(k) .. ':' .. json(v[k]) end
        return '{' .. table.concat(out, ',') .. '}'
    end
    return 'null'
end

-- ------------------------------------------------------------------ one item's text and links
local function plain(spans)
    local t = {}
    for _, sp in ipairs(spans or {}) do if sp.t ~= 'icon' then t[#t + 1] = sp.s or '' end end
    return (table.concat(t):gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', ''))
end

local function links(spans, o)
    o.npcs, o.zones, o.items, o.key_items, o.quests, o.mobs, o.pages = {}, {}, {}, {}, {}, {}, {}
    for _, sp in ipairs(spans or {}) do
        if sp.t == 'link' then
            if sp.kind == 'npc' then o.npcs[#o.npcs + 1] = sp.to or sp.s
            elseif sp.kind == 'zone' then o.zones[#o.zones + 1] = sp.to or sp.s
            elseif sp.kind == 'item' then o.items[#o.items + 1] = {__keys = {'name', 'id'}, name = sp.to or sp.s, id = sp.id}
            elseif sp.kind == 'ki' then o.key_items[#o.key_items + 1] = sp.to or sp.s
            elseif sp.kind == 'quest' or sp.kind == 'mission' then o.quests[#o.quests + 1] = sp.to or sp.s
            elseif sp.kind == 'mob' then o.mobs[#o.mobs + 1] = sp.to or sp.s
            elseif sp.kind == 'page' then o.pages[#o.pages + 1] = sp.to or sp.s end
        elseif sp.t == 'icon' and sp.icon == 'item' and sp.name then
            -- an item icon carries the name and id of the item link that follows it; the link is enough
        end
    end
    return o
end

local KEYS = {'n', 'tab', 'head', 'indent', 'fp', 'fold', 'text', 'npcs', 'zones', 'items', 'key_items', 'quests', 'mobs', 'pages', 'sub'}
local SUBKEYS = {'depth', 'text', 'npcs', 'zones', 'items', 'key_items', 'quests', 'mobs', 'pages'}

local function subs(children, depth, out)
    for _, ch in ipairs(children or {}) do
        local o = links(ch.spans, {__keys = SUBKEYS, depth = depth, text = plain(ch.spans)})
        out[#out + 1] = o
        subs(ch.children, depth + 1, out)
    end
    return out
end

-- ------------------------------------------------------------------ walk as ui/doc.lua counts steps
local bullets = {}
local counts = {}
local function walk(blocks, sec, tablabel)
    local head = nil
    for _, bl in ipairs(blocks) do
        if bl.k == 'h' then head = plain(bl.spans)
        elseif bl.k == 'list' then
            for _, it in ipairs(bl.items) do
                counts[sec] = (counts[sec] or 0) + 1
                local fold = E.fold(it.spans)
                local words = {}
                for w in fold:gmatch('%S+') do
                    if #words < 6 then words[#words + 1] = w end
                end
                local o = links(it.spans, {__keys = KEYS, n = counts[sec], tab = tablabel, head = head,
                                           indent = bl.indent or 0,
                                           fp = table.concat(words, ' '), fold = fold, text = plain(it.spans)})
                o.sub = subs(it.children, 2, {})
                bullets[#bullets + 1] = o
            end
        elseif bl.k == 'tabs' then
            for _, t in ipairs(bl.tabs) do walk(t.blocks, t.label or '', t.label) end
        end
        -- boxes ('box'): their bullets are not steps (ui/doc.lua in_box), so they are not walked
    end
end
walk(doc.blocks, '', nil)

io.write(json({__keys = {'page', 'title', 'bullets'}, page = path, title = doc.title, bullets = bullets}), '\n')
