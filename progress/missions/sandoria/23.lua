-- Step progress for The Heir to the Light (San d'Oria mission 9-2, mission id 23). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/9_2_The_Heir_to_the_Light.lua. The mission is a chain of cutscenes, nearly all of
-- them zone-ins: Northern San d'Oria zone-in 1 (status 0 -> 1), Chateau d'Oraguille zone-in 10 (status 1 -> 2), Fei'Yin zone-in 23
-- (status 2 -> 3), then after the Qu'Bia Arena battlefield Northern San d'Oria zone-in 0 (status 4 -> 5), the Great Hall door 8 (status 5 -> 6),
-- the Heavy Stone Door in King Ranperre's Tomb 14 (status 6 -> 7) and Halver 9 (status 7; completes and gives the San d'Orian flag). The final
-- Southern San d'Oria zone-in 0 plays once after the log has completed, so it is a post step gated on s10. The battlefield leaves no event of
-- its own and the fight bullets are notes on the zone-in that follows it. None of these ids has a decoded body in the client scripts, so the
-- ids come from LandSandBoat. The optional Prince Royal's / Regent's doors and the Papal Chamber door are indented or not bullets.
return {
    title = 'The Heir to the Light',
    completes = 's10',
    known = {{t = 'mission', line = 'sandoria', min = 23}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into northern san d oria'},
         done = {
            {t = 'zonein', zone = 231, event = 1, why = "Northern San d'Oria zone-in 1 (status 0, LandSandBoat)"},
         }},
        {id = 's2', at = {n = 2, fp = 'zone into chateau d oraguille for'},
         done = {
            {t = 'zonein', zone = 233, event = 10, why = "Chateau d'Oraguille zone-in 10 (status 1, LandSandBoat)"},
         }},
        {id = 's3', at = {n = 3, fp = 'head to fei yin for a'},
         done = {
            {t = 'zonein', zone = 204, event = 23, why = "Fei'Yin zone-in 23 (status 2, LandSandBoat)"},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'make your way to qu bia'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'part one will have death clan'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'part two will include prince trion'}},
        {id = 's7', at = {n = 7, fp = 'upon clearing the battlefield zone into'},
         done = {
            {t = 'zonein', zone = 231, event = 0, after = 's3', why = "Northern San d'Oria zone-in 0 after the battlefield (status 4, LandSandBoat)"},
         }},
        {id = 's8', at = {n = 8, fp = 'head to the chateau and check'},
         done = {
            {t = 'event', zone = 233, event = 8, after = 's3', why = 'Door: Great Hall 8 (status 5, LandSandBoat)'},
         }},
        {id = 's9', at = {n = 9, fp = 'make your way to h 8'},
         done = {
            {t = 'event', zone = 190, event = 14, why = 'Heavy Stone Door 14 (status 6, LandSandBoat)'},
         }},
        {id = 's10', at = {n = 10, fp = 'go back to the chateau and'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 23, completed = true, why = 'mission log: The Heir to the Light completed'},
            {t = 'event', zone = 233, event = 9, why = 'Halver 9 (status 7, completes; LandSandBoat)'},
         }},
        {id = 's11', kind = 'post', at = {n = 11, fp = 'zone into southern san d oria'},
         done = {
            {t = 'zonein', zone = 230, event = 0, after = 's10', why = "Southern San d'Oria zone-in 0: the epilogue (LandSandBoat)"},
         }},
    },
}
