-- Step progress for Overnight Delivery (Windurst quest 15). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Overnight_Delivery.lua (Kenapa-Keppa 336, 337 and 338 are the first three
-- talks and only set Prog; 339 is the offer and only option 0 begins the quest, so it is a reach; 340 to 343 are his reminder
-- talks, played only while the quest is accepted and the Small bag is not held; Kotan-Purutan 141 at Mhaura gives key item 99
-- between 18:00 and 6:00, 144 and 142 are refusals; Kenapa-Keppa 348 is the in-time hand-in and runs quest:complete, which can
-- fail on the Power Gi (full bag), so it is a reach and the quest log's completed bit carries the last step; 346 is the too-late
-- return that deletes the quest and the bag, a failure that proves nothing; 347 plays on a quest available again after that
-- failure, so it proves nothing either). The Small bag is also lost on the failed return, so its loss does not prove the
-- completion. No client event scripts exist for these events, so there are no chat lines. Key item id from res/key_items.lua.
-- The quest log is set at s1, so it is not silent.
return {
    title = 'Overnight Delivery',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to kenapa keppa after 7'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kenapa-Keppa 339, option 0)'},
            {t = 'event', zone = 238, event = 340, why = 'Kenapa-Keppa 340: reminder, only once accepted'},
            {t = 'event', zone = 238, event = 341, why = 'Kenapa-Keppa 341: reminder, only once accepted'},
            {t = 'event', zone = 238, event = 342, why = 'Kenapa-Keppa 342: reminder, only once accepted'},
            {t = 'event', zone = 238, event = 343, why = 'Kenapa-Keppa 343: reminder, only once accepted'},
         },
         reach = {
            {t = 'event', zone = 238, event = 336, why = 'Kenapa-Keppa 336: first talk'},
            {t = 'event', zone = 238, event = 337, why = 'Kenapa-Keppa 337: second talk'},
            {t = 'event', zone = 238, event = 338, why = 'Kenapa-Keppa 338: third talk'},
            {t = 'event', zone = 238, event = 339, why = 'Kenapa-Keppa 339 offered (its finish needs option 0)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to mhaura and speak to'},
         done = {
            {t = 'event', zone = 249, event = 141, why = 'Kotan-Purutan 141: gives the Small bag'},
            {t = 'ki', id = 99, gained = true, why = 'small bag obtained'},
            {t = 'ki_have', id = 99, have = true, why = 'small bag held'},
            {t = 'chat', re = 'obtained key item: small bag', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to kenapa keppa before 6'},
         reach = {{t = 'event', zone = 238, event = 348, why = 'Kenapa-Keppa 348: in time (also plays with a full bag, the Power Gi may not fit)'}},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
