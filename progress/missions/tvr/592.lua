-- Step progress for Duke Alloces's Decision (The Voracious Resurgence, page id 592). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's scripts/missions/tvr/10_5_Duke_Allocess_Decision.lua is a stub, so no scene is traced. The page ties one key
-- item to its last bullet and says it is lost there: "despairing psyche" (res/key_items.lua id 3333) goes with the gil reward.
-- The draft had it as a gain on bullet 5, which is wrong: the page never says where it is gained, and Odin's Eye (602) hands it out again.
-- So the proof is its loss at the final cutscene, plus the tvr line moving to 602 (Odin's Eye), which has no completed set. Bullets 1, 3
-- and 4 are cutscenes and the BCNM entry with no signal of their own; they stay plain bullets.
return {
    title = "Duke Alloces's Decision",
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 592, max = 601}},
    steps = {
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'return to castle zvahl keep and'}},
        {id = 's5', at = {n = 5, fp = 'return to and interact with the'},
         done = {
            {t = 'ki', id = 3333, gained = false, why = 'despairing psyche lost at the final Heroes\' Gambit cutscene (the page says so)'},
            {t = 'mission', line = 'tvr', min = 602, why = 'mission log: the line moved past Duke Alloces\'s Decision'},
         }},
    },
}
