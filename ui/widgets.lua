--[[
    Chronicle UI widget system
    Reusable widgets built on Windower's texts/images primitives

    Widgets:
    - Panel: Background container with title bar, drag, collapse/close
    - Bar: Progress bar with fill + text overlay
    - Button: Clickable text with hover feedback
    - ImageButton: Clickable image with hover feedback
    - Label: Non-interactive text display
    - ScrollList: Vertical scrollable list of items
    - Breadcrumb: Clickable navigation path
]]

local texts = require('texts')
local images = require('images')
local theme = require('ui/theme')

local widgets = {}

-- Icon asset paths
local ASSETS = windower.addon_path .. 'assets/'
local STATUS_ICON = {
    completed     = ASSETS .. 'completed.png',
    active        = ASSETS .. 'pending.png',
    not_started   = ASSETS .. 'not_started.png',
    ['repeat']    = ASSETS .. 'repeat.png',
    uncompletable = ASSETS .. 'unknown.png',
    unknown       = ASSETS .. 'unknown.png',
}
local REQ_ICON = {
    req_has     = ASSETS .. 'completed.png',
    req_missing = ASSETS .. 'req_missing.png',
    req_unknown = ASSETS .. 'unknown.png',
    req_header  = ASSETS .. 'req_header.png',
}
local BREADCRUMB_ICON = ASSETS .. 'breadcrumb.png'

-- Expose icon tables for use by views
widgets.STATUS_ICON = STATUS_ICON
widgets.REQ_ICON = REQ_ICON

-- Track all clickable widgets for mouse event handling
local clickables = {}
local active_panel = nil  -- cached Panel reference for over_any_panel
local drag_state = nil  -- {panel, offset_x, offset_y}
local mouse_down_target = nil

---------------------------------------------------------------------------
-- Unique name generator for primitives
---------------------------------------------------------------------------
local prim_counter = 0
local function next_name(prefix)
    prim_counter = prim_counter + 1
    return string.format('ql_%s_%d', prefix, prim_counter)
end

---------------------------------------------------------------------------
-- Label widget — non-interactive text
---------------------------------------------------------------------------
local Label = {}
Label.__index = Label

function widgets.Label(opts)
    local self = setmetatable({}, Label)
    opts = opts or {}

    self._text = texts.new(opts.text or '', {
        pos = {x = opts.x or 0, y = opts.y or 0},
        bg = {
            alpha = opts.bg_alpha or 0,
            red = opts.bg_red or 0,
            green = opts.bg_green or 0,
            blue = opts.bg_blue or 0,
            visible = (opts.bg_alpha or 0) > 0,
        },
        text = {
            font = opts.font or theme.font_name,
            size = opts.size or theme.font_size,
            alpha = opts.color and opts.color.alpha or theme.text.alpha,
            red = opts.color and opts.color.red or theme.text.red,
            green = opts.color and opts.color.green or theme.text.green,
            blue = opts.color and opts.color.blue or theme.text.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {
            bold = opts.bold ~= false, -- bold by default
            draggable = false,
        },
        padding = opts.padding or 0,
    })

    self._visible = false
    return self
end

function Label:text(str)
    if str then
        self._text:text(str)
    end
    return self._text:text()
end

function Label:pos(x, y)
    self._text:pos(x, y)
end

function Label:color(r, g, b)
    self._text:color(r, g, b)
end

function Label:alpha(a)
    self._text:alpha(a)
end

function Label:bg_color(r, g, b)
    self._text:bg_color(r, g, b)
end

function Label:bg_alpha(a)
    self._text:bg_alpha(a)
    self._text:bg_visible(a > 0)
end

function Label:size(s)
    self._text:size(s)
end

function Label:bold(b)
    self._text:bold(b)
end

function Label:extents()
    return self._text:extents()
end

function Label:show()
    self._visible = true
    self._text:show()
end

function Label:hide()
    self._visible = false
    self._text:hide()
end

function Label:visible()
    return self._visible
end

function Label:destroy()
    self._text:destroy()
end

---------------------------------------------------------------------------
-- Image widget — non-interactive image from file
---------------------------------------------------------------------------
local Image = {}
Image.__index = Image

function widgets.Image(opts)
    local self = setmetatable({}, Image)
    opts = opts or {}

    self._img = images.new({
        pos = {x = opts.x or 0, y = opts.y or 0},
        size = {width = opts.width or 16, height = opts.height or 16},
        color = {
            alpha = opts.alpha or 255,
            red = opts.red or 255,
            green = opts.green or 255,
            blue = opts.blue or 255,
        },
        texture = {fit = false, path = opts.path},
        draggable = false,
    })

    self._visible = false
    return self
end

function Image:pos(x, y)
    self._img:pos(x, y)
end

function Image:show()
    self._visible = true
    self._img:show()
end

function Image:hide()
    self._visible = false
    self._img:hide()
end

function Image:visible()
    return self._visible
end

function Image:path(p)
    self._img:path(p)
end

function Image:color(r, g, b)
    self._img:color(r, g, b)
end

function Image:alpha(a)
    self._img:alpha(a)
end

function Image:destroy()
    self._img:destroy()
end

---------------------------------------------------------------------------
-- ImageButton widget — clickable image with hover feedback (alpha tinting)
---------------------------------------------------------------------------
local ImageButton = {}
ImageButton.__index = ImageButton

function widgets.ImageButton(opts)
    local self = setmetatable({}, ImageButton)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._w = opts.width or 16
    self._h = opts.height or 16
    self._hovered = false
    self._visible = false
    self._normal_alpha = opts.alpha or 180
    self._hover_alpha = opts.hover_alpha or 255

    self._img = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = self._w, height = self._h},
        color = {
            alpha = self._normal_alpha,
            red = opts.red or 255,
            green = opts.green or 255,
            blue = opts.blue or 255,
        },
        texture = {fit = false, path = opts.path},
        draggable = false,
    })

    self.on_click = opts.on_click
    self._id = next_name('imgbtn')
    clickables[self._id] = self

    return self
end

function ImageButton:pos(x, y)
    self._x = x
    self._y = y
    self._img:pos(x, y)
end

function ImageButton:hover(x, y)
    if not self._visible then return false end
    return x >= self._x and x <= self._x + self._w
       and y >= self._y and y <= self._y + self._h
end

function ImageButton:set_hovered(is_hovered)
    if is_hovered == self._hovered then return end
    self._hovered = is_hovered
    if is_hovered then
        self._img:alpha(self._hover_alpha)
    else
        self._img:alpha(self._normal_alpha)
    end
end

function ImageButton:show()
    self._visible = true
    self._img:show()
end

function ImageButton:hide()
    self._visible = false
    self._hovered = false
    self._img:hide()
end

function ImageButton:visible()
    return self._visible
end

function ImageButton:path(new_path)
    self._img:path(new_path)
end

function ImageButton:destroy()
    clickables[self._id] = nil
    self._img:destroy()
end

---------------------------------------------------------------------------
-- Button widget — clickable text with hover feedback
---------------------------------------------------------------------------
local Button = {}
Button.__index = Button

