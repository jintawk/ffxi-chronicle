-- Step progress for The Scent of Battle (Wings of the Goddess mission 26, mission id 26). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/27_The_Scent_of_Battle.lua (Bulwark Gate, Sauromugue Champaign [S] 98: event 9 on every
-- touch while the mission is current, no menu, its finish completes the mission; not in the client pseudo-code). The page says the
-- Lion Springs cutscene (bullet 1) begins the mission; LandSandBoat has no Lion Springs event in this mission (the mission starts when
-- Fate in Haze ends, at its zone-in cutscene 155), so bullet 1 rests on the mission line moving to id 26 (completed = false), as
-- the accept step of the nation missions does. The draft's White stratum abyssite key item is dropped: the page only names it as a
-- travel aid and no script hands it out here.
return {
    title = 'The Scent of Battle',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 26}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the lion springs tavern in'},
         done = {
            {t = 'mission', line = 'wotg', eq = 26, completed = false, why = 'mission line: current mission = The Scent of Battle'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the bulwark gate in sauromugue'},
         done = {
            {t = 'event', zone = 98, event = 9, why = 'Bulwark Gate 9: the cutscene, completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 26, completed = true, why = 'mission log: The Scent of Battle completed'},
         }},
    },
}
