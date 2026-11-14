-- Step progress for Ode to the Serpents (Aht Urhgan quest 44). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Ode_to_the_Serpents.lua (Fari-Wari 882 begins the quest with no refusal and
-- gives Biyaada's letter, key item 895; while accepted Fari-Wari plays 891 until both When the Bow Breaks and Fist of the People
-- are completed, then 883, whose finish runs quest:complete and takes the letter). No client event script or text. Bullet 2 (the
-- Al Zahbi talks) and bullet 3 (the two other quests) have no event of this quest, so they are notes on the last step. The
-- reward item is not used. Not repeatable.
return {
    title = 'Ode to the Serpents',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to fari wari in aht'},
         done = {
            {t = 'event', zone = 50, event = 882, why = 'Fari-Wari 882: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 895, gained = true, why = "Biyaada's letter obtained"},
            {t = 'chat', re = "obtained key item: biyaada's letter", why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 891, why = 'Fari-Wari 891: his talk while accepted and the two quests are not both done'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'with the key item biyaada s'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'complete the quests when the bow'}},
        {id = 's4', at = {n = 4, fp = 'speak to fari wari to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 50, event = 883, why = 'Fari-Wari 883: both quests done, runs quest:complete'},
            {t = 'ki', id = 895, gained = false, conf = 'inferred', why = "Biyaada's letter handed over"},
         }},
    },
}
