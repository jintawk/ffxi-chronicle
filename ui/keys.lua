--[[
    DirectInput key codes -> characters for the search box (v1's tables), with Shift tracked from
    the keyboard event itself.
]]

local keys = {}

local plain = {
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
    [0x39] = ' ', [0x29] = '`', [0x2B] = '\\',
}
local shifted = {
    [0x02] = '!', [0x03] = '@', [0x04] = '#', [0x05] = '$', [0x06] = '%',
    [0x07] = '^', [0x08] = '&', [0x09] = '*', [0x0A] = '(', [0x0B] = ')',
    [0x0C] = '_', [0x0D] = '+', [0x1A] = '{', [0x1B] = '}',
    [0x27] = ':', [0x28] = '"', [0x33] = '<', [0x34] = '>', [0x35] = '?',
    [0x29] = '~', [0x2B] = '|',
}

-- each Shift key on its own: releasing one while the other is held keeps Shift (review UI-7); Ctrl and Alt the same way, for the
-- keyboard driver (a key with Ctrl or Alt held is the game's)
local held = {[0x2A] = false, [0x36] = false, [0x1D] = false, [0x9D] = false, [0x38] = false, [0xB8] = false}

-- -> the character for this key press, or nil
function keys.char(dik, down)
    if held[dik] ~= nil then held[dik] = down == true return nil end
    if not down then return nil end
    local c = plain[dik]
    if not c then return nil end
    if held[0x2A] or held[0x36] then return shifted[dik] or c:upper() end
    return c
end

-- the game window lost or gained focus: a Shift released elsewhere never sent its key-up
function keys.reset() for k in pairs(held) do held[k] = false end end

-- -> Shift held, Ctrl or Alt held (as the last keyboard events said)
function keys.shift() return held[0x2A] or held[0x36] end
function keys.ctrl_alt() return held[0x1D] or held[0x9D] or held[0x38] or held[0xB8] end
function keys.ctrl() return held[0x1D] or held[0x9D] end
function keys.alt() return held[0x38] or held[0xB8] end
function keys.modifier(dik) return held[dik] ~= nil end

-- Key names, for the keyboard driver's own key (settings.nav_key): the characters above, F1 to F12 and a few named keys.
-- A name is lower case, with optional modifiers before it: 'k', 'ctrl+n', 'alt+shift+f10' (Windower's ^n, !n and ~n too).
local NAMED = {
    f1 = 0x3B, f2 = 0x3C, f3 = 0x3D, f4 = 0x3E, f5 = 0x3F, f6 = 0x40, f7 = 0x41, f8 = 0x42, f9 = 0x43, f10 = 0x44,
    f11 = 0x57, f12 = 0x58, space = 0x39, insert = 0xD2, delete = 0xD3, pause = 0xC5, scrolllock = 0x46,
    up = 0xC8, down = 0xD0, left = 0xCB, right = 0xCD, enter = 0x1C, backspace = 0x0E, tab = 0x0F,
    pageup = 0xC9, pagedown = 0xD1, home = 0xC7, ['end'] = 0xCF,
}
local DIK_OF, NAME_OF = {}, {}
for dik, c in pairs(plain) do if c ~= ' ' then DIK_OF[c], NAME_OF[dik] = dik, c end end
for n, dik in pairs(NAMED) do DIK_OF[n], NAME_OF[dik] = dik, n end
local PREFIX = {['^'] = 'ctrl', ['!'] = 'alt', ['~'] = 'shift'}

-- name -> {dik, ctrl, alt, shift, name (normalized), label (for the hint line)}, or nil and why
function keys.parse(name)
    local s = tostring(name or ''):lower():gsub('%s+', '')
    local mods = {}
    while true do
        local p = s:sub(1, 1)
        if PREFIX[p] and #s > 1 then mods[PREFIX[p]] = true s = s:sub(2)
        else
            local m, rest = s:match('^(%a+)%+(.+)$')
            if m == 'ctrl' or m == 'alt' or m == 'shift' then mods[m] = true s = rest else break end
        end
    end
    local dik = DIK_OF[s]
    if not dik then return nil, 'not a key name: ' .. tostring(name) end
    local parts, label = {}, {}
    for _, m in ipairs({'ctrl', 'alt', 'shift'}) do
        if mods[m] then parts[#parts + 1] = m label[#label + 1] = m:sub(1, 1):upper() .. m:sub(2) end
    end
    parts[#parts + 1] = s
    label[#label + 1] = #s == 1 and s:upper() or (s:sub(1, 1):upper() .. s:sub(2))
    return {dik = dik, ctrl = mods.ctrl == true, alt = mods.alt == true, shift = mods.shift == true,
            name = table.concat(parts, '+'), label = table.concat(label, '+')}
end

-- the key just pressed, with the modifiers held, as a name for keys.parse (nil: a key with no name)
function keys.name_now(dik)
    local n = NAME_OF[dik]
    if not n then return nil end
    local parts = {}
    if keys.ctrl() then parts[#parts + 1] = 'ctrl' end
    if keys.alt() then parts[#parts + 1] = 'alt' end
    if keys.shift() then parts[#parts + 1] = 'shift' end
    parts[#parts + 1] = n
    return table.concat(parts, '+')
end

return keys
