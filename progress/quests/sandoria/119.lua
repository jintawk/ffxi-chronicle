-- Step progress for Trust: San d'Oria (San d'Oria quest 119). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Southern_San_dOria/npcs/Gondebaud.lua (3500 or 3504 offers it with a menu: only option
-- 2 adds the quest and gives key item 2500, so the events are `reach`; 3501 plays while 2500 is held) and
-- scripts/zones/Northern_San_dOria/npcs/Excenmille.lua (a first Trust quest: 893 gives the Excenmille spell, 894 is a talk,
-- and after casting him 895 takes 2500, runs completeQuest and prints CALL_MULTIPLE_ALTER_EGO; after another nation's Trust
-- quest 897 does all of it at once; the reward is key item 2501, no item); client event scripts S4 230_Gondebaud_010E62B1.txt
-- (3500 say #15638 and 3504 #15630 on the accept branch, 3501 #15640) and 231_Excenmille_010E70D1.txt (894 #18405).
-- The draft counted 893 and 894 as the end of the quest: they leave it open, so they are `reach`; the bullet closes at 895
-- or 897.
-- Shared-signal audit: the chat line 'You are now able to call multiple alter egos.' dropped (shared with Trust: Bastok and Windurst); events 895/897 and key item 2501 are unique.
return {
    title = "Trust: San d'Oria",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to gondebaud in southern san'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2500, gained = true, why = 'red institute card obtained'},
            {t = 'ki_have', id = 2500, have = true, why = 'red institute card held'},
            {t = 'chat', re = 'obtained key item: red institute card', why = 'chat: key item obtained'},
            {t = 'event', zone = 230, event = 3501, conf = 'inferred', why = 'Gondebaud 3501: only while the card is held'},
            {t = 'chat', re = "To get to Northern San d'Oria, you must first head west of here, then north toward Victory Square%.", conf = 'inferred', why = 'Gondebaud 3501 (say #15640)'},
         },
         reach = {{t = 'event', zone = 230, event = 3500, why = 'Gondebaud 3500 offered (its finish needs option 2)'},
                  {t = 'event', zone = 230, event = 3504, why = 'Gondebaud 3504 offered (its finish needs option 2)'}}},
        {id = 's2', at = {n = 2, fp = 'head to northern san d oria'},
         done = {
            {t = 'event', zone = 231, event = 897, why = 'Excenmille 897: completes the quest'},
            {t = 'event', zone = 231, event = 895, why = 'Excenmille 895: completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2501, gained = true, conf = 'inferred', why = "San d'Oria Trust permit obtained (reward)"},
            {t = 'ki', id = 2500, gained = false, conf = 'inferred', why = 'red institute card taken'},
         },
         reach = {{t = 'event', zone = 231, event = 893, why = 'Excenmille 893: the first talk, he joins; the quest stays open'},
                  {t = 'event', zone = 231, event = 894, why = 'Excenmille 894: a talk before he is cast'}}},
    },
}
