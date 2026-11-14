-- Step progress for Fall of the Hawk (Wings of the Goddess mission id 35). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/36_Fall_of_the_Hawk.lua. Castle Zvahl Baileys [S] (138) zone-in cutscene 4 plays whenever
-- the mission is current (the script's only condition) and its finish completes the mission, so it is the completing event; the draft
-- had it unplaced and the bullet as a note on itself. No client script exists for this id.
return {
    title = 'Fall of the Hawk',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 35}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter castle zvahl baileys s to'},
         done = {
            {t = 'mission', line = 'wotg', eq = 35, completed = true, why = 'mission log: Fall of the Hawk completed'},
            {t = 'zonein', zone = 138, event = 4, why = 'Baileys [S] zone-in cutscene 4: completes the mission'},
         }},
    },
}
