-- Step progress for Regaining Trust (Jeuno quest 85). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names REGAINING_TRUST but has no script for it, and the client's event scripts carry no body for
-- Luto's or Monberaux's cutscenes (S4 244_Luto_Mewrilah_010F408C.txt and 244_Monberaux_010F4001.txt hold only other
-- quests' events) and nothing for the Giant Footprint or Ingaevon, so the only strong signals are the quest log's two bits.
-- The page's metadata gives Luto as the starting NPC and bullet 1 as the cutscene that begins the quest (current bit);
-- bullet 5 is the last two cutscenes and "completes the quest" (completed bit). No key item is involved. Bullets 2 to 4 (a
-- cutscene at Monberaux, the footprint, the Gigas fight) have no event, line or key item of their own and stay plain.
-- Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Regaining Trust',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to luto for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Luto, the cutscene that begins the quest)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to luto in upper jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the cutscene at Monberaux)'},
         }},
    },
}
