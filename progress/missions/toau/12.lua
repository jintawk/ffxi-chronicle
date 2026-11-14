-- Step progress for Lost Kingdom (Treasures of Aht Urhgan mission 13, mission id 12). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/13_Lost_Kingdom.lua. Jazaraat's Headstone (Caedarva Mire, zone 79) plays cutscene 8
-- at status 0 with the Vial of spectral scent and cutscene 9 at status 2 (after Jazaraat dies), whose finish takes the vial (key item
-- 813) and completes the mission; neither id is used by anything else in the zone. The second check spawns the Fomor NM with no event
-- and no log change, so bullet 2 stays a plain bullet. The Ephramadian gold coin (a reward key item) is not used.
return {
    title = 'Lost Kingdom',
    completes = 's3',
    known = {{t = 'mission', line = 'toau', eq = 12}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to caedarva mire from the'},
         done = {
            {t = 'event', zone = 79, event = 8, why = "Jazaraat's Headstone 8: the first cutscene (status 0, vial held)"},
         }},
        {id = 's3', at = {n = 3, fp = 'check jazaraat s headstone a third'},
         done = {
            {t = 'event', zone = 79, event = 9, why = "Jazaraat's Headstone 9: the vial taken, the mission completes"},
            {t = 'ki', id = 813, gained = false, why = 'Vial of spectral scent taken at the headstone'},
            {t = 'mission', line = 'toau', eq = 12, completed = true, why = 'mission log: Lost Kingdom completed'},
         }},
    },
}
