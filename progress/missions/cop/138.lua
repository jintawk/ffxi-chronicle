-- Step progress for An Invitation West (Chains of Promathia 2-1, mission id 138). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/2_1_An_Invitation_West.lua (no client event scripts exist for the two zone-ins, so the
-- ids are LandSandBoat's). Lufaise Meadows (24) zone-in 110 plays at status 0 and its finish takes the Mysterious amulet (key item
-- 579, res/key_items.lua; the "has been stolen" line is Lufaise text 7705); Tavnazian Safehold (26) zone-in 101 plays at status 1
-- and its finish completes the mission, so it is bullet 3 (the draft had it as a note and put the first cutscene alone on bullet 1).
-- Bullet 2 is travel and a note on bullet 3.
return {
    title = 'An Invitation West',
    completes = 's3',
    known = {{t = 'mission', line = 'cop', eq = 138}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after clearing all three promyvions you'},
         done = {
            {t = 'zonein', zone = 24, event = 110, why = 'Lufaise Meadows zone-in 110 (status 0, LandSandBoat)'},
            {t = 'ki', id = 579, gained = false, conf = 'inferred', why = 'Mysterious amulet taken in the cutscene'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'when the cutscene ends make your'}},
        {id = 's3', at = {n = 3, fp = 'after reaching tavnazian safehold zone in'},
         done = {
            {t = 'mission', line = 'cop', eq = 138, completed = true, why = 'mission log: An Invitation West completed'},
            {t = 'zonein', zone = 26, event = 101, why = 'Tavnazian Safehold zone-in 101: completes (status 1, LandSandBoat)'},
         }},
    },
}
