-- Step progress for The Celennia Memorial Library (Seekers of Adoulin mission, page id 152). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/2_5_1_The_Celennia_Memorial_Library.lua and the client script S4 284_History_0111C018
-- (event 1003). History (Celennia Memorial Library 284) plays the menu 1003 on every visit, so the event is only `reach`; the line
-- "The following page is creased in a peculiar manner." (say #7554) prints only when the Colonization Decree is read before the
-- password is shown, and the server then sets mission status 1, which is what lets Levil play 125. That line proves bullet 2.
-- Yefafa's event 1 is an empty script that plays on any visit and proves nothing. Levil plays the reminder 124 at status 0 (not used)
-- and 125 at status 1, whose finish completes the mission, so 125 proves bullet 3. The adoulin line has no completed set
-- (packet value = page id), so the completion is `min = 153`, not `completed = true`. Bullet 1 is travel and a note.
return {
    title = 'The Celennia Memorial Library',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 152}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'proceed to the celennia memorial library'}},
        {id = 's2', at = {n = 2, fp = 'read all three options in the'},
         done = {
            {t = 'chat', re = '%.%.%.The following page is creased in a peculiar manner%.', why = 'History 1003 (say #7554): the password page, status 1 is set'},
         },
         reach = {
            {t = 'event', zone = 284, event = 1003, why = 'History 1003: the book menu (plays on any visit)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to levil in the pioneers'},
         done = {
            {t = 'event', zone = 256, event = 125, why = 'Levil 125 (status 1), finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 153, why = 'mission log: the line moved past The Celennia Memorial Library'},
         }},
    },
}
