-- Step progress for Love and Ice (Bastok quest 43). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Love_and_Ice.lua (Carmelo 185 begins the quest and gives Carmelo's song sheet
-- on finish; the refusal for a player without The Siren's Tear or rank 5 is event 187, which proves nothing; the Mirror Pond
-- in Beaucedine Glacier plays event 100 only with the song sheet held and takes it on finish; Carmelo 186 plays only without
-- the sheet and runs quest:complete); client event script S4 236_Carmelo_010EC00C.txt (185 say #7657, 186 say #7666); key item
-- ids from res/key_items.lua (163 Carmelo's song sheet). The first bullet (examine the Carrier pigeon letter) leaves no trace
-- the client can see, so it is not mapped. Event 100 has no decoded client script (LandSandBoat only), so the loss of the song
-- sheet is the lasting proof of the Mirror Pond step. The last step rests on the quest log: 186 also plays when the reward
-- item (Lamia Harp) cannot be given, so it is `reach` only. The draft made that bullet a note; it is a real step. Not repeatable.
return {
    title = 'Love and Ice',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'speak with carmelo inside the steaming'},
         done = {
            {t = 'event', zone = 236, event = 185, why = 'Carmelo 185: the quest begun'},
            {t = 'chat', re = 'I met her on the shores of the Gustaberg river%.', why = 'Carmelo 185 (say #7657)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 163, gained = true, why = "Carmelo's song sheet obtained"},
            {t = 'ki_have', id = 163, have = true, why = "Carmelo's song sheet held"},
            {t = 'chat', re = "obtained key item: carmelo's song sheet", why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to g 10 in beaucedine'},
         done = {
            {t = 'event', zone = 111, event = 100, why = 'Mirror Pond 100: the song sheet put in the pond'},
            {t = 'ki', id = 163, gained = false, after = 's2', why = "Carmelo's song sheet taken (the Mirror Pond)"},
         }},
        {id = 's4', at = {n = 4, fp = 'after the cutscene return to bastok'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 236, event = 186, why = 'Carmelo 186: plays even when the Lamia Harp does not fit, so it is not proof'},
                  {t = 'chat', re = 'Yes, I would have sacrificed everything to be with her%.', why = 'Carmelo 186 (say #7666)'}}},
    },
}
