-- Step progress for Return of the Talekeeper (Bastok mission 6-1, mission id 16). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/6_1_Return_of_the_Talekeeper.lua. A gate guard hands the mission out (event 1001,
-- option 16, mission:begin); the page has no bullet for that, so the nation line moving to id 16 opens the group (s1 becomes next).
-- Medicine Eagle 180 (Bastok Mines 234) plays at status 0 only and sets status 1; at any later status he plays 181 (say #11542,
-- "talk to Drake Fang"), so 181 can only follow s1. Drake Fang (Zeruhn Mines 172) plays 200 at status 1 (sets status 2) and 201 at
-- any status above 1. The ??? (qm2) in Western Altepa Desert (125) gives the Altepa moonpebble (key item 266, res/key_items.lua)
-- once one of the two Sphinx NMs is dead and sets status 3; killing the NM leaves no signal of its own, so the bullets before the
-- key item are notes. Tall Mountain 182 (Bastok Mines) plays at status 3, completes the mission and takes the moonpebble. The event
-- bodies are empty in the pseudo-code (no client line for 180, 182, 200, 201).
return {
    title = 'Return of the Talekeeper',
    completes = 's6',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 16, completed = false, why = 'mission line: current mission = Return of the Talekeeper'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you ll be instructed to go'},
         done = {
            {t = 'event', zone = 234, event = 180, why = 'Medicine Eagle 180: sends you to Drake Fang (status 0 only)'},
            {t = 'event', zone = 234, event = 181, conf = 'inferred', why = 'Medicine Eagle 181: reminder, only after 180'},
            {t = 'chat', re = 'you should talk to Drake Fang in the Zeruhn Mines about that', conf = 'inferred', why = 'Medicine Eagle 181 (say #11542), only after 180'},
         }},
        {id = 's2', at = {n = 2, fp = 'you must then speak with drake'},
         done = {
            {t = 'event', zone = 172, event = 200, why = 'Drake Fang 200 (status 1)'},
            {t = 'event', zone = 172, event = 201, conf = 'inferred', why = 'Drake Fang 201: replay, only after 200'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'you will get a cutscene telling'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'in western altepa desert seek out'}},
        {id = 's5', at = {n = 5, fp = 'once defeated check the again to'},
         done = {
            {t = 'ki', id = 266, gained = true, why = 'Altepa moonpebble obtained'},
            {t = 'ki_have', id = 266, have = true, why = 'Altepa moonpebble held'},
            {t = 'chat', re = 'obtained key item: altepa moonpebble', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to bastok mines hp 3'},
         done = {
            {t = 'mission', line = 'bastok', eq = 16, completed = true, why = 'mission log: Return of the Talekeeper completed'},
            {t = 'event', zone = 234, event = 182, why = 'Tall Mountain 182: the moonpebble handed in, completes the mission'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'after the cutscene the mission will'}},
    },
}
