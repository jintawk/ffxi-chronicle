-- Step progress for The Lost City (Chains of Promathia 2-2, mission id 218). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/2_2_The_Lost_City.lua; client script S4 026_Despachiaire_0101A009.txt (event 102 listed,
-- body empty; 106 is the reminder line, say #9883, played after 102 and not used). Despachiaire 102 (Tavnazian Safehold 26, status 0)
-- is bullet 3. The Sewer Entrance (_0q1, event 103, status 1; no client script) completes the mission, and it is the last thing
-- bullet 4 asks for, so bullet 4 is the completing step (the draft had it as a note). Bullets 5 to 10 are information about other
-- quests and are left as plain bullets. The draft's Justinius 360, Arquil 291 and Liphatte 301 reminders are dropped.
return {
    title = 'The Lost City',
    completes = 's4',
    known = {{t = 'mission', line = 'cop', eq = 218}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'if you did not get the'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'when the cutscene ends make your'}},
        {id = 's3', at = {n = 3, fp = 'enter the room and speak to'},
         done = {
            {t = 'event', zone = 26, event = 102, why = 'Despachiaire 102 (status 0 only)'},
         }},
        {id = 's4', at = {n = 4, fp = 'after the cutscene head back to'},
         done = {
            {t = 'mission', line = 'cop', eq = 218, completed = true, why = 'mission log: The Lost City completed'},
            {t = 'event', zone = 26, event = 103, why = 'Sewer Entrance 103: completes (status 1, LandSandBoat)'},
         }},
    },
}
