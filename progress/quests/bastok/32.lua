-- Step progress for Vengeful Wrath (Bastok quest 32). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Vengeful_Wrath.lua (Goraow 106 is a plain progress event that begins the quest
-- with no option test; Goraow 107 plays only for a trade of exactly one Quadav Helm and runs quest:complete, in any status but
-- available); client event script S4 234_Goraow_010EA03C.txt (106 say #10815, 107 say #10818). The quest is repeatable, but a
-- repeat needs no new accept (the helm trade alone plays 107 again), so there is no `repeatable` entry, as for Minesweeper (39).
-- Disagreement with the draft: it set restart = s1, which a repeat never visits.
return {
    title = 'Vengeful Wrath',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to goraow i 6 in'},
         done = {
            {t = 'event', zone = 234, event = 106, why = 'Goraow 106: begins the quest'},
            {t = 'chat', re = 'The workers in the mines and those who went out to avenge them%.%.%.', why = 'Goraow 106 (say #10815)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain a quadav helm'}},
        {id = 's3', at = {n = 3, fp = 'trade a quadav helm to goraow'},
         done = {
            {t = 'event', zone = 234, event = 107, why = 'Goraow 107: the Quadav Helm accepted, completes'},
            {t = 'chat', re = 'Good work%. Now the souls of my brethren can finally rest in peace%.', why = 'Goraow 107 (say #10818)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'can be repeated without zoning'}},
    },
}
