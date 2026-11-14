-- Step progress for Blue Ribbon Blues (Windurst quest 17). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Blue_Ribbon_Blues.lua (Kerutoto 358 is the Purple Ribbon trade that begins the
-- quest and pays 3,600 gil; 357 is his available-state talk and Roberta 376/377/379 hand out the ribbon before the quest, so
-- none of them prove anything; while accepted Kerutoto plays 359 (waiting), 360 (gives the ribbon back), 361 and 366 (talks
-- at Prog 1) and 365 (the ribbon again), all accepted-only; the Hume Bones trade has no event, it shows the zone text
-- RETURN_RIBBON_TO_HER only once the Lich C Magnus popped and the ribbon was taken; the Bones give the Blue Ribbon on a later
-- trigger with the zone's ITEM_OBTAINED; Kerutoto 362 plays only at Prog 3 (Blue Ribbon received) and runs quest:complete, which
-- has no item reward, so it proves the last bullet). The page has no bullet for the return to Kerutoto, so the completed bit
-- and 362 belong to the last bullet (the Blue Ribbon), which they imply. Client event script S4 238_Kerutoto_010EE02F.txt (358
-- say #8146, 359 #8148, 362 #8155, 365 #8159, 366 #8162); text from The_Eldieme_Necropolis IDs.lua. The Purple Ribbon can come
-- from elsewhere (Roberta, Conquest tally), so it proves nothing. The travel bullets lead into the Hume Bones trade. The quest
-- log is set at s1, so it is not silent.
return {
    title = 'Blue Ribbon Blues',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'give the purple ribbon to kerutoto'},
         done = {
            {t = 'event', zone = 238, event = 358, why = 'Kerutoto 358: the Purple Ribbon trade begins the quest'},
            {t = 'chat', re = "What's this grubby little ribbon you brought me%?", why = 'Kerutoto 358 (say #8146)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 359, why = 'Kerutoto 359: waiting talk, only once accepted'},
            {t = 'chat', re = 'I enjoy collecting strange or mysterious things%.', why = 'Kerutoto 359 (say #8148)'},
            {t = 'event', zone = 238, event = 360, why = 'Kerutoto 360: gives the ribbon back, only once accepted'},
            {t = 'event', zone = 238, event = 361, why = 'Kerutoto 361: talk with the ribbon, only once accepted'},
            {t = 'event', zone = 238, event = 365, why = 'Kerutoto 365: the ribbon again, only once accepted'},
            {t = 'chat', re = 'Hey, is that the same ribbon as before%?', why = 'Kerutoto 365 (say #8159)'},
            {t = 'event', zone = 238, event = 366, why = 'Kerutoto 366: talk without the ribbon, only once accepted'},
            {t = 'chat', re = 'Well, if it happens to come your way again, please bring it to me', why = 'Kerutoto 366 (say #8162)'},
         }},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'go to the eldieme necropolis from'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'upon entering go straight until you'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'follow the path west until you'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'go north through titan s gate'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'after the fall go east to'}},
        {id = 's7', at = {n = 7, fp = 'trade the purple ribbon to hume'},
         done = {
            {t = 'chat', re = 'You can hear a voice from somewhere', why = 'RETURN_RIBBON_TO_HER: the ribbon taken and the Lich C Magnus popped'},
         }},
        {id = 's8', at = {n = 8, fp = 'check the hume bones again after'},
         done = {
            {t = 'chat', re = 'Obtained: .-Blue ribbon', why = 'ITEM_OBTAINED from the Hume Bones'},
            {t = 'event', zone = 238, event = 362, why = 'Kerutoto 362: only at Prog 3 (Blue Ribbon received), completes'},
            {t = 'chat', re = 'You were able to purify that cursed ribbon%?', why = 'Kerutoto 362 (say #8155)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 12521, gained = true, conf = 'inferred', why = 'Blue Ribbon gained (items can come from elsewhere)'},
         }},
    },
}
