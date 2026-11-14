-- Step progress for Confessions of Royalty (Treasures of Aht Urhgan mission 5, mission id 4). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/05_Confessions_of_Royalty.lua. Guilerme 810 (Northern San d'Oria, 231) plays only for
-- a player without access to the Chateau and also on a refusal, so the entry bullet is a note. In the Chateau (zone 233) Halver 564
-- (played when Raillefal's letter is held) completes on option 1 and the forced-entry zone-in 563 completes without a choice; both
-- take Raillefal's letter (key item 785), so its loss and the mission line prove the step; 564 alone is `reach` because a refusal plays it too.
-- Raillefal's letter is a reward key item of the previous mission (only its loss is used).
return {
    title = 'Confessions of Royalty',
    completes = 's2',
    known = {{t = 'mission', line = 'toau', eq = 4}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'enter chateau d oraguille from northern'}},
        {id = 's2', at = {n = 2, fp = 'speak to halver i 9'},
         done = {
            {t = 'mission', line = 'toau', eq = 4, completed = true, why = 'mission log: Confessions of Royalty completed'},
            {t = 'ki', id = 785, gained = false, why = "Raillefal's letter handed over"},
            {t = 'zonein', zone = 233, event = 563, why = "Chateau d'Oraguille zone-in 563 (forced entry), completes"},
         },
         reach = {
            {t = 'event', zone = 233, event = 564, why = 'Halver 564 offered (it also plays on a refusal)'},
         }},
    },
}
