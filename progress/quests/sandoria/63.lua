-- Step progress for Introduction to Teamwork (San d'Oria quest 63). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Introduction_to_Teamwork.lua (Vilatroire 135 begins the quest on option 1;
-- 129 is the party check: its finish completes the quest only with option 0 and a same-nation party, but the reward is an
-- item (Shell Ring), so 129 plays on a failed check and on a full bag with no completion and is never proof); client event
-- script S4 100_Vilatroire_010642AF.txt (135 says #7508 on the accept branch). The first two bullets are the walk to the
-- watchtower: notes on the activation bullet, which rests on the accept line and the quest log.
-- Shared-signal audit (2026-10-28): dropped item 13442 (Shell Ring is sold by guild shops); event 129 is the party check of all three Teamwork quests, so it now needs P1 = 1 (client script: P1 picks the branch; LandSandBoat passes 1/2/3).
return {
    title = 'Introduction to Teamwork',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'first zone at c 7 in'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you should be in a watchtower'}},
        {id = 's3', at = {n = 3, fp = 'talk to him to activate the'},
         done = {
            {t = 'chat', re = 'Very well%. Let me know when you.ve collected all your party members%.', why = 'Vilatroire 135 (say #7508, accept branch)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 100, event = 135, why = 'Vilatroire 135 offered (accepting needs option 1)'}}},
        {id = 's4', at = {n = 4, fp = 'after you form a party of'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 100, event = 129, p = {[1] = 1}, why = 'Vilatroire 129: the party check (no completion on a failed check or a full bag)'}}},
    },
}
