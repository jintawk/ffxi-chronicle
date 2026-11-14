-- Step progress for Cavernous Maws (Wings of the Goddess mission 1, mission id 0). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/01_Cavernous_Maws.lua (the three Cavernous Maws in Batallia Downs 105, Rolanberry
-- Fields 110 and Sauromugue Champaign 120 play event 500 and its finish calls mission:complete, then drops the player at a random
-- past maw) and globals/maws.lua (500 is the "new to Wings of the Goddess" cutscene: it plays only at a maw not yet unlocked while
-- the Pure White Feather, the mission's reward, is not held, so it is this mission's cutscene and nothing else; the client lists
-- event 500 in 105_Cavernous_Maw_01069230.txt, 110_Cavernous_Maw_0106E24C.txt and 120_Cavernous_Maw_010781FC.txt with an empty body).
-- Bullet 5 is the one action (the click); bullet 1 (go to any of the three maws) is the way there, a note on it. Bullets 6 to 9
-- come after the completion (return to the maw you were placed at, unlock the other past maws) and have no event of their own
-- (maw unlocks are server-side bits), so they stay plain bullets. The draft made the log's "current mission = 0" prove bullet 1 and
-- gave bullets 7 and 9 an empty step; dropped.
return {
    title = 'Cavernous Maws',
    completes = 's5',
    known = {{t = 'mission', line = 'wotg', eq = 0}},
    steps = {
        {id = 's1', kind = 'note', with = 's5', at = {n = 1, fp = 'visit any cavernous maw in the'}},
        {id = 's5', at = {n = 5, fp = 'click on the cavernous maw for'},
         done = {
            {t = 'event', zone = 105, event = 500, why = 'Cavernous Maw 500: the new-to-Wings-of-the-Goddess cutscene, Batallia Downs (completes, LandSandBoat)'},
            {t = 'event', zone = 110, event = 500, why = 'Cavernous Maw 500: the cutscene, Rolanberry Fields (completes)'},
            {t = 'event', zone = 120, event = 500, why = 'Cavernous Maw 500: the cutscene, Sauromugue Champaign (completes)'},
            {t = 'mission', line = 'wotg', eq = 0, completed = true, why = 'mission log: Cavernous Maws completed'},
         }},
    },
}
