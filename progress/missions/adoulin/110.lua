-- Step progress for Rumors from the West (Seekers of Adoulin mission 1-1, mission id 110). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/1_1_Rumors_from_the_West.lua and the client script S4 245_Darcia_010F50DF (event 10117).
-- The adoulin line holds the page id (LandSandBoat's enum * 2 + 0x6E) and has no completed set, so the completion is `min = 111`.
-- Bullet 1 is the optional zone-in scene of each starting nation (one per nation, played once while this mission is current).
-- Darcia's 10117 is a menu that plays on every visit and on "Nevermind", so it is not used. Bullet 2 is proved by two lines that
-- only the Yes branches say: #10279 ("Thank you for your interest ...", the apply option with no Geomagnetron yet) and #10316
-- ("Let me see...dot the I's ...", the 1,000,000 gil skip, which also finishes this mission). The Geomagnetron key item is a
-- reward that Iroha can also hand over, so it is not used. Dropped from the draft: the 10117 event and the `completed = true` matcher.
return {
    title = 'Rumors from the West',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 110}},
    steps = {
        {id = 's1', kind = 'optional', at = {n = 1, fp = 'after loading up the game for'},
         done = {
            {t = 'zonein', zone = 231, event = 878, why = "Northern San d'Oria zone-in scene 878 (once, while this mission is current)"},
            {t = 'zonein', zone = 235, event = 22, why = 'Bastok Markets zone-in scene 22 (once, while this mission is current)'},
            {t = 'zonein', zone = 241, event = 839, why = 'Windurst Woods zone-in scene 839 (once, while this mission is current)'},
         }},
        {id = 's2', at = {n = 2, fp = 'proceed to lower jeuno and speak'},
         done = {
            {t = 'chat', re = 'thank you for your interest in our pioneer partnership program%.', why = 'Darcia 10117 (say #10279): the apply option taken'},
            {t = 'chat', re = "let me see%.%.%.dot the i.s here", why = 'Darcia 10117 (say #10316): the skip paid, which also ends this mission'},
            {t = 'mission', line = 'adoulin', min = 111, why = 'mission log: the line moved past Rumors from the West'},
         }},
    },
}
