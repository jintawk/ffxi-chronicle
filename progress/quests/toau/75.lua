-- Step progress for Divine Interference (Aht Urhgan quest 75). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Divine_Interference.lua (area-trigger cutscene 930 at the Whitegate sets
-- Prog 1 with no choice; Imperial Whitegate 931 begins the quest only on option 1, so it is a reach, and the repeat section
-- replays 931 to delete and restart the quest; Acid-eaten Door 157 is a plain cutscene that sets Prog 2, 158 takes exactly
-- three Slabs of Plumbago for the Lightning cell; blank lamp 308 (cutscene with the cell held) sets Prog 3; zone-in 309 in
-- Alzadaal after the battlefield gives the Whisper of radiance; Naja 932 pays the reward and completes only if it could be
-- given, so it replays on a full bag and is a reach, the completed bit proves the bullet). No client script for these actors.
-- Repeatable (page): a repeat skips bullet 1 and starts at the Whitegate (931), whose quest-current bit reopens the run. The
-- Lightning cell is never taken back, so its held snapshot only counts on the first run. The Runic Seal entry is shared by
-- every battlefield, so the fight bullet takes the win signals (zone-in 309, Whisper of radiance).
return {
    title = 'Divine Interference',
    completes = 's7',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'approach naja salaheem in aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 930, run1 = true, why = 'area-trigger cutscene 930 that begins the quest (no choice), sets Prog 1'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine imperial whitegate at aht urhgan'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         },
         reach = {{t = 'event', zone = 50, event = 931, why = 'Imperial Whitegate 931 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'examine the acid eaten door in'},
         done = {
            {t = 'event', zone = 61, event = 157, why = 'Acid-eaten Door 157: cutscene with no choice, sets Prog 2'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade 3 slabs of plumbago to'},
         done = {
            {t = 'event', zone = 61, event = 158, why = 'Acid-eaten Door 158: exactly three slabs traded'},
            {t = 'ki', id = 1246, gained = true, why = 'Lightning cell obtained'},
            {t = 'ki_have', id = 1246, have = true, run1 = true, why = 'Lightning cell held'},
            {t = 'chat', re = 'obtained key item: lightning cell', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'examine the blank target in nyzul'},
         done = {
            {t = 'event', zone = 72, event = 308, why = 'blank lamp 308: cutscene with the Lightning cell held, sets Prog 3'},
         }},
        {id = 's6', at = {n = 6, fp = 'examine the runic seal in alzadaal'},
         done = {
            {t = 'zonein', zone = 72, event = 309, why = 'zone-in cutscene 309 after the battlefield, gives the key item'},
            {t = 'ki', id = 1248, gained = true, why = 'Whisper of radiance obtained'},
            {t = 'ki_have', id = 1248, have = true, why = 'Whisper of radiance held'},
            {t = 'chat', re = 'obtained key item: whisper of radiance', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to naja salaheem to choose'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1248, gained = false, after = 's6', conf = 'inferred', why = 'Whisper of radiance handed over'},
         },
         reach = {{t = 'event', zone = 50, event = 932, why = 'Naja Salaheem 932 (replays when the reward cannot be given)'}}},
    },
}
