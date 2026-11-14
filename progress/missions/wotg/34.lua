-- Step progress for Flight of the Lion (Wings of the Goddess mission id 34). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/35_Flight_of_the_Lion.lua. The Bulwark Gate (Sauromugue Champaign [S] 98) plays event 10
-- with no menu; its finish completes the mission. No client script exists for this id.
return {
    title = 'Flight of the Lion',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 34}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the bulwark gate in sauromugue'},
         done = {
            {t = 'mission', line = 'wotg', eq = 34, completed = true, why = 'mission log: Flight of the Lion completed'},
            {t = 'event', zone = 98, event = 10, why = 'Bulwark Gate 10: completes the mission'},
         }},
    },
}
