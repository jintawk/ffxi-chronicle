-- Step progress for A Question of Taste (Outlands quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/A_Question_of_Taste.lua, first run (Prog 0 to 4): Etteh Sulaej 44 begins the
-- quest and gives the Letter to Angelica (KI 213; its menu is flavour, the script begins on any option); Angelica 771 gives
-- "Final Fantasy" (214) and Angelica's letter (259) and takes 213; Etteh 47 takes 259 (Prog 2; 49 is his reminder after it);
-- the Stone Picture Frame 50 (zone 159) takes 214 on option 1 and spawns the NM, so it plays on a refusal too and is only a
-- reach; the frame then gives the Ripped painting (215, no event) after the kill; Etteh 50 takes 215 and runs quest:complete.
-- The repeat (events 53/54/55/57, KI 216 "Final Fantasy Part II", frame event 51) is not on the page and is not tracked, so
-- there is no `repeatable` entry. Client event script S4 250_Etteh_Sulaej_010FA009.txt (44 say #10108, 47 say #10120, 49
-- say #10131, 50 say #10134) and 238_Angelica_010EE059.txt (771 has no line). The quest log is set at s1, so it is not silent.
-- Pilot-style audit: events 44/47/49/50 are used by this quest only (client script owners); Etteh 109 belongs to Everyone's Grudging.
return {
    title = 'A Question of Taste',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to etteh sulaej j 9'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Etteh Sulaej 44)'},
            {t = 'ki', id = 213, gained = true, why = 'letter to Angelica obtained'},
            {t = 'ki_have', id = 213, have = true, why = 'letter to Angelica held'},
            {t = 'event', zone = 250, event = 44, why = 'Etteh Sulaej 44: begins the quest on any option'},
            {t = 'chat', re = 'Ever since I picked up my first brush, I have dreamed of having my works put on display at a private exhibition%.', why = 'Etteh Sulaej 44 (say #10108)'},
            {t = 'chat', re = 'obtained key item: letter to angelica', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'take the letter to windurst waters'},
         done = {
            {t = 'event', zone = 238, event = 771, why = 'Angelica 771: gives both key items and takes the letter'},
            {t = 'ki', id = 214, gained = true, why = '"Final Fantasy" obtained'},
            {t = 'ki', id = 259, gained = true, why = "Angelica's letter obtained"},
            {t = 'ki_have', id = 214, have = true, why = '"Final Fantasy" held'},
            {t = 'ki_have', id = 259, have = true, why = "Angelica's letter held"},
            {t = 'chat', re = 'obtained key item: "final fantasy"', why = 'chat: key item obtained'},
            {t = 'chat', re = "obtained key item: angelica's letter", why = 'chat: key item obtained'},
            {t = 'ki', id = 213, gained = false, conf = 'inferred', why = 'letter to Angelica handed over'},
            {t = 'event', zone = 238, event = 772, conf = 'inferred', why = 'Angelica 772: her line once the letter is given'},
         }},
        {id = 's3', at = {n = 3, fp = 'go back to kazham talk to'},
         done = {
            {t = 'event', zone = 250, event = 47, why = 'Etteh Sulaej 47: takes Angelica\'s letter, Prog 2'},
            {t = 'chat', re = 'She wrrrote back saying that she still wants to display her paintings in the temple!', why = 'Etteh Sulaej 47 (say #10120)'},
            {t = 'ki', id = 259, gained = false, conf = 'inferred', why = "Angelica's letter handed over"},
            {t = 'event', zone = 250, event = 49, conf = 'inferred', why = 'Etteh Sulaej 49: his reminder, only after 47'},
            {t = 'chat', re = "I get dizzy every time I look at that girl's paintings%.", conf = 'inferred', why = 'Etteh Sulaej 49 (say #10131)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to g 8 on the'},
         done = {
            {t = 'ki', id = 214, gained = false, after = 's2', why = '"Final Fantasy" hung on the frame (taken on option 1)'},
         },
         reach = {{t = 'event', zone = 159, event = 50, after = 's2', why = 'Stone Picture Frame 50 offered (its finish needs option 1)'}}},
        {id = 's5', at = {n = 5, fp = 'defeat the nm then check the'},
         done = {
            {t = 'ki', id = 215, gained = true, why = 'ripped "Final Fantasy" painting obtained'},
            {t = 'ki_have', id = 215, have = true, why = 'ripped "Final Fantasy" painting held'},
            {t = 'chat', re = 'obtained key item: ripped "final fantasy" painting', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to etteh sulaej as a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 250, event = 50, why = 'Etteh Sulaej 50: runs quest:complete'},
            {t = 'chat', re = 'Interrresting%.%.%. Tell me more%.', why = 'Etteh Sulaej 50 (say #10134)'},
            {t = 'ki', id = 215, gained = false, conf = 'inferred', why = 'ripped "Final Fantasy" painting handed over'},
         }},
    },
}
