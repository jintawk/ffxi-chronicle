--Copyright (c) 2026, Jintawk
--All rights reserved.

--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:

--    * Redistributions of source code must retain the above copyright
--      notice, this list of conditions and the following disclaimer.
--    * Redistributions in binary form must reproduce the above copyright
--      notice, this list of conditions and the following disclaimer in the
--      documentation and/or other materials provided with the distribution.
--    * Neither the name of Chronicle nor the
--      names of its contributors may be used to endorse or promote products
--      derived from this software without specific prior written permission.

--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL Jintawk BE LIABLE FOR ANY
--DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
--ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.name = 'chronicle'
_addon.author = 'Jintawk'
_addon.commands = {'chronicle', 'cr'}
_addon.version = '1.1.0'

local config = require('config')
local packets = require('packets')
local data = require('data')
local widgets = require('ui/widgets')
local theme = require('ui/theme')
local views = require('ui/views')
local wiki = require('wiki')

---------------------------------------------------------------------------
-- Settings
---------------------------------------------------------------------------
local defaults = {
    pos = {x = 200, y = 150},
    visible_on_load = true,
    collapsed_on_load = false,
    scale = 1.0,
    sort_mode = 1,    -- 1=Default, 2=Name, 3=Status
    filter_mode = 1,  -- 1=All, 2=Done, 3=Todo
    active_tab = 'mission',  -- 'mission' or 'quest' (default tab on home view)
}

local settings = config.load(defaults)

-- Apply saved scale to theme
theme.set_scale(settings.scale)

---------------------------------------------------------------------------
-- UI state
---------------------------------------------------------------------------
local ui = {
    panel = nil,
    visible = false,
}

---------------------------------------------------------------------------
-- Save current UI state to settings
---------------------------------------------------------------------------
local function save_settings()
    if ui.panel then
        local x, y = ui.panel:get_pos()
        settings.pos.x = x
        settings.pos.y = y
    end
    settings:save()
end

---------------------------------------------------------------------------
-- UI construction — builds panel and initializes view system
---------------------------------------------------------------------------
local function build_ui()
    -- Preserve position across rebuilds; use settings as default
    local saved_x = settings.pos.x
    local saved_y = settings.pos.y
    local saved_view_state = nil
    local was_collapsed = settings.collapsed_on_load

    if ui.panel then
        saved_x, saved_y = ui.panel:get_pos()
        saved_view_state = views.get_state()
        was_collapsed = ui.panel:is_collapsed()
        ui.panel:destroy()
        ui.panel = nil
    end

    -- Create the main panel
    ui.panel = widgets.Panel({
        x = saved_x,
        y = saved_y,
        width = theme.window_width,
        height = 200,
        title = 'Chronicle',
        title_font = theme.font_headline,
        title_size = theme.title_size,
        collapsed = was_collapsed,
        on_close = function()
            ui.visible = false
            save_settings()
        end,
    })

    -- Initialize the view system
    views.init(ui.panel, function()
        ui.visible = false
        save_settings()
    end)
    views.set_settings(settings)

    -- Restore previous view state if rebuilding
    if saved_view_state then
        views.restore_state(saved_view_state)
    end

    -- Render the current view
    views.render()
end

---------------------------------------------------------------------------
-- UI show/hide/toggle
---------------------------------------------------------------------------
local function show_ui()
    if not ui.panel then
        build_ui()
    end
    ui.panel:show()
    ui.visible = true
end

local function hide_ui()
    if ui.panel then
        save_settings()
        ui.panel:hide()
    end
    ui.visible = false
end

local function toggle_ui()
    if ui.visible then
        hide_ui()
    else
        show_ui()
    end
end

local function reset_ui()
    if ui.panel then
        ui.panel:pos(200, 150)
        settings.pos.x = 200
        settings.pos.y = 150
        settings:save()
        windower.add_to_chat(207, 'Chronicle: Window position reset.')
    end
end

local function refresh_ui()
    if ui.panel and ui.visible then
        build_ui()
        ui.panel:show()
    end
end

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------

-- Keyboard event — delegate to widgets for TextInput focus handling
windower.register_event('keyboard', function(dik, down, flags, blocked)
    return widgets.handle_keyboard(dik, down, flags, blocked)
end)

-- Prerender — tick text input cursor blink
windower.register_event('prerender', function()
    widgets.tick_inputs()
end)

-- Handle incoming story log packets
-- Track whether a refresh is already scheduled to avoid spamming rebuilds
local refresh_scheduled = false
local guide_refresh_scheduled = false

windower.register_event('incoming chunk', function(id, original)
    -- Key Item Log update — refresh requirements checklist
    if id == 0x055 then
        views.refresh_guide()
        return
    end

    if id ~= 0x056 then return end

    local ok, err = pcall(function()
        local p = packets.parse('incoming', original)
        data.parse_packet(p)
    end)
    if not ok then
        windower.add_to_chat(167, 'Chronicle: Packet parse error: ' .. tostring(err))
    end

    -- Schedule a UI refresh after packets finish arriving (they come in bursts)
    if not refresh_scheduled then
        refresh_scheduled = true
        coroutine.schedule(function()
            refresh_scheduled = false
            refresh_ui()
        end, 2)
    end
end)

