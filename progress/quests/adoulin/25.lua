-- Step progress for Destiny's Device (Adoulin quest 25). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script for the quest (the enum names it only) and no decoded client event for Octavien, Gaddiux or
-- the Bloodstained Glove, so the signals are key items and the log, from BG-wiki's walkthrough: Octavien hands over the Runic
-- kinegraver (2370), the Yahse Wildflower the Yahse wildflower petal (2279; LandSandBoat gives the same petal for Children of
-- the Rune, so it is gated behind bullet 1), the Marjami ??? the Vial of vivid rainbow extract (2371), and Insidio's defeat
-- Insidio's extinguished lantern (2372). Ids and temporary category from res/key_items.lua. The draft put the petal on bullet 2
-- (Gaddiux); the page hands it over at bullet 3. It also put the completed bit on the Insidio fight and made the return to
-- Octavien (bullet 10) a note on an optional step; the quest completes at bullet 10. Gaddiux's two talks, the Octavien talk and
-- the trip to the beach have no signal of their own and are notes on the fight. The two optional bullets have no signal.
-- Not repeatable.
return {
    title = "Destiny's Device",
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to octavien at eastern adoulin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Octavien)'},
            {t = 'ki', id = 2370, gained = true, why = 'runic kinegraver obtained'},
            {t = 'ki_have', id = 2370, have = true, why = 'runic kinegraver held'},
            {t = 'chat', re = 'obtained key item: runic kinegraver', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to gaddiux at the inventors'}},
        {id = 's3', at = {n = 3, fp = 'click the yahse wildflower in yahse'},
         done = {
            {t = 'ki', id = 2279, gained = true, after = 's1', why = 'yahse wildflower petal obtained'},
            {t = 'ki_have', id = 2279, have = true, after = 's1', why = 'yahse wildflower petal held'},
            {t = 'chat', re = 'obtained key item: yahse wildflower petal', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'in marjami ravine travel to the'},
         done = {
            {t = 'ki', id = 2371, gained = true, after = 's1', why = 'vial of vivid rainbow extract obtained'},
            {t = 'ki_have', id = 2371, have = true, why = 'vial of vivid rainbow extract held'},
            {t = 'chat', re = 'obtained key item: vial of vivid rainbow extract', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'speak to gaddiux once more again'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'speak to octavien'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'travel to the secret beach at'}},
        {id = 's8', at = {n = 8, fp = 'after all party members have watched'},
         done = {
            {t = 'ki', id = 2372, gained = true, after = 's1', why = "Insidio's extinguished lantern obtained"},
            {t = 'ki_have', id = 2372, have = true, why = "Insidio's extinguished lantern held"},
            {t = 'chat', re = "obtained key item: insidio's extinguished lantern", why = 'chat: key item obtained'},
         }},
        {id = 's9', kind = 'optional', at = {n = 9, fp = 'optional examine the bloodstained glove after'}},
        {id = 's10', at = {n = 10, fp = 'return to octavien to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's11', kind = 'optional', at = {n = 11, fp = 'optional talk to zurko bazurko in'}},
    },
}
