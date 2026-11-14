-- Step progress for Teak Me to the Stars (Bastok quest 79). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Teak_Me_to_the_Stars.lua (Raibaht 864 always begins the quest when it finishes;
-- 871 is his reminder, only while accepted; 865 is the lumber trade and completes the quest; a wrong trade plays nothing);
-- client event script S4 237_Raibaht_010ED02C.txt (871 say #9946, 865 say #9948). The lumber bullet (n=2) has no signal of its
-- own (the Garhada Teak Lumber also comes from other sources) and is a note on the trade.
return {
    title = 'Teak Me to the Stars',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with raibaht in cid s'},
         done = {
            {t = 'event', zone = 237, event = 864, why = 'Raibaht 864: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 237, event = 871, conf = 'inferred', why = 'Raibaht 871: reminder, only while accepted'},
            {t = 'chat', re = 'To help the chief with his airship modification project, we need a large', conf = 'inferred', why = 'Raibaht 871 (say #9946)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to carpenters landing to obtain'}},
        {id = 's3', at = {n = 3, fp = 'return to raibaht and trade him'},
         done = {
            {t = 'event', zone = 237, event = 865, why = 'Raibaht 865: the lumber accepted'},
            {t = 'chat', re = 'This is exactly what the chief needs for his project%.', why = 'Raibaht 865 (say #9948)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
