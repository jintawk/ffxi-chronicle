-- Step progress for A New Force Arises (Seekers of Adoulin mission 4-3-2, mission id 280). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/soa/4_3_2_A_New_Force_Arises.lua and the client script S4 267_Alpine_Trail_0110B18E.
-- Bullet 3 is the three scales (Sunkissed, Moontouched and Starblessed, temporary key items) from Outer Ra'Kaznar (274). Each
-- scale event (_7mw 51, Effigy of Sealing 52 and 53) plays only while the scale is missing and gives it, so each is `reach`, as is
-- the Alpine Trail's 55 (one or two scales) and the Celennia Memorial Library zone-in 6 (one or two scales, the optional scene).
-- The Alpine Trail's 56 plays only with all three scales, so it proves bullet 3 (the collecting) and is `reach` for bullet 4; it is a
-- Proceed? menu client side and plays on a refusal too, so it is not proof of bullet 4. Bullet 4 is the Mount Kamihr (282) zone-in
-- 5 after the Yes (it plays only with all three scales), whose finish takes the scales and completes the mission. Zone-in 4 at
-- Mount Kamihr is not used: it plays with any other scale count, zero included. Levil's 165 is a reminder. The adoulin line has no
-- completed set (`min = 281`). Bullets 1 and 2 (the Ancestral Cloth tip, the way to Outer Ra'Kaznar) are notes on bullet 3. The
-- draft listed 55, 56 and zone-in 4 and 5 all as proof of bullet 4, which made a refusal or a partial count look like the end.
return {
    title = 'A New Force Arises',
    completes = 's4',
    known = {{t = 'mission', line = 'adoulin', eq = 280}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 280, why = 'mission line: current mission = A New Force Arises'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'ancestral cloth is a common from'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to outer ra kaznar by'}},
        {id = 's3', at = {n = 3, fp = 'in outer ra kaznar find and'},
         done = {
            {t = 'event', zone = 267, event = 56, why = 'Alpine Trail 56: plays only with all three scales held'},
         },
         reach = {
            {t = 'event', zone = 274, event = 51, why = '_7mw 51: the Sunkissed scale'},
            {t = 'event', zone = 274, event = 52, why = 'Effigy of Sealing 52: the Moontouched scale'},
            {t = 'event', zone = 274, event = 53, why = 'Effigy of Sealing 53: the Starblessed scale'},
            {t = 'event', zone = 267, event = 55, why = 'Alpine Trail 55: plays with one or two scales'},
            {t = 'zonein', zone = 284, event = 6, why = 'Celennia Memorial Library zone-in 6: plays with one or two scales'},
         }},
        {id = 's4', at = {n = 4, fp = 'after collecting all the items return'},
         done = {
            {t = 'zonein', zone = 282, event = 5, why = 'Mount Kamihr zone-in 5 with all three scales, its finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 281, why = 'mission log: the line moved past A New Force Arises'},
         },
         reach = {
            {t = 'event', zone = 267, event = 56, why = 'Alpine Trail 56: the Proceed? menu with all three scales (also plays on a refusal)'},
         }},
    },
}
