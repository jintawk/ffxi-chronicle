-- Step progress for An Errand! The Professor's Price (A Moogle Kupo d'Etat mission 6, mission id 5). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/06_An_Errand_The_Professors_Price.lua, missions/amk/helpers.lua (cardianOrbDrop) and
-- the client's event pseudo-code, 239_Shantotto_010EF01A.txt. Bullets 1 and 3 are travel (notes). Bullet 2: Cardians in Outer
-- Horutoto Ruins (194) drop the four Orb key items (1139 Swords, 1140 Cups, 1141 Batons, 1142 Coins) only once the line is at this
-- mission or later; one gained or held is a drop (`reach`); the fight deleting an orb is the proof. Bullet 4 (the ??? battlefield, qm1 event 100, which
-- plays whenever an orb is held and only option 1 starts the fight) stays a plain bullet: its only signals are the Ripe starfruit (1143)
-- and Peach coral key rewards, which are not proof alone, and the orb loss already marks bullet 2. Bullet 5: Shantotto 508 (status 0, no starfruit) is the "still dawdling" reminder and proves nothing (the draft offered it); 507
-- plays when the starfruit is held and only option 1 pays the 5000 gil (the other option sets needToZone), so it is `reach`; paying
-- deletes the starfruit and sets status 1, after which Shantotto plays 509 ("Excellent, and very well! Now, off to Jeuno", say #9715 in
-- the client). The starfruit being handed over, 509 and its line therefore prove the payment. Bullet 6: the Inconspicuous Door in
-- Upper Jeuno (244) plays 10182 at status 1 and its finish calls mission:complete. The mkd line has no completed set in Chronicle
-- (core/data.lua get_mission_read), so the completion is also the line moving past it (min = 6). Bullets 7 and 8 (Peach coral key, repeat) stay
-- plain: Squintrox needs the line at the Fin mission first.
return {
    title = "An Errand! The Professor's Price",
    completes = 's6',
    known = {{t = 'mission', line = 'mkd', eq = 5}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 5, why = "mission line: current mission = An Errand! The Professor's Price"}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter the outer horutoto ruins from'}},
        {id = 's2', at = {n = 2, fp = 'kill cardians in the area to'},
         done = {
            {t = 'ki', id = 1139, gained = false, why = 'Orb of Swords taken at the fight'},
            {t = 'ki', id = 1140, gained = false, why = 'Orb of Cups taken at the fight'},
            {t = 'ki', id = 1141, gained = false, why = 'Orb of Batons taken at the fight'},
            {t = 'ki', id = 1142, gained = false, why = 'Orb of Coins taken at the fight'},
         },
         reach = {
            {t = 'ki', id = 1139, gained = true, why = 'Orb of Swords obtained (Cardian drop)'},
            {t = 'ki', id = 1140, gained = true, why = 'Orb of Cups obtained (Cardian drop)'},
            {t = 'ki', id = 1141, gained = true, why = 'Orb of Batons obtained (Cardian drop)'},
            {t = 'ki', id = 1142, gained = true, why = 'Orb of Coins obtained (Cardian drop)'},
            {t = 'ki_have', id = 1139, have = true, why = 'Orb of Swords held'},
            {t = 'ki_have', id = 1140, have = true, why = 'Orb of Cups held'},
            {t = 'ki_have', id = 1141, have = true, why = 'Orb of Batons held'},
            {t = 'ki_have', id = 1142, have = true, why = 'Orb of Coins held'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'after receiving the orbs you want'}},
        {id = 's5', at = {n = 5, fp = 'return to shantotto she will require'},
         done = {
            {t = 'ki', id = 1143, gained = false, why = 'Ripe starfruit handed over: the 5000 gil paid (507 option 1)'},
            {t = 'event', zone = 239, event = 509, why = 'Shantotto 509: plays after the payment (status 1)'},
            {t = 'chat', re = 'Excellent, and very well!', why = 'Shantotto 509 (say #9715)'},
         },
         reach = {
            {t = 'event', zone = 239, event = 507, why = 'Shantotto 507 offered (its finish needs option 1)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to the inconspicuous door in'},
         done = {
            {t = 'event', zone = 244, event = 10182, why = 'Inconspicuous Door 10182: the cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', min = 6, why = 'mission line: moved on to Shock! Arrant Abuse of Authority (this one completed)'},
         }},
    },
}
