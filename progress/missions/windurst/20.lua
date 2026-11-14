-- Step progress for Vain (Windurst mission id 20). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/8_1_Vain.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 20) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 20), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1 Moreno-Toeno 752 (gives the "Star Seeker"). s2 the Qu'Hau Spring in Ro'Maeve, event 2 (decoded). s3 the Curse Wand drop and s4 the
-- walk have no event: notes on s5. s5 Sedal-Godjal 118 (swaps the "Star Seeker" for the Magic-drained "Star Seeker"). s6 the Curse Wand
-- trade, event 120 (valid trade only). s7 Moreno-Toeno 758 completes (takes the Magic-drained "Star Seeker").
return {
    title = 'Vain',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to moreno toeno in windurst'},
         done = {
            {t = 'event', zone = 238, event = 752, why = 'Moreno-Toeno 752'},
            {t = 'ki', id = 275, gained = true, why = '"Star Seeker" obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'click the qu hau spring in'},
         done = {
            {t = 'event', zone = 122, event = 2, why = 'Qu\'Hau Spring 2'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'go to davoi and kill dirtyhanded'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'take the elevator back down and'}},
        {id = 's5', at = {n = 5, fp = 'keep going until you reach sedal'},
         done = {
            {t = 'event', zone = 149, event = 118, why = 'Sedal-Godjal 118'},
            {t = 'ki', id = 279, gained = true, why = 'Magic-drained "Star Seeker" obtained'},
            {t = 'ki', id = 275, gained = false, why = '"Star Seeker" taken'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the curse wand to sedal'},
         done = {
            {t = 'event', zone = 149, event = 120, why = 'Sedal-Godjal 120: the Curse Wand accepted'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to moreno toeno for a'},
         done = {
            {t = 'mission', line = 'windurst', eq = 20, completed = true, why = 'mission log: Vain completed'},
            {t = 'event', zone = 238, event = 758, why = 'Moreno-Toeno 758: completes'},
            {t = 'ki', id = 279, gained = false, why = 'Magic-drained "Star Seeker" taken'},
         }},
    },
}
