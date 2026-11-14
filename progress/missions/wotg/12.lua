-- Step progress for Borne by the Wind (Wings of the Goddess mission 13, mission id 12). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/13_Borne_by_the_Wind.lua. The mission is one examine: the Bulwark Gate in Sauromugue
-- Champaign [S] (zone 98) plays event 5 while it is current, and its finish calls mission:complete and hands out the Underpass
-- hatch key (a reward key item, not used: it is also given again by the next mission's Bulwark Gate 6). The reminders Radford 177
-- and Velda-Galda 180 prove nothing and are not used. The draft listed the key item and its chat line as proof; dropped.
return {
    title = 'Borne by the Wind',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 12}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'in sauromugue champaign s examine the'},
         done = {
            {t = 'event', zone = 98, event = 5, why = 'Bulwark Gate 5: completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 12, completed = true, why = 'mission log: Borne by the Wind completed'},
         }},
    },
}
