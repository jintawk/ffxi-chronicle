-- Step progress for Dances with Luopans (Adoulin quest 118). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Dances_with_Luopans.lua (Sylvie 31 is the offer and 32 the offer after a
-- decline: both run quest:begin only with option 1, so they play on a refusal and are only reaches; 33 is her talk while
-- accepted before the Luopan, 34 plays only on a trade of a Petrified Log while the fistful of homeland soil is held and
-- hands over the Luopan (key item 2290) and takes the soil (2278), 35 is her talk while holding the Luopan, 36 is the
-- finish at Prog 1 and also plays when the bag is full (npcUtil.giveItem fails, no quest:complete), so it is a reach on
-- the hand-in and the log's completed bit proves the last bullet). The Ceizak/Yahse locus message "You are assaulted by
-- an uncanny sensation." is the same text in dozens of zones' IDs.lua (shared signal, dropped); "You feel a mystical
-- warmth welling up inside you!" exists only in Ceizak Battlegrounds and Yahse Hunting Grounds IDs.lua (MYSTICAL_WARMTH,
-- Prog = 1) and is used nowhere else, so it proves the resting bullet, as does Sylvie 36 (plays only at Prog 1).
-- Reward key item (job gesture: geomancer) and items (Indi-Poison, Matre Bell) are dropped: they support, never prove.
-- Client event script S4 256_Sylvie_0110008A.txt has no say lines (events 31-37 and 39 are bare). Key items from
-- res/key_items.lua. The travel bullets (n=4, n=5) are notes on the resting bullet; the indented n=8 is not a step.
return {
    title = 'Dances with Luopans',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sylvie at western adoulin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Sylvie 31 or 32 with option 1)'},
            {t = 'event', zone = 256, event = 33, conf = 'inferred', why = 'Sylvie 33: her talk while accepted, before the Luopan'},
         },
         reach = {
            {t = 'event', zone = 256, event = 31, why = 'Sylvie 31 offered (the quest begins only with option 1)'},
            {t = 'event', zone = 256, event = 32, why = 'Sylvie 32 offered again after a decline (begins only with option 1)'},
         }},
        {id = 's2', at = {n = 2, fp = 'venture to the crag closest to'},
         done = {
            {t = 'ki', id = 2278, gained = true, why = 'fistful of homeland soil obtained (Ergon Locus)'},
            {t = 'ki_have', id = 2278, have = true, why = 'fistful of homeland soil held'},
            {t = 'chat', re = 'obtained key item: fistful of homeland soil', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to sylvie with the soil'},
         done = {
            {t = 'event', zone = 256, event = 34, why = 'Sylvie 34: the Petrified Log traded with the soil held (plays on no other trade)'},
            {t = 'ki', id = 2290, gained = true, why = 'luopan obtained'},
            {t = 'ki_have', id = 2290, have = true, why = 'luopan held'},
            {t = 'chat', re = 'obtained key item: luopan', why = 'chat: key item obtained'},
            {t = 'event', zone = 256, event = 35, conf = 'inferred', why = 'Sylvie 35: her talk while holding the Luopan'},
            {t = 'ki', id = 2278, gained = false, after = 's2', conf = 'inferred', why = 'fistful of homeland soil taken by Sylvie 34'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'proceed to one of following ergon'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'upon arriving at one of the'}},
        {id = 's6', at = {n = 6, fp = 'it can take up to 8'},
         done = {
            {t = 'chat', re = 'You feel a mystical warmth welling up inside you!', after = 's3', why = 'Ceizak Battlegrounds / Yahse Hunting Grounds MYSTICAL_WARMTH: Prog = 1'},
            {t = 'event', zone = 256, event = 36, after = 's3', conf = 'inferred', why = 'Sylvie 36: plays only at Prog 1, after the warmth'},
         }},
        {id = 's7', at = {n = 7, fp = 'after receiving this message return to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Sylvie 36 with a free slot for the rewards)'},
         },
         reach = {
            {t = 'event', zone = 256, event = 36, after = 's3', why = 'Sylvie 36: the hand-in talk (also plays when the rewards cannot be given)'},
         }},
    },
}
