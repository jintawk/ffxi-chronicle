-- Step progress for Father Figure (Bastok quest 29). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Father_Figure.lua (Michea 240 is a plain progress event that begins the quest
-- with no option test; Michea 241 plays only for a trade of exactly one Silver Ingot and completes); client event script S4
-- 235_Michea_010EB02C.txt (240 say #7622, 241 say #7626). The ingot bullet is a note on the trade it feeds: the ingot can be
-- bought or crafted before the quest starts. Disagreement with the draft: the note leads into bullet 3, not bullet 2, and the
-- completion gets its dialogue line.
return {
    title = 'Father Figure',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'obtain a silver ingot from auction'}},
        {id = 's2', at = {n = 2, fp = 'speak to michea to start quest'},
         done = {
            {t = 'event', zone = 235, event = 240, why = 'Michea 240: begins the quest'},
            {t = 'chat', re = 'Hello%. Do you have time%? I need your help%.', why = 'Michea 240 (say #7622)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'when the cutscene ends trade her'},
         done = {
            {t = 'event', zone = 235, event = 241, why = 'Michea 241: the Silver Ingot accepted, completes'},
            {t = 'chat', re = "It isn't much, but I want you to have this%.", why = 'Michea 241 (say #7626)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
