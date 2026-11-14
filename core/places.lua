--[[
    Chronicle: the window's place and size, per character and per logical screen size (the game's
    UI size under `scale ui`), in data/places_<character>.lua. Written by hand rather than through the
    config library: a key like "2560x1440" is not a valid XML tag.

    One file per character, saved through a temp file and a rename (review LIFE-6): six clients logging
    out together each rewrote one shared file in place, and one reading it mid-write wrote back only its
    own entry. The old shared data/places.lua is still read for a character with no file of its own
    yet, and its places are carried into that file on the first save; it is never rewritten.
]]

local fsave = require('core/fsave')

local places = {}

local LEGACY = 'data/places.lua'

local function file_of(char) return ('data/places_%s.lua'):format(tostring(char):gsub('[^%w_%-]', '_')) end
places.file_of = file_of

-- -> the file's table, or nil when there is no file (a file that does not parse reads as {})
local function read(path)
    local f = io.open(path, 'r')
    if not f then return nil end
    local src = f:read('*a')
    f:close()
    local fn = loadstring(src)
    if not fn then return {} end
    setfenv(fn, {})
    local ok, t = pcall(fn)
    return ok and type(t) == 'table' and t or {}
end

local function key(sw, sh) return ('%dx%d'):format(sw, sh) end

-- this character's places: its own file, else its entry in the old shared file
local function mine(dir, char)
    dir = fsave.data_dir(dir)
    local own = read(dir .. file_of(char))
    if own then return own end
    local c = (read(dir .. LEGACY) or {})[char]
    local out = {}
    if type(c) == 'table' then for k, v in pairs(c) do out[k] = v end end
    return out
end

function places.load(dir, char, sw, sh)
    local p = mine(dir, char)[key(sw, sh)]
    if type(p) == 'table' and tonumber(p.x) and tonumber(p.y) and tonumber(p.w) and tonumber(p.h) then return p end
    return nil
end

function places.save(dir, char, sw, sh, p)
    local all = mine(dir, char)
    all[key(sw, sh)] = {x = math.floor(p.x), y = math.floor(p.y), w = math.floor(p.w), h = math.floor(p.h)}
    local out = {'-- Chronicle window place and size per screen, for one character (core/places.lua)', 'return {'}
    local ks = {}
    for k in pairs(all) do ks[#ks + 1] = k end
    table.sort(ks)
    for _, k in ipairs(ks) do
        local v = all[k]
        if type(v) == 'table' and tonumber(v.x) and tonumber(v.y) and tonumber(v.w) and tonumber(v.h) then
            out[#out + 1] = ('    [%q] = {x = %d, y = %d, w = %d, h = %d},'):format(k, v.x, v.y, v.w, v.h)
        end
    end
    out[#out + 1] = '}'
    dir = fsave.data_dir(dir)
    fsave.mkdir(dir .. 'data')            -- io.open does not create folders
    return (fsave.write(dir .. file_of(char), table.concat(out, '\n') .. '\n'))
end

return places
