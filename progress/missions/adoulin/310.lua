-- Step progress for Anagnorisis (Seekers of Adoulin mission 4-5-1, mission page id 310). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/4_5_1_Anagnorisis.lua and the client script S4 257_Ploh_Trishbahk_0110108E. Two Ploh
-- Trishbahk (Eastern Adoulin 257) events complete the mission: 1544, the trade of the necklace ("Yes, this <item> does look to be
-- the keepsake they requested."), and 1553, a plain talk when no necklace is held ("Could this be the necklace you're referring
-- to?"). Event 1545 (a talk while holding the necklace without trading it: "I await your return.") is a reminder and proves
-- nothing, so the draft's 1545 and its line are dropped. The adoulin line has no completed set: `min = 311`. Bullet 2 repeats
-- that the trade completes the mission, so it is a note.
return {
    title = 'Anagnorisis',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 310}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade ploh trishbahk the necklace reward'},
         done = {
            {t = 'event', zone = 257, event = 1544, why = 'Ploh Trishbahk 1544: the necklace traded, finish completes the mission'},
            {t = 'chat', re = 'does look to be the keepsake they rrrequested', why = 'Ploh Trishbahk 1544 (say #9590)'},
            {t = 'event', zone = 257, event = 1553, why = 'Ploh Trishbahk 1553: talk without a necklace, finish completes the mission'},
            {t = 'chat', re = 'Could this be the necklace you.re rrreferring to', why = 'Ploh Trishbahk 1553 (say #9591)'},
            {t = 'mission', line = 'adoulin', min = 311, why = 'mission log: the line moved past Anagnorisis'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'trading the item completes the mission'}},
    },
}
