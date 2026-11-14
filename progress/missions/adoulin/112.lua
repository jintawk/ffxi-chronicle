-- Step progress for The Geomagnetron (Seekers of Adoulin mission 1-2, mission id 112). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_2_The_Geomagnetron.lua, globals/geomagnetic_fount.lua and the client script S4
-- 245_Darcia_010F50DF (events 10117, 10118). The adoulin line holds the page id and has no completed set, so the completion is
-- `min = 113`. Bullet 1 (the application) is done once this mission is the current one. Bullet 2 (attuning at a fount) is a note on
-- bullet 3: the founts' own message is in no client script or in the entry's LandSandBoat zone text, so no line proves it.
-- Bullet 3: Darcia 10118 plays only once the device is attuned (charVar SOA = 1) and its finish completes; the lines
-- #10333 and #10335 are in it. Bullet 4 is the 1,000,000 gil skip: the line "There is one more thing" (#10317) is said only in
-- that branch, so it proves the skip; "Let me see...dot the I's" (#10316) is said at both ends and proves the completion.
-- Rejected from the draft: the refusal line ("do not appear to have the required gil", which plays when the skip fails), the
-- 10117 menu as `reach` (it plays in the previous mission's phase as well), the Geomagnetron and charter permit key items
-- (rewards the line can already carry), and `completed = true` (the line has no completed set).
return {
    title = 'The Geomagnetron',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 112}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with darcia in lower jeuno'},
         done = {
            {t = 'mission', line = 'adoulin', eq = 112, why = 'mission log: The Geomagnetron is current, so the application was made'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to one of the locations'}},
        {id = 's3', at = {n = 3, fp = 'return to darcia with the attuned'},
         done = {
            {t = 'event', zone = 245, event = 10118, why = 'Darcia 10118: plays only once attuned, its finish completes the mission'},
            {t = 'chat', re = 'you wish for me to examine your', why = 'Darcia 10118 (say #10333)'},
            {t = 'chat', re = "let me see%.%.%.dot the i.s here", why = 'Darcia (say #10316): the permit issued, by the return or by the paid skip'},
            {t = 'mission', line = 'adoulin', min = 113, why = 'mission log: the line moved past The Geomagnetron'},
         }},
        {id = 's4', kind = 'branch', at = {n = 4, fp = 'alternatively this mission can be skipped'},
         done = {
            {t = 'chat', re = 'there is one more thing%. take this', why = 'Darcia 10117 (say #10317): said only when the 1,000,000 gil skip is paid'},
         }},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'if you wish to do this'}},
        {id = 's6', kind = 'note', with = 's3', at = {n = 6, fp = 'korroloka tunnel g 9 map 4'}},
        {id = 's7', kind = 'note', with = 's3', at = {n = 17, fp = 'ranguemont pass j 10'}},
        {id = 's8', kind = 'note', with = 's3', at = {n = 26, fp = 'outer horutoto ruins g 7'}},
    },
}
