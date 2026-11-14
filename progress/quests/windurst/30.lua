-- Step progress for Glyph Hanger (Windurst quest 30). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Glyph_Hanger.lua (Hariga-Origa 381 is the offer and only option 0 begins the
-- quest and gives key item 25, so it is a reach; 382 is her reminder while accepted; Ipupu 47 takes key item 25 and gives key
-- item 26 in its finish, with nothing to fail; Hariga-Origa 385 takes key item 26 and runs quest:complete, whose reward is a key
-- item, fame and experience but no item; 386 is her talk once completed). Client event scripts S4 238_Hariga_Origa_010EE014.txt
-- (382 say #8204, 386 #8217), 115_Ipupu_0107321A.txt (47 #7422); key items 25, 26 from res/key_items.lua. The draft turned the
-- first two bullets into notes and put the whole quest on the Ipupu bullet; the offer is a real step (the quest log and the
-- key item prove it), the note-given bullet leads into the Ipupu delivery, and the last bullet is the hand-in that completes.
-- The quest log is set at s1, so it is not silent.
return {
    title = 'Glyph Hanger',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to hariga origa in windurst'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 25, gained = true, why = 'note from Hariga-Origa obtained'},
            {t = 'ki_have', id = 25, have = true, why = 'note from Hariga-Origa held'},
            {t = 'chat', re = 'obtained key item: note from hariga%-origa', why = 'chat: key item obtained'},
            {t = 'event', zone = 238, event = 382, why = 'Hariga-Origa 382: reminder, only while accepted'},
            {t = 'chat', re = 'Hurry up and pass that memo to Ipupu', why = 'Hariga-Origa 382 (say #8204)'},
         },
         reach = {{t = 'event', zone = 238, event = 381, why = 'Hariga-Origa 381 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will be given the note'}},
        {id = 's3', at = {n = 3, fp = 'she will accept the item and'},
         done = {
            {t = 'event', zone = 115, event = 47, why = 'Ipupu 47: takes the first note, gives the second'},
            {t = 'chat', re = 'Ohoho! Just kidding%-widding, my dear!', why = 'Ipupu 47 (say #7422)'},
            {t = 'ki', id = 26, gained = true, why = 'note from Ipupu obtained'},
            {t = 'ki_have', id = 26, have = true, why = 'note from Ipupu held'},
            {t = 'chat', re = 'obtained key item: note from ipupu', why = 'chat: key item obtained'},
            {t = 'ki', id = 25, gained = false, after = 's1', conf = 'inferred', why = 'note from Hariga-Origa handed over'},
         }},
        {id = 's4', at = {n = 4, fp = 'after delivering the note you will'},
         done = {
            {t = 'event', zone = 238, event = 385, why = 'Hariga-Origa 385: the note from Ipupu handed over, completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 26, gained = false, after = 's3', conf = 'inferred', why = 'note from Ipupu handed over'},
            {t = 'event', zone = 238, event = 386, why = 'Hariga-Origa 386: her talk once completed'},
            {t = 'chat', re = 'Let me see%.%.%. What was that book about%?', why = 'Hariga-Origa 386 (say #8217)'},
         }},
    },
}
