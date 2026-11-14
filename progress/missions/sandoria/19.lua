-- Step progress for The Secret Weapon (San d'Oria mission 7-2, mission id 19). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/7_2_The_Secret_Weapon.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt (1041 and 1042: say #7359 and #125, the garden invitation; 1043 and 1044: say #7368
-- and #134, the debrief); key item 284 crystal dowser (res/key_items.lua).
-- This mission has three statuses before it is accepted: the gate guard's invitation (1041 Endracion and Grilau, 1042 Ambrotien; status
-- 0 -> 1, it replays at status 1), the Chateau d'Oraguille garden trigger area (zone 233, event 0, status 1 -> 2; no other script uses
-- event 0 in that zone) and then the ordinary offer, whose accept moves the nation line to 19 (the offer event itself also plays on a
-- decline, so only the line proves it; the mission matcher is completed = false so a completion read cannot restart a run). The
-- Horlais Peak battlefield leaves no event of its own; the crystal dowser (284) is given when it is won and is taken at the end. The
-- garden event 0 has no decoded body, so its id comes from LandSandBoat. The Crystal dowser is an intermediate key item, not a reward.
return {
    title = 'The Secret Weapon',
    completes = 's8',
    known = {{t = 'mission', line = 'sandoria', min = 19}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with a gate guard who'},
         done = {
            {t = 'event', zone = 230, event = 1042, why = 'Ambrotien 1042: the garden invitation (status 0 or 1)'},
            {t = 'event', zone = 230, event = 1041, why = 'Endracion 1041: the garden invitation (status 0 or 1)'},
            {t = 'event', zone = 231, event = 1041, why = 'Grilau 1041: the garden invitation (status 0 or 1)'},
            {t = 'chat', re = 'The fair Claidie I d.Oraguille has invited you to the chateau%.', why = 'a gate guard (say #7359 and #125)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head for chateau d oraguille and'},
         done = {
            {t = 'event', zone = 233, event = 0, why = 'Chateau d\'Oraguille garden trigger area 0 (status 1, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to the gate guard to'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 19, completed = false, why = 'mission log: current mission = The Secret Weapon'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'if you re low level gather'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'you will have to reach horlais'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'once you re there get ready'}},
        {id = 's7', at = {n = 7, fp = 'when finished you ll receive another'},
         done = {
            {t = 'ki', id = 284, gained = true, why = 'crystal dowser obtained (the battlefield won)'},
            {t = 'ki_have', id = 284, have = true, why = 'crystal dowser held'},
            {t = 'chat', re = 'obtained key item: crystal dowser', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'head back to san d oria'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 19, completed = true, why = 'mission log: The Secret Weapon completed'},
            {t = 'event', zone = 230, event = 1044, why = 'Ambrotien 1044: completes'},
            {t = 'event', zone = 230, event = 1043, why = 'Endracion 1043: completes'},
            {t = 'event', zone = 231, event = 1043, why = 'Grilau 1043: completes'},
            {t = 'chat', re = 'Well, congratulations on the completion of your mission%.', why = 'a gate guard (say #7370 and #136)'},
         }},
    },
}
