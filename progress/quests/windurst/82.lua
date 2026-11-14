-- Step progress for Class Reunion (Windurst quest 82). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Walls/npcs/_6n2.lua (413 begins the quest and gives Carbuncle's Tear),
-- Koru-Moru.lua (412 takes the tear, 407 takes four Astragalos, 408 is a reminder, 410 the ending cutscene), Shantotto.lua
-- (409, needed before Gulmama), Windurst_Waters/npcs/{Fuepepe,Furakku-Norakku}.lua (817 and 816, flags needed for the ending),
-- Northern_San_dOria/npcs/Gulmama.lua (713 gives the Ice Pendulum, 712 a new one); client event script S4 239_Shantotto_010EF01A.txt
-- (409 say #8934), 238_Fuepepe_010EE036.txt (817 say #10045), 231_Gulmama_010E70C8.txt (713 and 712 both play on a full bag,
-- the item is only added afterwards, so the Obtained line proves the step). 410 also plays on a full bag (the quest is completed
-- only when the Evoker's Spats fit), so it is a reach and the completed bit carries the last step. Bullet 4 is three talks in
-- any order: only Shantotto's gates the next step, the other two are reach. Bullets 6 and 7 (travel, trade at the Protocrystal)
-- have no signal and are notes on the final step. Repeatable after a Memory reset: 413 opens the next run.
return {
    title = 'Class Reunion',
    completes = 's8',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'while your main job is summoner'},
         done = {
            {t = 'event', zone = 239, event = 413, why = 'House of the Hero 413: begins the quest'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
            {t = 'ki', id = 450, gained = true, why = "Carbuncle's Tear obtained"},
            {t = 'ki_have', id = 450, have = true, why = "Carbuncle's Tear held"},
            {t = 'chat', re = "obtained key item: carbuncle's tear", why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to koru moru in windurst'},
         done = {
            {t = 'event', zone = 239, event = 412, why = 'Koru-Moru 412: takes the tear, asks for four Astragalos'},
            {t = 'ki', id = 450, gained = false, conf = 'inferred', why = "Carbuncle's Tear handed over"},
            {t = 'event', zone = 239, event = 414, conf = 'inferred', why = 'Koru-Moru 414: the reminder, only once 412 is done'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade koru moru x4 astragalos'},
         done = {
            {t = 'event', zone = 239, event = 407, why = 'Koru-Moru 407: four Astragalos accepted'},
         }},
        {id = 's4', at = {n = 4, fp = 'he will task you to speak'},
         done = {
            {t = 'event', zone = 239, event = 409, why = 'Shantotto 409: Sunny-Pabonny went to San d\'Oria'},
            {t = 'chat', re = 'You want to know where to find Sunny%-Pabonny%?', why = 'Shantotto 409 (say #8934)'},
         },
         reach = {
            {t = 'event', zone = 238, event = 817, why = 'Fuepepe 817'},
            {t = 'chat', re = '%.%.%.I see%. He encountered Ildy%-Goldy in the Outlands%?', why = 'Fuepepe 817 (say #10045)'},
            {t = 'event', zone = 238, event = 816, why = 'Furakku-Norakku 816'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to gulmama in northern san'},
         done = {
            {t = 'chat', re = 'Obtained: Ice Pendulum', why = 'ITEM_OBTAINED, added after 713 or 712 when a slot is free'},
            {t = 'item', id = 1171, gained = true, why = 'Ice Pendulum gained'},
         },
         reach = {
            {t = 'event', zone = 231, event = 713, why = 'Gulmama 713 (also plays on a full bag)'},
            {t = 'event', zone = 231, event = 712, why = 'Gulmama 712: a new pendulum (also plays on a full bag)'},
         }},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'head to the cloister of frost'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'trade the ice pendulum to the'}},
        {id = 's8', at = {n = 8, fp = 'defeat them and then speak to'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 239, event = 410, why = 'Koru-Moru 410: ending cutscene (also plays on a full bag)'},
         }},
    },
}
