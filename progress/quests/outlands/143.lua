-- Step progress for 20 in Pirate Years (Outlands quest 143). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Norg/npcs/Ryoma.lua (133 starts the quest with no menu and adds it on finish; 134 is the hand-in:
-- with fewer than two free slots it plays and gives nothing, so it is only inferred and the key item being taken proves the
-- step), zones/Port_Bastok/npcs/Kagetora.lua (261, char var 1 -> 2) and Ensetsu.lua (262, 2 -> 3; 247 is the Ayame and Kaede
-- thank-you that plays before this quest is taken, and 263 is a later talk with no bullet, so neither is used),
-- zones/Eastern_Altepa_Desert/npcs/qm2.lua (the ??? spawns the two Tsuchigumo with a message other quests share, then gives the
-- Trick box (460) with no event). Client event scripts S4 252_Ryoma_010FC03A.txt (133 say #10622, 134 say #10628),
-- 236_Ensetsu_010EC025.txt (262 has no line); 236_Kagetora_010EC007.txt has no 261 (LandSandBoat only). The quest log is set at
-- s1, so it is not silent. Not repeatable.
return {
    title = '20 in Pirate Years',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ryoma at h 8'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ryoma 133)'},
            {t = 'event', zone = 252, event = 133, why = 'Ryoma 133: starts the quest, no menu'},
            {t = 'chat', re = "Hey wait, you're the", why = 'Ryoma 133 (say #10622)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to kagetora inside warehouse 2'},
         done = {
            {t = 'event', zone = 236, event = 261, after = 's1', why = 'Kagetora 261: char var 1 to 2'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to i 5 in port'},
         done = {
            {t = 'event', zone = 236, event = 262, after = 's2', why = 'Ensetsu 262: char var 2 to 3'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'after speaking with ensetsu make your'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'clear the area and examine the'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'two non sleepable spider nms called'}},
        {id = 's7', at = {n = 7, fp = 'clicking the again after defeating the'},
         done = {
            {t = 'ki', id = 460, gained = true, why = 'trick box obtained'},
            {t = 'ki_have', id = 460, have = true, why = 'trick box held'},
            {t = 'chat', re = 'obtained key item: trick box', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'head back to norg and speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 460, gained = false, after = 's7', why = 'trick box taken (only on the successful hand-in)'},
            {t = 'event', zone = 252, event = 134, after = 's7', conf = 'inferred', why = 'Ryoma 134: also plays on a full bag'},
            {t = 'chat', re = 'That weasel is still hiding something%.', after = 's7', conf = 'inferred', why = 'Ryoma 134 (say #10628)'},
         }},
    },
}
