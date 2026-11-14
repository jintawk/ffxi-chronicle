-- Step progress for In the Name of the Father (Wings of the Goddess mission 8, mission id 7). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/08_In_the_Name_of_the_Father.lua. The only step is the Lion Springs door in Southern
-- San d'Oria [S] (zone 80): it plays event 85 once the nation's quest pair is done, and its finish calls mission:complete. Bullets
-- 1 and 2 say what the mission unlocks and how it starts, notes on bullet 3. The draft made bullet 1 a step proven by the log's
-- "current mission = 7"; fixed.
return {
    title = 'In the Name of the Father',
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 7}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'once you begin this mission you'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'this mission is triggered automatically after'}},
        {id = 's3', at = {n = 3, fp = 'upon completion of your respective quests'},
         done = {
            {t = 'event', zone = 80, event = 85, why = 'Lion Springs 85: completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 7, completed = true, why = 'mission log: In the Name of the Father completed'},
         }},
    },
}
