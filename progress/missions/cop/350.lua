-- Step progress for Tending Aged Wounds (Chains of Promathia 3-4, mission id 350). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/3_4_Tending_Aged_Wounds.lua; no client scripts for either event, so the ids are
-- LandSandBoat's. The Lower Jeuno (245) zone-in cutscene 70 plays only at status 0 (bullet 1); the Door: Neptune's Spire (_6tc, event
-- 22, status 1) is the Tenshodo headquarters cutscene of bullet 2 and completes the mission. Dropped from the draft: the completion
-- it had put on bullet 3 (that bullet and bullet 4 only name quests that open afterwards, so they keep their plain bullets) and
-- Cid 862 (Metalworks, played once per zone, no bullet).
return {
    title = 'Tending Aged Wounds',
    completes = 's2',
    known = {{t = 'mission', line = 'cop', eq = 350}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into lower jeuno for a'},
         done = {
            {t = 'zonein', zone = 245, event = 70, why = 'Lower Jeuno zone-in cutscene 70 (status 0 only, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'enter neptune s spire and click'},
         done = {
            {t = 'mission', line = 'cop', eq = 350, completed = true, why = 'mission log: Tending Aged Wounds completed'},
            {t = 'event', zone = 245, event = 22, why = "Door: Neptune's Spire 22: the Tenshodo cutscene, completes (status 1, LandSandBoat)"},
         }},
    },
}
