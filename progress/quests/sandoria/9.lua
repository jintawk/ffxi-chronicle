-- Step progress for The Vicasque's Sermon (San d'Oria quest 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Vicasques_Sermon.lua (Abioleget 589 begins the quest on any answer; trading
-- 70 gil is event 591 and hands over the Blue Peas; Andelain in East Ronfaure takes the peas with event 19 (trade, or a talk
-- once delivered; with no peas held he only speaks, no event); 600 needs the peas delivered and runs quest:complete); client
-- event scripts S4 231_Abioleget_010E7011.txt (589 say #11262, 591 say #11289, 600 say #11290) and 101_Andelain_01065251.txt
-- (19 has no line of its own; the zone message "May the Gates of Paradise open to all..." is East Ronfaure IDs.lua
-- GATES_OF_PARADISE_OPEN, which every event 19 ends with). Bullet 2 (the 70 gil trade, event 591 hands over the peas
-- through giveItem) has no signal that survives a full bag, so it stays a plain bullet. Bullet 3 only tells where Andelain stands, but event 19 is the delivery that ends it. The quest log is set
-- at s1.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
-- Shared-signal audit (2026-10-28): the Andelain chat is tightened to the ellipsis ('...open to all...'); Faurbellant in La Theine (Gates to Paradise) says the same words ending in a full stop.
return {
    title = "The Vicasque's Sermon",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to abioleget who needs you'},
         done = {
            {t = 'event', zone = 231, event = 589, why = 'Abioleget 589: begins the quest'},
            {t = 'chat', re = 'Have you come to hear the sermon%?', why = 'Abioleget 589 (say #11262)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'look for andelain in east ronfaure'},
         done = {
            {t = 'event', zone = 101, event = 19, why = 'Andelain 19: the peas delivered'},
            {t = 'chat', re = 'May the Gates of Paradise open to all%.%.%.', why = 'Andelain 19 (East Ronfaure text GATES_OF_PARADISE_OPEN)'},
         }},
        {id = 's4', at = {n = 4, fp = 'after giving him the peas return'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 231, event = 600, why = 'Abioleget 600 (the Brass Ring reward may not fit)'},
                  {t = 'chat', re = 'We recognize your conviction%.', why = 'Abioleget 600 (say #11290)'}}},
    },
}
