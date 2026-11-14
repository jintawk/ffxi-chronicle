-- Step progress for Way of the Cook (quest other 1). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ2_Way_of_the_Cook.lua (Rycharde 76 is the offer and only option 74
-- begins the quest, so it is a reach; the accept line "Thanks! Remember, I need them within three days!" plays on accept
-- only; 78 is his talk while accepted; 80 (in time) and 81 (late) both follow a trade of exactly a Slice of Dhalmel Meat
-- and a Beehive Chip and run quest:complete; the first bullet is the 8 real hour wait, a note); client event script S4
-- 249_Rycharde_010F9009.txt (76 say #6896, 78 say #6898, 80 say #6900, 81 say #6901). Two different items are traded, so
-- there is no `count`. Not repeatable.
return {
    title = 'Way of the Cook',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you need to wait 8 real'}},
        {id = 's2', at = {n = 2, fp = 'speak to rycharde to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'Thanks! Remember, I need them within three days!', why = 'Rycharde 76, accepted (say #6896)'},
            {t = 'event', zone = 249, event = 78, conf = 'inferred', why = 'Rycharde 78: his talk, only while accepted'},
            {t = 'chat', re = 'Go and get those things I asked for, quick!', conf = 'inferred', why = 'Rycharde 78 (say #6898)'},
         },
         reach = {{t = 'event', zone = 249, event = 76, why = 'Rycharde 76 offered (its finish needs option 74)'}}},
        {id = 's3', at = {n = 3, fp = 'trade rycharde a dhalmel meat and'},
         done = {
            {t = 'event', zone = 249, event = 80, why = 'Rycharde 80: both items accepted in time, runs quest:complete'},
            {t = 'chat', re = "You got them! They're still fresh, too!", why = 'Rycharde 80 (say #6900)'},
            {t = 'event', zone = 249, event = 81, why = 'Rycharde 81: both items accepted late, runs quest:complete'},
            {t = 'chat', re = "Ah%.%.%.thanks, but when I saw you wouldn't make it, I asked someone else%.", why = 'Rycharde 81 (say #6901)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
