-- Step progress for Candle-making (Jeuno quest 22). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Candle_Making.lua (Rouliette 36 is a plain talk that has no choice and begins
-- the quest on its finish, offered while A Candlelight Vigil is accepted, and is repeated as the reminder; Rouliette 37 plays
-- only for an exact Lanolin Cube trade and runs quest:complete, whose reward is a key item and a title, nothing to refuse);
-- client event script S4 244_Rouliette_010F4016.txt (36 say #7098, 37 say #7099); item id from res/items.lua (531 Lanolin,
-- the Lanolin Cube) and key item from res/key_items.lua (50 Holy candle). Not repeatable (page meta).
return {
    title = 'Candle-making',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'rouliette in the goddess temple will'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Rouliette 36)'},
            {t = 'chat', re = 'Oh, all you want is a candle%? Very well%.', why = 'Rouliette 36 (say #7098)'},
            {t = 'event', zone = 244, event = 36, why = 'Rouliette 36: no choice, the quest begins on its finish'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade her the lanolin cube to'},
         done = {
            {t = 'event', zone = 244, event = 37, why = 'Rouliette 37: the Lanolin Cube accepted'},
            {t = 'chat', re = 'Excellent%. As promised, I bestow upon you this holy candle%.', why = 'Rouliette 37 (say #7099)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 50, gained = true, conf = 'inferred', why = 'Holy candle obtained (reward)'},
            {t = 'item', id = 531, lost = true, after = 's1', conf = 'inferred', why = 'Lanolin Cube gone (traded, or sold)'},
         }},
    },
}
