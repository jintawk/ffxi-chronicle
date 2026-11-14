-- Step progress for Imperial Coronation (Treasures of Aht Urhgan mission 46, mission id 45). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/46_Imperial_Coronation.lua; zone 50 = Aht Urhgan Whitegate. The Imperial Whitegate plays
-- event 3140 only when no weapon or shield is equipped and the armour check passes (otherwise 3081 plays), and its finish runs
-- mission:complete (the ring choice is in the same event), so bullet 4 is proved by it. Naja's 3150 is a briefing that plays on every talk
-- (LandSandBoat only), so bullet 1 is a note; the "Rhapsody in White" key item the draft used for bullet 2 is only a way to buy one of the
-- listed armours (a sub-bullet), so bullets 1 to 3 are notes on the door. The draft's reminder event 3155 plays after the mission is done.
return {
    title = 'Imperial Coronation',
    completes = 's4',
    known = {{t = 'mission', line = 'toau', eq = 45}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'before you can continue naja salaheem'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'wearing the following armors are known'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'in addition to the listed armor'}},
        {id = 's4', at = {n = 4, fp = 'check the imperial whitegate door at'},
         done = {
            {t = 'event', zone = 50, event = 3140, why = 'Imperial Whitegate 3140: the cutscene (dressed, unarmed), completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'toau', eq = 45, completed = true, why = 'mission log: Imperial Coronation completed'},
         }},
    },
}
