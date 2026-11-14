-- Step progress for The Big One (Quest) (Other Areas quest 70). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and the client event scripts do not cover Travonce, so only two signals are strong:
-- Travonce's escort award (Temporary KI 992) is handed over when The Big One dies (bullet 9), and the quest log's completed bit
-- is set at the reward talk (bullet 10, the last). Every other bullet is a note that leads into the first. The page says the
-- quest is repeatable, but no signal is known that restarts a run, so there is no `repeatable` entry.
return {
    title = 'The Big One (Quest)',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's9', at = {n = 1, fp = 'speak to travonce in tavnazian safehold'}},
        {id = 's2', kind = 'note', with = 's9', at = {n = 2, fp = 'zone out of the safehold into'}},
        {id = 's3', kind = 'note', with = 's9', at = {n = 3, fp = 'do not talk to travonce until'}},
        {id = 's4', kind = 'note', with = 's9', at = {n = 4, fp = 'his first stop will be on'}},
        {id = 's5', kind = 'note', with = 's9', at = {n = 5, fp = 'he will then head to the'}},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'kill any more notorious monsters he'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'eventually he moves on to a'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'he will fish up three more'}},
        {id = 's9', at = {n = 9, fp = 'he will eventually fish up the'},
         done = {
            {t = 'ki', id = 992, gained = true, why = "Travonce's escort award obtained"},
            {t = 'ki_have', id = 992, have = true, why = "Travonce's escort award held"},
         }},
        {id = 's10', at = {n = 10, fp = 'speak to travonce in tavnazian safehold'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's11', kind = 'note', with = 's10', at = {n = 11, fp = 'he fishes up the following monsters'}},
    },
}
