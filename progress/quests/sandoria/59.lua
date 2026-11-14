-- Step progress for Trial by Ice (San d'Oria quest 59). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Gulmama.lua (706 offers the quest; option 1 adds it and gives
-- the Tuning fork of ice 332; 718 re-gives a lost fork and 707 is the accepted-state talk; 709 is the reward menu: with no
-- free slot it plays and the quest is NOT completed, so 709 is never proof, the quest log is) and
-- scripts/battlefields/Cloister_of_Frost/trial_by_ice.lua (the win gives Whisper of frost 324); client event script S4
-- 231_Gulmama_010E70C8.txt (706 say #12813 is the accept branch; 718 say #12905; 707 and 709 are not decoded there).
-- Repeatable once per Earth day: the tuning fork stays held after a finish, so its login snapshot is run 1 only (run1) and
-- the restart is the next acceptance (quest log current, the fork gained, the accept line). Bullets 5 to 11 are tips.
-- Shared-signal audit (2026-10-28): s1's 706 chat is tightened to 'Here, take this tuning fork of ice. But be warned' (the other Trial givers say the same line with their own key item); dropped the 718 chat (the same words play in Trial by Earth, Fire and Water);
-- dropped the loss of key item 324 in s4 (The Moonlit Path, Windurst quest 9, deletes all six whispers at Leepe-Hoppe 844); the completed bit and the 709 reach stay.
return {
    title = 'Trial by Ice',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with gulmama to obtain quest'},
         done = {
            {t = 'chat', re = 'Here, take this tuning fork of ice%. But be warned', why = 'Gulmama 706 (say #12813, accept branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 332, gained = true, why = 'tuning fork of ice obtained'},
            {t = 'ki_have', id = 332, have = true, run1 = true, why = 'tuning fork of ice held (stays held after a finish)'},
            {t = 'chat', re = 'obtained key item: tuning fork of ice', why = 'chat: key item obtained'},
            {t = 'event', zone = 231, event = 718, conf = 'inferred', why = 'Gulmama 718: a new fork, only once accepted'},
            {t = 'event', zone = 231, event = 707, conf = 'inferred', why = 'Gulmama 707: accepted-state talk'},
         },
         reach = {{t = 'event', zone = 231, event = 706, why = 'Gulmama 706 offered (accepting needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to beaucedine glacier and enter'}},
        {id = 's3', at = {n = 3, fp = 'defeat shiva prime to receive the'},
         done = {
            {t = 'ki', id = 324, gained = true, why = 'whisper of frost obtained'},
            {t = 'ki_have', id = 324, have = true, why = 'whisper of frost held'},
            {t = 'chat', re = 'obtained key item: whisper of frost', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to gulmama with the whisper'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 231, event = 709, why = 'Gulmama 709: the reward menu (a full bag plays it too, no completion)'}}},
    },
}
