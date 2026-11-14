-- Step progress for The Chamber of Oracles (Rise of the Zilart mission 7, mission id 14). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/rotz/07_The_Chamber_of_Oracles.lua; key items 239 (Fire fragment) and 246 (Dark fragment)
-- from res/key_items.lua; zone 168 = Chamber of Oracles. Placing the eighth fragment in a pedestal plays event 1 (also replayed if
-- the cutscene was interrupted); its finish takes all eight fragments (fire 239 to dark 246) and completes the mission. Event 1 in
-- that zone plays only from these pedestals while the mission is current, and the earlier placements are only zone messages, so the
-- one bullet is the whole mission. Zone 168 has no client script for the pedestals (LandSandBoat's id). The fragments are held
-- until this event, so their loss is a hand-in; the Prismatic fragment reward is not used. `known` is the previous mission (id 12)
-- or anything after it completed. The draft had only the mission-line proof; the event and the key item losses are added.
return {
    title = 'The Chamber of Oracles',
    completes = 's1',
    known = {{t = 'mission', line = 'zilart', min = 12, completed = true}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you ll be in a room'},
         done = {
            {t = 'event', zone = 168, event = 1, why = 'Pedestals 1: the cutscene once all eight fragments are placed (completes, LandSandBoat)'},
            {t = 'mission', line = 'zilart', eq = 14, completed = true, why = 'mission log: The Chamber of Oracles completed'},
            {t = 'ki', id = 239, gained = false, why = 'Fire fragment taken at the completion'},
            {t = 'ki', id = 246, gained = false, why = 'Dark fragment taken at the completion'},
         }},
    },
}
