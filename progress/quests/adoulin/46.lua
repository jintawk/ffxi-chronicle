-- Step progress for Flavors of Our Lives (Adoulin quest 46). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Flavors_of_Our_Lives.lua (Berghent 80 offers it, and 81 after a refusal; the finish
-- needs option 1, so neither proves anything; the quest then runs on a Prog variable: Masad 83 plays at Prog 0 and sets Prog 1,
-- his 104 is the talk at Prog 1; Dewalt 85 plays at Prog 1 and sets Prog 2, his 105 is the talk at Prog 2 and 3; Chalvava 8 (Rala
-- Waterways) plays at Prog 2 and sets Prog 3, her 9 is the talk at Prog 3 without the Blightberry; the Harvesting Point hands
-- over the Blightberry (key item 2386) at Prog 3; Berghent 87 plays at Prog 3 with the Blightberry and runs quest:complete,
-- the reward being bayld, experience and a title, so it has no refusal; 88 is his line once completed; 82 is his reminder at
-- Prog 0 to 3 without the berry). Client event scripts S4 256_Masad_01100165.txt (104 say #8638), 256_Dewalt_011000BE.txt
-- (105 say #8640), 258_Chalvava_01102140.txt (9 say #8428), 256_Berghent_01100136.txt (82 say #8580, 88 say #8636); events 83,
-- 85, 8 and 87 are bare cutscenes. The page has no bullet for the offer, so the accepted bit and Berghent's reminder are only a
-- reach on bullet 1. The draft put the log's accepted bit and the 82 reminder on the last bullet and gave the whole quest a
-- silent_until; the log is flagged from the offer, and the last bullet is proved by 87 and the completed bit. Key item from
-- res/key_items.lua. Not repeatable.
return {
    title = 'Flavors of Our Lives',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to masad inside the mummers'},
         done = {
            {t = 'event', zone = 256, event = 83, why = 'Masad 83: only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 256, event = 104, why = 'Masad 104: his talk at Prog 1'},
            {t = 'chat', re = "If a particularly piquant fruit is what you're in search of", why = 'Masad 104 (say #8638)'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted (Berghent)'},
            {t = 'event', zone = 256, event = 82, why = 'Berghent 82: his reminder, only while accepted'},
            {t = 'chat', re = "Its peel's all lumpy and green to the point of inducing vomit", why = 'Berghent 82 (say #8580)'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to dewalt inside the couriers'},
         done = {
            {t = 'event', zone = 256, event = 85, why = 'Dewalt 85: only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 256, event = 105, why = 'Dewalt 105: his talk at Prog 2 and 3'},
            {t = 'chat', re = 'Researchers from the Civic Arboretum bought the total remaining stock of', why = 'Dewalt 105 (say #8640)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to rala waterways and talk'},
         done = {
            {t = 'event', zone = 258, event = 8, why = 'Chalvava 8: only at Prog 2, sets Prog 3'},
            {t = 'event', zone = 258, event = 9, why = 'Chalvava 9: her talk at Prog 3'},
            {t = 'chat', re = 'that badly, I guess I can let you in on a little secretaru', why = 'Chalvava 9 (say #8428)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to yahse hunting grounds and'},
         done = {
            {t = 'ki', id = 2386, gained = true, why = 'blightberry obtained at the Harvesting Point'},
            {t = 'ki_have', id = 2386, have = true, why = 'blightberry held'},
            {t = 'chat', re = 'obtained key item: blightberry', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to berghent for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 256, event = 87, why = 'Berghent 87: needs the Blightberry, runs quest:complete'},
            {t = 'event', zone = 256, event = 88, why = 'Berghent 88: his line once completed'},
            {t = 'chat', re = "I'ma head on over to that Arboretum and lend an old, wrinkly hand", why = 'Berghent 88 (say #8636)'},
         }},
    },
}
