--[[
    Chronicle metadata, loaded per area.

    v1 required all 3.25 MB of wiki data at load. v2 keeps none of it resident:
    meta/<cat>s/<area>.lua (no walkthrough text, requirements resolved to ids)
    is read when an area is needed and dropped again once KEEP newer areas have
    been used, and meta/index.lua (normalised name -> areas) is read only when
    a name has to be found across areas.
]]

local meta = {}

meta.LOSSY_MIN = 3 -- reward_from_page: fewest lines of a page's Rewards row for the lossy-card rule (rule 81)

local KEEP = 2 -- areas per category held at once (the open list + one guide)

local root = ''
local cache = {quest = {}, mission = {}} -- area -> {data, norm}
local order = {quest = {}, mission = {}} -- most recent last
local index = nil

function meta.set_root(path) root = path or '' end
function meta.get_root() return root end

-- Same normalisation as v1 data.lua.
function meta.normalize(name)
    if not name then return '' end
    return (name:lower():gsub('%s*%([Qq]uest%)%s*$', ''):gsub('%s*%([Mm]ission%)%s*$', ''))
end
local normalize = meta.normalize

-- Rule 173 (vision wave qcw1, quest wotg 7, 8, 9): the game's chat font draws ASCII only (a character outside it is drawn as a "?", and a
-- line may break after it: "Bronze Ribbon of Service" over a lone "?"). The pages are folded at build time (the page converter FOLD);
-- v1's metadata holds the same characters (the campaign ribbon rank "Bronze Ribbon of Service" with the section sign, an em dash in two
-- descriptions) and is folded here, as it is read, with the same table. meta.FOLD_ASCII = false is the old reading.
meta.FOLD = {
    ['\194\160']=' ', ['\194\167']='S', ['\194\169']='(C)', ['\194\171']='<<', ['\194\173']='', ['\194\174']='(R)', ['\194\176']=' deg',
    ['\194\183']='-', ['\194\187']='>>', ['\194\188']='1/4', ['\194\189']='1/2', ['\194\190']='3/4', ['\195\151']='x', ['\206\169']='O',
    ['\226\128\130']=' ', ['\226\128\131']=' ', ['\226\128\137']=' ', ['\226\128\139']='', ['\226\128\140']='', ['\226\128\141']='',
    ['\226\128\142']='', ['\226\128\143']='', ['\226\128\144']='-', ['\226\128\145']='-', ['\226\128\146']='-', ['\226\128\147']='-',
    ['\226\128\148']='-', ['\226\128\149']='-', ['\226\128\152']='\'', ['\226\128\153']='\'', ['\226\128\156']='"', ['\226\128\157']='"',
    ['\226\128\162']='-', ['\226\128\166']='...', ['\226\128\175']=' ', ['\226\129\160']='', ['\226\132\162']='(TM)', ['\226\134\144']='<',
    ['\226\134\145']='^', ['\226\134\146']='>', ['\226\134\147']='v', ['\226\134\148']='<->', ['\226\135\144']='<', ['\226\135\145']='^',
    ['\226\135\146']='>', ['\226\135\147']='v', ['\226\135\148']='<=>', ['\226\136\146']='-', ['\226\136\151']='*', ['\226\136\174']='S',
    ['\226\137\136']='~', ['\226\137\164']='<=', ['\226\137\165']='>=', ['\226\150\160']='[]', ['\226\150\161']='[]', ['\226\150\170']='*',
    ['\226\150\171']='*', ['\226\150\178']='^', ['\226\150\182']='>', ['\226\150\186']='>', ['\226\150\188']='v', ['\226\151\128']='<',
    ['\226\151\132']='<', ['\226\151\134']='*', ['\226\151\135']='*', ['\226\151\139']='o', ['\226\151\143']='*', ['\226\152\133']='*',
    ['\226\152\134']='*', ['\226\153\128']='(F)', ['\226\153\130']='(M)', ['\226\154\160']='(!)', ['\226\158\148']='>', ['\226\158\158']='>',
    ['\226\158\161']='>', ['\239\187\191']='', ['\240\159\148\176']='(*)',
}
function meta.fold(s)
    if type(s) ~= 'string' or not s:find('[\128-\255]') then return s end
    return (s:gsub('[\194-\244][\128-\191]*', meta.FOLD))
end
local TEXT_FIELDS = {'description', 'reward', 'start_npc', 'start_zone', 'start_pos', 'fame', 'fame_level', 'title', 'repeatable'}
local function fold_entry(e)
    if type(e) ~= 'table' then return end
    -- Rule 175 (vision wave qcw1, quest wotg 10): v1 lost the space of "3000 gil" (the page's Rewards row has it): an amount of gil is set
    -- off from its number. meta.GIL_SPACE = false is the old reading.
    if meta.GIL_SPACE ~= false and type(e.reward) == 'string' then e.reward = e.reward:gsub('(%d)([Gg]il)%f[%A]', '%1 %2') end
    -- Rule 194 (vision wave camp2, mission campaign 266 and 221, major / minor): v1's reward text has the number straight against the name
    -- ("900Allied Notes", "666Experience Points"), copied from the wiki's HTML, which has no space there either (rule 193 set it in the page's
    -- own header; the card keeps v1's letters, so it kept v1's spacing). A digit straight against a capital in a card reward gets its space; the
    -- only two rewards of the v1 data. meta.NUM_SPACE = false is the old reading.
    if meta.NUM_SPACE ~= false and type(e.reward) == 'string' then e.reward = e.reward:gsub('(%d)(%u)', '%1 %2') end
    for _, f in ipairs(TEXT_FIELDS) do
        if type(e[f]) == 'string' then e[f] = meta.fold(e[f]) end
    end
    if type(e.requirements) == 'table' then
        for _, r in ipairs(e.requirements) do
            if type(r) == 'table' and type(r.name) == 'string' then r.name = meta.fold(r.name) end
        end
    end
