-- Step progress for Spice Gals (San d'Oria quest 110). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Spice_Gals.lua (Rouva 724 begins it, 726 restarts it after a conquest tally;
-- the Riverne ??? gives key item 621; Rouva 725 (first time) or 727 (a repeat) takes it and runs quest:complete, which also
-- gives the Miratete's Memoirs page, so both events play even when the reward does not fit and are `reach` only: the proof
-- is the loss of key item 621, deleted only after the completion succeeded, and the completed bit for the first run);
-- client event script S4 230_Rouva_010E60C4.txt. The page has no bullet for the talk to Rouva that begins it. Repeatable
-- once per conquest tally: a new Rivernewort opens the next run, so the completed bit counts for the first run only.
return {
    title = 'Spice Gals',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'the rivernewort key item can be'},
         done = {
            {t = 'ki', id = 621, gained = true, why = 'Rivernewort obtained'},
            {t = 'ki_have', id = 621, have = true, why = 'Rivernewort held'},
            {t = 'chat', re = 'obtained key item: rivernewort', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 230, event = 724, why = 'Rouva 724: the quest begun'},
                  {t = 'event', zone = 230, event = 726, why = 'Rouva 726: the quest restarted after a tally'}}},
        {id = 's2', at = {n = 2, fp = 'once you have acquired the rivernewort'},
         done = {
            {t = 'ki', id = 621, gained = false, why = 'Rivernewort taken (only after the completion succeeded)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         },
         reach = {{t = 'event', zone = 230, event = 725, why = 'Rouva 725: plays even when the reward does not fit, so it is not proof'},
                  {t = 'event', zone = 230, event = 727, why = 'Rouva 727: a repeat, plays even when the reward does not fit'}}},
    },
}
