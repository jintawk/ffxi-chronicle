-- Step progress for Xarcabard, Land of Truths (Bastok mission 5-2, mission id 15). Data only; see progress/missions/sandoria/0.lua
-- and progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/5_2_Xarcabard_Land_of_Truths.lua. The mission is accepted at a nation gate guard
-- (event 1001, option 15, which calls mission:begin); the wiki bullet that says Malduc gives it is the step that gets the mission,
-- and the nation line moving to id 15 proves it (the offer event 1001 is shared by every rank mission and plays on a decline,
-- so it is not listed). Karst 602 in Metalworks (237) plays only while the mission is current and its status is 0 (onTrigger), no
-- refusal branch. The Shadow Lord battle ends in the Throne Room with event 7 (the zone-in cutscene) which sets status 4 and
-- gives the Shadow fragment (key item 74, res/key_items.lua). Event 603 in Metalworks (door 6ld / Karst's event list) needs the
-- Shadow fragment, completes the mission and takes the key item. Event bodies 602 and 603 are empty in
-- 237_Karst_010ED02A.txt (no client line), so there is no chat pattern. The page's navigation bullets are notes. Pavvke 76 and
-- 4l1 event 6 are not placed: 76 plays after the mission, 6 is the pre-battle cutscene with no bullet of its own. The notes after s5 are
-- the Navigation section's route bullets: they take s5 as their step because a note that points back at s4 would mark s5 done.
return {
    title = 'Xarcabard, Land of Truths',
    completes = 's5',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'malduc right beside naji will give'},
         done = {
            {t = 'mission', line = 'bastok', eq = 15, completed = false, why = 'mission line: current mission = Xarcabard, Land of Truths'},
         }},
        {id = 's2', at = {n = 2, fp = 'click on the door president s'},
         done = {
            {t = 'event', zone = 237, event = 602, why = 'Karst 602: the briefing (mission current, status 0)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'castle zvahl keep home point 1'}},
        {id = 's4', at = {n = 4, fp = 'after you clear the bcnm you'},
         done = {
            {t = 'ki', id = 74, gained = true, why = 'Shadow fragment obtained (Throne Room event 7)'},
            {t = 'ki_have', id = 74, have = true, why = 'Shadow fragment held'},
            {t = 'chat', re = 'obtained key item: shadow fragment', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to the president for your'},
         done = {
            {t = 'mission', line = 'bastok', eq = 15, completed = true, why = 'mission log: Xarcabard, Land of Truths completed'},
            {t = 'event', zone = 237, event = 603, why = 'event 603: the Shadow fragment handed in, completes the mission'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'head for xarcabard castle zvahl is'}},
        {id = 's7', kind = 'note', with = 's5', at = {n = 7, fp = 'enter castle zvahl baileys follow the'}},
        {id = 's8', kind = 'note', with = 's5', at = {n = 8, fp = 'turn left and follow the right'}},
        {id = 's9', kind = 'note', with = 's5', at = {n = 9, fp = 'on the next map turn right'}},
        {id = 's10', kind = 'note', with = 's5', at = {n = 10, fp = 'head up the stairs and you'}},
        {id = 's11', kind = 'note', with = 's5', at = {n = 11, fp = 'next get to the top left'}},
        {id = 's12', kind = 'note', with = 's5', at = {n = 12, fp = 'work your way into the center'}},
        {id = 's13', kind = 'note', with = 's5', at = {n = 13, fp = 'inside walk out of the hallway'}},
        {id = 's14', kind = 'note', with = 's5', at = {n = 14, fp = 'once on the second level you'}},
        {id = 's15', kind = 'note', with = 's5', at = {n = 15, fp = 'follow the teleporters four times until'}},
        {id = 's16', kind = 'note', with = 's5', at = {n = 16, fp = 'the shadow lord has 2 forms'}},
        {id = 's17', kind = 'note', with = 's5', at = {n = 17, fp = 'while immune to magic he will'}},
        {id = 's18', kind = 'note', with = 's5', at = {n = 18, fp = 'during physical immunity he can use'}},
        {id = 's19', kind = 'note', with = 's5', at = {n = 19, fp = 'defeating the first form will get'}},
        {id = 's20', kind = 'note', with = 's5', at = {n = 20, fp = 'the second form will only use'}},
    },
}
