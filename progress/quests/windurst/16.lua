-- Step progress for Water Way to Go! (Windurst quest 16). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Water_Way_to_Go.lua (Ohbiru-Dohbiru 352 is the offer: it plays on a refusal
-- too, and the quest begins only with option 0 and a free slot for the Rhinostery Canteen, so it is a reach; 354 re-issues a
-- lost canteen and plays only while the quest is accepted or restarted; Giddeus Spring 55 plays on the canteen trade, but the
-- Giddeus Water is given in its finish, which fails with a full bag, so it is a reach and the game's own "Obtained:" line is the
-- proof; Ohbiru-Dohbiru 355 takes the Giddeus Water and runs quest:complete, which has no item reward). The Giddeus Water
-- comes only from the spring trade. Repeatable (page meta): a finished run is restarted at Ohbiru-Dohbiru (352 again, then a
-- new canteen), so the quest-log matchers count the first run only (run1) and the canteen or its re-issue opens the next run.
-- No client event scripts exist for these events, so there are no dialogue lines; the "Obtained:" text is the zone IDs.lua
-- ITEM_OBTAINED. Item ids from res/items.lua (504 Rhinostery canteen, 4351 Giddeus Water). The quest log is set at s1.
return {
    title = 'Water Way to Go!',
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ohbiru dohbiru to receive'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = 'Obtained: .-rhinost', why = 'ITEM_OBTAINED, the Rhinostery Canteen (accept or re-issue)'},
            {t = 'event', zone = 238, event = 354, why = 'Ohbiru-Dohbiru 354: canteen re-issue, only once accepted'},
            {t = 'item', id = 504, gained = true, conf = 'inferred', why = 'Rhinostery canteen gained (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 238, event = 352, why = 'Ohbiru-Dohbiru 352 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'trade the rhinostery canteen to the'},
         reach = {{t = 'event', zone = 145, event = 55, why = 'Giddeus Spring 55: the canteen trade (also plays with a full bag)'}},
         done = {
            {t = 'chat', re = 'Obtained: .-Giddeus water', why = 'ITEM_OBTAINED, the spring trade is the only source'},
            {t = 'item', id = 4351, gained = true, why = 'Giddeus Water gained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to ohbiru dohbiru and trade'},
         done = {
            {t = 'event', zone = 238, event = 355, why = 'Ohbiru-Dohbiru 355: the Giddeus Water accepted, completes'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}
