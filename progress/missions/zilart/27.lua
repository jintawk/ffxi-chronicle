-- Step progress for The Sealed Shrine (Zilart mission 15, mission id 27). Data only; see progress/missions/sandoria/12.lua.
-- The zilart line carries completed ids only, so the mission matcher is a completion.
-- Evidence: LandSandBoat scripts/missions/rotz/15_The_Sealed_Shrine.lua; client script 252_Gilgamesh_010FC003.txt (events 172, 173
-- listed, 172 has no body). The Oaken Door in Norg (252, event 172, status 0 only) sets status 1 on option 0, but the same event
-- plays on a refusal, so it proves nothing. Gilgamesh 173 (and its line, say #10769) is the briefing that plays whenever the mission
-- is current, whether or not the door was used, so the draft's proof of bullet 2 is dropped. What does prove the door: the zone-in
-- cutscene 51 in The Shrine of Ru'Avitau (178) plays only at status 1 and completes the mission (LandSandBoat; no client script for a
-- zone-in event), with the completed id, and carries bullet 3; no signal belongs to the door alone, so bullet 2 is a note on it (a
-- step ticked by the same observation as the next one cannot be told apart). Bullet 1 is a conditional note on the Divine Might
-- route (no signal). `known` is the previous mission (id 26) or anything after it completed.
return {
    title = 'The Sealed Shrine',
    completes = 's3',
    known = {{t = 'mission', line = 'zilart', min = 26, completed = true}},
    groups = {main = {start = {{t = 'mission', line = 'zilart', min = 26, completed = true}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'if you completed the previous mission'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head for norg and speak to'}},
        {id = 's3', at = {n = 3, fp = 'head back to ru aun gardens'},
         done = {
            {t = 'mission', line = 'zilart', eq = 27, completed = true, why = 'mission log: The Sealed Shrine completed'},
            {t = 'zonein', zone = 178, event = 51, why = "The Shrine of Ru'Avitau zone-in cutscene 51: completes the mission (status 1, LandSandBoat)"},
         }},
    },
}
