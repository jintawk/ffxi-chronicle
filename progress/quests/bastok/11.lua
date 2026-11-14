-- Step progress for The Cold Light of Day (Bastok quest 11). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Cold_Light_of_Day.lua (Malene 102 has no option, its finish begins the quest
-- and it plays again on every later talk, so any 102 means the quest is begun; Malene 104 plays only on a Steam Clock trade and
-- runs quest:complete; Gwill 103 is an idle line); client event script S4 235_Malene_010EB004.txt (102 say #7484, 104 say
-- #7492). The ways to get the clock are indented bullets, which are never steps, and the bullet before them
-- has no signal of its own, so it is a note on the trade. A repeat needs no new accept (the trade alone), so there is no
-- `repeatable` entry (as in sandoria 5 and 15).
return {
    title = 'The Cold Light of Day',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to malene to begin quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 235, event = 102, why = 'Malene 102: begins the quest (and plays on every later talk)'},
            {t = 'chat', re = 'Well, well%. What do we have here%?', why = 'Malene 102 (say #7484)'},
         }},
        {id = 'n2', kind = 'note', with = 's5', at = {n = 2, fp = 'obtain a steam clock via the'}},
        {id = 's5', at = {n = 5, fp = 'return to town and trade the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 235, event = 104, why = 'Malene 104: the Steam Clock accepted, runs quest:complete'},
            {t = 'chat', re = 'Good, you got it%.', why = 'Malene 104 (say #7492)'},
         }},
    },
}
