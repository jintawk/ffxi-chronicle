-- Step progress for Curses, Foiled A-Golem!? (Windurst quest 63). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Curses_Foiled_A_Golem.lua (Shantotto 340 offers the quest and begin needs
-- option 1, so it is only `reach`; Torino-Samarino 104 with option 1 gives key item 171, Shantotto's new spell, and 109 re-issues
-- it; 105/108/110 are his talks at Prog 1 and 2; the Fei'Yin Cermet Door is event 14 and only plays while the spell is held, its
-- finish takes the spell and sets Prog 2; Shantotto 342 is the hand-in at Prog 2 and 343 her talk after completion). The draft
-- took key item 172 (Shantotto's ex-spell) as the Fei'Yin step: it is what the spell turns into when too many Fei'Yin monsters
-- die, the failure branch, so it proves nothing here. Quest:complete runs npcUtil.completeQuest with a Scroll of Warp II
-- reward, which fails when the bag is full after the cutscene played, so 342 is a refusal-played event (`reach`) and the quest
-- log's completed bit carries the last step. Item id from res/items.lua (4870). The quest log is set at s1, so it is not silent.
-- The final bullet is a remark about a Trust, a note.
-- Item 4870 (Scroll of Warp II) is sold by Amalasanda: shared, gated after s1.
return {
    title = 'Curses, Foiled A-Golem!?',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to shantotto k 7 who'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 239, event = 340, why = 'Shantotto 340 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'head to the tower at i'},
         done = {
            {t = 'ki', id = 171, gained = true, why = "Shantotto's new spell obtained"},
            {t = 'ki_have', id = 171, have = true, why = "Shantotto's new spell held"},
            {t = 'chat', re = "obtained key item: shantotto's new spell", why = 'chat: key item obtained'},
            {t = 'event', zone = 111, event = 105, conf = 'inferred', why = 'Torino-Samarino 105: only while the spell is held'},
         },
         reach = {{t = 'event', zone = 111, event = 104, why = 'Torino-Samarino 104 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'head to fei yin in the'},
         done = {
            {t = 'event', zone = 204, event = 14, why = 'Cermet Door 14: only plays while the spell is held, takes it'},
            {t = 'event', zone = 111, event = 110, conf = 'inferred', why = 'Torino-Samarino 110: his talk once the door was done (Prog 2)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to shantotto to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 4870, gained = true, after = 's1', conf = 'inferred', why = 'Scroll of Warp II gained (reward) (items can come from elsewhere)'},
            {t = 'event', zone = 239, event = 343, conf = 'inferred', why = 'Shantotto 343: her talk after completion'},
            {t = 'chat', re = 'Have you been using my magic%?', conf = 'inferred', why = 'Shantotto 343 (say #8137)'},
         },
         reach = {{t = 'event', zone = 239, event = 342, why = 'Shantotto 342: the hand-in (also plays when the reward cannot be given)'}}},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'the completion of this quest is'}},
    },
}
