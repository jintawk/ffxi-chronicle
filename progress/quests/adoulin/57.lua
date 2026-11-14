-- Step progress for Hide and Go Peak (Adoulin quest 57). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Hide_and_Go_Peak.lua (Toppled Tree 3 is shown while the quest is available and
-- quest:begin runs on its finish with no option; while accepted his talk is 4 at Prog 0, 5 at Prog 1 and 6 at Prog 2. The Velkk
-- Cache gives the Large strip of Velkk hide (key item 2387) and sets Prog 1; event 5 takes it and sets Prog 2; the Scalable
-- Area (target 2) plays event 7 only at Prog 2, gives the Pair of Velkk Gloves and Climbing and runs quest:complete. So the
-- completed bit belongs to the vine cutscene, bullet 4, not to the hand-in at bullet 3 as the draft had it. The "Demolishing"
-- key item the draft used on bullet 2 is the prerequisite of an earlier quest and says nothing here. The log is flagged at the
-- first bullet, so it is not silent. Client event script S4 266_Toppled_Tree_0110A1AD.txt (3 say #7737, 4 say #7747, 5 say
-- #7751, 6 say #7757); event 7 is the Scalable Area's and has no client text.
return {
    title = 'Hide and Go Peak',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to toppled tree at the'},
         done = {
            {t = 'event', zone = 266, event = 3, why = 'Toppled Tree 3: the offer, begins the quest with no option'},
            {t = 'chat', re = "Hold there, pioneer%-%-I'm in need of your aid%.", why = 'Toppled Tree 3 (say #7737)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'travel to the lower floor of'},
         done = {
            {t = 'ki', id = 2387, gained = true, why = 'Large strip of Velkk hide obtained at the Velkk Cache'},
            {t = 'ki_have', id = 2387, have = true, why = 'Large strip of Velkk hide held'},
            {t = 'chat', re = 'obtained key item: large strip of velkk hide', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'event', zone = 266, event = 4, why = 'Toppled Tree 4: his talk at Prog 0, before the hide'},
            {t = 'chat', re = 'The Velkk process most of their leather in an encampment to the southwest%.', why = 'Toppled Tree 4 (say #7747)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to toppled tree at m'},
         done = {
            {t = 'event', zone = 266, event = 5, why = 'Toppled Tree 5: plays only at Prog 1 with the hide in hand, takes it'},
            {t = 'chat', re = "You're back! Did you get what I asked for%?", why = 'Toppled Tree 5 (say #7751)'},
            {t = 'ki', id = 2387, gained = false, after = 's2', why = 'Large strip of Velkk hide handed over'},
         },
         reach = {
            {t = 'event', zone = 266, event = 6, why = 'Toppled Tree 6: his talk at Prog 2, after the hand-in'},
            {t = 'chat', re = "I'm going to try my hand at climbing the ivy again now that I can make those gloves%.", why = 'Toppled Tree 6 (say #7757)'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel slightly west of toppled tree'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 266, event = 7, why = 'Scalable Area 2 event 7: plays only at Prog 2, runs quest:complete'},
         }},
    },
}
