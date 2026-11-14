-- Step progress for A Sentry's Peril (San d'Oria quest 0). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Sentrys_Peril.lua (Glenne 510 option 0 gives the Ointment and begins the
-- quest; trading the Ointment to Aaveleon is event 100 (118 is the "carrying too much" refusal, so it proves nothing);
-- Glenne 513 on the Ointment Case completes it (514 is the wrong-item refusal); 520 is Glenne's reminder, 126 Aaveleon's
-- case re-issue, both only possible after the step they follow); client event scripts S4 230_Glenne_010E6020.txt
-- (510 say #7772 on accept, 513 say #7782/#7783, 520 say #7776) and 100_Aaveleon_010642A2.txt (100 say #7371);
-- item ids from res/items.lua (600 Ointment, 601 Ointment Case). The quest log is set at s1, so it is not silent.
return {
    title = "A Sentry's Peril",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to glenne to receive an'},
         done = {
            {t = 'chat', re = 'I thank you! His name is Aaveleon%.', why = 'Glenne 510, accepted (say #7772)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 600, gained = true, conf = 'inferred', why = 'Ointment gained (items can come from elsewhere)'},
            {t = 'event', zone = 230, event = 520, conf = 'inferred', why = 'Glenne 520: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 230, event = 510, why = 'Glenne 510 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'zone to west ronfaure and look'}},
        {id = 's3', at = {n = 3, fp = 'trade the ointment to him and'},
         done = {
            {t = 'event', zone = 100, event = 100, why = 'Aaveleon 100: the Ointment accepted'},
            {t = 'chat', re = 'Ah, that did the trick%. One dab of ointment', why = 'Aaveleon 100 (say #7371)'},
            {t = 'item', id = 601, gained = true, conf = 'inferred', why = 'Ointment Case gained (items can come from elsewhere)'},
            {t = 'event', zone = 100, event = 126, conf = 'inferred', why = 'Aaveleon 126: case re-issue, only after the trade'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to glenne and trade her'},
         done = {
            {t = 'event', zone = 230, event = 513, why = 'Glenne 513'},
            {t = 'chat', re = 'Thank you so much%. With more fiends in the woods', why = 'Glenne 513 (say #7782)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
