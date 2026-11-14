-- Step progress for I'll Take the Big Box (Outlands quest 144). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Ill_Take_the_Big_Box.lua. Ryoma 135 is a progressEvent whose finish begins the
-- quest with no menu; Ensetsu 264 (Prog 0) is the Port Bastok talk and 265 its reminder; Leodarion 90 (Prog 1) is the first talk
-- and where he asks for the Oak Pole (91 is the reminder), 92 is the Oak Pole trade (played only when the pole matches), 93 the
-- "come back tomorrow" reminder, 94 gives the Seance staff (465) the next Vana'diel day and 95 is the sail-at-night reminder.
-- The ferry trip has no event: Enagakure's death sets Prog 5 silently, and the Selbina zone-in event 1101 (only at Prog 5) is the
-- completion cutscene that runs quest:complete and takes the staff. Bullets 6 to 8 are the trip and the fight, notes on that
-- step. Client event script S4 247_Leodarion_010F7037.txt (90 say #10268, 91 say #10278, 92 say #10279, 93 say #10280, 94 say
-- #10282, 95 say #10282), 236_Ensetsu_010EC025.txt (265 say #8503; 264 has no line), 252_Ryoma_010FC03A.txt (135 say #10631);
-- there is no client script for 1101 (LandSandBoat only). The quest log is set at s1, so it is not silent. The page says
-- repeatable; nothing observable marks a second run (LandSandBoat has none), so there is no `repeatable` entry.
-- Draft corrections: 265 and 90 were on the wrong bullets (264 is the Ensetsu talk, 90 the Leodarion talk), bullet 5 held
-- events 93/95 that belong to bullets 4 and 5's gaps, and the completion was the Leodarion reminder; completion is the Selbina
-- zone-in with the log's completed bit, not bullet 5.
return {
    title = "I'll Take the Big Box",
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to norg and speak with'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ryoma 135)'},
            {t = 'event', zone = 252, event = 135, why = 'Ryoma 135: begins the quest, no menu'},
            {t = 'chat', re = 'But it still looks a helluva lot like the work of the greatest pirate inventor that ever lived%-%-Mitsunari the Poisonclaw%.', why = 'Ryoma 135 (say #10631)'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to ensetsu in port bastok'},
         done = {
            {t = 'event', zone = 236, event = 264, after = 's1', why = 'Ensetsu 264: first talk, Prog 0'},
            {t = 'event', zone = 236, event = 265, conf = 'inferred', why = 'Ensetsu 265: his reminder, only after 264'},
            {t = 'chat', re = "The information that Yomi came across on that mission was from Mitsunari's grandson%.", conf = 'inferred', why = 'Ensetsu 265 (say #8503)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to rabao and talk to'},
         done = {
            {t = 'event', zone = 247, event = 90, after = 's1', why = 'Leodarion 90: first talk, Prog 1'},
            {t = 'chat', re = 'You are the ninja that found the', why = 'Leodarion 90 (say #10268)'},
            {t = 'event', zone = 247, event = 91, conf = 'inferred', why = 'Leodarion 91: his oak pole reminder, only after 90'},
            {t = 'chat', re = "To call forth the spirit in my grandfather's trap, the diary says I need", conf = 'inferred', why = 'Leodarion 91 (say #10278)'},
         }},
        {id = 's4', at = {n = 4, fp = 'leodarion will request an oak pole'},
         done = {
            {t = 'event', zone = 247, event = 92, after = 's3', why = 'Leodarion 92: the Oak Pole accepted (Prog 2)'},
            {t = 'chat', re = 'Come back tomorrow, and I.ll show you the result%.', after = 's3', why = 'Leodarion 92 (say #10279)'},
            {t = 'event', zone = 247, event = 93, after = 's3', conf = 'inferred', why = 'Leodarion 93: the not-yet-finished reminder, only after 92'},
            {t = 'chat', re = "Now I can complete my grandfather's trap!", after = 's3', conf = 'inferred', why = 'Leodarion 93 (say #10280)'},
         }},
        {id = 's5', at = {n = 5, fp = 'after trading it to him speak'},
         done = {
            {t = 'event', zone = 247, event = 94, after = 's4', why = 'Leodarion 94: gives the Seance staff the next day'},
            {t = 'chat', re = 'With this, I can finally call forth the spirit and complete my grandfather.s work%.', after = 's4', why = 'Leodarion 94 (say #10281)'},
            {t = 'ki', id = 465, gained = true, why = 'seance staff obtained'},
            {t = 'ki_have', id = 465, have = true, why = 'seance staff held'},
            {t = 'chat', re = 'obtained key item: seance staff', why = 'chat: key item obtained'},
            {t = 'event', zone = 247, event = 95, after = 's4', conf = 'inferred', why = 'Leodarion 95: the sail-at-night reminder, only after 94'},
         }},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'once in mhaura take the ferry'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'the nm enagakure will spawn on'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'once you have defeated enagakure make'}},
        {id = 's9', at = {n = 9, fp = 'you will receive a cutscene ninja'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'zonein', zone = 248, event = 1101, after = 's5', why = 'Selbina zone-in 1101, only at Prog 5: the cutscene runs quest:complete'},
            {t = 'ki', id = 465, gained = false, after = 's5', why = 'seance staff taken at the completion'},
         }},
    },
}
