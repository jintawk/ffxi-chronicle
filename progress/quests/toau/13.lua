-- Step progress for Such Sweet Sorrow (Aht Urhgan quest 13). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Such_Sweet_Sorrow.lua (a chain of cutscenes: Dabhuh 582 warps the player to
-- Caedarva Mire, whose zone-in plays 29 and sends them back, and the zone-in at Whitegate plays 956, whose finish begins the
-- quest; 582 and 29 only reach the step, the log's accepted bit and the 956 zone-in prove it; while accepted or completed
-- Dabhuh's talk is 584; trading exactly a Merrow Scale plays 583, which runs quest:complete, whose reward is a Merrow no.17
-- locket, so 583 replays on a full bag and is only a reach: the completed bit proves the trade). The events have no client
-- script text; the zone-in ids are LandSandBoat's. Not repeatable.
return {
    title = 'Such Sweet Sorrow',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to dabhuh at k 11'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (the Whitegate zone-in 956)'},
            {t = 'zonein', zone = 50, event = 956, why = 'Whitegate zone-in 956: its finish begins the quest'},
            {t = 'event', zone = 50, event = 584, why = 'Dabhuh 584: his talk while accepted or completed'},
         },
         reach = {
            {t = 'event', zone = 50, event = 582, why = 'Dabhuh 582 offered (warps to Caedarva Mire)'},
            {t = 'zonein', zone = 79, event = 29, why = 'Caedarva Mire zone-in cutscene 29'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him a merrow scale to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 583, why = 'Dabhuh 583: the scale traded (replays if the locket cannot be given)'}}},
    },
}
