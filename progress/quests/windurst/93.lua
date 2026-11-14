-- Step progress for Waking Dreams (Windurst quest 93). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Waking_Dreams.lua (Kerutoto 918 begins the quest and gives the Vial of dream
-- incense; later runs offer 918 again with a Fight again? menu whose "Not yet" gives nothing; the Whisper of dreams comes from
-- the Diabolos Prime battlefield; 920 is the reward menu, which plays whether or not a reward is chosen or fits, and only a
-- completed pick completes the quest and takes the whisper; 919 and 789 are talk lines); client event script S4
-- 238_Kerutoto_010EE02F.txt (789 say #9912, 919 say #11937). The quest repeats once per Earth day: the vial is given again at the
-- next 918, so that opens the next run, and the quest-log bits count for the first run only (run1). 920 is a reach, the completed
-- bit and the loss of the whisper carry the last step. Bullets 2 to 10 are travel notes on the fight; 13 to 18 are rules and
-- tips, notes on the step they belong to. The quest log is set at s1, so it is not silent.
return {
    title = 'Waking Dreams',
    completes = 's12',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kerutoto windurst waters south'},
         done = {
            {t = 'ki', id = 335, gained = true, why = 'vial of dream incense obtained'},
            {t = 'ki_have', id = 335, have = true, why = 'vial of dream incense held'},
            {t = 'chat', re = 'obtained key item: vial of dream incense', why = 'chat: key item obtained'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 918, why = 'Kerutoto 918 (a later run can answer Not yet)'}}},
        {id = 'n2', kind = 'note', with = 's11', at = {n = 2, fp = 'head to pso xja home point'}},
        {id = 'n3', kind = 'note', with = 's11', at = {n = 3, fp = 'travel to beaucedine glacier h 8'}},
        {id = 'n4', kind = 'note', with = 's11', at = {n = 4, fp = 'once inside the correct displacement sequence'}},
        {id = 'n5', kind = 'note', with = 's11', at = {n = 5, fp = 'take the elevator down'}},
        {id = 'n6', kind = 'note', with = 's11', at = {n = 6, fp = 'head forward north then left west'}},
        {id = 'n7', kind = 'note', with = 's11', at = {n = 7, fp = 'use the stone gate and select'}},
        {id = 'n8', kind = 'note', with = 's11', at = {n = 8, fp = 'the home point is just past'}},
        {id = 'n9', kind = 'note', with = 's11', at = {n = 9, fp = 'head down the steps into the'}},
        {id = 'n10', kind = 'note', with = 's11', at = {n = 10, fp = 'select the memento circle and pick'}},
        {id = 's11', at = {n = 11, fp = 'defeat diabolos prime to receive a'},
         done = {
            {t = 'ki', id = 327, gained = true, why = 'whisper of dreams obtained'},
            {t = 'ki_have', id = 327, have = true, why = 'whisper of dreams held'},
            {t = 'chat', re = 'obtained key item: whisper of dreams', why = 'chat: key item obtained'},
         }},
        {id = 's12', at = {n = 12, fp = 'return to kerutoto with the whisper'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 327, gained = false, after = 's11', conf = 'inferred', why = 'whisper of dreams handed over (only when a reward is taken)'},
         },
         reach = {
            {t = 'event', zone = 238, event = 920, why = 'Kerutoto 920: the reward menu (also plays on an escape or a full bag)'},
         }},
        {id = 'n13', kind = 'note', with = 's12', at = {n = 13, fp = 'up to 6 party members can'}},
        {id = 'n14', kind = 'note', with = 's12', at = {n = 14, fp = 'each party member must have their'}},
        {id = 'n15', kind = 'note', with = 's12', at = {n = 15, fp = 'time limit is 30 minutes'}},
        {id = 'n16', kind = 'note', with = 's12', at = {n = 16, fp = 'you can only select 1 of'}},
        {id = 'n17', kind = 'note', with = 's12', at = {n = 17, fp = 'you may repeat this quest once'}},
        {id = 'n18', kind = 'note', with = 's12', at = {n = 18, fp = 'when clearing for the first time'}},
    },
}
