-- Step progress for Joy! Summoned to a Fabulous Fete (A Moogle Kupo d'Etat mission 12, mission id 11). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/12_Joy_Summoned_to_a_Fabulous_Fete.lua. Zoning into Castle Zvahl Baileys (161) while this
-- mission is current returns cutscene 88 from onZoneIn; its finish calls mission:complete. The cutscene id comes from the 0x00A zone-in
-- packet, so it is a zonein matcher (P.on_zonein keeps the zone and event pair a mapping names). The mkd line has no completed set in
-- Chronicle, so the completion is the line moving to 12.
return {
    title = 'Joy! Summoned to a Fabulous Fete',
    completes = 's1',
    known = {{t = 'mission', line = 'mkd', eq = 11}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 11, why = 'mission line: current mission = Joy! Summoned to a Fabulous Fete'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into castle zvahl baileys for'},
         done = {
            {t = 'zonein', zone = 161, event = 88, why = 'Castle Zvahl Baileys zone-in cutscene 88: completes the mission'},
            {t = 'mission', line = 'mkd', min = 12, why = 'mission line: moved on to A Challenge! You Could Be a Winner (this one completed)'},
         }},
    },
}
