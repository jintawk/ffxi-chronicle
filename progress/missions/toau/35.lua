-- Step progress for Gaze of the Saboteur (Treasures of Aht Urhgan mission 36, mission id 35). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/36_Gaze_of_the_Saboteur.lua; zone 78 = Hazhalm Testing Grounds (res/zones.lua), key item 877
-- = percipient eye (res/key_items.lua). Zone-in cutscene 6 plays only while this mission is current at status 0 (its finish sets status 1),
-- which is bullet 1. The Entry Gate (_260) plays event 7 only at status 1; its finish takes the Percipient Eye key item (given by the
-- previous mission, so its loss is a hand-in) and runs mission:complete, which is bullet 2. The draft left the gate as a note because no
-- bullet-level NPC was found: the page names it. The Luminian Dagger reward key item is not used.
return {
    title = 'Gaze of the Saboteur',
    completes = 's2',
    known = {{t = 'mission', line = 'toau', eq = 35}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into hazhalm testing grounds caedarva'},
         done = {
            {t = 'zonein', zone = 78, event = 6, why = 'Hazhalm Testing Grounds zone-in cutscene 6 (status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'check the entry gate for the'},
         done = {
            {t = 'event', zone = 78, event = 7, why = 'Entry Gate 7: the final cutscene, completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'toau', eq = 35, completed = true, why = 'mission log: Gaze of the Saboteur completed'},
            {t = 'ki', id = 877, gained = false, why = 'Percipient Eye taken at the completion'},
         }},
    },
}
