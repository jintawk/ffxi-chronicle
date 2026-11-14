-- Step progress for The Pirates' Cove (Bastok mission 6-2, mission id 17). Data only; see progress/missions/bastok/15.lua.
-- Evidence: LandSandBoat scripts/missions/bastok/6_2_The_Pirates_Cove.lua. A gate guard hands the mission out (event 1001, option 17);
-- the page has no bullet for it, so the nation line moving to id 17 opens the group (s1 becomes next). Naji (Metalworks 237) plays
-- 761 at status 0 (sets 1) and 762 at status 3 (completes the mission). Gilgamesh (Norg 252): 98 on talk at status 1 (sets 2), 99 on
-- trading a Frag Rock at status 2 only (the trade is checked before the event, a wrong item gives no event; sets 3). The
-- Adaman Ore trade to the ??? (qm4, Ifrit's Cauldron 205) has no event: popFromQM succeeding gives "You have a bad feeling about this place."
-- (IDs.lua text 7289); that phrase is generic and other content can reuse it, so it is not proof: bullet 7 is a note on the Frag Rock trade
-- (event 99). The Frag Rock drop, the ore and the travel bullets leave no signal of their own (items can come from elsewhere): notes. Event bodies 761, 762, 98 and
-- 99 are empty in the pseudo-code.
return {
    title = "The Pirates' Cove",
    completes = 's10',
    known = {{t = 'mission', line = 'bastok', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'bastok', eq = 17, completed = false, why = "mission line: current mission = The Pirates' Cove"}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to naji for a cutscene'},
         done = {
            {t = 'event', zone = 237, event = 761, why = 'Naji 761 (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to norg and speak with'},
         done = {
            {t = 'event', zone = 252, event = 98, why = 'Gilgamesh 98 (status 1 only)'},
         }},
        {id = 's3', kind = 'note', with = 's9', at = {n = 3, fp = 'obtain 1 adaman ore for every'}},
        {id = 's4', kind = 'note', with = 's9', at = {n = 4, fp = 'proceed to yhoator jungle i 5'}},
        {id = 's5', kind = 'note', with = 's9', at = {n = 5, fp = 'you will have to reach a'}},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'once inside head left at the'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'buff up and prepare to fight'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'upon defeating magma it will drop'}},
        {id = 's9', at = {n = 9, fp = 'when everyone has their frag rock'},
         done = {
            {t = 'event', zone = 252, event = 99, why = 'Gilgamesh 99: the Frag Rock accepted (status 2 only)'},
         }},
        {id = 's10', at = {n = 10, fp = 'head back to naji for a'},
         done = {
            {t = 'mission', line = 'bastok', eq = 17, completed = true, why = "mission log: The Pirates' Cove completed"},
            {t = 'event', zone = 237, event = 762, why = 'Naji 762 (status 3): completes the mission'},
         }},
    },
}
