-- Step progress for Raptor Rapture (Adoulin quest 73). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Western_Adoulin/npcs/Pagnelle.lua, Gontrain.lua and Zone.lua. Pagnelle 5032 is the
-- introduction chain that ends in the offer (Zone.lua event 5056, or Pagnelle 5061 on a later talk), and the quest is
-- added only on option 1, so 5032, 5056 and 5061 also play on a refusal: they are reaches, and the quest log's current bit
-- proves bullet 1. While accepted: Pagnelle 5033 (reminder, go to Ilney), Gontrain 5034 (Status 4 only, no option),
-- Pagnelle 5035 (Status 5 only), 5036 (reminder, rockberries missing), 5037 (all three Rockberry key items held, takes them),
-- 5038 (reminder, go to Rala), 5039 (finishes the quest). The draft put 5037 and 5038 on the Gontrain-return bullet; they
-- belong to the rockberry hand-in (bullet 5, 5037) and the Rala wait (reach on bullet 7, 5038). The three rockberries are
-- key items 2201 to 2203 (all named "rockberry"); it is not known in which order the harvesting hands them out, so only
-- the third is used and it is flagged inferred. The Rala cutscene (bullet 6) has no script and is a note on the last bullet.
-- Client event script S4 256_Pagnelle_011000C9.txt (5033 say #9265); the other events have no text.
return {
    title = 'Raptor Rapture',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with pagnelle g 10 in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (offer option 1 at the end of the introduction chain)'},
         },
         reach = {
            {t = 'event', zone = 256, event = 5032, why = 'Pagnelle 5032: the introduction chain (also before a refusal)'},
            {t = 'event', zone = 256, event = 5061, why = 'Pagnelle 5061: the offer again after a refusal (its finish needs option 1)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with gontrain h 12 next'},
         done = {
            {t = 'event', zone = 256, event = 5034, why = 'Gontrain 5034: plays only while accepted at Status 4'},
         },
         reach = {
            {t = 'event', zone = 256, event = 5033, why = 'Pagnelle 5033: his reminder to go to Ilney, only while accepted'},
            {t = 'chat', re = 'Please, I beg of you%-%-go to Ilney, and listen to his story%.', why = 'Pagnelle 5033 (say #9265)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to pagnelle for another cutscene'},
         done = {
            {t = 'event', zone = 256, event = 5035, why = 'Pagnelle 5035: plays only at Status 5, after Gontrain'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to the ceizak battlegrounds and'},
         done = {
            {t = 'ki', id = 2203, gained = true, conf = 'inferred', why = 'third rockberry obtained (the order the three are handed out is not known)'},
            {t = 'ki_have', id = 2203, have = true, conf = 'inferred', why = 'third rockberry held'},
         },
         reach = {
            {t = 'event', zone = 256, event = 5036, why = 'Pagnelle 5036: his reminder to bring the rockberries'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to pagnelle for another cutscene'},
         done = {
            {t = 'event', zone = 256, event = 5037, why = 'Pagnelle 5037: plays only with all three rockberries held, takes them'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'travel to the rala waterways enter'}},
        {id = 's7', at = {n = 7, fp = 'return to pagnelle to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 256, event = 5039, why = 'Pagnelle 5039: runs completeQuest'},
         },
         reach = {
            {t = 'event', zone = 256, event = 5038, why = 'Pagnelle 5038: his reminder to go to Rala'},
         }},
    },
}
