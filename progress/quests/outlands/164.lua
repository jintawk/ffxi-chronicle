-- Step progress for Divine Might (Repeat) (Outlands quest 164). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Divine_Might_Repeat.lua (after Divine Might is completed the Blank Target plays
-- 57, which deletes and begins this quest on finish; with no Moonlight ore it plays 58, with the ore and no win yet 56, and with
-- the ore after a win 59, the earring choice, which runs quest:complete only for a valid choice; the Qu'Hau Spring turns a Light
-- Ore into the Moonlight ore with event 8 on a full-moon night, and an Illuminink and Parchment into an Ark Pentasphere with
-- event 7, which Divine Might shares). Event 59 plays only once the battlefield is won, so it proves the battle bullet; the
-- completed bit proves the last. Event 56 is also the first quest's line and 58 is a waiting line, so neither is used. The
-- battlefield's own exit event (32001) is any battlefield's. The client has no event script for these zones' quest events beyond
-- the spring (S4 122_Qu_Hau_Spring_0107A114.txt lists 7 and 8). The quest log restarts on each repeat (57 deletes the quest first),
-- but retail may keep the old bits, so the log marks the first run only. The first eleven bullets are Divine Might's and stay plain.
return {
    title = 'Divine Might (Repeat)',
    completes = 's20',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s13'}},
    steps = {
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'drop your current earring you will'}},
        {id = 's13', at = {n = 13, fp = 'receive the quest at the unmarked'},
         done = {
            {t = 'event', zone = 178, event = 57, why = 'Blank Target 57: begins the repeat quest'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
         }},
        {id = 's14', kind = 'note', with = 's13', at = {n = 14, fp = 'the quest appears as a second'}},
        {id = 's15', kind = 'note', with = 's17', at = {n = 15, fp = 'obtain a light ore'}},
        {id = 's16', kind = 'note', with = 's17', at = {n = 16, fp = 'if you need a new ark'}},
        {id = 's17', at = {n = 17, fp = 'trade the light ore to the'},
         done = {
            {t = 'ki', id = 761, gained = true, why = 'Moonlight ore obtained'},
            {t = 'ki_have', id = 761, have = true, why = 'Moonlight ore held'},
            {t = 'event', zone = 122, event = 8, why = 'Qu\'Hau Spring 8: the Light Ore taken, Moonlight ore given'},
            {t = 'chat', re = 'obtained key item: moonlight ore', why = 'chat: key item obtained'},
         }},
        {id = 's18', kind = 'optional', at = {n = 18, fp = 'trade the illuminink and parchment to'},
         done = {
            {t = 'event', zone = 122, event = 7, after = 's13', why = 'Qu\'Hau Spring 7: Ark Pentasphere made (also Divine Might\'s)'},
         }},
        {id = 's19', at = {n = 19, fp = 'enter and complete the divine might'},
         done = {
            {t = 'event', zone = 178, event = 59, after = 's13', why = 'Blank Target 59: plays only with the ore held after the win (Prog 1); also on a cancelled menu'},
         }},
        {id = 's20', at = {n = 20, fp = 'return to the unmarked target in'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (Blank Target 59, a valid earring choice)'},
         }},
    },
}
