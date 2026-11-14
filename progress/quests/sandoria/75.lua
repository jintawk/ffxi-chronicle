-- Step progress for The Rivalry (San d'Oria quest 75; the page also covers its twin, The Competition at Joulet).
-- Data only; see progress/quests/sandoria/27.lua for the format. Two of the four bullets are steps; bullets 3 and 4 (Ufanne's
-- running count, the brothers' totals) are information, not actions, and stay plain bullets: Ufanne's 309 and 310 also play
-- before the quest is taken (310 is her only line in the available state), so they prove nothing.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Rivalry.lua (Gallijaux 300 option 700 begins the quest; 301 is a partial
-- carp trade that changes nothing but the tally; 303 is the trade that brings the total to 10,000 and runs quest:complete).
-- The twin quest is a different quest id with its own log bit: someone who took it from Joulet never sets this one, so bullet
-- 1 stays open for them (the entry for The Competition maps the same page). No client event script for events 300, 301 or
-- 303 is decoded; LandSandBoat names them. Event 303 plays whether or not the reward (Lu Shang's fishing rod) fits, and
-- quest:complete fails in the finish with a full bag, so it is reach and the completed bit proves bullet 2.
return {
    title = 'The Rivalry',   -- the page covers both twins; this entry is quest 75, so the title is the script's name
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'the quest begins from either joulet'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (from Gallijaux)'},
         },
         reach = {{t = 'event', zone = 232, event = 300, why = 'Gallijaux 300 offered (its finish needs option 700)'}}},
        {id = 's2', at = {n = 2, fp = 'trade whichever npc you want 10'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 232, event = 303, why = "Gallijaux 303: the trade that reaches 10,000 (plays even when Lu Shang's rod does not fit)"},
            {t = 'event', zone = 232, event = 301, why = 'Gallijaux 301: a carp trade, total under 10,000'},
         }},
    },
}
