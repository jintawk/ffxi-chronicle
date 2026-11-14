--[[
    Chronicle: drawing commands for _chronicle.dll (plugin/nui/ops.cpp) and the game fonts'
    metrics, so everything Lua lays out is measured with the widths the DLL draws with.

        local ops = require('ui/ops')
        ops.set_metrics(native.metrics())
        local b = ops.new()
        b:win(x, y, w, h, title) b:text(x, y, col, s) b:title(x, y, px, col, s) b:rect(x0, y0, x1, y1, col)
        b:quad(tex, x0, y0, x1, y1, u0, v0, u1, v1, col, filter) b:icon(x, y, size, item_id, col)
        b:gauge(x, y, w, h, frac, col) b:clip(x0, y0, x1, y1) b:unclip()
        b:hit({x0 =, y0 =, x1 =, y1 =, id =, ...})       -- input rectangles, kept with the commands
        b:text_out() -> the command text           b.hits -> the hit list
        ops.text_w(s) ops.title_w(s, px) ops.wrap(s, width) -> lines
        ops.fit(s, width) / ops.fit_title(s, px, width) -> s cut to the width with '..' (body font / title font)
        ops.fit_words(s, width) -> as fit, cut at a word (the step strip's hint, rule 147)
        ops.fit_tail(s, width) -> as fit, keeping a trailing "(qualifier)"
        ops.wrap_title(s, px, first, rest, max) -> a title wrapped to lines, a trailing "(qualifier)" kept whole

    Colours are {r, g, b[, a]}. Text is the game font's ASCII: accented letters fold to their base
    letter, anything else to '?', and tabs or newlines never reach the command text.
]]

local ops = {}

local M = nil   -- {moji = {96}, title = {{w, h, top} x 95}}

-- Built-in moji widths (the DLL's fallback table), used until set_metrics (tests, no game).
local FALLBACK = {7, 7, 7, 10, 8, 13, 11, 5, 8, 8, 9, 9, 5, 8, 5, 7, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 5, 5,
    9, 9, 9, 9, 11, 11, 11, 10, 10, 10, 9, 11, 10, 6, 9, 11, 10, 12, 10, 11, 10, 12, 11, 10,
    10, 10, 11, 14, 11, 11, 11, 8, 8, 8, 9, 9, 7, 9, 9, 9, 9, 9, 7, 9, 9, 5, 6, 9, 5, 12, 9,
    10, 9, 9, 6, 8, 7, 9, 9, 11, 9, 9, 8, 7, 6, 7, 12, 7}

function ops.set_metrics(m)
    if type(m) == 'table' and type(m.moji) == 'table' and #m.moji == 96 then M = m end
end
function ops.metrics() return M end

-- UTF-8 -> the font's ASCII ------------------------------------------------------------------------

local FOLD = {
    ['\195\128'] = 'A', ['\195\129'] = 'A', ['\195\130'] = 'A', ['\195\132'] = 'A', ['\195\135'] = 'C',
    ['\195\136'] = 'E', ['\195\137'] = 'E', ['\195\138'] = 'E', ['\195\139'] = 'E', ['\195\142'] = 'I',
    ['\195\143'] = 'I', ['\195\148'] = 'O', ['\195\150'] = 'O', ['\195\153'] = 'U', ['\195\155'] = 'U',
    ['\195\156'] = 'U', ['\195\160'] = 'a', ['\195\161'] = 'a', ['\195\162'] = 'a', ['\195\164'] = 'a',
    ['\195\167'] = 'c', ['\195\168'] = 'e', ['\195\169'] = 'e', ['\195\170'] = 'e', ['\195\171'] = 'e',
    ['\195\174'] = 'i', ['\195\175'] = 'i', ['\195\180'] = 'o', ['\195\182'] = 'o', ['\195\185'] = 'u',
    ['\195\187'] = 'u', ['\195\188'] = 'u', ['\195\177'] = 'n',
    ['\226\128\152'] = "'", ['\226\128\153'] = "'", ['\226\128\156'] = '"', ['\226\128\157'] = '"',
    ['\226\128\147'] = '-', ['\226\128\148'] = '-', ['\226\128\166'] = '...', ['\194\160'] = ' ',
}

function ops.ascii(s)
    s = tostring(s or '')
    if not s:find('[\128-\255\t\r\n]') then return s end
    s = s:gsub('[\t\r\n]', ' ')
    s = s:gsub('[\192-\247][\128-\191]+', function(c) return FOLD[c] or '?' end)
    return (s:gsub('[\128-\255]', '?'))
end
local ascii = ops.ascii

-- metrics --------------------------------------------------------------------------------------------

function ops.text_w(s)
    local moji = M and M.moji or FALLBACK
    local w = 0
    for i = 1, #s do
        local b = s:byte(i)
        if b < 32 or b > 127 then b = 63 end
        w = w + moji[b - 31]
    end
    return w
end
local text_w = ops.text_w

function ops.title_w(s, px)
    if not M then return #s * px * 0.62 end
    local k = px / M.title[('M'):byte() - 31][2]
    local w = 0
    for i = 1, #s do
        local b = s:byte(i)
        if b == 32 then w = w + 4 * k
        else
            if b < 32 or b > 126 then b = 63 end
            w = w + M.title[b - 31][1] * k
        end
    end
    return w
end

-- Greedy word wrap at a pixel width; a word longer than the width is cut.
function ops.wrap(s, width)
    s = ascii(s)
    local lines, line = {}, ''
    for word in s:gmatch('%S+') do
        local cand = line == '' and word or line .. ' ' .. word
        if text_w(cand) <= width then
            line = cand
        else
            if line ~= '' then lines[#lines + 1] = line end
            while text_w(word) > width and #word > 1 do
                local n = #word
                while n > 1 and text_w(word:sub(1, n)) > width do n = n - 1 end
                lines[#lines + 1] = word:sub(1, n)
                word = word:sub(n + 1)
            end
            line = word
        end
    end
    if line ~= '' then lines[#lines + 1] = line end
    return lines
end

-- The longest prefix of s that fits in width, with '..' when cut. One running width (glyph widths are
-- never negative, so the prefixes that fit are exactly the first n): the same cut as re-measuring every
-- prefix plus '..' from the longest down, each sum added in the same order (2026-10-22 perf pass).
function ops.fit(s, width)
    s = ascii(s)
    if text_w(s) <= width then return s end
    local moji = M and M.moji or FALLBACK
    local dot = moji[('.'):byte() - 31]
    local w, n = 0, 0
    for i = 1, #s do
        local b = s:byte(i)
        if b < 32 or b > 127 then b = 63 end
        w = w + moji[b - 31]
        if w + dot + dot > width then break end
        n = i
    end
    return s:sub(1, n) .. '..'
end

-- Rule 147 (vision, toau 6 12 21 28 44 93, other 79, outlands 135 199): the step strip's hint cut by fit() ended mid-word or on an open
-- bracket ("Palace Do..", "cut-scen..", "(.."). fit_words cuts the same text at a word: s when it fits, else the longest prefix that ends
-- before a space with '..' still fitting, trailing spaces, open brackets and joining marks (a comma, a dash, a slash, "&") dropped before
-- the '..'. When no word boundary leaves a prefix (the first word alone is too wide) it is fit(). ops.WORD_FIT = false is fit().
ops.WORD_FIT = true
-- A sentence's full stop, "!" and "?" are dropped too (a cut after "Lower Jeuno." read "Lower Jeuno..."): ops.WORD_STOPS = false keeps them.
ops.WORD_STOPS = true
local JOIN = '[%s%(%[{<,;:%-/&+=|]+$'
local JOIN_STOPS = '[%s%(%[{<,;:%-/&+=|%.!%?]+$'
function ops.fit_words(s, width)
    if not ops.WORD_FIT then return ops.fit(s, width) end
    s = ascii(s)
    if text_w(s) <= width then return s end
    local moji = M and M.moji or FALLBACK
    local dot = moji[('.'):byte() - 31]
    local w, best = 0, nil
    for i = 1, #s do
        local b = s:byte(i)
        if b < 32 or b > 127 then b = 63 end
        if b == 32 and w + dot + dot <= width then
            local core = s:sub(1, i - 1):gsub(ops.WORD_STOPS and JOIN_STOPS or JOIN, '')
            if core ~= '' then best = core end
        end
        w = w + moji[b - 31]
        if w + dot + dot > width then break end
    end
    if best then return best .. '..' end
    return ops.fit(s, width)
end

-- The same for text drawn in the title font at px (ops.fit measures in the body font, whose widths are not the
-- title font's: a title cut to fit by fit() ran under the status badge, 2026-10-19). The running width adds
-- the terms in title_w's order, so a cut at a fractional boundary is the same as before.
function ops.fit_title(s, px, width)
    s = ascii(s)
    if ops.title_w(s, px) <= width then return s end
    local n = 0
    if not M then
        n = #s
        while n > 0 and (n + 2) * px * 0.62 > width do n = n - 1 end
        return s:sub(1, n) .. '..'
    end
    local T = M.title
    local k = px / T[('M'):byte() - 31][2]
    local dot = T[('.'):byte() - 31][1] * k
    local w = 0
    for i = 1, #s do
        local b = s:byte(i)
        if b == 32 then w = w + 4 * k
        else
            if b < 32 or b > 126 then b = 63 end
            w = w + T[b - 31][1] * k
        end
        if (w + dot) + dot > width then break end
        n = i
    end
    return s:sub(1, n) .. '..'
end

-- Cut to the width with '..' like ops.fit, but keep a trailing "(qualifier)" whole: the part that tells two quests of
-- one name apart ("Lure of the Wildcat (San d'Oria)" -> "Lure of the Wil.. (San d'Oria)", 2026-10-20).
function ops.fit_tail(s, width)
    s = ascii(s)
    if text_w(s) <= width then return s end
    local qual = s:match('%s(%b())$')
    if qual then
        local head = s:sub(1, #s - #qual - 1)
        local room = width - text_w(' ' .. qual)
        if room >= text_w('WW..') then return ops.fit(head, room) .. ' ' .. qual end
    end
    return ops.fit(s, width)
end

-- A title in the title font at px wrapped to lines: the first has `first` px, the others `rest`. A trailing
-- "(qualifier)" is one unbreakable piece, so it moves to the next line whole ("Lure of the Wildcat" / "(San d'Oria)"),
-- never split ("(San" / "d'Oria)"). At most `max` lines: the rest of the name is cut with '..' on the last one. A
-- piece wider than its line is cut with '..' too (a word of 30 letters).
function ops.wrap_title(s, px, first, rest, max)
    s = ascii(s)
    local qual = s:match('%s(%b())$')
    local pieces = {}
    for w in (qual and s:sub(1, #s - #qual - 1) or s):gmatch('%S+') do pieces[#pieces + 1] = w end
    if qual then pieces[#pieces + 1] = qual end
    local lines, line = {}, ''
    for _, w in ipairs(pieces) do
        local room = #lines == 0 and first or rest
        local cand = line == '' and w or line .. ' ' .. w
        if line == '' or ops.title_w(cand, px) <= room then
            line = cand
        else
            lines[#lines + 1] = line
            line = w
        end
    end
    if line ~= '' then lines[#lines + 1] = line end
    if #lines == 0 then lines[1] = '' end
    if #lines > max then
        local tail = table.concat(lines, ' ', max)
        for i = #lines, max, -1 do lines[i] = nil end
        lines[max] = tail
    end
    for i, l in ipairs(lines) do
        local room = i == 1 and first or rest
        if ops.title_w(l, px) > room then lines[i] = ops.fit_title(l, px, room) end
    end
    return lines
end

-- builder ------------------------------------------------------------------------------------------

--[[ The builder: one string per command in b.o (joined by '\n' in text_out). Each command concatenates
     its fields directly (no vararg table): an integral number goes in as the number itself, which `..`
     formats with "%.14g" exactly as tostring does; anything else keeps the old num() rule ('%.2f'), and a
     string field is passed through as before. Colours go through a string cache keyed by the packed
     RGBA number, only for integral components 0-255 (any other colour is formatted every time, so a
     packed key never stands for two colours); bounded at HEX_MAX entries (cleared when full)
     (2026-10-22 perf pass): the text is byte-identical to the old vararg builder's
     (test/test_perf.lua checks it on real pages at several widths; the old builder is its REF). ]]

local fmt, floor, type, tostring = string.format, math.floor, type, tostring

local HEX, hex_n = {}, 0
local HEX_MAX = 4096

local function hex(c)
    local r, g, b, a = c[1], c[2], c[3], c[4] or 255
    if r % 256 == r and g % 256 == g and b % 256 == b and a % 256 == a
        and r % 1 == 0 and g % 1 == 0 and b % 1 == 0 and a % 1 == 0 then
        local k = ((r * 256 + g) * 256 + b) * 256 + a
        local h = HEX[k]
        if h then return h end
        h = fmt('%02X%02X%02X%02X', r, g, b, a)
        if hex_n >= HEX_MAX then HEX, hex_n = {}, 0 end
        HEX[k] = h
        hex_n = hex_n + 1
        return h
    end
    return fmt('%02X%02X%02X%02X', r, g, b, a)
end
ops.hex = hex
function ops.hex_cache_size() return hex_n end

-- a field: the old num() for a number that is not integral; a string as it is
local function num(v)
    if type(v) ~= 'number' then return v end
    if v == floor(v) then return tostring(v) end     -- an integral value % 1 did not catch (inf)
    return fmt('%.2f', v)
end
-- a field that may be a string (tex, filter, id, size, px): integral numbers fast, the rest via num
local function arg(v)
    if type(v) == 'number' and v % 1 == 0 then return v end
    return num(v)
end
ops._num = num

local B = {}
B.__index = B
ops.B = B           -- the builder's methods (test/test_perf.lua swaps in the old ones for its fault run)

function ops.new()
    return setmetatable({o = {}, hits = {}}, B)
end

-- the generic command
function B:add(...)
    local t = {...}
    for i = 2, #t do
        if type(t[i]) == 'number' then t[i] = num(t[i]) end
    end
    self.o[#self.o + 1] = table.concat(t, '\t')
end

local WHITE = {255, 255, 255}

function B:win(x, y, w, h, title, active)
    local o = self.o
    o[#o + 1] = 'W\t' .. (x % 1 == 0 and x or num(x)) .. '\t' .. (y % 1 == 0 and y or num(y)) .. '\t'
        .. (w % 1 == 0 and w or num(w)) .. '\t' .. (h % 1 == 0 and h or num(h)) .. '\t' .. ascii(title or '')
        .. '\t' .. (active and '1' or '0')
end
function B:text(x, y, col, s)
    s = ascii(s)
    if s ~= '' then
        local o = self.o
        o[#o + 1] = 'T\t' .. (x % 1 == 0 and x or num(x)) .. '\t' .. (y % 1 == 0 and y or num(y)) .. '\t' .. hex(col) .. '\t' .. s
    end
end
function B:title(x, y, px, col, s)
    s = ascii(s)
    if s ~= '' then
        local o = self.o
        o[#o + 1] = 'H\t' .. (x % 1 == 0 and x or num(x)) .. '\t' .. (y % 1 == 0 and y or num(y)) .. '\t' .. arg(px)
            .. '\t' .. hex(col) .. '\t' .. s
    end
end
function B:rect(x0, y0, x1, y1, col)
    if x1 > x0 and y1 > y0 then
        local o = self.o
        o[#o + 1] = 'R\t' .. (x0 % 1 == 0 and x0 or num(x0)) .. '\t' .. (y0 % 1 == 0 and y0 or num(y0)) .. '\t'
            .. (x1 % 1 == 0 and x1 or num(x1)) .. '\t' .. (y1 % 1 == 0 and y1 or num(y1)) .. '\t' .. hex(col)
    end
end
function B:quad(tex, x0, y0, x1, y1, u0, v0, u1, v1, col, filter)
    local o = self.o
    o[#o + 1] = 'Q\t' .. arg(tex) .. '\t' .. (x0 % 1 == 0 and x0 or num(x0)) .. '\t' .. (y0 % 1 == 0 and y0 or num(y0))
        .. '\t' .. (x1 % 1 == 0 and x1 or num(x1)) .. '\t' .. (y1 % 1 == 0 and y1 or num(y1)) .. '\t'
        .. (u0 % 1 == 0 and u0 or num(u0)) .. '\t' .. (v0 % 1 == 0 and v0 or num(v0)) .. '\t'
        .. (u1 % 1 == 0 and u1 or num(u1)) .. '\t' .. (v1 % 1 == 0 and v1 or num(v1)) .. '\t' .. hex(col or WHITE)
        .. '\t' .. arg(filter or 1)
end
function B:icon(x, y, size, id, col)
    local o = self.o
    o[#o + 1] = 'I\t' .. (x % 1 == 0 and x or num(x)) .. '\t' .. (y % 1 == 0 and y or num(y)) .. '\t' .. arg(size)
        .. '\t' .. arg(id) .. '\t' .. hex(col or WHITE)
end
function B:gauge(x, y, w, h, frac, col)
    local o = self.o
    o[#o + 1] = 'G\t' .. (x % 1 == 0 and x or num(x)) .. '\t' .. (y % 1 == 0 and y or num(y)) .. '\t'
        .. (w % 1 == 0 and w or num(w)) .. '\t' .. (h % 1 == 0 and h or num(h)) .. '\t'
        .. fmt('%.4f', math.max(0, math.min(1, frac))) .. '\t' .. hex(col)
end
function B:clip(x0, y0, x1, y1)
    local o = self.o
    o[#o + 1] = 'C\t' .. (x0 % 1 == 0 and x0 or num(x0)) .. '\t' .. (y0 % 1 == 0 and y0 or num(y0)) .. '\t'
        .. (x1 % 1 == 0 and x1 or num(x1)) .. '\t' .. (y1 % 1 == 0 and y1 or num(y1))
end
function B:unclip() self.o[#self.o + 1] = 'c' end
function B:hit(h) self.hits[#self.hits + 1] = h return h end
function B:text_out() return table.concat(self.o, '\n') end
function B:count() return #self.o end

return ops
