-- Step progress for The Chains That Bind Us (Bastok mission 8-1, mission id 20). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/8_1_The_Chains_That_Bind_Us.lua. A gate guard hands the mission out (event 1001,
-- option 20); the nation line moving to id 20 opens the group. Iron Eater's briefing 767 (Metalworks 237) is a yes/no menu and
-- sets status 1 only on option 0, so the event also plays on a decline and the briefing has no proof: bullet 1 is a note on the
-- first provable step. The ??? (qm6) in Quicksand Caves (208) pops the three Antica NMs at status 1 with "You are suddenly
-- overcome with a sense of foreboding..." (a phrase reused in many zones, not proof); once they are dead the status is 2 and the
-- same ??? plays event 11 (Zeid, sets status 3). The other ??? (qm4) plays event 10 at status 3 (sets status 4). Iron Eater 768
-- (status 4) completes the mission. Event 702 (Iron Eater / the door at status 3) is the generic door text, not listed. Event
-- bodies 767, 768 are empty in 237_Iron_Eater_010ED030.txt.
return {
    title = 'The Chains That Bind Us',
    completes = 's11',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 20, completed = false, why = 'mission line: current mission = The Chains That Bind Us'}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's6', at = {n = 1, fp = 'visit iron eater at the president'}},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'head for the tunnel at g'}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'make your way to h 8'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'open the next weighted ornate door'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'clear out the room and then'}},
        {id = 's6', at = {n = 6, fp = 'check the galka statue again once'},
         done = {
            {t = 'event', zone = 208, event = 11, why = 'qm6 11: the cutscene with Zeid (status 2 only)'},
         }},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'leave and proceed to d 12'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'inside head through the eastern weighted'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'go east to another weight device'}},
        {id = 's10', at = {n = 10, fp = 'the you need is on the'},
         done = {
            {t = 'event', zone = 208, event = 10, why = 'qm4 10: the cutscene with Zeid (status 3 only)'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to iron eater for a'},
         done = {
            {t = 'mission', line = 'bastok', eq = 20, completed = true, why = 'mission log: The Chains That Bind Us completed'},
            {t = 'event', zone = 237, event = 768, why = 'Iron Eater 768 (status 4): completes the mission'},
         }},
    },
}
