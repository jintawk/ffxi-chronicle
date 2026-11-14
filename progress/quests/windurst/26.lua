-- Step progress for Rock Racketeer (Windurst quest 26). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Rock_Racketeer.lua (Nanaa Mihgo 93 is a menu and only option 1 begins the quest
-- and gives key item 122, so it is a reach; 94 and 95 are her talks at Prog 0, accepted-only; Ardea 261 is a Sell it for 10 gil?
-- menu whose No branch plays the same event, so it is a reach, while 262 and 263 play only after the sale; Nanaa Mihgo 98 plays
-- at Prog 1 and 99 at Prog 2; Varun 100 and 101 play only at Prog 2 and 100 is not required; the Palborough Mythril Seam plays
-- event 51 and gives the Sharp Stone only from Prog 2 with a free slot; Varun 102 takes the Sharp Stone and runs quest:complete,
-- which has fame only, no item reward; 103 is his talk once completed); client event scripts S4 241_Nanaa_Mihgo_010F1072.txt
-- (94 say #7638, 99 #7647), 235_Ardea_010EB012.txt (262 #7676, 263 #7677), 241_Varun_010F1098.txt (101 #7654, 102 #7657).
-- Key item 122 from res/key_items.lua, item 598 (Sharp Stone) from res/items.lua. The draft's mining bullet (n=6) is a real step:
-- the zone's own "Obtained:" line and event 51 prove it; the pickaxe bullet leads into it. The quest log is set at s1.
return {
    title = 'Rock Racketeer',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nanaa mihgo to receive'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 122, gained = true, why = 'sharp gray stone obtained'},
            {t = 'ki_have', id = 122, have = true, why = 'sharp gray stone held'},
            {t = 'chat', re = 'obtained key item: sharp gray stone', why = 'chat: key item obtained'},
            {t = 'event', zone = 241, event = 94, why = 'Nanaa Mihgo 94: only while accepted'},
            {t = 'chat', re = "Head over to the Goldsmiths' Guild in Bastok and ask them what that stone is%.", why = 'Nanaa Mihgo 94 (say #7638)'},
         },
         reach = {{t = 'event', zone = 241, event = 93, why = 'Nanaa Mihgo 93 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to ardea bastok markets h'},
         reach = {{t = 'event', zone = 235, event = 261, why = 'Ardea 261 offered (the No branch plays the same event)'}},
         done = {
            {t = 'event', zone = 235, event = 262, why = 'Ardea 262: only after the sale'},
            {t = 'chat', re = 'Are you going back to Windurst%?', why = 'Ardea 262 (say #7676)'},
            {t = 'event', zone = 235, event = 263, why = 'Ardea 263: only after the sale, from Prog 2'},
            {t = 'chat', re = 'The stone you sold me the other day', why = 'Ardea 263 (say #7677)'},
            {t = 'ki', id = 122, gained = false, after = 's1', conf = 'inferred', why = 'sharp gray stone handed over'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to nanaa mihgo'},
         done = {
            {t = 'event', zone = 241, event = 98, why = 'Nanaa Mihgo 98: only at Prog 1, after the sale'},
            {t = 'event', zone = 241, event = 99, why = 'Nanaa Mihgo 99: only at Prog 2, after 98'},
            {t = 'chat', re = "Grrr%.%.%. If you hadn't sold it off", why = 'Nanaa Mihgo 99 (say #7647)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to varun windurst woods h'},
         done = {
            {t = 'event', zone = 241, event = 100, why = 'Varun 100: only at Prog 2'},
            {t = 'event', zone = 241, event = 101, why = 'Varun 101: only at Prog 2'},
            {t = 'chat', re = "I spread the word that I'd pay a reward", why = 'Varun 101 (say #7654)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'obtain some pickaxes then head to'}},
        {id = 's6', at = {n = 6, fp = 'at i 9 you will find'},
         done = {
            {t = 'event', zone = 143, event = 51, why = 'Mythril Seam 51: the Sharp Stone found (only from Prog 2, with a free slot)'},
            {t = 'chat', re = 'Obtained: .-Sharp stone', why = 'ITEM_OBTAINED, the seam is the only source (Mythril_Seam.lua:40)'},
            {t = 'item', id = 598, gained = true, conf = 'inferred', why = 'Sharp Stone gained (items can come from elsewhere)'},
         }},
        {id = 's7', at = {n = 7, fp = 'trade the sharp stone to varun'},
         done = {
            {t = 'event', zone = 241, event = 102, why = 'Varun 102: the Sharp Stone accepted, completes'},
            {t = 'chat', re = 'How can I ever repay you%?', why = 'Varun 102 (say #7657)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 103, why = 'Varun 103: his talk once completed'},
         }},
    },
}
