-- Step progress for Arts and Crafts (Aht Urhgan quest 1). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Arts_and_Crafts.lua (Hadahda 508 is the offer and only option 1 begins the
-- quest, so 508 is a reach; while accepted and short of letters his talk is 509; each of the seven NPCs plays one event the
-- first time (510 Mhasbaf, 511 Mathlouq, 512 Zabahf, 513 Ekhu Pesshyadha, 514 Qutiba, 515 Balakaf, 516 Matifa) and sets one
-- Prog bit; Hadahda 517 plays only when all seven bits are set, so it proves the collection, and gives a Bowl of Sutlac (it
-- replays if the bag is full, so it is not used for the return bullet); trading the Sutlac back plays 573, which runs
-- quest:complete, whose reward is an Imperial Bronze Piece, so 573 replays on a full bag and is only a reach). One letter
-- does not finish bullet 2, so the seven events only reach it. The completed bit proves bullet 3 (LandSandBoat completes
-- the quest at the trade-back, which the page lists as the optional last bullet; either way the completion cannot come
-- before the return talk). Client event scripts S4 050_Hadahda_01032128.txt (509 say #4952,
-- 573 say #4992). Not repeatable.
return {
    title = 'Arts and Crafts',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with hadahda f 10 above'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Hadahda 508, option 1)'},
            {t = 'event', zone = 50, event = 509, why = 'Hadahda 509: his talk while accepted and short of letters'},
            {t = 'chat', re = 'I need 7 letters in all', why = 'Hadahda 509 (say #4952)'},
         },
         reach = {{t = 'event', zone = 50, event = 508, why = 'Hadahda 508 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'collect the 7 letters from aht'},
         done = {
            {t = 'event', zone = 50, event = 517, why = 'Hadahda 517: plays only once all seven letters are collected'},
         },
         reach = {
            {t = 'event', zone = 50, event = 510, why = 'Mhasbaf 510'},
            {t = 'event', zone = 50, event = 511, why = 'Mathlouq 511'},
            {t = 'event', zone = 50, event = 512, why = 'Zabahf 512'},
            {t = 'event', zone = 50, event = 513, why = 'Ekhu Pesshyadha 513'},
            {t = 'event', zone = 50, event = 514, why = 'Qutiba 514'},
            {t = 'event', zone = 50, event = 515, why = 'Balakaf 515'},
            {t = 'event', zone = 50, event = 516, why = 'Matifa 516'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to hadahda for another cutscene'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 573, why = 'Hadahda 573: the Sutlac traded back (replays if the reward cannot be given)'},
            {t = 'chat', re = "You're giving it back to me%?", why = 'Hadahda 573 (say #4992)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'trade the sutlac back to hahahda'}},
    },
}
