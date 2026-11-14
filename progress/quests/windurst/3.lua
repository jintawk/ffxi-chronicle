-- Step progress for Making Amends (Windurst quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- The page has one bullet, which bundles the accept and the trade, so the quest log's current bit (set when Hakkuru-Rinkuru
-- is accepted at 274, option 1) only shows the bullet in progress: it is a reach, not proof, and the draft's use of it as
-- proof is dropped. Evidence: LandSandBoat scripts/quests/windurst/Making_Amends.lua (274 is the offer menu and can be
-- declined; 275 is the reminder while accepted; the Animal Glue trade plays 277, which completes the quest and pays 1,500
-- gil with no reward item to refuse; 278 plays only once it is completed and the player has not zoned); client event script
-- S4 240_Hakkuru_Rinkuru_010F0011.txt (274 menu #3767, 275 say #3771, 277 say #3775/#3776 or #12381/#12382, 278 say #3777).
return {
    title = 'Making Amends',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with hakkuru rinkuru in the'},
         done = {
            {t = 'event', zone = 240, event = 277, why = 'Hakkuru-Rinkuru 277: the Animal Glue accepted'},
            {t = 'chat', re = "You're the bee's knees!", why = 'Hakkuru-Rinkuru 277 (say #3776)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 240, event = 278, conf = 'inferred', why = 'Hakkuru-Rinkuru 278: plays only once completed'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted (Hakkuru-Rinkuru 274, option 1)'},
            {t = 'event', zone = 240, event = 275, why = 'Hakkuru-Rinkuru 275: reminder, only while accepted'},
            {t = 'event', zone = 240, event = 274, why = 'Hakkuru-Rinkuru 274 offered (its finish needs option 1)'},
         }},
    },
}
