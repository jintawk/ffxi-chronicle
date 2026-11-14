-- Step progress for Can Cardians Cry? (Windurst quest 47). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Apururu.lua (319 begins the quest and addQuest runs on its finish;
-- 320 is the reminder while accepted; the trade of a Bruised Starfruit is event 325, which only plays when the quest is
-- accepted and the trade holds the starfruit, and its finish completes the quest with gil and a title only, so it cannot
-- be refused by a full bag; 330 is the dialogue after completion); client event scripts S4 241_Apururu_010F1014.txt
-- (319 say_as #8188, 320 say #8199; 325 has no dialogue, so only the event and the quest log prove it).
-- The starfruit hunt (n=2) has no strong signal (the item is also sold at the Auction House) and is a note on the trade; the
-- last bullet is a remark about repeat trades, which leave no event of their own, so it is a note too. No `repeatable`
-- entry: a repeat plays no event or accept that could open a second run.
return {
    title = 'Can Cardians Cry?',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to apururu to begin this'},
         done = {
            {t = 'event', zone = 241, event = 319, why = 'Apururu 319: begins the quest'},
            {t = 'chat', re = 'Queen hAd a hap%-py lifE', why = 'Apururu 319 (say_as #8188)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 320, conf = 'inferred', why = 'Apururu 320: reminder, only once accepted'},
            {t = 'chat', re = "If she's on her way here too, then that can only mean she is seriously hurt as well%.", conf = 'inferred', why = 'Apururu 320 (say #8199)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'kill cursed weapons in xarcabard until'}},
        {id = 's3', at = {n = 3, fp = 'trade the bruised starfruit to apururu'},
         done = {
            {t = 'event', zone = 241, event = 325, why = 'Apururu 325: the starfruit accepted'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 330, conf = 'inferred', why = 'Apururu 330: dialogue only once completed'},
            {t = 'chat', re = 'Cardians are life forms born by borrowing the power of the stars%.', conf = 'inferred', why = 'Apururu 330 (say #8236)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'trading a bruised starfruit to apururu'}},
    },
}
