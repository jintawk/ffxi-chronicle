-- Step progress for Dancers in Distress (Wings of the Goddess mission 9, mission id 8). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/09_Dancers_in_Distress.lua. Status 0: Raustigne in Southern San d'Oria [S] (zone 80)
-- plays event 86, status 1. Status 1: the Elegant Footprints in Jugner Forest [S] (zone 82) play event 2 (the quiz, updated by
-- options; its finish sets status 2). Status 2: trading the quiz item plays event 3 (only when it is the chosen item and the player
-- has zoned; a wrong trade or too soon plays nothing), and its finish completes the mission. Bullet 3 (the quiz item to fetch) is a
-- note on bullet 4. Bullet 5, the Cernunnos Bulb advice, stays a plain bullet. The draft was right apart from the missing
-- `completes`; the trade event also carries the log's completion.
return {
    title = 'Dancers in Distress',
    completes = 's4',
    known = {{t = 'mission', line = 'wotg', eq = 8}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to raustigne in southern san'},
         done = {
            {t = 'event', zone = 80, event = 86, why = 'Raustigne 86 (status 0)'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the elegant footprints in jugner'},
         done = {
            {t = 'event', zone = 82, event = 2, why = 'Elegant Footprints 2: the quiz (status 1)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'you will be asked to retrieve'}},
        {id = 's4', at = {n = 4, fp = 'zone logging out doesn t count'},
         done = {
            {t = 'event', zone = 82, event = 3, why = 'Elegant Footprints 3: the quiz item accepted, completes the mission (status 2)'},
            {t = 'mission', line = 'wotg', eq = 8, completed = true, why = 'mission log: Dancers in Distress completed'},
         }},
    },
}
