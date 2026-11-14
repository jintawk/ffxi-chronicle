-- Step progress for Exit the Gambler (San d'Oria quest 101). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log shows nothing until it is completed, so every step before the last is seen only through NPC events and
-- dialogue: the second in-game test of the step progress proof of concept (events read from EventPara, 2026-10-27).
-- Evidence: LandSandBoat scripts/quests/sandoria/Exit_the_Gambler.lua (Aurege/Guilberdrier 521 sets Stage 1; Varchet 638
-- once per zone; Aurege 516 / Guilberdrier 518 complete it; reward key item 391, map of King Ranperre's Tomb) and
-- scripts/zones/Southern_San_dOria/npcs/Varchet.lua (5 gil trade -> event 519 with P0-P6 = dice and result, 0 = won;
-- on a win while Stage is 1, text 7809 "As promised, I shall go and see about those woodchippers"); client event scripts
-- S4 231_Aurege_010E7029.txt (521 say #11179, 516 say #11186) and 230_Varchet_010E6060.txt (638 say #7786). Event 519 is
-- not in the decoded client scripts: its P6 = result is LandSandBoat's only, and this run checks it.
-- Shared-signal audit: key item 391 (map of King Ranperre's Tomb) dropped, the map vendors sell it (globals/maps.lua); events 516/518 and the completed bit stay.
return {
    title = 'Exit the Gambler',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's5'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'start the quest by talking to aurege'},
         done = {
            {t = 'event', zone = 231, event = 521, why = 'Aurege or Guilberdrier 521'},
            {t = 'chat', re = "I reckon he's out scouring the Parade Grounds", why = 'Aurege 521 (say #11179)'},
         }},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'optional talk to nonterene'}, done = {}},
        {id = 's3', at = {n = 3, fp = 'varchet is located in southern'},
         done = {
            {t = 'event', zone = 230, event = 638, why = 'Varchet 638'},
            {t = 'chat', re = "Those blokes at the Carpenters' Guild are looking for me", why = 'Varchet 638 (say #7786)'},
         }},
        {id = 's4', at = {n = 4, fp = 'you ll need to gamble against him'},
         done = {
            {t = 'event', zone = 230, event = 519, p = {[6] = 0}, why = 'Varchet 519, P6 = 0: won'},
            {t = 'chat', re = 'As promised, I shall go and see about those woodchippers', why = 'Varchet text 7809 on a win'},
         },
         reach = {{t = 'event', zone = 230, event = 519, why = 'Varchet 519: a game played'}}},
        {id = 's5', at = {n = 5, fp = 'after winning return and talk to aurege'},
         done = {
            {t = 'event', zone = 231, event = 516, why = 'Aurege 516'},
            {t = 'event', zone = 231, event = 518, why = 'Guilberdrier 518'},
            {t = 'chat', re = "I don't remember asking you to fetch him", why = 'Aurege 516 (say #11186)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
