-- Step progress for Over the Hills and Far Away (San d'Oria quest 112). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_San_dOria/npcs/Antreneau.lua (725 starts it with no choice and the finish adds
-- the quest; 726 is his accepted-state talk) and scripts/zones/Uleguerand_Range/npcs/qm_moblin_hotrok.lua (examining the
-- ??? while accepted plays the glittering and "what lies beneath" texts, trading a Moblin Hotrok plays event 10 and its
-- finish completes the quest with gil, exp and the Uleguerand map key item, no item reward); client event script S4
-- 232_Antreneau_010E800D.txt (725 say #8456, 726 #8468, 727 #8471 once completed); Uleguerand IDs.lua WHAT_LIES_BENEATH.
-- The draft ended the quest at the Antreneau bullet; the quest completes at the trade (bullet 8). Bullet 1 (reading the
-- diary to page 4) has no signal of its own: Diary event 722 only offers page 4 and has no decoded line. Bullet 3 (the
-- Moblin Hotrok drop) is an item gain only, so it stays plain.
return {
    title = 'Over the Hills and Far Away',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'speak to antreneau port san d'},
         done = {
            {t = 'event', zone = 232, event = 725, why = 'Antreneau 725: the start'},
            {t = 'chat', re = 'Beans, beans, and more beans%.', why = 'Antreneau 725 (say #8456)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 232, event = 726, conf = 'inferred', why = 'Antreneau 726: accepted-state talk'},
            {t = 'chat', re = 'If you wish to meet with my uncle, you must cross the Uleguerand Range%.', conf = 'inferred', why = 'Antreneau 726 (say #8468)'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'head to uleguerand range and climb'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'at f 9 you will find'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'fall down the southern slope the'}},
        {id = 's7', at = {n = 7, fp = 'once on the ledge head inside'},
         done = {
            {t = 'chat', re = 'Could someone be trying to melt the ice to retrieve what lies beneath', why = 'Uleguerand ???: examined while accepted (text 7359)'},
         }},
        {id = 's8', at = {n = 8, fp = 'trade the moblin hotrok to the'},
         done = {
            {t = 'event', zone = 5, event = 10, why = 'Uleguerand ??? 10: the Hotrok traded, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 232, event = 727, conf = 'inferred', why = 'Antreneau 727: only once completed'},
            {t = 'chat', re = 'You actually managed to find my uncle', conf = 'inferred', why = 'Antreneau 727 (say #8471)'},
         }},
    },
}
