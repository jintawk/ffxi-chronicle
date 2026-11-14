-- Step progress for Equipped for All Occasions (Aht Urhgan quest 24). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/COR_AF1_Equipped_for_All_Occasions.lua (the ??? in Arrapago Reef plays 228 while
-- the quest is available, no option, and begins it; Ratihb's first talk (bullet 1) has no event of its own here, his 547 and 552
-- belong to Luck of the Draw, so bullet 1 is a note; the Iron Door raises the Lost Soul with no event, so bullet 3 is a note on the
-- fight; Iron Door 66 at Prog 2 (after the kill) hands over the Wheel lock trigger (key item 849) and sets Prog 3; the ??? 231 at
-- Prog 3 takes it back; Ratihb 772 at Prog 4 runs quest:complete, whose reward is the Trump Gun, so a full bag replays 772 and only
-- the completed bit proves the last bullet). Client event script S4 050_Ratihb_0103217C.txt (772 is bare); the other events have
-- no text. Key item id from res/key_items.lua. Not repeatable. Events 228 and 231 of zone 54 are used by no other script.
return {
    title = 'Equipped for All Occasions',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'talk to ratihb at aht urhgan'}},
        {id = 's2', at = {n = 2, fp = 'examine the in arrapago reef h'},
         done = {
            {t = 'event', zone = 54, event = 228, why = 'the ??? 228: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to maze of shakhrami map'}},
        {id = 's4', at = {n = 4, fp = 'defeat the lost soul and check'},
         done = {
            {t = 'event', zone = 198, event = 66, why = 'Iron Door 66: plays only at Prog 2 (the Lost Soul dead), hands over the trigger'},
            {t = 'ki', id = 849, gained = true, why = 'wheel lock trigger obtained'},
            {t = 'ki_have', id = 849, have = true, why = 'wheel lock trigger held'},
            {t = 'chat', re = 'obtained key item: wheel lock trigger', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to the in the arrapago'},
         done = {
            {t = 'event', zone = 54, event = 231, why = 'the ??? 231: plays only at Prog 3, takes the trigger back'},
            {t = 'ki', id = 849, gained = false, conf = 'inferred', why = 'wheel lock trigger handed over'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to ratihb aht urhgan whitegate'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 772, why = 'Ratihb 772: plays only at Prog 4, runs quest:complete (replays if the Trump Gun cannot be given)'}}},
    },
}
