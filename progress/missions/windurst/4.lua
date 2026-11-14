-- Step progress for A Testing Time (Windurst mission 2-2, mission id 4). Data only; see progress/missions/windurst/1.lua for the
-- format notes. Evidence: LandSandBoat scripts/missions/windurst/2_2_A_Testing_Time.lua and the client event scripts (S4 pseudo)
-- 238_Moreno_Toeno, 240_Janshura_Rashura, 239_Zokima_Rokima, 238_Mokyokyo, 241_Rakoh_Buuma; key item ids from res/key_items.lua.
-- Accepting is the guard menu (event 78/93/111/114, option 4) plus a Yes/No with no line of its own: step 1 rests on the nation
-- line moving to 4 and on the briefing each gate guard plays only while the mission is current (Janshura-Rashura 133, Zokima-Rokima
-- 127, Mokyokyo 177, Rakoh Buuma 473). Moreno-Toeno's offer (181 after a failed run, 182 the first time, 687 on a repeat) is a
-- "Ready already?" menu: the line "Incantation incorporated" (say #7746) plays only on Roger, Roger, "Return when you're arranged"
-- (#7747) on the refusal, so the offer events prove nothing and the accept line plus the "Creature Counter" magic doll key item
-- prove step 2. The kill bullets (n = 3 to 6) and the failure warning (n = 8) are notes: nothing in the log marks a kill count, and
-- Moreno-Toeno's early report (183 / 204, "time left") only repeats status 2. The assessment at the end is the progressEvent
-- 200 (30 to 34 kills) or 201 (35 or more) on the first run and 209 / 206 on a repeat; each calls mission:complete. 198, 199, 202
-- and 208 are the failures (mission dropped) and are not used. The mission can be run again, so s1 and s2 restart a run once it
-- has completed; the briefing events and the doll only occur on a live repeat.
return {
    title = 'A Testing Time',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', eq = 4}},
    repeatable = {restart = {'s1', 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'accept the mission from the gate'},
         done = {
            {t = 'mission', line = 'windurst', eq = 4, completed = false, run1 = true, why = 'mission line: current mission = A Testing Time'},
            {t = 'event', zone = 240, event = 133, why = 'Janshura-Rashura 133, briefing while the mission is current'},
            {t = 'chat', re = "The Aurastery's School of Magic is on the eastern side of Windurst Waters%. Take the opposite road", why = 'Janshura-Rashura 133 (say #3452)'},
            {t = 'event', zone = 239, event = 127, why = 'Zokima-Rokima 127, briefing while the mission is current'},
            {t = 'chat', re = 'The School of Magic is in the Windurst Waters district, west of here%.', why = 'Zokima-Rokima 127 (say #7386)'},
            {t = 'event', zone = 238, event = 177, why = 'Mokyokyo 177, briefing while the mission is current'},
            {t = 'chat', re = 'The School of Magic run by the Aurastery is here on the east side of Windurst Waters%.', why = 'Mokyokyo 177 (say #7725)'},
            {t = 'event', zone = 241, event = 473, why = 'Rakoh Buuma 473, briefing while the mission is current'},
            {t = 'chat', re = "The Aurastery's School of Magic is on the eastern side of Windurst Waters%. Just head north", why = 'Rakoh Buuma 473 (say #8680)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to l 6 in windurst'},
         done = {
            {t = 'chat', re = 'Incantation incorporated%.', why = 'Moreno-Toeno 181 / 182 / 687, accepted (say #7746)'},
            {t = 'ki', id = 38, gained = true, why = '"Creature Counter" magic doll obtained'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'head to tahrongi canyon and start'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'upon defeating 30 monsters return to'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'head to buburimu peninsula and start'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'upon defeating 30 monsters return to'}},
        {id = 's7', at = {n = 7, fp = 'return to moreno toeno in windurst'},
         done = {
            {t = 'mission', line = 'windurst', eq = 4, completed = true, why = 'mission log: A Testing Time completed'},
            {t = 'event', zone = 238, event = 200, why = 'Moreno-Toeno 200: assessed, 30 to 34 kills, mission completed'},
            {t = 'event', zone = 238, event = 201, why = 'Moreno-Toeno 201: assessed, 35 or more kills, mission completed'},
            {t = 'event', zone = 238, event = 209, why = 'Moreno-Toeno 209: assessed on a repeat, 30 to 34 kills, mission completed'},
            {t = 'event', zone = 238, event = 206, why = 'Moreno-Toeno 206: assessed on a repeat, 35 or more kills, mission completed'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'you will fail this mission if'}},
    },
}
