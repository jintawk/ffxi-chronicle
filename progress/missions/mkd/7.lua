-- Step progress for Lender Beware! Read the Fine Print (A Moogle Kupo d'Etat mission 8, mission id 7). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/08_Lender_Beware_Read_the_Fine_Print.lua and
-- the client's event pseudo-code, 176_Shady_Sconce_010B0220.txt. Three steps of mission status. Status 0: the Shady Sconce in Sea
-- Serpent Grotto (176) plays 19, and only option 1 sets status 1, so 19 is `reach`; at status 1 the sconce plays 22 instead (a
-- reminder, client line say #7601 "Yer lookin' for the boss, y'say?" on the "hold out your hand" yes branch), and the Waterfall Basin
-- 20 plays only at status 1, so 22 and its line prove bullet 1 (and 20, further on, implies it). Bullet 2 (the Sahagin Key and the
-- Ornamental Door) leaves no signal: a note on the basin step. Bullet 3: Waterfall Basin 20 (a plain cutscene, its finish sets status
-- 2). Bullet 4: the Inconspicuous Door in Upper Jeuno (244) plays 10184 at status 2 and its finish calls mission:complete. The mkd line
-- has no completed set in Chronicle (core/data.lua get_mission_read), so the completion is also the line moving past it (min = 8). LandSandBoat's
-- mission 9 script copies this one's events 19, 20 and 10184 as placeholders; that page does not use them.
return {
    title = 'Lender Beware! Read the Fine Print',
    completes = 's4',
    known = {{t = 'mission', line = 'mkd', eq = 7}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 7, why = 'mission line: current mission = Lender Beware! Read the Fine Print'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to sea serpent grotto and'},
         done = {
            {t = 'chat', re = "Yer lookin' for the boss, y'say%?", why = 'Shady Sconce 22 (say #7601): the reminder that only plays at status 1, after the cutscene was accepted'},
            {t = 'event', zone = 176, event = 22, conf = 'inferred', why = 'Shady Sconce 22: plays only at status 1 (LandSandBoat)'},
         },
         reach = {
            {t = 'event', zone = 176, event = 19, why = 'Shady Sconce 19 offered (its finish needs option 1)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'use a sahagin key to enter'}},
        {id = 's3', at = {n = 3, fp = 'continue to sea serpent grotto map'},
         done = {
            {t = 'event', zone = 176, event = 20, why = 'Waterfall Basin 20: the cutscene (plays only at status 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to the inconspicuous door in'},
         done = {
            {t = 'event', zone = 244, event = 10184, why = 'Inconspicuous Door 10184: the cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', eq = 8, why = "mission line: moved on to Rescue! A Moogle's Labor of Love (this one completed)"},
         }},
    },
}
