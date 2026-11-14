-- Step progress for Fork in the Road (Wings of the Goddess, mission id 49). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/50_Fork_in_the_Road.lua. Seven Blank Targets, one per zone, each plays its event only
-- while that zone's dawndrop is not held (no refusal path) and then hands the key item; the seventh pickup (any order) runs
-- mission:complete, takes every dawndrop and gives the Primal glow. The targets can be done in any order, so each is its own group
-- (a later step done must not tick the others) and each group opens with the mission current; the completed mission proves all seven.
-- Dawndrops exist only here and are all deleted at the completion, so a held one at login is a done step. Bullet 1 (the Ronfaure
-- dawndrop, handed out by the previous mission's completion) has no action and no signal: left as a plain bullet. `completes` is the
-- Walk of Echoes target (the page advises it last; any of the seven can be the closing one).
return {
    title = 'Fork in the Road',
    completes = 's7',
    known = {{t = 'mission', line = 'wotg', eq = 49}},
    groups = {
        jugner = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
        lavaule = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
        sandoria = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
        beaucedine = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
        xarcabard = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
        throne = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
        walk = {start = {{t = 'mission', line = 'wotg', eq = 49, completed = false, why = 'mission line: current mission = Fork in the Road'}}},
    },
    steps = {
        {id = 's1', group = 'jugner', at = {n = 2, fp = 'jugner dawndrop examine the blank target'},
         done = {
            {t = 'event', zone = 82, event = 7, why = 'Jugner Forest [S] Blank Target 7: the Jugner dawndrop is handed out (only while not held)'},
            {t = 'ki', id = 1724, gained = true, why = 'Jugner dawndrop obtained'},
            {t = 'ki_have', id = 1724, have = true, why = 'Jugner dawndrop held'},
            {t = 'chat', re = "obtained key item: jugner dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
        {id = 's2', group = 'lavaule', at = {n = 3, fp = 'la vaule dawndrop examine the blank'},
         done = {
            {t = 'event', zone = 85, event = 5, why = 'La Vaule [S] Blank Target 5: the La Vaule dawndrop is handed out (only while not held)'},
            {t = 'ki', id = 1723, gained = true, why = 'La Vaule dawndrop obtained'},
            {t = 'ki_have', id = 1723, have = true, why = 'La Vaule dawndrop held'},
            {t = 'chat', re = "obtained key item: la vaule dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
        {id = 's3', group = 'sandoria', at = {n = 4, fp = 'san d oria dawndrop examine the'},
         done = {
            {t = 'event', zone = 80, event = 176, why = "Southern San d'Oria [S] Blank Target 176: the San d'Oria dawndrop is handed out (only while not held)"},
            {t = 'ki', id = 1729, gained = true, why = "San d'Oria dawndrop obtained"},
            {t = 'ki_have', id = 1729, have = true, why = "San d'Oria dawndrop held"},
            {t = 'chat', re = "obtained key item: san d'oria dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
        {id = 's4', group = 'beaucedine', at = {n = 5, fp = 'beaucedine dawndrop examine the blank target'},
         done = {
            {t = 'event', zone = 136, event = 29, why = 'Beaucedine Glacier [S] Blank Target 29: the Beaucedine dawndrop is handed out (only while not held)'},
            {t = 'ki', id = 1725, gained = true, why = 'Beaucedine dawndrop obtained'},
            {t = 'ki_have', id = 1725, have = true, why = 'Beaucedine dawndrop held'},
            {t = 'chat', re = "obtained key item: beaucedine dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
        {id = 's5', group = 'xarcabard', at = {n = 6, fp = 'xarcabard dawndrop examine the blank target'},
         done = {
            {t = 'event', zone = 137, event = 42, why = 'Xarcabard [S] Blank Target 42: the Xarcabard dawndrop is handed out (only while not held)'},
            {t = 'ki', id = 1726, gained = true, why = 'Xarcabard dawndrop obtained'},
            {t = 'ki_have', id = 1726, have = true, why = 'Xarcabard dawndrop held'},
            {t = 'chat', re = "obtained key item: xarcabard dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
        {id = 's6', group = 'throne', at = {n = 7, fp = 'throne room dawndrop examine the blank'},
         done = {
            {t = 'event', zone = 156, event = 15, why = 'Throne Room [S] Blank Target 15: the Throne Room dawndrop is handed out (only while not held)'},
            {t = 'ki', id = 1727, gained = true, why = 'Throne Room dawndrop obtained'},
            {t = 'ki_have', id = 1727, have = true, why = 'Throne Room dawndrop held'},
            {t = 'chat', re = "obtained key item: throne room dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
        {id = 's7', group = 'walk', at = {n = 8, fp = 'walk of echoes dawndrop it is'},
         done = {
            {t = 'event', zone = 182, event = 10, why = 'Walk of Echoes Blank Target 10: the Walk of Echoes dawndrop is handed out (only while not held)'},
            {t = 'ki', id = 1728, gained = true, why = 'Walk of Echoes dawndrop obtained'},
            {t = 'ki_have', id = 1728, have = true, why = 'Walk of Echoes dawndrop held'},
            {t = 'chat', re = "obtained key item: walk of echoes dawndrop", why = 'chat: key item obtained'},
            {t = 'mission', line = 'wotg', eq = 49, completed = true, why = 'mission log: Fork in the Road completed (all seven dawndrops taken)'},
         }},
    },
}
