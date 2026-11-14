-- Step progress for The Shadow Lord (San d'Oria mission 5-2, mission id 15). Data only; see progress/missions/sandoria/0.lua for
-- the mission format. Evidence: LandSandBoat scripts/missions/sandoria/5_2_The_Shadow_Lord.lua; client event script S4
-- 233_Halver_010E9007.txt (546: say #7177; 548: say #7285 and the rank speech); key item 74 shadow fragment (res/key_items.lua).
-- The gate guard's offer is not a bullet (the page starts at Halver), so the mission line only reaches s1.
-- Halver 546 (status 0 -> 1, plays only while the mission is current and untouched), the Prince Royal's Rm door 547 (status 1 -> 2),
-- the Throne Room door 6 (status 2 -> 3, zone 165), the post-battle zone-in 7 (zone 165, gives the shadow fragment) and Halver 548
-- (needs the fragment; completes, takes it) are all progress events of this one mission. The doors 547, 6 and 61 and the zone-in 7
-- have no decoded body, so their ids come from LandSandBoat. The Throne Room door 6 and zone-in 7 are shared with Bastok 5-2 and
-- Windurst 5-2 (same shadow fragment, same events), so those matchers carry after = 's1' (Halver 546 is San d'Oria only) and
-- a Bastok or Windurst character never ticks this page. The battlefield entry (s5) has no event of its own: a note with s6.
-- The bullets after the reward (the Great Hall door 61 cutscene, the Trust: Trion door, the Castle Zvahl directions and the fight tips) are
-- notes on s7: a note placed after a step must not take an earlier step's state or it would pull every step before it to done. Event 61 (a
-- once-only cutscene after completion) is therefore not tracked.
return {
    title = 'The Shadow Lord',
    completes = 's7',
    known = {{t = 'mission', line = 'sandoria', min = 15}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to halver for a some'},
         done = {
            {t = 'event', zone = 233, event = 546, why = 'Halver 546 (status 0, plays once)'},
            {t = 'chat', re = 'Prince Trion was looking for you%.', why = 'Halver 546 (say #7177)'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine door prince royal s rm'},
         done = {
            {t = 'event', zone = 233, event = 547, after = 's1', why = "Door: Prince Royal's Rm 547 (status 1, LandSandBoat)"},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'castle zvahl keep home point 1'}},
        {id = 's4', at = {n = 4, fp = 'click on the door to the'},
         done = {
            {t = 'event', zone = 165, event = 6, after = 's1', why = 'Throne Room door 6 (status 2, LandSandBoat)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'click on the door again and'}},
        {id = 's6', at = {n = 6, fp = 'after you clear the bcnm you'},
         done = {
            {t = 'zonein', zone = 165, event = 7, after = 's1', why = 'Throne Room zone-in 7 after the battlefield (LandSandBoat)'},
            {t = 'ki', id = 74, gained = true, after = 's1', why = 'shadow fragment obtained'},
            {t = 'chat', re = 'obtained key item: shadow fragment', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to halver for your reward'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 15, completed = true, why = 'mission log: The Shadow Lord completed'},
            {t = 'event', zone = 233, event = 548, why = 'Halver 548 (needs the shadow fragment, completes)'},
            {t = 'chat', re = 'I knew you were the one for the job%.', why = 'Halver 548 (say #7285)'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'check the door to the great'}},
        {id = 's9', kind = 'note', with = 's7', at = {n = 9, fp = 'while you re here check door'}},
        {id = 's10', kind = 'note', with = 's7', at = {n = 10, fp = 'head for xarcabard castle zvahl is'}},
        {id = 's11', kind = 'note', with = 's7', at = {n = 11, fp = 'enter castle zvahl baileys follow the'}},
        {id = 's12', kind = 'note', with = 's7', at = {n = 12, fp = 'turn left and follow the right'}},
        {id = 's13', kind = 'note', with = 's7', at = {n = 13, fp = 'on the next map turn right'}},
        {id = 's14', kind = 'note', with = 's7', at = {n = 14, fp = 'head up the stairs and you'}},
        {id = 's15', kind = 'note', with = 's7', at = {n = 15, fp = 'next get to the top left'}},
        {id = 's16', kind = 'note', with = 's7', at = {n = 16, fp = 'work your way into the center'}},
        {id = 's17', kind = 'note', with = 's7', at = {n = 17, fp = 'at this point you can use'}},
        {id = 's18', kind = 'note', with = 's7', at = {n = 18, fp = 'inside walk out of the hallway'}},
        {id = 's19', kind = 'note', with = 's7', at = {n = 19, fp = 'once on the second level you'}},
        {id = 's20', kind = 'note', with = 's7', at = {n = 20, fp = 'follow the teleporters four times until'}},
        {id = 's21', kind = 'note', with = 's7', at = {n = 21, fp = 'the shadow lord has 2 forms'}},
        {id = 's22', kind = 'note', with = 's7', at = {n = 22, fp = 'while immune to magic he will'}},
        {id = 's23', kind = 'note', with = 's7', at = {n = 23, fp = 'during physical immunity he can use'}},
        {id = 's24', kind = 'note', with = 's7', at = {n = 24, fp = 'defeating the first form will get'}},
        {id = 's25', kind = 'note', with = 's7', at = {n = 25, fp = 'the second form will only use'}},
    },
}
