-- Step progress for Looking For Leads (Seekers of Adoulin, mission page id 232). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_5_3_Looking_for_Leads.lua. The trigger area at the Scouts' Coalition (Eastern
-- Adoulin 257, area 3) plays 1517 only while this mission is current, and its finish completes the mission and gives the
-- Tintinnabulum. That key item is a reward (it can already be owned), so it is not used; Levil's 144 is a reminder. The adoulin
-- line has no completed set: `min = 233`. No client script is decoded for 1517.
return {
    title = 'Looking For Leads',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 232}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach wegellion in the scouts coalition'},
         done = {
            {t = 'event', zone = 257, event = 1517, why = "Eastern Adoulin Scouts' Coalition area 1517, finish completes the mission"},
            {t = 'mission', line = 'adoulin', min = 233, why = 'mission log: the line moved past Looking For Leads'},
         }},
    },
}
