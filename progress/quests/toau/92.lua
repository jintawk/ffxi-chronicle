-- Step progress for Promotion: Lance Corporal (Aht Urhgan quest 92). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Lance_Corporal.lua, client event scripts S4 050_Nafiwaa_01032075.txt
-- and 050_Abquhbah_0103208D.txt. Server stage by stage: Abquhbah 5030 begins the quest (no bullet names that talk, so it is
-- not used); stage 0: Nafiwaa 5035 gives the five empty test tubes (814-818), Abquhbah 5032; stages 1-2: the five Mythralline
-- Wellsprings (four in Wajaom Woodlands, one in Bhaflau Thickets, any order) turn each empty tube into its filled key item
-- (819-823), Nafiwaa 5036/5037 are her "collect water" talks, Abquhbah 5033 (so all four are proof the tubes were handed
-- out), Nafiwaa 5038 is the mixing minigame, offered once all five tubes are filled, with no text and a throw-out choice (so it
-- is a reach, and the accept leaves no marker); stage 3 (accepted mix, one game day wait): Nafiwaa 5039 and Abquhbah 5034 are
-- their talks (proof the mix was handed in), area trigger 5031 is the Abquhbah cutscene once the day has passed, whose finish
-- runs quest:complete and prints "has been promoted to Lance Corporal" (line 6690 of Aht_Urhgan_Whitegate/IDs.lua), except
-- when the reward item cannot be given (full bag), which replays it. The five-pond bullet is any order and part-way key items
-- prove nothing about the whole, so it is a branch whose key items are only reaches. The quality bullet is a note. Bullet 6 is
-- the choice inside the cutscene that finishes the quest. Not repeatable.
return {
    title = 'Promotion: Lance Corporal',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after accepting the quest talk to'},
         done = {
            {t = 'event', zone = 50, event = 5035, why = 'Nafiwaa 5035: hands over the five empty test tubes'},
            {t = 'ki', id = 814, gained = true, why = 'Empty test tube #1 obtained'},
            {t = 'chat', re = 'obtained key item: empty test tube', why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 5036, why = 'Nafiwaa 5036: her collect-water talk (only once the tubes are given)'},
            {t = 'chat', re = 'I would like you to use the test tubes', why = 'Nafiwaa 5036 (say #6560)'},
            {t = 'event', zone = 50, event = 5037, why = 'Nafiwaa 5037: her partly-collected talk'},
            {t = 'chat', re = 'I see you have collected', why = 'Nafiwaa 5037 (say #6563)'},
            {t = 'event', zone = 50, event = 5033, why = 'Abquhbah 5033: his talk while the tubes are out'},
            {t = 'chat', re = 'Please help Falzum through this', why = 'Abquhbah 5033 (say #6564)'},
         }},
        {id = 's2', kind = 'branch', at = {n = 2, fp = 'after receiving the 5 test tube'},
         reach = {
            {t = 'ki', id = 819, gained = true, why = 'Test tube #1 filled'},
            {t = 'ki', id = 820, gained = true, why = 'Test tube #2 filled'},
            {t = 'ki', id = 821, gained = true, why = 'Test tube #3 filled'},
            {t = 'ki', id = 822, gained = true, why = 'Test tube #4 filled'},
            {t = 'ki', id = 823, gained = true, why = 'Test tube #5 filled'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to nafiwaa for a cutscene'},
         done = {
            {t = 'event', zone = 50, event = 5039, why = 'Nafiwaa 5039: her talk once the mix is handed in'},
            {t = 'chat', re = "I will contact Salaheem's Sentinels", why = 'Nafiwaa 5039 (say #6620)'},
            {t = 'event', zone = 50, event = 5034, why = 'Abquhbah 5034: his talk once the mix is handed in'},
            {t = 'chat', re = "Results from the Alchemists' Guild%?", why = 'Abquhbah 5034 (say #6621)'},
         },
         reach = {{t = 'event', zone = 50, event = 5038, after = 's1', why = 'Nafiwaa 5038: the mixing minigame (a throw-out replays it)'}}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'the quality of the mixture determines'}},
        {id = 's5', at = {n = 5, fp = 'wait a game day and zone'},
         done = {
            {t = 'event', zone = 50, event = 5031, why = 'Abquhbah 5031: the cutscene after the wait'},
         }},
        {id = 's6', at = {n = 6, fp = 'choose helping his fellow mercenaries to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'has been promoted to lance corporal', why = 'promotion message (IDs.lua 6690)'},
         }},
    },
}
