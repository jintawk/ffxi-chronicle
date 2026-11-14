-- Step progress for Your Crystal Ball (Jeuno quest 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Your_Crystal_Ball.lua (Kurou-Morou 194 is the offer and only option 0 begins
-- the quest, so it is a reach; while accepted he plays the reminder 191; trading the Ahriman Lens to the Rockwell shows the
-- zone's text "You submerged the Ahriman Lens into the pool of water." only when the lens is taken; checking it a minute
-- later plays event 52, which also plays when the bag is full and the Divination Sphere is not given; trading the sphere to
-- Kurou-Morou plays 196, which runs quest:complete with a title only, so there is no refusal). Client event scripts S4
-- 245_Kurou_Morou_010F5022.txt (191 say #7506) and 198_Rockwell_010C6216.txt (52 print #7100, on a full bag too); the text is
-- LandSandBoat's zones/Maze_of_Shakhrami/IDs.lua SUBMERGED_ITEM 7096. The lens hunt stays a plain bullet, the trip to the
-- Maze and the walk to the Rockwell are notes on the lens trade, and the "wait, then check the Rockwell" bullet has no signal
-- that a full bag does not also give (event 52, the "turned into" line, item 556), so it stays a plain bullet. Not repeatable.
return {
    title = 'Your Crystal Ball',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'kurou morou is the fortune teller'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kurou-Morou 194, option 0)'},
            {t = 'event', zone = 245, event = 191, conf = 'inferred', why = 'Kurou-Morou 191: his reminder, only while accepted'},
            {t = 'chat', re = 'in order to constructaru your', conf = 'inferred', why = 'Kurou-Morou 191 (say #7506)'},
         },
         reach = {{t = 'event', zone = 245, event = 194, why = 'Kurou-Morou 194 offered (its finish needs option 0)'}}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'with the lens in your possession'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'go to g 5 on the'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'at the top of the path'}},
        {id = 's6', at = {n = 6, fp = 'trade your ahriman lens to the'},
         done = {
            {t = 'chat', re = 'you submerged the .+ into the pool of water', why = 'Maze of Shakhrami text 7096: the lens taken'},
         },
         reach = {{t = 'event', zone = 198, event = 52, after = 's1', why = 'Rockwell 52 (the check a minute later; also plays when the bag is full)'}}},
        {id = 's8', at = {n = 8, fp = 'head back to kurou morou and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 196, why = 'Kurou-Morou 196: the Divination Sphere accepted, runs quest:complete'},
         }},
    },
}
