-- Step progress for Lure of the Wildcat (Jeuno quest 90). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Lure_of_the_Wildcat_Jeuno.lua (the draft cited the Bastok, San d'Oria and
-- Windurst quests of the same name; this is the Jeuno one). Ajithaam 10088 plays whatever the player answers, gives the White
-- Sentinel badge and begins the quest; each of the twenty NPCs plays one event once (the page lists them as indented
-- bullets, which are never steps); Ajithaam 10091 plays only when all twenty bits are set, and its finish takes the badge,
-- shows "Lost key item" and runs quest:complete (the White invitation card is its reward key item, so only supporting);
-- 10089 and 10090 are his reminders while accepted; 10177 is the 300 gil teleport trade, which only starts for a valid trade
-- by a player who has completed the quest and reached the Whitegate missions (the event script S4 244_Ajithaam_010F40AF.txt
-- has 10088 say #11113). Key item ids from res/key_items.lua (746 badge, 756 card). Bullet 4 (Naja Salaheem in Aht Urhgan)
-- has no signal here and stays plain. The card (756) is also used by the Invitation Cards flow, so it counts only after s2. Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'Lure of the Wildcat (Jeuno)',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ajithaam to recieve a'},
         done = {
            {t = 'event', zone = 244, event = 10088, why = 'Ajithaam 10088: the badge and the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 746, gained = true, why = 'white Sentinel badge obtained'},
            {t = 'ki_have', id = 746, have = true, why = 'white Sentinel badge held'},
            {t = 'chat', re = 'obtained key item: white sentinel badge', why = 'chat: key item obtained'},
            {t = 'event', zone = 244, event = 10089, conf = 'inferred', why = 'Ajithaam 10089: reminder, only while accepted with no one spoken to'},
            {t = 'event', zone = 244, event = 10090, conf = 'inferred', why = 'Ajithaam 10090: reminder, only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with the following people'},
         done = {
            {t = 'event', zone = 244, event = 10091, why = 'Ajithaam 10091: plays only once all twenty have been spoken to'},
         }},
        {id = 's3', at = {n = 3, fp = 'once you have spoken to all'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 746, gained = false, after = 's1', why = 'white Sentinel badge handed over'},
            {t = 'chat', re = 'lost key item: white sentinel badge', why = 'Ajithaam 10091 finish (KEYITEM_LOST)'},
            {t = 'ki', id = 756, gained = true, after = 's2', conf = 'inferred', why = 'white invitation card obtained (reward)'},
         },
         reach = {{t = 'event', zone = 244, event = 10091, why = 'Ajithaam 10091 under way'}}},
        {id = 's5', kind = 'post', at = {n = 5, fp = 'after joining salaheem s sentinels ajithaam'},
         done = {
            {t = 'event', zone = 244, event = 10177, after = 's3', why = 'Ajithaam 10177: the 300 gil teleport to Whitegate'},
         }},
    },
}
