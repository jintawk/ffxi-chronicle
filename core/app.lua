--[[
    Chronicle: what is shown and how to get there. No drawing here.

    Views: home (tabs Missions / Quests), area (one storyline or quest region), guide (one entry),
    settings. A navigation keeps a stack of {view, params, scroll}; the breadcrumb is built from the
    current view as v1 builds it (Home > Area > Entry), and a right click goes back.

        local app = require('core/app').new(data, settings, save)
        app:go(view, params)   app:back()   app:home()   app:area_list(cat, area)
]]

local App = {}
App.__index = App

App.SORTS = {'Default', 'Name', 'Status', 'Location'}
App.FILTERS = {'All', 'Completed', 'Active', 'Uncompleted', 'Uncompletable'}

-- Records has no starting NPC to sort by and a reward worth sorting by, and its fifth state is
-- "the client would not offer this yet", not "you can never finish it", so it has its own two
-- lists and its own saved choice.
App.ROE_SORTS = {'Default', 'Name', 'Status', 'Reward'}
App.ROE_FILTERS = {'All', 'Completed', 'Active', 'Uncompleted', 'Locked'}

App.SUBTITLES = {
    sandoria = 'Kingdom of the Elvaan', bastok = 'Republic of Humes',
    windurst = 'Federation of Tarutaru & Mithra', jeuno = 'Grand Duchy of Jeuno',
    other = "Various Regions of Vana'diel", outlands = 'Distant Lands', toau = 'Empire of Aht Urhgan',
    wotg = 'Wings of the Goddess Era', abyssea = 'Abyssean Realms', adoulin = 'Sacred City of Adoulin',
    coalition = 'Coalition Assignments', zilart = 'Rise of the Zilart', cop = 'Chains of Promathia',
    acp = 'A Crystalline Prophecy', mkd = "A Moogle Kupo d'Etat", asa = 'A Shantotto Ascension',
    rov = "Rhapsodies of Vana'diel", tvr = 'The Voracious Resurgence',
    assault = 'Aht Urhgan Assault Operations', campaign = 'Campaign Operations',
}

App.STATUS_TEXT = {completed = 'COMPLETED', active = 'ACTIVE', ['repeat'] = 'REPEATABLE',
                   not_started = 'NOT STARTED', uncompletable = 'UNCOMPLETABLE'}

-- data: core/data; settings: the config table; save(): writes it
function App.new(data, settings, save)
    local self = setmetatable({}, App)
    self.data, self.settings, self.save = data, settings, save or function() end
    self.stack = {}
    self.view = {name = 'home', params = {}}
    self.search = ''                -- shared by every list, as in v1
    self.req_cache = {}
    return self
end

-- what the window should show: the screen module for the current view
function App:screen_name() return self.view.name end

function App:go(name, params, scroll_now)
    params = params or {}
    if name == 'guide' and not params.id then params.id = self.data.find_id(params.cat, params.area, params.name) end
    if name == 'guide' then params.name = self.data.canon_name(params.cat, params.area, params.id, params.name) end
    -- the controller's cursor goes on the stack with the scroll, so back lands on the card or row it left (ui/window.lua)
    self.stack[#self.stack + 1] = {name = self.view.name, params = self.view.params, scroll = scroll_now or 0,
                                   cursor = self.win and self.win.cursor_key or nil}
    self.view = {name = name, params = params or {}}
    if self.on_change then self.on_change(0) end
end

-- back one step; -> true if there was somewhere to go
function App:back()
    local prev = table.remove(self.stack)
    if not prev then return false end
    self.view = {name = prev.name, params = prev.params}
    if self.on_change then self.on_change(prev.scroll, prev.cursor) end
    return true
end

function App:home()
    self.stack = {}
    self.view = {name = 'home', params = {}}
    if self.on_change then self.on_change(0) end
end

-- an area's list, reached from a breadcrumb or a card: the stack is Home > Area
function App:area_list(cat, area, scroll)
    self.stack = {{name = 'home', params = {}, scroll = 0}}
    self.view = {name = 'area', params = {cat = cat, area = area}}
    if self.on_change then self.on_change(scroll or 0) end
end

-- an entry, from a chain link or a page link: the stack is flattened to Home > Area > Entry
function App:entry(cat, area, name, id)
    id = id or self.data.find_id(cat, area, name)
    name = self.data.canon_name(cat, area, id, name)
    self.stack = {{name = 'home', params = {}, scroll = 0}, {name = 'area', params = {cat = cat, area = area}, scroll = 0}}
    self.view = {name = 'guide', params = {cat = cat, area = area, name = name, id = id}}
    if self.on_change then self.on_change(0) end
