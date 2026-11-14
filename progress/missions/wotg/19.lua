-- Step progress for On Thin Ice (Wings of the Goddess mission 19, mission id 19). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/20_On_Thin_Ice.lua; client event script S4 080_Raustigne_010501EF.txt (event 147 exists
-- with an empty body; the same NPC owns 148 for Proof of Valor and 149 for The Will of the World). Raustigne (Southern San d'Oria [S]
-- 80) plays 147 on every talk while this mission is current; there is no menu and its finish completes the mission. The draft is kept.
return {
    title = 'On Thin Ice',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 19}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to raustigne at southern san'},
         done = {
            {t = 'event', zone = 80, event = 147, why = 'Raustigne 147: the cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 19, completed = true, why = 'mission log: On Thin Ice completed'},
         }},
    },
}
