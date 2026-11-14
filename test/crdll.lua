--[[
    test/crdll.lua - CR_DLL=<path to a _chronicle build> makes every suite load that build instead of
    libs/_chronicle.dll (the game locks the installed one while the addon is loaded: build to
    libs/_chronicle.new.dll with CR_OUT=, test it with CR_DLL=, then replace the installed one).

        package.preload['_chronicle'] = dofile('test/crdll.lua').loader()    -- nil when CR_DLL is unset
        dofile('test/crdll.lua').path()                                       -- the DLL file the suites use
]]
local M = {}
function M.path()
    local p = os.getenv('CR_DLL')
    if p and p ~= '' then return p end
    return './libs/_chronicle.dll'
end
function M.loader()
    local p = os.getenv('CR_DLL')
    if not p or p == '' then return nil end
    local f, err = package.loadlib(p, 'luaopen__chronicle')
    if not f then error('CR_DLL=' .. p .. ' did not load: ' .. tostring(err), 0) end
    return f
end
return M
