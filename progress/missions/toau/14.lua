-- Step progress for The Black Coffin (Treasures of Aht Urhgan mission 15, mission id 14). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/15_The_Black_Coffin.lua (the battlefield itself is an unscripted instance there).
-- The Cutter's trigger area in Arrapago Reef (zone 54) starts event 8 (then the hidden 34 and 35, whose finish sets status 1) when the
-- Ephramadian gold coin is held at status 0. After the fight the player lands in Nashmau (zone 53), whose zone-in 281 completes the
-- mission. Examining the Cutter to enter the battlefield leaves no event of its own, so bullet 3 stays a plain bullet; the fight
-- bullets are notes on the step that follows the fight. The Naja reminder 12 and the travel bullet prove nothing.
return {
    title = 'The Black Coffin',
    completes = 's4',
    known = {{t = 'mission', line = 'toau', eq = 14}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'head to the cutter which is'}},
        {id = 's2', at = {n = 2, fp = 'approach the cutter for a cutscene'},
         done = {
            {t = 'event', zone = 54, event = 8, why = 'Arrapago Reef Cutter trigger area: event 8 (coin held, status 0)'},
            {t = 'event', zone = 54, event = 35, why = 'Arrapago Reef Cutter trigger area: event 35, finish sets status 1'},
         }},
        {id = 's4', at = {n = 4, fp = 'after the fight you will wind'},
         done = {
            {t = 'zonein', zone = 53, event = 281, why = 'Nashmau zone-in 281 after the battle, completes'},
            {t = 'mission', line = 'toau', eq = 14, completed = true, why = 'mission log: The Black Coffin completed'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'gessho will assist you in this'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'the first phase of battle is'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'once the five ashu talif crew'}},
        {id = 's8', kind = 'note', with = 's4', at = {n = 8, fp = 'the ashu talif captain will spawn'}},
        {id = 's9', kind = 'note', with = 's4', at = {n = 9, fp = 'you must bring the ashu talif'}},
    },
}
