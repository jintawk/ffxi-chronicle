-- Step progress for Calm Before the Storm (Chains of Promathia 7-4, mission id 738). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/7_4_Calm_Before_the_Storm.lua; client script S4 237_Cid_010ED02B.txt (895, say #10138);
-- key items 669 (vessel of light) and 701 (letters from Ulmia and Prishe) from res/key_items.lua. The three monsters can be fought in
-- any order, so each has its own group (like Three Paths): Boggelmann in Misareaux Coast (25), the Cryptonberry fight in Carpenters'
-- Landing (2) and Dalham in Bibiki Bay (4). What proves each is the cutscene at the ??? after the kill (Misareaux 13 with the vessel
-- of light, Carpenters' Landing 37, Bibiki 41: all LandSandBoat only, no client script); the spawn clicks, the travel and the fights
-- leave no event or log trace (the spawn lines are zone text, not used), so they are notes on the cutscene they lead to. Cid 892
-- (status 7, all three done, hands over key item 701) is the next step; 895 plays when the letters are already held ("You'd better
-- be off for Tavnazia"), so it proves that step too. It needs all three cutscenes, so it implies them (the groups are separate, and
-- the completing step implies it). Sueleen 17 in Sealion's Den (letters held, client body empty) completes the mission. The draft
-- put the vessel of light and event 13 on the spawn bullet (bullet 2) instead of the cutscene (bullet 3), made every other monster
-- bullet a note on Cid, and left the two other cutscenes out; the held-key-item matchers (snapshot) are dropped.
return {
    title = 'Calm Before the Storm',
    completes = 's10',
    known = {{t = 'mission', line = 'cop', eq = 738}},
    groups = {
        boggelmann = {start = {{t = 'mission', line = 'cop', eq = 738, completed = false, why = 'mission line: current mission = Calm Before the Storm'}}},
        cryptonberry = {start = {{t = 'mission', line = 'cop', eq = 738, completed = false, why = 'mission line: current mission = Calm Before the Storm'}}},
        dalham = {start = {{t = 'mission', line = 'cop', eq = 738, completed = false, why = 'mission line: current mission = Calm Before the Storm'}}},
    },
    steps = {
        {id = 's1', kind = 'note', with = 's9', at = {n = 1, fp = 'after your conversation with cid you'}},
        -- Boggelmann (Misareaux Coast)
        {id = 's2', group = 'boggelmann', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to e 7 in misareaux'}},
        {id = 's3', group = 'boggelmann', at = {n = 3, fp = 'check the storage compartment again after'},
         done = {
            {t = 'event', zone = 25, event = 13, why = 'Storage Compartment 13: Boggelmann defeated, the vessel of light (LandSandBoat)'},
            {t = 'ki', id = 669, gained = true, why = 'vessel of light obtained'},
            {t = 'chat', re = 'obtained key item: vessel of light', why = 'chat: key item obtained'},
         }},
        -- Cryptonberry Executor (Carpenters' Landing)
        {id = 's4', group = 'cryptonberry', kind = 'note', with = 's6', at = {n = 4, fp = 'head to carpenters landing from the'}},
        {id = 's5', group = 'cryptonberry', kind = 'note', with = 's6', at = {n = 5, fp = 'travel to i 9 in carpenters'}},
        {id = 's6', group = 'cryptonberry', at = {n = 6, fp = 'check the again once the tonberries'},
         done = {
            {t = 'event', zone = 2, event = 37, why = "??? 37 in Carpenters' Landing: the Cryptonberries defeated (LandSandBoat)"},
         }},
        -- Dalham (Bibiki Bay)
        {id = 's7', group = 'dalham', kind = 'note', with = 's8', at = {n = 7, fp = 'travel to f 6 in bibiki'}},
        {id = 's8', group = 'dalham', at = {n = 8, fp = 'check the after defeating dalham for'},
         done = {
            {t = 'event', zone = 4, event = 41, why = '??? 41 in Bibiki Bay: Dalham defeated (LandSandBoat)'},
         }},
        {id = 's9', implies = {'s3', 's6', 's8'}, at = {n = 9, fp = 'after all of the monsters have'},
         done = {
            {t = 'event', zone = 237, event = 892, why = 'Cid 892: the letters from Ulmia and Prishe (status 7)'},
            {t = 'ki', id = 701, gained = true, why = 'letters from Ulmia and Prishe obtained'},
            {t = 'chat', re = 'obtained key item: letters from ulmia and prishe', why = 'chat: key item obtained'},
            {t = 'event', zone = 237, event = 895, why = 'Cid 895: the letters are already held'},
            {t = 'chat', re = 'Did you deliver those letters yet%?', why = 'Cid 895 (say #10138)'},
         }},
        {id = 's10', implies = {'s9'}, at = {n = 10, fp = 'talk to sueleen in the sealion'},
         done = {
            {t = 'mission', line = 'cop', eq = 738, completed = true, why = 'mission log: Calm Before the Storm completed'},
            {t = 'event', zone = 32, event = 17, why = 'Sueleen 17 (letters held): completes'},
         }},
    },
}
