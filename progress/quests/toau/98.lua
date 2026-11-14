-- Step progress for Promotion: First Lieutenant (Aht Urhgan quest 98). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_First_Lieutenant.lua (events 5080-5089 have no text in the client
-- scripts). Server stage by stage: the Salaheem's Sentinels office region plays 5080 (no choice) and begins the quest; Prog 0
-- before the fee: Abquhbah 5087 is his reminder; trading five Imperial Gold Pieces plays 5081 (sets the wait); Prog 0 after:
-- Abquhbah 5088 while the day has not changed, 5082 is trial 1 (Counterespionage) once it has (option 1 = passed, sets Prog 1,
-- anything else may be retried the next game day); Prog 1: 5083 is trial 2 (the cipher), so it only exists once trial 1 is
-- passed (option 1 sets Prog 2); Prog 2: 5084 is trial 3 (Rock-Paper-Scissors), so it only exists once trial 2 is passed (option
-- 0 sets Prog 3); Prog 3: Abquhbah 5089 is the graduation setup talk, so it only exists once trial 3 is won (sets Prog 4 when
-- talked to between 15:00 and 17:00); Prog 4: 5085 runs quest:complete and prints "has been promoted to First Lieutenant",
-- line 9571 of Aht_Urhgan_Whitegate/IDs.lua. A trial's own event plays whether it is passed or failed, so it proves the
-- "talk to Abquhbah to start the trial" bullet (the trial was started), and the next trial's events prove the pass; 5088 is
-- used at several stages and is left out. The tip bullets about each trial and the waits are notes. Not repeatable.
return {
    title = 'Promotion: First Lieutenant',
    completes = 's24',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'the quest is started by entering'},
         done = {
            {t = 'event', zone = 50, event = 5080, why = "Salaheem's Sentinels office 5080: begins the quest (no choice)"},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 5087, why = 'Abquhbah 5087: his reminder before the fee'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade abquhbah 5 imperial gold pieces'},
         done = {
            {t = 'event', zone = 50, event = 5081, why = 'Abquhbah 5081: five Imperial Gold Pieces traded'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'wait until the game day changes'}},
        {id = 's4', at = {n = 4, fp = 'talk to abquhbah to start the'},
         done = {
            {t = 'event', zone = 50, event = 5082, why = 'Abquhbah 5082: trial 1 begins (any result plays it)'},
            {t = 'event', zone = 50, event = 5083, why = 'Abquhbah 5083: trial 2 only plays once trial 1 is passed'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'in this task you will be'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'there are 2 types of queries'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'you must solve 3 rounds to'}},
        {id = 's8', kind = 'note', with = 's4', at = {n = 8, fp = 'if you fail you may retry'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'after you succeed wait for the'}},
        {id = 's10', at = {n = 10, fp = 'talk to abquhbah to start the'},
         done = {
            {t = 'event', zone = 50, event = 5083, why = 'Abquhbah 5083: trial 2 begins (any result plays it)'},
            {t = 'event', zone = 50, event = 5084, why = 'Abquhbah 5084: trial 3 only plays once trial 2 is passed'},
         }},
        {id = 's11', kind = 'note', with = 's10', at = {n = 11, fp = 'in this task you will be'}},
        {id = 's12', kind = 'note', with = 's10', at = {n = 12, fp = 'language'}},
        {id = 's13', kind = 'note', with = 's10', at = {n = 13, fp = 'you will be asked 4 questions'}},
        {id = 's14', kind = 'note', with = 's10', at = {n = 14, fp = 'if you fail you may retry'}},
        {id = 's15', kind = 'note', with = 's16', at = {n = 15, fp = 'after you succeed wait a game'}},
        {id = 's16', at = {n = 16, fp = 'talk to abquhbah to start the'},
         done = {
            {t = 'event', zone = 50, event = 5084, why = 'Abquhbah 5084: trial 3 begins (any result plays it)'},
            {t = 'event', zone = 50, event = 5089, why = 'Abquhbah 5089: graduation talk, only once trial 3 is won'},
         }},
        {id = 's17', kind = 'note', with = 's16', at = {n = 17, fp = 'this game is the same as'}},
        {id = 's18', kind = 'note', with = 's16', at = {n = 18, fp = 'the three critters are beetle crab'}},
        {id = 's19', kind = 'note', with = 's16', at = {n = 19, fp = 'the first opponent you fight after'}},
        {id = 's20', kind = 'note', with = 's16', at = {n = 20, fp = 'the second opponent you fight is'}},
        {id = 's21', kind = 'note', with = 's16', at = {n = 21, fp = 'the third opponent you fight is'}},
        {id = 's22', kind = 'note', with = 's16', at = {n = 22, fp = 'the final opponent you fight is'}},
        {id = 's23', kind = 'note', with = 's24', at = {n = 23, fp = 'after winning wait until the game'}},
        {id = 's24', at = {n = 24, fp = 'talk to abquhbah between 15 00'},
         done = {
            {t = 'event', zone = 50, event = 5085, why = 'Abquhbah 5085: runs quest:complete'},
            {t = 'chat', re = 'has been promoted to first lieutenant', why = 'promotion message (IDs.lua 9571)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