end

local function read(rel)
    local f = loadfile(root .. rel)
    if not f then return nil end
    local ok, t = pcall(f)
    if ok and type(t) == 'table' then return t end
    return nil
end

local function touch(cat, area)
    local o = order[cat]
    for i = #o, 1, -1 do
        if o[i] == area then table.remove(o, i) end
    end
    o[#o + 1] = area
    while #o > KEEP do
        cache[cat][table.remove(o, 1)] = nil
    end
end

-- Entries v1's scrape holds only an id for (a name three nations share, "Eco-Warrior", was too ambiguous to scrape
-- for the wiki) have an empty guide card, though the walkthrough page converted from BG-wiki has the infobox. A stub
-- takes what its page's header says: starting NPC / zone / position, fame, title, repeatable, description, rewards,
-- previous and next quest. Only fields the entry lacks are filled; an entry with any data of its own is left as it is.
local function is_stub(e)
    return type(e) == 'table' and e.id and not (e.start_npc or e.start_zone or e.reward or e.description)
end

local NL = string.char(10)

local function plain(spans)
    local out = {}
    for _, sp in ipairs(spans) do
        if sp.t == 'br' then out[#out + 1] = NL
        elseif sp.s and sp.t ~= 'tag' then out[#out + 1] = sp.s end
    end
    local lines = {}
    for l in (table.concat(out) .. NL):gmatch('([^' .. NL .. ']*)' .. NL) do
        l = l:gsub('^%s+', ''):gsub('%s+$', '')
        if l ~= '' then lines[#lines + 1] = l end
    end
    return table.concat(lines, NL)
end

-- the walkthrough page of an entry (cat|area|id -> its file in pages/index.lua): its header table, nil when it has none
-- pages/index.lua is read once (review CORE-8: it was read again for every stub entry of every area loaded, 139 reads and 80 ms
-- for Jeuno's quests); core/pages.lua hands over the copy it already holds, so it is in the heap once.
local page_index, handed = nil, nil
function meta.set_page_index(t) handed = type(t) == 'table' and t or nil page_index = handed end
local function page_meta(cat, area, id)
    if not page_index then page_index = handed or read('pages/index.lua') or {} end
    local file = page_index[cat .. '|' .. area .. '|' .. tostring(id)]
    local page = file and read(file)
    return page and type(page.meta) == 'table' and page.meta or nil
end

local function fill_from_page(e, cat, area)
    local okd, D = pcall(require, 'ui/doc')
    if not okd or type(D) ~= 'table' or not D.inline then return end
    local m = page_meta(cat, area, e.id)
    if not m then return end
    local function spans(label) return type(m[label]) == 'string' and D.inline(m[label]) or nil end
    local function value(label)
        local sp = spans(label)
        local t = sp and plain(sp)
        if t and t ~= '' and t:lower() ~= 'none' then return t end
    end
    local sp = spans('Starting NPC')
    if sp then
        for _, x in ipairs(sp) do
            if x.t == 'link' and x.kind == 'npc' and not e.start_npc then e.start_npc = x.s end
            if x.t == 'link' and x.kind == 'zone' and not e.start_zone then e.start_zone = x.s end
            if x.t == 'coord' and not e.start_pos then e.start_pos = x.s:match('%((.-)%)') end
        end
    end
    local fame = value('Required Fame')
    if fame and not e.fame then
        local f, lvl = fame:match('^(.-)%s*Fame Level:%s*(%d+)')
        e.fame = f or fame
        e.fame_level = e.fame_level or lvl
    end
    e.title = e.title or value('Title')
    e.repeatable = e.repeatable or value('Repeatable')
    e.description = e.description or value('Description')
    e.reward = e.reward or value('Rewards')
    for _, f in ipairs({{'Previous Quest', 'previous'}, {'Next Quest', 'next'}}) do
        local s2 = spans(f[1])
        if s2 and not e[f[2]] then
            local names = {}
            for _, x in ipairs(s2) do
                if x.t == 'link' then names[#names + 1] = x.name or x.s end
            end
            if #names > 0 then e[f[2]] = names end
        end
    end
end

-- Requirement rows the v1 scrape could not resolve: just the "[Key Item]" label (the key item's name was lost: sandoria 84), or
-- two items in one name, joined by a line break ("Cupboard" + "Mistletoe": sandoria 70). The card drew the first as a dash row
-- under a bare label and the second as one dash row, no icon. Where the entry has a walkthrough page, its own Requirements row
-- has them right (item icons with their ids), so those rows are rebuilt from it. Not when the page offers a choice ("or",
-- "-or-"): a list of rows reads as all of them, and the v1 row, however untidy, says "one of".
function meta.malformed_requirement(req)
    local n = type(req) == 'table' and req.name or ''
    return n:find(string.char(10), 1, true) ~= nil or n:match('^%[Key Item%]%s*$') ~= nil
end

-- Requirement rows ({name, count, id, ki}) of a page's Requirements spans, whether it offers a choice, and how many "or" rows were
-- put between the alternatives. A line that is only "or" ("-OR-", "**OR**") becomes a separator row {name = 'or', sep = true};
-- when there is one, every other row is a row of the choice (`choice = true`: the card leaves them out of its total, one of the
-- groups being enough). A quest named alone on a line is a row too ("Goblin Stew 880", the other way to meet the need).
function meta.requirement_rows(spans, opt)
    local lines, cur = {}, {}
    for _, sp in ipairs(spans) do
        if sp.t == 'br' then lines[#lines + 1] = cur cur = {} else cur[#cur + 1] = sp end
    end
    lines[#lines + 1] = cur
    local rows, last, choice, seps = {}, nil, false, 0
    for li, line in ipairs(lines) do
        local text, only = '', {}
        for _, sp in ipairs(line) do
            if (sp.t == 'text' or sp.t == 'link') and sp.s then text = text .. sp.s end
            if sp.t ~= 'text' or (sp.s and sp.s:find('%S')) then only[#only + 1] = sp end
        end
        last = nil
        if text:match('^%W*[Oo][Rr]%W*$') and #only == 1 and only[1].t == 'text' then
            choice = true
            if #rows > 0 and not rows[#rows].sep then
                rows[#rows + 1] = {name = 'or', count = 1, sep = true}
                seps = seps + 1
            end
        elseif #only == 1 and only[1].t == 'link' and only[1].kind == 'quest' then
            rows[#rows + 1] = {name = only[1].s, count = 1}
        else
            local pending
            for _, sp in ipairs(line) do
                if sp.t == 'icon' and sp.icon == 'item' and sp.id then
                    last = {name = sp.name, count = pending or 1, id = sp.id}
                    pending = nil
                    rows[#rows + 1] = last
                elseif sp.t == 'link' and sp.kind == 'item' then
                    if not (last and sp.id and last.id == sp.id) then   -- the icon just before it made this row already
                        last = {name = sp.s, count = pending or 1, id = sp.id}
                        pending = nil
                        rows[#rows + 1] = last
                    end
                elseif sp.t == 'link' and sp.kind == 'ki' then
                    last = {name = '[Key Item] ' .. sp.s, count = 1, ki = true}      -- the page gives the name, not the key item's id
                    rows[#rows + 1] = last
                elseif sp.t == 'text' and sp.s then
                    local n = sp.s:match('^%s*[xX]%s*(%d+)')                             -- "Lambent Scale x2"
                    if n and last then last.count = tonumber(n) end
                    local pn = sp.s:match('(%d+)%s*[xX]%s*$')                            -- "3x Silk Thread"
                    if pn then pending = tonumber(pn) end
                    if opt and opt.lead and not pn and not n then                                  -- rule 152: "1 Scream Fungus, 1 Land Crab Meat"
                        local b, ln = sp.s:match('^(.-)%f[%d](%d+)%s*$')
                        if ln and b:sub(-1) ~= ',' then pending = tonumber(ln) end
                    end
                    if (' ' .. sp.s:lower() .. ' '):find('%Wor%W') then choice = true end
                end
            end
            -- rule 152: an "or" that ends a line ("Eastern Pottery x4 OR") separates it from the next line, as an "or" line of its own does
            if opt and opt.inline_or and li < #lines and #rows > 0 and not rows[#rows].sep and text:find('%f[%a][Oo][Rr]%s*$') then
                rows[#rows + 1] = {name = 'or', count = 1, sep = true}
                seps = seps + 1
                choice = true
            end
        end
    end
    if seps > 0 then
        for _, r in ipairs(rows) do if not r.sep then r.choice = true end end
    end
    return rows, choice, seps
end

-- Rule 152 (vision wave, F5; quest other 4 16 18, outlands 130 201, toau 15): v1's requirement rows are fragments of the wiki's
-- one sentence. A row that ends with the sentence's connector ("Onion Dagger x5 or", "Istakoz,", "Istiridye, and") or lists several
-- names under one row ("[Key Item] A, B, and C", "1 Scream Fungus, 1 Land Crab Meat") reads untidily on the card: a dash row with
-- the connector in it, no icon, no owned count. Where the entry has a page, its rows are the page's own: one row per item or key
-- item, the "or" at the end of a line a separator row between the choices (rule 43), the connector dropped. Where the page has no item
-- icons (other 16: weapons linked as plain pages) the v1 rows keep their words and lose the connector. A list of names with an "or"
-- in it ("A, or B, or C") is not touched here (rule 138). meta.TIDY_FRAGMENTS = false is the card before 152.
local function connector_of(name)
    local low = ' ' .. name:lower()
    if low:find('[,;]%s*$') or low:find('%Wor%s*$') or low:find('%Wand%s*$') then return true end
    return low:match('^%W*and%W*$') ~= nil or low:match('^%W*or%W*$') ~= nil
end

local function name_list(name)
    local low = ' ' .. name:lower() .. ' '
    if not name:find(', ', 1, true) or low:find('%Wor%W') or low:find('and/or', 1, true) then return false end
    for seg in (name .. ', '):gmatch('(.-), ') do                     -- every piece opens like a name ("Multiple, see below" is not a list)
        seg = seg:gsub('^and%s+', '')
        if not seg:match('^[%u%d%[]') then return false end
    end
    return true
end

function meta.fragment_requirement(r)
    if type(r) ~= 'table' or r.id or r.sep or type(r.name) ~= 'string' then return false end
    return connector_of(r.name) or name_list(r.name)
end

-- Rule 162 (quest abyssea 183, "Beneath a Blood-red Sky"): v1's one row "Traverser stone, 10,000 Cruor" is a list of two needs, and the
-- page's rows (the key item) tell only the first: a cost in Cruor is no item, so the page's rows do not cover v1's. Each piece of the
-- list is a row of its own; a piece the page's rows name takes the page's row (the key item with its icon and owned mark), the others
-- stay text rows ("10,000 Cruor"). meta.SPLIT_LISTS = false is the card before 162.
local function squash(n) return (n:lower():gsub('%[key item%]', ''):gsub('[^%w]', '')) end

local function split_list(r, pagerows)
    local out = {}
    for seg in (r.name .. ', '):gmatch('(.-), ') do
        seg = seg:gsub('^and%s+', '')
        local row
        for _, p in ipairs(pagerows or {}) do
            if not p.sep and type(p.name) == 'string' and squash(p.name) == squash(seg) and squash(seg) ~= '' then row = p break end
        end
        if not row then
            row = {}
            for k, v in pairs(r) do row[k] = v end
            row.name, row.count = seg, 1
        end
        out[#out + 1] = row
    end
    return out
end

-- v1's rows with the connectors taken off: "Onion Dagger x5 or" is the row "Onion Dagger" (count 5), then an "or" row
local function tidy_rows(rows, pagerows)
    local out, seps = {}, 0
    for i, r in ipairs(rows) do
        if meta.SPLIT_LISTS ~= false and type(r) == 'table' and not r.sep and not r.id and type(r.name) == 'string'
            and not connector_of(r.name) and name_list(r.name) then
            for _, row in ipairs(split_list(r, pagerows)) do out[#out + 1] = row end
        elseif type(r) ~= 'table' or r.sep or r.id or type(r.name) ~= 'string' or not connector_of(r.name) then
            out[#out + 1] = r
        else
            local n, orflag = r.name, false
            for _ = 1, 3 do
                local m = n:gsub('%s*[,;]%s*$', '')
                if m:lower():find('%Wor%s*$') or m:lower():match('^or$') then m = m:gsub('%s*[Oo][Rr]%s*$', ''); orflag = true
                elseif m:lower():find('%Wand%s*$') or m:lower():match('^and$') then m = m:gsub('%s*[Aa][Nn][Dd]%s*$', '') end
                n = m
            end
            local base, c = n:match('^(.-)%s+[xX](%d+)$')
            local row = {}
            for k, v in pairs(r) do row[k] = v end
            if n ~= '' then
                row.name = base or n
                if c then row.count = tonumber(c) end
                out[#out + 1] = row
            end
            if orflag and out[#out] and not out[#out].sep and i < #rows then
                out[#out + 1] = {name = 'or', count = 1, sep = true}
                seps = seps + 1
            end
        end
    end
    if seps > 0 then for _, r in ipairs(out) do if not r.sep then r.choice = true end end end
    return out
end

-- every v1 row is told by the rows rebuilt from the page: its letters are the names of those rows plus connectors, a "[Key Item]" tag and counts
local function covered(old, new)
    for _, r in ipairs(old) do
        if type(r) ~= 'table' or type(r.name) ~= 'string' then return false end
        if not r.sep then
            local l = (r.name:lower():gsub('%[key item%]', ''):gsub('[^%w]', ''))
            for _, n in ipairs(new) do
                if not n.sep then
                    local nl = (n.name:lower():gsub('%[key item%]', ''):gsub('[^%w]', ''))
                    if nl ~= '' then
                        local a, b = l:find(nl, 1, true)
                        while a do l = l:sub(1, a - 1) .. l:sub(b + 1) a, b = l:find(nl, 1, true) end
                    end
                end
            end
            l = l:gsub('and', ''):gsub('or', '')
            if not (l:match('^%d*$') or l:match('^x%d+$') or l:match('^%d*x%d+$')) then return false end
        end
    end
    return true
end

local function tidy_fragments(e, cat, area)
    local frag = false
    for _, r in ipairs(e.requirements) do if meta.fragment_requirement(r) then frag = true end end
    if not frag then return end
    local okd, D = pcall(require, 'ui/doc')
    if not okd or type(D) ~= 'table' or not D.inline then return end
    local m = page_meta(cat, area, e.id)
    if not m or type(m.Requirements) ~= 'string' then return end
    local rows, choice, seps = meta.requirement_rows(D.inline(m.Requirements), {inline_or = true, lead = true})
    if #rows >= 2 and not (choice and seps == 0) and covered(e.requirements, rows) then
        e.requirements = rows
    else
        e.requirements = tidy_rows(e.requirements, rows)
    end
end

local function repair_core(e, cat, area)
    local bad = false
    for _, r in ipairs(e.requirements or {}) do if meta.malformed_requirement(r) then bad = true end end
    if not bad then
        if meta.TIDY_FRAGMENTS ~= false and e.id then tidy_fragments(e, cat, area) end
        return
    end
    local okd, D = pcall(require, 'ui/doc')
    if not okd or type(D) ~= 'table' or not D.inline then return end
    local m = page_meta(cat, area, e.id)
    if not m or type(m.Requirements) ~= 'string' then return end
    local rows, choice, seps = meta.requirement_rows(D.inline(m.Requirements))
    if #rows == 0 or (choice and seps == 0) then
        -- an "or" the rows cannot show: v1's row, untidy as it is, says "one of". Rule 138 (outlands 165, "Tremorstone and one of the
        -- following:" over "1x Meteorite or 1x Soil Gem or 12x Soil Geode", an "or" inside a line and an item that is needed whatever the
        -- choice): its line break is a space, one wrapped row, so no row of a page-backed entry has a line break in its name.
        -- meta.CHOICE_ONE_ROW = false is the card before 138.
        if meta.CHOICE_ONE_ROW ~= false then
            for _, r in ipairs(e.requirements or {}) do
                if type(r) == 'table' and type(r.name) == 'string' and r.name:find(string.char(10), 1, true) then
                    r.name = r.name:gsub('%s*' .. string.char(10) .. '%s*', ' ')
                end
            end
        end
        return
    end
    e.requirements = rows
end

-- Rule 165 (vision wave qab1, quest abyssea 74, "Scouts Astray"): v1 read the page's Requirements row, two lines "Pea Soup or Emerald Soup" and
-- "Flint Stone", as the one row "Pea Soup or Emerald Soup Flint Stone" (the line break lost, the row a run-on with a dash and no icon). A v1 row
-- with no id whose letters are those of two or more consecutive lines of the page's own Requirements row is one row per line: a line that is
-- one item takes the page's row (the item with its icon and owned count), another stays a text row of the line's words. The other 4 entries
-- whose v1 row holds several of the page's rows are not this shape (the "or" and the rows sit in one line of the page), and outlands 165's "Tremorstone and one of the following:" over its list stays rule 138's one row (a line ending in a colon introduces the next). meta.SPLIT_RUNONS = false
-- is the card before 165.
local function page_lines(m)
    local okd, D = pcall(require, 'ui/doc')
    if not okd or type(D) ~= 'table' or not D.inline or type(m.Requirements) ~= 'string' then return nil end
    local spans, lines, cur = D.inline(m.Requirements), {}, {}
    for _, sp in ipairs(spans) do
        if sp.t == 'br' then lines[#lines + 1] = cur cur = {} else cur[#cur + 1] = sp end
    end
    lines[#lines + 1] = cur
    local out = {}
    for _, line in ipairs(lines) do
        local text = {}
        for _, sp in ipairs(line) do if (sp.t == 'text' or sp.t == 'link') and sp.s then text[#text + 1] = sp.s end end
        local t = table.concat(text):gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', '')
        if t ~= '' then out[#out + 1] = {text = t, spans = line} end
    end
    return out
end

-- the page's lines that v1's row r is the run-on of: {line, ...} (two or more), or nil
function meta.run_on_lines(r, lines)
    if type(r) ~= 'table' or r.id or r.sep or type(r.name) ~= 'string' or not lines or #lines < 2 then return nil end
    local want = squash(r.name)
    if want == '' then return nil end
    for i = 1, #lines - 1 do
        local acc, got = '', {}
        for j = i, #lines do
            acc = acc .. squash(lines[j].text)
            got[#got + 1] = lines[j]
            if acc == want and #got >= 2 then
                for n = 1, #got - 1 do if got[n].text:find(':%s*$') then return nil end end      -- a line that ends in a colon introduces the next one: rule 138's one row (outlands 165)
                return got
            end
            if #acc >= #want or want:sub(1, #acc) ~= acc then break end
        end
    end
    return nil
end

-- the page's Requirements lines of an entry ({text, spans} each), nil when it has none (the test of rule 165)
function meta.page_requirement_lines(cat, area, id)
    local m = page_meta(cat, area, id)
    return m and page_lines(m) or nil
end

local function split_run_ons(e, cat, area)
    local any = false
    for _, r in ipairs(e.requirements) do
        if type(r) == 'table' and not r.id and not r.sep and type(r.name) == 'string' then any = true end
    end
    if not any then return end
    local m = page_meta(cat, area, e.id)
    if not m then return end
    local lines = page_lines(m)
    if not lines then return end
    local out, changed = {}, false
    for _, r in ipairs(e.requirements) do
        local got = meta.run_on_lines(r, lines)
        if not got then
            out[#out + 1] = r
        else
            changed = true
            for _, l in ipairs(got) do
                local rows = meta.requirement_rows(l.spans)
                local row
                if #rows == 1 and not rows[1].sep and rows[1].id and squash(rows[1].name) == squash(l.text) then
                    row = rows[1]
                else
                    row = {}
                    for k, v in pairs(r) do row[k] = v end
                    row.name, row.count = l.text, 1
                end
                out[#out + 1] = row
            end
        end
    end
    if changed then e.requirements = out end
end

local function repair_requirements(e, cat, area)
    repair_core(e, cat, area)
    if meta.SPLIT_RUNONS ~= false and e.id and type(e.requirements) == 'table' then split_run_ons(e, cat, area) end
end

-- The wiki wins where it and the card's v1 data disagree (2026-10-20: sandoria 5 printed REPEATABLE No on the card under a header
-- that said Yes; ten more said "Yes, after Memory reset"). An entry with a page takes the page's Repeatable; a fame level that v1
-- scraped with the nation in it ("Jeuno Level 3", jeuno 17) is its number. Done when the entry is first handed out: the page is
-- read for the entry being opened, never for every entry of an area.
local refined = setmetatable({}, {__mode = 'k'})      -- entries already refined (a flag in the entry itself would be data)

-- The starting NPC and zone: v1's scrape sometimes holds something else than the page's Starting NPC row says (windurst 91: the NPC
-- "Leepe-Hoppe, Windurst Waters South" and the zone "Home Point #3)"; windurst 40 the NPC "Kohlo-Lakolo Port Windurst"; windurst 28
-- the zone "Windurst Waters (L-6, Northern map)"). Where the page's row has one NPC and one zone, the entry says what the page does:
-- a value that is not that name is replaced (the position too, when the zone was). A row with several NPCs ("Joulet or Gallijaux")
-- is left as v1 has it.
local function letters_of(x) return (x:lower():gsub('[^%w]', '')) end

local function start_from_page(e, m, D)
    if type(m['Starting NPC']) ~= 'string' then return end
    local npcs, zones, coords, people = {}, {}, {}, {}
    for _, sp in ipairs(D.inline(m['Starting NPC'])) do
        if sp.t == 'link' and sp.kind == 'zone' then zones[#zones + 1] = sp.s
        elseif sp.t == 'link' then
            npcs[#npcs + 1] = sp.s
            if sp.kind == 'npc' then people[#people + 1] = sp.s end
        elseif sp.t == 'coord' then coords[#coords + 1] = sp.s:match('%((.-)%)') end
    end
    if #npcs == 1 and e.start_npc ~= nil and e.start_npc ~= npcs[1] then e.start_npc = npcs[1] end
    -- rule 129 (assault, vision wave m2): v1 has no start_npc for the Assault missions (the card read "NPC --"), and the page's row names the
    -- person. A row with one NPC link gives an entry that has none its NPC; the zone is settled below as it always was.
    -- meta.NPC_FROM_PAGE = false is the card before 129.
    if meta.NPC_FROM_PAGE ~= false and #npcs == 1 and #people == 1 and e.start_npc == nil then e.start_npc = people[1] end
    -- the zone: a zone v1 scraped as something else is replaced (with its position); one v1 has none of is the page's, since the
    -- card must not print "-- (G-5)", a grid square with no zone (windurst 40: v1 glued "Port Windurst" to the NPC's name)
    if #zones == 1 and e.start_zone ~= zones[1] then
        local had = e.start_zone ~= nil
        e.start_zone = zones[1]
        if #coords == 1 and coords[1] and (had or not e.start_pos) then e.start_pos = coords[1] end
    end
    -- a row that names a place and no one (a mission that starts on zoning in: "Aht Urhgan Whitegate - (K-11)"): v1 put the place in
    -- start_npc too, and the card read "NPC Aht Urhgan Whitegate, ZONE --" (toau 6, 18, 19, 20, 22, 28, 29, 35 to 40, 2026-10-21)
    if #npcs == 0 and #zones == 1 and type(e.start_npc) == 'string' and letters_of(e.start_npc) == letters_of(zones[1]) then e.start_npc = nil end
    -- a row that names several zones ("Cavernous Maw in Batallia Downs, Rolanberry Fields, or Sauromugue Champaign.", wotg 0): v1 kept the last
    -- two with the sentence's full stop and lost the first, a zone that is none of the row's. The card then names them all, as the row
    -- does. A card zone that is one of them (toau 13: "Caedarva Mire - (I-10) (Azouph Isle Staging Point)", the second a place beside the
    -- first) is left as it is.
    if #zones >= 2 then
        local have, one = letters_of(type(e.start_zone) == 'string' and e.start_zone or ''), false
        local joined = #zones == 2 and (zones[1] .. ' or ' .. zones[2]) or (table.concat(zones, ', ', 1, #zones - 1) .. ', or ' .. zones[#zones])
        for _, z in ipairs(zones) do if have == letters_of(z) then one = true end end
        if not one and have ~= letters_of(joined) then e.start_zone = joined end
    end
    -- Rule 155 (vision wave qad1, quest adoulin 115 and 116): the row "Roskin (Near Cafe des Larmes, Eastern Adoulin)" has the zone as plain text
    -- inside a bracket; v1 cut it at the comma, the NPC "Roskin (Near Cafe des Larmes" and the zone "Eastern Adoulin)". The card read ZONE
    -- "Eastern Adoulin)" (also adoulin 110, 111, 134). A zone with more closing brackets than opening ones loses the closing brackets at its end.
    -- meta.ZONE_BRACKET = false is the card before 155.
    if meta.ZONE_BRACKET ~= false and type(e.start_zone) == 'string' then
        local z = e.start_zone
        local function count(c) return select(2, z:gsub('%' .. c, '')) end
        while z:sub(-1) == ')' and count(')') > count('(') do z = z:sub(1, -2):gsub('%s+$', '') end
        e.start_zone = z
    end
    -- Rule 158 (vision wave qad2, quest adoulin 110, 111, 134): the other half of the same v1 cut. "Amchuchu (Inventors' Coalition, Western
    -- Adoulin)" became the NPC "Amchuchu (Inventors' Coalition" (the bracket the comma cut off), drawn with its bracket open. An NPC with more
    -- opening brackets than closing ones gets the closing brackets back. meta.NPC_BRACKET = false is the card before 158.
    if meta.NPC_BRACKET ~= false and type(e.start_npc) == 'string' then
        local n = e.start_npc
        local function count(c) return select(2, n:gsub('%' .. c, '')) end
        local open, close = count('('), count(')')
        if open > close then e.start_npc = n .. string.rep(')', open - close) end
    end
end

-- The card's title is the page's Title row where the two differ (the wiki wins, as for Repeatable): v1 kept a list of titles as its first
-- ("Doctor Shantotto's Flavor of the Month" of two) or as the words before it ("One of the following:"), so the page's header had to draw
-- its own Title beside the card's (windurst 63 and 66, 2026-10-20). The lines of the row, one title a line.
local function title_from_page(e, m, D)
    if type(m.Title) ~= 'string' then return end
    local t = plain(D.inline(m.Title))
    local low = t:lower()
    if t == '' or low == 'none' or low == 'unknown' or low == '--' then return end
    local function letters(x) return (x:lower():gsub('[^%w]', '')) end
    if type(e.title) ~= 'string' or letters(e.title) ~= letters(t) then e.title = t end
end

-- The card's reward is the page's Rewards row when v1 cut the row short (mission toau 46: v1 kept "Imperial Standard" and the words "One of the
-- following:" and lost the three rings under them; the header's Rewards, hidden because the card has a reward, never drew them, 2026-10-21).
-- Only a reward that is the very start of the page's (the letters) is replaced: the rest differ in wording (abbreviated names, a "[Key Item]"
-- tag) and say the same. One line each, as the page lists them.
-- The card's description is the page's Description row where the two differ in their letters (the wiki wins, as for the title): v1 cut a
-- sentence at a link's text ("How will Naja Salaheem", toau 19: the page goes on "react to your freelancing? And what are Aphmau and
-- friends planning...?"), lost the end of another (jeuno 164) and kept a typo of its own ("Rreceipt", sandoria 2). A description whose
-- letters are the page's is left as v1 wrote it (its spacing).
local function description_from_page(e, m, D)
    if type(m.Description) ~= 'string' or type(e.description) ~= 'string' then return end
    local t = plain(D.inline(m.Description)):gsub(NL, ' ')
    if letters_of(t) ~= '' and letters_of(t) ~= letters_of(e.description) then e.description = t end
end

-- Rule 191 (vision wave camp1, mission campaign 21, 361, 362, 363): the card's description of a Campaign Op is the page's Objective row where the two
-- begin alike and then differ. v1 cut the sentence at a link and kept the link's target as text ("Join the :Category:Campaign Battle", 21 and
-- 361 to 363; "via the Vunkerl Inlet (S)", 11; "Fort Karugo-Narugo (S)", 352 and 353) or kept a typo of its own ("vis Fort Karugo-Narugo", 351).
-- The wiki wins, as for the Description row above. Only a Campaign Op (a page has an Objective row and no Description row), and only where the
-- first DESC_OPENING letters of the two are the same: a v1 description that is another row of the page (the Mission Orders sentence, a line of
-- flavour text) has a different opening and is left alone. meta.OBJECTIVE_DESC = false is the card before 191.
meta.DESC_OPENING = 40
local function description_from_objective(e, m, D)
    if type(m.Objective) ~= 'string' or type(m.Description) == 'string' or type(e.description) ~= 'string' then return end
    local t = plain(D.inline(m.Objective)):gsub(NL, ' ')
    local want, have = letters_of(t), letters_of(e.description)
    local n = meta.DESC_OPENING
    if #want >= n and #have >= n and want ~= have and want:sub(1, n) == have:sub(1, n) then e.description = t end
end

-- The card's FAME is the page's Required Fame row where the two name another nation or another number (the wiki wins, as for the title; rule 139):
-- v1 had "Other 1" for outlands 143 and 144 and "Other" for 145 to 147 where the wiki says "Outlands Fame Level: 1" / "Unknown", and for toau 48
-- "Treasures of Aht Urhgan" where the row says "Accepted at IS 25372". "<Nation> Fame Level: <n>": the nation, and the level when the card has one and the row's is a
-- number; any other text that is no number, N/A, None or Unknown is the fame itself. A bare number or N/A is left to v1 (the row names no nation).
-- Only an entry that has a fame of its own. meta.FAME_FROM_PAGE = false is the card before 139.
local function fame_from_page(e, m, D)
    if type(m['Required Fame']) ~= 'string' or type(e.fame) ~= 'string' then return end
    local t = plain(D.inline(m['Required Fame'])):gsub(NL, ' ')
    local f, lvl = t:match('^(.-)%s*Fame Level:%s*(.-)%s*$')
    if f then
        if f ~= '' and letters_of(f) ~= letters_of(e.fame) then e.fame = f end
        if lvl:match('^%d+$') and e.fame_level ~= nil and tostring(e.fame_level) ~= lvl then e.fame_level = lvl end   -- a card with no level keeps none (jeuno 91, windurst 31: committed cards)
        return
    end
    local low = letters_of(t)
    if low == '' or low == 'none' or low == 'unknown' or low == 'na' or low:match('^%d+$') then return end
    if letters_of(e.fame) ~= low then e.fame, e.fame_level = t, nil end
end

local function reward_from_page(e, m, D)
    if type(m.Rewards) ~= 'string' then return end
    local t = plain(D.inline(m.Rewards))
    local function letters(x) return (x:lower():gsub('[^%w]', '')) end
    -- v1 has no reward at all and the page lists one (wotg 53, "Lest We Forget": the augmented Moonshade Earring): the card has it, a
    -- page that says None / N/A / Unknown has nothing to give
    if type(e.reward) ~= 'string' or not e.reward:find('%S') then
        local w = letters(t)
        if w ~= '' and w ~= 'none' and w ~= 'na' and w ~= 'unknown' then e.reward = t end
        return
    end
    local have, want = letters(e.reward), letters(t)
    if have ~= '' and #want > #have and want:sub(1, #have) == have then e.reward = t return end
    -- Rule 156 (vision wave qad1, quest adoulin 117, A Thirst Before Time): v1 kept "or 30,000 Bayld" and lost the Erudition Necklace before
    -- it, so the card's reward began with "or". A card reward that starts with a connector ("or", "and") is the page's lines when the page
    -- has the card's text after something of its own. meta.REWARD_LEAD = false is the card before 156.
    if meta.REWARD_LEAD ~= false and (e.reward:match('^%s*[Oo][Rr]%s') or e.reward:match('^%s*[Aa][Nn][Dd]%s')) then
        local i = want:find(have, 1, true)
        if have ~= '' and i and i > 1 then e.reward = t return end
    end
    -- v1 rewrote a long list as a few lines (adoulin 368, The Light Within: three lines for the page's seventeen, the cuffs, the garb and twelve
    -- rings drawn nowhere because the header's Rewards is hidden for the card): when the page lists at least LOSSY_MIN lines and at least half of
    -- them (their letters, a "[Key Item]" tag dropped) are not in the card's reward, the page's lines are the reward. A card that only words a
    -- few lines otherwise ("Drachen Fng. Gnt.", "Warp (Scroll)": at most a third of the page's lines on the 11 such pages) is left alone.
    -- meta.REWARD_LOSSY = false is the old reading (the prefix rule only), for the self-test of the check in test/test_data.lua.
    if meta.REWARD_LOSSY ~= false then
        local lines, lost = 0, 0
        for l in (t .. NL):gmatch('([^' .. NL .. ']*)' .. NL) do
            local w = letters((l:gsub('%b[]', '')))
            if w ~= '' and w ~= 'none' and w ~= 'na' then
                lines = lines + 1
                if not have:find(w, 1, true) then lost = lost + 1 end
            end
        end
        if lines >= meta.LOSSY_MIN and lost * 2 >= lines then e.reward = t end
    end
end

-- Rule 144 (vision wave qots1, quest other 7, 34 and toau 2): a Requirements row that says "One of the following sets of items:" /
-- "Any one of the following:" over a list of items. v1's rows are a plain list, so the card counted every one as needed: Orlando's
-- Antiques read "0 / 88" (eleven alternatives of eight), Monstrosity "0 / 3", Olduum "0 / 4" (the pickaxe and one of three key items). The
-- rows that stand after the cue line are a choice (`choice = true`: left out of the total, as for an "or"); a row the page names before
-- the cue (the Pickaxe) stays needed. A row is a row of the page's lines by the letters of its name ("[Key Item]" and a list mark
-- dropped). meta.CHOICE_FROM_PAGE = false is the card before 144.
local function choice_from_page(e, m, D)
    if type(m.Requirements) ~= 'string' or type(e.requirements) ~= 'table' then return end
    local lines, cur = {}, {}
    for _, sp in ipairs(D.inline(m.Requirements)) do
        if sp.t == 'br' then lines[#lines + 1] = cur cur = {} else cur[#cur + 1] = sp end
    end
    lines[#lines + 1] = cur
    local function text_of(line)
        local s = ''
        for _, sp in ipairs(line) do if sp.s and sp.t ~= 'tag' and sp.t ~= 'icon' then s = s .. sp.s .. ' ' end end
        return s
    end
    local cue
    for i, line in ipairs(lines) do
        local low = text_of(line):lower():gsub('[^%a%s]', ''):gsub('%s+', ' '):gsub('^ ', '')
        if low:find('^any one of the following') or low:find('^any of the following') or low:find('^one of the following') then cue = i break end
    end
    if not cue then return end
    local before, after = '', ''
    for i, line in ipairs(lines) do
        if i < cue then before = before .. text_of(line) elseif i > cue then after = after .. text_of(line) end
    end
    before, after = letters_of(before), letters_of(after)
    for _, r in ipairs(e.requirements) do
        if type(r) == 'table' and not r.sep and type(r.name) == 'string' then
            local w = letters_of((r.name:gsub('%[Key Item%]', ''):gsub('^%s*[:*#;]+%s*', '')))
            if w ~= '' and not before:find(w, 1, true) and after:find(w, 1, true) then r.choice = true end
        end
    end
end

local function refine(e, cat, area)
    if type(e) ~= 'table' or refined[e] then return end
    refined[e] = true
    if type(e.fame_level) == 'string' and e.fame_level:lower():find('level', 1, true) then
        local n = e.fame_level:match('^%D+(%d+)%s*$')
        if n then e.fame_level = n end
    end
    -- v1 read a wiki list of titles as "*Discerning Individual": the bullet is not part of the title
    if type(e.title) == 'string' then e.title = e.title:gsub('^%*%s*', '') end
    -- a key item's tag with the name straight after it ("[Key Item]Super soup pot")
    if type(e.requirements) == 'table' then
        for _, r in ipairs(e.requirements) do
            if type(r) == 'table' and type(r.name) == 'string' then
                r.name = r.name:gsub('(%[Key Item%])(%S)', '%1 %2')
                -- rule 142 (vision wave qot1, quest toau 23 and 4): v1 kept the wiki's list mark in a requirement row ("*[Key Item] Remnants Permit"),
                -- as it did in the reward (rule 80); the mark is not part of the name. meta.KEEP_REQ_MARKS = true is the old reading.
                if not meta.KEEP_REQ_MARKS then r.name = r.name:gsub('^%s*[:*#;]+%s*', '') end
            end
        end
    end
    if not e.id then return end
    local m = page_meta(cat, area, e.id)
    if not m then return end
    local okd, D = pcall(require, 'ui/doc')
    if not okd or type(D) ~= 'table' or not D.inline then return end
    if meta.START_FROM_PAGE ~= false then start_from_page(e, m, D) end   -- false: the data before the page's start row (rule 109's test shows the place check is live)
    if meta.FAME_FROM_PAGE ~= false then fame_from_page(e, m, D) end
    if meta.CHOICE_FROM_PAGE ~= false then choice_from_page(e, m, D) end
    title_from_page(e, m, D)
    reward_from_page(e, m, D)
    description_from_page(e, m, D)
    if meta.OBJECTIVE_DESC ~= false and cat == 'mission' and area == 'campaign' then description_from_objective(e, m, D) end
    if type(m.Repeatable) ~= 'string' then return end
    local t = plain(D.inline(m.Repeatable))
    if t ~= '' and t:lower() ~= 'none' then e.repeatable = t end
end

-- The metadata of one area: {data = name -> entry, norm = normalised -> entry}.
local function area_meta(cat, area)
    if not area or not cache[cat] then return nil end      -- a Records page (record|roe|id) has no v1 metadata
    local c = cache[cat][area]
    if not c then
        local t = read('meta/' .. cat .. 's/' .. area .. '.lua') or {}
        local norm = {}
        for k, v in pairs(t) do
            if meta.FOLD_ASCII ~= false then fold_entry(v) end
            if is_stub(v) then fill_from_page(v, cat, area) end
            if type(v) == 'table' and type(v.requirements) == 'table' then repair_requirements(v, cat, area) end
            norm[normalize(k)] = v
        end
        c = {data = t, norm = norm}
        cache[cat][area] = c
    end
    touch(cat, area)
    return c
end

function meta.get(cat, area, name, id)
    local c = area_meta(cat, area)
    if not c then return nil end
    if id then
        for _, e in pairs(c.data) do
            if e.id == id then refine(e, cat, area) return e end
        end
    end
    if not name then return nil end
    local e = c.data[name] or c.norm[normalize(name)]
    refine(e, cat, area)
    return e
end

-- Every area holding an entry of this name, sorted (from meta/index.lua).
function meta.areas_of(cat, name)
    if not index then index = read('meta/index.lua') or {quest = {}, mission = {}} end
    local r = index[cat] and index[cat][normalize(name)]
    return r
end

-- Drop everything (logout, unload, or a heap test).
function meta.release()
    cache = {quest = {}, mission = {}}
    order = {quest = {}, mission = {}}
    index = nil
    page_index = nil
end

function meta.resident()
    local n = 0
    for _, cat in pairs(cache) do
        for _ in pairs(cat) do n = n + 1 end
    end
    return n, index ~= nil
end

return meta
