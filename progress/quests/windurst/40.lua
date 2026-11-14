-- Step progress for Know One's Onions (Windurst quest 40). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB2_Know_Ones_Onions.lua. Kohlo-Lakolo 391 (Windurst rank under 3, "in time")
-- or 388 (rank 3 or more, "late") start the quest on any outcome; 392 / 389 / 387 are his reminders while accepted. The trade
-- of 4 Wild Onions is 398 in time (sets Prog 2; 399 is his reminder afterwards, so only possible after the trade) and 390 when
-- late: 390 completes the quest at once, which the page's sub-bullet describes ("in some cases this will end the quest"). Both
-- the late path (390, 386) and the finish (400) run quest:complete with the Scroll of Blaze Spikes as a reward, which needs a free
-- slot while the event plays regardless, so 390, 386 and 400 are `reach` and the quest log's completed bit carries the last step
-- (a late finish therefore shows the House of the Hero step as done too, by the completion). The House of the Hero door in
-- Windurst Walls is event 288 (progressEvent, sets Prog 3; only possible after the trade, in time). The draft made the last
-- bullet a post-completion bullet; on the main path it is the completing step. Client event script S4 240_Kohlo_Lakolo_010F0052.txt
-- (391 say_as #4256, 388 say #4245, 392 say #4269, 398 say #4281, 399 say #4283, 390 say #4248, 389 say #4247); the
-- other Port Windurst villagers' lines belong to no bullet.
return {
    title = "Know One's Onions",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'before you begin you are required'}},
        {id = 's2', at = {n = 2, fp = 'speak to kohlo lakolo port windurst'},
         done = {
            {t = 'event', zone = 240, event = 391, why = 'Kohlo-Lakolo 391: begins the quest (in time)'},
            {t = 'chat', re = 'No one is supposed to live there', why = 'Kohlo-Lakolo 391 (say_as #4256)'},
            {t = 'event', zone = 240, event = 388, why = 'Kohlo-Lakolo 388: begins the quest (late)'},
            {t = 'chat', re = 'You missed some pretty cool action while you were away', why = 'Kohlo-Lakolo 388 (say #4245)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 392, conf = 'inferred', why = 'Kohlo-Lakolo 392: reminder, only while accepted'},
            {t = 'event', zone = 240, event = 389, conf = 'inferred', why = 'Kohlo-Lakolo 389: reminder, late, only while accepted'},
            {t = 'event', zone = 240, event = 387, conf = 'inferred', why = 'Kohlo-Lakolo 387: reminder, late, only while accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'retrieve 4 wild onions and trade'}, count = {item = 4387, need = 4},
         done = {
            {t = 'event', zone = 240, event = 398, why = 'Kohlo-Lakolo 398: the 4 Wild Onions accepted (in time)'},
            {t = 'chat', re = 'Now we can put our plan into action', why = 'Kohlo-Lakolo 398 (say #4281)'},
            {t = 'event', zone = 240, event = 399, conf = 'inferred', why = 'Kohlo-Lakolo 399: reminder, only after the trade'},
         },
         reach = {
            {t = 'event', zone = 240, event = 390, why = 'Kohlo-Lakolo 390: the late trade (also plays with a full bag, when the reward fails)'},
            {t = 'chat', re = 'These are just what I wanted', why = 'Kohlo-Lakolo 390 (say #4248)'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to house of the hero'},
         done = {
            {t = 'event', zone = 239, event = 288, why = 'House of the Hero door 288 (Prog 3, only after the trade)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to kohlo lakolo and speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 240, event = 400, why = 'Kohlo-Lakolo 400: the finish (also plays with a full bag, when the reward fails)'},
            {t = 'event', zone = 240, event = 386, why = 'Kohlo-Lakolo 386: the late finish (also plays with a full bag)'},
         }},
    },
}
