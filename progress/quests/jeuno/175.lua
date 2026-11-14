-- Step progress for Now Recording... (Jeuno quest 175). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for the quest (scripts/globals/quests.lua names no entry for 175; Darcia's events are
-- only the Rumors from the West / The Geomagnetron missions). Client event script S4 245_Darcia_010F50DF.txt event 10117,
-- menu choice 5 ("Do you have any work for me?"): "Will you accept this task?" then menu #10343, and only "Sounds like a
-- good time!" says #10344 ("I'm sure the Association appreciates your assistance in this matter. Here is the <keyitem>
-- they would like you to use.", key item 2158 temporary geomagnetron per the event's P0) and gives the device; the decline
-- says #10278. Event 10117 itself is shared with the missions, so it is not used. The founts' message GEOMAGNETRON_ATTUNED
-- ("Your <keyitem> has been attuned to a geomagnetic fount in the corresponding locale.", Ranguemont_Pass/IDs.lua and each
-- fount zone) also plays for the Geomagnetron mission, which is a prerequisite and over by now, and only counts once the
-- temporary geomagnetron has been given (after s2). The completing event is one of Darcia's 10119 to 10124, which have no
-- body in the client scripts, so the quest log's completed bit carries the last step; handing the device back also happens
-- on the abandon branch, so the key item loss proves nothing. Repeatable (page meta): the log marks the first run only, a
-- later accept (the line) opens the next run. Bullet 1 (ask Darcia for more work) and bullet 2 (the device) are the one
-- accept talk; the tail of bullet 3 are the fount lists.
return {
    title = 'Now Recording...',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after completing the geomagnetron return to'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = "I'm sure the Association appreciates your assistance in this matter%.", why = 'Darcia 10117 choice 5, accepting branch only (say #10344)'},
         }},
        {id = 's2', at = {n = 2, fp = 'darcia will grant you a temporary'},
         done = {
            {t = 'ki', id = 2158, gained = true, why = 'temporary geomagnetron obtained'},
            {t = 'ki_have', id = 2158, have = true, why = 'temporary geomagnetron held'},
            {t = 'chat', re = 'obtained key item: temporary geomagnetron', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to one of the locations'},
         done = {
            {t = 'chat', re = 'has been attuned to a geomagnetic fount', after = 's2', why = 'fount message GEOMAGNETRON_ATTUNED, once the temporary geomagnetron is held'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to darcia to complete the'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}
