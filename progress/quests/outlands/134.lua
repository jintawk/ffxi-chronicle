-- Step progress for Everyone's Grudge (Outlands quest 134). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Norg/npcs/Magephaud.lua (116 is the offer, only with Tonberry kills and Norg fame 2, and its
-- finish adds the quest with no refusal branch; 117 is his talk while accepted; a trade of exactly three Gold Beastcoins (item 748) plays
-- 118 and its finish completes the quest, takes the coins and gives the key; 119 plays once completed). Client event script S4
-- 252_Magephaud_010FC01A.txt (116 say #10252, 117 say #10256, 118 say #10258, 119 say #10265). LandSandBoat's key item for the reward,
-- TONBERRY_PRIEST_KEY, is not defined there, so the key is res/key_items.lua 291 (Tonberry key, the Uggalepih room key) and as a reward
-- it only supports s2. The page calls the quest repeatable: when the Tonberries' hate is back, Magephaud's offer 116 plays again, so a
-- 116 after a finished run opens the next run, and the log's bits count for the first run only (run1); LandSandBoat does not replay
-- 116 after a completion, in which case nothing reopens. The "check with Magephaud" bullet (n=3) comes after the completion and rests
-- on event 119; its tip (n=4) is a note on it.
return {
    title = "Everyone's Grudge",
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to magephaud in norg i'},
         done = {
            {t = 'event', zone = 252, event = 116, why = 'Magephaud 116: the offer, the quest is added in its finish'},
            {t = 'chat', re = "I can see them Tonberries' hate fer ya%.", why = 'Magephaud 116 (say #10252)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 252, event = 117, conf = 'inferred', why = 'Magephaud 117: his talk while accepted'},
            {t = 'chat', re = 'Bring me three .-%. Then I.ll let ya in on me little secret%.', conf = 'inferred', why = 'Magephaud 117 (say #10256)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him 3 gold beastcoins to'}, count = {item = 748, need = 3},
         done = {
            {t = 'event', zone = 252, event = 118, why = 'Magephaud 118: three Gold Beastcoins taken, completes the quest'},
            {t = 'chat', re = "Way back when I was still young and didn't know about the hate", why = 'Magephaud 118 (say #10258)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 291, gained = true, after = 's1', conf = 'inferred', why = 'Tonberry key obtained (reward) (key items can come from elsewhere)'},
         }},
        {id = 's3', kind = 'post', at = {n = 3, fp = 'check with magephaud in norg to'},
         done = {
            {t = 'event', zone = 252, event = 119, after = 's2', why = 'Magephaud 119: plays only once completed'},
            {t = 'chat', re = "Don't get the wrong idea, now%.", after = 's2', why = 'Magephaud 119 (say #10265)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'if magephaud requests the beastcoins then'}},
    },
}
