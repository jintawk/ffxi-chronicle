--[[
    Chronicle UI theme constants
    Colors, fonts, sizes, spacing

    Design: "Grand Chronicle" — deep navy palette with cyan/amber accents
    Inspired by glassmorphic Aetherial Chronicle concept
]]

local theme = {}

-- Scale factor — all dimensions and font sizes are multiplied by this value
theme.scale = 1.0

-- Scale helper: rounds a base value by current scale factor
function theme.s(base)
    return math.floor(base * theme.scale + 0.5)
end

-- Apply scale to all dimension values (called on init and when scale changes)
local function apply_scale()
    local s = theme.s

    -- Window dimensions
    theme.window_width = s(500)
    theme.title_height = s(22)
    theme.line_height = s(18)
    theme.padding = s(8)
    theme.bar_height = s(14)
    theme.breadcrumb_height = s(18)
    theme.scroll_indicator_width = math.max(2, s(6))
    theme.items_per_page = 15              -- count, not pixels — stays fixed

    -- Tab bar layout (top-level view)
    theme.tab_height = s(24)
    theme.tab_gap = s(16)
    theme.tab_font_size = s(10)
    theme.tab_underline_height = math.max(1, s(2))
    theme.tab_padding_bottom = s(6)

    -- Card layout (top-level view)
    theme.card_gap = s(8)
    theme.card_height = s(58)
    theme.card_padding = s(10)
    theme.card_bar_height = math.max(2, s(3))

    -- Header layout (top-level view)
    theme.header_title_size = s(14)
    theme.header_pct_size = s(16)
    theme.header_sub_size = s(9)
    theme.header_bar_height = math.max(2, s(5))

    -- Font sizes
    theme.font_size = s(10)
    theme.title_size = s(11)

    -- Card font sizes
    theme.card_name_size = s(11)
    theme.card_sub_size = s(8)
    theme.card_pct_size = s(9)

    -- View-specific scaled values
    theme.header_count_size = s(8)
    theme.footer_size = s(8)
    theme.loading_size = s(12)

    -- Spacing values used in views
    theme.header_pct_char_width = s(12)     -- estimated px per char at header_pct_size
    theme.header_count_char_width = s(6)    -- estimated px per char at count size
    theme.card_sub_y_offset = s(18)         -- offset from card top pad to sub-label
    theme.card_chevron_inset = s(8)         -- chevron inset from card right edge
    theme.card_bar_bottom_offset = s(6)     -- bar offset from card bottom
    theme.breadcrumb_char_width = 6.5 * theme.scale  -- estimated px per char (float)
    theme.bar_text_inset = s(4)             -- text inset inside bar

    -- Quest row layout (item_list view)
    theme.quest_row_height = s(34)
    theme.quest_row_gap = s(2)
    theme.quest_row_padding_x = s(10)
    theme.quest_row_indicator_size = s(14)
    theme.quest_row_indicator_gap = s(8)
    theme.quest_row_name_size = s(10)
    theme.quest_row_sub_size = s(8)
    theme.quest_row_status_size = s(7)
    theme.quest_row_name_y = s(3)
    theme.quest_row_sub_y = s(18)
    theme.quest_rows_per_page = 10
    theme.quest_row_status_char_w = s(5)

    -- Toolbar layout (item_list view)
    theme.toolbar_height = s(20)
    theme.toolbar_gap = s(8)
    theme.toolbar_input_width = s(180)
    theme.toolbar_input_size = s(9)
    theme.toolbar_button_size = s(8)
    theme.toolbar_y_gap = s(8)

    -- Wrap widths (chars) — description uses smaller font so fits more
    theme.wiki_wrap_width = math.floor(52 * theme.scale + 0.5)
    theme.walk_wrap_width = math.floor(46 * theme.scale + 0.5)

    -- Guide view layout
    theme.guide_name_size = s(13)
    theme.guide_desc_size = s(9)
    theme.guide_meta_label_size = s(8)
    theme.guide_meta_value_size = s(9)
    theme.guide_section_size = s(8)
    theme.guide_meta_pad = s(8)
    theme.guide_meta_row_h = s(32)
    theme.guide_section_gap = s(10)
    theme.guide_chain_label_w = s(80)  -- width for "< Previous: " text
    theme.guide_chain_next_w = s(52)   -- width for "> Next: " text

    -- Bar total (header)
    theme.bar_total = theme.bar_total or {}
    theme.bar_total.height = s(22)
    theme.bar_total.font_size = theme.font_size
    theme.bar_total.gap_below = s(14)
