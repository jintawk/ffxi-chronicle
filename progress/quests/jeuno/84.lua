-- Step progress for Chameleon Capers (Jeuno quest 84). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names CHAMELEON_CAPERS but has no script for it and the client's event scripts carry no body for
-- Luto's, Muhoho's or Gelzerio's cutscenes (Luto's events are bare, Muhoho and Gelzerio are not in S4 at all; Chamama's
-- 238_Chamama_010EE057.txt has no reversion dust event), so the only strong signals are the quest log and the key item.
-- The page's own metadata gives Luto as the starting NPC and bullet 1 as the cutscene that begins the quest, so the quest
-- log's current bit proves bullet 1. Key item 728 (jar of reversion dust, a permanent key item from this quest only, res/
-- key_items.lua) is handed over by Chamama in bullet 4 and proves it. Bullet 6 ends the quest ("a final cutscene that ends
-- the quest"), so the completed bit proves it. The draft put the completion on the key item bullet (a guess); the bullets
-- that are cutscenes with no event or line of their own (2, 3, 5) and the closing dialogue (7 to 9) stay plain bullets.
-- Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Chameleon Capers',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to luto for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Luto, the cutscene that begins the quest)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to windurst waters north map'},
         done = {
            {t = 'ki', id = 728, gained = true, why = 'jar of reversion dust obtained from Chamama'},
            {t = 'ki_have', id = 728, have = true, why = 'jar of reversion dust held'},
         }},
        {id = 's6', at = {n = 6, fp = 'once you defeat the magic pot'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the final cutscene)'},
         }},
    },
}