end

---------------------------------------------------------------------------
-- Records of Eminence: a third tab, one level deeper than the other two
-- (Home > Category > Sub-category > Objective)
---------------------------------------------------------------------------

function App:roe_cat(ci, scroll)
    self.stack = {{name = 'home', params = {}, scroll = 0}}
    self.view = {name = 'rcat', params = {ci = ci}}
    if self.on_change then self.on_change(scroll or 0) end
end

function App:roe_sub(ci, si, scroll)
    self.stack = {{name = 'home', params = {}, scroll = 0},
                  {name = 'rcat', params = {ci = ci}, scroll = 0}}
    self.view = {name = 'rsub', params = {ci = ci, si = si}}
    if self.on_change then self.on_change(scroll or 0) end
end

-- An objective reached from anywhere (a card, the In progress list, a search): the stack is
-- flattened to the path the tree gives it.
-- Open a record by its id. `push` is a click inside Chronicle: the screen you came from stays on
-- the stack, so going back returns to it. Without it the stack is rebuilt as the record's own
-- path, which is what a jump in from outside wants.
function App:roe_objective(oid, scroll, push)
    if not self.roe then return false end
    -- `self.roe and self.roe.locate(oid)` would keep only the first of the two returns
    local ci, si = self.roe.locate(oid)
    if not ci then return false end
    if push then
        self:go('robj', {ci = ci, si = si, id = oid}, scroll)
        return true
    end
    self.stack = {{name = 'home', params = {}, scroll = 0},
                  {name = 'rcat', params = {ci = ci}, scroll = 0},
                  {name = 'rsub', params = {ci = ci, si = si}, scroll = 0}}
    self.view = {name = 'robj', params = {ci = ci, si = si, id = oid}}
    if self.on_change then self.on_change(scroll or 0) end
    return true
end

function App:roe_sort() return self.settings.roe_sort_mode or 1 end
function App:roe_filter()
    local f = self.settings.roe_filter_mode or 1
    if f > #App.ROE_FILTERS then f = 1 end
    return f
end

