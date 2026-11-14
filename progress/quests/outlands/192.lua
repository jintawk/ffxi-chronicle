-- Step progress for Don't Forget the Antidote (Outlands quest 192). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Rabao/npcs/Edigey.lua (Edigey 2 is the offer and begins the quest only on option 1, so it
-- also plays on a refusal; while accepted a plain talk plays 3; the trade of one Desert Venom plays 4 whether the quest is accepted
-- or completed, and its finish gives the Dotanuki and completes the quest the first time, and only gil afterwards); client event
-- script S4 247_Edigey_010F7008.txt (2 say #10018 only on the accepting branch; 3 say #10020; 4 say #10021 and #10022 on the
-- first completion, #10023 on a repeat). The Desert Venom bullet is a note on the trade. Repeatable by the trade alone, so a
-- trade after a finished run opens the next one and skips the offer; the quest log's bits and the first-time lines count for the
-- first run only.
return {
    title = "Don't Forget the Antidote",
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s3'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to edigey to begin this'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (Edigey 2, option 1)'},
            {t = 'chat', re = "Thanks, pal, you're a lifesaver!", run1 = true, why = 'Edigey 2, the accepting branch (say #10018)'},
            {t = 'event', zone = 247, event = 3, conf = 'inferred', run1 = true, why = 'Edigey 3: his talk, only while accepted'},
         },
         reach = {{t = 'event', zone = 247, event = 2, why = 'Edigey 2 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'desert venom drops off doom scorpions'}},
        {id = 's3', at = {n = 3, fp = 'trade the desert venom to edigey'},
         done = {
            {t = 'event', zone = 247, event = 4, why = 'Edigey 4: the Desert Venom accepted (first time completes, later runs pay gil)'},
            {t = 'chat', re = "If ya come across any more of the stuff, bring it to me, and I'll buy it off ya%.", run1 = true, why = 'Edigey 4 first completion (say #10022)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
         }},
    },
}
