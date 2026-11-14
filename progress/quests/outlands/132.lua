-- Step progress for Stop Your Whining (Outlands quest 132). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Stop_Your_Whining.lua (Washu 21 is the offer; option 1 begins the quest and gives the
-- Empty Barrel, key item 260; while accepted his talk is 22 with the empty barrel held and 23 with the Barrel of Opo-Opo brew held;
-- the Yhoator Jungle ??? swaps the empty barrel for the brew (key item 261) with the zone text 7702, and says 7703 if it is held
-- already; 23's finish runs quest:complete and only then takes the brew; 24 plays once completed). Client event script S4
-- 252_Washu_010FC017.txt (21 say #10183 on the Yes branch, 22 say #10186, 23 say #10188). Key items 260 and 261 from res/key_items.lua.
-- The travel and Washu-introduction bullets (n=1, n=2) and the ??? search bullet (n=4) are notes on the step they lead into. Event 23
-- also plays when the bag is full (the Hojo: Ichi scroll is not given and the quest stays open), so it is reach for the last step and
-- the log's completed bit or the brew leaving the key items proves it. Not repeatable.
return {
    title = 'Stop Your Whining',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'travel to norg and enter the'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'talk to washu'}},
        {id = 's3', at = {n = 3, fp = 'washu will give you an empty'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Washu 21, option 1)'},
            {t = 'ki', id = 260, gained = true, why = 'empty barrel obtained'},
            {t = 'ki_have', id = 260, have = true, why = 'empty barrel held'},
            {t = 'chat', re = "I can't thank you enough!", why = 'Washu 21, Yes branch only (say #10183)'},
            {t = 'chat', re = 'obtained key item: empty barrel', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 22, conf = 'inferred', why = 'Washu 22: his talk while the empty barrel is held'},
            {t = 'chat', re = "The Opo%-opos don't hide their brew in the Yuhtunga Jungle", conf = 'inferred', why = 'Washu 22 (say #10186)'},
         },
         reach = {{t = 'event', zone = 252, event = 21, why = 'Washu 21 offered (its finish needs option 1)'}}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'you will need to examine a'}},
        {id = 's5', at = {n = 5, fp = 'once you find the the empty'},
         done = {
            {t = 'ki', id = 261, gained = true, why = 'barrel of Opo-Opo brew obtained'},
            {t = 'ki_have', id = 261, have = true, why = 'barrel of Opo-Opo brew held'},
            {t = 'chat', re = 'The hole in this tree is filled with a sweet%-smelling liquid%.', why = 'Yhoator Jungle text 7702: only with the empty barrel held'},
            {t = 'chat', re = 'obtained key item: barrel of opo%-opo brew', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 23, conf = 'inferred', why = 'Washu 23: his talk while the brew is held'},
            {t = 'chat', re = 'Mmm%-mmm! The color! The aroma!', conf = 'inferred', why = 'Washu 23 (say #10188)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to washu to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 261, gained = false, why = 'barrel of Opo-Opo brew taken, only after the quest was completed'},
         },
         reach = {
            {t = 'event', zone = 252, event = 23, after = 's5', why = 'Washu 23 (also plays when the bag is full: nothing is given)'},
            {t = 'chat', re = 'Mmm%-mmm! The color! The aroma!', after = 's5', why = 'Washu 23 (say #10188)'},
         }},
    },
}
