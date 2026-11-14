-- Step progress for Quiescence (Adoulin quest 132, the Epeolatry weapon quest). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest but has no script for it, so the page is the source. `n` is the page's bullet number
-- (indented bullets are never steps, so 2-3, 5-6, 8-10, 12-14, 18, 28, 31, 34-40, 45-51, 56-60 and 63 are not listed). The
-- key items are the ones the bullets say they hand out (res/key_items.lua): 2570 Numbing blossom seed (bullet 11's trade) then
-- 2571 Broken rapier hilt (the dig ends with it), 2572 Vial of crimson catalyst (19), 2573 "Quiescence" (the battlefield win,
-- bullet 28 under 21; a permanent key item, so a character that already owns it sees nothing change), 2574-2576 the three
-- Superlative runic rings (41, 52, 61). The page says the quest log moves to completed once the base weapon is received from
-- Gaddiux (bullet 31 under 30), so the log's completed bit belongs to bullet 30, not the last ring (the draft put it on 61).
-- Fixed from the draft: "Enlightened Endeavor" (bullet 11) is only named as a resonating key item, never as gained there, so
-- it marks nothing; the optional return to Octavien (29) is optional with no signal. Talks and trades with no signal of their
-- own are notes on the next step that has one. The Lexeme Blade III trade for Epeolatry (62) is an item, not a key item, so it
-- is optional with no signal, as is the Dropped Item recovery. The quest log's current bit is not mapped (nothing says which
-- bullet flags it). Every part after the completing step is kind post (it stays open after a completed log).
-- Not repeatable.
return {
    title = 'Quiescence',
    completes = 's30',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's11', at = {n = 1, fp = 'speak with gaddiux at the inventors'}},
        {id = 's4', kind = 'note', with = 's11', at = {n = 4, fp = 'obtain a pickaxe you will only'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'head to i 8 in yorcia'}},
        {id = 's11', at = {n = 11, fp = 'when your enlightened endeavor key item'},
         done = {
            {t = 'ki', id = 2571, gained = true, why = 'broken rapier hilt obtained (the dig ends with it)'},
            {t = 'ki_have', id = 2571, have = true, why = 'broken rapier hilt held'},
            {t = 'chat', re = 'obtained key item: broken rapier hilt', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'ki', id = 2570, gained = true, why = 'numbing blossom seed obtained (the pickaxe traded, the dig begins)'},
         }},
        {id = 's15', kind = 'note', with = 's19', at = {n = 15, fp = 'return to gaddiux at the inventors'}},
        {id = 's16', kind = 'note', with = 's19', at = {n = 16, fp = 'speak with runje desaali at j'}},
        {id = 's17', kind = 'note', with = 's19', at = {n = 17, fp = 'trade 100 high purity bayld to'}},
        {id = 's19', at = {n = 19, fp = 'you will receive the vial of'},
         done = {
            {t = 'ki', id = 2572, gained = true, why = 'vial of crimson catalyst obtained'},
            {t = 'ki_have', id = 2572, have = true, why = 'vial of crimson catalyst held'},
            {t = 'chat', re = 'obtained key item: vial of crimson catalyst', why = 'chat: key item obtained'},
         }},
        {id = 's20', kind = 'note', with = 's21', at = {n = 20, fp = 'speak with octavien at i 8'}},
        {id = 's21', at = {n = 21, fp = 'travel to rala waterways m 6'},
         done = {
            {t = 'ki', id = 2573, gained = true, why = '"Quiescence" obtained (battlefield win, bullet 28)'},
            {t = 'ki_have', id = 2573, have = true, why = '"Quiescence" held'},
            {t = 'chat', re = 'obtained key item: "quiescence"', why = 'chat: key item obtained'},
         }},
        {id = 's22', kind = 'note', with = 's21', at = {n = 22, fp = 'there is a 15 minute time'}},
        {id = 's23', kind = 'note', with = 's21', at = {n = 23, fp = 'you will fence against zurko bazurko'}},
        {id = 's24', kind = 'note', with = 's21', at = {n = 24, fp = 'zurko will dual wield swords and'}},
        {id = 's25', kind = 'note', with = 's21', at = {n = 25, fp = 'casts protect iv shell v and'}},
        {id = 's26', kind = 'note', with = 's21', at = {n = 26, fp = 'frequently parries which will limit your'}},
        {id = 's27', kind = 'note', with = 's21', at = {n = 27, fp = 'zurko bazurko will use lunge which'}},
        {id = 's29', kind = 'optional', at = {n = 29, fp = 'optional return to octavien for a'}, done = {}},
        {id = 's30', at = {n = 30, fp = 'speak with gaddiux in western adoulin'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the page: moved to completed on receiving Lexeme Blade I)'},
         }},
        {id = 's32', kind = 'note', with = 's41', at = {n = 32, fp = 'trade your lexeme blade i to'}},
        {id = 's33', kind = 'note', with = 's41', at = {n = 33, fp = 'then trade her the following'}},
        {id = 's41', kind = 'post', at = {n = 41, fp = 'you will receive superlative runic ring'},
         done = {
            {t = 'ki', id = 2574, gained = true, why = 'superlative runic ring of deluge obtained'},
            {t = 'ki_have', id = 2574, have = true, why = 'superlative runic ring of deluge held'},
            {t = 'chat', re = 'obtained key item: superlative runic ring of deluge', why = 'chat: key item obtained'},
         }},
        {id = 's42', kind = 'note', with = 's52', at = {n = 42, fp = 'trade your lexeme blade i to'}},
        {id = 's43', kind = 'note', with = 's52', at = {n = 43, fp = 'trade your lexeme blade ii to'}},
        {id = 's44', kind = 'note', with = 's52', at = {n = 44, fp = 'then trade her the following'}},
        {id = 's52', kind = 'post', at = {n = 52, fp = 'you will receive superlative runic ring'},
         done = {
            {t = 'ki', id = 2575, gained = true, why = 'superlative runic ring of luster obtained'},
            {t = 'ki_have', id = 2575, have = true, why = 'superlative runic ring of luster held'},
            {t = 'chat', re = 'obtained key item: superlative runic ring of luster', why = 'chat: key item obtained'},
         }},
        {id = 's53', kind = 'note', with = 's61', at = {n = 53, fp = 'trade your lexeme blade ii to'}},
        {id = 's54', kind = 'note', with = 's61', at = {n = 54, fp = 'trade your lexeme blade iii to'}},
        {id = 's55', kind = 'note', with = 's61', at = {n = 55, fp = 'then trade her the following'}},
        {id = 's61', kind = 'post', at = {n = 61, fp = 'you will receive superlative runic ring'},
         done = {
            {t = 'ki', id = 2576, gained = true, why = 'superlative runic ring of vision obtained'},
            {t = 'ki_have', id = 2576, have = true, why = 'superlative runic ring of vision held'},
            {t = 'chat', re = 'obtained key item: superlative runic ring of vision', why = 'chat: key item obtained'},
         }},
        {id = 's62', kind = 'optional', at = {n = 62, fp = 'trade your lexeme blade iii to'}, done = {}},
        {id = 's64', kind = 'optional', at = {n = 64, fp = 'talk to geosuke you might need'}, done = {}},
        {id = 's65', kind = 'optional', at = {n = 65, fp = 'answer yes'}, done = {}},
        {id = 's66', kind = 'optional', at = {n = 66, fp = 'trade information needed 1 000 000'}, done = {}},
    },
}
