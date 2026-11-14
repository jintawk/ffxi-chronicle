-- Step progress for The Warrior's Path (Chains of Promathia 7-5, mission id 748). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/7_5_The_Warriors_Path.lua (no client script for the gate, the zone-ins or the battle).
-- The Iron Gate in Sealion's Den (32, event 32, status 0) is bullet 1. Entering the battlefield and the fight (bullets 2 and 3) leave
-- no event of their own (32001 is a battlefield exit, never proof), so they are notes on the last bullet. That bullet is proved by
-- the zone-in cutscene 34 in Sealion's Den after the win (status 2) and completes with the Al'Taieu (33) zone-in cutscene 1 (status
-- 3), which also puts the mission in the log's completed ids. The zone-in 18 and Sueleen 12 / 28 (after completion), the Dimensional
-- Portals, Wilhelm, Meret and Yurim are menus or reminders and are dropped, as are the draft's notes-only steps for bullets 2 to 4.
return {
    title = "The Warrior's Path",
    completes = 's4',
    known = {{t = 'mission', line = 'cop', eq = 748}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'travel to sealion s den and'},
         done = {
            {t = 'event', zone = 32, event = 32, why = 'Iron Gate 32 (status 0, LandSandBoat)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'when your party is ready click'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'if happens to connect all weapon'}},
        {id = 's4', at = {n = 4, fp = 'after you beat you will receive'},
         done = {
            {t = 'mission', line = 'cop', eq = 748, completed = true, why = "mission log: The Warrior's Path completed"},
            {t = 'zonein', zone = 33, event = 1, why = "Al'Taieu zone-in cutscene 1 (status 3): completes"},
            {t = 'zonein', zone = 32, event = 34, why = "Sealion's Den zone-in cutscene 34 after the win (status 2)"},
         }},
    },
}
