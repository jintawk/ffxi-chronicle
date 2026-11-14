-- Step progress for Odin's Eye (The Voracious Resurgence, page id 602). Data only; see progress/missions/rov/144.lua for the format.
-- Evidence: LandSandBoat's scripts/missions/tvr/10_6_Odins_Eye.lua is a stub, so no scene is traced. Bullet 4 (the glowing "Before Castle
-- Zvahl" spot) hands over "Raebrimm's memento" (key item 3338, res/key_items.lua; only this page names it, and the mission's reward is
-- Cornelia's Belt). The tvr line has no completed set: the end is the line moving to 612 (Moglesse Oblige) on bullet 5, Gumbah's cutscene.
-- Not mapped: bullet 2 (the despairing psyche 3333 is handed out again, but Duke Alloces's Decision loses it, so it is held outside this
-- mission) and bullet 3 (four shards in any order: suffering/anguished/rancorous/determined psyche 3334-3337 arrive one by one, so no
-- single gain shows the bullet done).
return {
    title = "Odin's Eye",
    completes = 's5',
    known = {{t = 'mission', line = 'tvr', min = 602, max = 611}},
    steps = {
        {id = 's4', at = {n = 4, fp = 'once all shards have been collected'},
         done = {
            {t = 'ki', id = 3338, gained = true, why = "Raebrimm's memento obtained at Before Castle Zvahl"},
            {t = 'ki_have', id = 3338, have = true, why = "Raebrimm's memento held"},
            {t = 'chat', re = "obtained key item: raebrimm's memento", why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'head back to bastok mines and'},
         done = {
            {t = 'mission', line = 'tvr', min = 612, why = 'mission log: the line moved past Odin\'s Eye'},
         }},
    },
}
