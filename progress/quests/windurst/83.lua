-- Step progress for Carbuncle Debacle (Windurst quest 83). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Walls/npcs/_6n2.lua (415 begins the quest and adds it to the log) and
-- Koru-Moru.lua (416 sends you to Ripapa, 417 gives the Daze-breaker charm, 418 is a reminder, 419 the ending cutscene);
-- Mhaura/npcs/Ripapa.lua (10022 first pendulum, 10023 a new one) and Rabao/npcs/Agado-Pugado.lua (86 first pendulum, 87 a new
-- one); client event scripts S4 239_Koru_Moru_010EF021.txt (416 say #8960/#8961, 417 say #8962, 418 say #8974),
-- 249_Ripapa_010F9068.txt (10022 say #7447, 10023 say #7426), 247_Agado_Pugado_010F7030.txt (86 say #10141). The pendulum events
-- 10022, 10023, 86 and 87 play whether or not a slot is free (the item is added afterwards), as does the ending 419, so the
-- "Obtained" line proves the pendulum steps and the completed bit the last one. The fights and their travel (bullets 4 to 6 and
-- 9 and 11; 10 is in an indented list) leave no strong signal and are notes on the Koru-Moru step that follows. The quest log is set at s1, so it is not
-- silent. Repeatable after a Memory reset: 415 opens the next run.
-- Chat 'Obtained: .*Pendulum' also matched the Ice (windurst/82) and Earth (windurst/81) Pendulum lines: tightened to the Lightning Pendulum.
return {
    title = 'Carbuncle Debacle',
    completes = 's12',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'interact with the house of the'},
         done = {
            {t = 'event', zone = 239, event = 415, why = 'House of the Hero 415: begins the quest'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to koru moru at e'},
         done = {
            {t = 'event', zone = 239, event = 416, why = 'Koru-Moru 416: go and see Ripapa'},
            {t = 'chat', re = "Hurry on over and see what's hap%-happily%-happened", why = 'Koru-Moru 416 (say #8961)'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to mhaura and speak to'},
         done = {
            {t = 'chat', re = 'Obtained: L[%a%.]*[g%.] Pendulum', why = 'ITEM_OBTAINED, added after 10022 or 10023 when a slot is free'},
            {t = 'item', id = 1172, gained = true, why = 'Lightning Pendulum gained'},
         },
         reach = {
            {t = 'event', zone = 249, event = 10022, why = 'Ripapa 10022 (also plays on a full bag)'},
            {t = 'chat', re = 'Please take this%. / North of here', why = 'Ripapa 10022 (say #7450)'},
            {t = 'event', zone = 249, event = 10023, why = 'Ripapa 10023: a new pendulum (also plays on a full bag)'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'the cutscene that follows the next'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'trade the lightning pendulum to the'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'defeat both lightning gremlin and thunder'}},
        {id = 's7', at = {n = 7, fp = 'return to windurst walls and speak'},
         done = {
            {t = 'event', zone = 239, event = 417, why = 'Koru-Moru 417: gives the Daze-breaker charm'},
            {t = 'ki', id = 448, gained = true, why = 'daze-breaker charm obtained'},
            {t = 'ki_have', id = 448, have = true, why = 'daze-breaker charm held'},
            {t = 'chat', re = 'obtained key item: daze%-breaker charm', why = 'chat: key item obtained'},
            {t = 'event', zone = 239, event = 418, conf = 'inferred', why = 'Koru-Moru 418: the reminder, only once 417 is done'},
         }},
        {id = 's8', at = {n = 8, fp = 'head to rabao and talk to'},
         done = {
            {t = 'chat', re = 'Obtained: Wind Pendulum', why = 'ITEM_OBTAINED, added after 86 or 87 when a slot is free'},
            {t = 'item', id = 1174, gained = true, why = 'Wind Pendulum gained'},
         },
         reach = {
            {t = 'event', zone = 247, event = 86, why = 'Agado-Pugado 86 (also plays on a full bag)'},
            {t = 'event', zone = 247, event = 87, why = 'Agado-Pugado 87: a new pendulum (also plays on a full bag)'},
         }},
        {id = 's9', kind = 'note', with = 's12', at = {n = 9, fp = 'trade the wind pendulum to the'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'defeat ogmios who is a manticore'}},
        {id = 's12', at = {n = 12, fp = 'return to windurst walls and talk'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 239, event = 419, why = 'Koru-Moru 419: ending cutscene (also plays on a full bag)'},
         }},
    },
}
