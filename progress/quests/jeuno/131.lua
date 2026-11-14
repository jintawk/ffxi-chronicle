-- Step progress for Riding on the Clouds (Jeuno quest 131). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB04_Riding_on_the_clouds.lua (Maat 88 is an Accept/Decline menu, option 1
-- begins the quest, so it is only a reach; 89 is his reminder while accepted without all four stones; each Kindred's Seal
-- trade at the clue's NPC gives one stone key item; with the smiling, scowling, somber and spirited stones all held he plays
-- 90, which completes the quest, pays no item and so cannot be refused, and takes the stones back); client event script S4
-- 243_Maat_010F3031.txt (88-90 carry no text). Key item ids 466-469 from res/key_items.lua (only this quest uses them). The
-- four stones come from four NPCs in any order, so they are reaches of the last step and the bullets between stay plain.
-- Maat's ids are unique to this quest. Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Riding on the Clouds',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to maat on a level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 243, event = 89, conf = 'inferred', why = 'Maat 89: his reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 243, event = 88, why = 'Maat 88 offered (its finish needs option 1)'}}},
        {id = 's5', at = {n = 5, fp = 'speak to maat once you have'},
         reach = {
            {t = 'ki', id = 466, gained = true, why = 'smiling stone obtained'},
            {t = 'ki', id = 467, gained = true, why = 'scowling stone obtained'},
            {t = 'ki', id = 468, gained = true, why = 'somber stone obtained'},
            {t = 'ki', id = 469, gained = true, why = 'spirited stone obtained'},
         },
         done = {
            {t = 'event', zone = 243, event = 90, why = 'Maat 90: all four stones handed over, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 70%.', why = 'Ru Lude Gardens text: level limit 70, shown once the quest is completed'},
            {t = 'ki', id = 466, gained = false, conf = 'inferred', why = 'smiling stone handed over'},
            {t = 'ki', id = 467, gained = false, conf = 'inferred', why = 'scowling stone handed over'},
            {t = 'ki', id = 468, gained = false, conf = 'inferred', why = 'somber stone handed over'},
            {t = 'ki', id = 469, gained = false, conf = 'inferred', why = 'spirited stone handed over'},
         }},
    },
}
