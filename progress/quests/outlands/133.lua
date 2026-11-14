-- Step progress for Trial by Water (Outlands quest 133). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Norg/npcs/Edal-Tahdal.lua (109 is the offer when available, and again once a day after a
-- completion; option 1 adds the quest, deleting a finished one first, and gives the Tuning fork of water, key item 330; 190 gives a new
-- fork when none is held; 110 is his talk while accepted with the fork held; 112 is the reward menu with the Whisper of tides held, and
-- only a successful reward deletes the whisper, adds the title and completes the quest) and scripts/battlefields/Cloister_of_Tides/
-- trial_by_water.lua (the win gives the Whisper of tides, key item 322, and needs the fork). Client event script S4
-- 252_Edal_Tahdal_010FC059.txt (109 say #10464 on the Yes branch, 110 say #10465, 190 say #10518; 112 has no text in it). Key items from
-- res/key_items.lua. Event 109 also plays on a refusal and 112 on a refused or empty menu or a full bag, so both are reach; the log's
-- completed bit proves the last step. The whisper leaves the key items in The Moonlit Path too, so its loss is not used. The travel
-- bullet (n=2) is a note on the battle step; the tips after the last step (n=5 to n=11) are notes on it (a note on an earlier step would make the later steps show done). The quest
-- repeats once a day: a new accept (the "only a person who carries one" line or a fork gained) after a finished run opens the next run;
-- the log's bits and the held fork count for the first run only (the fork stays in the key items after a run).
return {
    title = 'Trial by Water',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with edal tahdal to obtain'},
         done = {
            {t = 'ki', id = 330, gained = true, why = 'tuning fork of water obtained (Edal-Tahdal 109 option 1, or 190)'},
            {t = 'chat', re = 'only a person who carries one can enter the crystal', why = 'Edal-Tahdal 109, Yes branch only (say #10464)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki_have', id = 330, have = true, run1 = true, why = 'tuning fork of water held (it stays after a run)'},
            {t = 'chat', re = 'obtained key item: tuning fork of water', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 110, conf = 'inferred', why = 'Edal-Tahdal 110: his talk while accepted with the fork held'},
            {t = 'chat', re = 'This .- will awaken the giant crystal', conf = 'inferred', why = 'Edal-Tahdal 110 (say #10465)'},
            {t = 'event', zone = 252, event = 190, conf = 'inferred', why = 'Edal-Tahdal 190: a new fork, only while accepted'},
            {t = 'chat', re = 'You want another .-%?', conf = 'inferred', why = 'Edal-Tahdal 190 (say #10518)'},
         },
         reach = {{t = 'event', zone = 252, event = 109, why = 'Edal-Tahdal 109 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to yhoator jungle and look'}},
        {id = 's3', at = {n = 3, fp = 'defeat leviathan prime and you will'},
         done = {
            {t = 'ki', id = 322, gained = true, after = 's1', why = 'whisper of tides obtained (Trial by Water battlefield win)'},
            {t = 'chat', re = 'obtained key item: whisper of tides', after = 's1', why = 'chat: key item obtained'},
            {t = 'ki_have', id = 322, have = true, after = 's1', conf = 'inferred', why = 'whisper of tides held (it may be kept from an earlier run)'},
            {t = 'event', zone = 252, event = 112, after = 's1', conf = 'inferred', why = 'Edal-Tahdal 112: the reward menu, only with the whisper held'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to edal tahdal with the'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         },
         reach = {{t = 'event', zone = 252, event = 112, after = 's3', why = 'Edal-Tahdal 112 (also plays on a refused menu or a full bag: nothing is given)'}}},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'up to 6 party members can'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'each party member must have their'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'time limit is 30 minutes'}},
        {id = 's8', kind = 'note', with = 's4', at = {n = 8, fp = 'you can only select one of'}},
        {id = 's9', kind = 'note', with = 's4', at = {n = 9, fp = 'you may repeat this quest once'}},
        {id = 's10', kind = 'note', with = 's4', at = {n = 10, fp = 'you can save yourself a lot'}},
        {id = 's11', kind = 'note', with = 's4', at = {n = 11, fp = 'you may also choose to retain'}},
    },
}
