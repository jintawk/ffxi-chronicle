-- Step progress for Northland Exposure (Wings of the Goddess mission 16, mission id 16). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/17_Northland_Exposure.lua. Beaucedine Glacier [S] (136) onZoneIn returns cutscene 13
-- only while this mission is current (event 13 is used by no other script for that zone), and its finish completes the mission and
-- hands out the Shadow bug (key item 1128, a reward and so only inferred). The draft's bullet was a note on itself with no matcher;
-- fixed: the bullet is the step. The indented line about the Survival Guide is a travel tip, not a step. The cutscene is the 0x00A
-- zone-in event, so it is only seen live; the mission log and the key item carry a login backfill.
return {
    title = 'Northland Exposure',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 16}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into beaucedine glacier s for'},
         done = {
            {t = 'zonein', zone = 136, event = 13, why = 'Beaucedine Glacier [S] zone-in cutscene 13 (mission current only), completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 16, completed = true, why = 'mission log: Northland Exposure completed'},
            {t = 'ki', id = 1128, gained = true, conf = 'inferred', why = 'Shadow bug obtained (the reward)'},
            {t = 'ki_have', id = 1128, have = true, conf = 'inferred', why = 'Shadow bug held'},
         }},
    },
}
