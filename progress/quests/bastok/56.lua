-- Step progress for The Talekeeper's Gift (Bastok quest 56). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Deidogg takes the Ginger Cookie (s4, event 172 begins the quest), so the first steps rest on
-- events alone.
-- Evidence: LandSandBoat scripts/quests/bastok/WAR_AF3_The_Talekeepers_Gift.lua (Deidogg 170 at Prog 0, Detzo 171 at Prog 1,
-- Deidogg 172 on the cookie begins the quest; the Behemoth's Dominion ??? plays 100 on every touch and its option 0 spawns the
-- three NMs with YOU_HEAR_A_NOISE, so only that line proves the spawn; the Qufim Island zone-in 100 from Behemoth's Dominion
-- completes the quest); zones/Behemoths_Dominion/IDs.lua (THERE_ARE_SYMBOLS, YOU_HEAR_A_NOISE); client event script S4
-- 234_Deidogg_010EA003.txt (170 say #11097; 172 is bare) and 234_Detzo_010EA016.txt (171 is bare). The draft put the zone-in 100
-- (Qufim Island, zone 126) on the ??? bullet; it completes bullet 7. Repeatable after a Memory reset: the restart is the next 170.
return {
    title = "The Talekeeper's Gift",
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's4'}},
    repeatable = {restart = {'s2'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you must wait until the next'}},
        {id = 's2', at = {n = 2, fp = 'speak to deidogg in bastok mines'},
         done = {
            {t = 'event', zone = 234, event = 170, why = 'Deidogg 170'},
            {t = 'chat', re = 'Hey, remember when Iron Eater showed up here%?', why = 'Deidogg 170 (say #11097)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to detzo in bastok mines'},
         done = {
            {t = 'event', zone = 234, event = 171, why = 'Detzo 171: plays only after Deidogg 170'},
         }},
        {id = 's4', at = {n = 4, fp = 'obtain a ginger cookie and trade'},
         done = {
            {t = 'event', zone = 234, event = 172, why = 'Deidogg 172: the cookie accepted, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'travel to behemoth s dominion'}},
        {id = 's6', at = {n = 6, fp = 'proceed to k 9 in behemoth'},
         done = {
            {t = 'chat', re = 'you hear a noise behind you%.', why = 'Behemoth\'s Dominion YOU_HEAR_A_NOISE: the NMs spawned'},
         },
         reach = {{t = 'chat', re = 'there are some symbols inscribed upon it%.', why = 'Behemoth\'s Dominion THERE_ARE_SYMBOLS: the ??? touched'}}},
        {id = 's7', at = {n = 7, fp = 'defeat the nms and zone out'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'zonein', zone = 126, event = 100, after = 's4', why = 'Qufim Island zone-in 100 from Behemoth\'s Dominion (a full bag plays it too, no completion)'}}},
    },
}
