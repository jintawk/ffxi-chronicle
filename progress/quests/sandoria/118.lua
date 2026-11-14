-- Step progress for Forest for the Trees (San d'Oria quest 118). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and the client event scripts have no Ramua, so there is no event or line to use.
-- Only the quest log bits and key item 1065 (timber survey checklist, res/key_items.lua; the page says Ramua gives it with
-- the Hatchet) are strong signals: bullet 1 is the accepted bit, bullet 2 the checklist, bullet 6 the completed bit. The
-- chat line for a logged item ("data was recorded on your checklist") is in no decoded text, so the logging bullet (3)
-- stays plain, as do the tips (4, 5, 7). Provenance is the wiki page and the log bits only: check it in game.
return {
    title = 'Forest for the Trees',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ramua in northern san'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'ramua will give you the timber'},
         done = {
            {t = 'ki', id = 1065, gained = true, why = 'timber survey checklist obtained'},
            {t = 'ki_have', id = 1065, have = true, why = 'timber survey checklist held'},
            {t = 'chat', re = 'obtained key item: timber survey checklist', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade these logs to ramua for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