-- Handle item changes — refresh requirements checklist (debounced like packet handler)
windower.register_event('add item', function(bag, index, id, count)
    if not guide_refresh_scheduled then
        guide_refresh_scheduled = true
        coroutine.schedule(function()
            guide_refresh_scheduled = false
            views.refresh_guide()
        end, 1)
    end
end)

-- Handle zone change
windower.register_event('zone change', function(new_id, old_id)
    data.on_zone_change()
    -- UI refresh happens automatically via incoming chunk handler above
end)

-- Handle login/logout
windower.register_event('login', function(name)
    data.on_login(name)
    config.reload(settings)
    theme.set_scale(settings.scale)
end)

windower.register_event('logout', function(name)
    save_settings()
    data.on_logout()
    if ui.panel then
        ui.panel:destroy()
        ui.panel = nil
    end
    ui.visible = false
end)

-- Cleanup on addon unload
windower.register_event('unload', function()
    save_settings()
    widgets.cleanup()
end)

-- Command handler
windower.register_event('addon command', function(...)
    local args = {...}
    local cmd = args[1] and args[1]:lower() or 'toggle'

    if cmd == 'toggle' or cmd == '' then
        toggle_ui()
    elseif cmd == 'show' then
        show_ui()
    elseif cmd == 'hide' then
        hide_ui()
    elseif cmd == 'reset' then
        reset_ui()
    elseif cmd == 'compact' then
        if ui.panel then
            ui.panel:toggle_collapse()
        end
    elseif cmd == 'refresh' then
        build_ui()
        show_ui()
        windower.add_to_chat(207, 'Chronicle: UI refreshed.')
    elseif cmd == 'home' then
        views.go_home()
    elseif cmd == 'autoshow' then
        settings.visible_on_load = not settings.visible_on_load
        settings:save()
        windower.add_to_chat(207, 'Chronicle: Auto-show on load: ' .. (settings.visible_on_load and 'ON' or 'OFF'))
    elseif cmd == 'q' or cmd == 'quests' then
        local area = args[2] and args[2]:lower() or nil
        if area then
            data.print_area('quest', area)
        else
            data.print_type_summary('quest')
        end
    elseif cmd == 'm' or cmd == 'missions' then
        local area = args[2] and args[2]:lower() or nil
        if area then
            data.print_area('mission', area)
        else
            data.print_type_summary('mission')
        end
    elseif cmd == 'size' then
        local param = args[2] and args[2]:lower() or nil
        if not param then
            -- Report current size
            windower.add_to_chat(207, string.format('Chronicle: UI scale = %.2f', theme.scale))
        else
            local new_scale
            if param == '+' or param == 'up' then
                new_scale = theme.scale + 0.1
            elseif param == '-' or param == 'down' then
                new_scale = theme.scale - 0.1
            elseif param == 'reset' then
                new_scale = 1.0
            else
                new_scale = tonumber(param)
                if not new_scale then
                    windower.add_to_chat(167, 'Chronicle: Invalid size value. Use a number, +, -, or reset.')
                    return
                end
            end
            theme.set_scale(new_scale)
            settings.scale = theme.scale
            settings:save()
            windower.add_to_chat(207, string.format('Chronicle: UI scale set to %.2f', theme.scale))
            -- Rebuild UI at new scale
            if ui.panel and ui.visible then
                build_ui()
                ui.panel:show()
            end
        end
    elseif cmd == 'debug' then
        data.toggle_debug()
    elseif cmd == 'unknown' then
        data.print_unknown_ids()
    elseif cmd == 'help' then
        windower.add_to_chat(207, 'Chronicle commands:')
        windower.add_to_chat(207, '  //cr              - Toggle UI window')
        windower.add_to_chat(207, '  //cr show/hide    - Show or hide window')
        windower.add_to_chat(207, '  //cr compact      - Toggle collapsed/expanded')
        windower.add_to_chat(207, '  //cr reset        - Reset window position')
        windower.add_to_chat(207, '  //cr refresh      - Rebuild UI with current data')
        windower.add_to_chat(207, '  //cr home         - Navigate to top-level view')
        windower.add_to_chat(207, '  //cr autoshow     - Toggle auto-show on load')
        windower.add_to_chat(207, '  //cr size             - Report current UI scale')
        windower.add_to_chat(207, '  //cr size +/-         - Increase/decrease UI scale by 0.1')
        windower.add_to_chat(207, '  //cr size <number>    - Set UI scale (0.5 - 3.0)')
        windower.add_to_chat(207, '  //cr size reset       - Reset UI scale to 1.0')
        windower.add_to_chat(207, '  //cr unknown      - List unknown quest/mission IDs')
        windower.add_to_chat(207, '  //cr q [area]     - Show quest summary / area detail (chat)')
        windower.add_to_chat(207, '  //cr m [area]     - Show mission summary / area detail (chat)')
        windower.add_to_chat(207, '  //cr debug        - Toggle debug logging')
        windower.add_to_chat(207, '  //cr help         - Show this help')
    else
        windower.add_to_chat(167, 'Chronicle: Unknown command "'..cmd..'". Use //cr help')
    end
end)

-- Auto-show on load if configured
if settings.visible_on_load then
    show_ui()
end

windower.add_to_chat(207, 'Chronicle v' .. _addon.version .. ' loaded. Use //cr to toggle UI. Zone to load data.')
