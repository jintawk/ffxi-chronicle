-- Step progress for Passing Glory (Treasures of Aht Urhgan, mission id 17). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/18_Passing_Glory.lua: Whitegate (50) event 3090 (Naja Salaheem, or the Salaheem's Sentinels
-- trigger area) runs mission:complete in onEventFinish, whatever the option. Bullet 2 (the Gessho cushion, under the Trust
-- heading) is a tip that comes after the mission starts and has no signal: left as a plain bullet. The draft's post step (current
-- mission = 17) was dropped, it described the wrong moment.
return {
    title = 'Passing Glory',
    completes = 's1',
    known = {{t = 'mission', line = 'toau', eq = 17}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach naja salaheem for a cutscene'},
         done = {
            {t = 'event', zone = 50, event = 3090, why = "Naja Salaheem 3090: completes the mission"},
            {t = 'mission', line = 'toau', eq = 17, completed = true, why = "mission log: Passing Glory completed"},
         }},
    },
}
