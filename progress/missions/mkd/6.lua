-- Step progress for Shock! Arrant Abuse of Authority (A Moogle Kupo d'Etat mission 7, mission id 6). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/07_Shock_Arrant_Abuse_of_Authority.lua, missions/amk/helpers.lua (chocoboDig) and
-- the client's event pseudo-code, 244_Inconspicuous_Door_010F40ED.txt. The Inconspicuous Door in Upper Jeuno (244) plays 10189 while
-- the Moldy, worm-eaten chest (key item 1144) is not held (say #12503, the digging zone reminder; it plays however often the door is
-- tried), so it is not proof of the dig and the draft's use of it on bullet 3 is dropped. Bullet 1 is the briefing (a note on the door step).
-- Bullet 2 (the dig) stays a plain bullet: its only signal is the chest key item 1144 (chocoboDig), a drop-style reward. Bullet 3: with the chest held the door plays 10183 (a plain cutscene
-- whose finish takes the chest and calls mission:complete). The mkd line has no completed set in Chronicle (core/data.lua
-- get_mission_read), so the completion is also the line moving past it (min = 7). Bullets 4 to 8 are the "A Moogle Kupo d'Etat" Key section
-- (Squintrox Dryeyes needs the line at the Fin mission first) and bullet 9 a hint list: all plain bullets.
return {
    title = 'Shock! Arrant Abuse of Authority',
    completes = 's3',
    known = {{t = 'mission', line = 'mkd', eq = 6}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 6, why = 'mission line: current mission = Shock! Arrant Abuse of Authority'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'for this mission you will be'}},
        {id = 's3', at = {n = 3, fp = 'return to the inconspicuous door in'},
         done = {
            {t = 'event', zone = 244, event = 10183, why = 'Inconspicuous Door 10183: plays only with the chest held, completes the mission'},
            {t = 'ki', id = 1144, gained = false, why = 'Moldy, worm-eaten chest handed over at the door'},
            {t = 'mission', line = 'mkd', min = 7, why = 'mission line: moved on to Lender Beware! Read the Fine Print (this one completed)'},
         }},
    },
}
