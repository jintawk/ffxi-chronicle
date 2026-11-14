-- Step progress for The Sixth Ministry (Windurst mission id 18). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/7_1_The_Sixth_Ministry.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 18) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 18), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1: Tosuka-Porika, event 715 (progressEvent at status 0; the Optistery ring, whose id is also given in The Jester Who'd Be King, so
-- no key item matcher). s2: the four Hinge Oils run no event: a note on s3. s3: the Marble Door (_4pc) is event 70 with P3 = 2 when
-- all four are dead and 70 with P3 = 1 while one lives (a refusal, not proof), so the params decide (LandSandBoat progressCutscene
-- 70, 0, 0, 0, 2; the door is not decoded in the pseudo-code). s4: the Tome of Magic, event 69 (decoded). The page ends there; the
-- mission completes when Tosuka-Porika plays 724, which sits on s4 with the completed id.
return {
    title = 'The Sixth Ministry',
    completes = 's4',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to tosuka porika in the'},
         done = {
            {t = 'event', zone = 238, event = 715, why = 'Tosuka-Porika 715: the cutscene and the Optistery ring'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to toraimarai canal g 8'}},
        {id = 's3', at = {n = 3, fp = 'after defeating the 4 slimes head'},
         done = {
            {t = 'event', zone = 169, event = 70, p = {[3] = 2}, why = 'Marble Door 70 with P3 = 2: all four Hinge Oils dead'},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the tome of magic lying'},
         done = {
            {t = 'event', zone = 169, event = 69, why = 'Tome of Magic 69'},
            {t = 'mission', line = 'windurst', eq = 18, completed = true, why = 'mission log: The Sixth Ministry completed'},
            {t = 'event', zone = 238, event = 724, why = 'Tosuka-Porika 724: completes (past the last bullet)'},
         }},
    },
}
