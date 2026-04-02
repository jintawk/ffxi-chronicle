--[[
    Chronicle UI views
    View state machine: top-level (quest categories), item-list, guide
    Each view builds widgets into the panel, reads data from data.lua
]]

local widgets = require('ui/widgets')
local theme = require('ui/theme')
local data = require('data')
local wiki = require('wiki')

local views = {}

-- Emblem asset lookup: area key -> filename (relative to assets/)
-- Files that don't exist are silently skipped
local emblem_extensions = {'png', 'jpg'}
local function find_emblem(area_key)
    for _, ext in ipairs(emblem_extensions) do
        local path = windower.addon_path .. 'assets/' .. area_key .. '.' .. ext
        if windower.file_exists(path) then
            return path
        end
    end
    return nil
end

---------------------------------------------------------------------------
-- View state
---------------------------------------------------------------------------
local state = {
    panel = nil,
    view_stack = {},     -- stack of {view_type, params} for back navigation
    current_view = nil,  -- {view_type, params}
    on_close = nil,      -- callback when close button clicked
    settings = nil,      -- reference to addon settings (for sort/filter persistence)
}

-- Sort/filter option tables
local sort_options = {'Default', 'Name', 'Status', 'Location'}
local filter_options = {'All', 'Completed', 'Active', 'Uncompleted'}

-- Percentage helper
local function pct(n, d)
    if d == 0 then return 0 end
    return math.floor((n / d) * 100)
end

-- Star icon path for 100% completion
local complete_icon_path = windower.addon_path .. 'assets/trophy.png'

-- Area flavor subtitles for item_list header
local area_subtitles = {
    sandoria  = 'Kingdom of the Elvaan',
    bastok    = 'Republic of Humes',
    windurst  = 'Federation of Tarutaru & Mithra',
    jeuno     = 'Grand Duchy of Jeuno',
    other     = 'Various Regions of Vana\'diel',
    outlands  = 'Distant Lands',
    toau      = 'Empire of Aht Urhgan',
    wotg      = 'Wings of the Goddess Era',
    abyssea   = 'Abyssean Realms',
    adoulin   = 'Sacred City of Adoulin',
    coalition = 'Coalition Assignments',
    zilart    = 'Rise of the Zilart',
    cop       = 'Chains of Promathia',
    acp       = 'A Crystalline Prophecy',
    mkd       = 'A Moogle Kupo d\'Etat',
    asa       = 'A Shantotto Ascension',
    rov       = 'Rhapsodies of Vana\'diel',
    tvr       = 'The Voracious Resurgence',
    assault   = 'Aht Urhgan Assault Operations',
    campaign  = 'Campaign Operations',
}

-- Tab definitions for home view
local tab_names = {'Missions', 'Quests'}
local tab_cats = {mission = 1, quest = 2}

---------------------------------------------------------------------------
-- Navigation
---------------------------------------------------------------------------
local render_current  -- forward declaration; implemented below

local function navigate_to(view_type, params)
    -- Push current view onto stack before navigating (if it exists)
    if state.current_view then
        table.insert(state.view_stack, state.current_view)
    end
    state.current_view = {view_type = view_type, params = params or {}}
    render_current()
end

local function navigate_back()
    if #state.view_stack > 0 then
        state.current_view = table.remove(state.view_stack)
        -- Clear cached requirement results so they rebuild with fresh inventory data
        if state.current_view.view_type == 'guide' then
            state.current_view.params.req_results = nil
            state.current_view.params.walk_lines = nil
        end
        render_current()
    end
end

local function navigate_to_root()
    state.view_stack = {}
    state.current_view = {view_type = 'top_level', params = {}}
    render_current()
end

-- Navigate to a quest guide keeping breadcrumbs flat: Home >> Region >> Quest
local function navigate_to_quest(quest_name, cat, target_area)
    state.view_stack = {
        {view_type = 'item_list', params = {cat = cat, area = target_area}},
    }
    state.current_view = {view_type = 'guide', params = {
        name = quest_name, cat = cat, area = target_area,
    }}
    render_current()
end