-- The objective list of one sub-category, through the same pipeline as a quest area's: filter,
-- search, sort. A locked objective is never hidden by the filter the way an uncompletable quest
-- is -- the client hides those and Chronicle's reason for existing is to show what is coming.
function App:roe_items(ci, si)
    local roe = self.roe
    local ix = roe and roe.index()
    local sub = ix and ix.cats[ci] and ix.cats[ci].subs[si]
    if not sub then return {}, nil end
    local data = roe.cat_data(ci) or {}
    local items = {}
    for _, oid in ipairs(sub.o) do
        local e = data[oid] or {}
        local status = roe.status(oid)
        local goal = ix.goal[oid] or 1
        items[#items + 1] = {
            id = oid, name = ix.name[oid] or ('Record ' .. oid), status = status,
            goal = goal, count = roe.progress(oid), repeatable = ix.rep[oid] == true,
            wrap = e.w, wrap_name = e.wn, desc = e.d,
            reward = (e.s or 0) + (e.x or 0) / 10 + (e.c or 0) / 10 + (e.a or 0),
        }
    end
    local function keep(fn)
        local out = {}
        for _, it in ipairs(items) do if fn(it) then out[#out + 1] = it end end
        items = out
    end
    local f = self:roe_filter()
    if f == 2 then keep(function(it) return it.status == 'completed' or it.status == 'repeat' end)
    elseif f == 3 then keep(function(it) return it.status == 'active' or it.status == 'repeat' end)
    elseif f == 4 then keep(function(it) return it.status == 'not_started' or it.status == 'active' end)
    elseif f == 5 then keep(function(it) return it.status == 'locked' end) end
    if self.search ~= '' then
        local needle = self.search:lower()
        keep(function(it)
            return it.name:lower():find(needle, 1, true) ~= nil
                or (it.desc and it.desc:lower():find(needle, 1, true) ~= nil)
        end)
    end
    local sort = self:roe_sort()
    if sort == 2 then
        table.sort(items, function(a, b) return a.name:lower() < b.name:lower() end)
    elseif sort == 3 then
        local pr = {active = 1, ['repeat'] = 2, not_started = 3, locked = 4, completed = 5}
        table.sort(items, function(a, b)
            local pa, pb = pr[a.status] or 9, pr[b.status] or 9
            if pa ~= pb then return pa < pb end
            return a.name:lower() < b.name:lower()
        end)
    elseif sort == 4 then
        table.sort(items, function(a, b)
            if a.reward ~= b.reward then return a.reward > b.reward end
            return a.name:lower() < b.name:lower()
        end)
    end
    return items, sub
end

-- The path to the current view: {{label, go = function}}, home first, this screen last. Nothing
-- draws it as a row of breadcrumbs any more (ui/screens/common.lua nav draws the tabs, and the
-- parent above the title), but the chain is still what says how deep a screen is and what is
-- above it.
function App:crumbs()
    local v, p = self.view, self.view.params
    local out = {{label = 'Home', go = function() self:home() end}}
    if v.name == 'settings' then
        out[#out + 1] = {label = 'Settings'}
        return out
    end
    if v.name == 'rcat' or v.name == 'rsub' or v.name == 'robj' then
        local ix = self.roe and self.roe.index()
        local c = ix and ix.cats[p.ci]
        out[#out + 1] = {label = c and c.n or '?', go = function() self:roe_cat(p.ci) end}
        if v.name ~= 'rcat' then
            local s = c and c.subs[p.si]
            local lead = {label = s and s.n or '?'}
            if v.name == 'robj' then lead.go = function() self:roe_sub(p.ci, p.si) end end
            out[#out + 1] = lead
        end
        if v.name == 'robj' then
            out[#out + 1] = {label = ix and ix.name[p.id] or '?'}
        end
        return out
    end
    if v.name == 'area' or v.name == 'guide' then
        out[#out + 1] = {label = self.data.get_area_name(p.area, p.cat),
                         go = function() self:area_list(p.cat, p.area) end}
    end
    if v.name == 'guide' then out[#out + 1] = {label = p.name or '?'} end
    return out
end

function App:show_uc() return self.settings.show_uncompletable == true end

-- totals with uncompletable entries left out unless shown (v1)
function App:adjusted(s)
    local total = self:show_uc() and s.total or s.total - (s.uncompletable or 0)
    return s.completed, total
end

-- v1's list pipeline (ui/views.lua render_item_list): NPC lines, hide uncompletable, filter,
-- search, sort. -> items, area status
function App:list_items(cat, area)
    local data = self.data
    local s = data.get_area_status(cat, area)
    local items = {}
    for i, it in ipairs(s.items) do
        local info = data.get_npc_info(area, it.name, cat)
        items[i] = {id = it.id, name = it.name, status = it.status, sub = data.format_npc_info(info),
                    start_zone = info and info.start_zone, start_pos = info and info.start_pos}
    end
    local function keep(fn)
        local out = {}
        for _, it in ipairs(items) do if fn(it) then out[#out + 1] = it end end
        items = out
    end
    local show_uc = self:show_uc()
    if not show_uc then keep(function(it) return it.status ~= 'uncompletable' end) end
    local f = self.settings.filter_mode or 1
    if f > (show_uc and 5 or 4) then f = 1 end
    if f == 2 then keep(function(it) return it.status == 'completed' or it.status == 'repeat' end)
    elseif f == 3 then keep(function(it) return it.status == 'active' end)
    elseif f == 4 then keep(function(it) return it.status ~= 'completed' and it.status ~= 'repeat' and it.status ~= 'uncompletable' end)
    elseif f == 5 then keep(function(it) return it.status == 'uncompletable' end) end
    if self.search ~= '' then
        local needle = self.search:lower()
        keep(function(it) return it.name:lower():find(needle, 1, true) ~= nil end)
    end
    local sort = self.settings.sort_mode or 1
    if sort == 2 then
        table.sort(items, function(a, b) return a.name:lower() < b.name:lower() end)
    elseif sort == 3 then
        local pr = {active = 1, not_started = 2, uncompletable = 3, completed = 4, ['repeat'] = 5}
        table.sort(items, function(a, b)
            local pa, pb = pr[a.status] or 9, pr[b.status] or 9
            if pa ~= pb then return pa < pb end
            return a.name:lower() < b.name:lower()
        end)
    elseif sort == 4 then
        table.sort(items, function(a, b)
            local az, bz = (a.start_zone or ''):lower(), (b.start_zone or ''):lower()
            if az ~= bz then return az < bz end
            local ap, bp = (a.start_pos or ''):lower(), (b.start_pos or ''):lower()
            if ap ~= bp then return ap < bp end
            return a.name:lower() < b.name:lower()
        end)
    end
    return items, s
end

-- an entry's step progress for a list (core/progress.lua summary), nil when it has no step mapping
function App:step_summary(cat, area, id)
    local p = self.progress
    if not (p and p.summary) then return nil end
    return p.summary(cat .. '|' .. tostring(area) .. '|' .. tostring(id))
end

-- Rule 104: Three Paths' three paths are entries of their own, active with it; its one row on Home already says the open path
local PATH_OF = {cop = {[540] = 530, [550] = 530, [560] = 530}}

-- Home: the entries in progress of one tab (summary = data.get_summary()[cat]), most recently advanced first, the rest in area
-- order; each with `steps` (step_summary, nil without a mapping) and `where`, the short series name when it has one (nil when
-- that would only repeat the entry's name)
function App:in_progress(cat, summary)
    local out, active = {}, {}
    for _, e in ipairs(summary.active or {}) do active[e.area .. '|' .. e.id] = true end
    for i, e in ipairs(summary.active or {}) do
        local parent = cat == 'mission' and PATH_OF[e.area] and PATH_OF[e.area][e.id]
        if not (parent and active[e.area .. '|' .. parent]) then
            local p = self.progress
            local code = p and p.code and p.code(cat .. '|' .. e.area .. '|' .. tostring(e.id))
            local steps = self:step_summary(cat, e.area, e.id)
            local where = code or e.area_name
            if where == e.name then where = nil end
            if steps and steps.label then where = where and where .. ', ' .. steps.label or steps.label end
            out[#out + 1] = {id = e.id, name = e.name, area = e.area, cat = cat, where = where, steps = steps, last = steps and steps.last or 0, pos = i}
        end
    end
    table.sort(out, function(x, y)
        if x.last ~= y.last then return x.last > y.last end
        return x.pos < y.pos
    end)
    return out
end

-- the entry for a guide, as v1: wiki metadata, or for a mission without any a stub from the map's
-- chain; plus the live status
function App:guide_entry(p)
    local data = self.data
    local status = p.status or 'not_started'
    if p.area then
        for _, it in ipairs(data.get_area_status(p.cat, p.area).items) do
            -- by id when the entry has one: entries of an area can share a name (rov "Eddies of Despair", 130 and 232), and the
            -- first of them would give its status to the second (rule 103; App.STATUS_BY_ID = false is the rule before)
            if (self.STATUS_BY_ID and p.id and it.id == p.id) or ((not (self.STATUS_BY_ID and p.id)) and it.name == p.name) then status = it.status break end
        end
    end
    local entry
    if p.cat == 'mission' then entry = data.get_mission_data(p.area, p.name, p.id)
    else entry = data.get_quest_data(p.area, p.name) end
    if not entry and p.cat == 'mission' then
        local chain = data.get_mission_chain(p.area, p.name)
        entry = {previous = chain and chain.previous, next = chain and chain.next}
    end
    return entry, status
end

-- A name met in a page's text ({p:Eddies of Despair|...}) that several entries of the area share: the open entry's own chain says which one
-- it means (rov 230's Next is "Eddies of Despair (2)", 128's is "Eddies of Despair"). -> the name to open, `name` itself when the chain
-- has no numbered form of it. App.LINK_BY_CHAIN = false is the rule before 103.
App.LINK_BY_CHAIN = true
App.STATUS_BY_ID = true
function App:link_name(cat, area, name)
    local v = self.view
    if not self.LINK_BY_CHAIN or v.name ~= 'guide' or v.params.cat ~= cat or v.params.area ~= area or not name then return name end
    local e = self:guide_entry(v.params)
    for _, list in ipairs({e and e.next or {}, e and e.previous or {}}) do
        for _, n in ipairs(list) do
            if n ~= name and n:match('^(.-)%s%(%d+%)$') == name then return n end
        end
    end
    return name
end

-- requirement results for an entry, cached until items or key items change
function App:requirements(key, entry, check)
    if not entry or not entry.requirements then return nil end
    local r = self.req_cache[key]
    if not r then
        r = check(entry.requirements)
        self.req_cache[key] = r
    end
    return r
end
function App:requirements_changed() self.req_cache = {} end

-- the entry a chain link names: its own kind first (the current area first), else the other kind (San d'Oria's "Apocalypse Nigh",
-- a quest, is followed by the mission "The Last Verse"). -> cat, area, or nil when Chronicle has no entry of that name
function App:chain_target(cat, area, name)
    local function find(c)
        return c == 'mission' and self.data.find_mission_area(name, area) or self.data.find_quest_area(name, area)
    end
    local a = find(cat)
    if a then return cat, a end
    local other = cat == 'mission' and 'quest' or 'mission'
    a = find(other)
    if a then return other, a end
end

-- a chain link: the entry holding that name, then open it
-- (false: Chronicle has no such entry)
function App:open_chain(cat, area, name)
    local c, a = self:chain_target(cat, area, name)
    if not a then return false end
    if self.view.name == 'guide' then
        self:go('guide', {cat = c, area = a, name = name}, self.win and self.win.scroll or 0)
    else
        self:entry(c, a, name)
    end
    return true
end

return App
