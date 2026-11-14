-- Step progress for Intermediate Teamwork (San d'Oria quest 64). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Intermediate_Teamwork.lua (Vilatroire 133 in West Ronfaure begins the quest
-- on option 1; 129 completes it on option 0 once the server has checked the party, otherwise it plays and completes nothing);
-- client event scripts S4 100_Vilatroire_010642AF.txt (133 say #7532/#7510 play before the offer menu, so they also play on
-- a refusal; 129 has no line of its own for the completion). The quest log is set at s3, so it proves both ends. The first
-- two bullets are travel, notes on the talk that activates the quest.
-- Shared-signal audit (2026-10-28): event 129 is the party check of all three Teamwork quests (Vilatroire), so it now needs P1 = 2 (client script: P1 picks the branch; LandSandBoat passes 1/2/3).
return {
    title = 'Intermediate Teamwork',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'first zone at c 7 in'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you should be in a watchtower'}},
        {id = 's3', at = {n = 3, fp = 'talk to him to activate the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 100, event = 133, why = 'Vilatroire 133 offered (its finish needs option 1)'}}},
        {id = 's4', at = {n = 4, fp = 'after you form a party of'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 100, event = 129, p = {[1] = 2}, why = 'Vilatroire 129: party check (completes only on option 0 with a right party)'}}},
    },
}
