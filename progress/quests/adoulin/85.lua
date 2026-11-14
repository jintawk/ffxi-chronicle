-- Step progress for Fertile Ground (Adoulin quest 85). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Western_Adoulin/npcs/Shipilolo.lua (2850 plays only while the quest is accepted and the
-- Bottle of fertilizer X is not held, and its finish gives that key item, with no refusal). LandSandBoat has no script for
-- Chalvava's start or the completion (Chalvava's client events 8, 9, 344 and others belong to Flavors of Our Lives and the
-- Seeds of Doubt missions), so the first and last steps rest on the quest log only: the current bit at the first talk (the page's
-- own note says Chalvava may need a second talk before she flags it, so it is inferred) and the completed bit at the last. The
-- reward Blightberry (key item 2386) is also what Flavors of Our Lives hands out, so it is not used. Client event script S4
-- 256_Shipilolo_0110010C.txt (2850 say #8106). Not repeatable.
return {
    title = 'Fertile Ground',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to chalvava to begin the'},
         done = {
            {t = 'quest', current = true, conf = 'inferred', why = 'quest log: accepted (Chalvava flags it; LandSandBoat has no script for her)'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to shipilolo in front of'},
         done = {
            {t = 'event', zone = 256, event = 2850, why = 'Shipilolo 2850: only while accepted and without the fertilizer'},
            {t = 'chat', re = 'No%? %.%.%.The Civic Arboretum sent you%?', why = 'Shipilolo 2850 (say #8106)'},
            {t = 'ki', id = 2263, gained = true, why = 'bottle of fertilizer X obtained'},
            {t = 'ki_have', id = 2263, have = true, why = 'bottle of fertilizer X held'},
            {t = 'chat', re = 'obtained key item: bottle of fertilizer x', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to chalvava for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
