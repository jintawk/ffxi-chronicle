-- Step progress for The Cursed Temple (Rhapsodies of Vana'diel mission, page id 209). Data only; see progress/missions/adoulin/134.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_24_The_Cursed_Temple.lua. Bullet 1: the zone-in scene 93 of the Temple of Uggalepih, played
-- once (Status 0) while this mission is current and Zilart mission 4 is done; the page says some players do not get it, so the step is optional
-- and a later step infers it done. Bullet 2: the Granite Door `_4fx` plays event 94 only when Zilart mission 4 is done (else a message), and
-- its finish completes the mission and moves the line on. Event 94 is also the door scene of the next mission (Wisdom of Our Forefathers,
-- page 211), which the finish above has already completed, so it only ever ticks this step on a mission that is behind it. Bullets 3 to 6
-- are the directions to the door (notes on bullet 2). No client event script for 93 or 94.
-- The client's table puts this mission at 209, LandSandBoat's enum at 210 (102 + 108): `known` takes both. The rov line has no completed set,
-- so the completion is `min = 211` (Wisdom of Our Forefathers is 103 + 108; the finish moves the line to 212, Where Divinities Collide).
return {
    title = 'The Cursed Temple',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', eq = 209}, {t = 'mission', line = 'rov', eq = 210}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'head to temple of uggalepih in'},
         done = {
            {t = 'zonein', zone = 159, event = 93, why = 'Temple of Uggalepih zone-in scene 93 (once, while this mission is current)'},
         }},
        {id = 's2', at = {n = 2, fp = 'navigate your way to the granite'},
         done = {
            {t = 'event', zone = 159, event = 94, why = 'Granite Door 94: the mission scene, its finish completes'},
            {t = 'mission', line = 'rov', min = 211, why = 'mission log: the line moved past The Cursed Temple'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'when you zone into temple of'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'follow this path until you reach'}},
        {id = 's5', kind = 'note', with = 's2', at = {n = 5, fp = 'take each right that doesn t'}},
        {id = 's6', kind = 'note', with = 's2', at = {n = 6, fp = 'keep left the entire time until'}},
    },
}
