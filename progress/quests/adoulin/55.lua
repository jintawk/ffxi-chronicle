-- Step progress for I'm on a Boat (Adoulin quest 55). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Im_on_a_Boat.lua (Choubollet 2561 is shown while the quest is available and
-- quest:begin runs on its finish with no option, so the log flags the quest at the first bullet; while accepted his talk is 2562
-- without the Watercraft key item, 2577 with it, and 2563 after casting off from Castoff Point 5 (Prog 2); trading exactly 3
-- Dhalmel Leather, 1 Umbril Ooze and 1 Twitherym Scale plays 2576 and hands over the Watercraft (key item 2167), and any other
-- trade plays nothing; 2563 runs quest:complete, which takes the Watercraft and gives "Watercrafting" (2205, a reward key item,
-- so supporting only). Castoff Point 4 and 5 play event 19 with a cast-off option that can be declined, so no step uses it:
-- bullets 3 and 4 (the two crossings) are notes on the return. The draft put 2563 on the trade bullet; it completes the quest
-- and proves the last bullet. 2562 only plays while the trade is still to do, so it is a reach on bullet 2. Client event script
-- S4 262_Choubollet_01106232.txt (2561 say #7525, 2562 say #7529, 2576 say #7530, 2563 say #7537).
return {
    title = "I'm on a Boat",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to choubollet at the frontier'},
         done = {
            {t = 'event', zone = 262, event = 2561, why = 'Choubollet 2561: the offer, begins the quest with no option'},
            {t = 'chat', re = 'You are a pioneer, are you not%?', why = 'Choubollet 2561 (say #7525)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'collect the items and trade them'},
         done = {
            {t = 'event', zone = 262, event = 2576, why = 'Choubollet 2576: the exact trade accepted'},
            {t = 'chat', re = 'Finished already%? That was quicker than I had anticipated%.', why = 'Choubollet 2576 (say #7530)'},
            {t = 'ki', id = 2167, gained = true, why = 'Watercraft obtained'},
            {t = 'ki_have', id = 2167, have = true, why = 'Watercraft held'},
            {t = 'chat', re = 'obtained key item: watercraft', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'event', zone = 262, event = 2562, why = 'Choubollet 2562: his talk while accepted without the Watercraft'},
            {t = 'chat', re = 'Do this for me, and I will construct a boat the likes of which you have never seen!', why = 'Choubollet 2562 (say #7529)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to the south side of'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'go to the west side of'}},
        {id = 's5', at = {n = 5, fp = 'head north from the second landing'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 262, event = 2563, why = 'Choubollet 2563: runs quest:complete'},
            {t = 'chat', re = 'Boating is not merely about paddling, but also about controlling your center of gravity so as not to capsize%.', why = 'Choubollet 2563 (say #7537)'},
            {t = 'ki', id = 2167, gained = false, after = 's2', why = 'Watercraft taken by the completing event'},
         }},
    },
}
