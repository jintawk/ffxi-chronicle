-- Step progress for The Queen of the Dance (Wings of the Goddess mission 4, mission id 3). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/04_The_Queen_of_the_Dance.lua. Status 0: the Lion Springs door in Southern San
-- d'Oria [S] (zone 80) plays event 68 (only once a nation's first follow-up quest pair is done), status 1; Turlough in Upper Jeuno
-- (244) plays 10172 and gives the Mayakov show ticket (key item 1022, a reward of that event, not used), status 2; the door then
-- plays 70 (status 3), the zone-in cutscenes 152 (status 3) and 153 (status 4) follow, and 153 completes the mission and takes the
-- ticket. Bullet 4 is one door touch that runs 70, 152 and 153, so 70 and 152 are reach and the completion proves it. The door's
-- reminder event 69 (status 1) proves nothing and is not used; bullet 1 is a note on bullet 2. The draft put 70 and 152 in the
-- completing step's proof and left no `completes`; fixed.
return {
    title = 'The Queen of the Dance',
    completes = 's4',
    known = {{t = 'mission', line = 'wotg', eq = 3}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'this mission is triggered automatically after'}},
        {id = 's2', at = {n = 2, fp = 'proceed to lion springs tavern k'},
         done = {
            {t = 'event', zone = 80, event = 68, why = 'Lion Springs 68: the door without a ticket (status 0)'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to present day upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 10172, why = 'Turlough 10172: the Mayakov show ticket handed out (status 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to lion springs tavern in'},
         done = {
            {t = 'zonein', zone = 80, event = 153, why = 'Southern San d\'Oria [S] zone-in cutscene 153: completes the mission (status 4)'},
            {t = 'mission', line = 'wotg', eq = 3, completed = true, why = 'mission log: The Queen of the Dance completed'},
         },
         reach = {
            {t = 'event', zone = 80, event = 70, why = 'Lion Springs 70: the door with the ticket (status 2)'},
            {t = 'zonein', zone = 80, event = 152, why = 'Southern San d\'Oria [S] zone-in cutscene 152 (status 3)'},
         }},
    },
}
