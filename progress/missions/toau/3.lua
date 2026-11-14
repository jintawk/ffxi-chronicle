-- Step progress for Knight of Gold (Treasures of Aht Urhgan mission 4, mission id 3). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/04_Knight_of_Gold.lua, all in Aht Urhgan Whitegate (zone 50). Cacaroon 3035 plays only at
-- status 0 or 1 (every finish advances the status; the later reminders are 3036 and 3023), Cacaroon 3022 only on a trade of 1,000 gil or an
-- Imperial Bronze Piece, trigger area 4 plays 3024 only at status 3 (Walahra Temple) and trigger area 5 plays 3026 only at status 4
-- (Shararat Teahouse), whose finish completes the mission. The questions are inside 3026, so the Teahouse bullet is its start and the
-- question bullet is the completion. Raillefal's letter (a reward key item) is not used. The answer bullets are notes.
return {
    title = 'Knight of Gold',
    completes = 's5',
    known = {{t = 'mission', line = 'toau', eq = 3}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to cacaroon g 11 for'},
         done = {
            {t = 'event', zone = 50, event = 3035, why = 'Cacaroon 3035: the first cutscene (status 0 or 1 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade cacaroon 1 000 gil or'},
         done = {
            {t = 'event', zone = 50, event = 3022, why = 'Cacaroon 3022: plays only on the 1,000 gil or Imperial Bronze Piece trade'},
         }},
        {id = 's3', at = {n = 3, fp = 'enter the walahra temple k 8'},
         done = {
            {t = 'event', zone = 50, event = 3024, why = 'Walahra Temple trigger area 3024 (status 3 only)'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to the shararat teahouse k'},
         done = {
            {t = 'event', zone = 50, event = 3026, why = 'Shararat Teahouse trigger area 3026 (status 4 only): the questions cutscene'},
         }},
        {id = 's5', at = {n = 5, fp = 'answer the following questions to complete'},
         done = {
            {t = 'mission', line = 'toau', eq = 3, completed = true, why = 'mission log: Knight of Gold completed'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'what have you learned about pick'}},
        {id = 's7', kind = 'note', with = 's5', at = {n = 7, fp = 'same as first question but with'}},
        {id = 's8', kind = 'note', with = 's5', at = {n = 8, fp = 'you are really a san d'}},
        {id = 's9', kind = 'note', with = 's5', at = {n = 9, fp = 'raillefal is really prince trion'}},
    },
}
