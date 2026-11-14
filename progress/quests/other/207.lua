-- Step progress for Rowing Together (other quest 207). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script covers the Mog Garden (zone 280) or Lower Jeuno's
-- Muckvix's Junk Shop events. a Logger chat log, 2026-05-03: Zenicca sells "Sakura and the Holy Grail" for 11000
-- bayld (14:40); Stinknix's cutscene ends with "Obtained key item: Chacharoon's sack of supplies" (17:22); in the Rearing
-- Grounds Chacharoon's cutscene ends with "Lost key item: Chacharoon's sack of supplies" and the Thatch Boots (17:25).
-- The sack is a delivery (gained, then handed over), so its loss is a hand-in. The zone-in cutscene has no signal.
return {
    title = 'Rowing Together',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'continue monster rearing and purchase the'},
         done = {
            {t = 'ki', id = 2846, gained = true, why = '"Sakura and the Holy Grail" obtained (bought from Zenicca)'},
            {t = 'ki_have', id = 2846, have = true, why = '"Sakura and the Holy Grail" held'},
            {t = 'chat', re = 'obtained key item: "sakura and the holy grail"', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'enter your mog garden for a'}},
        {id = 's3', at = {n = 3, fp = 'head to muckvix s junk shop'},
         done = {
            {t = 'ki', id = 2990, gained = true, why = "Chacharoon's sack of supplies obtained (Stinknix)"},
            {t = 'ki_have', id = 2990, have = true, why = "Chacharoon's sack of supplies held"},
            {t = 'chat', re = "obtained key item: chacharoon's sack of supplies", why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to chacharoon not in the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2990, gained = false, why = "Chacharoon's sack of supplies handed over"},
         }},
    },
}
