-- Step progress for Tuning Out (Windurst quest 91). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat Leepe-Hoppe.lua (888 begins the quest, 889 is the reminder, 897 is the reward and runs quest:complete
-- for the Cache-nez), Kazham/npcs/Jakoh_Wahcondalo.lua (293, then 294 as the reminder), Kazham/npcs/Romaa_Mihgo.lua (295, then
-- 296; 297 after the fight), Yuhtunga_Jungle/npcs/qm2.lua (28 starts the Nasus fight, 29 follows the kills), Norg/npcs/
-- Comitiolus.lua (207 takes the three foods; 206 and 208 are reminders), Beaucedine_Glacier/npcs/Torino-Samarino.lua (207, then
-- 208). The event ids repeat across zones, so every matcher carries its zone. The client holds text only for 889 and 897: 897 at
-- Leepe-Hoppe plays the reward lines (the helmet, say #10701 to #10703) and LandSandBoat completes the quest there, while Torino-
-- Samarino's 207 has no text in the client. The page says the log marks it complete at Torino's cutscene (bullet 10), but nothing in
-- the client supports that, so the completed bit sits on the last step (s11), like the reward. 897 also plays when the Cache-nez
-- cannot be given, so it is a reach and the completed bit and the Obtained line carry s11. Bullets 7 and 8 are notes on the trade.
-- The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'Tuning Out',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to leepe hoppe to initiate'},
         done = {
            {t = 'event', zone = 238, event = 888, why = 'Leepe-Hoppe 888: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 889, conf = 'inferred', why = 'Leepe-Hoppe 889: the reminder, only while accepted'},
            {t = 'chat', re = 'Put on your trunks and swim to Kazham!', conf = 'inferred', why = 'Leepe-Hoppe 889 (say #10700)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with jakoh wahcondalo at j'},
         done = {
            {t = 'event', zone = 250, event = 293, why = 'Jakoh Wahcondalo 293: Ildy meets Jakoh'},
            {t = 'event', zone = 250, event = 294, conf = 'inferred', why = 'Jakoh Wahcondalo 294: the reminder, only once 293 is done'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak with romaa mihgo at h'},
         done = {
            {t = 'event', zone = 250, event = 295, why = 'Romaa Mihgo 295: go to the waterfall'},
            {t = 'event', zone = 250, event = 296, conf = 'inferred', why = 'Romaa Mihgo 296: the hint, only once 295 is done'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to yuhtunga jungle k 7'},
         done = {
            {t = 'event', zone = 123, event = 28, why = 'Yuhtunga Jungle ??? 28: the five Nasus appear'},
         }},
        {id = 's5', at = {n = 5, fp = 'click the again after defeating the'},
         done = {
            {t = 'event', zone = 123, event = 29, why = 'Yuhtunga Jungle ??? 29: after the Nasus'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to kazham and speak with'},
         done = {
            {t = 'event', zone = 250, event = 297, why = 'Romaa Mihgo 297: the guard needs Habaneros, Black Curry and a Mutton Tortilla'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'to progress further you will need'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'head to norg k 8 to'}},
        {id = 's9', at = {n = 9, fp = 'trade all three food items to'},
         done = {
            {t = 'event', zone = 252, event = 207, why = 'Comitiolus 207: the three foods accepted'},
            {t = 'event', zone = 252, event = 208, conf = 'inferred', why = 'Comitiolus 208: the hint, only once 207 is done'},
         },
         reach = {{t = 'event', zone = 252, event = 206, why = 'Comitiolus 206: asked without the foods'}}},
        {id = 's10', at = {n = 10, fp = 'head to beaucedine glacier i 7'},
         done = {
            {t = 'event', zone = 111, event = 207, why = 'Torino-Samarino 207: Ildy meets his peers'},
            {t = 'event', zone = 111, event = 208, conf = 'inferred', why = 'Torino-Samarino 208: only once 207 is done'},
         }},
        {id = 's11', at = {n = 11, fp = 'speaking to leepe hoppe after completing'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Leepe-Hoppe 897)'},
            {t = 'chat', re = 'Obtained: Cache%-nez', after = 's10', why = 'ITEM_OBTAINED after Leepe-Hoppe 897 when a slot is free'},
            {t = 'item', id = 15180, gained = true, after = 's10', why = 'Cache-nez gained'},
         },
         reach = {{t = 'event', zone = 238, event = 897, why = 'Leepe-Hoppe 897 (also plays when the Cache-nez cannot be given)'}}},
    },
}
