-- Step progress for Testing the Waters (Treasures of Aht Urhgan, mission id 33). Data only; see progress/missions/sandoria/0.lua.
-- LandSandBoat scripts/missions/toau/34_Testing_the_Waters.lua: the Cutter trigger area (Arrapago Reef 54) plays event 15 on a
-- right and on a wrong answer (wrong = zone and retry), so it is not proof; only a right answer sets status 1, and then Talacca
-- Cove (57) zone-in cutscene 106 plays (status 1 only) and completes the mission, so 106 proves the Cutter bullet and the mission
-- line the last one. Bullet 1 (the Ephramadian gold coin) is a note with s2: the coin comes from earlier missions and is not tied
-- to this one.
return {
    title = 'Testing the Waters',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 33}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you will need another ephramadian gold'}},
        {id = 's2', at = {n = 2, fp = 'travel to and approach the cutter'},
         done = {
            {t = 'zonein', zone = 57, event = 106, why = "Talacca Cove zone-in cutscene 106: plays only at status 1, which only a right answer at the Cutter sets"},
         }},
        {id = 's3', at = {n = 3, fp = 'you will end up in talacca'},
         done = {
            {t = 'mission', line = 'toau', eq = 33, completed = true, why = "mission log: Testing the Waters completed"},
         }},
    },
}
