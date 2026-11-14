-- Step progress for Gatherer of Light (I) (A Crystalline Prophecy mission 3, mission id 2). Data only; see progress/missions/acp/1.lua.
-- Evidence: LandSandBoat scripts/zones/Batallia_Downs/mobs/Goblin_*.lua, Rolanberry_Fields and Sauromugue_Champaign (the goblin food
-- key items drop from any goblin, 1085 bowl of bland Goblin salad, 1086 jug of greasy Goblin juice, 1087 chunk of smoked Goblin grub;
-- the NMs Vegnix Greenthumb, Chuglix Berrypaws and Dribblix Greasemaw give Seedspall Roseum 1088, Caerulum 1089 and Viridis 1090),
-- zones/Qufim_Island/npcs/qm3.lua (event 32 plays with all three Seedspalls held on this mission, completes it and deletes them),
-- zones/Port_Jeuno/npcs/Squintrox_Dryeyes.lua (event 323, a menu that proves nothing; the Viridian Key 1106 for the three food key
-- items, which it takes) and zones/Lower_Jeuno/npcs/Treasure_Coffer_Tenshodo.lua (the coffer deletes the key when a prize is given).
-- The three goblin chains can be done in any order, so each of the six chain bullets is a group of its own (opened by the line being
-- at this mission); the strip joins them into one row. Within a chain the NM needs the food held, but the food is kept, so both bullets
-- tick from their own key item gain, and the login read ticks what is still held. The page has no bullet for the Qufim cutscene
-- that completes the mission (only a closing sentence, which is not a bullet), so each chain bullet also carries the acp line having
-- moved to 3 (event 32 needs all three Seedspalls, so every chain is done by then) and s10 is `completes`. The food and Seedspall key
-- items come back on a repeat and only re-tick. Bullets 13 and 14 are the repeat reward and post steps: the Viridian Key's only
-- source is the Squintrox trade and the coffer deletes it. The Seedspall drop in LandSandBoat needs "mission >= The Echo Awakens",
-- the page says on or past this mission; neither matters here (a gain is a gain).
return {
    title = 'Gatherer of Light (I)',
    completes = 's10',
    known = {{t = 'mission', line = 'acp', eq = 2}},
    groups = {
        bat_food = {start = {{t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current'}}},
        bat_nm = {start = {{t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current'}}},
        rol_food = {start = {{t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current'}}},
        rol_nm = {start = {{t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current'}}},
        sau_food = {start = {{t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current'}}},
        sau_nm = {start = {{t = 'mission', line = 'acp', min = 2, why = 'mission line: Gatherer of Light (I) is current'}}},
    },
    steps = {
        {id = 's1', group = 'bat_food', kind = 'note', with = 's5', at = {n = 1, fp = 'any characters currently on or previously'}},
        {id = 's2', group = 'bat_food', kind = 'note', with = 's5', at = {n = 2, fp = 'these key items have a low'}},
        {id = 's3', group = 'bat_food', kind = 'note', with = 's5', at = {n = 3, fp = 'party alliance members do not have'}},
        {id = 's4', group = 'bat_nm', kind = 'note', with = 's6', at = {n = 4, fp = 'note you must have the respective'}},
        {id = 's5', group = 'bat_food', at = {n = 5, fp = 'kill goblins in batallia downs to'},
         done = {
            {t = 'ki', id = 1085, gained = true, why = 'bowl of bland Goblin salad obtained (Batallia Downs goblin)'},
            {t = 'ki_have', id = 1085, have = true, why = 'bowl of bland Goblin salad held'},
            {t = 'chat', re = 'obtained key item: bowl of bland goblin salad', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current, the Qufim cutscene needs all three Seedspalls'},
         }},
        {id = 's6', group = 'bat_nm', at = {n = 6, fp = 'examine the at f 5 middle'},
         done = {
            {t = 'ki', id = 1088, gained = true, why = 'Seedspall Roseum obtained (Vegnix Greenthumb)'},
            {t = 'ki_have', id = 1088, have = true, why = 'Seedspall Roseum held'},
            {t = 'chat', re = 'obtained key item: seedspall roseum', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current, the Qufim cutscene needs all three Seedspalls'},
         }},
        {id = 's7', group = 'rol_food', at = {n = 7, fp = 'kill goblins in rolanberry fields to'},
         done = {
            {t = 'ki', id = 1086, gained = true, why = 'jug of greasy Goblin juice obtained (Rolanberry Fields goblin)'},
            {t = 'ki_have', id = 1086, have = true, why = 'jug of greasy Goblin juice held'},
            {t = 'chat', re = 'obtained key item: jug of greasy goblin juice', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current, the Qufim cutscene needs all three Seedspalls'},
         }},
        {id = 's8', group = 'rol_nm', at = {n = 8, fp = 'examine the at d 11 ne'},
         done = {
            {t = 'ki', id = 1089, gained = true, why = 'Seedspall Caerulum obtained (Chuglix Berrypaws)'},
            {t = 'ki_have', id = 1089, have = true, why = 'Seedspall Caerulum held'},
            {t = 'chat', re = 'obtained key item: seedspall caerulum', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current, the Qufim cutscene needs all three Seedspalls'},
         }},
        {id = 's9', group = 'sau_food', at = {n = 9, fp = 'kill goblins in sauromugue champaign to'},
         done = {
            {t = 'ki', id = 1087, gained = true, why = 'chunk of smoked Goblin grub obtained (Sauromugue Champaign goblin)'},
            {t = 'ki_have', id = 1087, have = true, why = 'chunk of smoked Goblin grub held'},
            {t = 'chat', re = 'obtained key item: chunk of smoked goblin grub', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current, the Qufim cutscene needs all three Seedspalls'},
         }},
        {id = 's10', group = 'sau_nm', at = {n = 10, fp = 'examine the at j 9 almost'},
         done = {
            {t = 'ki', id = 1090, gained = true, why = 'Seedspall Viridis obtained (Dribblix Greasemaw)'},
            {t = 'ki_have', id = 1090, have = true, why = 'Seedspall Viridis held'},
            {t = 'chat', re = 'obtained key item: seedspall viridis', why = 'chat: key item obtained'},
            {t = 'mission', line = 'acp', min = 3, why = 'mission line: Gatherer of Light (II) is current, the Qufim cutscene needs all three Seedspalls'},
         }},
        {id = 's11', group = 'key', kind = 'note', with = 's13', at = {n = 11, fp = 'note goblin food key items are'}},
        {id = 's12', group = 'key', kind = 'note', with = 's13', at = {n = 12, fp = 're obtain a bowl of bland'}},
        {id = 's13', group = 'key', kind = 'post', at = {n = 13, fp = 'head to port jeuno and speak'},
         done = {
            {t = 'ki', id = 1106, gained = true, why = 'Viridian Key obtained (Squintrox Dryeyes)'},
            {t = 'ki_have', id = 1106, have = true, why = 'Viridian Key held'},
            {t = 'chat', re = 'obtained key item: viridian key', why = 'chat: key item obtained'},
         }},
        {id = 's14', group = 'key', kind = 'post', at = {n = 14, fp = 'use the viridian key level 40'},
         done = {
            {t = 'ki', id = 1106, gained = false, why = 'Viridian Key used at the Treasure Coffer (deleted when the prize is given)'},
         }},
    },
}
