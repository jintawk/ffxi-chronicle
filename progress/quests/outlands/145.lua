-- Step progress for True Will (Outlands quest 145). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Norg/npcs/Ryoma.lua (136 starts the quest with no menu; 137 plays once the Old trick box is held,
-- char var 0 -> 1; 138 is his reminder while the var is 1), zones/Yhoator_Jungle/npcs/qm3.lua (the ??? pops the three Kappa
-- NMs with "A chill runs down your spine...", then gives the Old trick box (470) with no event; that line is also a Romaeve
-- mission line in LandSandBoat, so it is gated after s1), zones/Rabao/npcs/Leodarion.lua (97 takes the Old trick box, var 1 -> 2;
-- 98 is the reminder; 99 plays once the Large trick box (471, from a Kuftal Tunnel Treasure Coffer) is held and completes the
-- quest and takes the box, but gives nothing on a full bag, so it is only inferred and the box being taken proves the step).
-- Client event scripts S4 252_Ryoma_010FC03A.txt (136 say #10634, 137 say #10639), 247_Leodarion_010F7037.txt (97 say #10288,
-- 98 say #10324, 99 say #10327). The quest log is set at s1, so it is not silent. Bullets 3, 4, 7 to 10 and 15 are travel
-- tips and the mob list, so they are not steps. The page says repeatable; nothing observable marks a second run, so there is
-- no `repeatable` entry.
-- Draft corrections: the examine bullet 5 is a step (the spawn line proves it); bullet 17's completion rests on the log and
-- the box being taken, not the full-bag-unsafe event 99.
return {
    title = 'True Will',
    completes = 's17',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ryoma in norg to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ryoma 136)'},
            {t = 'event', zone = 252, event = 136, why = 'Ryoma 136: begins the quest, no menu'},
            {t = 'chat', re = "You're just the person I was looking for%.", why = 'Ryoma 136 (say #10634)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'travel to i 7 in yhoator'}},
        {id = 's5', at = {n = 5, fp = 'once prepared examine the at i'},
         done = {
            {t = 'chat', re = 'A chill runs down your spine%.%.%.', after = 's1', why = 'qm3 pops the Kappa NMs (Yhoator CHILL_RUNS_DOWN)'},
         }},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'these mobs are'}},
        {id = 's11', at = {n = 11, fp = 'after the sahagin are defeated examine'},
         done = {
            {t = 'ki', id = 470, gained = true, why = 'old trick box obtained'},
            {t = 'ki_have', id = 470, have = true, why = 'old trick box held'},
            {t = 'chat', re = 'obtained key item: old trick box', why = 'chat: key item obtained'},
         }},
        {id = 's12', at = {n = 12, fp = 'return to ryoma for another cutscene'},
         done = {
            {t = 'event', zone = 252, event = 137, after = 's11', why = 'Ryoma 137: the Old trick box seen, var 0 to 1'},
            {t = 'chat', re = "Well I'll be%.%.%. You found the", after = 's11', why = 'Ryoma 137 (say #10639)'},
            {t = 'event', zone = 252, event = 138, after = 's11', conf = 'inferred', why = 'Ryoma 138: his reminder, only after 137'},
         }},
        {id = 's13', at = {n = 13, fp = 'head to rabao and speak with'},
         done = {
            {t = 'event', zone = 247, event = 97, after = 's12', why = 'Leodarion 97: takes the Old trick box, var 1 to 2'},
            {t = 'chat', re = 'Putting this here like this%.%.%.', after = 's12', why = 'Leodarion 97 (say #10288)'},
            {t = 'ki', id = 470, gained = false, after = 's12', conf = 'inferred', why = 'old trick box handed over'},
            {t = 'event', zone = 247, event = 98, after = 's12', conf = 'inferred', why = 'Leodarion 98: his reminder, only after 97'},
         }},
        {id = 's14', kind = 'note', with = 's16', at = {n = 14, fp = 'go to kuftal tunnel and obtain'}},
        {id = 's16', at = {n = 16, fp = 'find and open the treasure coffer'},
         done = {
            {t = 'ki', id = 471, gained = true, why = 'large trick box obtained'},
            {t = 'ki_have', id = 471, have = true, why = 'large trick box held'},
            {t = 'chat', re = 'obtained key item: large trick box', why = 'chat: key item obtained'},
         }},
        {id = 's17', at = {n = 17, fp = 'return to leodarion to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 471, gained = false, after = 's16', why = 'large trick box taken (only when the quest completes)'},
            {t = 'event', zone = 247, event = 99, after = 's16', conf = 'inferred', why = 'Leodarion 99: also plays on a full bag'},
            {t = 'chat', re = 'Yes%. I knew I could do it!', after = 's16', conf = 'inferred', why = 'Leodarion 99 (say #10327)'},
         }},
    },
}
