-- Step progress for Promotion: Corporal (Aht Urhgan quest 93). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Corporal.lua (Naja Salaheem 5045 offers and begins the quest with
-- no choice and gives the Quartz transmitter, 824; while it is held Naja plays 5047, whose line says to put it at a hoofprint;
-- clicking a Warhorse Hoofprint in Bhaflau Thickets, Caedarva Mire, Mount Zhayolm or Wajaom Woodlands deletes the transmitter
-- and nothing else does; without it Naja plays 5046, whose finish runs quest:complete); client event script S4
-- 050_Naja_Salaheem_0103208C.txt (5047 say #6742-6744; 5045 and 5046 have no text). The quest log goes current with the first
-- talk, so it belongs to bullet 1. The last bullet in the page is a link to a Japanese tracking wiki, not a step. Not repeatable.
return {
    title = 'Promotion: Corporal',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to naja to receive the'},
         done = {
            {t = 'event', zone = 50, event = 5045, why = 'Naja Salaheem 5045: begins the quest, gives the transmitter'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 824, gained = true, why = 'Quartz transmitter obtained'},
            {t = 'ki_have', id = 824, have = true, why = 'Quartz transmitter held'},
            {t = 'chat', re = 'obtained key item: quartz transmitter', why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 5047, why = 'Naja Salaheem 5047: his talk while the transmitter is held'},
            {t = 'chat', re = 'The Dark Rider has been most frequently sighted', why = 'Naja Salaheem 5047 (say #6742)'},
         }},
        {id = 's2', at = {n = 2, fp = 'find the warhorse hoofprint and click'},
         done = {
            {t = 'ki', id = 824, gained = false, after = 's1', why = 'Quartz transmitter placed at the hoofprint'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to naja to complete the'},
         done = {
            {t = 'event', zone = 50, event = 5046, why = 'Naja Salaheem 5046: runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
