#!/bin/sh
# Build libs/_chronicle.dll (32-bit, MinGW-w64 i686, static runtime).
#   sh plugin/build.sh
# CR_GXX=<g++> overrides the compiler; CR_OUT=<path> builds elsewhere (the game locks
# libs/_chronicle.dll while the addon is loaded: build to another path, unload, copy over).
# The drawing library is the vendored copy in plugin/nui (upstream: github.com/jintawk/nui, in the
# nui repository, `python sync.py`), every nui/*.cpp; ChronicleModule.cpp is this
# addon's glue (nui/host.cpp does the work).
set -e
cd "$(dirname "$0")"
GXX="${CR_GXX:-i686-w64-mingw32-g++}"
OUT="${CR_OUT:-../libs/_chronicle.dll}"
mkdir -p "$(dirname "$OUT")"
"$GXX" -std=c++17 -O2 -m32 -shared -Wall -Wextra -Inui ChronicleModule.cpp nui/*.cpp exports.def \
    -o "$OUT" -s -static -static-libgcc -static-libstdc++
echo "built $OUT"
