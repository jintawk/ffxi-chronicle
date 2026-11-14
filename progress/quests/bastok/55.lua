-- Step progress for The Talekeeper's Truth (Bastok quest 55). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Deidogg's second talk (s2, event 161 begins the quest), so Phara's talk is seen through its
-- event and dialogue only.
-- Evidence: LandSandBoat scripts/quests/bastok/WAR_AF2_The_Talekeepers_Truth.lua (Phara 154 sets Prog 1; Deidogg 160 at Prog 1
-- sets Prog 2; Deidogg 161 at Prog 2 begins the quest; 162 is the egg trade, 163 the echo talk at Prog 1, 164 the skin trade,
-- 165 the reward after a Vana'diel day and completes, 166 is the waiting line at Prog 2 and the line after completion); client
-- event script S4 234_Phara_010EA06B.txt (154 say #11049) and 234_Deidogg_010EA003.txt (160 say #11053, 163 say #11080, 165 say
-- #11095; 161, 162 and 164 are bare). Deidogg 160 is the first of the two talks, so it only reaches s2. Deidogg 166 is not
-- bound to bullet 8 (it plays while waiting), so it is an inferred mark on the skin trade. Repeatable after a Memory reset: the
-- restart is the next 154.
return {
    title = "The Talekeeper's Truth",
    completes = 's8',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to phara in bastok mines'},
         done = {
            {t = 'event', zone = 234, event = 154, why = 'Phara 154'},
            {t = 'chat', re = 'So, you took the sword to my grandson%?', why = 'Phara 154 (say #11049)'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to deidogg h 6 bastok'},
         done = {
            {t = 'event', zone = 234, event = 161, why = 'Deidogg 161: the second talk begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted (Deidogg 161 begins the quest)'},
         },
         reach = {
            {t = 'event', zone = 234, event = 160, why = 'Deidogg 160: the first talk'},
            {t = 'chat', re = "What do you think you're looking at%?", why = 'Deidogg 160 (say #11053)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'go palborough mines and work your'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'examine it to spawn ni ghu'}},
        {id = 's5', at = {n = 5, fp = 'return to bastok and trade the'},
         done = {
            {t = 'event', zone = 234, event = 162, why = 'Deidogg 162: the egg accepted'},
            {t = 'event', zone = 234, event = 163, conf = 'inferred', why = 'Deidogg 163: the echo talk, only after the egg'},
            {t = 'chat', re = "I can't%.%.%. Why would he%.%.%.", conf = 'inferred', why = 'Deidogg 163 (say #11080)'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'go to castle oztroja and kill'}},
        {id = 's7', at = {n = 7, fp = 'return to bastok again and trade'},
         done = {
            {t = 'event', zone = 234, event = 164, why = 'Deidogg 164: the skin accepted'},
            {t = 'event', zone = 234, event = 166, conf = 'inferred', why = 'Deidogg 166: the waiting line, only after the skin'},
         }},
        {id = 's8', at = {n = 8, fp = 'wait a game day after clock'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 234, event = 165, why = 'Deidogg 165: the reward talk (a full bag plays it too, no completion)'},
            {t = 'chat', re = "I've finished the greaves%.", why = 'Deidogg 165 (say #11095)'},
         }},
    },
}
