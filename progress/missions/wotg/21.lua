-- Step progress for A Sanguinary Prelude (Wings of the Goddess mission 21, mission id 21). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/22_A_Sanguinary_Prelude.lua. Beaucedine Glacier [S] (136) onZoneIn returns cutscene 17
-- only while this mission is current (no other script uses 17 for that zone); its finish completes the mission and hands out the
-- Aroma bug (key item 1160, a reward and so only inferred; it can also be re-issued later, which is still after this mission). The
-- draft's bullet was a note on itself with no matcher; fixed. The cutscene is the 0x00A zone-in event, seen live only; the mission log
-- and the key item carry a login backfill.
return {
    title = 'A Sanguinary Prelude',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 21}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into beaucedine glacier s for'},
         done = {
            {t = 'zonein', zone = 136, event = 17, why = 'Beaucedine Glacier [S] zone-in cutscene 17 (mission current only), completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 21, completed = true, why = 'mission log: A Sanguinary Prelude completed'},
            {t = 'ki', id = 1160, gained = true, conf = 'inferred', why = 'Aroma bug obtained (the reward)'},
            {t = 'ki_have', id = 1160, have = true, conf = 'inferred', why = 'Aroma bug held'},
         }},
    },
}
