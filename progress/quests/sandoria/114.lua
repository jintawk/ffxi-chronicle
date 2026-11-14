-- Step progress for Atelloune's Lament (San d'Oria quest 114). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Atellounes_Lament.lua (Atelloune 890 is a cutscene with no choice and its
-- finish begins the quest; 892 is her accepted-state talk; trading exactly one Ladybug Wing plays 891, whose finish runs
-- quest:complete (it also gives the Trainee Gloves) and only then confirms the trade); client event script S4
-- 230_Atelloune_010E613A.txt (890 say #13415, 892 #13430, 891 #13434). Event 891 and its lines play even when the gloves do
-- not fit and the quest is then not completed, so they are `reach`; the completed bit proves the last bullet.
return {
    title = "Atelloune's Lament",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to atelloune in southern san'},
         done = {
            {t = 'event', zone = 230, event = 890, why = 'Atelloune 890: the start'},
            {t = 'chat', re = 'Hello, there%. Say, if you have some time would you mind lending me an ear%?', why = 'Atelloune 890 (say #13415)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 892, conf = 'inferred', why = 'Atelloune 892: accepted-state talk'},
            {t = 'chat', re = "I believe that there must still be some ladybugs out there somewhere in Vana'diel!", conf = 'inferred', why = 'Atelloune 892 (say #13430)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade her a ladybug wing for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 891, why = 'Atelloune 891: plays even when the Trainee Gloves do not fit, so it is not proof'}}},
    },
}
