-- Step progress for Indomitable Spirit (Outlands quest 201). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Rabao/npcs/Irmilant.lua (with the Serpent Rumors key item held and the quest available,
-- Irmilant 131 plays and begins the quest on finish, no choice; the trade of Opal Silk and Saber Shoot plays 132, which takes
-- them and starts the wait for the next conquest tally; 133 is the wait line; 134 gives the reward and completes, only when the
-- reward can be given, so it also plays on a full bag; 135 is the line after completion); client event script S4
-- 247_Irmilant_010F702E.txt (131 say #10227, 132 say #10559, 133 say #10561, 134 say #10562, 135 say #10564). The Serpent Rumors
-- key item is bought with guild points, so it proves the first bullet (it is quest-specific, held before the quest begins, hence
-- silent_until). Turning in the Liks and Gugrusaurus at Zaldon has no event of its own (the silk and shoot are random drops), so it
-- is a note on the trade. Not repeatable.
return {
    title = 'Indomitable Spirit',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'to begin this quest in your'},
         done = {
            {t = 'ki', id = 1977, gained = true, why = 'Serpent Rumors obtained'},
            {t = 'ki_have', id = 1977, have = true, why = 'Serpent Rumors held'},
            {t = 'chat', re = 'obtained key item: serpent rumors', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'turn in liks and gugrusaurus to'}},
        {id = 's3', at = {n = 3, fp = 'speak to irmilant in rabao g'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Irmilant 131)'},
            {t = 'event', zone = 247, event = 131, why = 'Irmilant 131: begins the quest'},
            {t = 'chat', re = 'Things of substance will inevitably be destroyed%.', why = 'Irmilant 131 (say #10227)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade the opal silk and saber'},
         done = {
            {t = 'event', zone = 247, event = 132, why = 'Irmilant 132: the silk and shoot taken'},
            {t = 'chat', re = 'This is a feat worthy of the greatest anglers in history%.', why = 'Irmilant 132 (say #10559)'},
            {t = 'event', zone = 247, event = 133, conf = 'inferred', why = 'Irmilant 133: the wait line, only after the trade'},
            {t = 'chat', re = 'Please, do not rush me%.', conf = 'inferred', why = 'Irmilant 133 (say #10561)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to irmilant after conquest tally'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 247, event = 135, conf = 'inferred', why = 'Irmilant 135: plays only after completion'},
            {t = 'chat', re = 'You will be the one to prove that there is a spirit', conf = 'inferred', why = 'Irmilant 135 (say #10564)'},
         },
         reach = {{t = 'event', zone = 247, event = 134, after = 's4', why = 'Irmilant 134: the reward talk (a full bag plays it too, no completion)'}}},
    },
}
