-- Step progress for Hearts of Mythril (Bastok quest 6). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Hearts_of_Mythril.lua (Elki 41 is the offer: only option 0 gives key item 23
-- and begins the quest; the Zegham Hill monument event 11 is offered while the key item is held and only option 0 lays it down,
-- deleting the key item and setting Prog 1; Elki 42 plays only at Prog 1 and runs quest:complete); client event scripts S4
-- 234_Elki_010EA017.txt (41 say #10650 on the Yes branch only, 42 say #10652) and 106_Monument_0106A28F.txt (11 print #7468 on
-- the Yes branch only); key item ids from res/key_items.lua (23 bouquet for the pioneers). The cutscene-ends bullet is the key
-- item handed out at the accept, so it is a note on step 1; the route bullets are notes on the monument.
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish after the
-- cutscene), so it is a reach only and the quest log's completed bit carries the last step.
return {
    title = 'Hearts of Mythril',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to elki in the bat'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 23, gained = true, why = 'bouquet for the pioneers obtained'},
            {t = 'ki_have', id = 23, have = true, why = 'bouquet for the pioneers held'},
            {t = 'chat', re = 'Look for an Omran%.', why = 'Elki 41, Yes branch only (say #10650)'},
            {t = 'chat', re = 'obtained key item: bouquet for the pioneers', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 234, event = 41, why = 'Elki 41 offered (its finish needs option 0)'}}},
        {id = 'n2', kind = 'note', with = 's1', at = {n = 2, fp = 'when the cutscene ends you will'}},
        {id = 'n3', kind = 'note', with = 's5', at = {n = 3, fp = 'head out to zegham hill in'}},
        {id = 'n4', kind = 'note', with = 's5', at = {n = 4, fp = 'it s pretty easy to go'}},
        {id = 's5', at = {n = 5, fp = 'touch the monument for an event'},
         done = {
            {t = 'chat', re = "There you see ten names, including that of Elki's great%-grandfather, Omran%.", why = 'Monument 11, Yes branch only (print #7468)'},
            {t = 'chat', re = 'As you lay down the bouquet for the pioneers', why = 'Monument 11, Yes branch only (print #7467)'},
            {t = 'ki', id = 23, gained = false, conf = 'inferred', why = 'bouquet for the pioneers laid down'},
         },
         reach = {{t = 'event', zone = 106, event = 11, why = 'Monument 11 offered (its finish needs option 0)'}}},
        {id = 's6', at = {n = 6, fp = 'after the event ends head back'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 234, event = 42, why = 'Elki 42: plays even when the reward item does not fit'},
            {t = 'chat', re = 'Thank you for your kindness%.', why = 'Elki 42 (say #10652)'},
         }},
    },
}
