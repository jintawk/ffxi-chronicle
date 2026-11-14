-- Step progress for The Dismayed Customer (San d'Oria quest 6). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Dismayed_Customer.lua (Gulemont 605 option 0 begins the quest; one of
-- three ??? in West Ronfaure gives Gulemont's document, key item 129; Gulemont 607 completes it and takes the key item, 606
-- is his reminder); client event scripts S4 232_Gulemont_010E800B.txt (605 accept branch say #7519, 606 say #7520, 607 say
-- #7522); key item id from res/key_items.lua. Disagreements with the draft: the completing event 607 and the quest log
-- belong to the LAST bullet (n=7), not to "touch the ???" (n=6, which is the document's key item); "Ahhh, now I've gone and
-- done it" plays before the offer menu, so it does not prove acceptance. The three location bullets (n=3..5) are indented
-- sub-bullets with no checkbox and the travel bullet (n=2) has no signal of its own: left unlisted / a note.
return {
    title = 'The Dismayed Customer',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with gulemont to begin quest'},
         done = {
            {t = 'chat', re = "You'll go find it for me%? That's a relief%.", why = 'Gulemont 605, accepted (say #7519)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 232, event = 606, conf = 'inferred', why = 'Gulemont 606: reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 232, event = 605, why = 'Gulemont 605 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'travel to west ronfaure to locate'}},
        {id = 's6', at = {n = 6, fp = 'when you locate the touch it'},
         done = {
            {t = 'ki', id = 129, gained = true, why = "Gulemont's document obtained"},
            {t = 'ki_have', id = 129, have = true, why = "Gulemont's document held"},
            {t = 'chat', re = "obtained key item: gulemont's document", why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to gulemont and speak with'},
         done = {
            {t = 'event', zone = 232, event = 607, why = 'Gulemont 607'},
            {t = 'chat', re = "You've found it! The missing bond!", why = 'Gulemont 607 (say #7522)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 129, gained = false, conf = 'inferred', why = "Gulemont's document handed over"},
         }},
    },
}
