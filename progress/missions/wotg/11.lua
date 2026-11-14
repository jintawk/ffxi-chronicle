-- Step progress for Affairs of the State (Wings of the Goddess mission 12, mission id 11). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/12_Affairs_of_State.lua; key item 1062 would be Count Borel's letter (a reward, not used).
-- The one bullet is a visit to both officials in either order: Velda-Galda in Windurst Waters [S] (zone 94) and Radford in Bastok
-- Markets [S] (zone 87). The first visit plays 178 (Velda-Galda) or 175 (Radford) and moves the status to 1; the second visit
-- plays 179 (Velda-Galda, Radford first) or 176 (Radford, Windurst first) and its finish completes the mission. The bullet says
-- "speak to both", so only the second visit and the log prove it; the first visits are reach. The reminders 177 / 180 (a visit
-- repeated) prove nothing and are not used. The draft listed the first visits and the reminder dialogue as proof of the whole
-- bullet; fixed.
return {
    title = 'Affairs of the State',
    completes = 's1',
    known = {{t = 'mission', line = 'wotg', eq = 11}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you must travel to both bastok'},
         done = {
            {t = 'event', zone = 94, event = 179, why = 'Velda-Galda 179: the second visit, completes the mission (Radford first)'},
            {t = 'event', zone = 87, event = 176, why = 'Radford 176: the second visit, completes the mission (Velda-Galda first)'},
            {t = 'mission', line = 'wotg', eq = 11, completed = true, why = 'mission log: Affairs of the State completed'},
         },
         reach = {
            {t = 'event', zone = 94, event = 178, why = 'Velda-Galda 178: the first visit (status 0)'},
            {t = 'event', zone = 87, event = 175, why = 'Radford 175: the first visit (status 0)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'once you have spoken to both'}},
    },
}
