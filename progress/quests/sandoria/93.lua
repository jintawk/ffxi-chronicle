-- Step progress for The Holy Crest (San d'Oria quest 93). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_San_dOria/npcs/{Arminibit,Ceraulian}.lua (24 while the quest is available),
-- Bostaunieux_Oubliette/npcs/Novalmauge.lua (6 at TheHolyCrest_Event 1, sets 2), Northern_San_dOria/npcs/Morjean.lua (65 at 2:
-- addQuest, sets 3; 62 with the Wyvern Egg at 3 or at 4), Maze_of_Shakhrami/npcs/Excavation_Point.lua (the Pickaxe trade gives the
-- egg, no event), Meriphataud_Mountains/npcs/qm1.lua (trading the egg is event 56, sets 5), Chateau_dOraguille/npcs/Rahal.lua (60
-- at 5 gives key item 294, 122 is the reminder once it is held), battlefields/Ghelsba_Outpost/holy_crest.lua (the win takes key
-- item 294 and completes the quest). Client event scripts S4 232_Arminibit_010E8047.txt (24 say #8338) and 233_Rahal_010E9008.txt
-- (60 and 122 say #6730); the other events are not in the decoded scripts, so they rest on the event id and zone. The draft put
-- the completed bit on the Rahal bullet (n=8 is the remedy, n=10 the fight) and guessed every middle bullet. The quest log stays
-- silent until Morjean 65 (s3) adds the quest; it is completed by the Ghelsba win (s10). Bullets 4-5 (Pickaxe, excavation) lead
-- into the Morjean talk with the egg; bullet 9 (Ghelsba, the Hut Door) leads into the fight. Bullets 11-12 (renaming, history)
-- are not steps.
return {
    title = 'The Holy Crest',
    completes = 's10',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to arminibit and ceraulian in'},
         done = {
            {t = 'event', zone = 232, event = 24, why = 'Arminibit or Ceraulian 24: sets TheHolyCrest_Event 1'},
            {t = 'chat', re = 'You hear more and more talk of the Dragon King Ranperre these days%.', why = 'Arminibit 24 (say #8338)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to novalmauge who walks between'},
         done = {
            {t = 'event', zone = 167, event = 6, why = 'Novalmauge 6: only at TheHolyCrest_Event 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to morjean in northern san'},
         done = {
            {t = 'event', zone = 231, event = 65, why = 'Morjean 65: adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted (Morjean 65)'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'if you don t already happen'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'go to the maze of shakhrami'}},
        {id = 's6', at = {n = 6, fp = 'return to morjean and speak to'},
         done = {
            {t = 'event', zone = 231, event = 62, why = 'Morjean 62: only with the Wyvern Egg (state 3) or after it (state 4)'},
         }},
        {id = 's7', at = {n = 7, fp = 'travel to meriphataud mountains k 8'},
         done = {
            {t = 'event', zone = 119, event = 56, why = 'Meriphataud ??? 56: the Wyvern Egg accepted'},
         }},
        {id = 's8', at = {n = 8, fp = 'speak to rahal in chateau d'},
         done = {
            {t = 'event', zone = 233, event = 60, why = 'Rahal 60: gives the Dragon Curse Remedy'},
            {t = 'event', zone = 233, event = 122, conf = 'inferred', why = 'Rahal 122: reminder, only once the remedy is held'},
            {t = 'chat', re = "Oh, it's you%. Fear not; the precious dragon is not in danger%.", why = 'Rahal 60 / 122 (say #6730)'},
            {t = 'ki', id = 294, gained = true, why = 'dragon curse remedy obtained'},
            {t = 'ki_have', id = 294, have = true, why = 'dragon curse remedy held'},
            {t = 'chat', re = 'obtained key item: dragon curse remedy', why = 'chat: key item obtained'},
         }},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'travel to ghelsba outpost to find'}},
        {id = 's10', at = {n = 10, fp = 'upon defeating the wyvern you will'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the Ghelsba win)'},
            {t = 'ki', id = 294, gained = false, conf = 'inferred', why = 'dragon curse remedy used up in the fight'},
         }},
    },
}
