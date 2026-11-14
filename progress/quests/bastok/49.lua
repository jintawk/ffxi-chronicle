-- Step progress for Altana's Sorrow (Bastok quest 49). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Altanas_Sorrow.lua (Virnage 141 begins the quest only on option 0, a refusal
-- plays the same event; while accepted Virnage plays 142 with no key item, 143 with the Bucket of divine paint (which takes
-- it and gives the Letter from Virnage) and 144 with the letter; the Garlaige Citadel ??? gives the bucket; Eperdur 679 plays
-- only with the letter, runs quest:complete and takes it); client event scripts S4 234_Virnage_010EA06A.txt (143 say #11029,
-- 142 say #11027, 144 say #11031) and 231_Eperdur_010E70AE.txt (679 say #12180); key item ids from res/key_items.lua (173
-- bucket of divine paint, 174 letter from Virnage). Event 141 has no line of its own, so the start rests on the quest log,
-- with the reminder 142 as a later sign. The quest log is set at the accept. Eperdur 679 also plays when the reward
-- item (a teleport scroll) cannot be given, so it is `reach`; the quest log and the loss of the letter prove the last step.
-- Not repeatable.
return {
    title = "Altana's Sorrow",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with virnage located at i'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 234, event = 142, conf = 'inferred', why = 'Virnage 142: reminder, only while accepted'},
            {t = 'chat', re = 'Please, the Goddess needs your help!', conf = 'inferred', why = 'Virnage 142 (say #11027)'},
         },
         reach = {{t = 'event', zone = 234, event = 141, why = 'Virnage 141 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to garlaige citadel and locate'}},
        {id = 's3', at = {n = 3, fp = 'touch the to receive a bucket'},
         done = {
            {t = 'ki', id = 173, gained = true, why = 'bucket of divine paint obtained'},
            {t = 'ki_have', id = 173, have = true, why = 'bucket of divine paint held'},
            {t = 'chat', re = 'obtained key item: bucket of divine paint', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to bastok and speak with'},
         done = {
            {t = 'event', zone = 234, event = 143, why = 'Virnage 143: the paint taken, the letter given'},
            {t = 'chat', re = 'I would like to repay you for your deeds, but I have nothing to give you at the moment%.', why = 'Virnage 143 (say #11029)'},
            {t = 'ki', id = 174, gained = true, why = 'letter from Virnage obtained'},
            {t = 'ki_have', id = 174, have = true, why = 'letter from Virnage held'},
            {t = 'chat', re = 'obtained key item: letter from virnage', why = 'chat: key item obtained'},
            {t = 'ki', id = 173, gained = false, conf = 'inferred', why = 'bucket of divine paint handed over'},
            {t = 'event', zone = 234, event = 144, conf = 'inferred', why = 'Virnage 144: plays only with the letter held'},
            {t = 'chat', re = 'May the Gates of Paradise open for you%.', conf = 'inferred', why = 'Virnage 144 (say #11031)'},
         }},
        {id = 's5', at = {n = 5, fp = 'travel to northern san d oria'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 174, gained = false, after = 's4', why = 'letter from Virnage taken (only after the completion succeeded)'},
         },
         reach = {{t = 'event', zone = 231, event = 679, why = 'Eperdur 679: plays even when the reward scroll does not fit, so it is not proof'},
                  {t = 'chat', re = 'Ah, you have met Virnage%?', why = 'Eperdur 679 (say #12180)'}}},
    },
}
