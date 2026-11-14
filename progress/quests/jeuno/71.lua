-- Step progress for Hook, Line, and Sinker (Jeuno quest 71). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Hook_Line_and_Sinker.lua (Omer 10040 is a plain cutscene whose finish begins the
-- quest; 10041 is his talk while accepted; trading exactly the Egret Fishing Rod is 10042, which runs quest:complete and pays
-- 3000 gil, no reward item). Client event script S4 245_Omer_010F5033.txt (10041 say #8890 or #8892, by P0). Bullet 2 (the rod
-- drops from a fished-up Kraken) is a note on the trade, as is the FPS note (bullet 4). Not repeatable. The quest log is set at
-- s1, so it is not silent.
return {
    title = 'Hook, Line, and Sinker',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to omer to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 245, event = 10040, why = 'Omer 10040: the cutscene that begins the quest'},
            {t = 'event', zone = 245, event = 10041, why = 'Omer 10041: his talk, only while accepted'},
            {t = 'chat', re = 'That girl said a monster she had fished up on Qufim Island took my', why = 'Omer 10041 (say #8890)'},
            {t = 'chat', re = 'She probably just sold my poor', why = 'Omer 10041 (say #8892)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the item omer asks for drops'}},
        {id = 's3', at = {n = 3, fp = 'return the fishing rod to omer'},
         done = {
            {t = 'event', zone = 245, event = 10042, why = 'Omer 10042: the exact rod traded, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'the game will freeze on the'}},
    },
}
