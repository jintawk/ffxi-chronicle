-- Step progress for Starting a Flame (San d'Oria quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Starting_a_Flame.lua (Legata 37 option 1 begins the quest; 35 is her reminder
-- while it is accepted; 36 is the trade of 4 Flint Stone and completes it); client event script S4 230_Legata_010E60C8.txt
-- (37 say #8914 on the accept branch only, 35 say #8916, 36 say #8917); item id from res/items.lua. Event 37 also plays on a
-- refusal and, once the quest is done, as the "another one" reminder, so it only reaches s1. The draft's 35 pattern holds the
-- item placeholder ")" and is dropped; event 35 itself carries the reminder. Repeatable (page meta), but the trade needs no
-- new talk, so there is no `repeatable` entry (as in Tiger's Teeth, quest 23).
return {
    title = 'Starting a Flame',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to legata in the lion'},
         done = {
            {t = 'chat', re = "Excellent! Then I'll be waiting%.", why = 'Legata 37, accepted (say #8914)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 35, conf = 'inferred', why = 'Legata 35: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 230, event = 37, why = 'Legata 37 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade her 4 flint stones for'}, count = {item = 768, need = 4},
         done = {
            {t = 'event', zone = 230, event = 36, why = 'Legata 36: the trade of 4 Flint Stone'},
            {t = 'chat', re = "Thank you so much! Here's something in return%.", why = 'Legata 36 (say #8917)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
