-- Step progress for When the Bow Breaks (Aht Urhgan quest 45). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/When_the_Bow_Breaks.lua (Gaweesh 280 begins the quest with no refusal while Ode
-- to the Serpents is accepted; the Giwahb Watchtower door in Wajaom Woodlands plays 512 only when the Frayed Arrow is traded
-- while accepted, and its finish runs quest:complete and confirms the trade). Client event script S4 048_Gaweesh_01030203.txt
-- (280: say #7909). Bullet 2 (killing the spiders for the arrow) has no event of its own: a note on the trade. The reward title
-- is not used. Not repeatable.
return {
    title = 'When the Bow Breaks',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'while the quest ode to the'},
         done = {
            {t = 'event', zone = 48, event = 280, why = 'Gaweesh 280: the offer, begins the quest with no refusal'},
            {t = 'chat', re = 'And you mean to immortalize our Galeserpent General in song!%?', why = 'Gaweesh 280 (say #7909)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'in wajaom woodlands kill aht urhgan'}},
        {id = 's3', at = {n = 3, fp = 'go to giwahb watchtower in wajaom'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 51, event = 512, why = 'Giwahb Watchtower 512: the arrow trade, runs quest:complete'},
         }},
    },
}