end

-- Set scale and recompute all dimensions
function theme.set_scale(new_scale)
    theme.scale = math.max(0.5, math.min(3.0, new_scale))
    apply_scale()
end

-- Fonts (names don't scale)
theme.font_name = 'Segoe UI'           -- body text (Manrope substitute)
theme.font_headline = 'Noto Serif'      -- headlines (install from Google Fonts)
theme.font_label = 'Consolas'           -- stats/labels (Space Grotesk substitute)

-- Initialize dimensions at default scale
apply_scale()

-- Background — deep navy #030e22
theme.bg = {
    alpha = 225,
    red = 3,
    green = 14,
    blue = 34,
}

-- Title bar background — blends into header #061329
theme.title_bg = {
    alpha = 235,
    red = 6,
    green = 19,
    blue = 41,
}

-- Text colors
theme.text = {                                              -- #dce5ff
    alpha = 255,
    red = 220,
    green = 229,
    blue = 255,
}

theme.text_dim = {                                          -- #a0abc6
    alpha = 180,
    red = 160,
    green = 171,
    blue = 198,
}

theme.text_bright = {
    alpha = 255,
    red = 255,
    green = 255,
    blue = 255,
}

-- Accent colors
theme.accent = {                                            -- #40cef3
    alpha = 255,
    red = 64,
    green = 206,
    blue = 243,
}

theme.accent_dim = {                                        -- #28c0e4
    alpha = 255,
    red = 40,
    green = 192,
    blue = 228,
}

theme.accent_amber = {                                      -- #ffb702
    alpha = 255,
    red = 255,
    green = 183,
    blue = 2,
}

theme.accent_green = {                                      -- #50dc78
    alpha = 255,
    red = 80,
    green = 220,
    blue = 120,
}

theme.accent_gold = {                                       -- #ffd700
    alpha = 255,
    red = 255,
    green = 215,
    blue = 0,
}

-- Status colors (for quest/mission status indicators)
theme.status = {
    completed = {red = 80, green = 220, blue = 120, alpha = 255},       -- green
    active = {red = 255, green = 183, blue = 2, alpha = 255},          -- amber
    ['repeat'] = {red = 64, green = 206, blue = 243, alpha = 200},     -- cyan dimmed
    not_started = {red = 160, green = 171, blue = 198, alpha = 255},   -- dim text
    unknown = {red = 255, green = 113, blue = 108, alpha = 255},       -- error red #ff716c
    -- Requirements checklist
    req_has = {red = 64, green = 206, blue = 243, alpha = 255},        -- cyan
    req_missing = {red = 255, green = 183, blue = 2, alpha = 255},     -- amber
    req_unknown = {red = 255, green = 113, blue = 108, alpha = 200},   -- dim red
    req_header = {red = 160, green = 171, blue = 198, alpha = 255},    -- dim text
}

-- Card colors
theme.card = {
    bg = {alpha = 220, red = 18, green = 36, blue = 65},              -- #122441
    bg_hover = {alpha = 240, red = 26, green = 44, blue = 75},        -- #1a2c4b
    border = {alpha = 40, red = 61, green = 72, blue = 95},           -- #3d485f at ~15%
    border_hover = {alpha = 80, red = 64, green = 206, blue = 243},   -- cyan glow
}

-- Bar colors (by completion tier)
theme.bar = {
    bg = {alpha = 200, red = 21, green = 37, blue = 67},              -- dark track
    fill_low = {alpha = 230, red = 255, green = 183, blue = 2},       -- amber (<25%)
    fill_mid = {alpha = 230, red = 64, green = 206, blue = 243},      -- cyan (25-74%)
    fill_high = {alpha = 230, red = 80, green = 220, blue = 120},     -- green (75-99%)
    fill_complete = {alpha = 240, red = 255, green = 215, blue = 0},  -- gold (100%)
    fill_default = {alpha = 230, red = 64, green = 206, blue = 243},  -- cyan
    -- legacy aliases used by item_list/guide views
    fill_green = {alpha = 230, red = 80, green = 220, blue = 120},
    fill_blue = {alpha = 230, red = 64, green = 206, blue = 243},
    fill_amber = {alpha = 230, red = 255, green = 183, blue = 2},
    text = {alpha = 255, red = 255, green = 255, blue = 255},
}

-- Total/summary bar fill color (set after apply_scale creates the table)
theme.bar_total.fill = {alpha = 230, red = 64, green = 206, blue = 243}  -- cyan

-- Quest row backgrounds (item_list view)
theme.quest_row = {
    bg_even = {alpha = 180, red = 10, green = 25, blue = 50},              -- #0a1932
    bg_odd = {alpha = 180, red = 16, green = 31, blue = 58},               -- #101f3a
    bg_hover = {alpha = 230, red = 26, green = 44, blue = 75},             -- #1a2c4b
    bg_active_even = {alpha = 200, red = 18, green = 30, blue = 60},       -- slightly brighter
    bg_active_odd = {alpha = 200, red = 22, green = 34, blue = 65},
}

-- Status display labels (item_list view)
theme.status_labels = {
    completed = 'COMPLETED',
    active = 'ACTIVE',
    not_started = '',
    ['repeat'] = 'REPEATABLE',
}

-- Clickable bar indicator
theme.bar_clickable_suffix = ' >'

-- Area bar indent (used by item_list view)
theme.bar_area_indent = 0

-- Button colors
theme.button = {
    normal = {alpha = 0, red = 0, green = 0, blue = 0},
    hover = {alpha = 100, red = 26, green = 44, blue = 75},           -- #1a2c4b
    text = {alpha = 255, red = 220, green = 229, blue = 255},         -- #dce5ff
    text_hover = {alpha = 255, red = 255, green = 255, blue = 255},
}

-- Breadcrumb
theme.breadcrumb = {
    separator = '>>',
    text = {alpha = 255, red = 64, green = 206, blue = 243},          -- cyan
    text_hover = {alpha = 255, red = 179, green = 243, blue = 255},   -- #b3f3ff
    active = {alpha = 255, red = 220, green = 229, blue = 255},       -- #dce5ff
}

-- Scroll indicator
theme.scroll = {
    bg = {alpha = 60, red = 10, green = 25, blue = 50},
    thumb = {alpha = 160, red = 64, green = 206, blue = 243},         -- cyan
}

-- Close / collapse button
theme.chrome = {
    text = {alpha = 180, red = 160, green = 171, blue = 198},         -- #a0abc6
    text_hover = {alpha = 255, red = 255, green = 255, blue = 255},
}

-- Toolbar colors (item_list search/sort/filter)
theme.toolbar = {
    input_bg = {alpha = 200, red = 10, green = 25, blue = 50},
    input_bg_focus = {alpha = 220, red = 18, green = 36, blue = 65},
    input_border_focus = {alpha = 120, red = 64, green = 206, blue = 243},
    placeholder = {alpha = 180, red = 160, green = 171, blue = 198},
    cursor = {alpha = 255, red = 64, green = 206, blue = 243},
}

-- Guide view colors
theme.guide = {
    meta_bg = {alpha = 220, red = 18, green = 36, blue = 65},        -- #122441 (matches card bg)
    desc_color = {alpha = 200, red = 140, green = 200, blue = 230},   -- soft cyan for flavor text
    section_color = {alpha = 255, red = 64, green = 206, blue = 243}, -- cyan section headers
}

-- Status symbols (ASCII-safe — Windower text rendering does not support UTF-8 multibyte)
theme.symbols = {
    completed = '+',
    active = '*',
    ['repeat'] = '~',
    not_started = '-',
    unknown = '?',
    expand = '>',
    collapse = 'v',
    close = 'x',
    back = '<-',
    scroll_up = '^',
    scroll_down = 'v',
    -- Requirements checklist
    req_has = '+',
    req_missing = 'o',
    req_unknown = '?',
    req_header = ' ',
}

return theme
