-- Step progress for Soul Siphon (Seekers of Adoulin mission 3-6-2, page id 242). Data only; see progress/missions/asa/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/3_6_2_Soul_Siphon.lua. The Hollowed Pathway (Kamihr Drifts 267) plays event 32, a
-- "Proceed?" menu (client S4 267_Hollowed_Pathway: Yes / No), and only the Yes branch sends the player into Cirdas Caverns (270),
-- where zone-in cutscene 29 plays only at that status (a No leaves it unset). Zoning back to Kamihr Drifts completes the mission
-- with no cutscene of its own. So event 32 is not proof (it plays on a refusal too) and is only `reach`; the Cirdas Caverns
-- zone-in 29 proves the "Proceed" bullet. The adoulin line has no completed set; its value is the page id (LandSandBoat enum * 2 + 0x6E),
-- so the mission ending is `min = 243`. Rejected: Levil 152 (a reminder dialogue while current).
return {
    title = 'Soul Siphon',
    completes = 's2',
    known = {{t = 'mission', line = 'adoulin', eq = 242}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'go to southwest corner of g'}},
        {id = 's2', at = {n = 2, fp = 'choose to proceed for a cutscene'},
         done = {
            {t = 'zonein', zone = 270, event = 29, why = 'Cirdas Caverns zone-in cutscene 29 (played only after answering Proceed)'},
            {t = 'mission', line = 'adoulin', min = 243, why = 'mission log: the line moved past Soul Siphon'},
         },
         reach = {
            {t = 'event', zone = 267, event = 32, why = 'Hollowed Pathway 32 offered (a Yes/No menu; only Yes proceeds)'},
         }},
    },
}
