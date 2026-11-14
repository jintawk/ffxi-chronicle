-- Step progress for Rubbish Day (Jeuno quest 13). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Rubbish_Day.lua (Chululu 198 is the offer, a menu whose option 0 begins the
-- quest and gives the Magic trash, key item 120, with nothing that can refuse it; 199 is the compatibility test, which plays
-- in every state, so it is not used; while accepted her talk is 49, or 197 once the trash is burned, which runs quest:complete,
-- but the reward includes a Chain Choker, so 197 also plays when the bag is full and is only a reach: the log's completed bit
-- proves the last step; Mashira 11 in Garlaige Citadel is a menu that also belongs to Making Amens, and its "Burn the Magic
-- trash" answer deletes key item 120). Client event scripts S4 245_Chululu_010F5023.txt (198: the I will branch says #7608,
-- 49 say #7610) and 200_Mashira_010C8159.txt (11: the Burn branch says #7241, with key item 120 as its argument). Key item 120
-- from res/key_items.lua. Bullet 2 is the accepting talk and bullets 4 and 6 only describe the way, so they are notes; the
-- compatibility tests, the Garlaige Key and the hatch leave no trace and stay plain bullets. Not repeatable.
return {
    title = 'Rubbish Day',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to her one game day'}},
        {id = 's3', at = {n = 3, fp = 'chululu gives you magic trash'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Chululu 198, option 0)'},
            {t = 'ki', id = 120, gained = true, why = 'Magic trash obtained'},
            {t = 'ki_have', id = 120, have = true, why = 'Magic trash held'},
            {t = 'chat', re = 'obtained key item: magic trash', why = 'chat: key item obtained'},
            {t = 'chat', re = "Really%? I knew you'd help%.", why = 'Chululu 198, I will branch (say #7608)'},
            {t = 'event', zone = 245, event = 49, conf = 'inferred', why = 'Chululu 49: her reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 245, event = 198, why = 'Chululu 198 offered (its finish needs option 0)'}}},
        {id = 's4', kind = 'note', with = 's8', at = {n = 4, fp = 'the magic trash can only be'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'to reach the incinerator pass through'}},
        {id = 's8', at = {n = 8, fp = 'speak with mashira who will dispose'},
         done = {
            {t = 'ki', id = 120, gained = false, after = 's3', why = 'Magic trash burned (Mashira 11, option 1)'},
            {t = 'chat', re = 'Ain.t you city folk ever heard of recyclin', after = 's3', why = 'Mashira 11, Burn branch (say #7241)'},
         },
         reach = {{t = 'event', zone = 200, event = 11, after = 's3', why = 'Mashira 11 (a menu; its finish needs option 1)'}}},
        {id = 's9', at = {n = 9, fp = 'return to chululu for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 245, event = 197, after = 's8', why = 'Chululu 197 (also plays when the Chain Choker cannot be given)'}}},
    },
}
