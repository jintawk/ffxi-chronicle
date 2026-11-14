-- Step progress for Fist of the People (Aht Urhgan quest 46). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Fist_of_the_People.lua (Talhaal 282 begins the quest with no refusal while Ode to
-- the Serpents is accepted; Fari-Wari 884 plays only at Prog 0 and sets Prog 1; the Wajaom Woodlands Leypoint plays 511 only when
-- the Rusty Medal is traded at Prog 1, and its finish runs quest:complete). Client event script S4 048_Talhaal_01030202.txt (282:
-- say #7902). Bullet 3 (killing tigers for the medal) has no event of its own: a note on the trade. The reward title is not
-- used. Not repeatable.
return {
    title = 'Fist of the People',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'while the quest ode to the'},
         done = {
            {t = 'event', zone = 48, event = 282, why = 'Talhaal 282: the offer, begins the quest with no refusal'},
            {t = 'chat', re = 'You have an introduction from Biyaada%?', why = 'Talhaal 282 (say #7902)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to fari wari in aht'},
         done = {
            {t = 'event', zone = 50, event = 884, why = 'Fari-Wari 884: only at Prog 0, sets Prog 1'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'in wajaom woodlands kill wajaom tigers'}},
        {id = 's4', at = {n = 4, fp = 'go to the leypoint in wajaom'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 51, event = 511, why = 'Leypoint 511: the medal trade, runs quest:complete'},
         }},
    },
}
