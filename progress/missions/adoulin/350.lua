-- Step progress for Blood for Blood (Seekers of Adoulin mission, page id 350). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_3_3_Blood_for_Blood.lua. The Ominous Postern (Ra'Kaznar Turris 277) plays 2 as a plain
-- progress event while the mission is current, with no refusal path, and its finish completes the mission. The adoulin line has no
-- completed set (packet value = page id), so the completion is `min = 351`, not the draft's `completed = true`.
return {
    title = 'Blood for Blood',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 350}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the bottom of ra'},
         done = {
            {t = 'event', zone = 277, event = 2, why = 'Ominous Postern 2, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 351, why = 'mission log: the line moved past Blood for Blood'},
         }},
    },
}
