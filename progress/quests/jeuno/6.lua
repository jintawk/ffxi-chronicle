-- Step progress for A Candlelight Vigil (Jeuno quest 6). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/A_Candlelight_Vigil.lua (Ilumida 192 is the first offer and 193 the second,
-- only option 1 begins the quest in both, so they are reaches; while accepted she plays 191, or 194 when the Holy candle is
-- held, which runs quest:complete and deletes the candle; the reward is a Flower Necklace, so 194 also plays when the bag is
-- full and is only a reach: the log's completed bit proves the last step) and scripts/quests/jeuno/Candle_Making.lua
-- (Rouliette 36 starts Candle Making, which is only possible while this quest is accepted, and trading a Lanolin Cube plays
-- 37, which gives the Holy candle, key item 50, as the reward). Client event scripts S4 244_Ilumida_010F401B.txt (193: the
-- Yes branch says #7445, 191 say #7447) and 244_Rouliette_010F4016.txt (36 say #7098, 37 say #7099). Key item 50 from
-- res/key_items.lua. Rouliette's events and the Holy candle belong to Candle Making, a quest of its own, so they count only
-- once this quest is accepted (after = 's1'). Not repeatable.
return {
    title = 'A Candlelight Vigil',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ilumida in upper jeuno'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ilumida 192 or 193, option 1)'},
            {t = 'event', zone = 244, event = 191, conf = 'inferred', why = 'Ilumida 191: her talk, only while accepted'},
            {t = 'chat', re = 'I think the Temple of the Goddess should have some candles%.', conf = 'inferred', why = 'Ilumida 191 (say #7447)'},
         },
         reach = {
            {t = 'event', zone = 244, event = 192, why = 'Ilumida 192 offered (its finish needs option 1)'},
            {t = 'event', zone = 244, event = 193, why = 'Ilumida 193 offered (its finish needs option 1)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to rouliette at h 9'},
         done = {
            {t = 'event', zone = 244, event = 36, after = 's1', why = 'Rouliette 36: Candle Making offered, possible only while this quest is accepted'},
            {t = 'chat', re = 'Oh, all you want is a candle%?', after = 's1', why = 'Rouliette 36 (say #7098)'},
         }},
        {id = 's3', at = {n = 3, fp = 'rouliette will provide you with the'},
         done = {
            {t = 'ki', id = 50, gained = true, after = 's1', why = 'Holy candle obtained (Candle Making reward)'},
            {t = 'ki_have', id = 50, have = true, after = 's1', why = 'Holy candle held'},
            {t = 'chat', re = 'obtained key item: holy candle', after = 's1', why = 'chat: key item obtained'},
            {t = 'event', zone = 244, event = 37, after = 's1', why = 'Rouliette 37: the Lanolin Cube accepted, Candle Making completed'},
            {t = 'chat', re = 'As promised, I bestow upon you this holy candle%.', after = 's1', why = 'Rouliette 37 (say #7099)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return and speak to ilumida in'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 50, gained = false, after = 's3', conf = 'inferred', why = 'Holy candle deleted on completion'},
         },
         reach = {{t = 'event', zone = 244, event = 194, why = 'Ilumida 194 (also plays when the Flower Necklace cannot be given)'}}},
    },
}
