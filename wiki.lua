--[[
    Chronicle guide data layer
    Reads quest walkthrough/reward/requirements from static data files
    and builds display lines for the ScrollList widget
]]

local res = require('resources')
local data = require('data')

local wiki = {}

---------------------------------------------------------------------------
-- Config
---------------------------------------------------------------------------
local theme = require('ui/theme')
-- Wrap width scales with UI size (theme.wiki_wrap_width is recomputed when scale changes)
local function get_wrap_width()
    return theme.wiki_wrap_width
end

local function get_walk_wrap_width()
    return theme.walk_wrap_width
end

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------

-- Word-wrap a string to fit within max_width characters
local function word_wrap(text, max_width)
    max_width = max_width or get_wrap_width()
    local lines = {}
    for raw_line in (text .. '\n'):gmatch('([^\n]*)\n') do
        if #raw_line <= max_width then
            table.insert(lines, raw_line)
        else
            -- Preserve leading whitespace (indentation)
            local indent = raw_line:match('^(%s*)') or ''
            local remaining = raw_line:sub(#indent + 1)
            local current = indent

            for word in remaining:gmatch('%S+') do
                if #current + #word + 1 > max_width and current ~= indent then
                    table.insert(lines, current)
                    current = indent .. word
                else
                    if current == indent then
                        current = current .. word
                    else
                        current = current .. ' ' .. word
                    end
                end
            end
            if #current > #indent then
                table.insert(lines, current)
            end
        end
    end
    return lines
end

---------------------------------------------------------------------------
-- Inventory checking
---------------------------------------------------------------------------

-- Bags to check for required items
local check_bags = {
    'inventory', 'satchel', 'sack', 'case',
    'wardrobe', 'wardrobe2', 'wardrobe3', 'wardrobe4',
    'safe', 'safe2', 'storage', 'locker', 'temporary',
}

-- Lazy-initialized reverse lookup: lowercase name -> {resource, type}
local item_cache = nil

local function build_item_cache()
    item_cache = {}
    for _, item in pairs(res.items) do
        if type(item) == 'table' then
            if item.en then item_cache[item.en:lower()] = {res = item, type = 'item'} end
            if item.enl then item_cache[item.enl:lower()] = {res = item, type = 'item'} end
        end
    end
    for _, ki in pairs(res.key_items) do
        if type(ki) == 'table' then
            if ki.en then item_cache[ki.en:lower()] = {res = ki, type = 'key_item'} end
            if ki.enl then item_cache[ki.enl:lower()] = {res = ki, type = 'key_item'} end
        end
    end
end

local function find_item(name)
    if not item_cache then build_item_cache() end
    local clean = name:gsub('^%[Key Item%]%s*', '')
    local lower = clean:lower()
    local cached = item_cache[lower]
    if cached then return cached.res, cached.type end
    return nil, nil
end

-- Check if the player has the required items
-- Takes list of {name, count} and returns list of {name, count, owned, found}
-- found = true if item was resolved to an ID, false if unresolvable
function wiki.check_requirements(requirements)
    if not requirements or #requirements == 0 then return nil end

    local results = {}
    local key_items_set = nil  -- lazy-load

    -- Pre-fetch all bag contents once (avoids N*13 API calls)
    local bag_counts = {}  -- item_id -> total_count
    for _, bag_name in ipairs(check_bags) do
        local ok, bag = pcall(windower.ffxi.get_items, bag_name)
        if ok and bag then
            for _, slot in ipairs(bag) do
                if type(slot) == 'table' and slot.id then
                    bag_counts[slot.id] = (bag_counts[slot.id] or 0) + slot.count
                end
            end
        end
    end

    for _, req in ipairs(requirements) do
        local item_res, item_type = find_item(req.name)
        if item_res and item_type == 'item' then
            -- Regular item — lookup from pre-fetched bag counts
            local owned = bag_counts[item_res.id] or 0
            table.insert(results, {
                name = req.name,
                count = req.count,
                owned = owned,
                found = true,
            })
        elseif item_res and item_type == 'key_item' then
            -- Key item
            if not key_items_set then
                local ok, ki_list = pcall(windower.ffxi.get_key_items)
                if not ok or not ki_list then return results end
                key_items_set = {}
                for _, id in ipairs(ki_list) do
                    key_items_set[id] = true
                end
            end
            local has = key_items_set[item_res.id] and true or false
            table.insert(results, {
                name = req.name,
                count = req.count,
                owned = has and req.count or 0,
                found = true,
            })
        else
            -- Unresolvable item name
            table.insert(results, {
                name = req.name,
                count = req.count,
                owned = 0,
                found = false,
            })
        end
    end

    return results
end

---------------------------------------------------------------------------
-- Display line building
---------------------------------------------------------------------------

-- Insert a potentially long text as wrapped lines into a list
local function insert_wrapped(lines, text, status)
    local wrapped = word_wrap(text, get_wrap_width())
    for _, line in ipairs(wrapped) do
        table.insert(lines, {name = line, status = status})
    end
end

---------------------------------------------------------------------------
-- Walkthrough + notes line builder (for guide view ScrollList)
---------------------------------------------------------------------------

-- Build just the walkthrough and notes sections as display lines
-- Returns a list of {name, status} items for a read-only ScrollList
function wiki.build_walkthrough_lines(entry)
    local lines = {}

    -- Walkthrough body (header rendered separately by view)
    if entry.walkthrough and #entry.walkthrough > 0 then
        local wrapped = word_wrap(entry.walkthrough, get_walk_wrap_width())
        for _, line in ipairs(wrapped) do
            table.insert(lines, {name = line, status = nil})
        end
    else
        table.insert(lines, {name = 'No walkthrough available.', status = nil})
    end

    -- Notes body (header rendered separately by view)
    if entry.notes and #entry.notes > 0 then
        table.insert(lines, {name = '', status = nil})
        table.insert(lines, {name = 'NOTES', status = 'req_header'})
        local wrapped = word_wrap(entry.notes, get_walk_wrap_width())
        for _, line in ipairs(wrapped) do
            table.insert(lines, {name = line, status = nil})
        end
    end

    return lines
end

-- Expose word_wrap for use by other modules
wiki.word_wrap = word_wrap

return wiki
