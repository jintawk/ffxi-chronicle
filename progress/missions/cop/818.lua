-- Step progress for A Fate Decided (Chains of Promathia 8-2, mission id 818). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/8_2_A_Fate_Decided.lua and 8_3_When_Angels_Fall.lua (no client script for the Particle
-- Gate, the Cermet Portal or the zone-in). Bullet 1 is the cutscene at the east Particle Gate (_iyb, Grand Palace of Hu'Xzoi 34,
-- event 2) that completes Garden of Antiquity and so makes this mission current; the same event and the cop line moving to 818 prove
-- it. Bullets 2 to 14 (the Quasilumin escorts, the routes, spawning the Ix'ghrah) leave no event, key item or log trace (the spawn
-- line is zone text, not used), so they are notes on the cutscene that follows the kill: the Cermet Portal (_iyq, event 3 at
-- status 1) completes the mission (bullet 15). Bullet 16 (enter the Garden of Ru'Hmet) is a post step: the Ru'Hmet zone-in cutscene
-- 201 (zone 35) plays only for When Angels Fall at status 0, i.e. once this mission is over. The draft had no signal for the
-- completing bullet and a bare 'current mission' proof for bullet 1; fixed.
-- Bullet 16 left plain: zone-in 201 (zone 35) belongs to When Angels Fall (8_3, mission 828), not to this mission's script.
return {
    title = 'A Fate Decided',
    completes = 's15',
    known = {{t = 'mission', line = 'cop', eq = 818}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the eastern particle gate at'},
         done = {
            {t = 'event', zone = 34, event = 2, why = 'Particle Gate 2: the cutscene that starts the mission (LandSandBoat)'},
            {t = 'mission', line = 'cop', eq = 818, completed = false, why = 'mission line: current mission = A Fate Decided'},
         }},
        {id = 's2', kind = 'note', with = 's15', at = {n = 2, fp = 'the next section requires you to'}},
        {id = 's3', kind = 'note', with = 's15', at = {n = 3, fp = 'on your way through you will'}},
        {id = 's4', kind = 'note', with = 's15', at = {n = 4, fp = 'you have to protect the quasilumin'}},
        {id = 's5', kind = 'note', with = 's15', at = {n = 5, fp = 'on your way through it appears'}},
        {id = 's6', kind = 'note', with = 's15', at = {n = 6, fp = 'map 1 upper level m1 j'}},
        {id = 's7', kind = 'note', with = 's15', at = {n = 7, fp = 'map 1 l 7 transporter'}},
        {id = 's8', kind = 'note', with = 's15', at = {n = 8, fp = 'map 2 basement level m2 l'}},
        {id = 's9', kind = 'note', with = 's15', at = {n = 9, fp = 'map 2 i 10 escort 30'}},
        {id = 's10', kind = 'note', with = 's15', at = {n = 10, fp = 'map 2 g 12 transporter'}},
        {id = 's11', kind = 'note', with = 's15', at = {n = 11, fp = 'map 1 g 10 escort 40'}},
        {id = 's12', kind = 'note', with = 's15', at = {n = 12, fp = 'map 1 g 4 transporter'}},
        {id = 's13', kind = 'note', with = 's15', at = {n = 13, fp = 'continue on to map 2 h'}},
        {id = 's14', kind = 'note', with = 's15', at = {n = 14, fp = 'enter the room and examine another'}},
        {id = 's15', at = {n = 15, fp = 'defeat it then examine the cermet'},
         done = {
            {t = 'mission', line = 'cop', eq = 818, completed = true, why = 'mission log: A Fate Decided completed'},
            {t = 'event', zone = 34, event = 3, why = 'Cermet Portal 3 (status 1, after the Ix\'ghrah): completes'},
         }},
    },
}
