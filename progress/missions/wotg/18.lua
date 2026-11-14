-- Step progress for Betrayal at Beaucedine (Wings of the Goddess mission 18, mission id 18). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/19_Betrayal_at_Beaucedine.lua (Regal Pawprints 2, Beaucedine Glacier [S] 136, none of it
-- in the client pseudo-code). Status 0: pawprints event 15 (no menu; its finish moves to status 1). Status 1: the second touch spawns
-- Count Halphas with the text "unwanted attention" and plays no event; his death sets status 2. Status 2: event 16 (finish moves to
-- status 3 and warps you beside the pawprints), then the zone-in cutscene 30 completes the mission. Bullet 2 (the fight) has no event of
-- its own and a defeat leaves no trace, so it is a note on the step that follows it; event 16 can only play after Halphas is dead, so
-- it proves the fight too. Bullet 3 holds event 16 and the completing zone-in 30. The draft's event 15 / 16 both on bullet 1 is fixed:
-- 16 belongs to bullet 3.
return {
    title = 'Betrayal at Beaucedine',
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 18}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the regal pawprints h 9'},
         done = {
            {t = 'event', zone = 136, event = 15, why = 'Regal Pawprints 15: the first cutscene (status 0, LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examining the regal pawprints a second'}},
        {id = 's3', at = {n = 3, fp = 'once defeated examine the regal pawprints'},
         done = {
            {t = 'event', zone = 136, event = 16, why = 'Regal Pawprints 16: the cutscene after Count Halphas (status 2, LandSandBoat)'},
            {t = 'zonein', zone = 136, event = 30, why = 'Beaucedine Glacier [S] zone-in cutscene 30 (status 3): completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 18, completed = true, why = 'mission log: Betrayal at Beaucedine completed'},
         }},
    },
}
