-- Step progress for Emissary from the Seas (Rhapsodies of Vana'diel mission 1-3, page id 111). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_03_Emissary_from_the_Seas.lua and the client scripts S4 248_Naillina (event 14) and
-- 249_Numi_Adaligo (event 50). The rov line holds the page id (enum + 108) and has no completed set; the next value is 112 (Set Free).
-- The two bullets are the two paths, taken by what Resonance set (Selbina or Mhaura), so each is a group of its own with the same start.
-- The events (14 at Naillina, 50 at Numi Adaligo) are a menu that plays on every talk, and only option 1 ("You wanted an adventurer?" /
-- "You're searching for adventurers?") completes, so the events are only `reach`, never proof. The first option's own lines are: Naillina #7998 ("Thank you
-- for answering the summons ...") and Numi Adaligo #8049 ("Forgive me for not recognizing you sooner ..."), said by that branch only.
-- Dropped from the draft: lines #6706 and #6867 (the "About this town" branch, which does not complete) and the events as proof.
-- The line cannot say which path was taken, so the path not taken is only inferred done once the line has moved on.
return {
    title = 'Emissary from the Seas',
    known = {{t = 'mission', line = 'rov', eq = 111}},
    groups = {
        selbina = {start = {{t = 'mission', line = 'rov', eq = 111, why = 'mission line: current mission = Emissary from the Seas'}}},
        mhaura = {start = {{t = 'mission', line = 'rov', eq = 111, why = 'mission line: current mission = Emissary from the Seas'}}},
    },
    steps = {
        {id = 's1', group = 'selbina', at = {n = 1, fp = 'if you picked the selbina path'},
         done = {
            {t = 'chat', re = 'thank you for answering the summons', why = 'Naillina 14 (say #7998): the first option, which completes'},
            {t = 'mission', line = 'rov', min = 112, conf = 'inferred', why = 'mission log: the line moved past Emissary from the Seas (path not known)'},
         },
         reach = {{t = 'event', zone = 248, event = 14, why = 'Naillina 14 offered (only its first option completes)'}}},
        {id = 's2', group = 'mhaura', at = {n = 2, fp = 'if you picked the mhaura path'},
         done = {
            {t = 'chat', re = 'forgive me for not recognizing you sooner', why = 'Numi Adaligo 50 (say #8049): the first option, which completes'},
            {t = 'mission', line = 'rov', min = 112, conf = 'inferred', why = 'mission log: the line moved past Emissary from the Seas (path not known)'},
         },
         reach = {{t = 'event', zone = 249, event = 50, why = 'Numi Adaligo 50 offered (only its first option completes)'}}},
    },
}
