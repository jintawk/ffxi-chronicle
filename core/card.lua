--[[
    Chronicle: what the guide screen's card shows for an entry (ui/screens/guide.lua draws it, and
    core/pages.lua tells the walkthrough page so its infobox header does not repeat it).

    card.fields(entry) -> {description, npc, zone, reward, fame, repeatable, title, requirements, previous, next}
    Each is the real value Chronicle's own data has (a string; for requirements the list), or nil when
    the entry lacks it or it is empty: the card draws '--' (or 'No' for repeatable) there, and that is
    not a value. 2026-10-19: the page header repeated almost all of the card.
]]

local card = {}

local function text(s)
    if type(s) == 'string' and s:find('%S') then return s end
end

function card.fields(entry)
    entry = entry or {}
    local f = {
        description = text(entry.description),
        npc = text(entry.start_npc),
        zone = text(entry.start_zone),
        reward = text(entry.reward),
        fame = text(entry.fame),
        repeatable = text(entry.repeatable),
        title = text(entry.title),
    }
    if type(entry.requirements) == 'table' and #entry.requirements > 0 then f.requirements = entry.requirements end
    -- the chain links under the card (entry names to open in Chronicle)
    if type(entry.previous) == 'table' and #entry.previous > 0 then f.previous = entry.previous end
    if type(entry.next) == 'table' and #entry.next > 0 then f.next = entry.next end
    return f
end

-- the card's ZONE as two pieces, the zone and its position "(K-6)" (nil when there is none): the screen keeps them together
function card.zone_parts(entry)
    local zone = text(entry.start_zone)
    if not zone then return '--', nil end        -- a grid square with no zone says nothing ("-- (G-5)"): the dash alone
    local tail = entry.start_pos and ('(' .. entry.start_pos .. ')') or nil
    return zone, tail
end

-- the card's ZONE text: the zone and its position; '--' for what is missing
function card.zone_text(entry)
    local zone, tail = card.zone_parts(entry)
    return tail and (zone .. ' ' .. tail) or zone
end

-- what the card prints for the fields whose wiki value is compared with it: REPEATABLE says 'No' where the entry has none (the
-- other fields say '--', which is never equal to a wiki value), TITLE its title (nil: '--'). A page header row with the very
-- same text repeats the card; one that differs is the wiki's word beside the card's (the wiki wins where they disagree, and a
-- title list the card cuts to its first title shows whole).
function card.printed(entry)
    entry = entry or {}
    local out = {repeatable = text(entry.repeatable) or 'No', title = text(entry.title), description = text(entry.description)}
    -- what a tab panel's infobox field must not repeat (ui/doc.lua D.panel_hidden): the card's Previous / Next (the names it
    -- lists, joined), its NPC and ZONE (with the position when it has one), its REWARD and FAME text. Each is the text the card draws.
    local function names(list)
        if type(list) ~= 'table' or #list == 0 then return nil end
        return table.concat(list, ' ')
    end
    out.previous, out.next = names(entry.previous), names(entry.next)
    local npc, zone = text(entry.start_npc), text(entry.start_zone)
    out.npc = npc      -- rule 176: the NPC the card's NPC row draws (a header row of the same text repeats it)
    if npc and zone then
        out.start = {npc .. ' ' .. zone}
        if text(entry.start_pos) then out.start[2] = npc .. ' ' .. zone .. ' (' .. entry.start_pos .. ')' end
    end
    local reward = card.reward_lines(text(entry.reward))
    out.reward = reward and table.concat(reward, ' ') or nil
    local fame = text(entry.fame)
    if fame then out.fame = {fame, entry.fame_level and (fame .. ' (Lvl ' .. entry.fame_level .. ')') or fame} end
    return out
end

-- The card's TITLE as the lines it is drawn in: a title list is one title a line (core/meta.lua takes the page's Title row). nil when none.
function card.title_lines(title)
    if type(title) ~= 'string' or not title:find('%S') then return nil end
    local out = {}
    for line in (title .. string.char(10)):gmatch('([^' .. string.char(10) .. ']*)' .. string.char(10)) do
        line = line:gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', '')
        if line ~= '' then out[#out + 1] = line end
    end
    return #out > 0 and out or nil
end

-- The card's REWARD as the lines it is drawn in: one per line of the entry's text (v1 kept each reward on a line of its own), a line
-- that is only "or" as the word, and the marks the wiki's layout left in a line tidied: no space before a full stop or a comma ("Windshear
-- Hat ."), a space after a "[Key Item]" tag ("[Key Item]Whisper of the Wyrmking"). nil when the entry has no reward. (2026-10-20: the card
-- joined the lines with "; " and drew "Rabbit Mantle ; OR; 10 gil", "single trade.; x1: 50 gil;".) card.KEEP_LIST_MARKS = true is the old
-- reading (the list marks kept), for the self-test of the check that no line starts with one.
function card.reward_lines(reward)
    if type(reward) ~= 'string' or not reward:find('%S') then return nil end
    local out = {}
    for line in (reward .. string.char(10)):gmatch('([^' .. string.char(10) .. ']*)' .. string.char(10)) do
        line = line:gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', '')
        -- the wiki's list marks v1 scraped into the text (":*Access to Adoulin", ":One of the following:", "*If already in possession"):
        -- a run of ":", "*", "#" and ";" at the start of the line is layout, not words (rule 80, adoulin 112, 320, 368)
        if not card.KEEP_LIST_MARKS then line = line:gsub('^[:*#;%s]+', '') end
        line = line:gsub('(%S) +([%.,;:])', '%1%2'):gsub("%]([%w\"'(])", '] %1'):gsub('[;]+$', '')
        if line:match('^%W*[Oo][Rr]%W*$') then line = 'or' end
        if line ~= '' then out[#out + 1] = line end
    end
    return #out > 0 and out or nil
end

-- the set of the card's fields that have a real value: {fame = true, npc = true, ...}, and `printed`, the text the
-- card draws for a field it has a default for (card.printed)
function card.shown(entry)
    local out = {}
    for k, v in pairs(card.fields(entry)) do if v then out[k] = true end end
    out.printed = card.printed(entry)
    return out
end

return card