---------------------------------------------------------------------------
-- Breadcrumb builder
---------------------------------------------------------------------------
local function build_breadcrumb(panel, cx, cy)
    local crumbs = {}

    -- Always start with Home (top-level overview)
    table.insert(crumbs, {
        text = 'Home ',
        on_click = function() navigate_to_root() end,
    })

    -- Build crumbs from view stack + current view
    -- Collect all views in order (stack + current)
    local all_views = {}
    for _, entry in ipairs(state.view_stack) do
        table.insert(all_views, entry)
    end
    table.insert(all_views, state.current_view)

    for vi, entry in ipairs(all_views) do
        local is_last = (vi == #all_views)

        if entry.view_type == 'item_list' then
            local cat = entry.params.cat
            local area = entry.params.area
            local area_name = data.get_area_name(area)

            if is_last then
                table.insert(crumbs, {text = area_name})
            else
                table.insert(crumbs, {
                    text = area_name,
                    on_click = function()
                        state.view_stack = {}
                        state.current_view = {view_type = 'item_list', params = {cat = cat, area = area}}
                        render_current()
                    end,
                })
            end
        elseif entry.view_type == 'guide' then
            table.insert(crumbs, {text = entry.params.name or '?'})
        end
    end

    -- Only show breadcrumb if we're deeper than top level
    if not state.current_view or state.current_view.view_type == 'top_level' then
        return cy
    end

    -- Smart truncation: only shorten the quest name if breadcrumbs exceed window width
    local sep_w = 4  -- icon separator width in char-equivalents
    local max_chars = math.floor(theme.window_width / theme.breadcrumb_char_width)
    local total_chars = 0
    for ci, crumb in ipairs(crumbs) do
        total_chars = total_chars + #crumb.text
        if ci < #crumbs then total_chars = total_chars + sep_w end
    end
    if total_chars > max_chars and #crumbs > 0 then
        local last = crumbs[#crumbs]
        local overflow = total_chars - max_chars
        local max_name = math.max(10, #last.text - overflow - 2)
        if max_name < #last.text then
            last.text = last.text:sub(1, max_name) .. '..'
        end
    end

    local breadcrumb = widgets.Breadcrumb({x = 0, y = 0})
    panel:add_child(breadcrumb, cx, cy)
    breadcrumb:set_path(crumbs)

    return cy + theme.breadcrumb_height + theme.s(2)
end

---------------------------------------------------------------------------
-- View: Top Level
-- Grand Chronicle: header with title/stats, 2-column card grid, footer
---------------------------------------------------------------------------
local function render_top_level(panel, cx, cy, cw)
    local s = data.get_summary()

    -- Determine active tab from settings (default: mission)
    local active_tab = (state.settings and state.settings.active_tab) or 'mission'
    local active_tab_idx = tab_cats[active_tab] or 1

    -- === TAB BAR ===
    local tab_bar = widgets.TabBar({
        x = 0, y = 0,
        tabs = tab_names,
        active = active_tab_idx,
        on_change = function(idx)
            local new_tab = idx == 1 and 'mission' or 'quest'
            if state.settings then
                state.settings.active_tab = new_tab
            end
            render_current()
        end,
    })
    panel:add_child(tab_bar, cx, cy)
    cy = cy + theme.tab_height + theme.tab_padding_bottom

    if not s.loaded then
        local header = widgets.Label({
            x = 0, y = 0,
            text = 'Waiting for data...',
            font = theme.font_name,
            size = theme.loading_size,
            color = theme.accent,
        })
        panel:add_child(header, cx, cy)
        cy = cy + theme.s(20)

        local hint = widgets.Label({
            x = 0, y = 0,
            text = 'Zone or complete an objective to populate.',
            font = theme.font_name,
            size = theme.header_sub_size,
            color = theme.text_dim,
            bold = false,
        })
        panel:add_child(hint, cx, cy)
        cy = cy + theme.s(14)

        local total_h = cy - theme.title_height + theme.padding
        panel:content_height(total_h)
        return
    end

    -- Get data for the active tab
    local tab_data = s[active_tab] or s.quest
    local cat_label = active_tab == 'mission' and 'MISSIONS' or 'QUESTS'

    -- === HEADER ===

    -- Subtitle (below tab bar)
    local subtitle = widgets.Label({
        x = 0, y = 0,
        text = 'Overall Completion',
        font = theme.font_name,
        size = theme.header_sub_size,
        color = theme.text_dim,
        bold = false,
    })
    panel:add_child(subtitle, cx, cy)

    -- Percentage (right side, large)
    local pct_val = pct(tab_data.completed, tab_data.total)
    local pct_fmt = string.format('%d%%', pct_val)
    local pct_width = #pct_fmt * theme.header_pct_char_width
    local pct_color = pct_val >= 100 and theme.accent_gold
        or pct_val >= 75 and theme.accent_green
        or pct_val >= 25 and theme.accent
        or theme.accent_red
    local pct_label = widgets.Label({
        x = 0, y = 0,
        text = pct_fmt,
        font = theme.font_label,
        size = theme.header_pct_size,
        color = pct_color,
    })
    local pct_x = cx + cw - pct_width
    panel:add_child(pct_label, pct_x, cy - theme.s(4))

    -- Gold star icon for 100% completion
    if pct_val >= 100 and windower.file_exists(complete_icon_path) then
        local star_size = theme.s(18)
        local star = widgets.Image({
            x = 0, y = 0,
            width = star_size, height = star_size,
            path = complete_icon_path,
        })
        panel:add_child(star, pct_x - star_size - theme.s(2), cy)
    end

    cy = cy + theme.s(16)

    -- Count line (right side)
    local count_str = string.format('%d / %d', tab_data.completed, tab_data.total)
    local count_width = #count_str * theme.header_count_char_width
    local count_label = widgets.Label({
        x = 0, y = 0,
        text = count_str,
        font = theme.font_label,
        size = theme.header_count_size,
        color = theme.text_dim,
        bold = false,
    })
    panel:add_child(count_label, cx + cw - count_width, cy)

    cy = cy + theme.s(14)

    -- Overall progress bar (thin, full width)
    local header_bar = widgets.Bar({
        x = 0, y = 0,
        width = cw,
        height = theme.header_bar_height,
        fill_color = theme.bar_total.fill,
    })
    panel:add_child(header_bar, cx, cy)
    header_bar:update(tab_data.completed, tab_data.total, '')

    cy = cy + theme.header_bar_height + theme.s(14)

    -- === CARD GRID (2 columns) ===

    local col_width = math.floor((cw - theme.card_gap) / 2)

    for i, area_info in ipairs(tab_data.areas) do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        local card_x = cx + col * (col_width + theme.card_gap)
        local card_y = cy + row * (theme.card_height + theme.card_gap)

        local area_pct = pct(area_info.completed, area_info.total)
        local fill_color = theme.bar.fill_default
        local pct_color = theme.accent
        if area_info.total > 0 then
            if area_pct >= 100 then
                fill_color = theme.bar.fill_complete
                pct_color = theme.accent_gold
            elseif area_pct >= 75 then
                fill_color = theme.bar.fill_high
                pct_color = theme.accent_green
            elseif area_pct >= 25 then
                fill_color = theme.bar.fill_mid
            else
                fill_color = theme.bar.fill_low
                pct_color = theme.accent_red
            end
        end

        local sub_text = string.format('%d / %d', area_info.completed, area_info.total)
        if not area_info.has_data then
            sub_text = sub_text .. ' [NO DATA]'
        end

        local area_key = area_info.area
        local card = widgets.Card({
            x = 0, y = 0,
            width = col_width,
            height = theme.card_height,
            name = area_info.name,
            sub_text = sub_text,
            pct_text = string.format('%d%%', area_pct),
            complete_star = area_pct >= 100 and complete_icon_path or nil,
            pct_color = pct_color,
            completed = area_info.completed,
            total = area_info.total,
            fill_color = fill_color,
            emblem = find_emblem(area_key),
            on_click = function()
                navigate_to('item_list', {cat = active_tab, area = area_key})
            end,
        })
        panel:add_child(card, card_x, card_y)
    end

    -- Calculate grid bottom
    local num_rows = math.ceil(#tab_data.areas / 2)
    local grid_bottom = cy + num_rows * (theme.card_height + theme.card_gap) - theme.card_gap
    cy = grid_bottom + theme.s(10)

    -- === FOOTER ===

    -- Timestamp footer
    local footer_left = widgets.Label({
        x = 0, y = 0,
        text = 'LAST UPDATED: ' .. os.date('%H:%M'),
        font = theme.font_label,
        size = theme.footer_size,
        color = theme.text_dim,
        bold = false,
    })
    panel:add_child(footer_left, cx, cy)

    cy = cy + theme.s(16)

    -- Set content height
    local total_h = cy - theme.title_height
    panel:content_height(total_h)
end

---------------------------------------------------------------------------
-- View: Item List
-- Redesigned: editorial header + QuestRowList with NPC sub-text
---------------------------------------------------------------------------
local function render_item_list(panel, cx, cy, cw, params)
    local cat = params.cat
    local area = params.area
    local area_name = data.get_area_name(area)
    local s = data.get_area_status(cat, area)

    if not data.is_loaded() then
        local header = widgets.Label({
            x = 0, y = 0,
            text = 'Waiting for data...',
            font = theme.font_name,
            size = theme.loading_size,
            color = theme.accent,
        })
        panel:add_child(header, cx, cy)
        cy = cy + theme.s(20)

        local hint = widgets.Label({
            x = 0, y = 0,
            text = 'Zone or complete an objective to populate.',
            font = theme.font_name,
            size = theme.header_sub_size,
            color = theme.text_dim,
            bold = false,
        })
        panel:add_child(hint, cx, cy)
        cy = cy + theme.s(14)

        panel:content_height(cy - theme.title_height + theme.padding)
        return
    end

    -- === HEADER ===

    -- Area name (large headline, left side)
    local area_title = widgets.Label({
        x = 0, y = 0,
        text = area_name,
        font = theme.font_headline,
        size = theme.header_title_size,
        color = theme.text_bright,
    })
    panel:add_child(area_title, cx, cy)

    -- Percentage (right side, large — matches root-level layout)
    local pct_val = pct(s.completed, s.total)
    local pct_fmt = string.format('%d%%', pct_val)
    local pct_width = #pct_fmt * theme.header_pct_char_width
    local pct_color = pct_val >= 100 and theme.accent_gold
        or pct_val >= 75 and theme.accent_green
        or pct_val >= 25 and theme.accent
        or theme.accent_red
    local pct_label = widgets.Label({
        x = 0, y = 0,
        text = pct_fmt,
        font = theme.font_label,
        size = theme.header_pct_size,
        color = pct_color,
    })
    local pct_x = cx + cw - pct_width
    panel:add_child(pct_label, pct_x, cy - theme.s(4))

    -- Gold star icon for 100% completion
    if pct_val >= 100 and windower.file_exists(complete_icon_path) then
        local star_size = theme.s(18)
        local star = widgets.Image({
            x = 0, y = 0,
            width = star_size, height = star_size,
            path = complete_icon_path,
        })
        panel:add_child(star, pct_x - star_size - theme.s(2), cy)
    end

    cy = cy + theme.s(20)

    -- Subtitle (area flavor text, left) + count (right, small)
    local subtitle_text = area_subtitles[area] or ''
    if #subtitle_text > 0 then
        local subtitle = widgets.Label({
            x = 0, y = 0,
            text = subtitle_text,
            font = theme.font_name,
            size = theme.header_sub_size,
            color = theme.text_dim,
            bold = false,
        })
        panel:add_child(subtitle, cx, cy)
    end

    local count_str = string.format('%d / %d', s.completed, s.total)
    local count_width = #count_str * theme.header_count_char_width
    local count_label = widgets.Label({
        x = 0, y = 0,
        text = count_str,
        font = theme.font_label,
        size = theme.header_count_size,
        color = theme.text_dim,
        bold = false,
    })
    panel:add_child(count_label, cx + cw - count_width, cy)

    cy = cy + theme.s(20)

    -- Progress bar (amber fill, matching design)
    local fill_color = theme.bar.fill_low  -- amber default
    if s.total > 0 then
        local p = pct(s.completed, s.total)
        if p >= 100 then
            fill_color = theme.bar.fill_complete
        elseif p >= 75 then
            fill_color = theme.bar.fill_high
        end
    end

    local progress_bar = widgets.Bar({
        x = 0, y = 0,
        width = cw,
        height = theme.header_bar_height,
        fill_color = fill_color,
    })
    panel:add_child(progress_bar, cx, cy)
    progress_bar:update(s.completed, s.total, '')

    cy = cy + theme.header_bar_height + theme.toolbar_y_gap

    -- === TOOLBAR (search, sort, filter) ===

    -- Preserve toolbar state across re-renders via view params
    local search_text = params.search_text or ''
    local sort_idx = params.sort_idx or (state.settings and state.settings.sort_mode or 1)
    local filter_idx = params.filter_idx or (state.settings and state.settings.filter_mode or 1)

    -- Search input (left side)
    local search_focused = params.search_focused or false
    local search_input = widgets.TextInput({
        width = theme.toolbar_input_width,
        height = theme.toolbar_height,
        placeholder = 'Search...',
        on_change = function(text)
            params.search_text = text
            params.search_focused = true
            render_current()
        end,
        on_blur = function()
            params.search_focused = false
        end,
    })
    panel:add_child(search_input, cx, cy)
    -- Restore previous search text and focus state if re-rendering
    if #search_text > 0 then
        search_input._value = search_text
        search_input:_update_display()
    end
    if search_focused then
        search_input:focus()
    end

    -- Filter button (right side)
    local filter_btn = widgets.ToolbarButton({
        label = 'Show',
        options = filter_options,
        index = filter_idx,
        on_change = function(idx, val)
            params.filter_idx = idx
            if state.settings then
                state.settings.filter_mode = idx
                state.settings:save()
            end
            render_current()
        end,
    })
    -- Estimated char width at toolbar_button_size for positioning
    -- "Show: Uncompleted" = 18 chars (longest filter), "Sort: Location" = 15 chars (longest sort)
    local char_w = theme.toolbar_button_size * 0.75
    local filter_w = math.floor(19 * char_w + 8)
    local sort_w = math.floor(16 * char_w + 8)
    panel:add_child(filter_btn, cx + cw - filter_w, cy)

    -- Sort button (left of filter)
    local sort_btn = widgets.ToolbarButton({
        label = 'Sort',
        options = sort_options,
        index = sort_idx,
        on_change = function(idx, val)
            params.sort_idx = idx
            if state.settings then
                state.settings.sort_mode = idx
                state.settings:save()
            end
            render_current()
        end,
    })
    panel:add_child(sort_btn, cx + cw - filter_w - theme.toolbar_gap - sort_w, cy)

    cy = cy + theme.toolbar_height + theme.toolbar_y_gap

    -- === QUEST LIST ===

    local items = s.items
    if #items == 0 and not (search_text and #search_text > 0) and filter_idx == 1 then
        local msg = widgets.Label({
            x = 0, y = 0,
            text = s.has_data and 'No entries for this area' or 'No data -- zone to load',
            color = theme.text_dim,
        })
        panel:add_child(msg, cx, cy)
        panel:content_height(cy - theme.title_height + theme.line_height + theme.padding)
        return
    end

    -- Enrich items with NPC info from static data
    for _, item in ipairs(items) do
        local info = data.get_npc_info(area, item.name, cat)
        item.npc_info = data.format_npc_info(info)
        if info then
            item.start_zone = info.start_zone
            item.start_pos = info.start_pos
        end
    end

    -- Apply filter
    if filter_idx == 2 then -- Completed (includes repeat)
        local filtered = {}
        for _, item in ipairs(items) do
            if item.status == 'completed' or item.status == 'repeat' then
                filtered[#filtered + 1] = item
            end
        end
        items = filtered
    elseif filter_idx == 3 then -- Active
        local filtered = {}
        for _, item in ipairs(items) do
            if item.status == 'active' then
                filtered[#filtered + 1] = item
            end
        end
        items = filtered
    elseif filter_idx == 4 then -- Uncompleted (active + not_started)
        local filtered = {}
        for _, item in ipairs(items) do
            if item.status ~= 'completed' and item.status ~= 'repeat' then
                filtered[#filtered + 1] = item
            end
        end
        items = filtered
    end

    -- Apply search
    if search_text and #search_text > 0 then
        local needle = search_text:lower()
        local filtered = {}
        for _, item in ipairs(items) do
            if item.name:lower():find(needle, 1, true) then
                filtered[#filtered + 1] = item
            end
        end
        items = filtered
    end

    -- Apply sort
    if sort_idx == 2 then -- Name
        table.sort(items, function(a, b) return a.name:lower() < b.name:lower() end)
    elseif sort_idx == 3 then -- Status
        local priority = {active = 1, not_started = 2, completed = 3, ['repeat'] = 4}
        table.sort(items, function(a, b)
            local pa, pb = priority[a.status] or 9, priority[b.status] or 9
            if pa ~= pb then return pa < pb end
            return a.name:lower() < b.name:lower()
        end)
    elseif sort_idx == 4 then -- Location
        table.sort(items, function(a, b)
            local az = (a.start_zone or ''):lower()
            local bz = (b.start_zone or ''):lower()
            if az ~= bz then return az < bz end
            local ap = (a.start_pos or ''):lower()
            local bp = (b.start_pos or ''):lower()
            if ap ~= bp then return ap < bp end
            return a.name:lower() < b.name:lower()
        end)
    end

    -- Empty results after filtering/searching
    if #items == 0 then
        local msg = widgets.Label({
            x = 0, y = 0,
            text = cat == 'mission' and 'No matching missions' or 'No matching quests',
            color = theme.text_dim,
        })
        panel:add_child(msg, cx, cy)
        panel:content_height(cy - theme.title_height + theme.line_height + theme.padding)
        return
    end

    local visible_count = math.min(#items, theme.quest_rows_per_page)
    local quest_list = widgets.QuestRowList({
        x = 0, y = 0,
        width = cw,
        visible_count = visible_count,
        on_item_click = function(item, idx)
            navigate_to('guide', {
                name = item.name,
                id = item.id,
                status = item.status,
                cat = cat,
                area = area,
            })
        end,
    })
    panel:add_child(quest_list, cx, cy)
    quest_list:set_items(items)

    -- Restore scroll offset from previous render
    if params.scroll_offset then
        quest_list:scroll_to_offset(params.scroll_offset)
    end
    state.quest_list_widget = quest_list

    -- Adjust panel content height
    local total_row_h = theme.quest_row_height + theme.quest_row_gap
    local list_height = visible_count * total_row_h - theme.quest_row_gap
    local total_h = cy - theme.title_height + list_height + theme.padding
    panel:content_height(total_h)
end

---------------------------------------------------------------------------
-- View: Guide (Structured Quest Detail)
-- Redesigned layout: metadata card, requirements, prev/next, walkthrough
---------------------------------------------------------------------------

-- Status display names
local status_display = {
    completed = 'COMPLETED',
    active = 'ACTIVE',
    ['repeat'] = 'REPEATABLE',
    not_started = 'NOT STARTED',
}

local function render_guide(panel, cx, cy, cw, params)
    local name = params.name or '?'
    local cat = params.cat or 'quest'
    local area = params.area

    -- Look up live status from data layer (not stale params snapshot)
    local status = params.status
    if area then
        local area_data = data.get_area_status(cat, area)
        for _, item in ipairs(area_data.items) do
            if item.name == name then
                status = item.status
                break
            end
        end
    end

    local status_name = status or 'not_started'
    local status_color = theme.status[status_name] or theme.text

    -- Get quest/mission data from wiki
    local entry
    if cat == 'mission' then
        entry = data.get_mission_data(area, name, params.id)
    else
        entry = data.get_quest_data(area, name)
    end

    -- For missions without wiki data, build a minimal entry from the map chain
    if not entry and cat == 'mission' then
        local chain = data.get_mission_chain(area, name)
        entry = {
            description = nil,
            start_npc = nil,
            start_zone = nil,
            previous = chain and chain.previous,
            next = chain and chain.next,
        }
    end

    if not entry then
        local label_text = cat == 'mission' and 'No data available for this mission.' or 'No data available for this quest.'
        local err_label = widgets.Label({
            x = 0, y = 0,
            text = label_text,
            color = theme.status.unknown,
        })
        panel:add_child(err_label, cx, cy)
        panel:content_height(cy - theme.title_height + theme.line_height + theme.padding)
        return
    end

    -- =================================================================
    -- QUEST NAME + STATUS BADGE
    -- =================================================================
    local name_label = widgets.Label({
        x = 0, y = 0,
        text = name,
        font = theme.font_headline,
        size = theme.guide_name_size,
        color = theme.text_bright,
    })
    panel:add_child(name_label, cx, cy)

    -- Status badge (right-aligned)
    local badge_text = status_display[status_name] or 'UNKNOWN'
    local badge_char_w = theme.s(5)
    local badge_w = #badge_text * badge_char_w + theme.s(8)
    local badge_label = widgets.Label({
        x = 0, y = 0,
        text = badge_text,
        font = theme.font_label,
        size = theme.s(7),
        color = status_color,
        bg_alpha = 60,
        bg_red = status_color.red,
        bg_green = status_color.green,
        bg_blue = status_color.blue,
        padding = 3,
    })
    panel:add_child(badge_label, cx + cw - badge_w - theme.s(4), cy + theme.s(3))

    cy = cy + theme.guide_name_size + theme.s(12)

    -- =================================================================
    -- DESCRIPTION (flavor text)
    -- =================================================================
    if entry.description and #entry.description > 0 then
        -- Normalize pre-wrapped descriptions: collapse newline+whitespace into single space
        local desc_text = entry.description:gsub('\n%s*', ' ')
        local desc_lines = wiki.word_wrap(desc_text, theme.wiki_wrap_width)
        for _, line in ipairs(desc_lines) do
            local dl = widgets.Label({
                x = 0, y = 0,
                text = line,
                size = theme.guide_desc_size,
                color = theme.guide.desc_color,
                bold = false,
            })
            panel:add_child(dl, cx + theme.s(4), cy)
            cy = cy + theme.s(14)
        end
        cy = cy + theme.s(4)
    end

    -- =================================================================
    -- METADATA CARD
    -- =================================================================
    local meta_pad = theme.guide_meta_pad
    local meta_row_h = theme.guide_meta_row_h
    local col_w = math.floor((cw - meta_pad * 3) / 2)

    -- Build metadata rows (left/right pairs)
    local meta_rows = {}

    -- Row 1: NPC | Zone
    local zone_str = entry.start_zone or '--'
    if entry.start_pos then zone_str = zone_str .. ' (' .. entry.start_pos .. ')' end
    -- Truncate to prevent overflow into left column
    if #zone_str > 30 then zone_str = zone_str:sub(1, 28) .. '..' end
    table.insert(meta_rows, {
        ll = 'NPC', lv = entry.start_npc or '--',
        rl = 'ZONE', rv = zone_str,
    })

    -- Row 2: Reward | Fame
    local fame_str = entry.fame or '--'
    if entry.fame_level then fame_str = fame_str .. ' (Lvl ' .. entry.fame_level .. ')' end
    local reward_str = entry.reward or '--'
    -- Truncate multi-line rewards to first line
    local nl = reward_str:find('\n')
    if nl then reward_str = reward_str:sub(1, nl - 1) .. ' +more' end
    table.insert(meta_rows, {
        ll = 'REWARD', lv = reward_str,
        rl = 'FAME', rv = fame_str,
    })

    -- Row 3: Repeatable | Title
    local title_str = entry.title or '--'
    -- Truncate long titles
    if #title_str > 24 then title_str = title_str:sub(1, 22) .. '..' end
    table.insert(meta_rows, {
        ll = 'REPEATABLE', lv = entry.repeatable or 'No',
        rl = 'TITLE', rv = title_str,
    })

    -- Truncate metadata values to fit within their column
    local meta_max_chars = math.floor(col_w / (theme.guide_meta_value_size * 0.65))
    for _, row in ipairs(meta_rows) do
        if #row.lv > meta_max_chars then row.lv = row.lv:sub(1, meta_max_chars - 2) .. '..' end
        if #row.rv > meta_max_chars then row.rv = row.rv:sub(1, meta_max_chars - 2) .. '..' end
    end

    local meta_h = #meta_rows * meta_row_h + meta_pad * 2

    -- Card background
    local meta_bg = widgets.Image({
        x = 0, y = 0,
        width = cw, height = meta_h,
        alpha = theme.guide.meta_bg.alpha,
        red = theme.guide.meta_bg.red,
        green = theme.guide.meta_bg.green,
        blue = theme.guide.meta_bg.blue,
    })
    panel:add_child(meta_bg, cx, cy)

    -- Render metadata rows
    for i, row in ipairs(meta_rows) do
        local row_y = cy + meta_pad + (i - 1) * meta_row_h

        -- Left column: label + value
        local ll = widgets.Label({
            x = 0, y = 0,
            text = row.ll,
            size = theme.guide_meta_label_size,
            font = theme.font_label,
            color = theme.text_dim,
            bold = false,
        })
        panel:add_child(ll, cx + meta_pad, row_y)

        local lv = widgets.Label({
            x = 0, y = 0,
            text = row.lv,
            size = theme.guide_meta_value_size,
            color = theme.text_bright,
        })
        panel:add_child(lv, cx + meta_pad, row_y + theme.s(12))

        -- Right column: label + value
        local rl = widgets.Label({
            x = 0, y = 0,
            text = row.rl,
            size = theme.guide_meta_label_size,
            font = theme.font_label,
            color = theme.text_dim,
            bold = false,
        })
        panel:add_child(rl, cx + meta_pad * 2 + col_w, row_y)

        local rv = widgets.Label({
            x = 0, y = 0,
            text = row.rv,
            size = theme.guide_meta_value_size,
            color = theme.text_bright,
        })
        panel:add_child(rv, cx + meta_pad * 2 + col_w, row_y + theme.s(12))
    end

    cy = cy + meta_h + theme.guide_section_gap

    -- =================================================================
    -- REQUIREMENTS CHECKLIST
    -- =================================================================
    if entry.requirements and #entry.requirements > 0 then
        -- Check requirements (cached, cleared on inventory change)
        if not params.req_results then
            params.req_results = wiki.check_requirements(entry.requirements)
        end
        local checked = params.req_results
        local has_count = 0
        local total_trackable = 0
        if checked then
            for _, item in ipairs(checked) do
                if item.found then
                    total_trackable = total_trackable + 1
                    if item.owned >= item.count then
                        has_count = has_count + 1
                    end
                end
            end
        end

        -- Section header
        local req_header = widgets.Label({
            x = 0, y = 0,
            text = '* REQUIREMENTS',
            size = theme.guide_section_size,
            font = theme.font_label,
            color = theme.guide.section_color,
        })
        panel:add_child(req_header, cx, cy)

        -- Count (right-aligned) — only counts trackable items
        if total_trackable > 0 then
            local count_str = string.format('%d / %d', has_count, total_trackable)
            local count_w = #count_str * theme.s(5)
            local count_label = widgets.Label({
                x = 0, y = 0,
                text = count_str,
                size = theme.guide_section_size,
                font = theme.font_label,
                color = theme.text_dim,
                bold = false,
            })
            panel:add_child(count_label, cx + cw - count_w - theme.s(4), cy)
        end

        cy = cy + theme.s(16)

        -- Requirement rows
        if checked then
            local req_icon_size = theme.s(12)
            local req_text_indent = req_icon_size + theme.s(6)
            for _, item in ipairs(checked) do
                local icon_path, color
                if not item.found then
                    -- Unresolvable: show as dim info line, no icon
                    icon_path = nil
                    color = theme.text_dim
                elseif item.owned >= item.count then
                    icon_path = widgets.REQ_ICON.req_has
                    color = theme.status.req_has
                else
                    icon_path = widgets.REQ_ICON.req_missing
                    color = theme.status.req_missing
                end

                local label = item.name
                if item.found and item.count > 1 then
                    label = string.format('%s (%d/%d)', item.name, item.owned, item.count)
                end

                -- Requirement icon (left)
                if icon_path then
                    local req_icon = widgets.Image({
                        x = 0, y = 0,
                        width = req_icon_size,
                        height = req_icon_size,
                        path = icon_path,
                        red = color.red,
                        green = color.green,
                        blue = color.blue,
                        alpha = color.alpha,
                    })
                    panel:add_child(req_icon, cx + theme.s(4), cy + theme.s(3))
                end

                local req_label = widgets.Label({
                    x = 0, y = 0,
                    text = (icon_path and '' or '  - ') .. label,
                    size = theme.font_size,
                    color = color,
                })
                panel:add_child(req_label, cx + (icon_path and req_text_indent or 0), cy)

                -- Right-side status icon removed — left icon is sufficient

                cy = cy + theme.s(16)
            end
        end
        cy = cy + theme.s(4)
    end

    -- =================================================================
    -- QUEST CHAIN (Previous / Next)
    -- =================================================================
    local has_prev = entry.previous and #entry.previous > 0
    local has_next = entry.next and #entry.next > 0

    if has_prev or has_next then
        local chain_indent = theme.s(16)

        -- Previous quest(s)
        if has_prev then
            local prev_prefix = widgets.Label({
                x = 0, y = 0,
                text = '< Previous:',
                size = theme.font_size,
                color = theme.text_dim,
                bold = false,
            })
            panel:add_child(prev_prefix, cx, cy)
            cy = cy + theme.line_height

            for _, pname in ipairs(entry.previous) do
                local prev_btn = widgets.Button({
                    x = 0, y = 0,
                    text = pname,
                    size = theme.font_size,
                    color = theme.accent,
                    hover_color = theme.breadcrumb.text_hover,
                    bg_color = {alpha = 0, red = 0, green = 0, blue = 0},
                    bg_hover_color = theme.button.hover,
                    padding = 1,
                    on_click = function()
                        local target_area
                        if cat == 'mission' then
                            target_area = data.find_mission_area(pname, area) or area
                        else
                            target_area = data.find_quest_area(pname, area) or area
                        end
                        navigate_to_quest(pname, cat, target_area)
                    end,
                })
                panel:add_child(prev_btn, cx + chain_indent, cy)
                cy = cy + theme.line_height
            end
        end

        -- Next quest(s)
        if has_next then
            local next_prefix = widgets.Label({
                x = 0, y = 0,
                text = '> Next:',
                size = theme.font_size,
                color = theme.text_dim,
                bold = false,
            })
            panel:add_child(next_prefix, cx, cy)
            cy = cy + theme.line_height

            for _, nname in ipairs(entry.next) do
                local next_btn = widgets.Button({
                    x = 0, y = 0,
                    text = nname,
                    size = theme.font_size,
                    color = theme.accent,
                    hover_color = theme.breadcrumb.text_hover,
                    bg_color = {alpha = 0, red = 0, green = 0, blue = 0},
                    bg_hover_color = theme.button.hover,
                    padding = 1,
                    on_click = function()
                        local target_area
                        if cat == 'mission' then
                            target_area = data.find_mission_area(nname, area) or area
                        else
                            target_area = data.find_quest_area(nname, area) or area
                        end
                        navigate_to_quest(nname, cat, target_area)
                    end,
                })
                panel:add_child(next_btn, cx + chain_indent, cy)
                cy = cy + theme.line_height
            end
        end

        cy = cy + theme.s(6)
    end

    -- =================================================================
    -- WALKTHROUGH + NOTES (read-only ScrollList)
    -- =================================================================
    if not params.walk_lines then
        params.walk_lines = wiki.build_walkthrough_lines(entry)
    end

    local walk_lines = params.walk_lines
    if #walk_lines > 0 then
        -- Section header (styled like REQUIREMENTS)
        local walk_header = widgets.Label({
            x = 0, y = 0,
            text = 'WALKTHROUGH',
            size = theme.guide_section_size,
            font = theme.font_label,
            color = theme.guide.section_color,
        })
        panel:add_child(walk_header, cx, cy)
        cy = cy + theme.s(16)

        local visible_count = math.min(#walk_lines, theme.items_per_page)
        if visible_count == 0 then visible_count = 1 end

        local scroll_list = widgets.ScrollList({
            x = 0, y = 0,
            width = cw,
            visible_count = visible_count,
            line_height = theme.line_height,
            read_only = true,
        })
        panel:add_child(scroll_list, cx, cy)
        scroll_list:set_items(walk_lines)

        -- Restore scroll offset from previous render
        if params.walk_scroll_offset then
            scroll_list:scroll_to_offset(params.walk_scroll_offset)
        end
        state.walk_list_widget = scroll_list

        local list_height = visible_count * theme.line_height
        cy = cy + list_height
    end

    cy = cy + theme.padding
    local total_h = cy - theme.title_height
    panel:content_height(total_h)
end

---------------------------------------------------------------------------
-- Main render function — dispatches to view renderer
---------------------------------------------------------------------------
render_current = function()
    local panel = state.panel
    if not panel then return end

    -- Remember position and visibility
    local px, py = panel:get_pos()
    local was_visible = panel:visible()

    -- Capture scroll offsets before clearing widgets
    local cv = state.current_view
    if cv then
        if cv.view_type == 'item_list' and state.quest_list_widget then
            cv.params.scroll_offset = state.quest_list_widget._scroll_offset
        elseif cv.view_type == 'guide' and state.walk_list_widget then
            cv.params.walk_scroll_offset = state.walk_list_widget._scroll_offset
        end
    end
    state.quest_list_widget = nil
    state.walk_list_widget = nil

    -- Clear existing content children
    panel:clear_children()

    -- Layout constants
    local cx = theme.padding
    local cy = theme.title_height + theme.padding
    local cw = panel:content_width()

    -- Build breadcrumb (returns updated cy, or same cy for top-level)
    cy = build_breadcrumb(panel, cx, cy)

    -- Dispatch to view renderer
    local cv = state.current_view
    if not cv or cv.view_type == 'top_level' then
        render_top_level(panel, cx, cy, cw)
    elseif cv.view_type == 'item_list' then
        render_item_list(panel, cx, cy, cw, cv.params)
    elseif cv.view_type == 'guide' then
        render_guide(panel, cx, cy, cw, cv.params)
    end

    -- Restore visibility
    if was_visible then
        panel:show()
    end
end

---------------------------------------------------------------------------
-- Public API
---------------------------------------------------------------------------

-- Initialize the views system with a panel
function views.init(panel, on_close)
    state.panel = panel
    state.on_close = on_close
    state.view_stack = {}
    state.current_view = {view_type = 'top_level', params = {}}
end

function views.set_settings(s)
    state.settings = s
end

-- Render the current view (call after init or when data changes)
function views.render()
    render_current()
end

-- Refresh — re-render current view with updated data
function views.refresh()
    render_current()
end

-- Navigate to top level
function views.go_home()
    navigate_to_root()
end

-- Refresh requirements in guide view (called when inventory/key items change)
-- Clears cached requirement results so they rebuild with fresh inventory data
function views.refresh_guide()
    local cv = state.current_view
    if cv and cv.view_type == 'guide' then
        cv.params.req_results = nil
        cv.params.walk_lines = nil
        render_current()
    end
end

-- Get current view type (for collapse/expand restore)
function views.get_state()
    return {
        current_view = state.current_view,
        view_stack = state.view_stack,
    }
end

-- Restore view state (after collapse/expand)
function views.restore_state(saved)
    if saved then
        state.current_view = saved.current_view
        state.view_stack = saved.view_stack
    end
end

return views
