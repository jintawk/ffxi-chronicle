-- Step progress for A Test of True Love (Bastok quest 62). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/A_Test_of_True_Love.lua (Carmelo 270 begins the quest at its finish; the three
-- page key items come from Treasure Chests with no event of their own the client keeps; Carmelo 272 plays only with all three
-- pages held (271 is the "not yet" talk, a refusal, so it proves nothing); 273 is the must-zone echo, 274 the closing talk after
-- zoning, which completes the quest and takes the pages); client event script S4 236_Carmelo_010EC00C.txt (270, 272 and 274
-- are bare; 273 say #8768). The draft put Carmelo 272 on the opening bullet; it is the hand-in of bullet 7. The three
-- indented chest bullets (n=4 to 6) are not steps, so ids s4 to s6 are unused; the log entry exists from s2.
return {
    title = 'A Test of True Love',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after completing love and ice'}},
        {id = 's2', at = {n = 2, fp = 'speak with carmelo to begin quest'},
         done = {
            {t = 'event', zone = 236, event = 270, why = 'Carmelo 270: the quest offered and begun at its finish'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'travel to the following locations and'}},
        {id = 's7', at = {n = 7, fp = 'return to bastok and speak with'},
         done = {
            {t = 'event', zone = 236, event = 272, why = 'Carmelo 272: plays only with all three pages held'},
            {t = 'event', zone = 236, event = 273, conf = 'inferred', why = 'Carmelo 273: the must-zone echo, only after 272'},
            {t = 'chat', re = 'I apologize, but the translation will require more time%.', conf = 'inferred', why = 'Carmelo 273 (say #8768)'},
         }},
        {id = 's8', at = {n = 8, fp = 'after the conversation zone out then'},
         done = {
            {t = 'event', zone = 236, event = 274, why = 'Carmelo 274: the closing talk, completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
