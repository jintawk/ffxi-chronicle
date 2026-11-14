-- Step progress for The Clue (quest other 5). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ6_The_Clue.lua (Rycharde 90, first offer, and 91, the offer again, play
-- on accept AND decline, so they are a reach; "Great! I knew I could count on you!" plays on accept only in both; 85 is his
-- talk while accepted but is shared with Unending Chase, so it is not used; trading exactly four Crawler Eggs is event 92,
-- which runs quest:complete). The page has one bullet that bundles the talk and the trade, so the accept can only reach it.
-- Client event script S4 249_Rycharde_010F9009.txt (90, 91 say #6942, 92 say #6945/#6946). Crawler Egg id 4357 in
-- res/items.lua. Not repeatable.
return {
    title = 'The Clue',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note you need to wait 8'}},
        {id = 's2', at = {n = 2, fp = 'speak to rycharde at h 8'}, count = {item = 4357, need = 4},
         done = {
            {t = 'event', zone = 249, event = 92, why = 'Rycharde 92: four Crawler Eggs accepted, runs quest:complete'},
            {t = 'chat', re = 'Here, take this, you earned it!', why = 'Rycharde 92 (say #6946)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'Great! I knew I could count on you!', why = 'Rycharde 90/91, accepted (say #6942)'},
            {t = 'event', zone = 249, event = 90, why = 'Rycharde 90 offered (plays on decline too)'},
            {t = 'event', zone = 249, event = 91, why = 'Rycharde 91 offered again (plays on decline too)'},
         }},
    },
}
