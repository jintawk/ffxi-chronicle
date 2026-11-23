--[[
    test_pages.lua - every walkthrough page in pages/index.lua, checked the way a reader would look
    at it, so a bad page fails here instead of in game. For each page, each tab, at six window widths:

      words     every word of the page is drawn, and nothing else (layout loses nothing)
      overlap   no text is drawn over other text
      fragments no line of text is only punctuation (the "( / BLM / )" bug of 2026-10-17)
      column    no text outside the column (left or right)
      links     every link drawn has a hit area, inside the column
      tabs      switching tabs never moves the tab strip or anything drawn above it
      gap       no stretch of the page longer than 360 px without a line of text (captions aside)
      pictures  every picture block names a file the page lists
      header    every field of the page's infobox (or the open tab's) is drawn: its label, then its value on the
                same line (2026-10-19: the quest header was never drawn); on a page without tabs, a field the
                guide card shows already (core/card.lua, from Chronicle's own data) or one saying nothing
                ("None", "--") is not, and no empty box is left when none remains (the header repeated the card)
      edges     no block starts or ends with an empty line (the wiki's <p><br />text</p> spacer)
      long word a word wider than the column is broken across lines, every piece inside the column and clickable
      labels    an icon chip is words, never a file name ("Cupboard icon", "Shiva GUI", "Fei'Yin-map1") or a template's
                message ("Information Needed", "Verification Needed", "Question"), and no such name is drawn in a line of text (2026-10-19, batch 6)
      headings  no heading with nothing under it before the next heading of its level or higher / the end of its tab
      bullets   no list item with nothing in it (a bullet drawn before a picture: the wiki's empty <li>, 2026-10-20)
      boxes     no titled box with no row under it (a heading bar with nothing in it)
      arrows    no line starting with a reference's back-arrow ("1. ^" alone before the address)
      tooltips  the tooltip of every link and picture fits its box, whatever a click opens, beside the icon if it has one, and the window (rule 206)
      table     no run of 6 lines of one bare cell each ("Area / Position / Name / (K-5) / Daggao..."): a wiki table's
                rows keep their cells together (the converter's own rows check is the first line of defence)

        cd addons/chronicle && "/c/Program Files (x86)/Lua/5.1/lua.exe" test/test_pages.lua [page key]

    Prints one line per page; exits 1 if any check fails. Run it after every conversion.
]]

package.path = './?.lua;' .. package.path
local ops = require('ui/ops')
local D = require('ui/doc')
local tooltip_fit = dofile('test/tooltip_fit.lua')
local meta = require('core/meta')
local card = require('core/card')

do  -- the game's own font widths when the DLL and the install are here
    package.cpath = './libs/?.dll;' .. package.cpath
    package.preload['_chronicle'] = dofile('test/crdll.lua').loader()      -- CR_DLL: a build other than libs/_chronicle.dll
    local ok, N = pcall(require, '_chronicle')
    if ok and N then
        N.start([[C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI\]])
        ops.set_metrics(N.metrics())
    end
end

local WIDTHS = {440, 520, 600, 700, 860, 1060}     -- content widths of 480 .. 1100 px windows
local only = arg[1]
local total_fail = 0
local FAKE_PIC = {h = 99, w = 400, h_px = 300}      -- every picture present, 4:3
local HEAD_VALUE_SHARE = 0.45                       -- of the box, the value column of a header field (rule 83)
local BOX_MARGIN = 8                                  -- px of room between a box's text and its right border (rule 86)
-- the doubled-word check reads the page's own text for a doubled word with a bracket between (rule 93); false = the check before it
local PLAIN_ROWS = true      -- rule 143: a card row of a table with no header row has no title set apart from its cells; false = the check before it
local AFTER_LIST = true      -- rule 132: a card pair after a multi-line value starts a line; false = the check before it
local FAME_READ = true       -- rule 134: Required Fame is judged by its level (N/A, text, case: "levelna") and a header naming no nation cannot contradict the card's; false = the check before it
local LABEL_LINE = true      -- rule 131: a card label (all its words) and the first word of its value stand on one line; false = the check before it
local QMARK_VALUE = true                      -- rule 187: a header field whose value is only "?" is the page's own, not a broken line; false = the check before it
local SQUEEZE_COLS = 5                            -- rule 124: a table of more columns than this is not drawn at a cell margin under 8 px
local SRC_BRACKET = true
-- ... and a mark before the first of the two ("is ""Woah, woah!", acp 2: the wiki doubles the opening quote too); false = the check before rule 96
local SRC_QUOTE = true
-- an item icon in a line of text keeps the line's runs together for the fragments check (rule 108); false = the check before it
local ICON_RUNS = true
-- a word that two neighbouring cells of a table row both hold may stand twice in a row of the layout (rule 112); false = the check before it
local CELL_PAIRS = true
-- two identical icons side by side are the wiki's own (the double weather of quest wotg 33: two Thunder icons), not a word the layout doubled
-- (rule 171); false = the check before it
local ICON_TWINS = true
-- a line of two cells joined by an arrow is a row of the wiki's own typed table, not one bare cell (rule 111); false = the check before it
local ARROW_ROWS = true
local LONE_PIC = true          -- rule 150: false = no check that the only picture(s) of a box are not floated at the right of an empty box
local BOX_PIC = true           -- rule 120: false = no check that a picture in a box keeps the box's right inset
local PLUS_HOLD = true        -- rule 159: false = no check that an item's "+1" is not left alone at the start of a line
local QMARK_SPACE = true      -- rule 195: false = no check that a lone "?" (an unknown number) keeps the space before it
local RANGE_HOLD = true       -- rule 157: false = no check that a range ("21:00 - 3:00") is not broken after its dash
local QQQ_HOLD = true         -- rule 119: false = no check that "???" stays with its word
local CHIP_RUNS = true       -- rule 118: false = the chip check before 118 (a pair of chips is not a run)
-- a brace or bar the wiki prints, escaped in the page, is not markup drawn as text (rule 98); false = the check before it
local LONE_PAGE_LINK = true      -- rule 127: a section of one link to a page Chronicle does not carry is empty; false = the check before it
local SRC_BRACE = true
-- a table drawn as a card per row (rule 121) is checked against its own header: the header words are drawn as labels, once for each value they
-- label, so the words check takes them off the page's count and adds what the card says it drew; false = no such allowance (the check before 121)
local CARD_LABELS = true
local GAP = 360                                     -- px of page without a line of text
local HEAD_APART = true      -- rule 130: a heading that opens with its own picture is not drawn beside the picture of the section before it; false = the check before 130
local APART_MIN = 24         -- px of the foreign picture (and its caption) that may still stand beside such a heading

local function words_of(s, into)
    for w in ops.ascii(s or ''):gmatch('%S+') do into[w] = (into[w] or 0) + 1 end
end

-- a row of text that is only punctuation is a fragment ("( / BLM / )"); '???' is an interaction point's name in
-- FFXI, a word, with or without the full stop after it
local function fragment(s)
    s = s:gsub('%s', '')
    if s:find('%w') then return false end
    if s:match('^[%(%[]*%?%?%?[%.,;:!%)%]]*$') then return false end     -- "(???)." alone on a line (bastok 15) is the name too
    return true
end

-- the form of a word for the doubled-word check: case and punctuation dropped, except that a leading '/'
-- stays ("trade (/trade)" is a word and a slash command, not "trade trade")
local function same_form(w)
    w = w:lower()
    local lead = w:match('^%p*')
    return (lead:find('/', 1, true) and '/' or '') .. w:sub(#lead + 1):gsub('%p', '')
end

-- a label that is a file name or a template's message rather than words: "Cupboard icon", "Shiva GUI",
-- "Fei'Yin-map1", "Auction House 16", "x.png", "Crawlers_Nest", "Information Needed" / "Verification Needed" / "Question", nothing at all
local function file_like(lab)
    local l = lab:lower():gsub('%s+$', '')
    return l == '' or l == 'information needed' or l == 'verification needed' or l == 'question'     -- rule 125: the wiki's maintenance icons
        or l:find('icon$') ~= nil or l:find('gui$') ~= nil
        or l:find('[%-_ ]map%d*$') ~= nil or l:find('%s%d+$') ~= nil or l:find('%.png$') ~= nil
        or l:find('%.jpe?g$') ~= nil or l:find('%.gif$') ~= nil or l:find('_', 1, true) ~= nil
        or l:find('[%-_]flag$') ~= nil     -- rule 77: a nation's flag file ("Windurst-Flag"); the converter says the nation
end

-- does a span list hold anything a reader sees: not only breaks and blank text
local function has_ink(spans)
    for _, sp in ipairs(spans or {}) do
        if sp.t ~= 'br' and not (sp.t == 'text' and not (sp.s or ''):find('%S')) then return true end
    end
    return false
end

-- does a block hold anything a reader sees? A rule, blank paragraphs, a list of blank items and a box of such
-- blocks do not. Pictures, tabs and headings do.
local function block_ink(b)
    if b.k == 'rule' then return false end
    if b.k == 'image' or b.k == 'tabs' then return true end
    if b.k == 'list' then
        local function item_ink(it)
            if has_ink(it.spans) then return true end
            for _, c in ipairs(it.children) do if item_ink(c) then return true end end
            return false
        end
        for _, it in ipairs(b.items) do if item_ink(it) then return true end end
        return false
    end
    if b.k == 'box' then
        for _, x in ipairs(b.blocks) do if block_ink(x) then return true end end
        return false
    end
    if b.k == 'table' then
        for _, r in ipairs(b.rows) do for _, c in ipairs(r.cells) do if has_ink(c.spans) then return true end end end
        return false
    end
    return has_ink(b.spans)
end

-- every span list of the decoded page, with where it is: fn(where, spans)
local function each_spans(doc, fn)
    for _, h in ipairs(doc.head) do fn('header ' .. h.key, h.spans) end
    local function blocks(bs)
        for _, b in ipairs(bs) do
            if b.k == 'tabs' then
                for _, t in ipairs(b.tabs) do
                    for _, h in ipairs(t.head) do fn('tab header ' .. h.key, h.spans) end
                    blocks(t.blocks)
                end
            elseif b.k == 'list' then
                local function items(its) for _, it in ipairs(its) do fn('list item', it.spans) items(it.children) end end
                items(b.items)
            elseif b.k == 'box' then fn('box title', b.title) blocks(b.blocks)
            elseif b.k == 'image' then fn('caption', b.caption)
            elseif b.k == 'table' then
                for _, r in ipairs(b.rows) do for _, c in ipairs(r.cells) do fn('table cell', c.spans) end end
            elseif b.spans then fn(b.k, b.spans) end
        end
    end
    blocks(doc.blocks)
end

-- Chronicle's entry for a page, as the guide reads it: by id, else by the name the area's map gives that id. An entry that shares its name
-- with another and has no data of v1's own (outlands 164, the second "Divine Might", one wiki page, rule 140) is shown the first one's card;
-- looked up by id alone it was nil and the test judged a card of defaults (Repeatable "No") nobody sees. SHARED_NAME = false is the test before 140.
local SHARED_NAME = true
local function entry_of(cat, area, id)
    local e = meta.get(cat, area, nil, id)
    if e or not SHARED_NAME then return e end
    local ok, map = pcall(require, 'maps/' .. cat .. 's/' .. (area == 'wotg' and 'crystal_war' or area))
    local name = ok and type(map) == 'table' and map[id]
    return name and meta.get(cat, area, name, id) or nil
end

-- The guide card's fields with a real value for a page (core/card.shown over Chronicle's own entry), by the
-- page's path; a page that is not Chronicle's (a fixture) has none.
local function page_card(path)
    local cat, area, id = path:match('pages/(%a+)s/([%w_]+)/(%d+)%.lua$')
    if not cat then return {} end
    return card.shown(entry_of(cat, area, tonumber(id)))
end

-- What the guide card prints under REPEATABLE and TITLE for a page, by the test's own reading of Chronicle's entry (not
-- core/card.lua): {repeatable = the entry's value, 'No' when it has none; title = the entry's title or nil}; nil for a page that
-- is not Chronicle's (a fixture).
local function page_printed(path)
    local cat, area, id = path:match('pages/(%a+)s/([%w_]+)/(%d+)%.lua$')
    if not cat then return nil end
    local e = entry_of(cat, area, tonumber(id)) or {}
    local function str(v) return (type(v) == 'string' and v:find('%S')) and v or nil end
    local r, t = e.repeatable, e.title
    local out = {repeatable = str(r) or 'No', title = str(t)}
    -- for a tab panel's infobox (see panel_hidden below): the text of each field the card draws, read from the entry
    out.description = str(e.description)
    out.reward = str(e.reward)
    local function joined(list) if type(list) == 'table' and #list > 0 then return table.concat(list, ' ') end end
    out.previous, out.next = joined(e.previous), joined(e.next)
    out.npc = str(e.start_npc)
    if str(e.start_npc) and str(e.start_zone) then
        out.start = {e.start_npc .. ' ' .. e.start_zone}
        if str(e.start_pos) then out.start[2] = e.start_npc .. ' ' .. e.start_zone .. ' (' .. e.start_pos .. ')' end
    end
    if str(e.fame) then out.fame = {e.fame, e.fame_level and (e.fame .. ' (Lvl ' .. e.fame_level .. ')') or e.fame} end
    -- which fields the card has a value for (it prints "--" for the others)
    out.has = {description = out.description ~= nil, reward = out.reward ~= nil, title = out.title ~= nil, fame = out.fame ~= nil,
               npc = str(e.start_npc) ~= nil, zone = str(e.start_zone) ~= nil, previous = out.previous ~= nil, next = out.next ~= nil,
               requirements = type(e.requirements) == 'table' and #e.requirements > 0}
    return out
end

-- the words of a field for comparing it with what the card prints
local function norm_words(t) return (t:lower():gsub('%s+', ' '):gsub('^ ', ''):gsub(' $', ''):gsub('%.$', '')) end

-- Is an infobox field left out of a page's header? The test's own statement of the rule (not ui/doc.lua's code,
-- or the check would agree with whatever it does): the Name when it is the title; a field that is empty, "None"
-- or "--"; a field the card shows. The wiki field -> card field(s) mapping is spelled out here on purpose.
local CARD_OF = {['Required Fame'] = {'fame'}, ['Starting NPC'] = {'npc', 'zone'},
                 ['Description'] = {'description'}, ['Rewards'] = {'reward'},
                 ['Requirements'] = {'requirements'}, ['Previous Quest'] = {'previous'}, ['Next Quest'] = {'next'}}
local CHAIN_OF = {['Previous Mission'] = 'previous', ['Next Mission'] = 'next'}
local function nn(t) return ((t or ''):lower():gsub('[^%w]', '')) end
local function field_text(h)
    local t, plain = '', true
    for _, sp in ipairs(h.spans) do
        if sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' or sp.t == 'tag' then t = t .. (sp.s or '')
        elseif sp.t ~= 'br' then plain = false end
    end
    return t, plain
end
-- rule 180: the card's Requirements list is one row per item, key-item or quest-item link of that row, so a {br} line
-- of it with none of those links (a skill, a level, a rank, a condition) is in no card field and is drawn on its own;
-- a line that has one is the card's row and stays out, words and all (drawing them would name the item twice).
local function req_prose(h)
    -- a line that says nothing of its own: a quantity, an "and" or an "or", punctuation
    local function bare(w)
        w = w:lower():gsub('x%d+', ' '):gsub('%f[%a]and%f[%A]', ' '):gsub('%f[%a]or%f[%A]', ' ')
        return (w:gsub('[%s%d,;:/%+%-%.%*%(%)]', ''))
    end
    local prose, carded, words = false, false, ''
    for _, sp in ipairs(h.spans) do
        if sp.t == 'br' then
            if not carded and bare(words) ~= '' then prose = true end
            carded, words = false, ''
        elseif (sp.t == 'icon' and sp.icon == 'item')
            or (sp.t == 'link' and (sp.kind == 'item' or sp.kind == 'ki' or sp.kind == 'quest')) then carded = true
        elseif sp.t == 'icon' then words = words .. 'icon'
        else words = words .. tostring(sp.s or '') end
    end
    if not carded and bare(words) ~= '' then prose = true end
    return prose
end

-- the spans of a Requirements row the page is expected to draw under a card that lists its items: the prose lines only
local function req_shown(h)
    local function bare(w)
        w = w:lower():gsub('x%d+', ' '):gsub('%f[%a]and%f[%A]', ' '):gsub('%f[%a]or%f[%A]', ' ')
        return (w:gsub('[%s%d,;:/%+%-%.%*%(%)]', ''))
    end
    local out, line, carded, words = {}, {}, false, ''
    local function close()
        if not carded and bare(words) ~= '' then
            if #out > 0 then out[#out + 1] = {t = 'br'} end
            for _, sp in ipairs(line) do out[#out + 1] = sp end
        end
        line, carded, words = {}, false, ''
    end
    for _, sp in ipairs(h.spans) do
        if sp.t == 'br' then close()
        else
            line[#line + 1] = sp
            if (sp.t == 'icon' and sp.icon == 'item')
                or (sp.t == 'link' and (sp.kind == 'item' or sp.kind == 'ki' or sp.kind == 'quest')) then carded = true
            elseif sp.t == 'icon' then words = words .. 'icon'
            else words = words .. tostring(sp.s or '') end
        end
    end
    close()
    return out
end

local function page_hidden(h, title, shown, printed)
    local t, plain = field_text(h)
    if h.key == 'Name' then return t == title end
    local raw = t
    t = t:lower():gsub('^%s+', ''):gsub('%s+$', '')
    if plain and (t == '' or t == 'none' or t == '--' or t == 'unknown') then return true end
    -- the very text the card prints (REPEATABLE: No for an entry with no value), however the card got it
    if plain and h.key == 'Repeatable' and printed and norm_words(raw) == norm_words(printed.repeatable) then return true end
    -- a Title is the card's when it has the same letters; one that differs (a list the card cuts to its first) is drawn
    if h.key == 'Title' then return plain and printed and printed.title ~= nil and nn(raw) == nn(printed.title) or false end
    -- a mission's Previous / Next: the card's chain, left out when the card draws the very same names (the letters); a chain that
    -- differs (a mission with two ways in) is the wiki's word beside the card's and stays (2026-10-21, rule 67: toau's header
    -- drew the Series box's Previous / Next under the card's own)
    local chain = CHAIN_OF[h.key]
    if chain then return plain and printed and printed[chain] ~= nil and nn(raw) == nn(printed[chain]) or false end
    -- rule 126: an assault page's Objective or Mission Orders row that has the letters of the card's description (the intro under
    -- the title is the card's) repeats it; one that differs stays
    if h.key == 'Objective' or h.key == 'Mission Orders' then
        return plain and printed and printed.description ~= nil and nn(raw) == nn(printed.description) or false
    end
    -- rule 176: a Starting NPC row with the letters of the card's NPC, a Pack row with the letters of the card's FAME: the card draws it
    if h.key == 'Starting NPC' and plain and printed and printed.npc and nn(raw) == nn(printed.npc) then return true end
    if h.key == 'Pack' and plain and printed and printed.fame then
        for _, c in ipairs(printed.fame) do if nn(raw) == nn(c) then return true end end
    end
    local need = CARD_OF[h.key]
    if not need then return false end
    for _, k in ipairs(need) do if not shown[k] then return false end end
    -- rule 180: a Requirements line the card's item list cannot carry keeps the row (only that line is drawn)
    if h.key == 'Requirements' and req_prose(h) then return false end
    return true
end

-- Is a field of a tab panel's infobox left out? The test's own statement (not ui/doc.lua's): the Name (the tab says it); a field with the
-- very text the card prints for it (the letters and digits, whatever the case); a field with nothing in it where the card has nothing
-- ("--"). A path's own Starting NPC, Title, Previous and the like, which differ from the card's, are drawn. `printed` is nil for a page
-- that is not Chronicle's (a fixture): the card has nothing there.
local PANEL_OF = {Repeatable = 'repeatable', Title = 'title', Description = 'description', Rewards = 'reward', ['Starting NPC'] = 'start',
                  ['Required Fame'] = 'fame', ['Previous Mission'] = 'previous', ['Next Mission'] = 'next',
                  ['Previous Quest'] = 'previous', ['Next Quest'] = 'next'}
local EMPTY_OF = {Rewards = {'reward'}, Description = {'description'}, Title = {'title'}, ['Required Fame'] = {'fame'},
                  ['Starting NPC'] = {'npc', 'zone'}, Requirements = {'requirements'}, ['Previous Mission'] = {'previous'},
                  ['Next Mission'] = {'next'}, ['Previous Quest'] = {'previous'}, ['Next Quest'] = {'next'}}
-- Rule 178 (quest wotg 69, three nation tabs with quest infoboxes): as on a page header, a Starting NPC row with the letters of the card's NPC and
-- a Pack row with the letters of the card's FAME repeat the card, a key-item icon is the words "Key Item" the card prints for it ("[Key Item] Large
-- memory fragment"), and a field that says nothing and has no card field at all (Level Restriction: None) adds nothing.
local function panel_hidden(h, printed)
    if h.key == 'Name' then return true end
    local t, plain = '', true
    for _, sp in ipairs(h.spans) do
        if sp.t == 'text' or sp.t == 'link' or sp.t == 'coord' or sp.t == 'tag' then t = t .. (sp.s or '')
        elseif sp.t == 'icon' and sp.icon == 'ki' then t = t .. 'Key Item '
        elseif sp.t ~= 'br' then plain = false end
    end
    if not plain then return false end
    local low = t:lower():gsub('^%s+', ''):gsub('%s+$', '')
    if low == '' or low == 'none' or low == '--' or low == 'unknown' then
        local need = EMPTY_OF[h.key]
        if not need then return PANEL_OF[h.key] == nil and CARD_OF[h.key] == nil end
        for _, k in ipairs(need) do if printed and printed.has[k] then return false end end
        return true
    end
    if h.key == 'Starting NPC' and printed and printed.npc and nn(t) == nn(printed.npc) then return true end
    if h.key == 'Pack' and printed and printed.fame then
        for _, c in ipairs(printed.fame) do if nn(t) == nn(c) then return true end end
    end
    local card_text = printed and PANEL_OF[h.key] and printed[PANEL_OF[h.key]]
    if card_text == nil then return false end
    if type(card_text) ~= 'table' then card_text = {card_text} end
    -- rule 179 (quest other 24): "Other Fame Level: Unknown" under a card FAME "Other" is the card's fame; so is a level the card has. A field
    -- that is the card's text but for a final "s" ("Support Job" / "Support Jobs") is the card's
    if h.key == 'Required Fame' then
        local f, lvl = t:match('^(.-)%s*Fame Level:%s*(.-)%s*$')
        if f then
            for _, c in ipairs(card_text) do
                local name, clvl = c:match('^(.-)%s*%(Lvl%s*(%d+)%)%s*$')
                if nn(name or c) == nn(f) and (nn(lvl) == '' or nn(lvl) == 'unknown' or nn(lvl) == 'none' or nn(lvl) == 'na' or nn(lvl) == clvl) then
                    return true
                end
            end
        end
    end
    for _, c in ipairs(card_text) do if nn(t) == nn(c) or nn(t):gsub('s$', '') == nn(c):gsub('s$', '') then return true end end
    return false
end

-- The wiki wins where it and the card's own (v1) data disagree: a header field the drawing leaves out because the card shows it
-- must say what the card says. Judged by the real D.head_hidden (the code that decides what is drawn), against the test's own
-- reading of the entry. Repeatable: the very text the card prints; Title: the same letters; Required Fame: the nation, and the
-- level when the entry has one. (2026-10-20: ten quests said "Yes" / "Yes, after Memory reset" where the card printed "No", and the
-- header's wiki value was hidden because the card had a value.) -> a description of each, {} when none.
local function card_contradictions(path, doc, drawn_card)
    local cat, area, id = path:match('pages/(%a+)s/([%w_]+)/(%d+)%.lua$')
    local out = {}
    if not cat or doc.tabbed then return out end
    local e = entry_of(cat, area, tonumber(id)) or {}
    for _, h in ipairs(doc.head) do
        -- a Repeatable the page draws must not contradict the card either (2026-10-20: sandoria 5's card printed No, its header Yes:
        -- the reader sees both)
        if h.key == 'Repeatable' and not D.head_hidden(h, doc.title, drawn_card) and not D.head_empty(h) then
            local t, plain = field_text(h)
            local printed = (page_printed(path) or {}).repeatable or 'No'
            if not plain or norm_words(t) ~= norm_words(printed) then
                out[#out + 1] = ('header field "Repeatable" says "%s" where the card prints "%s"'):format(t, printed)
            end
        end
        -- ...and a Title the page draws under a card that prints a TITLE repeats it (2026-10-20: windurst 63's card printed the first of two
        -- titles and 66's "One of the following:", the header drew the whole list beside it): the card must carry the wiki's title
        if h.key == 'Title' and not D.head_hidden(h, doc.title, drawn_card) and not D.head_empty(h) then
            local printed = (page_printed(path) or {}).title
            if printed then
                out[#out + 1] = ('header field "Title" is drawn under a card that prints the TITLE "%s"'):format(printed:gsub('%s+', ' '))
            end
        end
        if D.head_hidden(h, doc.title, drawn_card) and not D.head_empty(h) then
            local t, plain = field_text(h)
            local card_says
            if h.key == 'Repeatable' then
                local printed = (page_printed(path) or {}).repeatable or 'No'
                if not plain or norm_words(t) ~= norm_words(printed) then card_says = printed end
            elseif h.key == 'Title' and e.title then
                if nn(t) ~= nn(e.title) then card_says = e.title end
            elseif h.key == 'Required Fame' and e.fame then
                local w = nn(t)
                local wrong
                if FAME_READ then
                    -- rule 134: a header that is only a number, N/A or Unknown (An Explorer's Footsteps: "4", the card "Selbina 4") names no nation, so it
                    -- cannot name a wrong one; its level must be the card's. Any other header must name the card's nation and, when the card
                    -- has a level, say "level" and that level (the level compared as the header's text is: letters and digits, any case:
                    -- "N/A" is "na", Monstrosity (Quest) "Other Fame Level: N/A").
                    local lv = e.fame_level and nn(tostring(e.fame_level))
                    if w:match('^%d+$') or w == 'na' or w == 'unknown' then wrong = lv ~= nil and w ~= lv     -- outlands 103: the header "N/A", the card's fame N/A
                    else wrong = not w:find(nn(e.fame), 1, true) or (lv ~= nil and not w:find('level' .. lv, 1, true)) end
                else
                    wrong = not w:find(nn(e.fame), 1, true) or (e.fame_level and not w:find('level' .. e.fame_level, 1, true))
                end
                if wrong then
                    card_says = e.fame .. (e.fame_level and (' ' .. e.fame_level) or '')
                end
            end
            if card_says then
                out[#out + 1] = ('header field "%s" is left out for the card but says "%s" where the card says "%s"'):format(h.key, t, card_says)
            end
        end
    end
    return out
end

-- Rule 176 (vision wave qcw2, quest wotg 81 to 86 and 79 more): a header field the drawing leaves drawn (D.head_hidden says so) that is only what
-- the guide card prints is a repeat: a Starting NPC row with the letters of the card's NPC, a Pack row with the letters of the card's FAME (v1 keeps
-- the pack in `fame`). The card is the test's own reading of the entry (page_printed); a card with no fame leaves the Pack row, a Starting NPC
-- that adds a zone is not the NPC. -> descriptions, {} when none.
local function header_repeats(doc, drawn_card, printed)
    local out = {}
    if doc.tabbed or not printed then return out end
    for _, h in ipairs(doc.head) do
        if (h.key == 'Starting NPC' or h.key == 'Pack') and not D.head_hidden(h, doc.title, drawn_card) and not D.head_empty(h) then
            local t, plain = field_text(h)
            local texts = h.key == 'Starting NPC' and {printed.npc} or (printed.fame or {})
            for _, c in ipairs(texts) do
                if plain and nn(t) ~= '' and nn(t) == nn(c) then
                    out[#out + 1] = ('header field "%s" repeats the card: "%s" is drawn under a card that prints "%s"'):format(h.key, t, c)
                    break
                end
            end
        end
    end
    return out
end

-- the header fields a page draws with tab `sel` open: the page's own on a page without tabs, else the open
-- tab's (nothing above the tab strip: the tabs keep it)
-- the header fields drawn, and which of them are the page header's own (a tab panel's box draws a row the page
-- header would leave to the card, so the two are not read by the same rules)
local function header_fields(doc, sel, shown, printed)
    local out, of_page = {}, {}
    if not doc.tabbed then
        for _, h in ipairs(doc.head) do
            if not page_hidden(h, doc.title, shown, printed) then out[#out + 1] = h of_page[h] = true end
        end
    end
    local function blocks(bs)
        for _, b in ipairs(bs) do
            if b.k == 'tabs' then
                local t = b.tabs[sel[b.group] or 1]
                for _, h in ipairs(t.head) do
                    if not panel_hidden(h, printed) then out[#out + 1] = h end
                end
                blocks(t.blocks)
            elseif b.k == 'box' then blocks(b.blocks) end
        end
    end
    blocks(doc.blocks)
    return out, of_page
end

-- what the page should draw with tab `sel[group]` open in each group
local function expected(doc, sel, shown, printed)
    local want = {}
    local links = {}
    local function spans(sp, whole)
        -- a heading is drawn as one title string (ui/doc.lua `heading`): spans of text that touch, "(" + a link + ")", are one word
        -- "(Raubahn)" there (2026-10-21, toau 43); in body text each span is drawn as a piece of its own. `whole` joins the runs.
        local run = ''
        local function flush() if run ~= '' then words_of(run, want) run = '' end end
        for si, s in ipairs(sp) do
            if s.t == 'text' or s.t == 'link' or s.t == 'coord' then
                if whole then run = run .. (s.s or '') else words_of(s.s, want) end
                if s.t == 'link' then links[s] = true end
            elseif s.t == 'tag' then
                if whole then run = run .. (s.s or '') else words_of(s.s, want) end
            elseif s.t == 'icon' and s.icon ~= 'item' and s.icon ~= 'ki' then
                flush()
                local drawn = D.icon_text(sp, si)          -- what is drawn of the icon: its label, or the plain word of it in a sentence
                if drawn then words_of(drawn, want) end
            else
                flush()
            end
        end
        flush()
    end
    local function blocks(bs)
        for _, b in ipairs(bs) do
            if b.k == 'tabs' then
                for _, t in ipairs(b.tabs) do words_of(t.label, want) words_of(t.sub, want) end
                local t = b.tabs[sel[b.group] or 1]
                for _, h in ipairs(t.head) do
                    if not panel_hidden(h, printed) then
                        words_of(D.HEAD_LABEL[h.key] or h.key, want)
                        spans(h.spans)
                    end
                end
                blocks(t.blocks)
            elseif b.k == 'list' then
                local function items(its, level)
                    for n, it in ipairs(its) do
                        if b.ordered and level == 1 then words_of(n .. '.', want) end
                        spans(it.spans)
                        items(it.children, level + 1)
                    end
                end
                items(b.items, 1)
            elseif b.k == 'box' then spans(b.title) blocks(b.blocks)
            elseif b.k == 'image' then spans(b.caption)
            elseif b.k == 'table' then
                for _, r in ipairs(b.rows) do for _, c in ipairs(r.cells) do spans(c.spans) end end
            elseif b.spans then spans(b.spans, b.k == 'h') end
        end
    end
    if not doc.tabbed then
        for _, h in ipairs(doc.head) do
            if not page_hidden(h, doc.title, shown, printed) then
                words_of(D.HEAD_LABEL[h.key] or h.key, want)
                -- rule 180: under a card that lists the items, only the row's prose lines are drawn
                if h.key == 'Requirements' and shown and shown.requirements then spans(req_shown(h))
                else spans(h.spans) end
            end
        end
    end
    blocks(doc.blocks)
    return want, links
end

-- the drawn commands -> text items {x, y, w, h, s}
local function drawn_text(b)
    local items = {}
    for _, line in ipairs(b.o) do
        local k = line:sub(1, 1)
        if k == 'T' then
            local x, y, s = line:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
            items[#items + 1] = {x = tonumber(x), y = tonumber(y), w = ops.text_w(s), h = 16, s = s, font = 'moji'}
        elseif k == 'H' then
            local x, y, px, s = line:match('^H\t([%-%d%.]+)\t([%-%d%.]+)\t([%d%.]+)\t%x+\t(.*)$')
            px = tonumber(px)
            items[#items + 1] = {x = tonumber(x), y = tonumber(y), w = ops.title_w(s, px), h = px + 2, s = s, font = 'title'}
        end
    end
    return items
end

-- A word wider than the column is broken across lines (ui/doc.lua). The drawn pieces of a word the page has
-- and the drawing lacks are joined back into it, when the word really did not fit from where it starts:
-- -> {{word, pieces}}; `got` and the items are updated.
local function join_pieces(items, want, got, W)
    local out = {}
    local order = {}
    for i, it in ipairs(items) do order[i] = it end
    table.sort(order, function(a, c) if a.y ~= c.y then return a.y < c.y end return a.x < c.x end)
    local lim = (W >= 540) and (W - 200) or (W - 12)        -- a float may narrow the line
    for w, n in pairs(want) do
        if (got[w] or 0) < n and ops.text_w(w) > 100 then
            for i = 1, #order do
                if (got[w] or 0) >= n then break end
                local a = order[i]
                if a.font and not a.used and #a.s < #w and w:sub(1, #a.s) == a.s then
                    local acc, seq = a.s, {a}
                    for j = i + 1, #order do
                        local c = order[j]
                        if #acc >= #w or c.y > seq[#seq].y + 40 then break end
                        if not c.used and c.font == a.font and c.y > seq[#seq].y and w:sub(#acc + 1, #acc + #c.s) == c.s then
                            acc = acc .. c.s
                            seq[#seq + 1] = c
                        end
                    end
                    -- the word really did not fit where it starts (it ends past the column), or its pieces stand one under the other at
                    -- the same left edge: a cell narrower than a job list ("BRD/RDM/BLU/PUP/RUN" breaks after a slash, bastok 74)
                    local stacked = #seq >= 2
                    for _, pc in ipairs(seq) do if math.abs(pc.x - a.x) > 1 then stacked = false end end
                    local ww = a.font == 'title' and ops.title_w(w, a.h - 2) or ops.text_w(w)     -- rule 95: a heading's word breaks too
                    if acc == w and (a.x + ww > lim or stacked) then
                        for _, pc in ipairs(seq) do pc.used = true got[pc.s] = (got[pc.s] or 0) - 1 end
                        got[w] = (got[w] or 0) + 1
                        out[#out + 1] = {word = w, pieces = seq}
                    end
                end
            end
        end
    end
    return out
end

-- mutate(b, sel, W, tops): the self-test's fault injection, applied to what was drawn (nil normally)
-- draw_card(card): the self-test's fault, what the drawing is told the card shows (the check uses the real one)
-- rule 206: every link and picture of what was drawn, its tooltip drawn as a hover draws it and read back. Where a click goes is a
-- property of the running app, so every answer is tried. tip_fault (the self-test) breaks the drawn tooltip.
local OPENS = {'Chronicle', 'this page', 'BG-wiki', 'the browser'}
local WINDOW_MARGIN = 40        -- a window is this much wider than its content (WIDTHS)
local WINDOW_H = 480            -- the shortest window; the link is hovered on its last line, so the tooltip has to go above it
local tip_fault = nil
local function tooltip_problems(hits, W, fail, tag)
    local seen = {}
    for _, hit in ipairs(hits) do
        local sp = hit.span
        local key = hit.id == 'link' and table.concat({'l', tostring(sp.kind), tostring(sp.name or sp.to or sp.s), tostring(sp.id)}, '|')
            or (hit.id == 'picture' and ('p|' .. tostring(hit.file) .. tostring(hit.missing)))
        if key and not seen[key] then
            seen[key] = true
            for _, where in ipairs(OPENS) do
                local tb = ops.new()
                D.tooltip(tb, hit, 0, WINDOW_H - 4, W + WINDOW_MARGIN, function() return where end, WINDOW_H, WINDOW_H - 20)
                if tip_fault then tip_fault(tb) end
                for _, p in ipairs(tooltip_fit.problems(tb.o, ops, W + WINDOW_MARGIN, WINDOW_H)) do fail(tag .. ': ' .. p) end
            end
        end
    end
end

local function check_page(key, path, mutate, quiet, draw_card)
    local mk = dofile(path)
    local doc = D.decode(mk)
    local shown = page_card(path)
    local printed = page_printed(path)
    if not printed and draw_card then      -- a fixture: the card it is drawn under says what the card prints (rule 176)
        local dc = draw_card({})
        if dc and type(dc.printed) == 'table' and (dc.printed.npc or dc.printed.fame) then
            printed = {repeatable = 'No', has = {reward = dc.printed.reward ~= nil, fame = dc.printed.fame ~= nil}, npc = dc.printed.npc,
                       fame = dc.printed.fame, reward = dc.printed.reward}     -- reward: rule 178's panel fixture
        end
    end
    local fails = {}
    local function fail(what) fails[#fails + 1] = what end

    -- header vs card: a field hidden for the card must not contradict it
    for _, c in ipairs(card_contradictions(path, doc, draw_card and draw_card(page_card(path)) or shown)) do fail(c) end
    -- rule 176: a header field that only repeats the card's NPC or FAME is not drawn
    for _, c in ipairs(header_repeats(doc, draw_card and draw_card(page_card(path)) or shown, printed)) do fail(c) end

    -- characters: everything the page displays is the game font's ASCII (convert.py folds it)
    do
        local seen = {}
        local function scan_spans(sp)
            for _, x in ipairs(sp or {}) do
                for _, k in ipairs({'s', 'label'}) do
                    local v = x[k]
                    if v and v:find('[\128-\255]') and not seen[v] then
                        seen[v] = true
                        fail(('a character the game font cannot draw in "%s"'):format((v:gsub('[\128-\255]', '?'))))
                    end
                end
            end
        end
        local function scan(bs)
            for _, bl in ipairs(bs) do
                if bl.k == 'tabs' then
                    for _, t in ipairs(bl.tabs) do
                        scan_spans({{s = t.label}, {s = t.sub}})
                        for _, h in ipairs(t.head) do scan_spans(h.spans) end
                        scan(t.blocks)
                    end
                elseif bl.k == 'list' then
                    local function items(its) for _, it in ipairs(its) do scan_spans(it.spans) items(it.children) end end
                    items(bl.items)
                elseif bl.k == 'box' then scan_spans(bl.title) scan(bl.blocks)
                elseif bl.k == 'image' then scan_spans(bl.caption)
                elseif bl.k == 'table' then
                    for _, r in ipairs(bl.rows) do for _, c in ipairs(r.cells) do scan_spans(c.spans) end end
                else scan_spans(bl.spans) end
            end
        end
        for _, v in pairs(doc.meta) do scan_spans(v) end
        scan(doc.blocks)
    end

    -- pictures named by the page
    local listed = {}
    for _, f in ipairs(doc.images) do listed[f] = true end
    local groups = {}
    local function scan(bs)
        for _, b in ipairs(bs) do
            if b.k == 'image' and not listed[b.file] then fail('picture not in the page\'s list: ' .. b.file) end
            if b.k == 'tabs' then
                groups[#groups + 1] = b
                for _, t in ipairs(b.tabs) do scan(t.blocks) end
            elseif b.k == 'box' then scan(b.blocks) end
        end
    end
    scan(doc.blocks)

    -- every combination of open tabs (one group at a time; others on their first tab)
    local choices = {{}}
    for _, g in ipairs(groups) do
        for i = 2, #g.tabs do choices[#choices + 1] = {[g.group] = i} end
    end

    -- the page's own running text (no icon labels), to tell a real "that that" from a doubled word
    local page_text
    do
        local parts = {}
        local function sp(list) for _, x in ipairs(list or {}) do if x.s then parts[#parts + 1] = x.s end end end
        local function walk(bs)
            for _, bl in ipairs(bs) do
                if bl.k == 'tabs' then for _, t in ipairs(bl.tabs) do for _, h in ipairs(t.head) do sp(h.spans) end walk(t.blocks) end
                elseif bl.k == 'list' then
                    local function items(its) for _, it in ipairs(its) do sp(it.spans) items(it.children) end end
                    items(bl.items)
                elseif bl.k == 'box' then sp(bl.title) walk(bl.blocks)
                elseif bl.k == 'image' then sp(bl.caption)
                elseif bl.k == 'table' then
                    for _, r in ipairs(bl.rows) do
                        for _, c in ipairs(r.cells) do sp(c.spans) parts[#parts + 1] = ' ' end
                    end
                else sp(bl.spans) end
            end
        end
        for _, h in ipairs(doc.head) do sp(h.spans) end
        walk(doc.blocks)
        page_text = ' ' .. table.concat(parts, ''):lower():gsub('%s+', ' ') .. ' '
    end

    -- the text of every cell of every table block: a cell of only "-" or "?" is the page's own value, not a fragment of a split line
    local cell_text = {}
    each_spans(doc, function(where, spans)
        if where == 'table cell' then
            local t = ''
            for _, x in ipairs(spans) do t = t .. (x.s or '') end
            cell_text[(ops.ascii(t):gsub('%s+', ''))] = true
            -- ...and the last words of a cell: a cell narrower than its text wraps, and its last line may be "(?)" alone
            local ws = {}
            for w in ops.ascii(t):gmatch('%S+') do ws[#ws + 1] = w end
            for k = 2, #ws do cell_text[table.concat(ws, '', k)] = true end
        end
    end)

    -- rule 187 (campaign, "Time Limit  ?" on 6 pages): a header field whose whole value is "?" is the wiki's own value (the field is
    -- there and its value is unknown); drawn in the value column, 88 px from a short label ("Time Limit"), it is a run of its own and was
    -- taken for a line broken down to a "?". The values of the page's header fields (and of each tab's infobox) that are only question
    -- marks are the page's, as the cells of a table are. QMARK_VALUE = false is the check before 187.
    local head_qmark = {}
    if QMARK_VALUE then
        local function field(h)
            local t = ''
            for _, sp in ipairs(h.spans) do
                if sp.t == 'text' then t = t .. (sp.s or '') elseif sp.t ~= 'br' then return end
            end
            t = t:gsub('%s+', '')
            if t ~= '' and not t:find('[^%?]') then head_qmark[t] = true end
        end
        for _, h in ipairs(doc.head or {}) do field(h) end
        local function walk(bs)
            for _, bl in ipairs(bs) do
                if bl.k == 'tabs' then
                    for _, t in ipairs(bl.tabs) do for _, h in ipairs(t.head or {}) do field(h) end walk(t.blocks) end
                elseif bl.k == 'box' then walk(bl.blocks) end
            end
        end
        walk(doc.blocks)
    end

    -- the words that two neighbouring cells of one row both hold (rule 112: "Mamool Ja Warder | Mamool Ja Training Grounds", assault 11): at a
    -- width where each cell wraps to its first word, the row draws "Mamool Mamool" a cell's padding apart. That is the wiki's two cells, not
    -- a word the layout doubled. CELL_PAIRS = false is the check before rule 112.
    local cell_pair = {}
    do
        local function wordset(spans)
            local t = ''
            for _, x in ipairs(spans) do t = t .. (x.s or '') end
            local set = {}
            for w in ops.ascii(t):gmatch('%S+') do set[same_form(w)] = true end
            return set
        end
        local function blocks(bs)
            for _, b in ipairs(bs) do
                if b.k == 'table' then
                    for _, r in ipairs(b.rows) do
                        local prev
                        for _, c in ipairs(r.cells) do
                            local cur = wordset(c.spans)
                            if prev then for w in pairs(cur) do if prev[w] then cell_pair[w] = true end end end
                            prev = cur
                        end
                    end
                elseif b.k == 'box' then blocks(b.blocks)
                elseif b.k == 'tabs' then for _, t in ipairs(b.tabs) do blocks(t.blocks) end end
            end
        end
        blocks(doc.blocks)
    end

    -- rule 171: the labels of icons that stand twice in a row in the page ("Thunder" for two Thunder icons: double weather). Two icons of the
    -- same label with nothing between them are the wiki's pair; an icon before the same word in TEXT is not one and is still caught.
    local icon_twin = {}
    each_spans(doc, function(where, spans)
        for i = 2, #spans do
            local a, c = spans[i - 1], spans[i]
            if a.t == 'icon' and c.t == 'icon' and a.icon ~= 'item' and a.icon ~= 'ki' and c.icon ~= 'item' and c.icon ~= 'ki'
                and (a.label or '') ~= '' and a.label == c.label then
                for w in ops.ascii(a.label):gmatch('%S+') do icon_twin[same_form(w)] = true end
            end
        end
    end)

    -- edges: a block never starts or ends with an empty line
    each_spans(doc, function(where, spans)
        if #spans > 0 and (spans[1].t == 'br' or spans[#spans].t == 'br') then
            fail(('a block starts or ends with an empty line: %s'):format(where))
        end
    end)

    -- labels: an icon's chip is words (convert.py resolves item icons to ids; a file name is never a label)
    each_spans(doc, function(where, spans)
        for _, sp in ipairs(spans) do
            if sp.t == 'icon' and sp.icon ~= 'item' and sp.icon ~= 'ki' then
                local lab = sp.label or sp.file or ''
                if file_like(lab) then fail(('a file name or message drawn as an icon chip: "%s" (%s)'):format(lab, where)) end
            end
        end
    end)

    -- markup: no drawn text holds the reader's own syntax (2026-10-20: {c=red:{q:A|B|C}} drew "A|B|C" in red, windurst 73)
    -- rule 98 (2026-10-22, asa 2): a brace or bar the wiki itself prints ("(You will need to make two of these}") is written `\}` in the
    -- page and drawn as the character. It is the wiki's when the page text holds that escape after the same ten characters; markup the
    -- reader would see (`{c=red:{q:A|B|C}}`, no escape) is not. SRC_BRACE = false is the check before the rule.
    local src_all
    do
        local parts = {}
        local function walk(t, depth)
            if type(t) == 'string' then parts[#parts + 1] = t
            elseif type(t) == 'table' and depth < 6 then for _, v in pairs(t) do walk(v, depth + 1) end end
        end
        walk(mk, 0)
        src_all = table.concat(parts, '\n')
    end
    local function wiki_mark(v, i)
        if not SRC_BRACE then return false end
        local c = v:sub(i, i)
        local ctx = v:sub(math.max(1, i - 10), i - 1) .. string.char(92) .. c
        return src_all:find(ctx, 1, true) ~= nil
    end
    each_spans(doc, function(where, spans)
        for _, sp in ipairs(spans) do
            local v = sp.s or ''
            local leak = v:find('Category:%S') ~= nil
            for i = 1, #v do
                if v:sub(i, i):find('[|{}]') and not wiki_mark(v, i) then leak = true break end
            end
            if leak then fail(('markup drawn as text: "%s" (%s)'):format(v:sub(1, 50), where)) break end
            -- rule 204: a link drawn with the underscores of its target ("Sauromugue_Champaign_(S)" over "Sauromugue Champaign (S)")
            if sp.t == 'link' and sp.to and v:find("[%w'%)]_[%w%(]") and (v:gsub('_', ' ')) == sp.to then
                fail(('link drawn with underscores: "%s" (%s)'):format(v:sub(1, 50), where)) break
            end
        end
    end)

    -- maps: a picture of a map has a label, and a map number the text cites is on one of them (2026-10-20: sandoria 85, 86, 95 cited
    -- "Map 2" and "the map below" over pictures that said nothing; three maps side by side were unlabelled). The test's own reading of
    -- the rule convert.py states: a map picture is one whose file is named for a map, or the one picture of a page that speaks of its
    -- map; a number is required of the labels when the page has two or more map pictures or a file named for a numbered map.
    do
        local pics, text = {}, {}
        local function walk(bs)
            for _, b in ipairs(bs) do
                if b.k == 'image' then pics[#pics + 1] = b
                elseif b.k == 'tabs' then for _, t in ipairs(b.tabs) do walk(t.blocks) end
                elseif b.k == 'box' then walk(b.blocks) end
            end
        end
        walk(doc.blocks)
        -- rule 89: a line break is a break in the text read ('Map 2<br />4 Tablets' is the cite 2 and a count of 4, not 'Map 24 Tablets')
        local function span_text(sp) if sp.t == 'br' then return string.char(10) end return sp.s or sp.label or '' end
        each_spans(doc, function(where, spans)
            if where ~= 'caption' then for _, sp in ipairs(spans) do text[#text + 1] = span_text(sp) end end
        end)
        local all = table.concat(text, ' ' .. string.char(10)):lower()
        local cited = {}
        for n in all:gmatch('maps?%s*#?(%d+)') do cited[n] = true end
        for n in all:gmatch('map(%d+)') do cited[n] = true end
        local refers = all:find('map below', 1, true) or all:find('map above', 1, true) or all:find('following map', 1, true)
            or all:find('below map', 1, true) or all:find('above map', 1, true)
            or all:find('map on the right', 1, true) or all:find('map on the left', 1, true) or all:find('map to the right', 1, true)
            or all:find('map to the left', 1, true) or all:find('map at the right', 1, true) or all:find('map at the left', 1, true)
        local function stem(f) return (f:gsub('%.[%w]+$', ''):lower()) end
        local function is_map(b)
            local st = stem(b.file)
            if st:find('[^%a]maps?[^%a]') or st:find('^maps?[^%a]') or st:find('[^%a]maps?$') or st:find('^maps?$') or st:find('map%d') then return true end
            return #pics == 1 and refers ~= nil
        end
        local maps, labels = {}, {}
        for _, b in ipairs(pics) do
            if is_map(b) then
                maps[#maps + 1] = b
                local cap = ''
                for _, sp in ipairs(b.caption or {}) do cap = cap .. (sp.s or '') end
                if not cap:find('%S') then fail(('a map picture with no label: "%s"'):format(b.file)) end
                labels[#labels + 1] = cap
            end
        end
        if next(cited) and #maps >= 2 then
            local lab = table.concat(labels, ' ')
            -- rule 72: labels numbered 10 or more are the wiki's file ids (Everbloom Hollow-map11.jpg), not layers: a cited layer below 10 is not asked of them
            local function missing(set, text)
                local ids, lowest = false, nil
                for n in text:lower():gmatch('map%s*(%d+)') do ids = true; lowest = math.min(lowest or 1e9, tonumber(n)) end
                local file_ids = ids and lowest >= 10
                local out = {}
                for n in pairs(set) do
                    if file_ids and tonumber(n) < 10 then
                        -- a game layer the file ids cannot carry
                    elseif not text:find('%f[%d]' .. n .. '%f[%D]') then out[#out + 1] = n end
                end
                table.sort(out)
                return out
            end
            -- rule 78: a cite belongs to the zone its own line names (the nearest zone link before it; a list item with none takes the
            -- first zone of the item above). A zone with no map picture on the page is not asked a number (a dungeon list pictures four
            -- of nineteen); a pictured zone is asked of its own pictures only on a line that names that zone alone; otherwise any label.
            local function norm(x) return ((x or ''):lower():gsub('[^a-z0-9]+', ' '):gsub('^ +', ''):gsub(' +$', '')) end
            local zcites, names = {}, {}
            local function scan(spans, inherited)
                local text, marks, zone, first, distinct, ndistinct = '', {}, inherited, nil, {}, 0
                for _, sp in ipairs(spans) do
                    if sp.t == 'link' and sp.kind == 'zone' then
                        zone = sp.s or sp.to; first = first or zone
                        if not distinct[zone] then distinct[zone] = true; ndistinct = ndistinct + 1 end
                    end
                    marks[#marks + 1] = {#text, zone, ndistinct > 0}
                    text = text .. span_text(sp)
                end
                local low = text:lower()
                local function at(pos)
                    local z, own = inherited, false
                    for _, m in ipairs(marks) do if m[1] < pos then z, own = m[2], m[3] end end
                    return z, own and ndistinct == 1
                end
                local function add(pos, n)
                    local z, own = at(pos)
                    local zones = {}
                    for d in pairs(distinct) do zones[d] = true end
                    if inherited then zones[inherited] = true end
                    if z then zones[z] = true end
                    zcites[#zcites + 1] = {z, n, own, zones}
                    if z then names[z] = true end
                end
                for pos, n in low:gmatch('()maps?%s*#?(%d+)') do add(pos, n) end
                for pos, n in low:gmatch('()map(%d+)') do add(pos, n) end
                return first or inherited
            end
            local function items(its, inherited)
                for _, it in ipairs(its) do items(it.children, scan(it.spans, inherited)) end
            end
            local function zblocks(bs)
                for _, b in ipairs(bs) do
                    if b.k == 'tabs' then
                        for _, t in ipairs(b.tabs) do
                            for _, h in ipairs(t.head) do scan(h.spans, nil) end
                            zblocks(t.blocks)
                        end
                    elseif b.k == 'list' then items(b.items, nil)
                    elseif b.k == 'box' then scan(b.title, nil) zblocks(b.blocks)
                    elseif b.k == 'table' then
                        for _, r in ipairs(b.rows) do for _, c in ipairs(r.cells) do scan(c.spans, nil) end end
                    elseif b.k ~= 'image' and b.spans then scan(b.spans, nil) end
                end
            end
            for _, h in ipairs(doc.head) do scan(h.spans, nil) end
            zblocks(doc.blocks)
            local function pictured(z)
                local key, got = norm(z) .. ' ', {}
                for i, b in ipairs(maps) do
                    if (norm(labels[i]) .. ' '):sub(1, #key) == key or (norm(stem(b.file)) .. ' '):sub(1, #key) == key then got[#got + 1] = labels[i] end
                end
                return got
            end
            local zlabels = {}
            for z in pairs(names) do zlabels[z] = pictured(z) end
            -- rule 90: a number tells pictures of ONE zone apart, so a pooled cite is asked of the labels only when it could be about a zone
            -- with two or more map pictures on the page (a cite with no zone: only on a page with such a zone)
            local function map_key(f)
                local st, from = stem(f), 1
                while true do
                    local a, b = st:find('maps?%d*', from)
                    if not a then return norm(st) end
                    local before, after = st:sub(a - 1, a - 1), st:sub(b + 1, b + 1)
                    if not before:find('%a') and not after:find('%a') then
                        local head = st:sub(1, a - 1):gsub('[%s_%-]+$', '')
                        return norm(head ~= '' and head or st)
                    end
                    from = b + 1
                end
            end
            local counts, page_series = {}, false
            for _, b in ipairs(maps) do
                local k = map_key(b.file)
                counts[k] = (counts[k] or 0) + 1
                if counts[k] >= 2 then page_series = true end
            end
            local function asked(zones)
                if next(zones) == nil then return page_series end
                for z in pairs(zones) do if #pictured(z) >= 2 then return true end end
                return false
            end
            local pooled, per_zone = {}, {}
            for _, c in ipairs(zcites) do
                local z, n, own = c[1], c[2], c[3]
                if z ~= nil and #zlabels[z] == 0 then
                    -- a zone with no picture is not asked a number
                elseif z ~= nil and own then            -- a line of that one zone: asked of that zone's pictures
                    per_zone[z] = per_zone[z] or {}
                    per_zone[z][n] = true
                elseif asked(c[4]) then pooled[n] = true end    -- no zone, or one of several the line names: any label
            end
            for _, n in ipairs(missing(pooled, lab)) do fail(('the text cites map %s and no picture label has it'):format(n)) end
            for z, set in pairs(per_zone) do
                for _, n in ipairs(missing(set, table.concat(zlabels[z], ' '))) do
                    fail(('the text cites map %s of %s and no picture label of it has it'):format(n, z))
                end
            end
        end
    end

    -- headings: none with nothing under it
    do
        local function text(spans) local t = '' for _, x in ipairs(spans or {}) do t = t .. (x.s or '') end return t end
        -- rule 127 (assault 51, 52): a section that is only one link to a wiki page Chronicle does not carry ("Strategy" ->
        -- "Nyzul Isle Investigation/Strategy") has nothing a reader can open; it counts as nothing. An external address is something.
        -- LONE_PAGE_LINK = false is the check before the rule.
        local function pointer_only(nb)
            if not LONE_PAGE_LINK or nb.k ~= 'p' then return false end
            local ink = {}
            for _, x in ipairs(nb.spans or {}) do
                if x.t ~= 'br' and not (x.t == 'text' and not (x.s or ''):find('%S')) then ink[#ink + 1] = x end
            end
            return #ink == 1 and ink[1].t == 'link' and ink[1].kind == 'page' and not (ink[1].to or ''):find('://', 1, true)
        end
        local function blocks(bs)
            for i, b in ipairs(bs) do
                if b.k == 'h' then
                    local empty, ink_n, last = true, 0, nil
                    for j = i + 1, #bs do
                        local nb = bs[j]
                        if nb.k == 'h' and nb.level <= b.level then break end
                        if nb.k ~= 'h' and block_ink(nb) then ink_n = ink_n + 1 last = nb end
                    end
                    if ink_n > 1 or (ink_n == 1 and not pointer_only(last)) then empty = false end
                    if empty then fail(('a heading with nothing under it: "%s"'):format(text(b.spans))) end
                elseif b.k == 'tabs' then for _, t in ipairs(b.tabs) do blocks(t.blocks) end
                elseif b.k == 'box' then blocks(b.blocks) end
            end
        end
        blocks(doc.blocks)
    end

    -- bullets: a list item draws a bullet, so it has something after it (2026-10-20: the wiki's empty <li> drew a lone
    -- bullet above the Davoi map)
    each_spans(doc, function(where, spans)
        if where == 'list item' and not has_ink(spans) then fail('a list item with nothing in it (a bullet drawn alone)') end
    end)

    -- boxes: a titled box has a row under its title
    do
        local function blocks(bs)
            for _, b in ipairs(bs) do
                if b.k == 'box' then
                    local t = ''
                    for _, x in ipairs(b.title or {}) do t = t .. (x.s or '') end
                    if not block_ink(b) then fail(('a box with a title and no row under it: "%s"'):format(t)) end
                    blocks(b.blocks)
                elseif b.k == 'tabs' then for _, tb in ipairs(b.tabs) do blocks(tb.blocks) end end
            end
        end
        blocks(doc.blocks)
    end

    -- arrows: no line starts with a reference's back-arrow (it draws "1. ^" with the address on the next line)
    each_spans(doc, function(where, spans)
        local line = ''
        local function done()
            local t = line:gsub('^%s+', '')
            if t:match('^[%^]') and (t == '^' or t:match('^%^%s') or t:match('^\e')) then
                fail(('a line starts with a back-arrow: "%s" (%s)'):format(t:sub(1, 40), where))
            end
            line = ''
        end
        for _, sp in ipairs(spans) do
            if sp.t == 'br' then done() else line = line .. (sp.s or '') end
        end
        done()
    end)

    -- table: a run of bare one-cell lines is a table with its columns lost. A row of a table of short cells is
    -- written "cell - cell" (convert.py), so it is not bare.
    do
        local ROW_RUN = 6
        local function bare(b)
            if b.k ~= 'p' and b.k ~= 'sub' then return false end
            local t = ''
            for _, x in ipairs(b.spans) do
                if x.t == 'br' or x.t == 'icon' then return false end
                t = t .. (x.s or '')
            end
            -- rule 111: "Blushing ==> /doze" is a row the wiki typed as text, two cells joined by an arrow (assault 39); false = the check before it
            if ARROW_ROWS and t:find('%s=+>%s') then return false end
            return #t <= 24 and not t:find(' - ', 1, true)
        end
        local function blocks(bs)
            local run, first = 0, nil
            local function done()
                if run >= ROW_RUN then
                    local t = ''
                    for _, x in ipairs(first.spans) do t = t .. (x.s or '') end
                    fail(('%d lines in a row hold one bare cell each, from "%s" (a flattened table)'):format(run, t))
                end
                run, first = 0, nil
            end
            for _, b in ipairs(bs) do
                if bare(b) then run = run + 1 first = first or b else done() end
                if b.k == 'tabs' then for _, t in ipairs(b.tabs) do blocks(t.blocks) end
                elseif b.k == 'box' then blocks(b.blocks) end
            end
            done()
        end
        blocks(doc.blocks)
    end

    -- rule 130: the headings that open with a picture of their own (the next block is a picture), by their drawn text; a text that is also a
    -- heading that opens with text is left out (the log names a heading by its text only)
    local opens_pic = {}
    do
        local function walk(bs)
            for i, bl in ipairs(bs) do
                if bl.k == 'h' then
                    local t = ''
                    for _, sp in ipairs(bl.spans) do t = t .. (sp.s or '') end
                    t = ops.ascii(t)
                    local yes = bs[i + 1] ~= nil and bs[i + 1].k == 'image'
                    if opens_pic[t] == nil then opens_pic[t] = yes else opens_pic[t] = opens_pic[t] and yes end
                elseif bl.k == 'tabs' then for _, t in ipairs(bl.tabs) do walk(t.blocks) end
                elseif bl.k == 'box' then walk(bl.blocks) end
            end
        end
        walk(doc.blocks)
    end

    local runs = 0
    for _, W in ipairs(WIDTHS) do
        local prefix = {}              -- group -> commands above the strip, to compare across tabs
        for _, sel in ipairs(choices) do
            runs = runs + 1
            local b = ops.new()
            local box_rects = {}
            local float_log = {}
            local h, tops = D.draw(b, doc, 0, 0, W, {tabs = sel, pics = function() return FAKE_PIC end, box_rects = box_rects, float_log = float_log,
                card = draw_card and draw_card(page_card(path)) or shown})
            if mutate then mutate(b, sel, W, tops) end
            local tag = ('w%d tabs%s'):format(W, next(sel) and (' ' .. select(2, next(sel))) or ' 1')
            local items = drawn_text(b)
            if W == WIDTHS[1] then tooltip_problems(b.hits, W, fail, tag) end     -- the narrowest window is the hardest

            -- words
            local want, links = expected(doc, sel, shown, printed)
            -- rule 121: a table drawn as cards says its header words once for each value they label; the page has them once. The words
            -- the card says it drew must be the header's own (or the "/" between two header cells), and the values are still all counted.
            if CARD_LABELS then
                for _, cd in ipairs(D.cards or {}) do
                    local head_rows = {}
                    for _, r in ipairs(cd.tb.rows) do if r.head then head_rows[#head_rows + 1] = r end end
                    local hw = expected({head = {}, blocks = {{k = 'table', rows = head_rows}}, tabbed = false}, {}, shown, printed)
                    for w, n in pairs(hw) do want[w] = (want[w] or 0) - n end
                    for w, n in pairs(cd.drawn) do
                        want[w] = (want[w] or 0) + n
                        if not hw[w] and not hw[w .. ':'] and w ~= '/' then fail(('%s: a card label says "%s", which is not in the table header'):format(tag, w)) end
                    end
                end
            end
            local got = {}
            for _, it in ipairs(items) do words_of(it.s, got) end
            local joined = join_pieces(items, want, got, W)
            for w, n in pairs(want) do
                if (got[w] or 0) < n then fail(('%s: "%s" drawn %d of %d times'):format(tag, w, got[w] or 0, n)) end
            end
            for w, n in pairs(got) do
                if (want[w] or 0) < n then fail(('%s: "%s" drawn %d times, the page has %d'):format(tag, w, n, want[w] or 0)) end
            end

            -- heading apart (rule 130): a heading that opens with a picture of its own reads as that picture's title, and drawn beside the
            -- picture of the section before it (asa 8: "Map 2" at the side of Map 1, its own map 170 px lower; asa 11: the Den of Rancor
            -- heading beside the Temple map) it reads as the other's. A subsection (a deeper heading) stays beside its parent's picture, and a
            -- picture before any heading (the page's lead picture, the Assault pages' Enemies / Notes beside it) is the wiki's own two columns.
            if HEAD_APART then
                local seen, gov = {}, nil
                for _, e in ipairs(float_log) do
                    if e.k == 'heading' then
                        if opens_pic[e.text] then
                            for _, p in ipairs(seen) do
                                if p.gov and e.level <= p.gov and p.x0 > e.x0 and p.y0 < e.y and p.y1 - e.y > APART_MIN then
                                    fail(('%s: heading "%s" (y %d) is drawn beside the picture of the section before it (picture y %d to %d)')
                                        :format(tag, e.text:sub(1, 40), e.y, p.y0, p.y1))
                                    break
                                end
                            end
                        end
                        gov = e.level
                    elseif e.k == 'pic' and not e.inline then
                        seen[#seen + 1] = {gov = gov, x0 = e.x0, y0 = e.y0, y1 = e.y1}
                    end
                end
            end

            -- column
            for _, it in ipairs(items) do
                if it.x < -1 or it.x + it.w > W + 1 then
                    fail(('%s: "%s" outside the column (x %d..%d of 0..%d)'):format(tag, it.s, it.x, it.x + it.w, W))
                end
            end

            -- overlap: sweep by y
            table.sort(items, function(a, c) if a.y ~= c.y then return a.y < c.y end return a.x < c.x end)
            for i = 1, #items do
                local a = items[i]
                for j = i + 1, #items do
                    local c = items[j]
                    if c.y >= a.y + a.h - 1 then break end
                    local ox = math.min(a.x + a.w, c.x + c.w) - math.max(a.x, c.x)
                    local oy = math.min(a.y + a.h, c.y + c.h) - math.max(a.y, c.y)
                    if ox > 2 and oy > 3 then
                        fail(('%s: "%s" overlaps "%s" at y %d'):format(tag, a.s, c.s, a.y))
                    end
                end
            end

            -- bars (rule 82): a red title bar (a box's, a table's header row) has text in it. A box whose wiki table has one cell and no
            -- header has no title; the bar drawn over nothing was 20 px of red with no word (2026-10-21, adoulin 212).
            for _, line in ipairs(b.o) do
                local x0, y0, x1, y1 = line:match('^R	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	783434C8$')
                if x0 then
                    x0, y0, x1, y1 = tonumber(x0), tonumber(y0), tonumber(x1), tonumber(y1)
                    local has = false
                    for _, it in ipairs(items) do
                        if it.y >= y0 - 1 and it.y < y1 and it.x >= x0 - 1 and it.x < x1 then has = true break end
                    end
                    if not has then fail(('%s: a box bar with no title (y %d to %d)'):format(tag, y0, y1)) end
                end
            end

            -- box margin (rule 86, 2026-10-21, adoulin 212): text inside a box keeps an inset from the box's right border, as the left
            -- padding gives it from the left (10 px for the body, 8 px for a title: BOX_MARGIN, the title bar's own). The boxes are the
            -- ones doc.lua reports (opts.box_rects): a table is drawn with the same wash and frame, and its cells have their own margins.
            for _, r in ipairs(box_rects) do
                for _, it in ipairs(items) do
                    if it.y >= r.y0 and it.y < r.y1 and it.x >= r.x0 and it.x < r.x1 and r.x1 - (it.x + it.w) < BOX_MARGIN then
                        fail(('%s: "%s" ends %d px from the right border of its box (box x %d..%d, y %d)'):format(
                            tag, it.s, r.x1 - (it.x + it.w), r.x0, r.x1, r.y0))
                    end
                end
            end

            -- picture inset (rule 120, 2026-10-22, tvr 362 380 414 430 484 516 592 602 624): a picture inside a box keeps the box's right inset
            -- too; a gallery of two or more at the narrowest width ran to the border and painted over it. A picture is a quad of the fake
            -- picture's texture; one that starts inside a box ends BOX_MARGIN px or more from its right border. BOX_PIC = false is the check
            -- before 120.
            if BOX_PIC then
                for _, line in ipairs(b.o) do
                    if line:sub(1, 1) == 'Q' then
                        local tex, qx0, qy0, qx1, qy1 = line:match('^Q	(%d+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)')
                        if tonumber(tex) == FAKE_PIC.h then
                            qx0, qy0, qx1, qy1 = tonumber(qx0), tonumber(qy0), tonumber(qx1), tonumber(qy1)
                            for _, r in ipairs(box_rects) do
                                if qy0 >= r.y0 and qy0 < r.y1 and qx0 >= r.x0 and qx0 < r.x1 and r.x1 - qx1 < BOX_MARGIN then
                                    fail(('%s: a picture ends %d px from the right border of its box (picture x %d..%d, box x %d..%d, y %d)'):format(
                                        tag, r.x1 - qx1, qx0, qx1, r.x0, r.x1, qy0))
                                end
                            end
                        end
                    end
                end
            end

            -- lone picture (rule 150, 2026-10-29, quest other 20, tvr 138 and 24 more): a box whose only content is pictures (its title bar and
            -- the captions under the pictures aside) draws them in the box's width. A picture flush with the right border and standing farther
            -- than its own width from the left one is floated (168 px, PIC_FLOAT) at the right of an empty box. LONE_PIC = false is the check before 150.
            if LONE_PIC then
                for _, r in ipairs(box_rects) do
                    local bar_y1 = r.y0
                    for _, line in ipairs(b.o) do
                        local x0, y0, x1, y1 = line:match('^R	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	783434C8$')
                        if x0 and tonumber(x0) == r.x0 and tonumber(y0) == r.y0 then bar_y1 = tonumber(y1) end
                    end
                    local quads = {}
                    for _, line in ipairs(b.o) do
                        local tex, qx0, qy0, qx1, qy1 = line:match('^Q\t(%d+)\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)\t([%-%d%.]+)')
                        if tex and tonumber(tex) == FAKE_PIC.h and tonumber(qy0) >= r.y0 and tonumber(qy0) < r.y1 and tonumber(qx0) >= r.x0 and tonumber(qx0) < r.x1 then
                            quads[#quads + 1] = {tonumber(qx0), tonumber(qy0), tonumber(qx1), tonumber(qy1)}
                        end
                    end
                    if #quads > 0 then
                        local text = false
                        for _, it in ipairs(items) do
                            if it.y >= bar_y1 and it.y < r.y1 and it.x >= r.x0 and it.x < r.x1 then
                                local cap = false
                                for _, q in ipairs(quads) do
                                    if it.y >= q[4] and it.y <= q[4] + 60 and it.x >= q[1] - 2 and it.x + it.w <= q[3] + 2 then cap = true end
                                end
                                if not cap then text = true end
                            end
                        end
                        if not text then
                            for _, q in ipairs(quads) do
                                local left = false      -- a picture of a row of the gallery has its sibling at its left: not alone
                                for _, o in ipairs(quads) do if o ~= q and o[1] < q[1] and o[2] < q[4] and o[4] > q[2] then left = true end end
                                if not left and r.x1 - q[3] < 20 and q[1] - r.x0 > q[3] - q[1] then
                                    fail(('%s: the only content of a box is a picture floated at the right, its left side empty (picture x %d..%d, box x %d..%d, y %d)')
                                        :format(tag, q[1], q[3], r.x0, r.x1, r.y0))
                                    break
                                end
                            end
                        end
                    end
                end
            end

            -- text gap: the reader never scrolls more than GAP px without a line of text (2026-10-19:
            -- three maps stacked at the narrowest width pushed the first line two screens down)
            do
                -- pictures' captions are not reading text: lines just under a picture, within its width
                local pics_r = {}
                for _, line in ipairs(b.o) do
                    if line:sub(1, 1) == 'Q' then
                        local tex, x0, y0, x1, y1 = line:match('^Q	(%d+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)')
                        if tonumber(tex) == FAKE_PIC.h then pics_r[#pics_r + 1] = {tonumber(x0), tonumber(y0), tonumber(x1), tonumber(y1)} end
                    end
                end
                local function caption(it)
                    for _, r in ipairs(pics_r) do
                        if it.y >= r[4] and it.y <= r[4] + 60 and it.x >= r[1] - 2 and it.x + it.w <= r[3] + 2 then return true end
                    end
                end
                local ys = {}
                for _, it in ipairs(items) do if not caption(it) then ys[#ys + 1] = it.y end end
                table.sort(ys)
                -- a gallery is rows of two or more pictures side by side (a last row may hold the one left over): content, not the
                -- pictures stacked one to a line that this rule exists for
                local function gallery_between(ya, yb)
                    local rows = {}
                    for _, r in ipairs(pics_r) do
                        if r[2] >= ya - 2 and r[4] <= yb + 2 then rows[r[2]] = (rows[r[2]] or 0) + 1 end
                    end
                    local multi, single = 0, 0
                    for _, c in pairs(rows) do if c >= 2 then multi = multi + 1 else single = single + 1 end end
                    return multi >= 1 and single <= 1
                end
                for i = 2, #ys do
                    if ys[i] - ys[i - 1] > GAP and not gallery_between(ys[i - 1], ys[i]) then
                        fail(('%s: %d px without text, y %d to %d'):format(tag, ys[i] - ys[i - 1], ys[i - 1], ys[i]))
                    end
                end
                -- ...and after the last line of text, to the end of the page: a column of pictures floated at the right with the whole left
                -- side empty (2026-10-20: jeuno 128's thirteen maps, 77's forty faces, 42 and 186: two to four screens of nothing but
                -- thumbnails; the stretches between two lines of text were checked, the tail was not)
                if #ys > 0 and h - ys[#ys] > GAP and not gallery_between(ys[#ys], h) then
                    fail(('%s: %d px of pictures and no text after y %d, to the end of the page'):format(tag, h - ys[#ys], ys[#ys]))
                end
            end

            -- chips: a labelled chip (the wiki's icon, its alt text in a grey box) never stands inside a sentence, words on both sides of it on
            -- its line (2026-10-20: "is Red [Element: Fire]. Hot spells" in windurst 75, "Use [Two-Hour ability] Manafont" in 68: the chip split
            -- the sentence). Found in what is drawn: a chip's box is a 13 px white wash of alpha 22, its label the text inside it.
            do
                -- the 13 px boxes drawn: a chip (white wash, alpha 22) and a tag (Rare / Ex, its colour at alpha 48). The label inside a box
                -- is not a word of a sentence (2026-10-21, toau 16: the "Ex" tag after "name [Find on FFXIAH]" was taken for one).
                local boxes = {}
                for _, line in ipairs(b.o) do
                    local x0, y0, x1, y1, col = line:match('^R	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	([%-%d%.]+)	(%x+)$')
                    if col and tonumber(y1) - tonumber(y0) == 13 and (col == 'FFFFFF16' or col:sub(7, 8) == '30') then
                        boxes[#boxes + 1] = {x0 = tonumber(x0), y0 = tonumber(y0), x1 = tonumber(x1), chip = col == 'FFFFFF16'}
                    end
                end
                local function in_box(it, except)
                    for _, bx in ipairs(boxes) do
                        if bx ~= except and math.abs(it.y - (bx.y0 - 2)) <= 2 and it.x >= bx.x0 and it.x + it.w <= bx.x1 + 4 then return true end
                    end
                    return false
                end
                -- rule 118: two chips side by side are one run ("Element: Light" "Element: Dark" in cop 228, Lightsday): the words on the
                -- run's two sides are its neighbours, not the other chip. CHIP_RUNS = false is the check before 118.
                local function chip_before(bx)
                    for _, o in ipairs(boxes) do
                        if o ~= bx and o.chip and math.abs(o.y0 - bx.y0) < 1 and o.x1 <= bx.x0 + 1 and bx.x0 - o.x1 <= 14 then return o end
                    end
                end
                local function chip_after(bx)
                    for _, o in ipairs(boxes) do
                        if o ~= bx and o.chip and math.abs(o.y0 - bx.y0) < 1 and o.x0 >= bx.x1 - 1 and o.x0 - bx.x1 <= 14 then return o end
                    end
                end
                for _, bx in ipairs(boxes) do
                    local x0, y0, x1 = bx.x0, bx.y0, bx.x1
                    local run_labels = {}
                    if bx.chip and CHIP_RUNS then
                        if chip_before(bx) then x0 = nil
                        else
                            local o = bx
                            while chip_after(o) and #run_labels < 8 do o = chip_after(o) run_labels[#run_labels + 1] = o end
                            x1 = o.x1
                        end
                    end
                    if bx.chip and x0 then
                        local left, right, label
                        for _, it in ipairs(items) do
                            if it.font == 'moji' and math.abs(it.y - (y0 - 2)) <= 2 then
                                if it.x >= x0 and it.x + it.w <= x1 + 4 then label = label or it.s
                                elseif in_box(it, bx) then
                                    -- the label of another box (a tag, a second chip): not a word
                                elseif it.x + it.w <= x0 + 1 and x0 - (it.x + it.w) <= 14 then left = it
                                elseif it.x >= x1 - 2 and it.x - x1 <= 14 then right = it end
                            end
                        end
                        if left and right then
                            fail(('%s: a chip "%s" inside a sentence, between "%s" and "%s"'):format(tag, label or '?', left.s, right.s))
                        end
                    end
                end
            end

            -- run-on tables: a table of five columns or fewer is columns at the minimum window (2026-10-20: jeuno 77's personality table and
            -- bastok 74's rewards ran their cells on with bars and wrapped anywhere; at 4 px of padding a side they fit). A wider grid is a
            -- card per row (rule 121, 2026-10-22: the eight-column Enemies tables of assault 1, 4, 7 ... ran their cells on at w440 and
            -- read as raw pipes); no table of any width may be drawn as run-on rows.
            for _, n in ipairs(D.runon or {}) do
                fail(('%s: a table of %d columns drawn as run-on rows'):format(tag, n))
            end

            -- a grid of more than five columns keeps its full cell margin: squeezed to fit, its headers run together and its cells
            -- wrap to a word a line (rule 124, assault 2 and 3 at w440); the wider grid is a card per row (rule 121)
            for _, g in ipairs(D.grids or {}) do
                if g.ncols > SQUEEZE_COLS and g.pad < 8 then
                    fail(('%s: a table of %d columns squeezed to a margin of %d px a side (cells wrapping: %d)'):format(tag, g.ncols, g.pad, g.wrapped))
                end
            end

            -- words held together across a space (a card's label and its value, rule 122; "???" and the word after it, rule 123) are
            -- drawn with that space between them: "ZonePeriqia" and "???Box" were two words touching (2026-10-22, assault at w440)
            for _, h in ipairs(D.held or {}) do
                if h.a.x and h.b.x and h.b.x > h.a.x and h.b.x - (h.a.x + h.a.w) < h.sp - 1 then
                    fail(('%s: %s "%s" touches "%s" (a gap of %d px, not %d)'):format(tag,
                        h.label and 'a card label' or 'a placeholder', h.a.s or '?', h.b.s or '?', h.b.x - (h.a.x + h.a.w), h.sp))
                end
            end

            -- rule 131: a card's label and the first word of its value are on one line: "Center /" at the end of a line and "South Ryaaf" on the
            -- next (assault 33 at w440) leaves a pair whose start is unclear. Judged on the drawn tokens, whatever holds them together.
            if LABEL_LINE then
                for _, p in ipairs(D.labels or {}) do
                    local ly, words = nil, {}
                    local broken = false
                    for _, t in ipairs(p.label) do
                        if t.k ~= 'sp' and t.ly then
                            words[#words + 1] = t.s or '?'
                            if ly and t.ly ~= ly then broken = true end
                            ly = ly or t.ly
                        end
                    end
                    if p.value and p.value.ly and ly and p.value.ly ~= ly then broken = true end
                    if broken then
                        fail(('%s: the card label "%s" is broken from its value "%s" over two lines'):format(tag, table.concat(words, ' '), p.value and p.value.s or '?'))
                    end
                end
            end
            -- rule 132: a card's pair that follows a multi-line value (a list of drops) starts its own line: after the list's last item it reads
            -- as that item's value ("Water Crystal  Steal None", assault 42 at w440). AFTER_LIST = false is the check before 132.
            if AFTER_LIST then
                for _, p in ipairs(D.afterlist or {}) do
                    if p.a.ly and p.b.ly and p.a.ly == p.b.ly then
                        fail(('%s: the card pair "%s" follows a list on the last line of the list ("%s")'):format(tag, p.b.s or '?', p.a.s or '?'))
                    end
                end
            end

            -- rule 143: a table with no header row has no title: the first cell of a card row is not set apart on a line of its own above the
            -- others (quest other 11's fish grid, "Bibiki Urchin" over seven names). The line breaks of a row are only those its cells hold.
            -- PLAIN_ROWS = false is the check before 143.
            if PLAIN_ROWS then
                for _, p in ipairs(D.plain or {}) do
                    if p.brs > p.own then
                        fail(('%s: the first cell of a card row with no header row is set apart on its own line (%d line breaks, its cells hold %d)'):format(tag, p.brs, p.own))
                        break
                    end
                end
            end

            -- doubled words: "aggro to Sight Sight" (an icon's label before the same word, 2026-10-19)
            do
                local rows2 = {}
                for _, it in ipairs(items) do
                    if it.font == 'moji' then
                        rows2[it.y] = rows2[it.y] or {}
                        table.insert(rows2[it.y], it)
                    end
                end
                for y, row in pairs(rows2) do
                    table.sort(row, function(a, c) return a.x < c.x end)
                    local words, gaps = {}, {}
                    local prev
                    for _, it in ipairs(row) do
                        local first = true
                        for w in it.s:gmatch('%S+') do
                            words[#words + 1] = w
                            -- the gap before a word: cells of a table are further apart than the words of a line
                            gaps[#gaps + 1] = (first and prev) and (it.x - (prev.x + prev.w)) or 0
                            first = false
                        end
                        prev = it
                    end
                    -- a file name drawn in the text: "Cupboard icon Cupboard", "Shiva GUI Shiva", "Fei'Yin-map1"
                    for i, w in ipairs(words) do
                        local lw = w:lower()
                        if lw:find('%-map%d*[%p]*$') or lw:find('%.png') or lw:find('%.jpe?g') then
                            fail(('%s: a file name drawn as text: "%s" at y %d'):format(tag, w, y))
                        elseif (lw == 'icon' or lw == 'gui') and i > 1 and words[i + 1] then
                            local nxt = same_form(words[i + 1])
                            for k = math.max(1, i - 5), i - 1 do
                                if same_form(words[k]) == nxt and #nxt >= 2 then
                                    fail(('%s: a file name drawn as text: "%s %s %s" at y %d'):format(tag, words[k], w, words[i + 1], y))
                                    break
                                end
                            end
                        end
                    end
                    for i = 2, #words do
                        local a, c = same_form(words[i - 1]), same_form(words[i])
                        -- "quest. (Quest never shows...)": the first word ends a sentence, the second begins the next (jeuno 1)
                        local ends_sentence = words[i - 1]:find("[%.!%?;:][%)%]\"']*$") ~= nil
                        -- the wiki's own "Chains of Promathia (Promathia Mission 8-5)" (zilart 31): the source has the word, a space and
                        -- an opening bracket between the two; without the bracket in the pattern it was taken for the layout's doing
                        local src_pat = SRC_BRACKET and (' ' .. a .. '%p* %p*' .. a .. '%p*[ %p]') or (' ' .. a .. '%p* ' .. a .. '%p*[ %p]')
                        -- the wiki's own "Woah, woah!" after an opening quote (or two: acp 2 has `""Woah, woah!`): a mark may stand before the first word
                        if SRC_QUOTE then src_pat = ' %p*' .. src_pat:sub(2) end
                        if a == c and #a >= 2 and a:find('%a') and gaps[i] < 14 and not ends_sentence
                            and not page_text:find(src_pat) and not (CELL_PAIRS and cell_pair[a]) and not (ICON_TWINS and icon_twin[a]) then
                            fail(('%s: "%s %s" doubled at y %d'):format(tag, words[i - 1], words[i], y))
                        end
                    end
                end
            end

            -- placeholder: "???" (an interaction point's name) keeps the space the page has before it (2026-10-20: the closing-mark glue took it
            -- for a closing mark and drew "a???", "the???" on 100 pages); only a page that writes a letter straight against it ("the???s") may draw it
            do
                local glued = page_text:find('%w%?%?%?') ~= nil
                local by_row = {}
                for _, it in ipairs(items) do
                    if it.font == 'moji' then
                        by_row[it.y] = by_row[it.y] or {}
                        table.insert(by_row[it.y], it)
                    end
                end
                for y, row in pairs(by_row) do
                    table.sort(row, function(a, c) return a.x < c.x end)
                    for i, it in ipairs(row) do
                        local bad = it.s:find('%w%?%?%?') ~= nil
                        local nxt = row[i + 1]
                        if nxt and it.s:find('%w$') and nxt.s:find('^%?%?%?') and nxt.x - (it.x + it.w) < 3 then bad = true end
                        if bad and not glued then
                            fail(('%s: no space before "???" at y %d ("%s")'):format(tag, y, it.s))
                            break
                        end
                    end
                end
            end

            -- rule 195 (vision wave camp2, mission campaign 233, wotg 23): a lone "?" the page writes with a space on each side, an unknown number
            -- ("around ? HP", "Level ? Holy"), is no closing mark: the closing-mark glue took it for one and drew "around? HP", "Level? Holy". The word
            -- before it and the "?" are not drawn against each other where the page has the space. QMARK_SPACE = false is the check before 195.
            if QMARK_SPACE then
                local by_row = {}
                for _, it in ipairs(items) do
                    if it.font == 'moji' then
                        by_row[it.y] = by_row[it.y] or {}
                        table.insert(by_row[it.y], it)
                    end
                end
                for y, row in pairs(by_row) do
                    table.sort(row, function(a, c) return a.x < c.x end)
                    for i, it in ipairs(row) do
                        local word = it.s:match('^(.*[^%?%s])%?$')
                        local nxt = row[i + 1]
                        if not word and nxt and nxt.s == '?' and it.s:find('[^%s%?]$') and nxt.x - (it.x + it.w) < 3 then word = it.s end
                        if word and page_text:find(' ' .. word:lower() .. ' ? ', 1, true) and not page_text:find(word:lower() .. '?', 1, true) then
                            fail(('%s: no space before a lone "?" at y %d ("%s")'):format(tag, y, it.s))
                            break
                        end
                    end
                end
            end

            -- fragments: a row of text with nothing but punctuation
            local rows = {}
            for _, it in ipairs(items) do
                if it.font == 'moji' then
                    rows[it.y] = rows[it.y] or {}
                    table.insert(rows[it.y], it)
                end
            end
            -- rule 108: an item icon drawn in a line of text is part of the line ("(" icon icon icon ")." is one run, not a "(" and a ")." 60 px
            -- apart that the 40 px column gap below would take for two columns). It stands in the run as a letter, so a line of only
            -- brackets and icons is not "a line of only punctuation" but a line with the icons in it; a bracket with nothing drawn
            -- beside it still is. ICON_RUNS = false is the check before rule 108 (cop 358, "(Gray Chip Cyan Chip Carmine Chip).").
            if ICON_RUNS then
                for _, line in ipairs(b.o) do
                    if line:sub(1, 1) == 'I' then
                        local ix, iy, isz = line:match('^I	([%-%d%.]+)	([%-%d%.]+)	([%d%.]+)')
                        ix, iy, isz = tonumber(ix), tonumber(iy), tonumber(isz)
                        for ry, rrow in pairs(rows) do
                            if math.abs(ry - (iy + 1)) <= 1 then rrow[#rrow + 1] = {x = ix, y = ry, w = isz, h = isz, s = 'I', font = 'moji', icon = true} end
                        end
                    end
                end
            end
            for y, row in pairs(rows) do
                table.sort(row, function(a, c) return a.x < c.x end)
                -- split a row into runs (a gap wider than 40 px is another column: a float caption)
                local run = {row[1]}
                local function done()
                    local s = ''
                    for _, it in ipairs(run) do s = s .. it.s end
                    if fragment(s) then
                        -- a run of only punctuation made of whole cells of a table ("-" and "?" are values) is the page's own
                        -- (the cells of a table are 16 px apart or more, the words of a line less)
                        local pieces, cur = {}, ''
                        for n, it in ipairs(run) do
                            if n > 1 and it.x - (run[n - 1].x + run[n - 1].w) >= 14 then pieces[#pieces + 1] = cur cur = '' end
                            cur = cur .. it.s
                        end
                        pieces[#pieces + 1] = cur
                        local cells_only = true
                        for _, p in ipairs(pieces) do local pp = p:gsub('%s+', '') if not (cell_text[pp] or (head_qmark[pp] and run[1] ~= row[1])) then cells_only = false end end
                        if not cells_only then fail(('%s: a line of only "%s" at y %d'):format(tag, s, y)) end
                    end
                end
                -- rule 119: "???" is an interaction point's name and keeps its word: a run that is only "???" with a line under it that begins
                -- at the run's left edge with a word is "???" broken away from that word (assault 52's narrow Type column, "???" / "Footwear";
                -- a "???" that ends a line of prose is the line filling up, not this). QQQ_HOLD = false is the check before 119.
                local function qqq_done()
                    local last = run[#run]
                    if QQQ_HOLD and #run == 1 and last.s:match('^[%(%[]*%?%?%?+$') then
                        local below = rows[y + 18]
                        if below then
                            for _, it in ipairs(below) do
                                if math.abs(it.x - run[1].x) <= 2 and it.s:find('^[%w]') then
                                    fail(('%s: "%s" alone on a line, its word "%s" on the next (y %d)'):format(tag, last.s, it.s, y))
                                    break
                                end
                            end
                        end
                    end
                end
                -- rule 157: a range ("21:00 - 3:00") is not broken after its dash: a run that ends with a lone "-" or "~" after a word that ends
                -- in a clock time, with a line under it that begins at the run's left edge with a clock time, left the end of the range alone (a number
-- range, "2,494 - 3,049" in a table cell, is not held by D.HOLD_RANGES and is not checked).
                -- RANGE_HOLD = false is the check before 157.
                local function range_done()
                    if not RANGE_HOLD then return end
                    local text = ''
                    for _, it in ipairs(run) do text = text .. it.s end
                    if text:find('%d:%d%d[%)%]]?%s*[%-~]$') then
                        local below = rows[y + 18]
                        if below then
                            for _, it in ipairs(below) do
                                if math.abs(it.x - run[1].x) <= 2 and it.s:find('^%d+:%d%d') then
                                    fail(('%s: a range broken after its dash ("%s" / "%s", y %d)'):format(tag, text:sub(-14), it.s:sub(1, 8), y))
                                    break
                                end
                            end
                        end
                    end
                end
                -- rule 159: the last word of an item's name that is a plus sign and digits ("Midras's Helm +1.") is not left alone at the start of a
                -- line: a run that begins with such a word, which is a word of an item link whose earlier word is drawn on a line above (the
                -- words of a link have a hit area each). PLUS_HOLD = false is the check before 159.
                local function plus_done()
                    if not PLUS_HOLD or not run[1] or not run[1].s:find('^%+%d+[%.,;:!%?%)%]]*$') then return end
                    local first, above
                    for _, hh in ipairs(b.hits) do
                        if hh.id == 'link' and hh.span and hh.span.kind == 'item' then
                            if math.abs(hh.x0 - run[1].x) <= 2 and math.abs(hh.y0 - run[1].y) <= 4 then first = hh end
                        end
                    end
                    if first then
                        for _, hh in ipairs(b.hits) do
                            if hh.id == 'link' and hh.span == first.span and hh.y0 < first.y0 - 4 and hh.y0 > first.y0 - 40 then above = true end
                        end
                    end
                    if above then fail(('%s: a "%s" of an item name alone at the start of a line (y %d)'):format(tag, run[1].s, y)) end
                end
                for i = 2, #row do
                    if row[i].x - (row[i - 1].x + row[i - 1].w) > 40 then done() qqq_done() range_done() plus_done() run = {} end
                    run[#run + 1] = row[i]
                end
                done()
                qqq_done()
                range_done()
                plus_done()
            end

            -- links
            -- every word of every link is clickable: one hit per word
            local hit_count = {}
            for _, hh in ipairs(b.hits) do
                if hh.id == 'link' then
                    hit_count[hh.span] = (hit_count[hh.span] or 0) + 1
                    if hh.x0 < -1 or hh.x1 > W + 1 then fail(tag .. ': a link hit outside the column') end
                end
            end
            for sp in pairs(links) do
                local n = 0
                for _ in ops.ascii(sp.s or ''):gmatch('%S+') do n = n + 1 end
                if (hit_count[sp] or 0) < n then
                    fail(('%s: link "%s" has no hit area on %d of its %d words'):format(tag, sp.s, n - (hit_count[sp] or 0), n))
                end
            end

            -- every piece of a broken link word is clickable too
            do
                local link_words = {}
                for sp in pairs(links) do for w in ops.ascii(sp.s or ''):gmatch('%S+') do link_words[w] = true end end
                for _, j in ipairs(joined) do
                    if link_words[j.word] then
                        for _, pc in ipairs(j.pieces) do
                            local covered = false
                            for _, hh in ipairs(b.hits) do
                                if hh.id == 'link' and hh.x0 <= pc.x + 1 and hh.x1 >= pc.x + pc.w - 1
                                    and hh.y0 <= pc.y + 1 and hh.y1 >= pc.y + 8 then covered = true break end
                            end
                            if not covered then fail(('%s: a piece of the link word "%s" has no hit area'):format(tag, j.word)) break end
                        end
                    end
                end
            end

            -- header: the label of each infobox field, and its value on the same line
            local hfields, of_page = header_fields(doc, sel, shown, printed)
            for _, h in ipairs(hfields) do
                local label = ops.ascii(D.HEAD_LABEL[h.key] or h.key)
                local first
                -- rule 180: under a card that lists the items, a Requirements row draws only its prose lines
                local hs = (of_page[h] and h.key == 'Requirements' and shown and shown.requirements) and req_shown(h) or h.spans
                local sp1 = hs[1]
                if sp1 and (sp1.t == 'text' or sp1.t == 'link' or sp1.t == 'coord') then first = ops.ascii(sp1.s):match('%S+') end
                local found_label, found_value = false, first == nil
                for _, it in ipairs(items) do
                    -- the label drawn whole, or (rule 83) wrapped in its column: its lines one under the other, from the first
                    local whole = it.s == label
                    if not whole and it.x < 16 and label:sub(1, #it.s + 1) == it.s .. ' ' then
                        local got, y = it.s, it.y
                        for _, nx in ipairs(items) do
                            if nx.font == 'moji' and nx.x == it.x and nx.y == y + 18 and label:sub(#got + 2, #got + 1 + #nx.s) == nx.s then
                                got = got .. ' ' .. nx.s
                                y = nx.y
                            end
                        end
                        whole = got == label
                    end
                    if it.font == 'moji' and whole and it.x < 16 then
                        found_label = true
                        if first then
                            for _, v in ipairs(items) do
                                if v.font == 'moji' and v.y == it.y and v.x > it.x and first:sub(1, #v.s) == v.s then
                                    found_value = true
                                    -- rule 83 (2026-10-21, adoulin 368): the value column, from the value's first x to the box's right edge,
                                    -- is at least HEAD_VALUE_SHARE of the box; a long label wraps in its column instead of taking the box
                                    local share = (W - v.x) / (W - (it.x - 10))
                                    if share < HEAD_VALUE_SHARE then
                                        fail(('%s: header field "%s" leaves its value %d%% of the box (the label column is too wide)'):format(tag, h.key, share * 100))
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
                if not found_label then fail(('%s: header field "%s" not drawn'):format(tag, h.key))
                elseif not found_value then fail(('%s: header field "%s" has no value on its line'):format(tag, h.key)) end
            end
            -- ... and a page's field that adds nothing is not (the card has it; or it says nothing)
            if not doc.tabbed then
                local drawn_n = 0
                for _, h in ipairs(doc.head) do
                    if page_hidden(h, doc.title, shown, printed) then
                        local label = ops.ascii(D.HEAD_LABEL[h.key] or h.key)
                        for _, it in ipairs(items) do
                            if it.font == 'moji' and it.s == label and it.x > 8 and it.x < 12 and it.y < (tops[1] or 1e9) then
                                fail(('%s: header field "%s" drawn though it adds nothing (the card shows it, or it is empty)'):format(tag, h.key))
                                break
                            end
                        end
                    else drawn_n = drawn_n + 1 end
                end
                if drawn_n == 0 then
                    for _, line in ipairs(b.o) do
                        if line:find('^R	0	0	[%d%.]+	[%d%.]+	00000032$') then
                            fail(('%s: a header box with no field in it'):format(tag))
                            break
                        end
                    end
                end
            end

            -- a tab panel's infobox likewise (cop 530, 2026-10-20: each path's box repeated the card's Repeatable, Next and Reward): a field
            -- that says what the card prints, or says nothing where the card has nothing, is not drawn, and a box left with no field is not
            local function panel_boxes(bs)
                for _, bl in ipairs(bs) do
                    if bl.k == 'tabs' then
                        local t = bl.tabs[sel[bl.group] or 1]
                        local ys = tops.strip and tops.strip[bl.group]
                        local visible = 0
                        for _, h in ipairs(t.head) do
                            if panel_hidden(h, printed) then
                                local label = ops.ascii(D.HEAD_LABEL[h.key] or h.key)
                                for _, it in ipairs(items) do
                                    if it.font == 'moji' and it.s == label and it.x > 8 and it.x < 12 and ys and it.y > ys then
                                        fail(('%s: tab header field "%s" drawn though it adds nothing (the card prints the same, or it is empty)'):format(tag, h.key))
                                        break
                                    end
                                end
                            else visible = visible + 1 end
                        end
                        if #t.head > 0 and visible == 0 and ys then
                            for _, line in ipairs(b.o) do
                                local y0 = line:match('^R	0	([%d%.]+)	[%d%.]+	[%d%.]+	00000032$')
                                if y0 and tonumber(y0) > ys then
                                    fail(('%s: a tab header box with no field in it'):format(tag))
                                    break
                                end
                            end
                        end
                        panel_boxes(t.blocks)
                    elseif bl.k == 'box' then panel_boxes(bl.blocks) end
                end
            end
            panel_boxes(doc.blocks)

            -- tabs: what is drawn above each strip is the same whichever tab is open
            for g, y in pairs(tops.strip or {}) do
                local above = {}
                for _, line in ipairs(b.o) do
                    -- y is the 3rd field, or the 4th for Q (tex x0 y0 ...)
                    local ly = line:sub(1, 1) == 'Q' and line:match('^Q\t[^\t]+\t[^\t]+\t([%-%d%.]+)')
                        or line:match('^%a\t[%-%d%.]+\t([%-%d%.]+)')
                    ly = tonumber(ly)
                    if ly and ly < y then above[#above + 1] = line end
                end
                local key2 = table.concat(above, '\n')
                if prefix[g] and (prefix[g].y ~= y or prefix[g].text ~= key2) then
                    fail(('%s: the tab strip or the page above it moved (strip y %d, was %d)'):format(tag, y, prefix[g].y))
                end
                prefix[g] = prefix[g] or {y = y, text = key2}
            end
        end
    end

    local unique, seen = {}, {}
    for _, f in ipairs(fails) do
        local k = f:gsub('^w%d+ tabs %d+: ', '')
        if not seen[k] then seen[k] = true unique[#unique + 1] = f end
    end
    if not quiet then
        print(('%-30s %-16s %3d layouts, %s'):format(key, doc.title or '?', runs,
            #fails == 0 and 'ok' or (#fails .. ' failures')))
        for i = 1, math.min(#unique, tonumber(os.getenv('CR_MAXFAIL') or 25)) do print('    ' .. unique[i]) end
    end
    return #fails, unique
end

-- --selftest: every check must catch the fault it exists for. Each mutation breaks what was drawn
-- in one way; the verifier has to report it, with the matching message.
if only == '--selftest' then
    local page = 'pages/missions/cop/530.lua'
    local function first_t(b, n)
        local k = 0
        for i, line in ipairs(b.o) do
            if line:sub(1, 1) == 'T' and line:match('	%a%a%a+$') then
                k = k + 1
                if k == (n or 1) then return i end
            end
        end
    end
    local function set_x(line, x) return (line:gsub('^T	[%-%d%.]+', 'T	' .. x)) end
    local cases = {
        {'a word not drawn', 'drawn %d+ of %d+ times$', function(b) table.remove(b.o, first_t(b)) end},
        {'a word drawn twice', 'times, the page has', function(b) table.insert(b.o, b.o[first_t(b)]) end},
        {'text over text', 'overlaps', function(b)
            local i = first_t(b, 3)
            local x = b.o[i]:match('^T	([%-%d%.]+)')
            local line = b.o[first_t(b, 4)]
            local y4 = line:match('^T	[%-%d%.]+	([%-%d%.]+)')
            b.o[#b.o + 1] = (b.o[i]:gsub('^T	[%-%d%.]+	[%-%d%.]+', 'T	' .. x .. '	' .. y4))
            table.remove(b.o, i)
        end},
        {'text outside the column', 'outside the column', function(b, _, W)
            local i = first_t(b) b.o[i] = set_x(b.o[i], W - 5)
        end},
        {'a line of only punctuation', 'a line of only', function(b)
            b.o[#b.o + 1] = 'T	0	99999	FFFFFFFF	)'
        end},
        {'the tab strip moving', 'tab strip', function(b, sel, W, tops)
            if next(sel) then
                for i, line in ipairs(b.o) do
                    if line:sub(1, 1) == 'T' then
                        local y = tonumber(line:match('^T	[%-%d%.]+	([%-%d%.]+)'))
                        if y and y < (tops.strip[1] or 0) then b.o[i] = (line:gsub('^T	([%-%d%.]+)', function(x) return 'T	' .. (x + 1) end)) break end
                    end
                end
            end
        end},
        {'a link without a hit area', 'has no hit area on', function(b)
            for i = #b.hits, 1, -1 do if b.hits[i].id == 'link' then table.remove(b.hits, i) break end end
        end},
        -- the quest header (2026-10-19): drawn on a page without tabs (quest 23: what the card lacks, its Requirements)
        {'a dropped page header', 'header field "[^"]+" not drawn', function(b)
            local first_h
            for _, line in ipairs(b.o) do
                if line:sub(1, 1) == 'H' then first_h = tonumber(line:match('^H	[%-%d%.]+	([%-%d%.]+)')) break end
            end
            for i = #b.o, 1, -1 do
                local y = tonumber(b.o[i]:match('^T	[%-%d%.]+	([%-%d%.]+)'))
                if y and y < first_h then table.remove(b.o, i) end
            end
        end, 'pages/quests/sandoria/23.lua'},
        {'a header value not on its label line', 'has no value on its line', function(b)
            local label_y
            for _, line in ipairs(b.o) do
                local x, y, s = line:match('^T	([%-%d%.]+)	([%-%d%.]+)	%x+	(.*)$')
                if s == 'Requirements' and tonumber(x) < 16 then label_y = tonumber(y) break end
            end
            for i = #b.o, 1, -1 do
                local x, y = b.o[i]:match('^T	([%-%d%.]+)	([%-%d%.]+)')
                if y and tonumber(y) == label_y and tonumber(x) > 16 then b.o[i] = b.o[i]:gsub('^T	([%-%d%.]+)	[%-%d%.]+', 'T	%1	' .. (label_y + 3)) end
            end
        end, 'pages/quests/sandoria/23.lua'},
        -- a line of nothing but punctuation, whatever the punctuation (but "???" is a word)
        {'a line of only a full stop', 'a line of only', function(b) b.o[#b.o + 1] = 'T	0	99999	FFFFFFFF	.' end},
        {'a line of only a question mark', 'a line of only', function(b) b.o[#b.o + 1] = 'T	0	99999	FFFFFFFF	?' end},
        {'a line of only two dots', 'a line of only', function(b) b.o[#b.o + 1] = 'T	0	99999	FFFFFFFF	..' end},
        {'a line of only ??.', 'a line of only', function(b) b.o[#b.o + 1] = 'T	0	99999	FFFFFFFF	??' end},
        -- a broken address whose last piece lost its hit area
        {'a broken link piece unclickable', 'a piece of the link word', function(b)
            for i = #b.hits, 1, -1 do
                if b.hits[i].id == 'link' and b.hits[i].x0 < 5 then table.remove(b.hits, i) break end
            end
        end, 'test/fixtures/long_word.lua'},
    }
    local bad = 0
    for _, c in ipairs(cases) do
        local n, msgs = check_page('selftest', c[4] or page, c[3], true)
        local found = false
        for _, m in ipairs(msgs) do if m:find(c[2]) then found = true end end
        print(('  %-30s %s'):format(c[1], (n > 0 and found) and 'caught' or 'MISSED'))
        if not (n > 0 and found) then bad = bad + 1 end
    end
    -- an icon's label drawn before the same word ("Sight Sight", 2026-10-19): the old behaviour back
    do
        local keep = D.icon_shows_label
        D.icon_shows_label = function() return true end
        local n, msgs = check_page('selftest', page, nil, true)
        D.icon_shows_label = keep
        local found = false
        for _, m in ipairs(msgs) do if m:find('doubled', 1, true) then found = true end end
        print(('  %-30s %s'):format('a doubled word', (n > 0 and found) and 'caught' or 'MISSED'))
        if not (n > 0 and found) then bad = bad + 1 end
    end
    -- a character the game font cannot draw (the arrows of 2026-10-19 showed as "?")
    do
        local n, msgs = check_page('selftest', 'test/fixtures/undrawable.lua', nil, true)
        local found = false
        for _, m in ipairs(msgs) do if m:find('cannot draw', 1, true) then found = true end end
        print(('  %-30s %s'):format('an undrawable character', (n > 0 and found) and 'caught' or 'MISSED'))
        if not (n > 0 and found) then bad = bad + 1 end
    end
    -- the real bug of 2026-10-17: the boss table's "( / BLM / )" lines, in the markup of that day
    local n, msgs = check_page('selftest', 'test/fixtures/530_fragmented.lua', nil, true)
    local found = false
    for _, m in ipairs(msgs) do if m:find('a line of only', 1, true) then found = true end end
    print(('  %-30s %s'):format('the 2026-10-17 boss table', (n > 0 and found) and 'caught' or 'MISSED'))
    if not (n > 0 and found) then bad = bad + 1 end
    local function expect(name, page, msg, setup, draw_card, mutate)
        local keep = setup and setup()
        local n, msgs = check_page('selftest', page, mutate, true, draw_card)
        if keep then keep() end
        local found = false
        for _, m in ipairs(msgs) do if m:find(msg, 1, true) then found = true end end
        print(('  %-30s %s'):format(name, (n > 0 and found) and 'caught' or 'MISSED'))
        if not (n > 0 and found) then bad = bad + 1 end
    end
    local function expect_clean(name, page, _, draw_card)
        local n, msgs = check_page('selftest', page, nil, true, draw_card)
        print(('  %-30s %s'):format(name, n == 0 and 'passes' or ('FAILS: ' .. tostring(msgs[1]))))
        if n ~= 0 then bad = bad + 1 end
    end
    -- a block with an empty first or last line
    expect('a blank line at a block edge', 'test/fixtures/blank_edge.lua', 'starts or ends with an empty line')
    -- batch 6 (2026-10-19): a flattened table, file names as chips, a heading with nothing under it
    expect('a flattened table', 'test/fixtures/table_cells.lua', 'hold one bare cell each')
    -- rule 111: the wiki's own "A ==> B" lines are rows, not a flattened table; a column of plain bare cells still is
    expect_clean('lines of two cells joined by an arrow', 'test/fixtures/arrow_rows.lua')
    expect('lines of two cells joined by an arrow, the check before rule 111', 'test/fixtures/arrow_rows.lua', 'hold one bare cell each', function()
        ARROW_ROWS = false
        return function() ARROW_ROWS = true end
    end)
    expect_clean('a table of rows', 'test/fixtures/table_rows.lua')
    expect('file names as chips', 'test/fixtures/icon_chips.lua', 'drawn as an icon chip')
    expect('a file name in the text', 'test/fixtures/icon_chips.lua', 'drawn as text')
    expect('Information Needed as a chip', 'test/fixtures/icon_chips.lua', '"Information Needed"')
    expect('Verification Needed as a chip (rule 125)', 'test/fixtures/icon_chips.lua', '"Verification Needed"')
    expect('Question as a chip (rule 125)', 'test/fixtures/icon_chips.lua', '"Question"')
    expect('a nation flag named by its file', 'test/fixtures/icon_chips.lua', 'icon chip: "Windurst-Flag"')
    expect_clean('icons as item icons, words and notes', 'test/fixtures/icons_clean.lua')
    expect('a heading with nothing under it', 'test/fixtures/empty_heading.lua', 'a heading with nothing under it')
    expect_clean('a heading with a subheading and text', 'test/fixtures/headings_clean.lua')
    -- rule 127: a section that is only a pointer to a subpage (assault 51, 52); an external address under a heading is content
    expect('a heading over only a link to a wiki page', 'test/fixtures/pointer_heading.lua', 'a heading with nothing under it: "Strategy"')
    expect_clean('a heading over an external address is content', 'test/fixtures/pointer_clean.lua')
    do   -- the check before 127 counted the lone link as something under the heading and let the section through
        LONE_PAGE_LINK = false
        local n = check_page('selftest', 'test/fixtures/pointer_heading.lua', nil, true)
        LONE_PAGE_LINK = true
        print(('  %-30s %s'):format('a pointer section, the check before 127', n == 0 and 'passes (the old check missed it)' or 'CAUGHT: it should not be'))
        if n ~= 0 then bad = bad + 1 end
    end
    -- 2026-10-20: a bullet before nothing, a titled box with no row, a reference's back-arrow
    expect('a bullet drawn alone', 'test/fixtures/empty_bullet.lua', 'a list item with nothing in it')
    expect_clean('lists that are all text', 'test/fixtures/bullets_clean.lua')
    expect('a box with no row under its title', 'test/fixtures/empty_box.lua', 'a box with a title and no row under it')
    expect('a heading over only an empty box', 'test/fixtures/empty_box.lua', 'a heading with nothing under it: "Rewards"')
    expect('a back-arrow before a reference', 'test/fixtures/back_arrow.lua', 'a line starts with a back-arrow')
    expect_clean('references without the arrow', 'test/fixtures/references_clean.lua')
    -- a header Repeatable that says what the card prints (REPEATABLE: No for an entry with no value) is left out;
    -- one that says something else stays
    do
        local P100, REP = 'pages/quests/sandoria/100.lua', 'test/fixtures/repeat_quest.lua'
        expect_clean('Repeatable: No under the card default', P100)
        expect('a Repeatable repeating the card', P100, 'header field "Repeatable" drawn though it adds nothing', nil,
            function(c) c.printed = nil return c end)
        expect('a Repeatable repeating a card default', P100, 'header field "Repeatable" drawn though it adds nothing', nil,
            function(c) c.printed = {repeatable = 'Yes'} return c end)
        expect_clean('Repeatable: Yes, once a week stays', REP)
        -- the wiki wins where it and the card disagree (2026-10-20): sandoria 84's "Yes, after Memory reset" over a card that
        -- prints "No" is drawn, and so is a title list the card cuts to one title; the old rule (hide it, the card has a value) is caught
        local P84, P106 = 'pages/quests/sandoria/84.lua', 'pages/quests/sandoria/106.lua'
        -- since the same day core/meta.lua takes the page's Repeatable for the entry, so the card and the header agree (hidden then); the
        -- fault is re-created with the entry as v1 had it: Repeatable "No"
        local function v1_repeatable(value)
            return function()
                local keep = meta.get
                meta.get = function(cat, area, name, id)
                    local e = keep(cat, area, name, id)
                    if not e then return e end
                    local c = {}
                    for k, v in pairs(e) do c[k] = v end
                    c.repeatable = value
                    return c
                end
                return function() meta.get = keep end
            end
        end
        local function both(f1, f2)
            return function()
                local k1, k2 = f1(), f2()
                return function() k2() k1() end
            end
        end
        expect_clean('a Repeatable the card shares with the wiki is left out', P84)
        -- ...and since core/meta.lua takes the page's Title row too (windurst 63: v1's card printed the first of two titles, 66's "One of the
        -- following:"), the card carries the whole list and the header's Title is hidden; the fault is the entry as v1 had it
        local function v1_title()
            local keep = meta.get
            meta.get = function(cat, area, name, id)
                local e = keep(cat, area, name, id)
                if not (e and type(e.title) == 'string') then return e end
                local c = {}
                for k, v in pairs(e) do c[k] = v end
                c.title = e.title:match('^[^' .. string.char(10) .. ']*')
                return c
            end
            return function() meta.get = keep end
        end
        expect_clean('a title list the card carries whole is left out', P106)
        expect('a title list the card cuts, drawn beside it', P106, 'header field "Title" is drawn under a card that prints the TITLE', v1_title)
        expect('a Repeatable the card contradicts, drawn', P84, 'header field "Repeatable" says "Yes, after Memory reset" where the card prints "No"', v1_repeatable('No'))
        local function old_rule(key, card_key)
            return function()
                local keep = D.head_hidden
                D.head_hidden = function(h, title, card)
                    if h.key == key and title and card and card[card_key] then return true end
                    return keep(h, title, card)
                end
                return function() D.head_hidden = keep end
            end
        end
        expect('a contradicted Repeatable hidden for the card', P84, 'is left out for the card but says "Yes, after Memory reset" where the card says "No"',
            both(v1_repeatable('No'), old_rule('Repeatable', 'repeatable')))
        expect('a longer title list hidden for the card', P106, 'header field "Title" is left out for the card but says',
            both(v1_title, old_rule('Title', 'title')))
        -- rule 134: Required Fame. An-Explorer's-Footsteps (card "Selbina 4") has the header "4"; Monstrosity (Quest) (card "Other", level
        -- "N/A") "Other Fame Level: N/A"; a wrong level or nation under a card that hides the header is still caught
        local F19, F34 = 'pages/quests/other/19.lua', 'pages/quests/other/34.lua'
        local function v1_fame(fame, level)
            return function()
                local keep = meta.get
                meta.get = function(cat, area, name, id)
                    local e = keep(cat, area, name, id)
                    if not e then return e end
                    local c = {}
                    for k, v in pairs(e) do c[k] = v end
                    c.fame, c.fame_level = fame or e.fame, level or e.fame_level
                    return c
                end
                return function() meta.get = keep end
            end
        end
        expect_clean('a bare level that is the card level, no nation', F19)
        expect_clean('a level of N/A the card shares', F34)
        expect('a bare level that is not the card level', F19, 'header field "Required Fame" is left out for the card but says "4" where the card says "Selbina 5"', v1_fame(nil, '5'))
        expect('a nation that is not the card one', F34, 'header field "Required Fame" is left out for the card but says "Other Fame Level: N/A" where the card says "Jeuno N/A"', v1_fame('Jeuno'))
        expect('a level the card has and the header lacks', F34, 'where the card says "Other 3"', v1_fame(nil, '3'))
        expect_clean('a header N/A over a card with fame N/A', 'pages/quests/outlands/103.lua')
        expect_clean('a header over a card that took the wiki nation', 'pages/quests/outlands/143.lua')
        expect('a card with another nation than the wiki', 'pages/quests/outlands/143.lua', 'header field "Required Fame" is left out for the card but says "Outlands Fame Level: 1" where the card says "Other 1"',
            function()
                local keep = meta.FAME_FROM_PAGE
                meta.FAME_FROM_PAGE = false
                meta.release()
                return function() meta.FAME_FROM_PAGE = keep meta.release() end
            end)
        -- rule 140: the second entry of a shared name has no data of v1's own; its card is the first's (Repeatable Yes), not a card of defaults
        expect_clean('a second entry of a shared name reads the first card', 'pages/quests/outlands/164.lua')
        do
            SHARED_NAME = false
            local n164, m164 = check_page('selftest', 'pages/quests/outlands/164.lua', nil, true)
            SHARED_NAME = true
            local found = false
            for _, m in ipairs(m164) do if m:find('header field "Repeatable" says "Yes" where the card prints "No"', 1, true) then found = true end end
            print(('  %-30s %s'):format('the test before 140 read no card for outlands 164', (n164 > 0 and found) and 'caught' or 'MISSED'))
            if not (n164 > 0 and found) then bad = bad + 1 end
        end
        do   -- the check before 134 failed both pages
            FAME_READ = false
            local n19 = check_page('selftest', F19, nil, true)
            local n34 = check_page('selftest', F34, nil, true)
            FAME_READ = true
            local ok = n19 > 0 and n34 > 0
            print(('  %-30s %s'):format('the Required Fame check before 134', ok and 'caught (both pages failed)' or 'MISSED'))
            if not ok then bad = bad + 1 end
        end
        expect('a differing Repeatable hidden', REP, 'header field "Repeatable" not drawn', function()
            local keep = D.head_hidden
            D.head_hidden = function(h, title, card)
                if h.key == 'Repeatable' and title then return true end
                return keep(h, title, card)
            end
            return function() D.head_hidden = keep end
        end, function(c) c.printed = {repeatable = 'No'} return c end)
    end
    -- rule 176 (quest wotg 81 to 86 and 79 more): a Starting NPC row with no zone and a Pack row that are the card's NPC and FAME are left out; a card
    -- with no fame keeps the Pack row; a Starting NPC that is not the card's NPC stays
    do
        local HR = 'test/fixtures/head_repeats_card.lua'
        local function with_card(npc, fame)
            return function(c)
                c.npc, c.fame = npc and true or nil, fame and true or nil
                c.printed = {repeatable = 'No', npc = npc, fame = fame and {fame, fame} or nil}
                return c
            end
        end
        expect_clean('a Start and Pack row that repeat the card', HR, nil, with_card('Voidwatch Officer', 'Wings of the Goddess'))
        expect('a Start and Pack row that repeat the card, the drawing before 176', HR, 'repeats the card', function()
            D.HIDE_CARD_REPEAT = false
            return function() D.HIDE_CARD_REPEAT = true end
        end, with_card('Voidwatch Officer', 'Wings of the Goddess'))
        expect_clean('a Pack row under a card with no fame stays', HR, nil, with_card('Voidwatch Officer', nil))
        expect_clean('a Start row that is not the card NPC stays', HR, nil, with_card('Somebody Else', 'Wings of the Goddess'))
    end
    -- rule 178 (quest wotg 69): a panel's Pack and Level Restriction "None" rows and a Rewards row of a key-item icon and name, under a card whose
    -- FAME is the pack and whose REWARD is "[Key Item]" and the name, are left out; the panel's own Description stays
    do
        local PR = 'test/fixtures/panel_repeats_card.lua'
        local function with_card(fame, reward)
            return function(c)
                c.npc, c.fame, c.reward = true, fame and true or nil, reward and true or nil
                c.printed = {repeatable = 'No', npc = 'Somebody', fame = fame and {fame, fame} or nil, reward = reward}
                return c
            end
        end
        expect_clean('a panel Pack, Level None and key-item Reward that repeat the card', PR, nil,
            with_card('Wings of the Goddess', '[Key Item] Large memory fragment'))
        expect('the same panel, the drawing before 178', PR, 'tab header field "Pack" drawn though it adds nothing', function()
            D.PANEL_REPEAT = false
            return function() D.PANEL_REPEAT = true end
        end, with_card('Wings of the Goddess', '[Key Item] Large memory fragment'))
        expect('the same panel, the drawing before 178 (Rewards)', PR, 'tab header field "Rewards" drawn though it adds nothing', function()
            D.PANEL_REPEAT = false
            return function() D.PANEL_REPEAT = true end
        end, with_card('Wings of the Goddess', '[Key Item] Large memory fragment'))
        expect('the same panel, the drawing before 178 (Level Restriction)', PR, 'tab header field "Level Restriction" drawn though it adds nothing', function()
            D.PANEL_REPEAT = false
            return function() D.PANEL_REPEAT = true end
        end, with_card('Wings of the Goddess', '[Key Item] Large memory fragment'))
        expect('a panel Description hidden', PR, 'header field "Description" not drawn', function()
            local keep = D.panel_hidden
            D.panel_hidden = function(h, card) if h.key == 'Description' then return true end return keep(h, card) end
            return function() D.panel_hidden = keep end
        end, with_card('Wings of the Goddess', '[Key Item] Large memory fragment'))
    end
    -- rule 179 (quest other 24): a panel's "Other Fame Level: Unknown" under a card FAME "Other", and its "Support Job" under a card REWARD
    -- "Support Jobs", are left out; a fame row naming another fame or another level stays
    do
        local PF = 'test/fixtures/panel_fame_card.lua'
        local function with_card(fame, level, reward)
            return function(c)
                c.npc, c.fame, c.reward = true, true, true
                c.printed = {repeatable = 'No', npc = 'Somebody', fame = {fame, level and (fame .. ' (Lvl ' .. level .. ')') or fame}, reward = reward}
                return c
            end
        end
        expect_clean('a panel fame and singular reward that repeat the card', PF, nil, with_card('Other', nil, 'Support Jobs'))
        expect('the same panel, the drawing before 179 (fame)', PF, 'tab header field "Required Fame" drawn though it adds nothing', function()
            D.PANEL_FAME = false
            return function() D.PANEL_FAME = true end
        end, with_card('Other', nil, 'Support Jobs'))
        expect('the same panel, the drawing before 179 (reward)', PF, 'tab header field "Rewards" drawn though it adds nothing', function()
            D.PANEL_FAME = false
            return function() D.PANEL_FAME = true end
        end, with_card('Other', nil, 'Support Jobs'))
        expect('a panel fame of another nation hidden', PF, 'header field "Required Fame" not drawn', function()
            local keep = D.panel_hidden
            D.panel_hidden = function(h, card) if h.key == 'Required Fame' then return true end return keep(h, card) end
            return function() D.panel_hidden = keep end
        end, with_card('Windurst', nil, 'Support Jobs'))
    end
    -- a tab panel's infobox repeating the guide card (cop 530, 2026-10-20: Repeatable No, Next, Reward None under a card that prints them);
    -- a path's own Starting NPC, Title and Previous differ from the card's and stay (the page itself is the clean case)
    do
        expect_clean('a panel box without the card fields', page)
        expect('a panel Repeatable repeating the card', page, 'tab header field "Repeatable" drawn though it adds nothing', nil,
            function(c) c.printed = nil return c end)
        expect('a panel Next repeating the card', page, 'tab header field "Next Mission" drawn though it adds nothing', nil,
            function(c) c.printed = {repeatable = 'No', title = c.printed and c.printed.title} return c end)
        expect('a panel Reward "None" under a card with none', page, 'tab header field "Rewards" drawn though it adds nothing', nil,
            function(c) c.reward = true return c end)
        expect('a differing panel Title hidden', page, 'header field "Title" not drawn', function()
            local keep = D.head_hidden
            D.head_hidden = function(h, title, card)
                if h.key == 'Title' and not title then return true end
                return keep(h, title, card)
            end
            return function() D.head_hidden = keep end
        end)
        expect_clean('a panel box with nothing left is not drawn', 'test/fixtures/tab_panel_empty.lua')
        expect('an empty panel box drawn', 'test/fixtures/tab_panel_empty.lua', 'a tab header box with no field in it', nil, nil,
            function(b, sel, W, tops)
                for _, y in pairs(tops.strip or {}) do b.o[#b.o + 1] = ('R	0	%d	%d	%d	00000032'):format(y + 60, W, y + 100) end
            end)
    end
    -- an over-wide word: the old layout left it outside the column; the new one breaks it
    expect('an over-wide word, not broken', 'test/fixtures/long_word.lua', 'outside the column', function()
        D.BREAK_LONG = false
        return function() D.BREAK_LONG = true end
    end)
    expect_clean('an over-wide word, broken', 'test/fixtures/long_word.lua')
    -- rule 97: the last piece of a broken word is never only a closing mark (mkd 12: "(north/.../etc.)." broke before ").")
    expect_clean('an over-wide word ending in ").", broken', 'test/fixtures/break_tail.lua')
    -- rule 113: a table column is as wide as a run with no space in it (a link and the bracket after it)
    expect_clean('a bracket after a link in a narrow table cell', 'test/fixtures/cell_bracket.lua')
    expect('a bracket after a link in a narrow table cell, the measure before rule 113', 'test/fixtures/cell_bracket.lua', 'a line of only ")"', function()
        D.MIN_RUNS = false
        D.COMPACT_COLS = 99      -- (the fixture's eight columns are cards since rule 124; this fault is the squeezed grid's)
        return function() D.MIN_RUNS = true D.COMPACT_COLS = 5 end
    end)
    expect('an over-wide word ending in ").", the break before rule 97', 'test/fixtures/break_tail.lua', 'a line of only ")."', function()
        D.BREAK_TAIL = false
        return function() D.BREAK_TAIL = true end
    end)
    -- doubled words: a bracket does not hide one; a slash command is another word
    expect('trade (trade)', 'test/fixtures/doubled_paren.lua', 'doubled')
    expect_clean('trade (/trade)', 'test/fixtures/slash_command.lua')
    -- rule 93: the wiki's own "Promathia (Promathia Mission 8-5)" is not the layout's doubling; the check before the rule failed it
    expect_clean('the source has "word (word"', 'test/fixtures/doubled_source_paren.lua')
    expect('the source has "word (word", the check before rule 93', 'test/fixtures/doubled_source_paren.lua', 'doubled', function()
        SRC_BRACKET = false
        return function() SRC_BRACKET = true end
    end)
    -- rule 96: the wiki's own `""Woah, woah!` (a mark before the first of the two words) is not the layout's doubling
    expect_clean('the source has a quoted "word, word"', 'test/fixtures/doubled_source_quote.lua')
    expect('the source has a quoted "word, word", the check before rule 96', 'test/fixtures/doubled_source_quote.lua', 'doubled', function()
        SRC_QUOTE = false
        return function() SRC_QUOTE = true end
    end)
    expect('a quoted word after an icon label of the same word', 'test/fixtures/doubled_quote.lua', 'doubled')
    -- rule 112: the same word at the start of two neighbouring cells is the wiki's; the doubled word in one cell is not
    expect_clean('two neighbouring cells begin with the same word', 'test/fixtures/doubled_cells.lua')
    expect('two neighbouring cells begin with the same word, the check before rule 112', 'test/fixtures/doubled_cells.lua', 'doubled', function()
        CELL_PAIRS = false
        D.COMPACT_COLS = 99      -- (the fixture's columns are cards since rule 124; this fault is the squeezed grid's)
        return function() CELL_PAIRS = true D.COMPACT_COLS = 5 end
    end)
    -- rule 171: two identical icons side by side (the wiki's double weather) are not the layout's doubled word; an icon before the same word in
    -- text still is
    expect_clean('two identical icons side by side', 'test/fixtures/doubled_icons.lua')
    expect('two identical icons side by side, the check before rule 171', 'test/fixtures/doubled_icons.lua', 'doubled', function()
        ICON_TWINS = false
        return function() ICON_TWINS = true end
    end)
    expect('an icon label before the same word in the text, beside a pair of icons', 'test/fixtures/doubled_icon_text.lua', 'doubled')
    -- rule 170: a labelled icon in a heading draws its label (the heading dropped it: quest wotg 80 lost its nations)
    expect_clean('a labelled icon opens a heading', 'test/fixtures/heading_icon.lua')
    expect('a labelled icon opens a heading, the drawing before rule 170', 'test/fixtures/heading_icon.lua', '"Bastok" drawn 0 of 1', function()
        D.HEAD_ICONS = false
        return function() D.HEAD_ICONS = true end
    end)
    -- rule 98: the wiki's own "...two of these}" is a character, not leaked markup; markup with no escape on the same page still is
    expect_clean('the source has an escaped brace (the wiki closing brace)', 'test/fixtures/brace_escaped.lua')
    expect('the source has an escaped brace, the check before rule 98', 'test/fixtures/brace_escaped.lua', 'markup drawn as text', function()
        SRC_BRACE = false
        return function() SRC_BRACE = true end
    end)
    expect('an escaped brace and leaked markup on one page', 'test/fixtures/brace_escaped_leak.lua', 'markup drawn as text: "{q:Sin Hunting|')
    expect_clean('??? alone on a line', 'test/fixtures/interaction_point.lua')
    -- rule 94: a sign that is no word, with a full stop at its end (">>."), stays with the word before it
    expect_clean('a ">>." tail at every line length', 'test/fixtures/sign_tail.lua')
    expect('a ">>." tail alone on a line, the layout before rule 94', 'test/fixtures/sign_tail.lua', 'a line of only ">>."', function()
        D.HOLD_SIGNS = false
        return function() D.HOLD_SIGNS = true end
    end)
    -- rule 102: the same with the quotes and stops around a placeholder ('glowing "???".', rov 191)
    expect_clean('a quoted "???". tail at every line length', 'test/fixtures/sign_quoted.lua')
    expect('a quoted "???". tail alone on a line, the layout before rule 102', 'test/fixtures/sign_quoted.lua', 'a line of only', function()
        D.HOLD_QUOTED = false
        return function() D.HOLD_QUOTED = true end
    end)
    -- rule 195 (mission campaign 233, wotg 23): a lone "?" (an unknown number) keeps the space before it, at every line length
    expect_clean('a lone "?" at every line length', 'test/fixtures/qmark_space.lua')
    expect('a lone "?" drawn against the word before it, the layout before rule 195', 'test/fixtures/qmark_space.lua', 'no space before a lone "?"', function()
        D.QMARK_PLACEHOLDER = false
        QMARK_SPACE = true
        return function() D.QMARK_PLACEHOLDER = true end
    end)
    -- rule 157 (quest adoulin 127): "21:00 - 3:00" is not broken after its dash, at every line length
    expect_clean('a time range at every line length', 'test/fixtures/range_split.lua')
    expect('a time range broken after its dash, the layout before rule 157', 'test/fixtures/range_split.lua', 'a range broken after its dash', function()
        D.HOLD_RANGES = false
        return function() D.HOLD_RANGES = true end
    end)
    -- rule 159 (quest adoulin 111): an item name that ends in "+1" is not broken before the "+1", at every line length
    expect_clean('an item "+1" at every line length', 'test/fixtures/plus_split.lua')
    expect('an item "+1" alone on a line, the layout before rule 159', 'test/fixtures/plus_split.lua', 'of an item name alone at the start of a line', function()
        D.HOLD_PLUS = false
        return function() D.HOLD_PLUS = true end
    end)
    -- rule 108: "(" icon icon icon ")." on one line is a line with icons in it (cop 358); a lone "(" with nothing beside it still is a fragment
    expect_clean('a bracket round item icons', 'test/fixtures/icons_in_brackets.lua')
    expect('a bracket round item icons, the check before rule 108', 'test/fixtures/icons_in_brackets.lua', 'a line of only "("', function()
        ICON_RUNS = false
        return function() ICON_RUNS = true end
    end)
    expect('a lone bracket with no icon beside it', 'test/fixtures/530_fragmented.lua', 'a line of only')
    -- the page header leaves out what the guide card shows (2026-10-19: it repeated almost all of it)
    do
        local P58, P2, P30 = 'pages/quests/sandoria/58.lua', 'pages/quests/sandoria/2.lua', 'pages/quests/sandoria/30.lua'
        local CHAIN = 'test/fixtures/chain_quest.lua'
        -- the drawing is told the card shows a field it does not (a fixture the wiki gives a Repeatable of its own: since
        -- 2026-10-20 quest 2's "No" is the card's own default and is rightly left out)
        expect('hidden though the card lacks it', 'test/fixtures/reward_quest.lua', 'header field "Rewards" not drawn', nil,
            function(c) c.reward = true return c end)
        -- the card is not passed: the old behaviour, every field repeated
        expect('the card repeated', P58, 'drawn though it adds nothing', nil, function() return {} end)
        -- a field saying "None" drawn
        expect('a None field drawn', P58, 'drawn though it adds nothing', function()
            local keep = D.head_empty
            D.head_empty = function() return false end
            return function() D.head_empty = keep end
        end)
        -- a field saying "Unknown" (Required Fame, jeuno 41) adds nothing beside the card's "--"
        expect_clean('an Unknown field is left out', 'pages/quests/jeuno/41.lua')
        expect('an Unknown field drawn', 'pages/quests/jeuno/41.lua', 'drawn though it adds nothing', function()
            local keep = D.head_empty
            D.head_empty = function() return false end
            return function() D.head_empty = keep end
        end)
        -- Previous / Next Quest are the card's chain links: dropped only when the card draws them
        expect('chain hidden though the card has none', CHAIN, 'header field "Next Quest" not drawn', nil,
            function(c) c.next = {'x'} c.previous = {'x'} return c end)
        expect('chain drawn though the card shows it', P30, 'header field "Previous Quest" drawn though it adds nothing', nil,
            function() return {} end)
        -- the mapping too wide: Next Quest dropped because the card has an NPC
        expect('a real Next Quest dropped', CHAIN, 'header field "Next Quest" not drawn', function()
            local keep = D.CARD_FIELD['Next Quest']
            D.CARD_FIELD['Next Quest'] = {'npc'}
            return function() D.CARD_FIELD['Next Quest'] = keep end
        end, function(c) c.npc = true return c end)
        -- a mission's Previous / Next are the card's chain (2026-10-21, rule 67): toau 6 drew both under the card's own
        local T6, MCH = 'pages/missions/toau/6.lua', 'test/fixtures/chain_mission.lua'
        expect('a mission chain the card draws, repeated', T6, 'header field "Previous Mission" drawn though it adds nothing', nil,
            function(c) c.printed = {repeatable = 'No'} return c end)
        expect('a Next Mission the card draws, repeated', T6, 'header field "Next Mission" drawn though it adds nothing', nil,
            function(c) c.printed = {repeatable = 'No'} return c end)
        expect('a different Next Mission dropped', MCH, 'header field "Next Mission" not drawn', nil,
            function(c) c.printed = {repeatable = 'No', next = 'Fixture Two'} return c end)
        -- rule 126 (vision wave m2, assault 49 50 51): the intro under the title is the card's description, which the Objective or Mission
        -- Orders row repeats; with D.HIDE_ORDERS = false (the drawing before 126) the row is drawn again and the check sees it
        local A49, A51, AO = 'pages/missions/assault/49.lua', 'pages/missions/assault/51.lua', 'test/fixtures/assault_orders.lua'
        expect('a Mission Orders row repeating the card', A49, 'header field "Mission Orders" drawn though it adds nothing', function()
            D.HIDE_ORDERS = false
            return function() D.HIDE_ORDERS = true end
        end)
        expect('an Objective row repeating the card', A51, 'header field "Objective" drawn though it adds nothing', function()
            D.HIDE_ORDERS = false
            return function() D.HIDE_ORDERS = true end
        end)
        expect_clean('assault 49: the card has the orders, the objective stays', A49)
        expect_clean('assault 51: the card has the objective', A51)
        expect('an Objective the card does not repeat, left out', AO, 'header field "Objective" not drawn', nil,
            function(c) c.printed = {repeatable = 'No', description = 'Collect ahtapot.'} return c end)
        expect_clean('an Objective and Mission Orders that differ from the card stay', AO, nil,
            function(c) c.printed = {repeatable = 'No', description = 'Something else entirely'} return c end)
        expect_clean('toau 6: the card has the chain', T6)
        expect_clean('a mission chain the card lacks stays', MCH)
        -- an empty box left behind when every field is hidden (quest 58 has none to draw)
        expect('an empty header box', P58, 'a header box with no field in it', nil, nil, function(b, _, W)
            table.insert(b.o, 1, 'R	0	0	' .. W .. '	30	00000032')
        end)
        -- the real pages: quest 30's chain is the card's (no header), a fixture's is not (drawn), quest 58 draws nothing
        expect_clean('a chain the card lacks stays', CHAIN)
        expect_clean('quest 30: the card has the chain', P30)
        expect_clean('quest 58: no header at all', P58)
    end
    -- 2026-10-20 (Phase 1c): table blocks (columns, header rows, spanning cells, a run-on layout when the window is too narrow),
    -- galleries, and the rule against pictures stacked one to a line
    do
        local TB = 'test/fixtures/table_block.lua'
        expect_clean('a table of columns, header rows, spans', TB)
        expect_clean('an eight-column grid in a narrow window', 'test/fixtures/table_wide.lua')
        -- rule 121 (assault 1, 4, 7 ... at w440): a table too wide for its columns even at their narrowest is a card per row, never run-on
        -- rows with bars; with D.CARDS = false (the drawing before 121) the very same tables are caught
        expect('an eight-column grid run on with bars', 'test/fixtures/table_wide.lua', 'drawn as run-on rows', function()
            D.CARDS = false
            return function() D.CARDS = true end
        end)
        -- rule 124 (assault 2, 3 at w440): the eight-column Enemies table of two short rows fits at a squeezed margin, but squeezed it
        -- reads as run-together headers and wrapped cells; it is cards too. D.COMPACT_COLS = 99 (the drawing before 124) is caught
        expect_clean('a short Enemies table as cards', 'test/fixtures/table_enemies_fit.lua')
        expect('a short Enemies table squeezed into columns', 'test/fixtures/table_enemies_fit.lua', 'squeezed to a margin', function()
            D.COMPACT_COLS = 99
            return function() D.COMPACT_COLS = 5 end
        end)
        expect_clean('an Enemies table as cards', 'test/fixtures/table_enemies.lua')
        expect('an Enemies table run on with bars', 'test/fixtures/table_enemies.lua', 'drawn as run-on rows', function()
            D.CARDS = false
            return function() D.CARDS = true end
        end)
        expect_clean('a two-header table as cards', 'test/fixtures/table_faces.lua')
        expect('a two-header table run on with bars', 'test/fixtures/table_faces.lua', 'drawn as run-on rows', function()
            D.CARDS = false
            return function() D.CARDS = true end
        end)
        -- rule 122 (assault 1, 4, 7 ... at w440): a card's label and its value are two words with a space between them, not "ZonePeriqia"
        expect('an Enemies card label touching its value', 'test/fixtures/table_enemies.lua', 'a card label "', function()
            D.CARD_SPACE = false
            return function() D.CARD_SPACE = true end
        end)
        expect('a two-header card label touching its value', 'test/fixtures/table_faces.lua', 'a card label "', function()
            D.CARD_SPACE = false
            return function() D.CARD_SPACE = true end
        end)
        -- rule 131 (assault 33 at w440): a two-header label stays in one piece with its value, not "Center /" | "South Ryaaf"
        expect('a two-header card label broken after its slash', 'test/fixtures/table_faces.lua', 'broken from its value', function()
            D.CARD_LABEL = false
            return function() D.CARD_LABEL = true end
        end)
        -- ... and the check itself still catches the break when the pair is held (an unconditional switch off, not a weaker check)
        expect_clean('a held label is not broken over two lines', 'test/fixtures/table_faces.lua')
        -- rule 143 (quest other 11 at every width): a table with no header row runs each row's cells on, no cell set apart as a title
        expect_clean('a grid with no header row', 'test/fixtures/table_grid.lua')
        expect('a grid with no header row, the layout before rule 143', 'test/fixtures/table_grid.lua', 'is set apart on its own line', function()
            D.PLAIN_GRID = false
            return function() D.PLAIN_GRID = true end
        end)
        -- rule 132 (assault 42 at w440): the pair after a multi-line Drops cell starts its own line
        expect_clean('a pair after a list of drops', 'test/fixtures/table_enemies_list.lua')
        expect('a pair after a list on its last line', 'test/fixtures/table_enemies_list.lua', 'follows a list', function()
            D.CARD_AFTER_LIST = false
            return function() D.CARD_AFTER_LIST = true end
        end)
        expect('a card label that is no header word', 'test/fixtures/table_enemies.lua', 'a card label says', function()
            local draw = D.draw
            D.draw = function(...)
                local r1, r2 = draw(...)
                for _, cd in ipairs(D.cards) do cd.drawn['Bogus'] = 1 end
                return r1, r2
            end
            return function() D.draw = draw end
        end)
        -- ... and what the cards say: every value is still there under its label, empty cells are not drawn, the header row is not
        do
            local function lines_of(page, W)
                local doc = D.decode(dofile(page))
                local b = ops.new()
                D.draw(b, doc, 0, 0, W, {pics = function() return FAKE_PIC end})
                local items = drawn_text(b)
                table.sort(items, function(a, c) if a.y ~= c.y then return a.y < c.y end return a.x < c.x end)
                local rows, cur = {}, nil
                for _, it in ipairs(items) do
                    if not cur or cur.y ~= it.y then cur = {y = it.y} rows[#rows + 1] = cur end
                    cur[#cur + 1] = it.s
                    -- rule 122: words with no gap between them read as one word ("ZonePeriqia")
                    cur.text = (cur.text and (it.x - cur.last < 2 and cur.text or cur.text .. ' ') or '') .. it.s
                    cur.last = it.x + it.w
                end
                return rows, #doc.blocks
            end
            local function has(rows, needle)
                for _, r in ipairs(rows) do if r.text:find(needle, 1, true) then return true end end
                return false
            end
            local function count(rows, word)
                local n = 0
                for _, r in ipairs(rows) do for _, w in ipairs(r) do if w == word then n = n + 1 end end end
                return n
            end
            local function report(name, ok, why)
                print(('  %-30s %s'):format(name, ok and 'passes' or ('FAILS: ' .. why)))
                if not ok then bad = bad + 1 end
            end
            local rows = lines_of('test/fixtures/table_enemies.lua', 440)
            report('cards: a value under its label', has(rows, 'Aggro Yes') and has(rows, 'Spawns 15') and has(rows, 'Steal None'),
                'no "Aggro Yes" / "Spawns 15" / "Steal None"')
            report('cards: the name is a line', has(rows, 'Bluethunder Kaqool Ja') and has(rows, 'Vulcanian Bomb'), 'no name line')
            report('cards: a plain-text name is the title', (function()
                for _, r in ipairs(rows) do if r.text:find('Vulcanian Bomb', 1, true) then return not r.text:find('Lebros', 1, true) end end
            end)(), 'the zone took the name line')
            report('cards: an empty cell is not drawn', count(rows, 'Drops') == 3, 'Drops drawn ' .. count(rows, 'Drops') .. ' times, not 3')
            report('cards: the header row is not drawn alone', count(rows, 'Level') == 5, 'Level drawn ' .. count(rows, 'Level') .. ' times, not 5')
            rows = lines_of('test/fixtures/table_faces.lua', 440)
            report('cards: two header rows', has(rows, "North / North Balarahb") and has(rows, "Room / NPC Faces"),
                'no "North / North Balarahb" or "Room / NPC Faces"')
            report('cards: the row name is a line', has(rows, 'Pattern #1') and has(rows, 'Pattern #3'), 'no Pattern lines')
        end
        expect_clean('a table of long cells', 'test/fixtures/table_long.lua')
        expect_clean('a five-column table fits the minimum window', 'test/fixtures/table_five.lua')
        expect('a five-column table run on with bars', 'test/fixtures/table_five.lua', 'columns drawn as run-on rows', function()
            D.COMPACT_TABLES = false
            D.CARDS = false          -- (since rule 121 a table that does not fit is cards; the run-on drawing is the one before it)
            return function() D.COMPACT_TABLES = true D.CARDS = true end
        end)
        expect_clean('a gallery of seven captioned maps', 'test/fixtures/gallery.lua')
        -- rule 120 (tvr 592, 602): a gallery in a box keeps the box's right inset
        expect_clean('a gallery in a box', 'test/fixtures/box_gallery.lua')
        expect('a gallery in a box painting over its border', 'test/fixtures/box_gallery.lua', 'a picture ends', function()
            D.GALLERY_INSET = false
            return function() D.GALLERY_INSET = true end
        end)
        expect('pictures stacked one to a line', 'test/fixtures/pictures_stacked.lua', 'px without text')
        local function word_at(b, word)
            for i, line in ipairs(b.o) do
                local x, y, s = line:match('^T\t([%-%d%.]+)\t([%-%d%.]+)\t%x+\t(.*)$')
                if s == word then return i, x, y end
            end
        end
        expect('a table cell drawn over its neighbour', TB, 'overlaps', nil, nil, function(b)
            local _, sx, sy = word_at(b, 'Southern')
            local i = word_at(b, '(K-5)')
            b.o[i] = (b.o[i]:gsub('^T\t[%-%d%.]+\t[%-%d%.]+', 'T\t' .. sx .. '\t' .. sy))
        end)
        expect('a table cell not drawn', TB, 'drawn 0 of 1 times', nil, nil, function(b) table.remove(b.o, (word_at(b, 'Daggao'))) end)
        expect('a table cell outside the column', TB, 'outside the column', nil, nil, function(b, _, W)
            local i = word_at(b, 'Authere')
            b.o[i] = (b.o[i]:gsub('^T\t[%-%d%.]+', 'T\t' .. (W - 5)))
        end)
    end
    -- 2026-10-20 (Phase 1d): a long alt text on an icon is a note that wraps, a closing mark never starts a line, an icon's label before the
    -- word it ends with, a heading's link, the reader's syntax drawn as text, map pictures with no label, a sentence end before a bracket
    do
        expect_clean('an icon with a sentence for a label wraps', 'test/fixtures/long_chip.lua')
        expect('an icon with a sentence for a label, as a chip', 'test/fixtures/long_chip.lua', 'outside the column', function()
            D.CHIP_WRAP = false
            return function() D.CHIP_WRAP = true end
        end)
        expect_clean('a closing mark after a space stays on its line', 'test/fixtures/closer_wrap.lua')
        expect('a closing mark alone on a line', 'test/fixtures/closer_wrap.lua', 'a line of only ")"', function()
            D.GLUE_CLOSERS = false
            return function() D.GLUE_CLOSERS = true end
        end)
        expect_clean('a space before "???" stays', 'test/fixtures/placeholder_space.lua')
        expect('"???" glued to the word before it', 'test/fixtures/placeholder_space.lua', 'no space before "???"', function()
            D.GLUE_PLACEHOLDER = true
            return function() D.GLUE_PLACEHOLDER = false end
        end)
        expect_clean('an icon, a space and the word it ends with', 'test/fixtures/icon_space_word.lua')
        expect('an icon, a space and the word it ends with, the old test', 'test/fixtures/icon_space_word.lua', 'doubled', function()
            local keep = D.icon_shows_label
            D.icon_shows_label = function(spans, i)
                local s, nxt = spans[i], spans[i + 1]
                if not (nxt and nxt.s) then return true end
                local first = function(t) return ((t or ''):match("^%s*([%w']+)") or ''):lower() end
                return first(s.label) == '' or first(s.label) ~= first(nxt.s)
            end
            return function() D.icon_shows_label = keep end
        end)
        expect_clean('a link in a heading has hit areas', 'test/fixtures/heading_link.lua')
        expect('a link in a heading without hit areas', 'test/fixtures/heading_link.lua', 'has no hit area on', function()
            D.HEAD_HITS = false
            return function() D.HEAD_HITS = true end
        end)
        -- rule 95: a heading wider than the column wraps, its link keeps a hit area on every line it is drawn on
        expect_clean('a heading wider than the column wraps', 'test/fixtures/heading_long.lua')
        expect('a heading wider than the column, one line', 'test/fixtures/heading_long.lua', 'outside the column', function()
            D.WRAP_HEADINGS = false
            return function() D.WRAP_HEADINGS = true end
        end)
        expect('a wrapped heading whose link has no hit area', 'test/fixtures/heading_long.lua', 'has no hit area on', function()
            D.HEAD_HITS = false
            return function() D.HEAD_HITS = true end
        end)
        expect('markup drawn as text', 'test/fixtures/markup_leak.lua', 'markup drawn as text')
        expect('a wiki namespace drawn as text', 'test/fixtures/category_leak.lua', 'markup drawn as text')
        expect('a link drawn with underscores', 'test/fixtures/link_underscore.lua', 'link drawn with underscores')
        expect_clean('"quest. (Quest never shows)"', 'test/fixtures/doubled_sentence.lua')
        expect('maps side by side with no label', 'test/fixtures/maps_unlabelled.lua', 'a map picture with no label')
        expect('a map number the labels lack', 'test/fixtures/maps_unlabelled.lua', 'the text cites map 2 and no picture label has it')
        expect_clean('maps with their labels', 'test/fixtures/maps_labelled.lua')
        expect_clean('maps labelled with the wiki file ids, the text cites a layer below 10', 'test/fixtures/maps_fileids.lua')
        -- rule 78: a map cite belongs to the zone its line names; the number is asked only of a zone that has a map picture on the page
        expect_clean('a dungeon list that pictures some of its zones, a cite of an unpictured zone', 'test/fixtures/maps_zones.lua')
        expect('a pictured zone cites a layer it has no label for', 'test/fixtures/maps_zone_missing.lua', 'the text cites map 3 of Foo Tunnel and no picture label of it has it')
        -- 2026-10-22 (rules 89, 90): a line break keeps "Map 2" and "4 Tablets" apart; a number tells pictures of one zone apart
        expect_clean('a count under a map number, after a line break', 'test/fixtures/maps_break.lua')
        expect_clean('one map picture a zone, a text citing "Map 1"', 'test/fixtures/maps_singles.lua')
        expect_clean('a line naming only zones with no numbered pictures, beside a numbered series', 'test/fixtures/maps_series_unpictured.lua')
        expect('a line naming a zone with a numbered series, a layer no label has', 'test/fixtures/maps_series_missing.lua', 'the text cites map 4 and no picture label has it')

        expect('the one map of "the map below", no label', 'test/fixtures/map_below.lua', 'a map picture with no label: "Crawlers Nest Full.png"')
        expect_clean('a screenshot on a page that mentions a map', 'test/fixtures/screenshot_clean.lua')
    end
    -- 2026-10-20 (second quest vision sweep): runs of pictures the text beside could not fill, labelled icons inside a sentence, "the map on the right"
    do
        local FACES = 'test/fixtures/faces_run.lua'
        expect_clean('a run of faces under their labels', FACES)
        expect('a run of faces floated at the right', FACES, 'px of pictures and no text after', function()
            D.FLOAT_RUNS = true
            return function() D.FLOAT_RUNS = nil end
        end)
        -- rule 99 (2026-10-22, asa 11): a picture that would wait below the one floated before it, with less text beside it than its column
        -- is tall, goes in the flow; pictures that have text to fill their column still float
        expect_clean('map pictures with two short lines each, the pictures falling behind', 'test/fixtures/float_drift.lua')
        expect('map pictures with two short lines each, the layout before rule 99', 'test/fixtures/float_drift.lua', 'px of pictures and no text after', function()
            D.DRIFT_FLOATS = false
            return function() D.DRIFT_FLOATS = true end
        end)
        expect_clean('pictures with text as tall as their column beside them', 'test/fixtures/float_beside.lua')
        -- rule 130 (2026-10-22, asa 8 and 11): a heading that opens with its own picture starts below the picture of the section before it
        expect_clean('sections of a heading and a picture, each below the one before', 'test/fixtures/float_apart.lua')
        expect('sections of a heading and a picture, the layout before rule 130', 'test/fixtures/float_apart.lua', 'is drawn beside the picture of the section before it', function()
            D.CLEAR_HEADINGS = false
            return function() D.CLEAR_HEADINGS = true end
        end)
        expect_clean('a subsection, a lead picture and a section opening with text, all beside a picture', 'test/fixtures/float_apart_ok.lua')
        expect_clean('icons with a label in a sentence are plain words', 'test/fixtures/chip_inline.lua')
        expect('a chip inside a sentence', 'test/fixtures/chip_inline.lua', 'inside a sentence', function()
            D.INLINE_CHIPS = true
            return function() D.INLINE_CHIPS = false end
        end)
        -- rule 118 (cop 228, tvr 352): two icons side by side in a sentence are two plain words, not two chips
        expect_clean('two icons side by side in a sentence are plain words', 'test/fixtures/chip_pair.lua')
        expect('a pair of chips inside a sentence', 'test/fixtures/chip_pair.lua', 'inside a sentence', function()
            D.ICON_PAIRS = false
            return function() D.ICON_PAIRS = true end
        end)
        do   -- the check before 118 took the other chip of a pair for the end of the sentence and let the pair through
            D.ICON_PAIRS = false
            CHIP_RUNS = false
            local n = check_page('selftest', 'test/fixtures/chip_pair.lua', nil, true)
            D.ICON_PAIRS = true
            CHIP_RUNS = true
            print(('  %-30s %s'):format('a pair of chips, the check before 118', n == 0 and 'passes (the old check missed them)' or 'CAUGHT: it should not be'))
            if n ~= 0 then bad = bad + 1 end
        end
        -- rule 119 (assault 52): "???" keeps its word in a narrow table column
        expect_clean('"???" and its word in a narrow table column', 'test/fixtures/qqq_cell.lua')
        expect('"???" alone above its word in a narrow table column', 'test/fixtures/qqq_cell.lua', 'alone on a line', function()
            D.GLUE_QQQ = false
            return function() D.GLUE_QQQ = true end
        end)
        -- rule 123 (assault 7 to 12 at w440): and the space between "???" and its word is drawn, not only kept in the measure
        expect('"???" touching its word', 'test/fixtures/qqq_cell.lua', 'a placeholder "???" touches', function()
            D.QQQ_SPACE = false
            return function() D.QQQ_SPACE = true end
        end)
        -- 2026-10-21 (toau 16): an item row "name [Find on FFXIAH] [Ex]" is not a sentence; the Ex tag's label is not a word
        expect_clean('a chip between an item name and its Ex tag is not in a sentence', 'test/fixtures/chip_tag.lua')
        -- 2026-10-21 (toau 43): a heading is one title string, so "Battle 1 (" + a link + ")" is the words "Battle", "1", "(Raubahn)"
        expect_clean('a heading with a link inside brackets', 'test/fixtures/heading_paren.lua')
        expect('"the map on the right", no label', 'test/fixtures/map_right.lua', 'a map picture with no label: "TheHolyCrestExcavation.png"')
        expect_clean('"the map on the right", labelled', 'test/fixtures/map_right_labelled.lua')
    end
    -- rule 82 (2026-10-21, adoulin 212): a box with no title draws no bar; a titled box keeps its own
    do
        expect_clean('a box with no title draws no bar', 'test/fixtures/box_untitled.lua')
        expect('a box with no title under the old bar', 'test/fixtures/box_untitled.lua', 'a box bar with no title', function()
            D.EMPTY_BAR = true
            return function() D.EMPTY_BAR = false end
        end)
        expect_clean('a titled box', 'test/fixtures/box_titled.lua')
        local function bars(path)
            local b = ops.new()
            D.draw(b, D.decode(dofile(path)), 0, 0, 520, {tabs = {}, pics = function() return FAKE_PIC end})
            local n = 0
            for _, line in ipairs(b.o) do if line:find('	783434C8$') then n = n + 1 end end
            return n
        end
        local got = {bars('test/fixtures/box_titled.lua'), bars('test/fixtures/box_untitled.lua')}
        local ok = got[1] == 1 and got[2] == 1
        print(('  %-30s %s'):format('a bar per titled box only', ok and 'right' or ('WRONG: ' .. got[1] .. ', ' .. got[2])))
        if not ok then bad = bad + 1 end
    end
    -- rule 86 (2026-10-21, adoulin 212): text inside a box keeps room from the box's right border
    do
        expect_clean('a box with a line that fits the edge', 'test/fixtures/box_edge_text.lua')
        expect('a box whose text runs to the border', 'test/fixtures/box_edge_text.lua', 'right border of its box', function()
            D.BOX_RIGHT_PAD = 0
            return function() D.BOX_RIGHT_PAD = 10 end
        end)
    end
    -- rule 150 (2026-10-29, quest other 20, tvr 138 and 24 more): a box of only pictures draws them in the box's width
    do
        expect_clean('a titled box of one picture', 'test/fixtures/box_lone_picture.lua')
        expect_clean('an untitled box of one picture', 'test/fixtures/box_lone_picture_untitled.lua')
        expect_clean('a box with a picture and text', 'test/fixtures/box_picture_text.lua')
        expect('a titled box of one picture floated, the layout before 150', 'test/fixtures/box_lone_picture.lua', 'a picture floated at the right, its left side empty', function()
            D.LONE_PICTURE = false
            return function() D.LONE_PICTURE = true end
        end)
        expect('an untitled box of one picture floated, the layout before 150', 'test/fixtures/box_lone_picture_untitled.lua', 'a picture floated at the right, its left side empty', function()
            D.LONE_PICTURE = false
            return function() D.LONE_PICTURE = true end
        end)
    end
    -- rule 187 (campaign 214, 216, 217, 386 to 388): a header field whose value is "?" is the page's own value, not a line broken to a "?"
    do
        local Q = 'test/fixtures/head_qmark.lua'
        expect_clean('a header field valued "?"', Q)
        expect('a header field valued "?", the check before 187', Q, 'a line of only "?"', function()
            QMARK_VALUE = false
            return function() QMARK_VALUE = true end
        end)
        expect('a stray "?" on a page with a "?" field', Q, 'a line of only "?"', nil, nil,
            function(b) b.o[#b.o + 1] = 'T	0	99999	FFFFFFFF	?' end)
    end
    -- rule 83 (2026-10-21, adoulin 368): the header's label column is capped and a longer label wraps
    do
        local LONG = 'test/fixtures/head_long_label.lua'
        expect_clean('a header with a 36-character label', LONG)
        expect('a label column as wide as the label', LONG, 'leaves its value', function()
            D.HEAD_LABEL_CAP = nil
            return function() D.HEAD_LABEL_CAP = 0.45 end
        end)
        local function lines_at(path, W)
            local b = ops.new()
            D.draw(b, D.decode(dofile(path)), 0, 0, W, {tabs = {}, pics = function() return FAKE_PIC end})
            local t = {}
            for _, it in ipairs(drawn_text(b)) do if it.x == 10 then t[#t + 1] = it.s end end
            return t, table.concat(b.o, '\n')
        end
        local t = lines_at(LONG, 440)
        local joined = table.concat(t, ' ')
        local ok = joined:find('Spoiler - Permanent Key Item Rewards', 1, true) ~= nil and #t == 4   -- Series, Start, and the label on 2 lines
        print(('  %-30s %s'):format('the long label on two lines', ok and 'right' or ('WRONG: ' .. joined)))
        if not ok then bad = bad + 1 end
        -- a header with short labels is drawn as before, byte for byte
        local _, with = lines_at('test/fixtures/repeat_quest.lua', 440)
        D.HEAD_LABEL_CAP = nil
        local _, without = lines_at('test/fixtures/repeat_quest.lua', 440)
        D.HEAD_LABEL_CAP = 0.45
        print(('  %-30s %s'):format('short labels unchanged', with == without and 'right' or 'WRONG'))
        if with ~= without then bad = bad + 1 end
    end
    -- the punctuation test itself, case by case
    do
        local yes = {'.', ')', '?', '..', '??', '????', '( )', '.)', '/', '-', '(', '??.?'}
        local no = {'???', '???.', '???,', '???)', '???!', 'a', '1', '(BLM)', '(???).', '(???)', '[???]'}
        local wrong = {}
        for _, t in ipairs(yes) do if not fragment(t) then wrong[#wrong + 1] = '"' .. t .. '" should be a fragment' end end
        for _, t in ipairs(no) do if fragment(t) then wrong[#wrong + 1] = '"' .. t .. '" should not be' end end
        local same = {same_form('(/trade)') ~= same_form('trade'), same_form('trade)') == same_form('(trade'),
                      same_form('/trade') ~= same_form('trade'), same_form('Trade.') == same_form('trade')}
        for i, ok in ipairs(same) do if not ok then wrong[#wrong + 1] = 'same_form case ' .. i end end
        print(('  %-30s %s'):format('fragment / same_form cases', #wrong == 0 and 'right' or ('WRONG: ' .. table.concat(wrong, '; '))))
        if #wrong > 0 then bad = bad + 1 end
    end
    -- rule 206: a tooltip that does not fit. The faults break the tooltip as drawn; the control is the same page unbroken
    do
        local TIP_PAGE = 'pages/quests/sandoria/109.lua'         -- item links with an icon (Treasury Gold)
        local function set_w(tb, f)
            for i, line in ipairs(tb.o) do
                if line:sub(1, 1) == 'W' then
                    tb.o[i] = line:gsub('^(W\t[%-%d%.]+\t[%-%d%.]+\t)([%-%d%.]+)', function(p, w) return p .. f(tonumber(w)) end)
                end
            end
        end
        local function tip_case(name, msg, fault)
            tip_fault = fault
            local n, msgs = check_page('selftest', TIP_PAGE, nil, true)
            tip_fault = nil
            local found = false
            for _, m in ipairs(msgs) do if m:find(msg) then found = true end end
            print(('  %-30s %s'):format(name, (n > 0 and found) and 'caught' or 'MISSED'))
            if not (n > 0 and found) then bad = bad + 1 end
        end
        tip_case('tooltip text past its box', 'past the room in its box', function(tb) set_w(tb, function(w) return w - 18 end) end)
        tip_case('tooltip wider than the window', 'outside the %d+ px window', function(tb) set_w(tb, function(w) return w + 1000 end) end)
        tip_case('tooltip below the window', 'below the %d+ px window', function(tb)
            for i, line in ipairs(tb.o) do
                if line:sub(1, 1) == 'W' then tb.o[i] = line:gsub('^(W\t[%-%d%.]+\t)[%-%d%.]+', '%1476') end
            end
        end)
        tip_case('tooltip text over its icon', 'drawn over the icon', function(tb)
            for i, line in ipairs(tb.o) do
                if line:sub(1, 1) == 'T' then tb.o[i] = line:gsub('^T\t[%-%d%.]+', 'T\t16') end
            end
        end)
        tip_case('tooltip text below its box', 'is below its box', function(tb)
            for i, line in ipairs(tb.o) do
                if line:sub(1, 1) == 'W' then tb.o[i] = line:gsub('^(W\t[%-%d%.]+\t[%-%d%.]+\t[%-%d%.]+\t)[%-%d%.]+', '%120') end
            end
        end)
        local n, msgs = check_page('selftest', TIP_PAGE, nil, true)
        print(('  %-30s %s'):format('tooltips, no fault', n == 0 and 'clean' or ('MISSED: ' .. tostring(msgs[1]))))
        if n ~= 0 then bad = bad + 1 end
    end
    print(('test_pages selftest: %s'):format(bad == 0 and 'every fault caught' or (bad .. ' faults missed')))
    os.exit(bad == 0 and 0 or 1)
end

local index = dofile('pages/index.lua')
local keys = {}
for k in pairs(index) do keys[#keys + 1] = k end
table.sort(keys)
-- CR_PAGES_FILE=<f>: only the page keys listed in f (one per line), as the frame chooser shards them
local wanted
if os.getenv('CR_PAGES_FILE') then
    wanted = {}
    for line in io.lines(os.getenv('CR_PAGES_FILE')) do
        line = line:gsub('%s+$', '')
        if line ~= '' then wanted[line] = true end
    end
    for k in pairs(wanted) do
        if not index[k] then error('CR_PAGES_FILE lists a page the index does not have: ' .. k, 0) end
    end
end
local checked = 0
for _, k in ipairs(keys) do
    if (not only and not wanted) or k == only or (wanted and wanted[k]) then
        checked = checked + 1
        total_fail = total_fail + check_page(k, index[k])
    end
end
print(('test_pages: %d pages, %s'):format(checked, total_fail == 0 and 'all ok' or (total_fail .. ' failures')))
os.exit(total_fail == 0 and 0 or 1)
