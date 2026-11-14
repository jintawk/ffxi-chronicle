-- Step progress for In a Stew (Windurst quest 45). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/In_a_Stew.lua (Kuoh Rhel 235 is the first-time offer and begins the quest with no
-- option test; 234 is the repeat offer after a conquest tally, a menu where only option 1 restarts it; 236 is his reminder; Matata
-- 237 is the hint, once Prog is 1 or more; Ranpi-Monpi 554 and 555 request the 3 Woozyshrooms, 557 is his reminder after the trade;
-- 556 plays on the exact trade of 3 Woozyshrooms, takes them and gives the special stew key item, setting Prog 2; Kuoh Rhel 239
-- plays only at Prog 2 and runs quest:complete, which pays gil and fame only, so it cannot fail; Matata 241 is the post-quest lore
-- while the must-zone flag is set). Client event scripts S4 241_Kuoh_Rhel_010F103C.txt (234 menu #7977, 236 say #7984, 240 say
-- #7995), 241_Matata_010F103D.txt (237 say #7986, 241 say #7997); key item 100 from res/key_items.lua, item 4373 from res/items.lua.
-- The quest can be repeated after a conquest tally, but the only marker of a new run is the 234 menu, which plays whether or not the
-- offer is taken, so there is no `repeatable` entry. Bullet 6 (wait for the next conquest update) is a note under Notes, not a step.
return {
    title = 'In a Stew',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kuoh rhel'},
         done = {
            {t = 'event', zone = 241, event = 235, why = 'Kuoh Rhel 235: the offer, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 236, conf = 'inferred', why = 'Kuoh Rhel 236: reminder, only once begun'},
            {t = 'chat', re = "I finally got the secret cure%-all medicament from the apothecary", conf = 'inferred', why = 'Kuoh Rhel 236 (say #7984)'},
         },
         reach = {{t = 'event', zone = 241, event = 234, why = 'Kuoh Rhel 234 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to matata k 12'},
         done = {
            {t = 'event', zone = 241, event = 237, why = 'Matata 237: the hint toward Ranpi-Monpi'},
            {t = 'chat', re = "Why don't y'all try mixing that bitter medicament into some of Ranpi%-Monpi's special stew", why = 'Matata 237 (say #7986)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to ranpi monpi in the'}, count = {item = 4373, need = 3},
         done = {
            {t = 'event', zone = 238, event = 556, why = 'Ranpi-Monpi 556: the 3 Woozyshrooms accepted, gives the stew'},
            {t = 'ki', id = 100, gained = true, why = "Ranpi-Monpi's special stew obtained"},
            {t = 'chat', re = "obtained key item: ranpi%-monpi's special stew", why = 'chat: key item obtained'},
            {t = 'ki_have', id = 100, have = true, why = "Ranpi-Monpi's special stew held"},
            {t = 'event', zone = 238, event = 557, conf = 'inferred', why = 'Ranpi-Monpi 557: reminder, only after the trade'},
         },
         reach = {
            {t = 'event', zone = 238, event = 554, why = 'Ranpi-Monpi 554: asks for the 3 Woozyshrooms'},
            {t = 'event', zone = 238, event = 555, why = 'Ranpi-Monpi 555: reminder to get the Woozyshrooms'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to kuoh rhel to complete'},
         done = {
            {t = 'event', zone = 241, event = 239, why = 'Kuoh Rhel 239: only at Prog 2, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 100, gained = false, conf = 'inferred', why = "Ranpi-Monpi's special stew handed over"},
         }},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'optional speak to matata again for'},
         done = {
            {t = 'event', zone = 241, event = 241, why = 'Matata 241: the lore, only after completing'},
            {t = 'chat', re = 'I wonder why that chocobo turned all sickly in the first place%?', why = 'Matata 241 (say #7997)'},
         }},
    },
}
