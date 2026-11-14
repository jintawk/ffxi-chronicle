-- Step progress for The Final Seal (Windurst mission 5-1, mission id 14). Data only; see progress/missions/windurst/1.lua for the
-- format notes. Evidence: LandSandBoat scripts/missions/windurst/5_1_The_Final_Seal.lua; key item ids from res/key_items.lua.
-- There is no gate guard: the mission starts at the Vestal Chamber door (_6q2) in Heavens Tower, event 166 (with the Message to
-- Jeuno held) or 190, whose finish accepts only on option 0 and otherwise just takes the Message to Jeuno, and the client scripts
-- for that door are not decoded, so the event proves nothing. Step 2 rests on the nation line moving to 14 and the New Fei'Yin
-- seal it hands over. Step 3 is the Fei'Yin zone-in cutscene (zonein event 1, played once at status 10). Step 6 is the Qu'Bia Arena
-- battlefield win: event 32001 plays for any win there, so the proof is the Burnt seal, a temporary key item that only this win
-- gives and that is taken again at the end (not a reward that can already be held). The fight tips (n = 4, 5) are notes. Step 7
-- is the door again at status 12 with the Burnt seal: event 192, which calls mission:complete.
return {
    title = 'The Final Seal',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', eq = 14}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'click the door vestal chamber at'},
         done = {
            {t = 'mission', line = 'windurst', eq = 14, completed = false, why = 'mission line: current mission = The Final Seal'},
            {t = 'ki', id = 72, gained = true, why = "new Fei'Yin seal obtained (given when the mission starts)"},
         }},
        {id = 's3', at = {n = 3, fp = 'go to fei yin located in'},
         done = {
            {t = 'zonein', zone = 204, event = 1, why = "Fei'Yin 1: the zone-in cutscene with Zeid (status 10 to 11)"},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'you only need to kill the'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'you will be facing archlich taber'}},
        {id = 's6', at = {n = 6, fp = 'when you win you ll be'},
         done = {
            {t = 'ki', id = 73, gained = true, why = "Burnt seal obtained from the Qu'Bia Arena battlefield win"},
         }},
        {id = 's7', at = {n = 7, fp = 'check the door vestal chamber at'},
         done = {
            {t = 'mission', line = 'windurst', eq = 14, completed = true, why = 'mission log: The Final Seal completed'},
            {t = 'event', zone = 242, event = 192, why = 'Heavens Tower 192: the Vestal Chamber door with the Burnt seal, mission completed'},
            {t = 'ki', id = 73, gained = false, why = 'Burnt seal handed over'},
         }},
    },
}
