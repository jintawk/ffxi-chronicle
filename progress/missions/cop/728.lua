-- Step progress for Fire in the Eyes of Men (Chains of Promathia 7-3, mission id 728). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/7_3_Fire_in_the_Eyes_of_Men.lua. The Shaft Entrance in Mine Shaft #2716 (13, event 4,
-- status 0, LandSandBoat only) is bullet 1. Cid in Metalworks (237) plays 857 on the first talk (status 1, no timer: it only starts
-- a one Vana'diel day wait), 858 while the wait runs (a reminder, client lines #9915 and #9916), and 890 once it is over; 890 completes
-- the mission. So only event 890 and the completed id prove bullet 2; 857 marks it as under way. The draft counted 857 as a proof of
-- completion and 858 was not listed; both are corrected. The notes after the walkthrough are not steps.
return {
    title = 'Fire in the Eyes of Men',
    completes = 's2',
    known = {{t = 'mission', line = 'cop', eq = 728}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to mine shaft 2716 and'},
         done = {
            {t = 'event', zone = 13, event = 4, why = 'Shaft Entrance 4 (status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to the metalworks and speak'},
         done = {
            {t = 'mission', line = 'cop', eq = 728, completed = true, why = 'mission log: Fire in the Eyes of Men completed'},
            {t = 'event', zone = 237, event = 890, why = 'Cid 890 (the day has passed): completes'},
         },
         reach = {
            {t = 'event', zone = 237, event = 857, why = 'Cid 857: first talk, starts the one day wait'},
            {t = 'event', zone = 237, event = 858, why = 'Cid 858: still waiting (status 1)'},
         }},
    },
}
