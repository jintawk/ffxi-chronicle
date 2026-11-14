-- Step progress for Paradise, Salvation, and Maps (Other Areas quest 68). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Paradise_Salvation_and_Maps.lua (Nivorajean 223 begins the quest; 224 is his
-- reminder; a Sacrarium treasure chest gives the Piece of ripped floorplans, Temporary KI 605; 225 plays while it is held, and
-- its finish always takes it and records the chosen position; 226 asks for another day; 227 is a wrong position and resets the
-- loop to the start; 228 is a correct position the next game day and completes the quest); client event script S4
-- 026_Nivorajean_0101A045.txt (223 say #10756, 224 say #10759 (shared with 223), 225 say #10762, 226 say #10771, 228 say
-- #10774). The draft piled every Nivorajean event on bullet 1 and took "Rhapsody in White" (KI 2884, only the way to buy the
-- chest key, not given by this quest) as proof of bullet 2; the chest key is an item that can already be owned, so bullets 2-3
-- are notes. Bullet 6 (the position menu) is the choice inside event 225, with no event of its own, so it is a note. The
-- wrong-position event 227 is left out: it loops the quest back and proves nothing new.
return {
    title = 'Paradise, Salvation, and Maps',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to nivorajean i 9 to'},
         done = {
            {t = 'event', zone = 26, event = 223, why = 'Nivorajean 223: begins the quest'},
            {t = 'chat', re = 'Have you ever journeyed to the Sacrarium%?', why = 'Nivorajean 223 (say #10756)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 224, conf = 'inferred', why = 'Nivorajean 224: his reminder while accepted'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'go to sacrarium and obtain a'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'locate the position of a treasure'}},
        {id = 's4', at = {n = 4, fp = 'open the treasure chest to obtain'},
         done = {
            {t = 'ki', id = 605, gained = true, why = 'Piece of ripped floorplans obtained'},
            {t = 'ki_have', id = 605, have = true, why = 'Piece of ripped floorplans held'},
            {t = 'chat', re = 'obtained key item: piece of ripped floorplans', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to nivorajean and talk to'},
         done = {
            {t = 'event', zone = 26, event = 225, after = 's1', why = 'Nivorajean 225: the floorplans handed in, the position chosen'},
            {t = 'chat', re = 'Yes, this looks similar to the set of plans I found before%.%.%.', after = 's1', why = 'Nivorajean 225 (say #10762)'},
            {t = 'ki', id = 605, gained = false, conf = 'inferred', why = 'Piece of ripped floorplans handed over'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'select the position of the chest'}},
        {id = 's7', at = {n = 7, fp = 'if you selected correctly then he'},
         done = {
            {t = 'event', zone = 26, event = 228, after = 's1', why = 'Nivorajean 228: the correct position, completes the quest'},
            {t = 'chat', re = '! I succeeded in completing the', after = 's1', why = 'Nivorajean 228 (say #10774)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 26, event = 226, after = 's5', why = 'Nivorajean 226: the map needs a day'},
            {t = 'chat', re = 'It will take me about a day to complete my work on the map of the Sacrarium%.', after = 's5', why = 'Nivorajean 226 (say #10771)'},
         }},
    },
}
