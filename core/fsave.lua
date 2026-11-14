--[[
    Chronicle: whole-file saves that a reader never sees half written.

        fsave.data_dir(addon_dir)    -- the folder data/ is in: the addon's own, or the test harness's temp folder
        fsave.mkdir(path)            -- make a folder (io.open does not); windower.create_dir, never a shell (review LIFE-12)
        fsave.write(path, text) -> true | false, why
            the text goes to a temp file of its own, is checked written, then renamed over `path`. A crash or a full disk leaves
            the old file whole; Windows' rename will not replace a file, so the old one is removed first, retried a few times
            when another process lands in between (review LIFE-6, CORE-12).
]]

local fsave = {}

math.randomseed(os.time() + math.floor((os.clock() % 1) * 1000000))

-- A player's own files (window places, page state, the progress log) are under <data_dir>data/. In the game that is the
-- addon folder; the offline tests set windower.chronicle_data_dir to a temp folder of their own, so a test run never reads
-- or writes them. The picture cache (data/pics, downloaded content) stays in the addon folder: the QA frames draw from it.
function fsave.data_dir(addon_dir)
    return windower and windower.chronicle_data_dir or addon_dir
end

function fsave.mkdir(path)
    if windower and windower.create_dir then pcall(windower.create_dir, path) end
end

fsave.FAIL_WRITE = nil          -- tests only: the temp file's write fails (a full disk)

function fsave.write(path, text)
    local tmp = ('%s.%d%06d.tmp'):format(path, os.time(), math.random(0, 999999))
    local f = io.open(tmp, 'wb')
    if not f then return false, 'cannot open ' .. tmp end
    local ok = f:write(text)
    local closed = f:close()
    if fsave.FAIL_WRITE then ok = nil end
    if not ok or not closed then
        os.remove(tmp)
        return false, 'write failed'
    end
    for _ = 1, 5 do
        if os.rename(tmp, path) then return true end
        os.remove(path)
    end
    os.remove(tmp)
    return false, 'rename failed'
end

return fsave
