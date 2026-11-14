-- Step progress for The Gustaberg Tour (Bastok quest 45). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Gustaberg_Tour.lua (Izabele 745 begins the quest on finish, no refusal
-- branch; 746 is her reminder while accepted; Hunting Bear plays 22 and runs quest:complete only for a party of two or more
-- at level 15 or below, otherwise 21, a refusal whose first line is the same as 22's); client event scripts S4
-- 237_Izabele_010ED05F.txt (745 say #8132, 746 say #8136) and 106_Hunting_Bear_0106A292.txt (22 say #7480 after the
-- party check, 21 say #7478). The draft's chat line "You've talked to my partner, I assume?" opens both 21 and 22, so it is
-- replaced by a line only 22 plays. The Notes-section bullets are not steps. Not repeatable.
return {
    title = 'The Gustaberg Tour',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to izabele to begin the'},
         done = {
            {t = 'event', zone = 237, event = 745, why = 'Izabele 745: the quest begun'},
            {t = 'chat', re = "Hey, you're an adventurer, aren't you%?", why = 'Izabele 745 (say #8132)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 237, event = 746, conf = 'inferred', why = 'Izabele 746: reminder, only while accepted'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'invite at least one other player'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'together with your party travel to'}},
        {id = 's4', at = {n = 4, fp = 'speak with hunting bear to complete'},
         done = {
            {t = 'event', zone = 106, event = 22, why = 'Hunting Bear 22: the party accepted, completes the quest (21 is the refusal)'},
            {t = 'chat', re = 'Okay, you check out%.', why = 'Hunting Bear 22 (say #7480)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 106, event = 23, conf = 'inferred', why = 'Hunting Bear 23: plays only once completed'},
         }},
    },
}
