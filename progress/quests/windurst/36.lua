-- Step progress for Truth, Justice, and the Onion Way! (Windurst quest 36). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB1_Truth_Justice_and_the_Onion_Way.lua (Kohlo-Lakolo 368 is the offer and
-- only option 0 begins the quest; 371 is his reminder while accepted; 378 plays on the exact trade of one Rarab Tail and runs
-- quest:complete in onEventFinish, but the Justice Badge reward needs a free slot and 378 plays without that check, so 378 is
-- `reach` and the quest log's completed bit carries the last step). The other Port Windurst villagers' reminder lines (372 to
-- 377) belong to no bullet. Client event script S4 240_Kohlo_Lakolo_010F0052.txt (368 is a menu with no dialogue line, 371 say
-- #4199, 378 say_as #4215).
return {
    title = 'Truth, Justice, and the Onion Way!',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to kohlo lakolo behind warehouse'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kohlo-Lakolo 368, option 0)'},
            {t = 'event', zone = 240, event = 371, conf = 'inferred', why = 'Kohlo-Lakolo 371: reminder, only while accepted'},
            {t = 'chat', re = "If you bring us a tail, we'll let you join the Star Onion Brigade!", conf = 'inferred', why = 'Kohlo-Lakolo 371 (say #4199)'},
         },
         reach = {{t = 'event', zone = 240, event = 368, why = 'Kohlo-Lakolo 368 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'obtain and trade him a rarab'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 240, event = 378, why = 'Kohlo-Lakolo 378: the Rarab Tail accepted (also plays with a full bag, when the reward fails)'},
            {t = 'chat', re = "It'th a tail like mommy wanted!", why = 'Kohlo-Lakolo 378 (say_as #4215)'},
         }},
    },
}
