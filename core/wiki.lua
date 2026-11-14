--[[
    Chronicle requirement checks.

    Requirements arrive from core/meta.lua already resolved to item or key
    item ids (the metadata splitter), so this never loads the
    resources library: v1 built a name lookup over res.items here.
]]

local wiki = {}

-- Bags to check for required items: every bag the game has but the recycle bin (res/bags.lua; review CORE-15, Wardrobe 5-8
-- were missing, so an item kept there showed as owned 0)
local check_bags = {
    'inventory', 'satchel', 'sack', 'case',
    'wardrobe', 'wardrobe2', 'wardrobe3', 'wardrobe4', 'wardrobe5', 'wardrobe6', 'wardrobe7', 'wardrobe8',
    'safe', 'safe2', 'storage', 'locker', 'temporary',
}
wiki.bags = check_bags

-- Takes a list of {name, count, id, ki} and returns {name, count, owned, found}.
-- found is false when the name never resolved to an id. `sep` marks the "or" between alternatives and `choice` a row of them
-- (core/meta.lua requirement_rows): the card draws the first as a word and leaves the second out of its total.
function wiki.check_requirements(requirements)
    if not requirements or #requirements == 0 then return nil end

    local bag_counts = {}
    for _, bag_name in ipairs(check_bags) do
        local ok, bag = pcall(windower.ffxi.get_items, bag_name)
        if ok and type(bag) == 'table' then
            for _, slot in ipairs(bag) do
                if type(slot) == 'table' and slot.id and slot.id ~= 0 then
                    bag_counts[slot.id] = (bag_counts[slot.id] or 0) + (slot.count or 0)
                end
            end
        end
    end

    local kis = nil
    local results = {}
    for _, req in ipairs(requirements) do
        local owned, found = 0, req.id ~= nil
        if req.id and req.ki then
            if not kis then
                kis = {}
                local ok, list = pcall(windower.ffxi.get_key_items)
                if ok and type(list) == 'table' then
                    for _, id in ipairs(list) do kis[id] = true end
                end
            end
            owned = kis[req.id] and req.count or 0
        elseif req.id then
            owned = bag_counts[req.id] or 0
        end
        results[#results + 1] = {name = req.name, count = req.count, owned = owned, found = found, sep = req.sep, choice = req.choice}
    end
    return results
end

return wiki
