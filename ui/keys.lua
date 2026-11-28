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

return keys
