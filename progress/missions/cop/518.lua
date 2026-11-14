-- Step progress for Desires of Emptiness (Chains of Promathia 5-2, mission id 518). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/5_2_Desires_of_Emptiness.lua; client script 237_Cid_010ED02B.txt lists event 850 (body
-- empty); the Spire of Vahzl (23) zone-in 20 and the Beaucedine Glacier (111) zone-in 206 are LandSandBoat's (no client script).
-- Spire zone-in 20 plays only at status 1 (all three Memory Flux cutscenes seen; 21 at status 0 turns you back, not used). The Web
-- of Recollections battlefield has no event of its own (32001 is any win in that zone): bullet 6 is a note, and the win is proven by
-- the Beaucedine zone-in 206, which plays only at status 3 (after the win). Cid 850 (status 4) completes. Bullet 4 (the Memory Flux
-- cutscenes, Promyvion - Vahzl events 51 / 52 / 53, each played after its NM is dead) is left plain: LandSandBoat sets them through
-- a table (lines 147-149) that the step checker cannot resolve to event ids. Dropped from the draft: Spire
-- zone-in 21, the Torino-Samarino / Potete / Leigon-Moigon talks on optional bullet 8 (three NPCs, one bullet: no single event is
-- proof) and the Pso'Xja checkpoint door events.
return {
    title = 'Desires of Emptiness',
    completes = 's9',
    known = {{t = 'mission', line = 'cop', eq = 518}},
    steps = {
        {id = 's5', at = {n = 5, fp = 'zone into the uncapped area spire'},
         done = {
            {t = 'zonein', zone = 23, event = 20, why = 'Spire of Vahzl zone-in cutscene 20 (status 1 only, LandSandBoat)'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'use this time to rest and'}},
        {id = 's7', at = {n = 7, fp = 'after defeating the bosses you ll'},
         done = {
            {t = 'zonein', zone = 111, event = 206, why = 'Beaucedine Glacier zone-in cutscene 206 (status 3 only, after the battlefield win, LandSandBoat)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to the metalworks and speak'},
         done = {
            {t = 'mission', line = 'cop', eq = 518, completed = true, why = 'mission log: Desires of Emptiness completed'},
            {t = 'event', zone = 237, event = 850, why = 'Cid 850: completes (status 4)'},
         }},
    },
}
