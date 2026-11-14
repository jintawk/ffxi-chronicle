-- Step progress for A Smudge on One's Record (Windurst quest 12). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/A_Smudge_on_Ones_Record.lua (Hariga-Origa 413 is an Accept/Decline menu,
-- option 0 begins the quest, so it is only a reach; 414 is his talk while accepted; trading exactly the Vial of Slime Oil and
-- the Frost Turnip plays 417, which completes the quest and gives gil, experience and the Map of Fei'Yin with no item reward
-- to refuse; 418 plays once completed and before zoning); client event script S4 238_Hariga_Origa_010EE014.txt (413 menu
-- #8296, 414 say #8299, 417 say #8306, 418 say #8315); key item id from res/key_items.lua (411 map of Fei'Yin, the reward,
-- which may already be owned). Not repeatable (page meta). The quest log is set at s1, so it is not silent.
-- Shared-signal audit: key item 411 (Map of Fei'Yin) is also sold by the map vendors (globals/maps.lua): shared, gated after s1.
return {
    title = "A Smudge on One's Record",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to hariga origa in windurst'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Hariga-Origa 413, option 0)'},
            {t = 'event', zone = 238, event = 414, conf = 'inferred', why = 'Hariga-Origa 414: his talk, only while accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 413, why = 'Hariga-Origa 413 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'trade both slime oil and frost'},
         done = {
            {t = 'event', zone = 238, event = 417, why = 'Hariga-Origa 417: the Vial of Slime Oil and Frost Turnip accepted'},
            {t = 'chat', re = 'Squeak, squeak, squeak%.%.%.', why = 'Hariga-Origa 417 (say #8306)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 411, gained = true, after = 's1', conf = 'inferred', why = "Map of Fei'Yin obtained (reward)"},
            {t = 'event', zone = 238, event = 418, conf = 'inferred', why = 'Hariga-Origa 418: plays only once completed'},
         }},
    },
}
