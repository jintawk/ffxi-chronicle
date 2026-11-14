-- Step progress for Chains and Bonds (Chains of Promathia 7-1, mission id 648). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/7_1_Chains_and_Bonds.lua. The Tavnazian Safehold (26) zone-in cutscene 114 plays only
-- at status 1, which is set once the Ducal Guard's Ring has been handed over, so it proves bullet 1 (LandSandBoat only: no client
-- script for a zone-in). The Lufaise Meadows (24) zone-in 111 (status 0) is the ring scene itself and only marks the step as under
-- way; it also plays when the bag is full and the ring is stashed, so it never proves the step, and neither does the ring or the
-- 'no room' line. The three cutscenes of bullet 2 are indented sub-bullets (the Walnut Door 115 and the Sewer Entrance 116 in the
-- Safehold, the Sealion's Den zone-in 14), each played only while its Option bit is unset; the mission completes when all three
-- are set, so bullet 2 is proved by the cop log alone and the three events are in-progress marks. The draft's Despachiaire /
-- Justinius reminders (318, 135) are dropped.
return {
    title = 'Chains and Bonds',
    completes = 's2',
    known = {{t = 'mission', line = 'cop', eq = 648}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after the scene in lufaise meadows'},
         done = {
            {t = 'zonein', zone = 26, event = 114, why = 'Tavnazian Safehold zone-in cutscene 114 (status 1, after the ring)'},
         },
         reach = {
            {t = 'zonein', zone = 24, event = 111, why = 'Lufaise Meadows zone-in cutscene 111: the ring scene (status 0)'},
         }},
        {id = 's2', at = {n = 2, fp = 'the following cutscenes can be done'},
         done = {
            {t = 'mission', line = 'cop', eq = 648, completed = true, why = 'mission log: Chains and Bonds completed'},
         },
         reach = {
            {t = 'event', zone = 26, event = 115, why = 'Walnut Door 115 (Option bit 0 unset)'},
            {t = 'event', zone = 26, event = 116, why = 'Sewer Entrance 116 (Option bit 1 unset)'},
            {t = 'zonein', zone = 32, event = 14, why = "Sealion's Den zone-in cutscene 14 (Option bit 2 unset)"},
         }},
    },
}
