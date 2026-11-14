--[[
    Chronicle: a GIF as a BMP. The renderer decodes PNG, JPEG and BMP only (nui's textures.cpp), and BG-wiki has some
    pictures as GIFs only (mission adoulin 280: the two floor maps of Outer Ra'Kaznar), which the layout sized from the GIF header
    and then could not draw (a "failed" box a different height, 2026-10-21). core/pics.lua converts a downloaded GIF once, with
    this, to an 8-bit BMP beside it.

        gif.to_bmp(bytes[, yield]) -> bmp string | nil, why
            yield: called now and then while decoding (core/pics.lua passes a coroutine sleep, so a big picture does not
            hold the game's Lua thread in one piece; review CORE-10). A cut or malformed file returns nil, never an error.
        gif.size(bytes)   -> w, h | nil           -- the logical screen, which is the bitmap's size

    The first frame only, drawn on the logical screen (a frame smaller than the screen sits where the file puts it; what a frame leaves uncovered
    is colour 0, or black when the file has a transparent colour; a transparent pixel is black), interlaced or not.
    Pure Lua 5.1, no bit library.
]]

local gif = {}

local function u16(s, i) return s:byte(i) + s:byte(i + 1) * 256 end
local function le32(n)
    n = n % 4294967296
    return string.char(n % 256, math.floor(n / 256) % 256, math.floor(n / 65536) % 256, math.floor(n / 16777216) % 256)
end
local function le16(n) return string.char(n % 256, math.floor(n / 256) % 256) end

local POW = {}
for i = 0, 16 do POW[i] = 2 ^ i end

function gif.size(s)
    if type(s) ~= 'string' or #s < 10 then return nil end
    local sig = s:sub(1, 6)
    if sig ~= 'GIF87a' and sig ~= 'GIF89a' then return nil end
    local w, h = u16(s, 7), u16(s, 9)
    if w > 0 and h > 0 then return w, h end
end

-- the LZW data of one image (sub-blocks already joined) -> a string of npix colour indices (shorter if the data ends early)
local YIELD_EVERY = 65536       -- pixels decoded between two calls of `yield`
local function lzw(data, minbits, npix, yield)
    if minbits < 2 or minbits > 8 then return nil, 'bad LZW code size ' .. minbits end
    local clear = POW[minbits]
    local eoi = clear + 1
    local dict, nxt, bits
    local function reset()
        dict = {}
        for i = 0, clear - 1 do dict[i] = string.char(i) end
        nxt, bits = eoi + 1, minbits + 1
    end
    reset()
    local out, total, prev = {}, 0, nil
    local acc, nacc, pos, n = 0, 0, 1, #data
    local next_yield = YIELD_EVERY
    while total < npix do
        if yield and total >= next_yield then
            yield()
            next_yield = total + YIELD_EVERY
        end
        while nacc < bits do
            if pos > n then return table.concat(out) end
            acc = acc + data:byte(pos) * POW[nacc]
            nacc, pos = nacc + 8, pos + 1
        end
        local code = acc % POW[bits]
        acc = (acc - code) / POW[bits]
        nacc = nacc - bits
        if code == clear then
            reset()
            prev = nil
        elseif code == eoi then
            break
        else
            local entry
            if dict[code] then
                entry = dict[code]
            elseif code == nxt and prev then
                entry = prev .. prev:sub(1, 1)
            else
                return nil, 'bad LZW code'
            end
            if prev and nxt < 4096 then
                dict[nxt] = prev .. entry:sub(1, 1)
                nxt = nxt + 1
                if nxt == POW[bits] and bits < 12 then bits = bits + 1 end
            end
            out[#out + 1] = entry
            total = total + #entry
            prev = entry
        end
    end
    return table.concat(out)
end

local PASSES = {{0, 8}, {4, 8}, {2, 4}, {1, 2}}

gif.MAX = 2048                  -- the largest logical screen converted, per side (review CORE-10: at 4096 one took seconds and ~100 MB)

function gif.to_bmp(s, yield)
    local W, H = gif.size(s)
    if not W then return nil, 'not a GIF' end
    if W > gif.MAX or H > gif.MAX then return nil, 'too large' end
    local packed = s:byte(11)
    if not packed then return nil, 'cut in the header' end
    local pos = 14
    local pal = {}
    local gsize = 0
    if packed >= 128 then
        gsize = 2 ^ (packed % 8 + 1)
        for i = 0, gsize - 1 do
            local o = pos + i * 3
            if o + 2 > #s then return nil, 'cut in the global colour table' end
            pal[i] = {s:byte(o), s:byte(o + 1), s:byte(o + 2)}
        end
        pos = pos + gsize * 3
    end
    local transp
    while pos <= #s do
        local b = s:byte(pos)
        if b == 0x21 then                                           -- an extension
            local label = s:byte(pos + 1)
            if not label then return nil, 'cut in an extension' end
            if label == 0xF9 and s:byte(pos + 2) == 4 then
                local flags = s:byte(pos + 3)                      -- a file cut after "21 F9 04" has none (review CORE-10)
                if flags and flags % 2 == 1 then transp = s:byte(pos + 6) end
            end
            pos = pos + 2
            while true do                                           -- its sub-blocks
                local l = s:byte(pos)
                if not l then return nil, 'cut in an extension' end
                pos = pos + 1 + l
                if l == 0 then break end
            end
        elseif b == 0x2C then                                       -- the first image
            if pos + 9 > #s then return nil, 'cut in an image header' end
            local left, top, fw, fh = u16(s, pos + 1), u16(s, pos + 3), u16(s, pos + 5), u16(s, pos + 7)
            local ip = s:byte(pos + 9)
            pos = pos + 10
            local fpal = pal
            if ip >= 128 then
                fpal = {}
                local size = 2 ^ (ip % 8 + 1)
                for i = 0, size - 1 do
                    local o = pos + i * 3
                    if o + 2 > #s then return nil, 'cut in the local colour table' end
                    fpal[i] = {s:byte(o), s:byte(o + 1), s:byte(o + 2)}
                end
                pos = pos + size * 3
            end
            local interlaced = math.floor(ip / 64) % 2 == 1
            local minbits = s:byte(pos)
            if not minbits then return nil, 'cut before the image data' end
            pos = pos + 1
            local blocks = {}
            while true do
                local l = s:byte(pos)
                if not l then return nil, 'cut in the image data' end
                if l == 0 then break end
                blocks[#blocks + 1] = s:sub(pos + 1, pos + l)
                pos = pos + 1 + l
            end
            if fw == 0 or fh == 0 then return nil, 'an empty image' end
            local pix, why = lzw(table.concat(blocks), minbits, fw * fh, yield)
            if not pix then return nil, why end
            if #pix < fw * fh then pix = pix .. string.rep(string.char(0), fw * fh - #pix) end

            -- the colours: black for a transparent colour, 256 entries
            local fill = transp or 0                                   -- as PIL and the browsers do: the file's background colour index is ignored
            if fill > 255 then fill = 0 end
            local rows = {}
            local fillrow = string.rep(string.char(fill), W)
            for y = 1, H do rows[y] = fillrow end
            local order = {}                                        -- the frame's rows in stream order -> canvas row
            if interlaced then
                for _, p in ipairs(PASSES) do
                    for y = p[1], fh - 1, p[2] do order[#order + 1] = y end
                end
            else
                for y = 0, fh - 1 do order[y + 1] = y end
            end
            local tch = transp and string.char(transp)
            for i, y in ipairs(order) do
                if yield and i % 256 == 0 then yield() end
                local cy = top + y
                if cy < H and left < W then
                    local row = pix:sub((i - 1) * fw + 1, i * fw)
                    if left + fw > W then row = row:sub(1, W - left) end
                    local base = rows[cy + 1]
                    if tch and row:find(tch, 1, true) then
                        local t = {}
                        for x = 1, #row do
                            local c = row:sub(x, x)
                            t[x] = (c == tch) and base:sub(left + x, left + x) or c
                        end
                        row = table.concat(t)
                    end
                    rows[cy + 1] = base:sub(1, left) .. row .. base:sub(left + #row + 1)
                end
            end

            local rowbytes = math.ceil(W / 4) * 4
            local padding = string.rep(string.char(0), rowbytes - W)
            local data = {}
            for y = H, 1, -1 do data[#data + 1] = rows[y] .. padding end   -- bottom-up
            local ptab = {}
            for i = 0, 255 do
                local c = fpal[i]
                if i == transp or not c then c = {0, 0, 0} end
                ptab[#ptab + 1] = string.char(c[3], c[2], c[1], 0)
            end
            local body = table.concat(data)
            local offset = 14 + 40 + 1024
            return 'BM' .. le32(offset + #body) .. le32(0) .. le32(offset)
                .. le32(40) .. le32(W) .. le32(H) .. le16(1) .. le16(8) .. le32(0) .. le32(#body) .. le32(2835) .. le32(2835)
                .. le32(256) .. le32(0) .. table.concat(ptab) .. body
        elseif b == 0x3B then
            return nil, 'no image'
        else
            return nil, 'unknown block'
        end
    end
    return nil, 'no image'
end

return gif
