-- Step progress for Chocobilious (Windurst quest 27). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Kuoh_Rhel.lua (224 is the offer and only the accept answer adds the
-- quest, so it is a reach; 225 is his reminder and 231 his hand-in talk, both only while accepted; 231 runs completeQuest with
-- gil and fame, no item reward, so nothing can fail; 232 is his talk once completed until the player zones) and
-- Tapoh_Lihzeh.lua (227 first talk and 228 second talk before the Papaka Grass; 229 is the Papaka Grass trade, which sets the
-- variable to 2 with nothing to fail; 230 is her talk after it, and Kuoh Rhel's 231 needs that variable too); client event
-- scripts S4 241_Kuoh_Rhel_010F103C.txt (225 say #7957, 231 #7971, 232 #7972), 241_Tapoh_Lihzeh_010F106A.txt (228 #7964,
-- 230 #7969). The draft put 228 (before the trade) and 232 (completed) on the wrong bullets. The quest log is set at s1.
return {
    title = 'Chocobilious',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kuoh rhel inside the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 225, why = 'Kuoh Rhel 225: reminder, only while accepted'},
            {t = 'chat', re = "Hurry up and go to the apothecary, y'hearrr%?", why = 'Kuoh Rhel 225 (say #7957)'},
         },
         reach = {{t = 'event', zone = 241, event = 224, why = 'Kuoh Rhel 224 offered (its finish needs the accept answer)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to tapoh lihzeh at i'},
         reach = {
            {t = 'event', zone = 241, event = 227, why = 'Tapoh Lihzeh 227: first talk, before the trade'},
            {t = 'event', zone = 241, event = 228, why = 'Tapoh Lihzeh 228: second talk, before the trade'},
            {t = 'chat', re = "Accorrrding to the staff of the dhalmel farm, there aren't any", why = 'Tapoh Lihzeh 228 (say #7964)'},
         },
         done = {
            {t = 'event', zone = 241, event = 229, why = 'Tapoh Lihzeh 229: the Papaka Grass accepted'},
            {t = 'event', zone = 241, event = 230, why = 'Tapoh Lihzeh 230: only after the trade'},
            {t = 'chat', re = "I'm starrrting to make the medicament now%.", why = 'Tapoh Lihzeh 230 (say #7969)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to kuoh rhel again to'},
         done = {
            {t = 'event', zone = 241, event = 231, why = 'Kuoh Rhel 231: the hand-in talk, completes'},
            {t = 'chat', re = 'Well, thank you for going through all that trrrouble%.', why = 'Kuoh Rhel 231 (say #7971)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 232, why = 'Kuoh Rhel 232: his talk once completed'},
            {t = 'chat', re = 'Once my little chocobo friend here is back on his feet again', why = 'Kuoh Rhel 232 (say #7972)'},
         }},
    },
}
