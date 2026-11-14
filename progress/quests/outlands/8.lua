-- Step progress for Gullible's Travels (Outlands quest 8). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Magriffon.lua. 144 is the offer, a menu whose "Something's fishy" option
-- plays the same event, so the log's current bit proves the accept; 145 is his reminder while accepted; 146 is the gil trade
-- (it only plays when enough gil is offered) and runs completeQuest. Events 148 to 152 belong to the follow-up quest Even More
-- Gullible's Travels (page outlands 9), not to this one. Client event script S4 250_Magriffon_010FA02E.txt (145 say #10284,
-- 146 say #10289). The quest log is set at s1, so it is not silent. Not repeatable.
return {
    title = "Gullible's Travels",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to magriffon i 7 inside'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Magriffon 144, option 1)'},
            {t = 'event', zone = 250, event = 145, conf = 'inferred', why = 'Magriffon 145: reminder, only while accepted'},
            {t = 'chat', re = 'gil, then I could complete my mission%.', conf = 'inferred', why = 'Magriffon 145 (say #10284)'},
         },
         reach = {{t = 'event', zone = 250, event = 144, why = 'Magriffon 144 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade him the gil he asks'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 250, event = 146, why = 'Magriffon 146: the gil accepted, runs completeQuest'},
            {t = 'chat', re = 'I promise you, .* that I will never forget your kindness', why = 'Magriffon 146 (say #10289)'},
         }},
    },
}
