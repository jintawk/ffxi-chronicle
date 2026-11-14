-- Step progress for Transformations (Aht Urhgan quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/BLU_AF3_Transformations.lua (Waoud 720 is a divination menu that plays whether
-- or not the 1,000 gil is paid, so the event proves nothing; only a paid divination says "Your fate lies beyond the gate of
-- nobility" (client script S4 050_Waoud_01032119.txt, say #8925, in 720 and 721; the other Waoud quests have different lines) and
-- sets Prog 1; the Imperial Whitegate 722 plays only at Prog 1 and begins the quest, so the log is silent until bullet 3; the
-- Alzadaal trigger areas play 2 at Prog 1 and 3 at Prog 2, bullet 5's two cutscenes; the Remnants Permit and Captain Wildcat badge
-- the draft used are entry tickets, not progress, and bullet 6 is travel; the ??? plays 4 at Prog 3 (the cutscene that raises the
-- Nepionic Soulflayer) and 5 at Prog 4 after the kill, which runs quest:complete, whose reward is Magus Keffiyeh, so a full bag
-- replays 5 and only the completed bit proves the last bullet). Events 2 to 5 of zone 72 are used by no other script. Not repeatable
-- (the draft's restart was a guess).
return {
    title = 'Transformations',
    completes = 's8',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with waoud at j 10'},
         done = {
            {t = 'chat', re = 'Your fate lies beyond the gate of nobility', why = 'Waoud 720 and 721, paid divination (say #8925)'},
         },
         reach = {{t = 'event', zone = 50, event = 720, why = 'Waoud 720 offered (plays whether or not the divination is paid)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'ask for a divination by selecting'}},
        {id = 's3', at = {n = 3, fp = 'go to the imperial whitegate door'},
         done = {
            {t = 'event', zone = 50, event = 722, why = 'Imperial Whitegate 722: plays only at Prog 1, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'the quest is now listed in'}},
        {id = 's5', at = {n = 5, fp = 'your next goal is to obtain'},
         done = {
            {t = 'event', zone = 72, event = 3, why = 'Alzadaal trigger area 3: plays only at Prog 2, the second cutscene, sets Prog 3'},
         },
         reach = {{t = 'event', zone = 72, event = 2, why = 'Alzadaal trigger area 2: plays only at Prog 1, the first cutscene'}}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'after the above two cutscenes it'}},
        {id = 's7', at = {n = 7, fp = 'use the teleporter at i 9'},
         done = {
            {t = 'event', zone = 72, event = 4, why = 'the ??? 4: plays only at Prog 3 with the Soulflayer not up, raises it'},
         }},
        {id = 's8', at = {n = 8, fp = 'defeat the soulflayer then examine the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 72, event = 5, why = 'the ??? 5: plays only at Prog 4 after the kill, runs quest:complete (replays if Magus Keffiyeh cannot be given)'}}},
    },
}
