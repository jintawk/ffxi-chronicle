-- Step progress for Time Slips Away (Wings of the Goddess, mission id 44). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/45_Time_Slips_Away.lua: a Punch Bug traded to the Veridical Conflux (Grauberg [S] 89)
-- plays 35 only for that trade (no refusal path) and its finish completes the mission; a plain examine plays 40 (the briefing), which
-- only shows the step is current. Bullet 2 names the Bottled punch bug, the mission's reward key item: a note on the step.
return {
    title = 'Time Slips Away',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 44}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade a punch bug to the'},
         done = {
            {t = 'event', zone = 89, event = 35, why = 'Veridical Conflux 35: the Punch Bug trade, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 44, completed = true, why = 'mission log: Time Slips Away completed'},
         },
         reach = {{t = 'event', zone = 89, event = 40, why = 'Veridical Conflux 40: the briefing while the mission is current'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you will obtain a bottled punch'}},
    },
}
