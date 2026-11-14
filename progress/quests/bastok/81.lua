-- Step progress for The Naming Game (Bastok quest 81). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and the client's Raibaht script carries none of its events, so only the quest log
-- speaks: the trade to Raibaht completes the quest, so the completed bit proves the last bullet. The Ordrynite bullet (n=1) is
-- a note on that trade (an item alone can come from elsewhere, and the sub-bullets under it are not steps). The page says the
-- quest is repeatable, but no step has a signal that tells a second run apart, so no repeat is modelled.
return {
    title = 'The Naming Game',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's7', at = {n = 1, fp = 'obtain an ordrynite'}},
        {id = 's7', at = {n = 7, fp = 'trade it to raibaht to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the trade to Raibaht completes it)'},
         }},
    },
}
