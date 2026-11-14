-- Step progress for No Strings Attached (Aht Urhgan quest 7, the Puppetmaster job flag). Data only; see
-- progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/No_Strings_Attached.lua (Shamarhaan 434 is the puppet show, whose finish sets
-- the Option that lets Iruki-Waraki offer the quest; the script notes it no longer plays on retail, and 435 is his talk
-- afterwards, also while accepted; Iruki-Waraki 260 begins the quest with no refusal; his 261 plays at Prog 0-3; Ghatsad 262 at
-- Prog 0 sets 1, 263 plays at Prog 1; the Arrapago Reef ??? (qm10) plays cutscene 214 at Prog 1, gives the Antique automaton
-- (key item 798) and sets 2; Ghatsad 264 at Prog 2 with the automaton sets Prog 3, a Vana'diel day and deletes it; Ghatsad 265
-- once the day has passed sets 4; Iruki-Waraki 266 at Prog 4 runs quest:complete, whose reward includes an Animator, so 266
-- replays on a full bag and is only a reach: the completed bit proves the last bullet). The quest log is silent until Iruki's
-- 260. Ghatsad 256 is his generic "come back later" talk (Ghatsad.lua), so it is not used. Client event scripts S4
-- 235_Shamarhaan_010EB096.txt (434 say #9552, 435 say #9568), 050_Ghatsad_01032091.txt (263 say #5808); the other events have no
-- text; key item 798 from res/key_items.lua. Bullet 4 (the ferry) is a note on the ??? in Arrapago Reef. Not repeatable.
return {
    title = 'No Strings Attached',
    completes = 's8',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to shamarhaan f 9 in'},
         done = {
            {t = 'event', zone = 235, event = 434, why = 'Shamarhaan 434: the puppet show'},
            {t = 'chat', re = 'Would like to join in dance%?', why = 'Shamarhaan 434 (say #9552)'},
            {t = 'event', zone = 235, event = 435, why = 'Shamarhaan 435: his talk after the show'},
            {t = 'chat', re = 'If you really want to become a puppetmaster', why = 'Shamarhaan 435 (say #9568)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to aht urhgan whitegate and'},
         done = {
            {t = 'event', zone = 50, event = 260, why = 'Iruki-Waraki 260: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 261, why = 'Iruki-Waraki 261: his talk at Prog 0-3 while accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak with ghatsad in aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 262, why = 'Ghatsad 262: only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 50, event = 263, why = 'Ghatsad 263: only at Prog 1'},
            {t = 'chat', re = 'I am fairly certain that some old models of mine are lying dormant somewhere on Arrapago Reef', why = 'Ghatsad 263 (say #5808)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'take the northern port ephramad ferry'}},
        {id = 's5', at = {n = 5, fp = 'find the at h 10 on'},
         done = {
            {t = 'ki', id = 798, gained = true, why = 'antique automaton obtained'},
            {t = 'ki_have', id = 798, have = true, why = 'antique automaton held'},
            {t = 'event', zone = 54, event = 214, why = 'Arrapago Reef ??? 214: only at Prog 1, gives the automaton'},
            {t = 'chat', re = 'obtained key item: antique automaton', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to ghatsad'},
         done = {
            {t = 'event', zone = 50, event = 264, why = 'Ghatsad 264: only at Prog 2 holding the automaton, sets Prog 3'},
            {t = 'ki', id = 798, gained = false, why = 'antique automaton handed over (deleted by Ghatsad 264)'},
         }},
        {id = 's7', at = {n = 7, fp = 'wait until the next vana diel'},
         done = {
            {t = 'event', zone = 50, event = 265, why = 'Ghatsad 265: only at Prog 3 once the day has passed, sets Prog 4'},
         }},
        {id = 's8', at = {n = 8, fp = 'speak with iruki waraki k 9'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 266, why = 'Iruki-Waraki 266 (replays if the Animator cannot be given)'}}},
    },
}
