-- Step progress for The Tenshodo Showdown (Windurst quest 69). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/THF_AF1_The_Tenshodo_Showdown.lua (Nanaa Mihgo 496 begins the quest with no
-- option test and gives the Letter; Harnek 10021 takes the Letter for the Tenshodo envelope; Elfriede 10002 and 10003 are her
-- talk before and after the stew is wanted and 10004 is the accepted stew trade, which swaps the envelope for the Signed
-- envelope; Harnek 10022 completes the quest, but only if quest:complete can pay the reward, so it is a reach and the quest log
-- carries the last step; 497 and 498 are Nanaa's reminders and 503 an after-quest line); client event scripts S4
-- 241_Nanaa_Mihgo_010F1072.txt, 245_Harnek_010F500D.txt, 248_Elfriede_010F8008.txt; key items from res/key_items.lua (183 letter,
-- 184 Tenshodo envelope, 185 Signed envelope). The Harnek line "You have completed your assignment?" plays whether or not the
-- reward can be given, so it is not used. Repeatable after a memory reset (page meta): Nanaa 496 plays only while the quest is
-- available, so it opens the next run. The quest log is set at s1, so it is not silent.
return {
    title = 'The Tenshodo Showdown',
    completes = 's9',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to nanaa mihgo as a'},
         done = {
            {t = 'event', zone = 241, event = 496, why = 'Nanaa Mihgo 496: the quest begins'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki', id = 183, gained = true, why = 'letter from the Tenshodo obtained'},
            {t = 'ki_have', id = 183, have = true, why = 'letter from the Tenshodo held'},
            {t = 'chat', re = 'obtained key item: letter from the tenshodo', why = 'chat: key item obtained'},
            {t = 'event', zone = 241, event = 497, conf = 'inferred', why = 'Nanaa Mihgo 497: reminder, only once accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to lower jeuno and talk'},
         done = {
            {t = 'event', zone = 245, event = 10021, why = 'Harnek 10021: the Letter handed over'},
            {t = 'chat', re = 'Wait in that room over there%.', why = 'Harnek 10021 (say #7937)'},
            {t = 'ki', id = 184, gained = true, why = 'Tenshodo envelope obtained'},
            {t = 'ki_have', id = 184, have = true, why = 'Tenshodo envelope held'},
            {t = 'chat', re = 'obtained key item: tenshodo envelope', why = 'chat: key item obtained'},
            {t = 'ki', id = 183, gained = false, conf = 'inferred', why = 'letter from the Tenshodo handed over'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you will be given the tenshodo'}},
        {id = 's4', at = {n = 4, fp = 'travel to selbina and talk to'},
         done = {
            {t = 'event', zone = 248, event = 10002, why = 'Elfriede 10002'},
            {t = 'chat', re = "Welcome to the Shepherd's Muster%.", why = 'Elfriede 10002 (say #7286)'},
            {t = 'event', zone = 248, event = 10003, conf = 'inferred', why = 'Elfriede 10003: only once 10002 is done'},
         }},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'quadav stew can only be stolen'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'head to beadeaux and steal from'}},
        {id = 's7', at = {n = 7, fp = 'once you get the quadav stew'},
         done = {
            {t = 'event', zone = 248, event = 10004, why = 'Elfriede 10004: the Quadav Stew accepted'},
            {t = 'chat', re = 'What an amazing display of thievery!', why = 'Elfriede 10004 (say #7298)'},
            {t = 'ki', id = 185, gained = true, why = 'signed envelope obtained'},
            {t = 'ki_have', id = 185, have = true, why = 'signed envelope held'},
            {t = 'chat', re = 'obtained key item: signed envelope', why = 'chat: key item obtained'},
            {t = 'ki', id = 184, gained = false, conf = 'inferred', why = 'Tenshodo envelope handed over'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'you will receive the signed envelope'}},
        {id = 's9', at = {n = 9, fp = 'head back to lower jeuno and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 185, gained = false, conf = 'inferred', why = 'signed envelope handed over'},
         },
         reach = {{t = 'event', zone = 245, event = 10022, why = 'Harnek 10022 (completion needs a free slot for the reward)'}}},
    },
}
