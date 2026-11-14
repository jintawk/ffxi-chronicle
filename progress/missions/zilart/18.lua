-- Step progress for Ro'Maeve (Zilart mission 9, mission id 18). Data only; see progress/missions/sandoria/12.lua. The zilart line
-- carries completed ids only, so every mission matcher here is a completion.
-- Evidence: LandSandBoat scripts/missions/rotz/09_RoMaeve.lua; client script 245_Aldo_010F5007.txt (event 84 listed under this
-- mission, its body is empty); the Oaken Door (Norg 252, event 3) is only in LandSandBoat and the client has no script for it.
-- Aldo's cutscene (Lower Jeuno 245, event 84) plays once, while the mission is current and his Option var is 0, and has no menu:
-- it is the optional first bullet. The Oaken Door cutscene (252, event 3) completes the mission only on option 0 ("Open the door"),
-- but the same event plays on a refusal, so it proves nothing and is not listed; the completed id is what ticks bullet 2. The two
-- bullets after it are the "other missions" note and the result, both notes. `known` is the previous mission (id 16) or anything
-- after it completed. The draft had only the Aldo event and notes, and its `known` used a current-value matcher on the zilart line,
-- which carries none.
return {
    title = "Ro'Maeve",
    completes = 's2',
    known = {{t = 'mission', line = 'zilart', min = 16, completed = true}},
    groups = {main = {start = {{t = 'mission', line = 'zilart', min = 16, completed = true}}}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional head to the tenshodo and'},
         done = {
            {t = 'event', zone = 245, event = 84, why = 'Aldo 84: the optional cutscene (plays once while the mission is current)'},
         }},
        {id = 's2', at = {n = 2, fp = 'go to norg and speak with'},
         done = {
            {t = 'mission', line = 'zilart', eq = 18, completed = true, why = "mission log: Ro'Maeve completed"},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you may be on other missions'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'after the cut scene with lion'}},
    },
}
