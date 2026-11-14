-- Step progress for Divine Might (Outlands quest 163). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Divine_Might.lua (the Blank Target in The Shrine of Ru'Avitau plays 54 while
-- the Ark Angels mission is at status 1, and begins the quest on finish; 56 is the same offer from a later mission, but it is
-- also the Divine Might (Repeat) line, so it is not used; the Ark Pentasphere comes from the Qu'Hau Spring trade, event 7, which
-- the repeat quest shares; the battlefield win sets Prog 1, after which the target plays 55, the earring choice, and 55 runs
-- quest:complete only for a valid choice, so it also plays on a cancelled menu). Event 55 therefore proves the win (bullet 8),
-- and the completed bit proves the reward pick (bullet 11). The battlefield's own exit event (32001) is any battlefield's, so it
-- is not used. Bullets 3 and 4 are the same target; bullet 3's cutscene is the mission's, not this quest's. The client has no
-- event script for this zone, so the events come from LandSandBoat only. The Re-Questing bullets belong to Divine Might (Repeat)
-- (quest 164), which has its own mapping; they stay plain bullets here. Not repeatable (the repeat is its own quest).
return {
    title = 'Divine Might',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'enter the shrine of ru avitau'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'head north a short distance to'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'examine the blank target for a'}},
        {id = 's4', at = {n = 4, fp = 'examine the blank target again for'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Blank Target 54 begins the quest)'},
            {t = 'event', zone = 178, event = 54, why = 'Blank Target 54: how to obtain an Ark Pentasphere; begins the quest'},
         }},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'you or someone in your group'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'trade the ark pentasphere to any'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'this battle has a 30 minute'}},
        {id = 's8', at = {n = 8, fp = 'you will need to defeat ark'},
         done = {
            {t = 'event', zone = 178, event = 55, after = 's4', why = 'Blank Target 55: plays only once the battlefield is won (Prog 1); also on a cancelled menu'},
         }},
        {id = 's9', kind = 'note', with = 's8', at = {n = 9, fp = 'if you happen to have an'}},
        {id = 's10', kind = 'note', with = 's8', at = {n = 10, fp = 'the general strategy at level 75'}},
        {id = 's11', at = {n = 11, fp = 'once you have finished the battle'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Blank Target 55, a valid earring choice)'},
         }},
    },
}
