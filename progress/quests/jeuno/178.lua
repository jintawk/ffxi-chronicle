-- Step progress for To Kill Mocking Birds (Jeuno quest 178). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for the quest (scripts/globals/quests.lua names no entry for 178) and the client's
-- event scripts have no body for Nantoto (her events 20035 and 20047 appear only in S4/param_uses_all.json, shared by her
-- Records of Eminence quests, with no text that names this quest). The RoE objective itself has no key item, event or line
-- that is specific to it, and the telepoint or kill credit is not the quest. Only the quest log's own bits are used: the
-- current bit (Nantoto gives the quest, bullet 1) and the completed bit (the report back to Nantoto, bullet 4). The kill is not tracked; bullets 5 and 6 (the extra quests) are not steps.
-- Not repeatable (page meta).
return {
    title = 'To Kill Mocking Birds',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to nantoto at h 8'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Nantoto)'},
         }},
        {id = 's2', at = {n = 4, fp = 'return to nantoto for a cutscene'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the report back to Nantoto)'},
         }},
    },
}
