-- Step progress for Land of Sacred Serpents (Treasures of Aht Urhgan mission 1, mission id 0). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/01_Land_of_Sacred_Serpents.lua. The mission is current from character creation, so the line
-- moving to 0 proves nothing. The cutscene is a trigger area in Aht Urhgan Whitegate (zone 50): event 3000 plays only for this mission and its
-- finish always completes it (the Supplies package, a reward key item, is not used). The quest bullet (The Road to Aht Urhgan) and the
-- travel and Home Point bullets leave no trace on this mission's line, so they are notes on the step they lead into.
return {
    title = 'Land of Sacred Serpents',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 0}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'complete the quest the road to'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to mhaura and take the'}},
        {id = 's3', at = {n = 3, fp = 'approach naja salaheem at i 10'},
         done = {
            {t = 'event', zone = 50, event = 3000, why = 'Aht Urhgan Whitegate trigger area 3: event 3000, finish completes the mission'},
            {t = 'mission', line = 'toau', eq = 0, completed = true, why = 'mission log: Land of Sacred Serpents completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'if this is your first time'}},
    },
}
