-- Step progress for Arciela's Missive (Seekers of Adoulin mission 5-1-1, mission page id 328). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_1_1_Arcielas_Missive.lua. The Sunrise Beacon (Western Adoulin 256) plays 179 only
-- once the Hastily scribbled note (key item 2621, temporary, the last mission's reward) has been read, and its finish takes the
-- note and completes the mission, so 179, the note leaving and the line moving on prove bullet 2. Reading the note (bullet 1) is
-- silent, so it is a note on bullet 2; Ploh Trishbahk's 1554 only records that he was spoken to and Levil's 183 and 40 are
-- reminders. The adoulin line has no completed set: `min = 329`. No client script is decoded for 179.
return {
    title = "Arciela's Missive",
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 328}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'go to your temporary key items'}},
        {id = 's2', at = {n = 2, fp = 'go to the waterfront in western'},
         done = {
            {t = 'event', zone = 256, event = 179, why = 'Sunrise Beacon 179: only with the note read, finish completes the mission'},
            {t = 'ki', id = 2621, gained = false, why = 'Hastily scribbled note handed over'},
            {t = 'mission', line = 'adoulin', min = 329, why = "mission log: the line moved past Arciela's Missive"},
         }},
    },
}
