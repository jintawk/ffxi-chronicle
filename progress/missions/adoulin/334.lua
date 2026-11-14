-- Step progress for Yggdrasil Beckons (Seekers of Adoulin mission, page id 334). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_2_0_Yggdrasil_Beckons.lua. The two fights can be done in either order, so each is a
-- group of its own (dhokmak, ashrakk). The Wavering Flux in Cirdas Caverns (270) plays 34 as a plain progress event until its finish
-- sets the status bit, with no refusal path, so it proves bullet 4; the one in Yorcia Weald (263) plays 3 the same way and proves
-- bullet 9 (the draft put both on bullet 4). Winning a fight gives a permanent key item (Dhokmak's blood sigil 2625, Ashrakk's blood
-- sigil 2624); nothing else gives them, so the gain proves the "upon defeating" bullet (7, 12) and implies the flux step. The
-- mission completes when both sigils are held, whichever fight is second, so every required step also has the line moving past
-- (`min = 335`; the adoulin line has no completed set, packet value = page id), and `completes` names bullet 12. Rejected: the
-- zone-ins 36 (Cirdas Caverns) and 4 (Yorcia Weald): they re-issue a sigil after a fight and the ids are LandSandBoat's own
-- assumption (its battlefield is not implemented), Levil's 40 (a reminder), and the draft's `completed = true` matcher. Bullets 1 to 3,
-- 5, 6, 8, 10 and 11 (cautions, travel, transport, the enemy list) are notes.
return {
    title = 'Yggdrasil Beckons',
    completes = 's12',
    known = {{t = 'mission', line = 'adoulin', eq = 334}},
    groups = {
        main = {start = {{t = 'mission', line = 'adoulin', eq = 334, why = 'mission line: current mission = Yggdrasil Beckons'}}},
        dhokmak = {start = {{t = 'mission', line = 'adoulin', eq = 334, why = 'mission line: current mission = Yggdrasil Beckons'}}},
        ashrakk = {start = {{t = 'mission', line = 'adoulin', eq = 334, why = 'mission line: current mission = Yggdrasil Beckons'}}},
    },
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'note drawing your weapon will immediately'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'note if you fail either battle'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to k 11 in cirdas'}},
        {id = 's4', group = 'dhokmak', at = {n = 4, fp = 'examine the wavering flux for a'},
         done = {
            {t = 'event', zone = 270, event = 34, why = 'Wavering Flux (Cirdas Caverns) 34: plays until its finish sets the status bit'},
            {t = 'mission', line = 'adoulin', min = 335, why = 'mission line: the line moved past Yggdrasil Beckons'},
         }},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'examine it again to be transported'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'you will fight dhokmak and 3'}},
        {id = 's7', group = 'dhokmak', implies = {'s4'}, at = {n = 7, fp = 'upon defeating dhokmak you will receive'},
         done = {
            {t = 'ki', id = 2625, gained = true, why = "Dhokmak's blood sigil obtained (the won fight)"},
            {t = 'ki_have', id = 2625, have = true, why = "Dhokmak's blood sigil held (permanent key item)"},
            {t = 'chat', re = 'obtained key item: dhokmak.s blood sigil', why = 'chat: key item obtained'},
            {t = 'mission', line = 'adoulin', min = 335, why = 'mission line: the line moved past Yggdrasil Beckons'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'head to the southeastern section of'}},
        {id = 's9', group = 'ashrakk', at = {n = 9, fp = 'examine the wavering flux for a'},
         done = {
            {t = 'event', zone = 263, event = 3, why = 'Wavering Flux (Yorcia Weald) 3: plays until its finish sets the status bit'},
            {t = 'mission', line = 'adoulin', min = 335, why = 'mission line: the line moved past Yggdrasil Beckons'},
         }},
        {id = 's10', kind = 'note', with = 's12', at = {n = 10, fp = 'examine it again to be transported'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'you will fight ashrakk'}},
        {id = 's12', group = 'ashrakk', implies = {'s9'}, at = {n = 12, fp = 'upon defeating ashrakk you will receive'},
         done = {
            {t = 'ki', id = 2624, gained = true, why = "Ashrakk's blood sigil obtained (the won fight)"},
            {t = 'ki_have', id = 2624, have = true, why = "Ashrakk's blood sigil held (permanent key item)"},
            {t = 'chat', re = 'obtained key item: ashrakk.s blood sigil', why = 'chat: key item obtained'},
            {t = 'mission', line = 'adoulin', min = 335, why = 'mission line: the line moved past Yggdrasil Beckons'},
         }},
    },
}
