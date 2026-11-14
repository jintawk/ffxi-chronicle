-- Step progress for Petals for Parelbriaux (Other Areas quest 74). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Ondieulix 514 begins the quest (s4), so s1 and s3 rest on events alone.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Petals_for_Parelbriaux.lua (Chemioue 512 at Prog 0, Parelbriaux 513 at Prog 1,
-- Ondieulix 514 at Prog 2 begins the quest; the Lufaise Meadows ??? pops Baumesel in fog with SPINE_CHILLING_PRESENCE ("You sense
-- a spine-chilling presence!", a line no other quest uses), and once it is dead gives the Particularly poignant petal, Temporary
-- KI 679, with cutscene 115; Ondieulix 516 at Prog 4 completes the quest and takes the petal); the client event scripts S4
-- 026_Chemioue, 026_Ondieulix and 026_Parelbriaux are bare for these events. The draft put the petal and its loss on the
-- completing bullet; the petal and cutscene 115 happen at the ??? before the hand-in, so they are only reaches of s7. Bullet 2
-- (Tressia) has no event of its own in LandSandBoat.
return {
    title = 'Petals for Parelbriaux',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's4'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to chemioue on the top'},
         done = {
            {t = 'event', zone = 26, event = 512, why = 'Chemioue 512 (Prog 0)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to tressia next to chemioue'}},
        {id = 's3', at = {n = 3, fp = 'speak to parelbriaux k 7'},
         done = {
            {t = 'event', zone = 26, event = 513, why = 'Parelbriaux 513 (Prog 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to ondieulix i 7 middle'},
         done = {
            {t = 'event', zone = 26, event = 514, why = 'Ondieulix 514: begins the quest (Prog 2)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'head to lufaise meadows and look'}},
        {id = 's6', at = {n = 6, fp = 'the will spawn the nm baumesel'},
         done = {
            {t = 'chat', re = 'you sense a spine%-chilling presence!', after = 's4', why = 'Lufaise Meadows SPINE_CHILLING_PRESENCE: Baumesel popped'},
         }},
        {id = 's7', at = {n = 7, fp = 'once the nm is defeated check'},
         done = {
            {t = 'event', zone = 26, event = 516, after = 's4', why = 'Ondieulix 516: the petal handed over, completes the quest (Prog 4)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 679, gained = false, conf = 'inferred', why = 'Particularly poignant petal handed over'},
         },
         reach = {
            {t = 'ki', id = 679, gained = true, why = 'Particularly poignant petal obtained at the ???'},
            {t = 'ki_have', id = 679, have = true, why = 'Particularly poignant petal held'},
            {t = 'event', zone = 24, event = 115, after = 's4', why = 'Lufaise Meadows ??? cutscene 115 (Prog 3 to 4)'},
         }},
    },
}
