-- Step progress for Wish Upon a Star (Bastok quest 64). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Enu's first talk (s3, event 332 begins the quest), so the first two steps rest on events and
-- dialogue alone.
-- Evidence: LandSandBoat scripts/quests/bastok/Wish_Upon_a_Star.lua (Zacc 329 at Prog 0, Malene 330 at Prog 1, Enu 332 at Prog 2
-- begins the quest; 333 is Enu's accepted-state talk; the Yuhtunga Jungle Logging Point plays 205 with the Hatchet trade and
-- gives the Fallen Star 1192; Enu 334 on the star at a clear night completes, 337 is the wrong-weather refusal and proves
-- nothing; the reward bag of cactus stems is an item, so a full bag plays 334 without completing); client event scripts S4
-- 235_Zacc_010EB071.txt (329 is bare), 235_Malene_010EB004.txt (330 say #8233), 235_Enu_010EB072.txt (332, 334 bare; 333
-- say #8253) and 123_Logging_Point_0107B25E.txt (205 prints the logging result, so the event alone may play on a failed log:
-- only its "cut off" line naming the Fallen Star is used). Zacc 336 and Enu 335 are the completed-state talks.
return {
    title = 'Wish Upon a Star',
    completes = 's6',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to zacc g 9 who'},
         done = {
            {t = 'event', zone = 235, event = 329, why = 'Zacc 329: plays at Prog 0'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with malene i 5 more'},
         done = {
            {t = 'event', zone = 235, event = 330, why = 'Malene 330: plays at Prog 1, after Zacc'},
            {t = 'chat', re = "What's this%? You say you're looking for an Alisa%?", why = 'Malene 330 (say #8233)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to the fountain and speak'},
         done = {
            {t = 'event', zone = 235, event = 332, why = 'Enu 332: plays at Prog 2, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 235, event = 333, conf = 'inferred', why = 'Enu 333: accepted-state talk'},
            {t = 'chat', re = 'Remember, .- is a super%-special secret stone', conf = 'inferred', why = 'Enu 333 (say #8253)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'acquire a hatchet from the auction'}},
        {id = 's5', at = {n = 5, fp = 'travel to yuhtunga jungle and locate'},
         done = {
            {t = 'chat', re = 'you successfully cut off .-fallen star', why = 'Yuhtunga Jungle logging result (print #7725)'},
            {t = 'item', id = 1192, gained = true, conf = 'inferred', why = 'Fallen Star gained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to enu and trade her'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 235, event = 334, why = 'Enu 334: the star at a clear night (a full bag plays it too, no completion)'}}},
    },
}
