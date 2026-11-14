-- Step progress for The First Meeting (Bastok quest 52). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/MNK_AF2_The_First_Meeting.lua (Oggbi 233 begins the quest on finish, no refusal
-- branch; zoning into Fei'Yin from Qu'Bia Arena plays 16 and gives the Letter from Dalzakk; the Davoi Hide Flap plays 108 on
-- every click, spawns the two NMs while the letter is held, and gives the San d'Orian martial arts scroll only after both
-- are dead; Oggbi 234 plays only with both key items held and runs quest:complete, which takes them). Oggbi's event script
-- (S4 236_Oggbi_010EC07D.txt) has no distinctive line for 233 or 234. The draft put the letter and the Fei'Yin zone-in on the
-- Hide Flap bullet; they belong to the Fei'Yin bullet, and the Hide Flap click (108) proves nothing, since it plays before the
-- NMs are killed and again after the scroll is held, so only the scroll proves that bullet. The zone-in (Fei'Yin 16) and the Hide Flap (Davoi
-- 108) events are in the quest script only, which check_steps cannot find under this title, so neither is used: the key items
-- say the same. The Davoi travel bullet is a note on the Hide Flap bullet. Event 234 also plays when the reward item (Temple Gaiters) cannot be given, so it is `reach`;
-- the key items are deleted only after the completion succeeded. The quest is repeatable after a Memory
-- reset, which opens a fresh accept (233 again), so the quest log's bits count for the first run only.
return {
    title = 'The First Meeting',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note if you just finished ghosts'}},
        {id = 's2', at = {n = 2, fp = 'talk to oggbi inside the steaming'},
         done = {
            {t = 'event', zone = 236, event = 233, why = 'Oggbi 233: the quest begun'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to fei yin your goal'},
         done = {
            {t = 'ki', id = 191, gained = true, why = 'letter from Dalzakk obtained'},
            {t = 'ki_have', id = 191, have = true, why = 'letter from Dalzakk held'},
            {t = 'chat', re = 'obtained key item: letter from dalzakk', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'travel to davoi and look for'}},
        {id = 's5', at = {n = 5, fp = 'when ready click the hide flap'},
         done = {
            {t = 'ki', id = 192, gained = true, why = "San d'Orian martial arts scroll obtained"},
            {t = 'ki_have', id = 192, have = true, why = "San d'Orian martial arts scroll held"},
            {t = 'chat', re = "obtained key item: san d'orian martial arts scroll", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'go back and talk to oggbi'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
            {t = 'ki', id = 191, gained = false, after = 's3', why = 'letter from Dalzakk taken (only after the completion succeeded)'},
            {t = 'ki', id = 192, gained = false, after = 's5', why = "San d'Orian martial arts scroll taken (only after the completion succeeded)"},
         },
         reach = {{t = 'event', zone = 236, event = 234, why = 'Oggbi 234: plays even when the Temple Gaiters do not fit, so it is not proof'}}},
    },
}
