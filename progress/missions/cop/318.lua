-- Step progress for A Vessel Without a Captain (Chains of Promathia 3-2, mission id 318). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/3_2_A_Vessel_Without_a_Captain.lua; no client script decodes the door or the trigger area,
-- so the ids are LandSandBoat's. The Neptune's Spire door (_6tc, Lower Jeuno 245) plays event 86 only at status 0; the Ru'Lude Gardens
-- stairs trigger area (243) plays event 65 at status 1 and completes the mission, so bullet 2 is the completing step (the draft had it
-- as a note and put a current-value proof on the quest list in bullet 3). Bullets 3 and 4 list other quests and stay plain bullets.
-- Cid 861 (once per zone, any status) and Harnek 12 (a reminder) are dropped.
return {
    title = 'Vessel Without a Captain',
    completes = 's2',
    known = {{t = 'mission', line = 'cop', eq = 318}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter neptune s spire in lower'},
         done = {
            {t = 'event', zone = 245, event = 86, why = "Neptune's Spire door 86 (status 0 only)"},
         }},
        {id = 's2', at = {n = 2, fp = 'go to ru lude gardens h'},
         done = {
            {t = 'mission', line = 'cop', eq = 318, completed = true, why = 'mission log: A Vessel Without a Captain completed'},
            {t = 'event', zone = 243, event = 65, why = "Ru'Lude Gardens stairs trigger area 65: completes (status 1)"},
         }},
    },
}
