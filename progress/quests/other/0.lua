-- Step progress for Rycharde the Chef (quest other 0). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ1_Rycharde_the_Chef.lua (Numi Adaligo's job question is event 50, which
-- is shared with Emissary from the Seas and leaves Prog = 1, so its bullet is a note; Take 60 plays only at Prog 1 and
-- sets Prog 2; Rycharde 70 and 71 are the offer and play on accept AND decline, so they are a reach only; accepting runs
-- quest:begin and the client's "Good! Better hurry up" line; 72 is his talk while accepted; trading exactly two Slices of
-- Dhalmel Meat is event 74, which runs quest:complete); client event scripts S4 249_Take_010F9008.txt (60 say #6880) and
-- 249_Rycharde_010F9009.txt (70 say #6882/#6885, 72 say #6888, 74 say #6891). Take 68 is shared with Way of the Cook and
-- is not used. Item id 4359 (Slice of Dhalmel Meat, "Dhalmel Meat" in res/items.lua). Not repeatable.
return {
    title = 'Rycharde the Chef',
    completes = 's4',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak to numi adaligo f 9'}},
        {id = 's2', at = {n = 2, fp = 'speak to take i 8 on'},
         done = {
            {t = 'event', zone = 249, event = 60, why = 'Take 60 (only at Prog 1, owned by this quest alone)'},
            {t = 'chat', re = "Welcome to the Sailors' Stay%.", why = 'Take 60 (say #6880)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to rycharde on the second'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = "Good! Better hurry up%. Time's a%-wastin'%.", why = 'Rycharde 70/71, accepted (say #6885)'},
            {t = 'event', zone = 249, event = 72, conf = 'inferred', why = 'Rycharde 72: his talk, only while accepted'},
            {t = 'chat', re = "How's it going%? You're not done yet, huh%?", conf = 'inferred', why = 'Rycharde 72 (say #6888)'},
         },
         reach = {
            {t = 'event', zone = 249, event = 70, why = 'Rycharde 70 offered (plays on decline too)'},
            {t = 'event', zone = 249, event = 71, why = 'Rycharde 71 offered again (plays on decline too)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade rycharde 2 dhalmel meat to'}, count = {item = 4359, need = 2},
         done = {
            {t = 'event', zone = 249, event = 74, why = 'Rycharde 74: exactly two Dhalmel Meat accepted, runs quest:complete'},
            {t = 'chat', re = "I've been an apprentice chef for more than three years now, but someday I'll be a first%-rate chef!", why = 'Rycharde 74 (say #6891)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
