-- Step progress for Royal Puppeteer (Treasures of Aht Urhgan mission 12, mission id 11). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/12_Royal_Puppeteer.lua. Naja Salaheem 3071 is a plain briefing (mission:event) and
-- proves nothing, so bullets 1 and 2 are notes. Pyopyoroon (Nashmau, zone 53) plays 277 only at status 0 (his finish sets status 1)
-- and 279 only on a trade of one Vial of Jody's Acid, whose finish completes the mission. The Vial of spectral scent (a reward key
-- item) is not used.
return {
    title = 'Royal Puppeteer',
    completes = 's4',
    known = {{t = 'mission', line = 'toau', eq = 11}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'once you start this mission you'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to salaheem s sentinels aht'}},
        {id = 's3', at = {n = 3, fp = 'speak to pyopyoroon nashmau h 7'},
         done = {
            {t = 'event', zone = 53, event = 277, why = "Pyopyoroon 277: asks for Jody's Acid (status 0 only)"},
         }},
        {id = 's4', at = {n = 4, fp = 'trade jody s acid to pyopyoroon'},
         done = {
            {t = 'event', zone = 53, event = 279, why = "Pyopyoroon 279: plays only on the Jody's Acid trade, completes"},
            {t = 'mission', line = 'toau', eq = 11, completed = true, why = 'mission log: Royal Puppeteer completed'},
         }},
    },
}
