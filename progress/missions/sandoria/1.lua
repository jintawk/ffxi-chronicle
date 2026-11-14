-- Step progress for Bat Hunt (San d'Oria mission 1-2, mission id 1). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/1_2_Bat_Hunt.lua. The mission menu is event 2009/1009 in the three gate guards
-- (option 101 = Bat Hunt), so the menu proves nothing; what proves the accept is the line the client says only on the accept branch
-- (say #7260 in 230_Ambrotien_010E6062.txt and 230_Endracion_010E6061.txt, say #26 with the same text in 231_Grilau_010E7022.txt)
-- and the nation line moving to id 1 (completed = false, run1 as in the pilot). The Tombstone (King Ranperre's Tomb 190, event 4)
-- plays only for this mission while its status is below 2 (LandSandBoat: mission:progressCutscene(4); the quests that use that
-- Tombstone play event 2); it has no client script in S4, the id is LandSandBoat's. The first completion is the Orcish Mail Scales
-- trade (Ambrotien 2023, Endracion 1023, Grilau 1023; the wrong-item trade plays no event), the repeat is the Bat Fang trade
-- (2003 / 1003); all four finish handlers call mission:complete. Both completion groups sit on s5 (the run's completing step),
-- the repeat events also on the branch bullet s7. The kill-bats bullet (s3) has no signal of its own (the scales are an item and
-- can come from the AH), so it is a note on the turn-in; the order of s3 and s4 is free on the page.
-- The draft marked every bullet a note and found no event for the Tombstone: fixed. Its mission matcher min = 3 style "past"
-- guesses are not used anywhere: the line holds 65535 after a completion, which is above every id.
return {
    title = 'Bat Hunt',
    completes = 's5',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any san d orian'},
         done = {
            {t = 'chat', re = "Deep in the tomb you'll find Goblins%. Take care; I don't want to lose you yet%.", why = 'a gate guard, accepted (say #7260)'},
            {t = 'mission', line = 'sandoria', eq = 1, completed = false, run1 = true, why = 'mission line: current mission = Bat Hunt'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'go to h 11 in east'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'kill ding bats in king ranperre'}},
        {id = 's4', at = {n = 4, fp = 'touch the tombstone at h i'},
         done = {
            {t = 'event', zone = 190, event = 4, why = 'Tombstone (Upper): the cutscene, only while this mission is current'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to a gate guard and'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 1, completed = true, why = 'mission log: Bat Hunt completed'},
            {t = 'event', zone = 230, event = 2023, why = 'Ambrotien 2023: the Orcish Mail Scales accepted, first completion'},
            {t = 'event', zone = 230, event = 1023, why = 'Endracion 1023: the Orcish Mail Scales accepted, first completion'},
            {t = 'event', zone = 231, event = 1023, why = 'Grilau 1023: the Orcish Mail Scales accepted, first completion'},
            {t = 'event', zone = 230, event = 2003, why = 'Ambrotien 2003: the Bat Fang accepted, repeat'},
            {t = 'event', zone = 230, event = 1003, why = 'Endracion 1003: the Bat Fang accepted, repeat'},
            {t = 'event', zone = 231, event = 1003, why = 'Grilau 1003: the Bat Fang accepted, repeat'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'the gate guard will ask for'}},
        {id = 's7', kind = 'branch', at = {n = 7, fp = 'trade the bat fang to the'},
         done = {
            {t = 'event', zone = 230, event = 2003, why = 'Ambrotien 2003: the Bat Fang accepted'},
            {t = 'event', zone = 230, event = 1003, why = 'Endracion 1003: the Bat Fang accepted'},
            {t = 'event', zone = 231, event = 1003, why = 'Grilau 1003: the Bat Fang accepted'},
         }},
    },
}
