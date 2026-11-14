-- Step progress for Purple, The New Black (Wings of the Goddess mission 7, mission id 6). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/07_Purple_The_New_Black.lua. Status 0: the Reinforced Gateway (_2d1) in La Vaule [S]
-- (zone 85) plays event 2, status 1. The second touch enters the Galarhigg battlefield (events 32000 / 32001 are any battlefield
-- in the zone, never proof), and after the win the zone-in cutscene 6 (status 2) plays and its finish completes the mission. So
-- bullet 1 is event 2 and bullet 3 is zone-in 6 plus the log; bullet 2 (the fight) has no event of its own and is a note on bullet
-- 3, as is the route to the gateway (4 to 8; a note placed after its step must name a later or same step, or it would tick the steps before it). Bullets 9 and 10 are fight tips and stay plain. The draft made
-- bullets 2 to 8 notes on bullet 1, left zone-in 6 unplaced and had no `completes`; fixed.
return {
    title = 'Purple, The New Black',
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 6}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the reinforced gateway at f'},
         done = {
            {t = 'event', zone = 85, event = 2, why = 'Reinforced Gateway 2: the cutscene before the battlefield (status 0)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examine the reinforced gateway a second'}},
        {id = 's3', at = {n = 3, fp = 'after defeating the boss another cutscene'},
         done = {
            {t = 'zonein', zone = 85, event = 6, why = 'La Vaule [S] zone-in cutscene 6 after the Galarhigg win: completes the mission (status 2)'},
            {t = 'mission', line = 'wotg', eq = 6, completed = true, why = 'mission log: Purple, The New Black completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'once inside la vaule s enter'}},
        {id = 's5', kind = 'note', with = 's3', at = {n = 5, fp = 'from i 7 go north then'}},
        {id = 's6', kind = 'note', with = 's3', at = {n = 6, fp = 'make your way directly across the'}},
        {id = 's7', kind = 'note', with = 's3', at = {n = 7, fp = 'once you reach e 6 follow'}},
        {id = 's8', kind = 'note', with = 's3', at = {n = 8, fp = 'the path will turn you south'}},
    },
}
