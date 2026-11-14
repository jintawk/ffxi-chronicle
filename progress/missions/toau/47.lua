-- Step progress for Eternal Mercenary (Treasures of Aht Urhgan mission 48, mission id 47). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/toau/48_Eternal_Mercenary.lua; zone 50 = Aht Urhgan Whitegate. Naja Salaheem plays event 3151
-- only for this mission (LandSandBoat; no client script lists it, so the id is LandSandBoat's) and it is the "final cutscene" of bullet 1.
-- LandSandBoat never completes the mission (reward = {}), so there is no `completes` and no completion matcher: the step shows done when the
-- cutscene is seen, and the line only ever reads 47 as current. Bullet 2 (the Nashmeira trust, after completion) is a note on it. The draft
-- offered the event as reach only; it is the one event of the mission and does not play on a refusal.
return {
    title = 'Eternal Mercenary',
    known = {{t = 'mission', line = 'toau', eq = 47}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach naja salaheem for the final'},
         done = {
            {t = 'event', zone = 50, event = 3151, why = 'Naja Salaheem 3151: the final cutscene (LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'after completing this mission you may'}},
    },
}
