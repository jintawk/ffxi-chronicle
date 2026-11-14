-- Step progress for The Goblin Tailor (Jeuno quest 42). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Goblin_Tailor.lua (Guttrix 10016 plays only while the quest is available
-- and the fame and level are met; the refusal is a different event, 10020; its finish begins the quest. While accepted he
-- plays 10017 without the Magical pattern and 10018 with it; 10018 is a menu, and only a chosen piece that fits the bag
-- removes the pattern, completes the quest and adds the item, so 10018 and its line are only a reach and the pattern's loss
-- (key item 178) is the proof that does not depend on the menu; 10019 once all four pieces are bought); client event script
-- S4 245_Guttrix_010F503E.txt (10016 say #7925, 10017 say #7929, 10018 say #7931); key item id from res/key_items.lua (178
-- magical pattern). The pattern comes out of a treasure chest in a dungeon, which only the key item gain shows, and the page
-- gives that no bullet of its own (it is indented under the first bullet), so the gain is a reach on the hand-in. The page
-- is repeatable up to four clears, but every clear looks alike and the key items carry no run marker, so no restart is
-- mapped. The ammo bullets (NM drops) have no signal.
return {
    title = 'The Goblin Tailor',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to guttrix who will offer'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 245, event = 10016, why = 'Guttrix 10016: the offer, plays only while available'},
            {t = 'chat', re = "I'm the best Gobbie tailor in the 'hood!", why = 'Guttrix 10016 (say #7925)'},
            {t = 'event', zone = 245, event = 10017, conf = 'inferred', why = 'Guttrix 10017: his talk without a pattern, only while accepted'},
            {t = 'chat', re = "Look, you bring me .- and I'll give you somethin' pretty to wear%.", conf = 'inferred', why = 'Guttrix 10017 (say #7929)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'each race is given a game'}},
        {id = 's3', at = {n = 3, fp = 'turn the pattern into guttrix who'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the first clear)'},
            {t = 'ki', id = 178, gained = false, why = 'magical pattern handed over (only taken once a piece is given)'},
         },
         reach = {
            {t = 'ki', id = 178, gained = true, why = 'magical pattern obtained from a chest'},
            {t = 'ki_have', id = 178, have = true, why = 'magical pattern held'},
            {t = 'event', zone = 245, event = 10018, why = 'Guttrix 10018 (the menu also plays on "Let me think" and with a full bag)'},
            {t = 'chat', re = 'Hey, you did it! Now, take your pick,', why = 'Guttrix 10018 (say #7931)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'all four armor pieces can be'}},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'in addition to the armor there'}},
        {id = 's6', kind = 'note', with = 's3', at = {n = 6, fp = 'during the correct time for your'}},
        {id = 's7', kind = 'note', with = 's3', at = {n = 7, fp = 'chest may also spawn near morbolger'}},
        {id = 's8', kind = 'note', with = 's3', at = {n = 8, fp = 'aroma leech are not marked on'}},
    },
}
