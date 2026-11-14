-- Step progress for Sandswept Memories (Wings of the Goddess mission 15, mission id 15). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/16_Sandswept_Memories.lua. Lion Springs (the tavern door, Southern San d'Oria [S] 80)
-- plays event 146 on every touch while this mission is current; it has no menu to refuse and its finish completes the mission. 146 is
-- not used by any other script in the zone (the next mission uses 151 at the same door). The door is not in the client pseudo-code,
-- so the id is LandSandBoat's. The draft is kept: mission completed + event 146.
return {
    title = 'Sandswept Memories',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 15}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'proceed to lion springs tavern at'},
         done = {
            {t = 'event', zone = 80, event = 146, why = 'Lion Springs door 146: the cutscene, completes the mission (LandSandBoat)'},
            {t = 'mission', line = 'wotg', eq = 15, completed = true, why = 'mission log: Sandswept Memories completed'},
         }},
    },
}
