#!/bin/sh
# Build and run the native tests (32-bit MinGW i686). Build outputs and the FFXiMain.dll copy go to
# CR_TEST_OUT (default: a temp folder), never into the repo; the game install is only read (assets),
# never loaded.
#   sh plugin/test/build_test.sh
#
# The generic pieces (hook_test, hook_client, the cr_testhost Lua host, the nui sync check) live with
# the drawing library's own tests; this script runs them into the same out folder, then Chronicle's:
#   test_e2e.lua    _chronicle.dll + a real D3D8 device through the patched wrapper (needs
#                   libs/_chronicle.dll, or CR_DLL=<path to another build>); with a second module's
#                   libs/_nui.dll (UiHook 2) present, found through CR_SECOND_MODULE, that it joins and draws beside Chronicle; with
#                   the library's pre-release ABI 1 test module (mods/mod_x0.dll, the frozen header),
#                   that it is refused when Chronicle patched first, and (mode abi1_first, its own
#                   process) that Chronicle fails for good, without a retry, when it patched first
#   test_perf.lua   the performance budgets (2026-10-22): the handlers the game thread waits for (0x055, add item,
#                   refresh, hover, wheel, drags, resize), allocation, the heap; then each --fault run (one piece of
#                   the old behaviour put back, in the test only) must fail on its own tag, with no Lua error
set -e
cd "$(dirname "$0")"
GXX="${CR_GXX:-i686-w64-mingw32-g++}"
LUA="${CR_LUA:-/c/Program Files (x86)/Lua/5.1/lua.exe}"
OUT="${CR_TEST_OUT:-${TEMP:-/tmp}/chronicle_test}"
# The generic half of these tests belongs to the drawing library. Point CR_NUI at a clone of
# https://github.com/jintawk/nui (default: a sibling of this repository), and CR_FFXI_COPY at an
# unpacked copy of FFXiMain.dll, which cannot be shipped.
NUI_TEST="${CR_NUI:-../../../nui}/test"
if [ ! -f "$NUI_TEST/build_test.sh" ]; then
    echo "cannot find the nui library's tests at $NUI_TEST" >&2
    echo "clone https://github.com/jintawk/nui and set CR_NUI to it" >&2
    exit 2
fi
if [ -z "${CR_FFXI_COPY:-}" ]; then
    echo "set CR_FFXI_COPY to an unpacked copy of FFXiMain.dll (never the one in your install)" >&2
    exit 2
fi
NUI_DLL="${CR_DLL:-}" NUI_GXX="$GXX" NUI_TEST_OUT="$OUT" NUI_FFXI_COPY="$CR_FFXI_COPY" sh "$NUI_TEST/build_test.sh"
echo "== test_e2e"
cd ../..
"$LUA" test/test_e2e.lua "$(cygpath -w "$OUT/ffxi/FFXiMain.dll")" "$(cygpath -m "$OUT")"
echo "== test_e2e abi1_first"
"$LUA" test/test_e2e.lua "$(cygpath -w "$OUT/ffxi/FFXiMain.dll")" "$(cygpath -m "$OUT")" abi1_first
echo "== test_perf"
"$LUA" test/test_perf.lua "$(cygpath -w "$OUT/ffxi/FFXiMain.dll")" "$(cygpath -m "$OUT")"
echo "== test_perf faults (each must fail on its own tag)"
for ft in memo:memo skip:skip tokens:alloc ops:alloc resize:resize coalesce:drag bands:bands docs:docs known:known heap:heap slow:time; do
    f="${ft%%:*}"; tag="${ft#*:}"
    if log="$("$LUA" test/test_perf.lua "$(cygpath -w "$OUT/ffxi/FFXiMain.dll")" "$(cygpath -m "$OUT")" --fault "$f" 2>&1)"; then
        echo "  fault $f: NOT CAUGHT (the run passed)"; exit 1
    fi
    if echo "$log" | grep -qE "lua.exe: |attempt to "; then
        echo "$log" | grep -E "lua.exe: |attempt to " | head -3; echo "  fault $f: a Lua error, not a budget"; exit 1
    fi
    if ! echo "$log" | grep -q "^FAIL \[$tag\]"; then
        echo "$log" | grep "^FAIL" | head -3; echo "  fault $f: failed, but not on [$tag]"; exit 1
    fi
    echo "  fault $f: caught on [$tag] ($(echo "$log" | grep -c '^FAIL') budgets failed)"
done
echo "== icons vs an independent reference decoder (CR_ICON_REF=<dir holding prep_assets.py>;"
echo "   needs python + Pillow; skipped without either)"
REF="$OUT/icons"
mkdir -p "$REF"
if python -c "import PIL" 2>/dev/null && [ -n "$CR_ICON_REF" ] && [ -f "$CR_ICON_REF/prep_assets.py" ]; then
    python -c "
import os, sys; sys.path.insert(0, os.environ['CR_ICON_REF']); import prep_assets as p
for i in (1, 4165, 12345, 16384, 20000, 28000):
    im = p.item_icon(i)
    if im is not None: open(sys.argv[1] + '/%d.raw' % i, 'wb').write(p.bgra(im))
" "$(cygpath -m "$REF")"
    "$LUA" -e "
package.cpath = './libs/?.dll;' .. package.cpath
package.preload['_chronicle'] = dofile('test/crdll.lua').loader()
local N = require('_chronicle')
N.start([[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]])
local pass, fail = 0, 0
for _, i in ipairs({1, 4165, 12345, 16384, 20000, 28000}) do
    local f = io.open('$(cygpath -m "$REF")/' .. i .. '.raw', 'rb')
    if f then
        local same = N.icon_pixels(i) == f:read('*a')
        f:close()
        if same then pass = pass + 1 else fail = fail + 1 print('FAIL icon ' .. i) end
    end
end
print(('test_icons: %d passed, %d failed'):format(pass, fail))
os.exit(fail == 0 and 0 or 1)"
fi
