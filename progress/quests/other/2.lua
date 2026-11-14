-- Step progress for Unending Chase (quest other 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/RQ3_Unending_Chase.lua (Rycharde 82, first offer, and 84, the offer
-- again after a decline, both play on accept AND decline, so they are a reach; the accept line "Really? That's great!" plays
-- on accept only in both; 85 is his talk while accepted but is shared with The Clue, so it is not used; trading exactly one
-- Puffball is event 83, which runs quest:complete). The page has one bullet that bundles the talk and the trade, so the
-- accept can only reach it, never finish it. Client event script S4 249_Rycharde_010F9009.txt (82, 84 say #6908, 83 say
-- #6911/#6912). Not repeatable.
return {
    title = 'Unending Chase',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to rycharde then trade him'},
         done = {
            {t = 'event', zone = 249, event = 83, why = 'Rycharde 83: the Puffball accepted, runs quest:complete'},
            {t = 'chat', re = "Here's your well%-deserved reward%.", why = 'Rycharde 83 (say #6912)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = "Really%? That's great!", why = 'Rycharde 82/84, accepted (say #6908)'},
            {t = 'event', zone = 249, event = 82, why = 'Rycharde 82 offered (plays on decline too)'},
            {t = 'event', zone = 249, event = 84, why = 'Rycharde 84 offered again (plays on decline too)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you need to wait 8 real'}},
    },
}
