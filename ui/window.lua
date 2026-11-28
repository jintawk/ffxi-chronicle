--[[
    Chronicle: the main window, drawn as four layers of _chronicle.dll.

        1 chrome   frame, header, toolbar (window-local; re-sent when it changes or is hovered)
        2 content  the screen's body in content coordinates; scrolled and clipped by layer_pos, so
                   scrolling and moving never re-send it
        3 overlay  hover highlight, scrollbar, tooltip, resize grip (small; re-sent on hover)
        4 popup    an enlarged picture

    A screen is a table with
        S.chrome(b, ctx)   draw the frame and header into builder b; return the viewport
                           {x0, y0, x1, y1} (window-local) or nil, and the header height that drags
        S.content(b, ctx)  draw the body at content coordinates (0, 0 = the viewport's top-left);
                           return its height and, optionally, block tops for keeping the reading place
        S.overlay(b, ctx, hit, to_win)   optional: draw the hover for a content hit
        S.click(hit, ctx, app), S.right(hit, ctx, app), S.key(...)   optional
    Hits carry `id`; content hits are in content coordinates.

    Input is in Lua units (the caller divides by the view scale). Moves are never consumed; clicks,
    wheel, right clicks and drags over the window are. A press fires on release over the same
    target. A resize applies at most once a frame (tick), re-laying the content out only when the
    width changed, and keeps the block at the top of the viewport where it was.

    Performance (2026-10-22 pass). The game thread waits for every mouse, keyboard and packet event Chronicle handles, so the
    work in them is kept small:
      - a layer whose text is the text it was last sent is not sent again (send; W.SKIP_SAME). A 0x055 or the 0x056 refresh that
        changes nothing on the page costs no parse in the DLL. W:resend() forgets what was sent (a new look or scale).
      - while resizing, the content is laid out again at most every W.RESIZE_S seconds (the first change of width at once); the
        frame and grip follow every frame; the release lays it out at the final width, so the end state is exact.
      - a thumb drag or a window drag records where the mouse wants the page or window and W:tick applies the last one once a
        frame; the release applies what is pending first. A wheel notch applies at once when it is the first thing to move the
        page this frame (the layer follows the wheel in the same event), further notches in the same frame only change the
        scroll and are drawn by W:tick (W.COALESCE = false: everything at once, the behaviour before).
      - content hits are found through 32 px bands of content y, built once per layout (hit_at; W.BANDS), the same answers as
        the scan of every hit.

    The controller (2.2.0). While the pad is Chronicle's, one hit is the cursor (W.cursor; ui/nav.lua moves it) and it is the
    hover, so every screen's hover drawing shows it; the overlay adds a frame round it and a line of button hints in the bottom
    margin. A mouse move of more than 3 px over the window gives the hover back to the mouse until the next pad action. The
    cursor is kept by a key without coordinates (nav.key), so a re-layout finds it again, and going back finds the one the
    screen was left with (App:go keeps it on the stack).]]

local ops = require('ui/ops')
local kit = require('ui/kit')
local nav = require('ui/nav')

local W = {}
W.__index = W

local WHEEL = 54                -- px per wheel notch (three lines)
local DRAG_THRESHOLD = 5
local MIN_W, MIN_H = 480, 360
local COLLAPSED_H = 46

local L_CHROME, L_CONTENT, L_OVERLAY, L_POPUP = 1, 2, 3, 4

-- mouse event types (the window message - 0x200): presses and double clicks per button (left 1, right 4, middle 7), releases
local PRESS = {[1] = 1, [3] = 1, [4] = 4, [6] = 4, [7] = 7, [9] = 7}
local RELEASE = {[2] = 1, [5] = 4, [8] = 7}

W.SKIP_SAME = true          -- false: every flush sends its layers, changed or not
W.RESIZE_S = 0.1            -- the content's re-layout while resizing, at most this often (0: every frame)
W.COALESCE = true           -- false: drags and wheel notches apply inside their mouse event
W.BANDS = true              -- false: hit_at scans every content hit
local BAND = 32

-- native: the DLL's table (layer, layer_pos); opts.place: {x, y, w, h}
function W.new(native, opts)
    opts = opts or {}
    local self = setmetatable({}, W)
    self.N = native
    self.x, self.y = opts.x or 200, opts.y or 150
    self.w, self.h = opts.w or 620, opts.h or 760
    self.screen_w, self.screen_h = opts.screen_w or 3840, opts.screen_h or 2160
    self.visible = false
    self.collapsed = false
    self.scroll = 0
    self.dirty = {chrome = true, content = true, overlay = true, pos = true}
    self.hover, self.pressed, self.drag, self.resize = nil, nil, nil, nil
    self.focus = nil
    self.keys_down = {}                     -- key-downs the search box took: only their key-ups are swallowed (review UI-4)
    self.down = {}                          -- mouse buttons whose press the window took: only their releases are acted on (review LIFE-2)
    self.caret, self.next_caret = true, 0
    self.on_place = opts.on_place           -- called after a move / resize ends
    self.stats = {sent = {0, 0, 0, 0}, content_ms = 0, layouts = 0, skipped = 0, applied = 0}
    -- per layer: the text and z the DLL holds (send skips sending the same again). Kept by a wrapper around the DLL's layer(), so
    -- a layer anyone else sends or clears through the same table (test/qa_render.lua clears layers between its dumps) is known too
    self.sent_text, self.sent_z = {}, {}
    if native and native.layer then
        local real, me = native.layer, self
        native.layer = function(id, z, text, ...)
            local a, b = real(id, z, text, ...)
            if z == nil or not a then me.sent_text[id], me.sent_z[id] = nil, nil
            else me.sent_text[id], me.sent_z[id] = text, z end
            return a, b
        end
    end
    self.want = nil                         -- a drag's pending place {x, y} or scroll {scroll}, applied once a frame (W:tick)
    self.moved = false                      -- something already moved the page / window this frame (the wheel's first notch)
    self.app = opts.app
    return self
end

function W.clamp_size(w, h, sw, sh)
    w = math.max(MIN_W, math.min(math.floor(w), sw or 1e9))
    h = math.max(MIN_H, math.min(math.floor(h), sh or 1e9))
    return w, h
end

function W:set_screen_size(sw, sh)
    self.screen_w, self.screen_h = sw, sh
    self.w, self.h = W.clamp_size(self.w, self.h, sw, sh)
    self.x = math.max(0, math.min(self.x, sw - 60))
    self.y = math.max(0, math.min(self.y, sh - 40))
    self:invalidate('all')
end

-- Show a screen. params are kept on the screen's own state; scroll restores a place.
function W:set_screen(S, scroll, cursor)
    self.S = S
    self.scroll = scroll or 0
    if self.picture then self:close_picture() end      -- the popup belongs to the screen it was opened on (review UI-5)
    self.hover, self.pressed = nil, nil
    -- the controller's cursor: the one this screen was left with (back), else the first target in view (W:pad_refind)
    self.cursor, self.cursor_key, self.cursor_zone, self.cursor_pick, self.parked_at = nil, cursor, 'body', true, nil
    if self.focus and not (S.focusable and S.focusable[self.focus]) then self.focus = nil end
    self:invalidate('all')
end

function W:invalidate(what)
    if what == 'all' then
        self.dirty.chrome, self.dirty.content, self.dirty.overlay, self.dirty.pos = true, true, true, true
    else
        self.dirty[what] = true
        if what == 'content' or what == 'chrome' then self.dirty.overlay = true end
    end
end

function W:ctx()
    return {w = self.w, h = self.collapsed and COLLAPSED_H or self.h, collapsed = self.collapsed,
            hover = self.hover, pressed = self.pressed, focus = self.focus, caret = self.caret,
            scroll = self.scroll, vh = self.vp and (self.vp.y1 - self.vp.y0) or 0,
            vw = self.vp and (self.vp.x1 - self.vp.x0) or 0,
            screen_w = self.screen_w, screen_h = self.screen_h, app = self.app, win = self}
end

local function clock_ms() return os.clock() * 1000 end

-- content coordinates -> window-local
function W:to_win(x, y) return self.vp.x0 + x, self.vp.y0 + y - self.scroll end

-- Send a layer, unless it is the text (and z) the DLL holds for it already: Lua 5.1 interns strings, so the compare is a pointer
-- compare. The DLL keeps a layer until it is cleared (forget) and rebuilds every layer itself on a window type change, and a texture
-- handle is never reused (nui's tex_load numbers them up), so the same text always draws the same pixels.
local function send(self, id, z, b)
    local text = b:text_out()
    if W.SKIP_SAME and self.sent_text[id] == text and self.sent_z[id] == z then
        self.stats.skipped = self.stats.skipped + 1
        return true
    end
    local ok, why = self.N.layer(id, z, text)        -- the wrapper (W.new) records what the DLL now holds
    self.stats.sent[id] = self.stats.sent[id] + 1
    if not ok then self.last_error = why end
    return ok
end

-- clear a layer in the DLL (the wrapper forgets its text: the next send of it goes whatever it says)
local function forget(self, id)
    self.N.layer(id)
end

-- Send every layer again on the next flush, the same text or not (a change the DLL may not have seen: the view scale, a restyle).
function W:resend()
    self.sent_text, self.sent_z = {}, {}
    self:invalidate('all')
end

-- The scroll the content allows.
function W:clamp_scroll()
    local vh = self.vp and (self.vp.y1 - self.vp.y0) or 0
    self.scroll = math.max(0, math.min(self.scroll, math.max(0, (self.content_h or 0) - vh)))
end

-- The drag the mouse events recorded (W.COALESCE): the last wanted scroll (thumb) or place (header), applied here, once.
function W:apply_want()
    local s, x = self.want_scroll, self.want_x
    if s then
        self.want_scroll = nil
        self:scroll_to(s)
        self.stats.applied = self.stats.applied + 1
    end
    if x then
        self.x, self.y = x, self.want_y
        self.want_x, self.want_y = nil, nil
        self.dirty.pos = true
        self.pure_move = true
        self.stats.applied = self.stats.applied + 1
    end
end

-- Send what changed. Called after every event that may change something.
function W:flush()
    if not self.visible or not self.S then return end
    if self.want_scroll or self.want_x then self:apply_want() end
    self.pending = nil
    local d = self.dirty
    local rebuilt = d.chrome or d.content
    if d.chrome then
        local b = ops.new()
        local vp, drag_h = self.S.chrome(b, self:ctx())
        if not self.collapsed then kit.grip_hits(b, self.w, self.h) end
        self.chrome_b, self.drag_h = b, drag_h or 40
        local vw_old = self.vp and (self.vp.x1 - self.vp.x0)
        self.vp = (not self.collapsed) and vp or nil
        if self.vp and vw_old ~= (self.vp.x1 - self.vp.x0) then
            -- a new width: the content is laid out again, unless a resize laid it out less than W.RESIZE_S ago (W:tick does it then)
            if self.resize and self.resize.hold then self.content_wait = true else d.content = true end
        end
        send(self, L_CHROME, 0, b)
        d.chrome = false
        d.pos = true
        self.pure_move = nil
    end
    if d.content then
        if self.vp and self.S.content then
            local t0 = clock_ms()
            local anchor = self.keep_place and self.blocks and self:anchor()
            local b = ops.new()
            local h, blocks = self.S.content(b, self:ctx())
            self.content_b, self.content_h, self.blocks = b, h or 0, blocks
            self.stats.content_ms = clock_ms() - t0
            self.stats.layouts = self.stats.layouts + 1
            if self.resize then self.resize.laid = t0 / 1000 end
            if anchor then self.scroll = self:scroll_for(anchor) end
            self:clamp_scroll()
            send(self, L_CONTENT, 1, b)
        else
            self.content_b, self.content_h, self.blocks = nil, 0, nil
            forget(self, L_CONTENT)
        end
        self.keep_place = nil
        self.content_wait = nil
        d.content = false
        d.pos = true
        d.overlay = true
        self.pure_move = nil
    end
    -- the cursor's hit is a new table after a layout: found again by its key; a cursor that moved onto or off the chrome
    -- draws the chrome again (once: the second find is the same key, and changes nothing)
    if rebuilt and self.pad_mode then
        self:pad_refind()
        if d.chrome then return self:flush() end
    end
    if d.pos then
        self.N.layer_pos(L_CHROME, self.x, self.y)
        if self.content_b and self.vp then
            local vp = self.vp
            self:clamp_scroll()
            self.N.layer_pos(L_CONTENT, self.x + vp.x0, self.y + vp.y0 - self.scroll,
                0, self.scroll, vp.x1 - vp.x0, self.scroll + vp.y1 - vp.y0)
        end
        d.pos = false
        -- only the window moved (a header drag): the overlay is window-local and the same, unless it shows a button's tooltip (its
        -- width depends on the room to the screen's right edge) or the scroll moved under it; it is only placed again
        local h = self.hover
        if self.pure_move and not d.overlay and self.overlay_b and self.scroll == self.overlay_scroll
            and not (h and h.tip and not h.content and not self.pressed) then
            self.N.layer_pos(L_OVERLAY, self.x, self.y)
        else
            d.overlay = true
        end
    end
    self.pure_move = nil
    if d.overlay then
        local b = ops.new()
        if self.vp then
            local vp = self.vp
            -- the scrollbar sits in the right margin, between the content and the frame, so the
            -- content keeps the same margin on both sides whether it scrolls or not
            self.thumb = kit.scrollbar(b, self.w - 14, vp.y0, math.min(vp.y1, self.h - 26), vp.y1 - vp.y0,
                self.content_h or 0, self.scroll)
            if self.hover and self.hover.content and self.S.overlay then
                b:clip(vp.x0 - 4, vp.y0, vp.x1 + 2, vp.y1)
                self.S.overlay(b, self:ctx(), self.hover, function(x, y) return self:to_win(x, y) end)
                b:unclip()
                if self.S.tooltip then self.S.tooltip(b, self:ctx(), self.hover, function(x, y) return self:to_win(x, y) end) end
            end
            if self.S.sticky then self.S.sticky(b, self:ctx()) end
            kit.grip(b, self.w, self.h, self.resize ~= nil, self.hover and self.hover.resize ~= nil)
            if self.pad_mode and self.pad_hint then
                b:text(20, self.h - 18, kit.C.faint, ops.fit(self.pad_hint, self.w - 64))
            end
        end
        if self.pad_mode and self.cursor then self:pad_draw(b) end
        local h = self.hover
        if h and h.tip and not h.content and not self.pressed then
            kit.tooltip(b, h.x0, h.y1 + 6, h.tip, {}, nil, self.screen_w - self.x, self.screen_h - self.y, h.y0)
        end
        self.overlay_b = b
        self.overlay_scroll = self.scroll
        send(self, L_OVERLAY, 2, b)
        self.N.layer_pos(L_OVERLAY, self.x, self.y)
        d.overlay = false
    end
end

function W:show()
    self.visible = true
    self:invalidate('all')
    self:flush()
end

function W:hide()
    self.visible = false
    self.hover, self.pressed, self.drag, self.resize, self.focus = nil, nil, nil, nil, nil
    self.want_scroll, self.want_x, self.want_y, self.pending, self.content_wait = nil, nil, nil, nil, nil
    self.picture, self.thumb_drag, self.down = nil, nil, {}     -- the popup layer is cleared below (review UI-5)
    self.pad_mode, self.cursor, self.pad_held, self.holders = false, nil, false, nil
    for id = L_CHROME, L_POPUP do forget(self, id) end
end

function W:toggle_collapse()
    self.collapsed = not self.collapsed
    self:invalidate('all')
    self:flush()
end

-- reading place: the block at the top of the viewport and how far into it
function W:anchor()
    local n = 1
    for i, y in ipairs(self.blocks) do if y <= self.scroll then n = i else break end end
    return {block = n, into = self.scroll - (self.blocks[n] or 0)}
end
function W:scroll_for(a)
    local y0 = self.blocks[a.block] or 0
    local y1 = self.blocks[a.block + 1] or self.content_h or y0
    return y0 + math.max(0, math.min(a.into, y1 - y0))
end

function W:scroll_to(y)
    self.scroll = y
    self:clamp_scroll()
    self.dirty.pos = true
    -- a screen whose drawing depends on what is in view (a walkthrough's pictures: textures only for those near it) says so
    if self.S and self.S.scrolled and self.content_b and self.S.scrolled(self:ctx()) then
        self.keep_place = true
        self:invalidate('content')
    end
end

-- hits ----------------------------------------------------------------------------------------------

local function inside(h, x, y) return x >= h.x0 and x < h.x1 and y >= h.y0 and y < h.y1 end

-- the hit under window-local (lx, ly): chrome (resize edges first), then content inside the viewport
function W:hit_at(lx, ly)
    local ob = self.overlay_b                -- sticky bars over the content
    if ob then
        for i = #ob.hits, 1, -1 do
            local h = ob.hits[i]
            if inside(h, lx, ly) then return h end
        end
    end
    local cb = self.chrome_b
    if cb then
        for i = #cb.hits, 1, -1 do
            local h = cb.hits[i]
            if h.resize and inside(h, lx, ly) then return h end
        end
        for i = #cb.hits, 1, -1 do
            local h = cb.hits[i]
            if not h.resize and inside(h, lx, ly) then return h end
        end
    end
    local vp = self.vp
    if vp and self.content_b and lx >= vp.x0 and lx < vp.x1 and ly >= vp.y0 and ly < vp.y1 then
        local cx, cy = lx - vp.x0, ly - vp.y0 + self.scroll
        local hits = self.content_b.hits
        if W.BANDS then
            -- the content hits by 32 px bands of y, each band in the hits' order, built at the first look after a layout: a hit
            -- holding cy is in band floor(cy / 32) (it is listed in every band from floor(y0 / 32) to floor(y1 / 32)), so the
            -- reverse scan of the band finds what the reverse scan of every hit finds
            if self.band_b ~= self.content_b then
                local idx, floor = {}, math.floor
                for i = 1, #hits do
                    local h = hits[i]
                    for k = floor(h.y0 / BAND), floor(h.y1 / BAND) do
                        local l = idx[k]
                        if not l then l = {} idx[k] = l end
                        l[#l + 1] = h
                    end
                end
                self.band_b, self.bands = self.content_b, idx
            end
            hits = self.bands[math.floor(cy / BAND)]
            if not hits then return nil end
        end
        for i = #hits, 1, -1 do
            local h = hits[i]
            if inside(h, cx, cy) then
                h.content = true
                return h
            end
        end
    end
    return nil
end

-- a hit's identity that survives a re-render (the chrome is rebuilt while a button is pressed)
local function key_of(h)
    if not h then return nil end
    if h.resize then return 'resize:' .. h.resize end
    if not h.key_s then
        local what = h.key or h.area or (h.item and (h.item.id or h.item.name)) or h.name or h.to or h.file or ''
        h.key_s = table.concat({h.content and 'c' or 'w', tostring(h.id), tostring(h.i or ''), tostring(what),
            tostring(h.step or ''), tostring(h.dir or ''), tostring(h.x0), tostring(h.y0)}, '|')
    end
    return h.key_s
end
W.key_of = key_of

function W:over(x, y)
    local h = self.collapsed and COLLAPSED_H or self.h
    return x >= self.x and x < self.x + self.w and y >= self.y - 6 and y < self.y + h
end

-- -> consumed
function W:mouse(t, x, y, delta, blocked)
    if not self.visible or not self.S then return false end
    -- a press, release or wheel sees the drag the moves of this frame recorded (W:tick would apply it at the frame's end)
    if t ~= 0 and (self.want_scroll or self.want_x) then self:flush() end
    local lx, ly = x - self.x, y - self.y
    local mp = self.mouse_px
    if mp then mp[1], mp[2] = x, y else self.mouse_px = {x, y} end
    if t == 0 then
        -- the controller has the hover: a jiggle of the mouse leaves it there; a real move gives it back to the mouse
        if self.pad_mode then
            local pm = self.pad_mouse
            if not pm then pm = {x, y} self.pad_mouse = pm end
            if not self:over(x, y) then pm[1], pm[2] = x, y return false end      -- elsewhere on the screen: not ours
            if (x - pm[1]) ^ 2 + (y - pm[2]) ^ 2 <= 9 then return false end
            self:pad_to_mouse()
        end
        if self.resize then
            local r = self.resize
            local w = r.mode:find('x') and r.vw + x - r.sx or self.w
            local h = r.mode:find('y') and r.vh + y - r.sy or self.h
            r.want = {W.clamp_size(w, h, self.screen_w - self.x, self.screen_h - self.y)}
            return false
        end
        if self.thumb_drag then
            local td = self.thumb_drag
            local vh = self.vp.y1 - self.vp.y0
            local track = td.track
            if track > 0 then
                local s = td.scroll + (y - td.sy) * (self.content_h - vh) / track
                if W.COALESCE then
                    self.want_scroll = s            -- W:tick applies the last one, once a frame
                else
                    self:scroll_to(s)
                    self:flush()
                end
            end
            return false
        end
        if self.drag then
            local d = self.drag
            if not d.moving and (x - d.sx) ^ 2 + (y - d.sy) ^ 2 >= DRAG_THRESHOLD ^ 2 then d.moving = true end
            if d.moving then
                local nx = math.max(-self.w + 60, math.min(d.vx + x - d.sx, self.screen_w - 60))
                local ny = math.max(0, math.min(d.vy + y - d.sy, self.screen_h - 30))
                if W.COALESCE then
                    self.want_x, self.want_y = nx, ny       -- W:tick applies the last one, once a frame
                else
                    self.x, self.y = nx, ny
                    self.dirty.pos = true
                    self:flush()
                end
            end
            return false
        end
        local h = self:hit_at(lx, ly)
        -- the tooltip is anchored at the mouse, so the mouse is recorded before the flush that draws it
        if h and h.content then
            local m = self.mouse_at
            if m then m.x, m.y = lx, ly else self.mouse_at = {x = lx, y = ly} end
        end
        if key_of(h) ~= key_of(self.hover) then
            local was = self.hover
            self.hover = h
            if (was and not was.content and not was.resize and not was.sticky) or (h and not h.content and not h.resize and not h.sticky) then
                self.dirty.chrome = true
            end
            self.dirty.overlay = true
            self:flush()
        end
        return false
    end
    local over = self:over(x, y)
    local h = self:hit_at(lx, ly)
    local press, release = PRESS[t], RELEASE[t]
    -- a press outside the window takes the search box's focus away, whether or not another addon blocked it (review UI-4)
    if press == 1 and self.focus and not over and not (h and h.resize) then
        self.focus = nil
        self.dirty.chrome = true
        self:flush()
    end
    -- a release is the window's only when its press was (review LIFE-2): the game keeps every release of a press it saw
    if release then
        local mine = self.down[release]
        self.down[release] = nil
        if not mine then return false end
    elseif press then
        self.down[press] = nil
        if blocked then return false end
        local took = self:press(t, x, y, lx, ly, over, h)
        if took then self.down[press] = true end
        return took
    elseif blocked and not self.drag and not self.pressed and not self.resize and not self.thumb_drag then
        return false
    end

    if t == 10 then
        if not over or self.collapsed then return false end
        local n = (delta or 0) > 0 and 1 or ((delta or 0) < 0 and -1 or 0)
        self:scroll_to(self.scroll - n * WHEEL)
        self.hover = nil
        self.dirty.overlay = true
        -- the first notch of a frame is drawn at once; more in the same frame move the scroll and W:tick draws the last
        if W.COALESCE and self.moved then
            self.pending = true
        else
            self:flush()
            self.moved = true
        end
        return true
    end
    if t == 2 then
        if self.resize then
            -- the last grip move is applied (frame, grip, place); a content layout it needs is left to the next prerender pass
            -- (W:tick), so the release does not wait for a layout (13.8 ms on assault 52): the end state is exact a frame later
            self.resize.release = true
            self:tick()
            self.resize = nil
            self.dirty.overlay = true
            self:flush()
            if self.on_place then self.on_place(self) end
            return true
        end
        if self.thumb_drag then self.thumb_drag = nil return true end
        local was = self.pressed
        self.pressed = nil
        if self.drag then
            local moved = self.drag.moving
            self.drag = nil
            if moved then
                if self.on_place then self.on_place(self) end
                return true
            end
        end
        if was and not was.content then self.dirty.chrome = true end
        if self.picture then
            self:close_picture()
            return true
        end
        if h and was and key_of(h) == key_of(was) and self.S.click then
            self.S.click(h, self:ctx(), self.app)
        end
        self:flush()
        return true
    end
    if t == 5 then
        if self.picture then self:close_picture() return true end
        if over and self.S.right then self.S.right(h, self:ctx(), self.app) self:flush() end
        return true
    end
    return release ~= nil or over
end

-- a press (W:mouse's PRESS types) -> taken. Only a left press (1) does anything here; the others are taken over the window.
function W:press(t, x, y, lx, ly, over, h)
    if self.picture and PRESS[t] ~= 7 then return true end     -- any click closes the enlarged picture (on its release)
    if t ~= 1 then return over end
    if not over and not (h and h.resize) then return false end
    if h and h.resize then
        self.resize = {mode = h.resize, sx = x, sy = y, vw = self.w, vh = self.h}
        self.dirty.overlay = true
        self:flush()
        return true
    end
    if self.thumb and lx >= self.thumb.x0 and lx < self.thumb.x1 and ly >= self.thumb.y0 and ly < self.thumb.y1 then
        local th = self.thumb
        if ly < th.thumb0 or ly >= th.thumb1 then
            -- a click on the track jumps there (the track the scrollbar drew, which can be shorter than the viewport)
            local vh = self.vp.y1 - self.vp.y0
            self:scroll_to((ly - th.y0) / (th.y1 - th.y0) * self.content_h - vh / 2)
            self:flush()
            th = self.thumb
        end
        -- the thumb moves over the track less its own length (review UI-6: not over the viewport's height, which is longer)
        self.thumb_drag = {sy = y, scroll = self.scroll, t0 = th.thumb0, t1 = th.thumb1,
                           track = (th.y1 - th.y0) - (th.thumb1 - th.thumb0)}
        return true
    end
    local focus = h and h.id == 'search' and 'search' or nil
    if focus ~= self.focus then
        self.focus = focus
        self.caret, self.next_caret = true, 0
        self.dirty.chrome = true
    end
    self.pressed = h or false
    if not h and ly < (self.drag_h or 40) then
        self.drag = {sx = x, sy = y, vx = self.x, vy = self.y, moving = false}
    end
    if h and not h.content then self.dirty.chrome = true end
    self:flush()
    return true
end

-- once a frame: a pending resize (re-lays the content out only on a new width, at most every W.RESIZE_S while the grip moves), the
-- drag the mouse moves recorded, wheel notches after the first of the frame, the caret
function W:tick(now)
    now = now or os.clock()
    self.moved = false
    local r = self.resize
    if r and r.want then
        local w, h = r.want[1], r.want[2]
        r.want = nil
        if w ~= self.w or h ~= self.h then
            if w ~= self.w then self.keep_place = true end
            self.w, self.h = w, h
            r.hold = r.release or (W.RESIZE_S > 0 and r.laid ~= nil and now - r.laid < W.RESIZE_S)
            self.dirty.chrome = true
            self:flush()
        end
    end
    if self.content_wait and not (r and (r.release or (r.laid and now - r.laid < W.RESIZE_S))) then
        if r then r.hold = false end
        self.dirty.content = true
        self:flush()
    end
    if self.want_scroll or self.want_x or self.pending then self:flush() end
    if now and self.focus and now >= self.next_caret then
        self.next_caret = now + 0.5
        self.caret = not self.caret
        self.dirty.chrome = true
        self:flush()
    end
end

-- an enlarged picture over everything (layer 4); any click closes it
function W:open_picture(b)
    self.picture = true
    self.N.layer(L_POPUP, 3, b:text_out())
    self.N.layer_pos(L_POPUP, 0, 0)
end
function W:close_picture()
    self.picture = nil
    self.N.layer(L_POPUP)
end

-- keyboard: the focused search box takes every key pressed while it has focus, and the release of each key it took (review UI-4:
-- a key held before the box took focus is released to the game; one the box took is swallowed even after the focus went)
function W:key(dik, down, ch)
    if not down then
        if not self.keys_down[dik] then return false end
        self.keys_down[dik] = nil
        return true
    end
    if not self.visible or not self.focus or not self.S.key then return false end
    self.keys_down[dik] = true
    local keep = self.S.key(self.focus, dik, ch, self:ctx(), self.app)
    if keep == false then self.focus = nil end
    self.caret, self.next_caret = true, 0
    self.dirty.chrome = true
    self:flush()
    return true
end

-- the controller ---------------------------------------------------------------------------------------------------------------

W.PAD_MARGIN = 24           -- a target scrolled into view keeps this much room above or below it
W.PAD_REACH = 0.5           -- a target further than this many viewports beyond the view is not jumped to: the view steps instead
W.PAD_STEP = 1 / 3          -- that step, in viewports

local function vh_of(self) return self.vp and (self.vp.y1 - self.vp.y0) or 0 end

-- the first head target in reading order (the lit tab row comes before the controls on its right)
local function first_head(T)
    local best
    for _, c in ipairs(T) do
        if c.zone == 'head' and (not best or c.y0 < best.y0 or (c.y0 == best.y0 and c.x0 < best.x0)) then best = c end
    end
    return best
end

-- Make c ({h, zone, key, x0..}, or nil) the cursor and the hover. quiet: the same target found again after a layout (nothing to
-- redraw but the overlay).
function W:pad_set(c, quiet)
    local was = self.hover
    local same = c and c.key == self.cursor_key
    if c then
        self.cursor, self.cursor_key, self.cursor_zone = c.h, c.key, c.zone
        c.h.content = c.zone == 'body' or nil
        self.cursor_at = {x = c.x0, y = c.y0}
        self.parked_at = nil
    else
        self.cursor, self.cursor_key = nil, nil
    end
    self.hover = self.cursor
    local h = self.cursor
    if h and h.content and self.vp then          -- content tooltips are anchored at the mouse: put it on the cursor
        local m = self.mouse_at or {}
        m.x, m.y = self.vp.x0 + h.x0 + 4, self.vp.y0 + h.y0 - self.scroll
        self.mouse_at = m
    end
    if not (quiet and same) and ((was and not was.content) or (h and not h.content)) then self.dirty.chrome = true end
    self.dirty.overlay = true
end

-- after a layout: the cursor's target again (by key), else the nearest one where it was, else (a new screen) the first in view
function W:pad_refind()
    local T = nav.targets(self)
    local c = nav.find(T, self.cursor_key)
    if not c and self.cursor_pick then
        local vh = vh_of(self)
        c = (self.vp and nav.first_in(T, self.scroll, self.scroll + vh)) or first_head(T)
    elseif not c and self.cursor and self.cursor_at then
        c = nav.nearest(T, self.cursor_zone, self.cursor_at.x, self.cursor_at.y)
    end
    self.cursor_pick = nil
    if c then self:pad_set(c, true) elseif self.cursor then self:pad_set(nil) end
end

-- the pad acts: the cursor shows again (after the mouse had the hover)
function W:pad_wake()
    if self.pad_mode then return end
    self.pad_mode = true
    local mp = self.mouse_px
    self.pad_mouse = mp and {mp[1], mp[2]} or nil
    if not self.cursor_key then self.cursor_pick = true end
    self:pad_refind()
    self.dirty.chrome, self.dirty.overlay = true, true
end

-- the mouse moved: it has the hover again; the cursor's key stays for the next pad action
function W:pad_to_mouse()
    self.pad_mode = false
    self.hover = nil
    self.dirty.chrome, self.dirty.overlay = true, true
end

-- an input is Chronicle's (who: 'pad' or 'keys'; hint: its line of keys) / given back. The pad and the keyboard are held on
-- their own and share the one cursor: it goes only when neither holds it
function W:pad_enter(hint, who)
    self.holders = self.holders or {}
    self.holders[who or 'pad'] = true
    self.pad_held, self.pad_hint = true, hint or self.pad_hint
    self.pad_mode = false
    self:pad_wake()
    self:flush()
end
-- the hint line follows the input that acted last
function W:pad_hint_for(hint)
    if hint and hint ~= self.pad_hint then
        self.pad_hint = hint
        self.dirty.overlay = true
    end
end
function W:pad_leave(who, other_hint)
    local hs = self.holders or {}
    hs[who or 'pad'] = nil
    if next(hs) then                      -- the other input still holds the cursor: its hint again
        self:pad_hint_for(other_hint)
        return self:flush()
    end
    self.pad_held = false
    if self.pad_mode then
        self.pad_mode = false
        if self.hover == self.cursor then self.hover = nil end
        self.dirty.chrome, self.dirty.overlay = true, true
        self:flush()
    end
end

-- scroll so a body target is in view, with W.PAD_MARGIN of room (a target taller than the view: its top)
function W:pad_reveal(c)
    if not (c and c.zone == 'body' and self.vp) then return end
    local vh = vh_of(self)
    local m = math.min(W.PAD_MARGIN, math.floor(vh / 4))
    if c.y0 < self.scroll + m then
        self:scroll_to(c.y0 - m)
    elseif c.y1 > self.scroll + vh - m then
        self:scroll_to(math.min(c.y0 - m, c.y1 - vh + m))
    end
    if self.cursor and self.cursor.content then self:pad_set(c, true) end     -- the tooltip follows the scroll
end

-- the view moved under the cursor (the right stick, a page, the wheel): a body cursor scrolled out of view moves to the first
-- target in view, or is parked (none in view) until one comes into reach
function W:pad_follow()
    if not (self.pad_mode and self.vp) or self.cursor_zone ~= 'body' then return end
    local vh = vh_of(self)
    local h = self.cursor
    -- still in view (the hit's own rectangle, while its layout stands): only the tooltip's anchor moves, no target list
    if h and h.content and self.content_b and h.y1 > self.scroll and h.y0 < self.scroll + vh then
        local m = self.mouse_at
        if m then m.y = self.vp.y0 + h.y0 - self.scroll end
        self.dirty.overlay = true
        return
    end
    -- parked, with nothing in view at the last look and the view not past it: nothing can have come into view yet
    if not h and self.parked_at and math.abs(self.scroll - self.parked_at) < 16 then return end
    local T = nav.targets(self)
    local c = nav.first_in(T, self.scroll, self.scroll + vh)
    self.parked_at = (not c) and self.scroll or nil
    self:pad_set(c)
end

-- a direction: up, down, left, right
function W:pad_move(dir)
    if not self.visible or not self.S then return end
    self:pad_wake()
    local T = nav.targets(self)
    local cur = nav.find(T, self.cursor_key)
    local vh = vh_of(self)
    if not cur then
        if self.cursor_zone == 'head' or not self.vp then
            self:pad_set(first_head(T))
            return self:flush()
        end
        -- parked in the content: the move starts from the edge of the view it leaves
        local w = self.vp.x1 - self.vp.x0
        if dir == 'up' then cur = {zone = 'body', x0 = 0, x1 = w, y0 = self.scroll + vh, y1 = self.scroll + vh + 1}
        else cur = {zone = 'body', x0 = 0, x1 = w, y0 = self.scroll - 1, y1 = self.scroll} end
    end
    local function to_win(x, y) return self:to_win(x, y) end
    if cur.zone == 'head' then
        local c = nav.pick(nav.zone(T, 'head'), cur, dir)
        if not c and dir == 'down' and self.vp then
            -- into the content: the nearest target in view below
            local vis = {}
            for _, b in ipairs(nav.zone(T, 'body', to_win)) do
                if b.y1 > self.vp.y0 and b.y0 < self.vp.y1 then vis[#vis + 1] = b end
            end
            local wc = nav.pick(vis, cur, 'down')
            c = wc and wc.src
            if not c and #vis == 0 then
                self.cursor, self.cursor_key, self.cursor_zone, self.hover = nil, nil, 'body', nil   -- parked in the content
                self.dirty.chrome, self.dirty.overlay = true, true
                return self:pad_move('down')
            end
        end
        if c then self:pad_set(c) end
        return self:flush()
    end
    local c = nav.pick(nav.zone(T, 'body'), cur, dir)
    local reach = vh * W.PAD_REACH
    local step = math.max(18, math.floor(vh * W.PAD_STEP))
    local maxs = math.max(0, (self.content_h or 0) - vh)
    if dir == 'down' then
        if c and c.y0 <= self.scroll + vh + reach then self:pad_set(c) self:pad_reveal(c)
        elseif self.scroll < maxs then self:scroll_to(self.scroll + step) self:pad_follow()
        elseif c then self:pad_set(c) self:pad_reveal(c) end
    elseif dir == 'up' then
        if c and c.y1 >= self.scroll - reach then self:pad_set(c) self:pad_reveal(c)
        elseif self.scroll > 0 then self:scroll_to(self.scroll - step) self:pad_follow()
        elseif c then self:pad_set(c) self:pad_reveal(c)
        else
            -- the top of the content: up into the header, from where the cursor is on screen
            local x0, y0 = self:to_win(cur.x0, math.max(cur.y0, self.scroll))
            local x1 = self:to_win(cur.x1, 0)
            local h = nav.pick(nav.zone(T, 'head'), {x0 = x0, y0 = y0, x1 = x1, y1 = y0 + 1}, 'up')
            if h then self:pad_set(h) end
        end
    elseif c then
        self:pad_set(c)
        self:pad_reveal(c)
    end
    self:flush()
end

-- Confirm: what a click on the cursor does (the search box takes the keyboard, as a click on it does); closes an enlarged picture
function W:pad_activate()
    if not self.visible or not self.S then return end
    if self.picture then self:close_picture() return self:flush() end
    self:pad_wake()
    local h = self.cursor
    if not h then return self:flush() end
    if h.id == 'search' then
        if self.S.focusable and self.S.focusable.search then
            self.focus = 'search'
            self.caret, self.next_caret = true, 0
            self.dirty.chrome = true
        end
        return self:flush()
    end
    if self.S.click then self.S.click(h, self:ctx(), self.app) end
    self:flush()
end

-- Cancel: closes the picture, leaves the search box, or goes back. -> 'root' when there is nowhere to go back to
function W:pad_back()
    if not self.visible or not self.S then return nil end
    if self.picture then self:close_picture() self:flush() return nil end
    if self.focus then
        self.focus = nil
        self.dirty.chrome = true
        self:flush()
        return nil
    end
    local app = self.app
    if app and app.stack and #app.stack == 0 then return 'root' end
    self:pad_wake()
    if self.S.right then self.S.right(nil, self:ctx(), app) end
    self:flush()
    return nil
end

-- a control that is not the cursor (Sort, Show, Settings, a tab): the screen's click for a hit with that id
function W:pad_click(hit)
    if not self.visible or not self.S then return end
    if self.picture then self:close_picture() end
    self:pad_wake()
    if self.S.click then self.S.click(hit, self:ctx(), self.app) end
    self:flush()
end

-- scroll by dy px (the right stick, a page, the top); the cursor follows
function W:pad_scroll(dy, absolute)
    if not self.visible or not self.vp then return end
    self:pad_wake()
    self:scroll_to(absolute and dy or (self.scroll + dy))
    self:pad_follow()
    self:flush()
end

-- the cursor's frame: round the target (every rectangle of a wrapped link), over the content's own hover
function W:pad_draw(b)
    local h = self.cursor
    local col = kit.C.press_edge
    if h.content and self.vp and self.content_b then
        local vp = self.vp
        b:clip(vp.x0 - 4, vp.y0, vp.x1 + 4, vp.y1)
        if h.span then
            for _, r in ipairs(self.content_b.hits) do
                if r.span == h.span then
                    local x0, y0 = self:to_win(r.x0, r.y0)
                    local x1, y1 = self:to_win(r.x1, r.y1)
                    kit.frame(b, x0 - 2, y0 - 1, x1 + 2, y1 + 1, col)
                end
            end
        else
            local x0, y0 = self:to_win(h.x0, h.y0)
            local x1, y1 = self:to_win(h.x1, h.y1)
            kit.frame(b, x0 - 1, y0 - 1, x1 + 1, y1 + 1, col)
        end
        b:unclip()
    elseif not h.content then
        kit.frame(b, h.x0 - 2, h.y0 - 2, h.x1 + 2, h.y1 + 2, col)
    end
end

return W
