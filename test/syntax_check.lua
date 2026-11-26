-- syntax_check.lua: every Lua file named on stdin compiles under Lua 5.1.
--
--   git ls-files '*.lua' | lua5.1 test/syntax_check.lua
--
-- A file that does not compile is reported with the parser's own message and the run ends
-- non-zero. It reads nothing but the files themselves, so it needs no game installation.
local n, bad = 0, 0
for line in io.lines() do
    local path = line:gsub('%s+$', '')
    if path ~= '' then
        n = n + 1
        local chunk, err = loadfile(path)
        if not chunk then
            bad = bad + 1
            io.stderr:write(tostring(err), string.char(10))
        end
    end
end
print(('syntax: %d files, %d failed'):format(n, bad))
os.exit(bad == 0 and 0 or 1)
