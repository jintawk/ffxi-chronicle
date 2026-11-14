-- Step progress for Distant Beliefs (Chains of Promathia 2-3, mission id 228). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/2_3_Distant_Beliefs.lua and zones/Phomiuna_Aqueducts/npcs/Wooden_Ladder.lua; client
-- scripts S4 027_Wooden_Ladder_0101B125.txt (event 35, body empty) and 026_Justinius_0101A02B.txt (event 113, body empty). The Minotaur
-- kill (status 0 to 1) has no event or key item and is a note. The Wooden Ladder at the lower-west end of the Iron Gate corridor
-- plays event 35 only at status 1 with the mission current (status 2); that is the cutscene bullet 7 names (the draft put it on
-- bullet 5, which only describes the way to the Iron Gate). The Ornate Gate (_0r5, event 36, status 2; no client script) is
-- bullet 14 (status 3). Justinius 113 (Tavnazian Safehold 26, status 3) completes the mission; his 123 is the reminder at other statuses.
-- Bullet 2 only announces the two objectives and bullet 6 is indented; both carry no signal and stay plain bullets.
return {
    title = 'Distant Beliefs',
    completes = 's15',
    known = {{t = 'mission', line = 'cop', eq = 228}},
    steps = {
        {id = 's1', kind = 'note', with = 's7', at = {n = 1, fp = 'check the sewer entrance in tavnazian'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'sneak and invisible up and make'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'after you defeat the minotaur there'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'find the iron gate at g'}},
        {id = 's7', at = {n = 7, fp = 'after you pass through the iron'},
         done = {
            {t = 'event', zone = 27, event = 35, why = 'Wooden Ladder 35 (status 1 only, LandSandBoat)'},
         }},
        {id = 's8', kind = 'note', with = 's14', at = {n = 8, fp = 'head left through the north door'}},
        {id = 's9', kind = 'note', with = 's14', at = {n = 9, fp = 'look for a on a bookshelf'}},
        {id = 's10', kind = 'note', with = 's14', at = {n = 10, fp = 'in this hallway there are several'}},
        {id = 's11', kind = 'note', with = 's14', at = {n = 11, fp = 'look at which vana diel day'}},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'the above list should be read'}},
        {id = 's13', kind = 'note', with = 's14', at = {n = 13, fp = 'examine the two corresponding oil lamps'}},
        {id = 's14', at = {n = 14, fp = 'head through it and make your'},
         done = {
            {t = 'event', zone = 27, event = 36, why = 'Ornate Gate 36 (status 2 only, LandSandBoat)'},
         }},
        {id = 's15', at = {n = 15, fp = 'after both objectives are completed exit'},
         done = {
            {t = 'mission', line = 'cop', eq = 228, completed = true, why = 'mission log: Distant Beliefs completed'},
            {t = 'event', zone = 26, event = 113, why = 'Justinius 113: completes (status 3)'},
         }},
    },
}
