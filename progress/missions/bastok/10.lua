-- Step progress for The Four Musketeers (Bastok mission 3-1, mission id 10). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/3_1_The_Four_Musketeers.lua. The page has no accept bullet; the nation line
-- moving to id 10 (65535 = no mission before; completing sets it back to 65535 and adds id 10 to the completed set) only
-- marks the mission as known. Iron Eater (Metalworks 237): event 715 is the briefing and has no body in the pseudo-code, and
-- the status is only set on option 0, so 715 may play on a decline: it is only `reach`. Event 716 plays only once that status is
-- set (the mission is current and status is not 0), which proves the briefing was taken. Entering Beadeaux (147) with status 1
-- plays zone-in cutscene 120. After 20 Copper Quadav kills (counted by the server, not observable), entering Pashhow
-- Marshlands (109) from Beadeaux plays cutscene 11 and completes the mission; cutscene 10 plays on an early exit with fewer
-- kills, so it proves nothing. Ayame 718 and Naji 717 are plain talks once the briefing is taken and prove nothing more.
-- The two Recommendations bullets are notes. Zone-in event ids come from LandSandBoat's onZoneIn (no NPC pseudo-code).
return {
    title = 'The Four Musketeers',
    completes = 's4',
    known = {{t = 'mission', line = 'bastok', eq = 10}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to iron eater inside the'},
         done = {
            {t = 'event', zone = 237, event = 716, why = 'Iron Eater 716: the briefing taken (plays only once the status is set)'},
         },
         reach = {
            {t = 'event', zone = 237, event = 715, why = 'Iron Eater 715: the briefing (its finish needs option 0)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you ll be instructed to go'}},
        {id = 's3', at = {n = 3, fp = 'zone in to beadeaux for a'},
         done = {
            {t = 'zonein', zone = 147, event = 120, why = 'Beadeaux zone-in cutscene 120 (played only at status 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'upon killing 20 copper quadavs zone'},
         done = {
            {t = 'zonein', zone = 109, event = 11, why = 'Pashhow Marshlands zone-in cutscene 11 (only after 20 kills): the mission completed'},
            {t = 'mission', line = 'bastok', eq = 10, completed = true, why = 'mission log: The Four Musketeers completed'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'while you are in beadeaux it'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'view this walkthrough on the mission'}},
    },
}
