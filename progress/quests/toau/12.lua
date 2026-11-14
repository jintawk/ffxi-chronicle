-- Step progress for A Taste of Honey (Aht Urhgan quest 12). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/A_Taste_of_Honey.lua (needs Vanishing Act completed; Qutiba 55 and Ulamaal
-- 56 are the "come back later" talks before the quest and Fochacha 50 a plain talk, so none is used; Qutiba or Ulamaal 579 is
-- the cutscene that begins the quest with no refusal; while accepted Qutiba's talk is 585; trading exactly three Pots of White
-- Honey plays 580, which runs quest:complete, whose reward is an Irmik Helvasi, so 580 replays on a full bag and is only a
-- reach: the completed bit proves the trade; once completed Qutiba's recipe talk is 57 and trading one honey plays 581, both
-- ignored). Client event script S4 050_Qutiba_01032101.txt (585 say #6864, 55 say #9216); 579 and 580 have no text. White Honey
-- (item 5562) counts toward the trade bullet. The re-zone and the several talks (bullets 1 and 3) are notes. Not repeatable.
return {
    title = 'A Taste of Honey',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'after completing vanishing act re zone'}},
        {id = 's2', at = {n = 2, fp = 'talk to qutiba at k 12'},
         done = {
            {t = 'event', zone = 50, event = 579, why = 'Qutiba or Ulamaal 579: the cutscene, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 585, why = 'Qutiba 585: her talk while accepted'},
            {t = 'chat', re = 'You should be able to gather', why = 'Qutiba 585 (say #6864)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'you may have to talk to'}},
        {id = 's4', at = {n = 4, fp = 'trade qutiba three pots of white'}, count = {item = 5562, need = 3},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 580, why = 'Qutiba 580: three honey traded (replays if the Irmik Helvasi cannot be given)'}}},
    },
}
