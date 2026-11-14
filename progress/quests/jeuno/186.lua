-- Step progress for The Flying Machine of Eld (Jeuno quest 186). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for the quest (scripts/globals/quests.lua names no entry for 186) and the client's
-- event script for Mapitoto (S4 244_Mapitoto_010F4100.txt) has bodies only for 10223 to 10226 (Full Speed Ahead!); the
-- Strange Apparatus in Fei'Yin has none. So the proof is the quest's own temporary key items, each handed out at one bullet
-- (ids from res/key_items.lua: 3166 broken flying machine, 3167 levitation device, 3168 whirring engine) and the quest log's
-- completed bit for the last bullet, where the Levitus key (3095, a mount key item that may already be owned) is the reward.
-- The report-back, the apparatus and trade bullets and the notes carry no key item, event or line of their own: plain
-- bullets. Not repeatable (page meta).
return {
    title = 'The Flying Machine of Eld',
    completes = 's19',
    known = {{t = 'quest'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'complete the the celestial nexus ii'},
         done = {
            {t = 'ki', id = 3166, gained = true, why = 'broken flying machine obtained'},
            {t = 'ki_have', id = 3166, have = true, why = 'broken flying machine held'},
            {t = 'chat', re = 'obtained key item: broken flying machine', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'obtain a ve lugannon coffer key'},
         done = {
            {t = 'ki', id = 3167, gained = true, why = 'levitation device obtained'},
            {t = 'ki_have', id = 3167, have = true, why = 'levitation device held'},
            {t = 'chat', re = 'obtained key item: levitation device', why = 'chat: key item obtained'},
         }},
        {id = 's18', at = {n = 18, fp = 'trade the stacks of clusters to'},
         done = {
            {t = 'ki', id = 3168, gained = true, why = 'whirring engine obtained'},
            {t = 'ki_have', id = 3168, have = true, why = 'whirring engine held'},
            {t = 'chat', re = 'obtained key item: whirring engine', why = 'chat: key item obtained'},
         }},
        {id = 's19', at = {n = 19, fp = 'return to mapitoto to get the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 3095, gained = true, conf = 'inferred', why = 'Levitus key obtained (reward)'},
         }},
    },
}
