-- Step progress for Undersea Scouting (Treasures of Aht Urhgan mission 9, mission id 8). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/09_Undersea_Scouting.lua. Alzadaal Undersea Ruins (zone 72) trigger area 23 (map 7,
-- before the door) plays event 1, the only event 1 in the zone, and its finish completes the mission. The Astral compass (a reward
-- key item) is not used. The three travel bullets are notes on that cutscene; the page's "when you zone in" is the trigger area.
return {
    title = 'Undersea Scouting',
    completes = 's4',
    known = {{t = 'mission', line = 'toau', eq = 8}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'enter the chamber of passage k'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'take the southeastern transport device at'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'take the right eastern transport device'}},
        {id = 's4', at = {n = 4, fp = 'the cutscene will start when you'},
         done = {
            {t = 'event', zone = 72, event = 1, why = 'Alzadaal Undersea Ruins trigger area 23: event 1, finish completes the mission'},
            {t = 'mission', line = 'toau', eq = 8, completed = true, why = 'mission log: Undersea Scouting completed'},
         }},
    },
}
