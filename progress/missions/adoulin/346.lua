-- Step progress for Watery Grave (Seekers of Adoulin mission, page id 346). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_3_2_Watery_Grave.lua (the instance itself is not implemented there). Entering the
-- fight turns the Ash runic board (key item 2626) into a Blank ash runic board (2640; the page's sub-bullet), and a lost fight turns
-- it back on the next zone-in, so the blank board's gain (and the Ash board's loss) proves bullet 1, the entry. The win sends you to
-- Rala Waterways (258) where onZoneIn plays 375 only at status 1; its finish completes the mission and gives Teodor's blood sigil
-- (2627), the aged Undying Naakual crest (2165, permanent) and the message about the three blood sigils, so those and the line
-- (`min = 347`; the adoulin line has no completed set, packet value = page id) prove bullet 3. The zone-in 375 is only `reach`:
-- LandSandBoat sets status 1 from an assumed battlefield-clear event, so it cannot be told apart from a play that never finishes.
-- Rejected: the draft's `? 1000` event (zone 259, LandSandBoat's own TODO guess, and it was placed on the entry), the Blank board's
-- loss as proof of the win (the failed-fight conversion takes it too), and `completed = true`. Bullet 2 (the fight) is a note.
return {
    title = 'Watery Grave',
    completes = 's3',
    known = {{t = 'mission', line = 'adoulin', eq = 346}},
    groups = {main = {start = {{t = 'mission', line = 'adoulin', eq = 346, why = 'mission line: current mission = Watery Grave'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the entrance coliseum at rala'},
         done = {
            {t = 'ki', id = 2640, gained = true, why = 'Blank ash runic board obtained on entering the battle'},
            {t = 'ki', id = 2626, gained = false, why = 'Ash runic board taken on entering the battle'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'this fight will be against teodor'}},
        {id = 's3', implies = {'s1'}, at = {n = 3, fp = 'after defeating teodor there will be'},
         done = {
            {t = 'ki', id = 2627, gained = true, why = "Teodor's blood sigil obtained (zone-in 375 finish, completes the mission)"},
            {t = 'ki', id = 2165, gained = true, why = 'aged Undying Naakual crest obtained (zone-in 375 finish)'},
            {t = 'chat', re = 'the three blood sigils begin to pulse', why = 'Rala Waterways text on the win (LandSandBoat zone text)'},
            {t = 'mission', line = 'adoulin', min = 347, why = 'mission line: the line moved past Watery Grave'},
         },
         reach = {
            {t = 'zonein', zone = 258, event = 375, why = 'Rala Waterways zone-in 375 after the win'},
         }},
    },
}
