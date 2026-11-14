-- Step progress for Awakening of the Gods (Windurst mission id 19). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/7_2_Awakening_of_the_Gods.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 19) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 19), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1 Leepe-Hoppe 734 (status 0). s2 Kerutoto 736 (progressEvent at status 1; the page's other Kerutoto cutscene, about Diabolos, is a
-- quest event). s3 Romaa Mihgo in Kazham 266 (status 2; Vanono 264 and Jakoh 265 are optional talks). s4 the Cursed Key drop from
-- Bonze Marberry has no event: a note on s5. s5 the Granite Door trade, event 23 in the Temple of Uggalepih (a valid Cursed Key only;
-- gives the Book of the Gods). s6 Leepe-Hoppe 742 completes.
return {
    title = 'Awakening of the Gods',
    completes = 's6',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to leepe hoppe on the'},
         done = {
            {t = 'event', zone = 238, event = 734, why = 'Leepe-Hoppe 734'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to kerutoto in the rhinostery'},
         done = {
            {t = 'event', zone = 238, event = 736, why = 'Kerutoto 736'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to romaa mihgo in kazham'},
         done = {
            {t = 'event', zone = 250, event = 266, why = 'Romaa Mihgo 266'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'travel to the temple of uggalepih'}},
        {id = 's5', at = {n = 5, fp = 'after obtaining your cursed key trade'},
         done = {
            {t = 'event', zone = 159, event = 23, why = 'Granite Door 23: the Cursed Key accepted'},
            {t = 'ki', id = 252, gained = true, why = 'Book of the Gods obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to leepe hoppe to complete'},
         done = {
            {t = 'mission', line = 'windurst', eq = 19, completed = true, why = 'mission log: Awakening of the Gods completed'},
            {t = 'event', zone = 238, event = 742, why = 'Leepe-Hoppe 742: completes'},
         }},
    },
}
