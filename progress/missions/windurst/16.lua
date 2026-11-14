-- Step progress for Full Moon Fountain (Windurst mission id 16). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/6_1_Full_Moon_Fountain.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 16) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 16), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1: Hakkuru-Rinkuru in Port Windurst, event 456 (progressEvent at status 0; gives the Southwestern star charm). The Cracked Walls
-- and the Gate: Magical Gizmo (which spawns the Jack Cardians) run no event (a message only): notes on s5. s5: the door after the
-- Jacks, event 68 in Outer Horutoto Ruins (takes the charm). s6: Full Moon Fountain zone-in 50, which completes the mission.
return {
    title = 'Full Moon Fountain',
    completes = 's6',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to hakkuru rinkuru at the'},
         done = {
            {t = 'event', zone = 240, event = 456, why = 'Hakkuru-Rinkuru 456: the cutscene and the charm'},
            {t = 'ki', id = 248, gained = true, why = 'Southwestern star charm obtained'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'go to west sarutabaruta f 11'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'you ll be in map 4'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'go straight ahead to j 8'}},
        {id = 's5', at = {n = 5, fp = 'examine the door after defeating them'},
         done = {
            {t = 'event', zone = 194, event = 68, why = 'Outer Horutoto Ruins door 68: the Jack Cardians beaten, the charm goes'},
            {t = 'ki', id = 248, gained = false, why = 'Southwestern star charm taken'},
         }},
        {id = 's6', at = {n = 6, fp = 'enter full moon fountain located in'},
         done = {
            {t = 'mission', line = 'windurst', eq = 16, completed = true, why = 'mission log: Full Moon Fountain completed'},
            {t = 'zonein', zone = 170, event = 50, why = 'Full Moon Fountain zone-in 50: completes'},
         }},
    },
}
