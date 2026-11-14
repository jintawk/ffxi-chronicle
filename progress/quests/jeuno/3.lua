-- Step progress for Save the Clock Tower (Jeuno quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Save_the_Clock_Tower.lua (Collet 164 is a plain talk while the quest is
-- available; Derrick 230 is a menu that plays on every talk, accepted or not, and only option 20 gives the Tower Petition and
-- begins the quest, so it is a reach and the log's current bit proves the step; Souren 120 is his talk while accepted; the
-- ten signatures are ten different trade events, one per NPC, whose count LandSandBoat keeps in a private variable;
-- trading the petition to Derrick with all ten plays 231, which runs quest:complete; the reward is a title only, so there is
-- no refusal; Souren 181 plays once completed). Client event scripts S4 244_Collet_010F4010.txt (164 say #7290),
-- 244_Souren_010F4003.txt (120 say #7042, 181 say #7047) and 245_Derrick_010F5021.txt (231 say #7753). Item 555 from res/items.lua. The
-- signature bullet (n=3) has no event of its own that tells the tenth from the others (231 is the completing trade of the
-- next bullet), so it stays a plain bullet and the individual signatures are not used. Not repeatable.
return {
    title = 'Save the Clock Tower',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional speak to collet near the'},
         done = {
            {t = 'event', zone = 244, event = 164, why = 'Collet 164: the gossip, only while the quest is available'},
            {t = 'chat', re = "They're going to take down the clock%.", why = 'Collet 164 (say #7290)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to derrick in lower jeuno'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Derrick 230, option 20)'},
            {t = 'item', id = 555, gained = true, conf = 'inferred', why = 'Tower Petition gained'},
            {t = 'event', zone = 244, event = 120, conf = 'inferred', why = 'Souren 120: his talk, only while accepted'},
            {t = 'chat', re = "Come to think of it, Narihira doesn't stop by anymore%.", conf = 'inferred', why = 'Souren 120 (say #7042)'},
         },
         reach = {{t = 'event', zone = 245, event = 230, why = 'Derrick 230 (the menu; option 20 begins the quest)'}}},
        {id = 's4', at = {n = 4, fp = 'once you have all 10 signatures'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 231, why = 'Derrick 231: the petition with ten signatures accepted, runs quest:complete'},
            {t = 'chat', re = "How's the petition going%?", why = 'Derrick 231 (say #7753)'},
            {t = 'event', zone = 244, event = 181, conf = 'inferred', why = 'Souren 181: plays only once completed'},
            {t = 'chat', re = "So the clock tower's safe%?", conf = 'inferred', why = 'Souren 181 (say #7047)'},
         }},
    },
}
