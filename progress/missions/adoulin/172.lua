-- Step progress for Behind the Sluices (Seekers of Adoulin mission, page id 172). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_7_1_Behind_the_Sluices.lua and zones/Rala_Waterways_U/instances/behind_the_sluices.lua.
-- The Storage Container gives the Waterway facility crank (key item 2450, temporary) only in this mission, so its gain proves bullet 1.
-- The Sluice Gate (Rala Waterways 258) plays event 359 only with the crank at status 0, no refusal path, and its finish sets status
-- 1, so 359 proves bullet 2. Event 361 (the gate again) is a menu whose option 1 starts the entry and any other option leaves, and it
-- also plays after the mission is done, so it is only `reach` of bullet 4; the crank leaving the key items is the instance's entry
-- (afterInstanceRegister deletes it), also `reach`. Returning from the won fight plays the zone-in 353 (status 3) whose finish
-- completes the mission, so 353 and the line prove bullet 4 (completes). Bullet 3 (click the gate to enter the area) has no signal
-- of its own, so it is a note on bullet 4. Rejected from the draft: bullet 1 as a note (the crank gain is a real signal), 361 as
-- proof of bullet 2, and the notes tied to bullet 3. The adoulin line has no completed set (packet value = page id), so the
-- completion is `min = 173`, not `completed = true`.
return {
    title = 'Behind the Sluices',
    completes = 's4',
    known = {{t = 'mission', line = 'adoulin', eq = 172}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to h 6 in rala'},
         done = {
            {t = 'ki', id = 2450, gained = true, why = 'Waterway facility crank obtained (Storage Container)'},
            {t = 'ki_have', id = 2450, have = true, why = 'Waterway facility crank held'},
            {t = 'chat', re = 'obtained key item: waterway facility crank', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'return to the sluice gate c'},
         done = {
            {t = 'event', zone = 258, event = 359, why = 'Sluice Gate 359: only with the crank at status 0, finish sets status 1'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'click the sluice gate to enter'}},
        {id = 's4', at = {n = 4, fp = 'click the antiquated sluice gate to'},
         done = {
            {t = 'zonein', zone = 258, event = 353, why = 'Rala Waterways zone-in 353 after the won fight, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 173, why = 'mission log: the line moved past Behind the Sluices'},
         },
         reach = {
            {t = 'event', zone = 258, event = 361, why = 'Sluice Gate 361: the entry menu (plays on any answer)'},
            {t = 'ki', id = 2450, gained = false, why = 'Waterway facility crank taken on entering the battle'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'notes for those assisting with the'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'you fight against four enemies'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'all four enemies run to a'}},
        {id = 's8', kind = 'note', with = 's4', at = {n = 8, fp = 'alter ego trusts may be summoned'}},
        {id = 's9', kind = 'note', with = 's4', at = {n = 9, fp = 'at 119 this fight is not'}},
        {id = 's10', kind = 'note', with = 's4', at = {n = 10, fp = 'you fight alongside arciela'}},
    },
}