function widgets.Button(opts)
    local self = setmetatable({}, Button)
    opts = opts or {}

    local tc = opts.color or theme.button.text
    local hc = opts.hover_color or theme.button.text_hover
    local bgc = opts.bg_color or theme.button.normal
    local bhc = opts.bg_hover_color or theme.button.hover

    self._normal_color = {r = tc.red, g = tc.green, b = tc.blue}
    self._hover_color = {r = hc.red, g = hc.green, b = hc.blue}
    self._normal_bg = {a = bgc.alpha, r = bgc.red, g = bgc.green, b = bgc.blue}
    self._hover_bg = {a = bhc.alpha, r = bhc.red, g = bhc.green, b = bhc.blue}
    self._hovered = false
    self._visible = false

    self._text = texts.new(opts.text or '', {
        pos = {x = opts.x or 0, y = opts.y or 0},
        bg = {
            alpha = bgc.alpha,
            red = bgc.red,
            green = bgc.green,
            blue = bgc.blue,
            visible = true,
        },
        text = {
            font = opts.font or theme.font_name,
            size = opts.size or theme.font_size,
            alpha = tc.alpha or 255,
            red = tc.red,
            green = tc.green,
            blue = tc.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {
            bold = opts.bold ~= false,
            draggable = false,
        },
        padding = opts.padding or 2,
    })

    self.on_click = opts.on_click
    self._id = next_name('btn')

    -- Register for mouse events
    clickables[self._id] = self

    return self
end

function Button:text(str)
    if str then
        self._text:text(str)
    end
    return self._text:text()
end

function Button:pos(x, y)
    self._text:pos(x, y)
end

function Button:color(r, g, b)
    self._normal_color = {r = r, g = g, b = b}
    if not self._hovered then
        self._text:color(r, g, b)
    end
end

function Button:extents()
    return self._text:extents()
end

function Button:hover(x, y)
    return self._visible and self._text:hover(x, y)
end

function Button:set_hovered(is_hovered)
    if is_hovered == self._hovered then return end
    self._hovered = is_hovered
    if is_hovered then
        self._text:color(self._hover_color.r, self._hover_color.g, self._hover_color.b)
        self._text:bg_alpha(self._hover_bg.a)
        self._text:bg_color(self._hover_bg.r, self._hover_bg.g, self._hover_bg.b)
    else
        self._text:color(self._normal_color.r, self._normal_color.g, self._normal_color.b)
        self._text:bg_alpha(self._normal_bg.a)
        self._text:bg_color(self._normal_bg.r, self._normal_bg.g, self._normal_bg.b)
    end
end

function Button:show()
    self._visible = true
    self._text:show()
end

function Button:hide()
    self._visible = false
    self._hovered = false
    self._text:hide()
end

function Button:visible()
    return self._visible
end

function Button:destroy()
    clickables[self._id] = nil
    self._text:destroy()
end

---------------------------------------------------------------------------
-- Bar widget — progress bar with background, fill, text overlay
---------------------------------------------------------------------------
local Bar = {}
Bar.__index = Bar

function widgets.Bar(opts)
    local self = setmetatable({}, Bar)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._width = opts.width or (theme.window_width - theme.padding * 2)
    self._height = opts.height or theme.bar_height
    self._visible = false
    self._clickable = opts.clickable or false
    self.on_click = opts.on_click

    local fill_color = opts.fill_color or theme.bar.fill_default
    local bg_color = opts.bar_bg_color or theme.bar.bg

    -- Background image (full width)
    self._bg = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = self._width, height = self._height},
        color = {
            alpha = bg_color.alpha,
            red = bg_color.red,
            green = bg_color.green,
            blue = bg_color.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Fill image (scaled by percentage)
    self._fill_color = fill_color
    self._fill = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = 0, height = self._height},
        color = {
            alpha = fill_color.alpha,
            red = fill_color.red,
            green = fill_color.green,
            blue = fill_color.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Text overlay
    self._label = texts.new('', {
        pos = {x = self._x + theme.bar_text_inset, y = self._y},
        bg = {alpha = 0, visible = false},
        text = {
            font = theme.font_name,
            size = opts.font_size or math.max(7, theme.font_size - theme.s(1)),
            alpha = theme.bar.text.alpha,
            red = theme.bar.text.red,
            green = theme.bar.text.green,
            blue = theme.bar.text.blue,
            stroke = {width = 1, alpha = 180, red = 0, green = 0, blue = 0},
        },
        flags = {bold = true, draggable = false},
    })

    self._percent = 0
    self._hovered = false
    self._id = next_name('bar')

    if self._clickable then
        clickables[self._id] = self
    end

    return self
end

function Bar:set_hovered(is_hovered)
    if is_hovered == self._hovered then return end
    self._hovered = is_hovered
    if is_hovered then
        self._fill:color(
            math.min(255, self._fill_color.red + 30),
            math.min(255, self._fill_color.green + 30),
            math.min(255, self._fill_color.blue + 30)
        )
        self._fill:alpha(math.min(255, self._fill_color.alpha + 25))
    else
        self._fill:color(self._fill_color.red, self._fill_color.green, self._fill_color.blue)
        self._fill:alpha(self._fill_color.alpha)
    end
end

function Bar:update(completed, total, label_text)
    if total == 0 then
        self._percent = 0
    else
        self._percent = completed / total
    end

    local fill_width = math.max(1, math.floor(self._width * self._percent))
    if self._percent == 0 then fill_width = 0 end
    self._fill:size(fill_width, self._height)

    if label_text then
        self._label:text(label_text)
    else
        local pct = math.floor(self._percent * 100)
        self._label:text(string.format('%d/%d (%d%%)', completed, total, pct))
    end
end

function Bar:fill_color(color)
    self._fill_color = color
    self._fill:color(color.red, color.green, color.blue)
    self._fill:alpha(color.alpha)
end

function Bar:pos(x, y)
    self._x = x
    self._y = y
    self._bg:pos(x, y)
    self._fill:pos(x, y)
    self._label:pos(x + theme.bar_text_inset, y)
end

function Bar:hover(x, y)
    if not self._visible then return false end
    return self._bg:hover(x, y)
end

function Bar:show()
    self._visible = true
    self._bg:show()
    self._fill:show()
    self._label:show()
end

function Bar:hide()
    self._visible = false
    self._bg:hide()
    self._fill:hide()
    self._label:hide()
end

function Bar:visible()
    return self._visible
end

function Bar:destroy()
    if self._clickable then
        clickables[self._id] = nil
    end
    self._bg:destroy()
    self._fill:destroy()
    self._label:destroy()
end

---------------------------------------------------------------------------
-- ScrollList widget — vertical scrollable list
---------------------------------------------------------------------------
local ScrollList = {}
ScrollList.__index = ScrollList

function widgets.ScrollList(opts)
    local self = setmetatable({}, ScrollList)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._width = opts.width or (theme.window_width - theme.padding * 2)
    self._visible_count = opts.visible_count or theme.items_per_page
    self._line_height = opts.line_height or theme.line_height
    self._visible = false
    self._scroll_offset = 0
    self._items = {}       -- {text, status, data} entries
    self._rows = {}        -- Button or Label widgets for visible rows
    self._row_icons = {}   -- Status icon images for non-read_only rows
    self._read_only = opts.read_only or false
    self.on_item_click = opts.on_item_click

    self._id = next_name('scroll')

    -- Icon dimensions for status icons in list rows
    local icon_size = theme.s(12)
    local icon_text_gap = theme.s(4)
    self._row_icon_size = icon_size
    self._row_text_offset = self._read_only and 0 or (icon_size + icon_text_gap)

    -- Create row widgets for visible items
    for i = 1, self._visible_count do
        local row_y = self._y + (i - 1) * self._line_height
        if self._read_only then
            -- Labels: no hover effect, no click handler
            local label = widgets.Label({
                x = self._x,
                y = row_y,
                text = '',
                size = opts.font_size or theme.font_size,
                padding = 1,
                bold = false,
            })
            self._rows[i] = label
        else
            -- Status icon per row
            self._row_icons[i] = widgets.Image({
                x = self._x + theme.s(2),
                y = row_y + math.floor((self._line_height - icon_size) / 2),
                width = icon_size,
                height = icon_size,
            })

            local btn = widgets.Button({
                x = self._x + self._row_text_offset,
                y = row_y,
                text = '',
                padding = 1,
                on_click = function()
                    local item_idx = self._scroll_offset + i
                    if item_idx <= #self._items and self.on_item_click then
                        self.on_item_click(self._items[item_idx], item_idx)
                    end
                end,
            })
            self._rows[i] = btn
        end
    end

    -- Scroll indicator background
    self._scroll_bg = images.new({
        pos = {x = self._x + self._width - theme.scroll_indicator_width, y = self._y},
        size = {width = theme.scroll_indicator_width, height = self._visible_count * self._line_height},
        color = {
            alpha = theme.scroll.bg.alpha,
            red = theme.scroll.bg.red,
            green = theme.scroll.bg.green,
            blue = theme.scroll.bg.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Scroll indicator thumb
    self._scroll_thumb = images.new({
        pos = {x = self._x + self._width - theme.scroll_indicator_width, y = self._y},
        size = {width = theme.scroll_indicator_width, height = 20},
        color = {
            alpha = theme.scroll.thumb.alpha,
            red = theme.scroll.thumb.red,
            green = theme.scroll.thumb.green,
            blue = theme.scroll.thumb.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Register for scroll events
    clickables[self._id] = self

    return self
end

function ScrollList:set_items(items)
    self._items = items or {}
    self._scroll_offset = 0
    self:_refresh()
end

function ScrollList:scroll_up()
    if self._scroll_offset > 0 then
        self._scroll_offset = self._scroll_offset - 1
        self:_refresh()
    end
end

function ScrollList:scroll_down()
    local max_offset = math.max(0, #self._items - self._visible_count)
    if self._scroll_offset < max_offset then
        self._scroll_offset = self._scroll_offset + 1
        self:_refresh()
    end
end

function ScrollList:hover(x, y)
    if not self._visible then return false end
    -- Simple bounding box check over the entire scroll list area
    local x2 = self._x + self._width
    local y2 = self._y + self._visible_count * self._line_height
    return x >= self._x and x <= x2 and y >= self._y and y <= y2
end

function ScrollList:_refresh()
    local total = #self._items
    local max_offset = math.max(0, total - self._visible_count)

    for i = 1, self._visible_count do
        local item_idx = self._scroll_offset + i
        local row = self._rows[i]

        if item_idx <= total then
            local item = self._items[item_idx]
            local status_color = theme.status[item.status] or theme.text

            if self._read_only then
                row:text(item.name or '')
            else
                local tag = item.status == 'repeat' and '  [RPT]' or ''
                row:text(string.format(' %s%s', item.name or '', tag))

                -- Update row icon
                local icon = self._row_icons[i]
                if icon then
                    local icon_path = STATUS_ICON[item.status]
                    if icon_path then
                        local ic = theme.status[item.status] or theme.text
                        icon:path(icon_path)
                        icon:color(ic.red, ic.green, ic.blue)
                        icon:alpha(ic.alpha)
                        if self._visible then icon:show() end
                    else
                        icon:hide()
                    end
                end
            end
            row:color(status_color.red, status_color.green, status_color.blue)

            if self._visible then row:show() end
        else
            row:text('')
            row:hide()
            -- Hide row icon
            local icon = self._row_icons[i]
            if icon then icon:hide() end
        end
    end

    -- Update scroll indicator
    if total > self._visible_count then
        local track_height = self._visible_count * self._line_height
        local thumb_height = math.max(theme.s(10), math.floor(track_height * self._visible_count / total))
        local thumb_y = self._y
        if max_offset > 0 then
            thumb_y = self._y + math.floor((track_height - thumb_height) * self._scroll_offset / max_offset)
        end
        self._scroll_thumb:size(theme.scroll_indicator_width, thumb_height)
        self._scroll_thumb:pos(self._x + self._width - theme.scroll_indicator_width, thumb_y)

        -- Store geometry for drag hit-testing
        self._track_x = self._x + self._width - theme.scroll_indicator_width
        self._track_y = self._y
        self._track_h = track_height
        self._thumb_y = thumb_y
        self._thumb_h = thumb_height
        self._scroll_active = true

        if self._visible then
            self._scroll_bg:show()
            self._scroll_thumb:show()
        end
    else
        self._scroll_bg:hide()
        self._scroll_thumb:hide()
        self._scroll_active = false
    end
end

function ScrollList:scroll_to_offset(offset)
    local max_off = math.max(0, #self._items - self._visible_count)
    self._scroll_offset = math.max(0, math.min(max_off, offset))
    self:_refresh()
end

-- Hit-test the scroll thumb (with padding for easier clicking)
function ScrollList:hover_scroll_thumb(x, y)
    if not self._visible or not self._scroll_active then return false end
    local pad = theme.s(6)
    return x >= self._track_x - pad and x <= self._track_x + theme.scroll_indicator_width + pad
       and y >= self._thumb_y and y <= self._thumb_y + self._thumb_h
end

-- Hit-test the scroll track (not the thumb)
function ScrollList:hover_scroll_track(x, y)
    if not self._visible or not self._scroll_active then return false end
    local pad = theme.s(6)
    return x >= self._track_x - pad and x <= self._track_x + theme.scroll_indicator_width + pad
       and y >= self._track_y and y <= self._track_y + self._track_h
       and not self:hover_scroll_thumb(x, y)
end

function ScrollList:pos(x, y)
    self._x = x
    self._y = y
    local icon_size = self._row_icon_size
    for i, row in ipairs(self._rows) do
        local row_y = y + (i - 1) * self._line_height
        row:pos(x + self._row_text_offset, row_y)
        local icon = self._row_icons[i]
        if icon then
            icon:pos(x + theme.s(2), row_y + math.floor((self._line_height - icon_size) / 2))
        end
    end
    self._scroll_bg:pos(x + self._width - theme.scroll_indicator_width, y)
    self._scroll_thumb:pos(x + self._width - theme.scroll_indicator_width, y)
    self:_refresh()
end

function ScrollList:show()
    self._visible = true
    self:_refresh()
    for i = 1, self._visible_count do
        local item_idx = self._scroll_offset + i
        if item_idx <= #self._items then
            self._rows[i]:show()
            -- icons shown by _refresh
        end
    end
    -- scroll indicator shown by _refresh if needed
end

function ScrollList:hide()
    self._visible = false
    for _, row in ipairs(self._rows) do
        row:hide()
    end
    for _, icon in pairs(self._row_icons) do
        icon:hide()
    end
    self._scroll_bg:hide()
    self._scroll_thumb:hide()
end

function ScrollList:visible()
    return self._visible
end

function ScrollList:destroy()
    clickables[self._id] = nil
    for _, row in ipairs(self._rows) do
        row:destroy()
    end
    for _, icon in pairs(self._row_icons) do
        icon:destroy()
    end
    self._row_icons = {}
    self._rows = {}
    self._scroll_bg:destroy()
    self._scroll_thumb:destroy()
end

---------------------------------------------------------------------------
-- QuestRowList widget — styled scrollable quest list with two-line rows
-- Each row: background strip, status indicator, quest name, NPC sub-text,
-- right-aligned status label. Hover highlights row, click navigates.
---------------------------------------------------------------------------
local QuestRowList = {}
QuestRowList.__index = QuestRowList

function widgets.QuestRowList(opts)
    local self = setmetatable({}, QuestRowList)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._width = opts.width or (theme.window_width - theme.padding * 2)
    self._visible_count = opts.visible_count or theme.quest_rows_per_page
    self._row_height = theme.quest_row_height
    self._row_gap = theme.quest_row_gap
    self._visible = false
    self._scroll_offset = 0
    self._items = {}
    self._hovered_row = nil
    self._prev_hovered_row = nil
    self._on_item_click = opts.on_item_click

    local total_row_h = self._row_height + self._row_gap
    local pad_x = theme.quest_row_padding_x
    local ind_size = theme.quest_row_indicator_size
    local ind_gap = theme.quest_row_indicator_gap
    local text_x = pad_x + ind_size + ind_gap

    self._rows = {}
    for i = 1, self._visible_count do
        local ry = self._y + (i - 1) * total_row_h
        local row = {}

        -- Background strip
        row.bg = images.new({
            pos = {x = self._x, y = ry},
            size = {width = self._width, height = self._row_height},
            color = {alpha = 0, red = 0, green = 0, blue = 0},
            texture = {fit = false},
            draggable = false,
        })

        -- Status icon indicator
        local iy = ry + math.floor((self._row_height - ind_size) / 2)
        row.indicator = images.new({
            pos = {x = self._x + pad_x, y = iy},
            size = {width = ind_size, height = ind_size},
            color = {alpha = 0, red = 255, green = 255, blue = 255},
            texture = {fit = false},
            draggable = false,
        })

        -- Quest name (bold, top line)
        row.name = texts.new('', {
            pos = {x = self._x + text_x, y = ry + theme.quest_row_name_y},
            bg = {alpha = 0, visible = false},
            text = {
                font = theme.font_name,
                size = theme.quest_row_name_size,
                alpha = theme.text.alpha,
                red = theme.text.red,
                green = theme.text.green,
                blue = theme.text.blue,
                stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
            },
            flags = {bold = true, draggable = false},
        })

        -- NPC sub-text (bottom line, brighter than dim for readability)
        row.sub = texts.new('', {
            pos = {x = self._x + text_x, y = ry + theme.quest_row_sub_y},
            bg = {alpha = 0, visible = false},
            text = {
                font = theme.font_label,
                size = theme.quest_row_sub_size,
                alpha = 220,
                red = 180,
                green = 195,
                blue = 220,
                stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
            },
            flags = {bold = false, draggable = false},
        })

        self._rows[i] = row
    end

    -- Scroll indicators
    local track_h = self._visible_count * total_row_h
    self._scroll_bg = images.new({
        pos = {x = self._x + self._width - theme.scroll_indicator_width, y = self._y},
        size = {width = theme.scroll_indicator_width, height = track_h},
        color = {alpha = theme.scroll.bg.alpha, red = theme.scroll.bg.red, green = theme.scroll.bg.green, blue = theme.scroll.bg.blue},
        texture = {fit = false},
        draggable = false,
    })

    self._scroll_thumb = images.new({
        pos = {x = self._x + self._width - theme.scroll_indicator_width, y = self._y},
        size = {width = theme.scroll_indicator_width, height = 20},
        color = {alpha = theme.scroll.thumb.alpha, red = theme.scroll.thumb.red, green = theme.scroll.thumb.green, blue = theme.scroll.thumb.blue},
        texture = {fit = false},
        draggable = false,
    })

    -- Click handler — dispatches to hovered row
    local me = self
    self.on_click = function()
        if me._hovered_row then
            local idx = me._scroll_offset + me._hovered_row
            if idx <= #me._items and me._on_item_click then
                me._on_item_click(me._items[idx], idx)
            end
        end
    end

    self._id = next_name('qrl')
    clickables[self._id] = self

    return self
end

function QuestRowList:set_items(items)
    self._items = items or {}
    self._scroll_offset = 0
    self:_refresh()
end

function QuestRowList:scroll_up()
    if self._scroll_offset > 0 then
        self._scroll_offset = self._scroll_offset - 1
        self:_refresh()
    end
end

function QuestRowList:scroll_down()
    local max_offset = math.max(0, #self._items - self._visible_count)
    if self._scroll_offset < max_offset then
        self._scroll_offset = self._scroll_offset + 1
        self:_refresh()
    end
end

function QuestRowList:hover(x, y)
    if not self._visible then return false end
    local total_row_h = self._row_height + self._row_gap
    local total_h = self._visible_count * total_row_h
    if x >= self._x and x <= self._x + self._width and y >= self._y and y < self._y + total_h then
        local rel_y = y - self._y
        local row_idx = math.floor(rel_y / total_row_h) + 1
        if row_idx >= 1 and row_idx <= self._visible_count then
            local row_top = (row_idx - 1) * total_row_h
            if rel_y - row_top < self._row_height then
                self._hovered_row = row_idx
            else
                self._hovered_row = nil
            end
        else
            self._hovered_row = nil
        end
        return true
    end
    self._hovered_row = nil
    return false
end

function QuestRowList:set_hovered(is_over)
    local new_row = is_over and self._hovered_row or nil
    local old_row = self._prev_hovered_row
    if new_row ~= old_row then
        self._prev_hovered_row = new_row
        if old_row then self:_update_row_bg(old_row) end
        if new_row then self:_update_row_bg(new_row) end
    end
end

function QuestRowList:_update_row_bg(row_idx)
    local row = self._rows[row_idx]
    if not row then return end
    local item_idx = self._scroll_offset + row_idx
    local item = self._items[item_idx]
    local bg
    if row_idx == self._hovered_row then
        bg = theme.quest_row.bg_hover
    elseif item and item.status == 'active' then
        bg = (row_idx % 2 == 1) and theme.quest_row.bg_active_even or theme.quest_row.bg_active_odd
    else
        bg = (row_idx % 2 == 1) and theme.quest_row.bg_even or theme.quest_row.bg_odd
    end
    row.bg:color(bg.red, bg.green, bg.blue)
    row.bg:alpha(bg.alpha)
end

function QuestRowList:_refresh()
    local total = #self._items
    local total_row_h = self._row_height + self._row_gap
    local pad_x = theme.quest_row_padding_x
    for i = 1, self._visible_count do
        local item_idx = self._scroll_offset + i
        local row = self._rows[i]

        if item_idx <= total then
            local item = self._items[item_idx]

            -- Background
            self:_update_row_bg(i)

            -- Indicator icon
            local ind_icon = STATUS_ICON[item.status]
            if ind_icon then
                local ic = theme.status[item.status] or theme.text_dim
                row.indicator:path(ind_icon)
                row.indicator:color(ic.red, ic.green, ic.blue)
                row.indicator:alpha(ic.alpha)
            else
                row.indicator:alpha(0)
            end

            -- Quest name — dimmer for completed/uncompletable
            row.name:text(item.name or '')
            if item.status == 'completed' or item.status == 'uncompletable' then
                row.name:color(theme.text_dim.red, theme.text_dim.green, theme.text_dim.blue)
            else
                row.name:color(theme.text.red, theme.text.green, theme.text.blue)
            end

            -- NPC sub-text
            row.sub:text(item.npc_info or '')

            if self._visible then
                row.bg:show()
                row.indicator:show()
                row.name:show()
                row.sub:show()
            end
        else
            row.bg:hide()
            row.indicator:hide()
            row.name:hide()
            row.sub:hide()
        end
    end

    -- Scroll indicator
    local max_offset = math.max(0, total - self._visible_count)
    if total > self._visible_count then
        local track_h = self._visible_count * total_row_h
        local thumb_h = math.max(theme.s(10), math.floor(track_h * self._visible_count / total))
        local thumb_y = self._y
        if max_offset > 0 then
            thumb_y = self._y + math.floor((track_h - thumb_h) * self._scroll_offset / max_offset)
        end
        self._scroll_thumb:size(theme.scroll_indicator_width, thumb_h)
        self._scroll_thumb:pos(self._x + self._width - theme.scroll_indicator_width, thumb_y)

        -- Store geometry for drag hit-testing
        self._track_x = self._x + self._width - theme.scroll_indicator_width
        self._track_y = self._y
        self._track_h = track_h
        self._thumb_y = thumb_y
        self._thumb_h = thumb_h
        self._scroll_active = true

        if self._visible then
            self._scroll_bg:show()
            self._scroll_thumb:show()
        end
    else
        self._scroll_bg:hide()
        self._scroll_thumb:hide()
        self._scroll_active = false
    end
end

function QuestRowList:scroll_to_offset(offset)
    local max_off = math.max(0, #self._items - self._visible_count)
    self._scroll_offset = math.max(0, math.min(max_off, offset))
    self:_refresh()
end

function QuestRowList:hover_scroll_thumb(x, y)
    if not self._visible or not self._scroll_active then return false end
    local pad = theme.s(6)
    return x >= self._track_x - pad and x <= self._track_x + theme.scroll_indicator_width + pad
       and y >= self._thumb_y and y <= self._thumb_y + self._thumb_h
end

function QuestRowList:hover_scroll_track(x, y)
    if not self._visible or not self._scroll_active then return false end
    local pad = theme.s(6)
    return x >= self._track_x - pad and x <= self._track_x + theme.scroll_indicator_width + pad
       and y >= self._track_y and y <= self._track_y + self._track_h
       and not self:hover_scroll_thumb(x, y)
end

function QuestRowList:pos(x, y)
    self._x = x
    self._y = y

    local total_row_h = self._row_height + self._row_gap
    local pad_x = theme.quest_row_padding_x
    local ind_size = theme.quest_row_indicator_size
    local ind_gap = theme.quest_row_indicator_gap
    local text_x = pad_x + ind_size + ind_gap

    for i, row in ipairs(self._rows) do
        local ry = y + (i - 1) * total_row_h
        row.bg:pos(x, ry)
        row.indicator:pos(x + pad_x, ry + math.floor((self._row_height - ind_size) / 2))
        row.name:pos(x + text_x, ry + theme.quest_row_name_y)
        row.sub:pos(x + text_x, ry + theme.quest_row_sub_y)
        -- status pos updated in _refresh (right-aligned)
    end

    self._scroll_bg:pos(x + self._width - theme.scroll_indicator_width, y)
    self:_refresh()
end

function QuestRowList:show()
    self._visible = true
    self:_refresh()
end

function QuestRowList:hide()
    self._visible = false
    self._hovered_row = nil
    self._prev_hovered_row = nil
    for _, row in ipairs(self._rows) do
        row.bg:hide()
        row.indicator:hide()
        row.name:hide()
        row.sub:hide()
    end
    self._scroll_bg:hide()
    self._scroll_thumb:hide()
end

function QuestRowList:visible()
    return self._visible
end

function QuestRowList:destroy()
    clickables[self._id] = nil
    for _, row in ipairs(self._rows) do
        row.bg:destroy()
        row.indicator:destroy()
        row.name:destroy()
        row.sub:destroy()
    end
    self._rows = {}
    self._scroll_bg:destroy()
    self._scroll_thumb:destroy()
end

---------------------------------------------------------------------------
-- Breadcrumb widget — clickable path navigation
---------------------------------------------------------------------------
local Breadcrumb = {}
Breadcrumb.__index = Breadcrumb

function widgets.Breadcrumb(opts)
    local self = setmetatable({}, Breadcrumb)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._visible = false
    self._segments = {}  -- {text, on_click} per segment
    self._buttons = {}   -- Button/Image widgets
    self._widths = {}    -- pixel width per element (for repositioning)

    return self
end

function Breadcrumb:set_path(segments)
    -- segments = {{text='Chronicle', on_click=fn}, {text='Quests', on_click=fn}, ...}
    -- Destroy old buttons
    for _, btn in ipairs(self._buttons) do
        btn:destroy()
    end
    self._buttons = {}
    self._widths = {}
    self._segments = segments or {}

    -- Build the breadcrumb string as individual buttons + icon separators
    local x_offset = self._x
    local sep_icon_size = theme.s(16)
    for i, seg in ipairs(self._segments) do
        local is_last = (i == #self._segments)

        local btn = widgets.Button({
            x = x_offset,
            y = self._y,
            text = seg.text,
            size = theme.font_size,
            color = is_last and theme.breadcrumb.active or theme.breadcrumb.text,
            hover_color = is_last and theme.breadcrumb.active or theme.breadcrumb.text_hover,
            bg_color = {alpha = 0, red = 0, green = 0, blue = 0},
            bg_hover_color = is_last and {alpha = 0, red = 0, green = 0, blue = 0} or theme.button.hover,
            padding = 1,
            on_click = not is_last and seg.on_click or nil,
        })

        if self._visible then btn:show() end
        table.insert(self._buttons, btn)

        -- Estimate width from string length (extents() returns 0 before first render)
        local w = self:_estimate_width(seg.text)
        table.insert(self._widths, w)
        x_offset = x_offset + w

        if not is_last then
            local sep_gap = theme.s(8)
            x_offset = x_offset + sep_gap

            local sep = widgets.Image({
                x = x_offset,
                y = self._y + theme.s(3),
                width = sep_icon_size,
                height = sep_icon_size,
                path = BREADCRUMB_ICON,
                red = theme.text_dim.red,
                green = theme.text_dim.green,
                blue = theme.text_dim.blue,
                alpha = theme.text_dim.alpha,
            })
            if self._visible then sep:show() end
            table.insert(self._buttons, sep)
            table.insert(self._widths, sep_icon_size)

            x_offset = x_offset + sep_icon_size + sep_gap
        end
    end
end

-- Estimate text width in pixels from string length
function Breadcrumb:_estimate_width(str)
    return math.floor(#str * theme.breadcrumb_char_width) + theme.s(4)
end

function Breadcrumb:pos(x, y)
    self._x = x
    self._y = y
    -- Reposition all elements using stored widths
    local x_offset = x
    local sep_gap = theme.s(8)
    local sep_icon_size = theme.s(16)
    for i, element in ipairs(self._buttons) do
        local is_sep = (i % 2 == 0)
        if is_sep then
            element:pos(x_offset, y + theme.s(3))
        else
            element:pos(x_offset, y)
        end
        local w = self._widths[i] or 0
        x_offset = x_offset + w + sep_gap
    end
end

function Breadcrumb:show()
    self._visible = true
    for _, btn in ipairs(self._buttons) do
        btn:show()
    end
end

function Breadcrumb:hide()
    self._visible = false
    for _, btn in ipairs(self._buttons) do
        btn:hide()
    end
end

function Breadcrumb:visible()
    return self._visible
end

function Breadcrumb:destroy()
    for _, btn in ipairs(self._buttons) do
        btn:destroy()
    end
    self._buttons = {}
    self._segments = {}
end

---------------------------------------------------------------------------
-- Panel widget — container with title bar, background, drag, collapse/close
---------------------------------------------------------------------------
local Panel = {}
Panel.__index = Panel

function widgets.Panel(opts)
    local self = setmetatable({}, Panel)
    opts = opts or {}

    self._x = opts.x or 100
    self._y = opts.y or 100
    self._width = opts.width or theme.window_width
    self._content_height = opts.height or 200
    self._visible = false
    self._collapsed = opts.collapsed or false
    self._title_text = opts.title or 'Panel'
    self._children = {}

    self.on_collapse = opts.on_collapse
    self.on_close = opts.on_close

    -- Title bar background
    self._title_bg = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = self._width, height = theme.title_height},
        color = {
            alpha = theme.title_bg.alpha,
            red = theme.title_bg.red,
            green = theme.title_bg.green,
            blue = theme.title_bg.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Title text
    self._title_label = widgets.Label({
        x = self._x + theme.padding,
        y = self._y + theme.s(2),
        text = self._title_text,
        font = opts.title_font,
        size = opts.title_size or theme.title_size,
        color = theme.text_bright,
        bold = true,
    })

    -- Icon paths for collapse/expand
    local asset_path = windower.addon_path .. 'assets/'
    self._chevron_down_path = asset_path .. 'collapse.png'
    self._chevron_up_path = asset_path .. 'expand.png'

    -- Collapse button (image)
    local icon_size = theme.s(14)
    local icon_y_offset = math.floor((theme.title_height - icon_size) / 2)
    self._collapse_btn = widgets.ImageButton({
        x = self._x + self._width - theme.s(38),
        y = self._y + icon_y_offset,
        width = icon_size,
        height = icon_size,
        path = self._collapsed and self._chevron_up_path or self._chevron_down_path,
        on_click = function()
            self:toggle_collapse()
        end,
    })

    -- Close button (image)
    self._close_btn = widgets.ImageButton({
        x = self._x + self._width - theme.s(20),
        y = self._y + icon_y_offset,
        width = icon_size,
        height = icon_size,
        path = asset_path .. 'close.png',
        on_click = function()
            self:hide()
            if self.on_close then self.on_close() end
        end,
    })

    -- Content background
    self._content_bg = images.new({
        pos = {x = self._x, y = self._y + theme.title_height},
        size = {width = self._width, height = self._content_height},
        color = {
            alpha = theme.bg.alpha,
            red = theme.bg.red,
            green = theme.bg.green,
            blue = theme.bg.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Register panel for drag via title bar
    self._id = next_name('panel')
    clickables[self._id] = self

    active_panel = self

    return self
end

function Panel:title(text)
    if text then
        self._title_text = text
        self._title_label:text(text)
    end
    return self._title_text
end

function Panel:content_height(h)
    if h then
        self._content_height = h
        self._content_bg:size(self._width, h)
    end
    return self._content_height
end

function Panel:content_top()
    return self._y + theme.title_height + theme.padding
end

function Panel:content_left()
    return self._x + theme.padding
end

function Panel:width()
    return self._width
end

function Panel:content_width()
    return self._width - theme.padding * 2
end

function Panel:get_pos()
    return self._x, self._y
end

function Panel:pos(x, y)
    local dx = x - self._x
    local dy = y - self._y
    self._x = x
    self._y = y

    self._title_bg:pos(x, y)
    self._title_label:pos(x + theme.padding, y + theme.s(2))
    local icon_size = theme.s(14)
    local icon_y_offset = math.floor((theme.title_height - icon_size) / 2)
    self._collapse_btn:pos(x + self._width - theme.s(38), y + icon_y_offset)
    self._close_btn:pos(x + self._width - theme.s(20), y + icon_y_offset)
    self._content_bg:pos(x, y + theme.title_height)

    -- Move children
    for _, child in ipairs(self._children) do
        if child.widget and child.widget.pos then
            local cx, cy = child.offset_x + x, child.offset_y + y
            child.widget:pos(cx, cy)
        end
    end
end

function Panel:add_child(widget, offset_x, offset_y)
    table.insert(self._children, {
        widget = widget,
        offset_x = offset_x or 0,
        offset_y = offset_y or 0,
    })
    widget:pos(self._x + (offset_x or 0), self._y + (offset_y or 0))
end

function Panel:clear_children()
    for _, child in ipairs(self._children) do
        if child.widget.destroy then
            child.widget:destroy()
        end
    end
    self._children = {}
end

function Panel:toggle_collapse()
    self._collapsed = not self._collapsed
    self._collapse_btn:path(self._collapsed and self._chevron_up_path or self._chevron_down_path)

    if self._collapsed then
        self._content_bg:hide()
        for _, child in ipairs(self._children) do
            if child.widget.hide then child.widget:hide() end
        end
    else
        self._content_bg:show()
        for _, child in ipairs(self._children) do
            if child.widget.show then child.widget:show() end
        end
    end

    if self.on_collapse then self.on_collapse(self._collapsed) end
end

function Panel:is_collapsed()
    return self._collapsed
end

function Panel:hover_title(x, y)
    if not self._visible then return false end
    return self._title_bg:hover(x, y)
end

-- Hit test over entire panel area (title bar + content)
function Panel:hover(x, y)
    if not self._visible then return false end
    local total_height = theme.title_height
    if not self._collapsed then
        total_height = total_height + self._content_height
    end
    return x >= self._x and x <= self._x + self._width
       and y >= self._y and y <= self._y + total_height
end

function Panel:show()
    self._visible = true
    self._title_bg:show()
    self._title_label:show()
    self._collapse_btn:show()
    self._close_btn:show()

    if not self._collapsed then
        self._content_bg:show()
        for _, child in ipairs(self._children) do
            if child.widget.show then child.widget:show() end
        end
    end
end

function Panel:hide()
    self._visible = false
    self._title_bg:hide()
    self._title_label:hide()
    self._collapse_btn:hide()
    self._close_btn:hide()
    self._content_bg:hide()

    for _, child in ipairs(self._children) do
        if child.widget.hide then child.widget:hide() end
    end
end

function Panel:visible()
    return self._visible
end

function Panel:destroy()
    if active_panel == self then active_panel = nil end
    clickables[self._id] = nil
    self._title_bg:destroy()
    self._title_label:destroy()
    self._collapse_btn:destroy()
    self._close_btn:destroy()
    self._content_bg:destroy()
    self:clear_children()
end

---------------------------------------------------------------------------
-- Card widget — bordered card with area name, count, percentage, bar
---------------------------------------------------------------------------
local Card = {}
Card.__index = Card

function widgets.Card(opts)
    local self = setmetatable({}, Card)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._width = opts.width or 238
    self._height = opts.height or theme.card_height
    self._visible = false
    self._hovered = false
    self.on_click = opts.on_click

    local pad = theme.card_padding
    local card_bg = theme.card.bg
    local card_border = theme.card.border

    -- Content left offset: shifts text/bar right when emblem is present
    local emblem_inset = opts.emblem and (self._height + 1) or 0
    self._emblem_inset = emblem_inset

    -- Border layer (1px larger on each side, rendered first = behind)
    self._border = images.new({
        pos = {x = self._x - 1, y = self._y - 1},
        size = {width = self._width + 2, height = self._height + 2},
        color = {
            alpha = card_border.alpha,
            red = card_border.red,
            green = card_border.green,
            blue = card_border.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Background layer
    self._bg = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = self._width, height = self._height},
        color = {
            alpha = card_bg.alpha,
            red = card_bg.red,
            green = card_bg.green,
            blue = card_bg.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Emblem background image (centered, faded)
    self._emblem = nil
    if opts.emblem then
        local emblem_h = self._height
        local emblem_w = emblem_h  -- square source -> square display
        local emblem_x = self._x
        local emblem_y = self._y
        self._emblem = images.new({
            pos = {x = emblem_x, y = emblem_y},
            size = {width = emblem_w, height = emblem_h},
            color = {alpha = 135, red = 255, green = 255, blue = 255},
            texture = {fit = false, path = opts.emblem},
            draggable = false,
        })
    end

    -- Area name (top-left, after emblem)
    local content_x = self._x + pad + emblem_inset
    self._name = texts.new(opts.name or '', {
        pos = {x = content_x, y = self._y + pad - theme.s(2)},
        bg = {alpha = 0, visible = false},
        text = {
            font = theme.font_name,
            size = theme.card_name_size,
            alpha = theme.text.alpha,
            red = theme.text.red,
            green = theme.text.green,
            blue = theme.text.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {bold = true, draggable = false},
    })

    -- Sub-label (e.g. "23 / 82 QUESTS")
    local sub_y = self._y + pad + theme.card_sub_y_offset
    self._sub = texts.new(opts.sub_text or '', {
        pos = {x = content_x, y = sub_y},
        bg = {alpha = 0, visible = false},
        text = {
            font = theme.font_label,
            size = theme.card_sub_size,
            alpha = theme.text_dim.alpha,
            red = theme.text_dim.red,
            green = theme.text_dim.green,
            blue = theme.text_dim.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {bold = false, draggable = false},
    })

    -- Percentage (right-aligned on sub line)
    local pct_color = opts.pct_color or theme.accent
    local pct_str = opts.pct_text or ''
    self._pct_width = math.max(theme.s(20), #pct_str * theme.s(6))
    self._pct = texts.new(pct_str, {
        pos = {x = self._x + self._width - pad - self._pct_width, y = sub_y},
        bg = {alpha = 0, visible = false},
        text = {
            font = theme.font_label,
            size = theme.card_pct_size,
            alpha = pct_color.alpha,
            red = pct_color.red,
            green = pct_color.green,
            blue = pct_color.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {bold = true, draggable = false},
    })

    -- Completion star icon (shown left of percentage for 100% cards)
    self._star = nil
    self._star_size = theme.s(16)
    if opts.complete_star then
        local ss = self._star_size
        local star_x = self._x + self._width - pad - self._pct_width - ss - theme.s(1)
        local star_y = sub_y + math.floor((theme.card_pct_size - ss) / 2) + theme.s(3)
        self._star = images.new({
            pos = {x = star_x, y = star_y},
            size = {width = ss, height = ss},
            color = {alpha = 255, red = 255, green = 255, blue = 255},
            texture = {fit = false, path = opts.complete_star},
            draggable = false,
        })
    end

    -- Progress bar track
    local bar_y = self._y + self._height - theme.card_bar_height - theme.card_bar_bottom_offset
    local bar_width = self._width - pad * 2 - emblem_inset
    self._bar_bg = images.new({
        pos = {x = content_x, y = bar_y},
        size = {width = bar_width, height = theme.card_bar_height},
        color = {
            alpha = theme.bar.bg.alpha,
            red = theme.bar.bg.red,
            green = theme.bar.bg.green,
            blue = theme.bar.bg.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    -- Progress bar fill
    local completed = opts.completed or 0
    local total = math.max(1, opts.total or 1)
    local fill_pct = completed / total
    local fill_width = math.max(0, math.floor(bar_width * fill_pct))
    local fill_color = opts.fill_color or theme.bar.fill_default
    self._fill_color = fill_color
    self._bar_fill = images.new({
        pos = {x = content_x, y = bar_y},
        size = {width = fill_width, height = theme.card_bar_height},
        color = {
            alpha = fill_color.alpha,
            red = fill_color.red,
            green = fill_color.green,
            blue = fill_color.blue,
        },
        texture = {fit = false},
        draggable = false,
    })

    self._id = next_name('card')
    clickables[self._id] = self

    return self
end

function Card:pos(x, y)
    self._x = x
    self._y = y
    local pad = theme.card_padding

    self._border:pos(x - 1, y - 1)
    self._bg:pos(x, y)
    if self._emblem then
        self._emblem:pos(x, y)
    end
    local cx = x + pad + self._emblem_inset
    self._name:pos(cx, y + pad - theme.s(2))
    local sub_y = y + pad + theme.card_sub_y_offset
    self._sub:pos(cx, sub_y)
    self._pct:pos(x + self._width - pad - self._pct_width, sub_y)
    if self._star then
        local ss = self._star_size
        self._star:pos(x + self._width - pad - self._pct_width - ss - theme.s(1), sub_y + math.floor((theme.card_pct_size - ss) / 2) + theme.s(3))
    end

    local bar_y = y + self._height - theme.card_bar_height - theme.card_bar_bottom_offset
    self._bar_bg:pos(cx, bar_y)
    self._bar_fill:pos(cx, bar_y)
end

function Card:hover(x, y)
    if not self._visible then return false end
    return x >= self._x and x <= self._x + self._width
       and y >= self._y and y <= self._y + self._height
end

function Card:set_hovered(is_hovered)
    if is_hovered == self._hovered then return end
    self._hovered = is_hovered
    if is_hovered then
        local h = theme.card.bg_hover
        self._bg:color(h.red, h.green, h.blue)
        self._bg:alpha(h.alpha)
        local bh = theme.card.border_hover
        self._border:color(bh.red, bh.green, bh.blue)
        self._border:alpha(bh.alpha)
    else
        local n = theme.card.bg
        self._bg:color(n.red, n.green, n.blue)
        self._bg:alpha(n.alpha)
        local bn = theme.card.border
        self._border:color(bn.red, bn.green, bn.blue)
        self._border:alpha(bn.alpha)
    end
end

function Card:show()
    self._visible = true
    self._border:show()
    self._bg:show()
    if self._emblem then self._emblem:show() end
    self._name:show()
    self._sub:show()
    self._pct:show()
    if self._star then self._star:show() end
    self._bar_bg:show()
    self._bar_fill:show()
end

function Card:hide()
    self._visible = false
    self._hovered = false
    self._border:hide()
    self._bg:hide()
    if self._emblem then self._emblem:hide() end
    self._name:hide()
    self._sub:hide()
    self._pct:hide()
    if self._star then self._star:hide() end
    self._bar_bg:hide()
    self._bar_fill:hide()
end

function Card:visible()
    return self._visible
end

function Card:destroy()
    clickables[self._id] = nil
    self._border:destroy()
    self._bg:destroy()
    if self._emblem then self._emblem:destroy() end
    self._name:destroy()
    self._sub:destroy()
    self._pct:destroy()
    if self._star then self._star:destroy() end
    self._bar_bg:destroy()
    self._bar_fill:destroy()
end

---------------------------------------------------------------------------
-- ToolbarButton widget — cycles through options on click
---------------------------------------------------------------------------
local ToolbarButton = {}
ToolbarButton.__index = ToolbarButton

function widgets.ToolbarButton(opts)
    local self = setmetatable({}, ToolbarButton)
    opts = opts or {}

    self._label = opts.label or ''
    self._options = opts.options or {'Default'}
    self._index = opts.index or 1
    self._on_change = opts.on_change
    self._visible = false
    self._hovered = false

    local tc = theme.button.text
    local hc = theme.button.text_hover
    local bgc = theme.button.normal
    local bhc = theme.button.hover

    self._normal_color = {r = tc.red, g = tc.green, b = tc.blue}
    self._hover_color = {r = hc.red, g = hc.green, b = hc.blue}
    self._normal_bg = {a = bgc.alpha, r = bgc.red, g = bgc.green, b = bgc.blue}
    self._hover_bg = {a = bhc.alpha, r = bhc.red, g = bhc.green, b = bhc.blue}

    self._text = texts.new(self:_display_text(), {
        pos = {x = opts.x or 0, y = opts.y or 0},
        bg = {
            alpha = bgc.alpha,
            red = bgc.red,
            green = bgc.green,
            blue = bgc.blue,
            visible = true,
        },
        text = {
            font = opts.font or theme.font_name,
            size = opts.size or theme.toolbar_button_size,
            alpha = tc.alpha or 255,
            red = tc.red,
            green = tc.green,
            blue = tc.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {bold = true, draggable = false},
        padding = 3,
    })

    local me = self
    self.on_click = function()
        me._index = (me._index % #me._options) + 1
        me._text:text(me:_display_text())
        if me._on_change then
            me._on_change(me._index, me._options[me._index])
        end
    end

    self._id = next_name('tbb')
    clickables[self._id] = self
    return self
end

function ToolbarButton:_display_text()
    return self._label .. ': ' .. self._options[self._index]
end

function ToolbarButton:index()
    return self._index
end

function ToolbarButton:pos(x, y)
    self._text:pos(x, y)
end

function ToolbarButton:extents()
    return self._text:extents()
end

function ToolbarButton:hover(x, y)
    return self._visible and self._text:hover(x, y)
end

function ToolbarButton:set_hovered(is_hovered)
    if is_hovered == self._hovered then return end
    self._hovered = is_hovered
    if is_hovered then
        self._text:color(self._hover_color.r, self._hover_color.g, self._hover_color.b)
        self._text:bg_alpha(self._hover_bg.a)
        self._text:bg_color(self._hover_bg.r, self._hover_bg.g, self._hover_bg.b)
    else
        self._text:color(self._normal_color.r, self._normal_color.g, self._normal_color.b)
        self._text:bg_alpha(self._normal_bg.a)
        self._text:bg_color(self._normal_bg.r, self._normal_bg.g, self._normal_bg.b)
    end
end

function ToolbarButton:show()
    self._visible = true
    self._text:show()
end

function ToolbarButton:hide()
    self._visible = false
    self._hovered = false
    self._text:hide()
end

function ToolbarButton:visible()
    return self._visible
end

function ToolbarButton:destroy()
    clickables[self._id] = nil
    self._text:destroy()
end

---------------------------------------------------------------------------
-- TextInput widget — click-to-focus text field with keyboard capture
---------------------------------------------------------------------------
local TextInput = {}
TextInput.__index = TextInput

-- Minimal DIK-to-character map (DirectInput key codes)
local dik_chars = {
    [0x02] = '1', [0x03] = '2', [0x04] = '3', [0x05] = '4', [0x06] = '5',
    [0x07] = '6', [0x08] = '7', [0x09] = '8', [0x0A] = '9', [0x0B] = '0',
    [0x0C] = '-', [0x0D] = '=',
    [0x10] = 'q', [0x11] = 'w', [0x12] = 'e', [0x13] = 'r', [0x14] = 't',
    [0x15] = 'y', [0x16] = 'u', [0x17] = 'i', [0x18] = 'o', [0x19] = 'p',
    [0x1A] = '[', [0x1B] = ']',
    [0x1E] = 'a', [0x1F] = 's', [0x20] = 'd', [0x21] = 'f', [0x22] = 'g',
    [0x23] = 'h', [0x24] = 'j', [0x25] = 'k', [0x26] = 'l',
    [0x27] = ';', [0x28] = "'",
    [0x2C] = 'z', [0x2D] = 'x', [0x2E] = 'c', [0x2F] = 'v', [0x30] = 'b',
    [0x31] = 'n', [0x32] = 'm',
    [0x33] = ',', [0x34] = '.', [0x35] = '/',
    [0x39] = ' ',
    [0x29] = '`', [0x2B] = '\\',
}
local dik_shift = {
    [0x02] = '!', [0x03] = '@', [0x04] = '#', [0x05] = '$', [0x06] = '%',
    [0x07] = '^', [0x08] = '&', [0x09] = '*', [0x0A] = '(', [0x0B] = ')',
    [0x0C] = '_', [0x0D] = '+',
    [0x1A] = '{', [0x1B] = '}',
    [0x27] = ':', [0x28] = '"',
    [0x33] = '<', [0x34] = '>', [0x35] = '?',
    [0x29] = '~', [0x2B] = '|',
}

-- Module-level focus tracking
local focused_input = nil
local shift_down = false

function widgets.TextInput(opts)
    local self = setmetatable({}, TextInput)
    opts = opts or {}

    self._x = opts.x or 0
    self._y = opts.y or 0
    self._width = opts.width or theme.toolbar_input_width
    self._height = opts.height or theme.toolbar_height
    self._placeholder = opts.placeholder or 'Search...'
    self._value = ''
    self._focused = false
    self._visible = false
    self._on_change = opts.on_change
    self._on_blur = opts.on_blur
    self._cursor_frame = 0

    -- Background rectangle
    local bgc = theme.toolbar.input_bg
    self._bg = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = self._width, height = self._height},
        color = {alpha = bgc.alpha, red = bgc.red, green = bgc.green, blue = bgc.blue},
        texture = {fit = false},
        draggable = false,
    })

    -- Border highlight (shown when focused)
    local bc = theme.toolbar.input_border_focus
    self._border_top = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = self._width, height = 1},
        color = {alpha = bc.alpha, red = bc.red, green = bc.green, blue = bc.blue},
        texture = {fit = false},
        draggable = false,
    })
    self._border_bottom = images.new({
        pos = {x = self._x, y = self._y + self._height - 1},
        size = {width = self._width, height = 1},
        color = {alpha = bc.alpha, red = bc.red, green = bc.green, blue = bc.blue},
        texture = {fit = false},
        draggable = false,
    })
    self._border_left = images.new({
        pos = {x = self._x, y = self._y},
        size = {width = 1, height = self._height},
        color = {alpha = bc.alpha, red = bc.red, green = bc.green, blue = bc.blue},
        texture = {fit = false},
        draggable = false,
    })
    self._border_right = images.new({
        pos = {x = self._x + self._width - 1, y = self._y},
        size = {width = 1, height = self._height},
        color = {alpha = bc.alpha, red = bc.red, green = bc.green, blue = bc.blue},
        texture = {fit = false},
        draggable = false,
    })

    -- Text display
    local pc = theme.toolbar.placeholder
    self._text = texts.new(self._placeholder, {
        pos = {x = self._x + 4, y = self._y + 2},
        bg = {alpha = 0, visible = false},
        text = {
            font = theme.font_name,
            size = theme.toolbar_input_size,
            alpha = pc.alpha,
            red = pc.red,
            green = pc.green,
            blue = pc.blue,
            stroke = {width = 0, alpha = 0, red = 0, green = 0, blue = 0},
        },
        flags = {bold = false, draggable = false},
    })

    local me = self
    self.on_click = function()
        me:focus()
    end

    self._id = next_name('tin')
    clickables[self._id] = self
    return self
end

function TextInput:focus()
    if self._focused then return end
    self._focused = true
    self._cursor_frame = 0
    focused_input = self
    -- Update background to focused style
    local bgc = theme.toolbar.input_bg_focus
    self._bg:color(bgc.red, bgc.green, bgc.blue)
    self._bg:alpha(bgc.alpha)
    -- Show border
    if self._visible then
        self._border_top:show()
        self._border_bottom:show()
        self._border_left:show()
        self._border_right:show()
    end
    -- Update display
    self:_update_display()
end

function TextInput:blur()
    if not self._focused then return end
    self._focused = false
    if focused_input == self then
        focused_input = nil
    end
    -- Restore normal background
    local bgc = theme.toolbar.input_bg
    self._bg:color(bgc.red, bgc.green, bgc.blue)
    self._bg:alpha(bgc.alpha)
    -- Hide border
    self._border_top:hide()
    self._border_bottom:hide()
    self._border_left:hide()
    self._border_right:hide()
    -- Update display (remove cursor)
    self:_update_display()
    -- Notify listener
    if self._on_blur then
        self._on_blur()
    end
end

function TextInput:text()
    return self._value
end

function TextInput:clear()
    self._value = ''
    self:_update_display()
    if self._on_change then
        self._on_change(self._value)
    end
end

function TextInput:_update_display()
    if #self._value == 0 and not self._focused then
        -- Show placeholder
        local pc = theme.toolbar.placeholder
        self._text:color(pc.red, pc.green, pc.blue)
        self._text:alpha(pc.alpha)
        self._text:text(self._placeholder)
    else
        -- Show value with optional cursor
        local tc = theme.text
        self._text:color(tc.red, tc.green, tc.blue)
        self._text:alpha(tc.alpha)
        local display = self._value
        if self._focused then
            -- Blinking cursor based on frame counter
            if math.floor(self._cursor_frame / 30) % 2 == 0 then
                display = display .. '|'
            end
        end
        self._text:text(display)
    end
end

function TextInput:tick()
    if self._focused then
        local old_blink = math.floor(self._cursor_frame / 30) % 2
        self._cursor_frame = self._cursor_frame + 1
        local new_blink = math.floor(self._cursor_frame / 30) % 2
        if old_blink ~= new_blink then
            self:_update_display()
        end
    end
end

function TextInput:hover(x, y)
    if not self._visible then return false end
    local px, py = self._bg:pos()
    local w = self._width
    local h = self._height
    return x >= px and x < px + w and y >= py and y < py + h
end

function TextInput:set_hovered(is_hovered)
    -- No visual hover state for text input (focus is the active state)
end

function TextInput:pos(x, y)
    self._x = x
    self._y = y
    self._bg:pos(x, y)
    self._border_top:pos(x, y)
    self._border_bottom:pos(x, y + self._height - 1)
    self._border_left:pos(x, y)
    self._border_right:pos(x + self._width - 1, y)
    self._text:pos(x + 4, y + 2)
end

function TextInput:show()
    self._visible = true
    self._bg:show()
    self._text:show()
    if self._focused then
        self._border_top:show()
        self._border_bottom:show()
        self._border_left:show()
        self._border_right:show()
    end
end

function TextInput:hide()
    self._visible = false
    self._bg:hide()
    self._text:hide()
    self._border_top:hide()
    self._border_bottom:hide()
    self._border_left:hide()
    self._border_right:hide()
end

function TextInput:visible()
    return self._visible
end

function TextInput:destroy()
    if self._focused then
        -- Suppress on_blur callback during destroy to avoid clobbering state
        self._on_blur = nil
        self:blur()
    end
    clickables[self._id] = nil
    self._bg:destroy()
    self._border_top:destroy()
    self._border_bottom:destroy()
    self._border_left:destroy()
    self._border_right:destroy()
    self._text:destroy()
end

---------------------------------------------------------------------------
-- TabBar widget — horizontal tab selector with underline indicator
---------------------------------------------------------------------------
local TabBar = {}
TabBar.__index = TabBar

function widgets.TabBar(opts)
    local self = setmetatable({}, TabBar)
    self._x = opts.x or 0
    self._y = opts.y or 0
    self._tabs = opts.tabs or {}
    self._active = opts.active or 1
    self._on_change = opts.on_change
    self._buttons = {}
    self._underline = nil
    self._height = theme.tab_height

    -- Build color tables with rgba keys matching Button's expected format
    local active_color = {red = theme.accent.red, green = theme.accent.green, blue = theme.accent.blue, alpha = 255}
    local inactive_color = {red = theme.text_dim.red, green = theme.text_dim.green, blue = theme.text_dim.blue, alpha = 255}
    local transparent_bg = {alpha = 0, red = 0, green = 0, blue = 0}

    -- Create tab buttons — positioned at 0,0 since Panel:add_child handles offsets
    -- We track logical positions for underline placement
    local cx = 0
    local tab_positions = {}  -- {x, width} per tab
    for i, tab_label in ipairs(self._tabs) do
        local is_active = (i == self._active)
        local btn = widgets.Button({
            x = 0, y = 0,
            text = tab_label:upper(),
            size = theme.tab_font_size,
            font = theme.font_label,
            color = is_active and active_color or inactive_color,
            hover_color = active_color,
            bg_color = transparent_bg,
            bg_hover_color = transparent_bg,
            bold = true,
            on_click = function()
                if i ~= self._active and self._on_change then
                    self._on_change(i)
                end
            end,
        })
        -- Estimate rendered width from character count (extents() unreliable before show)
        local text_upper = tab_label:upper()
        local btn_padding = 2
        local text_w = #text_upper * theme.tab_font_size * 0.65
        local est_w = text_w + btn_padding * 2 + 4
        table.insert(tab_positions, {x = cx, width = est_w, underline_x = cx + btn_padding, underline_w = text_w})
        table.insert(self._buttons, btn)
        cx = cx + est_w + theme.tab_gap
    end

    self._tab_positions = tab_positions

    -- Create underline indicator under active tab
    local active_pos = tab_positions[self._active]
    if active_pos then
        self._underline = images.new({
            pos = {x = 0, y = 0},
            size = {width = active_pos.underline_w + theme.tab_font_size * 0.65, height = theme.tab_underline_height},
            color = {
                alpha = 255,
                red = theme.accent.red,
                green = theme.accent.green,
                blue = theme.accent.blue,
            },
            texture = {fit = false},
            draggable = false,
        })
    end

    return self
end

function TabBar:height()
    return self._height
end

-- TabBar is added as a panel child; the panel calls pos() with absolute coords
-- We position each button and the underline relative to those coords
function TabBar:pos(x, y)
    self._x = x
    self._y = y
    for i, btn in ipairs(self._buttons) do
        local tp = self._tab_positions[i]
        btn:pos(x + tp.x, y)
    end
    if self._underline then
        local active_pos = self._tab_positions[self._active]
        if active_pos then
            self._underline:pos(x + active_pos.underline_x, y + theme.tab_font_size + 10)
        end
    end
end

function TabBar:show()
    self._visible = true
    for _, btn in ipairs(self._buttons) do btn:show() end
    if self._underline then self._underline:show() end
end

function TabBar:hide()
    self._visible = false
    for _, btn in ipairs(self._buttons) do btn:hide() end
    if self._underline then self._underline:hide() end
end

function TabBar:visible()
    return self._visible or false
end

function TabBar:destroy()
    for _, btn in ipairs(self._buttons) do btn:destroy() end
    if self._underline then self._underline:destroy() end
    self._buttons = {}
end

---------------------------------------------------------------------------
-- Keyboard handler — called from global keyboard event
function widgets.handle_keyboard(dik, down, flags, blocked)
    -- Track shift state globally
    if dik == 0x2A or dik == 0x36 then
        shift_down = down
        if focused_input then return true end
        if blocked then return false end
        return false
    end

    -- When our input is focused, process keystrokes even if another addon
    -- blocked them — the user explicitly clicked our search field.
    if not focused_input then
        if blocked then return false end
        return false
    end
    if not down then return true end  -- block key-up while focused

    -- Escape: blur first (updates focus state), then clear (triggers re-render)
    if dik == 0x01 then
        local input = focused_input
        input:blur()
        if #input._value > 0 then
            input:clear()
        end
        return true
    end

    -- Backspace: delete last character
    if dik == 0x0E then
        if #focused_input._value > 0 then
            -- Handle multi-byte if needed, but quest names are ASCII
            focused_input._value = focused_input._value:sub(1, -2)
            focused_input:_update_display()
            if focused_input._on_change then
                focused_input._on_change(focused_input._value)
            end
        end
        return true
    end

    -- Character input
    local ch = nil
    if shift_down then
        -- Shift letters = uppercase
        if dik_chars[dik] and dik_chars[dik]:match('%a') then
            ch = dik_chars[dik]:upper()
        else
            ch = dik_shift[dik]
        end
    else
        ch = dik_chars[dik]
    end

    if ch then
        focused_input._value = focused_input._value .. ch
        focused_input:_update_display()
        if focused_input._on_change then
            focused_input._on_change(focused_input._value)
        end
        return true
    end

    -- Block all other keys while focused (prevent game input)
    return true
end

-- Tick all visible text inputs (cursor blink)
function widgets.tick_inputs()
    if focused_input and focused_input._visible then
        focused_input:tick()
    end
end

---------------------------------------------------------------------------
-- Global mouse event handler
---------------------------------------------------------------------------
local scrollbar_drag = nil  -- {widget, offset_y}

-- Check if mouse is over any visible panel (blocks game input)
local function over_any_panel(x, y)
    if active_panel and active_panel._visible and active_panel:hover(x, y) then
        return true
    end
    return false
end

windower.register_event('mouse', function(type, x, y, delta, blocked)
    if blocked then return end

    -- Mouse move — update hover states
    if type == 0 then

        -- Handle scrollbar dragging
        if scrollbar_drag then
            local w = scrollbar_drag.widget
            local new_thumb_y = y - scrollbar_drag.offset_y
            -- Clamp thumb to track bounds
            local min_y = w._track_y
            local max_y = w._track_y + w._track_h - w._thumb_h
            new_thumb_y = math.max(min_y, math.min(max_y, new_thumb_y))
            -- Convert thumb position to scroll offset
            local range = max_y - min_y
            if range > 0 then
                local ratio = (new_thumb_y - min_y) / range
                local max_offset = math.max(0, #w._items - w._visible_count)
                local new_offset = math.floor(ratio * max_offset + 0.5)
                w:scroll_to_offset(new_offset)
            end
            return true
        end

        -- Handle panel dragging
        if drag_state then
            drag_state.panel:pos(x - drag_state.offset_x, y - drag_state.offset_y)
            return true
        end

        -- Skip hover updates if no panel is visible
        if not active_panel or not active_panel._visible then return false end

        -- Update hover on all buttons
        for _, w in pairs(clickables) do
            if w.set_hovered and w._visible then
                w:set_hovered(w:hover(x, y))
            end
        end

        -- Block mouse move over panel to prevent camera/character movement
        return over_any_panel(x, y)
    end

    -- Left click down
    if type == 1 then
        -- Check scrollbar thumb/track for drag start
        for _, w in pairs(clickables) do
            if w.hover_scroll_thumb and w._visible then
                if w:hover_scroll_thumb(x, y) then
                    scrollbar_drag = {widget = w, offset_y = y - w._thumb_y}
                    return true
                elseif w:hover_scroll_track(x, y) then
                    -- Click on track: jump scroll to clicked position, then start drag
                    local ratio = (y - w._track_y) / w._track_h
                    local max_offset = math.max(0, #w._items - w._visible_count)
                    local new_offset = math.floor(ratio * max_offset + 0.5)
                    w:scroll_to_offset(new_offset)
                    -- Start drag from new thumb position
                    scrollbar_drag = {widget = w, offset_y = math.floor(w._thumb_h / 2)}
                    return true
                end
            end
        end

        -- Check panel title bars for drag start
        for _, w in pairs(clickables) do
            if w.hover_title and w:hover_title(x, y) then
                -- Check if collapse/close buttons are hovered first
                if w._collapse_btn:hover(x, y) or w._close_btn:hover(x, y) then
                    -- Don't start drag, let button handle it
                else
                    local px, py = w:get_pos()
                    drag_state = {panel = w, offset_x = x - px, offset_y = y - py}
                    mouse_down_target = w
                    return true
                end
            end
        end

        -- Check buttons and clickable bars (only widgets with on_click)
        -- Skip panels and scroll lists — they don't handle clicks directly
        local hit_input = false
        for _, w in pairs(clickables) do
            if w.on_click and w.hover and w._visible then
                if w:hover(x, y) then
                    mouse_down_target = w
                    -- Track if we clicked a TextInput (don't blur it)
                    if getmetatable(w) == TextInput then
                        hit_input = true
                    end
                    -- Blur focused input if clicking a different widget
                    if focused_input and not hit_input then
                        focused_input:blur()
                    end
                    return true
                end
            end
        end

        -- Block click if over panel even if not on a specific widget
        if over_any_panel(x, y) then
            -- Blur focused input when clicking empty panel area
            if focused_input then
                focused_input:blur()
            end
            mouse_down_target = nil
            return true
        end

        mouse_down_target = nil
        return false
    end

    -- Left click release
    if type == 2 then
        -- End scrollbar drag
        if scrollbar_drag then
            scrollbar_drag = nil
            return true
        end

        -- End panel drag
        if drag_state then
            drag_state = nil
            mouse_down_target = nil
            return true
        end

        -- Fire click on the widget that received mouse down
        if mouse_down_target then
            local w = mouse_down_target
            mouse_down_target = nil
            if w.on_click and w._visible and w.hover and w:hover(x, y) then
                w:on_click()
                return true
            end
            -- Click started on a widget but released elsewhere — consume it
            if over_any_panel(x, y) then
                return true
            end
            return false
        end

        -- Block release over panel
        if over_any_panel(x, y) then
            return true
        end
        return false
    end

    -- Right click down/up (types 3/4/5) — block over panel
    if type == 3 or type == 4 or type == 5 then
        if over_any_panel(x, y) then
            return true
        end
    end

    -- Scroll wheel event: type 10, delta > 0 = scroll up, delta < 0 = scroll down
    if type == 10 then
        for _, w in pairs(clickables) do
            if w.scroll_up and w._visible and w:hover(x, y) then
                if delta > 0 then
                    w:scroll_up()
                else
                    w:scroll_down()
                end
                return true
            end
        end

        -- Block scroll over panel even if no scrollable widget
        if over_any_panel(x, y) then
            return true
        end
    end

    return false
end)

---------------------------------------------------------------------------
-- Cleanup function — destroy all tracked widgets
---------------------------------------------------------------------------
function widgets.cleanup()
    local ids = {}
    for id in pairs(clickables) do ids[#ids + 1] = id end
    for _, id in ipairs(ids) do
        local w = clickables[id]
        if w and w.destroy then
            w:destroy()
        end
    end
    clickables = {}
    drag_state = nil
    mouse_down_target = nil
end

return widgets
