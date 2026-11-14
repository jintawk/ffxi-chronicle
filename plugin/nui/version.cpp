// version.cpp - puts the library version and source-tree hash in every DLL built from it, as one
// string ("NUI-TAG:<version>:<tree sha256>"), so `python sync.py status` can tell which
// source a built DLL came from with a byte search (no load). nui_version.h is written by sync.py.
#include "nui_version.h"

extern "C" {
__attribute__((used)) const char nui_build_tag[] = NUI_TAG;
}
