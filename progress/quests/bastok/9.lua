-- Step progress for A Foreman's Best Friend (Bastok quest 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/A_Foremans_Best_Friend.lua (Gudav 110 has no option and its finish begins the
-- quest; Gudav 112 plays only on a Dog Collar trade and runs quest:complete, then gives key item 398 or 2,000 exp when it is
-- already held, so the key item only supports the step; Dehlner 111 is an idle line); client event script S4
-- 236_Gudav_010EC02B.txt (110 say #7525, 112 say #7533). The collar bullet is a note on the trade.
-- Shared-signal audit: key item 398 (map of the Gusgen Mines) is also sold by the map seller (globals/maps.lua) -> dropped; the
-- completed bit, event 112 and its line still carry s3.
return {
    title = "A Foreman's Best Friend",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to gudav to begin the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 110, why = 'Gudav 110: begins the quest'},
            {t = 'chat', re = 'This is such a great location%.%.%.', why = 'Gudav 110 (say #7525)'},
         }},
        {id = 'n2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a dog collar from black'}},
        {id = 's3', at = {n = 3, fp = 'after the cutscene trade gudav the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 236, event = 112, why = 'Gudav 112: the Dog Collar accepted, runs quest:complete'},
            {t = 'chat', re = "Hey%.%.%.the foreman's dog used to wear this collar%.", why = 'Gudav 112 (say #7533)'},
         }},
    },
}
