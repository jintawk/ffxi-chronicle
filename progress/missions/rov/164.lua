-- Step progress for Ever Forward (Rhapsodies of Vana'diel mission, page id 164 = LandSandBoat's EVER_FORWARD 56 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_07_Ever_Forward.lua. Two ways out, both gated on Treasures of Aht Urhgan: the
-- zone-in cutscene 30039 in any of the ten nation zones (bullet 1, and the same scene as bullets 4 to 5) completes the mission into
-- Aphmau's Light (170); the Imperial Whitegate's event 166 (bullet 2) completes it straight into Reunited (172), skipping 170. Both
-- are cutscenes with no refusal branch (below Royal Puppeteer the Whitegate only prints a message and no event plays). Event 166
-- is also the Whitegate event of Aphmau's Light (170), which comes after this mission in the line, so seeing it can never tick this
-- page early. The rov line holds the page id and has no completed set, so the completion is `min = 168`: the next value is 168
-- (the Endless Sky placeholder, no script), 170 or 172, and all three are above 164. Bullets 3 to 6 only describe where the
-- scenes lead (their text is the result of bullets 1, 2 and 4), so they are notes. Cross-audit: the reward is Cipher: Nashmeira II
-- and mission:complete returns before completing when the bag is full (npc_util.lua:753-762), so event 166 can play and leave the
-- mission current (it replays); on the completing step it is only `reach`, and the line moving on proves the step. The zone-in
-- 30039 calls completeMission directly (no item), so it stays proof of bullet 1. Dropped from the draft: the line's `min = 168`
-- on bullet 1 (it is the optional zone-in, and the move on is not proof of it).
return {
    title = 'Ever Forward',
    completes = 's2',
    known = {{t = 'mission', line = 'rov', min = 164, max = 167}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'optional return to your home nation'},
         done = {
            {t = 'zonein', zone = 230, event = 30039, why = "Southern San d'Oria zone-in 30039 (plays while this mission is current)"},
            {t = 'zonein', zone = 231, event = 30039, why = "Northern San d'Oria zone-in 30039"},
            {t = 'zonein', zone = 232, event = 30039, why = "Port San d'Oria zone-in 30039"},
            {t = 'zonein', zone = 234, event = 30039, why = 'Bastok Mines zone-in 30039'},
            {t = 'zonein', zone = 235, event = 30039, why = 'Bastok Markets zone-in 30039'},
            {t = 'zonein', zone = 236, event = 30039, why = 'Port Bastok zone-in 30039'},
            {t = 'zonein', zone = 238, event = 30039, why = 'Windurst Waters zone-in 30039'},
            {t = 'zonein', zone = 239, event = 30039, why = 'Windurst Walls zone-in 30039'},
            {t = 'zonein', zone = 240, event = 30039, why = 'Port Windurst zone-in 30039'},
            {t = 'zonein', zone = 241, event = 30039, why = 'Windurst Woods zone-in 30039'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the imperial whitegate for a'},
         done = {
            {t = 'mission', line = 'rov', min = 168, why = 'mission log: the line moved past Ever Forward'},
         },
         reach = {{t = 'event', zone = 50, event = 166, why = 'Imperial Whitegate 166 (completes into Reunited unless the bag is full, then it replays)'}}},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you will skip to the mission'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'return to your home nation for'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'after viewing the cutscene in your'}},
        {id = 's6', kind = 'note', with = 's2', at = {n = 6, fp = 'you will progress to the mission'}},
    },
}
