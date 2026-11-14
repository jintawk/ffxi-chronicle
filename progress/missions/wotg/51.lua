-- Step progress for Where It All Began (Wings of the Goddess, mission id 51). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/52_Where_It_All_Began.lua: the Lion Springs door (Southern San d'Oria [S] 80) plays
-- 175 with no conditions beyond the mission, and its finish runs mission:complete. The Wedding invitation is the reward key item.
return {
    title = 'Where It All Began',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 51}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the door to lion springs'},
         done = {
            {t = 'event', zone = 80, event = 175, why = 'Lion Springs door 175: the cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 51, completed = true, why = 'mission log: Where It All Began completed'},
         }},
    },
}
