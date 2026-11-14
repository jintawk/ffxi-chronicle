-- Step progress for Rescue! A Moogle's Labor of Love (A Moogle Kupo d'Etat mission 9, mission id 8). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/09_Rescue_A_Moogles_Labor_of_Love.lua and
-- the client's event pseudo-code, 208_Goblin_Geologist_010D0238.txt. The Goblin Geologist (Quicksand Caves 208) plays event 100 with
-- P0 = 0 at the first talk (progress 0), P0 = 2 when the markers are already assigned, and P0 = 1 once all nine stones are held; P1 is
-- 1 when the Map of the Quicksand Caves is held. The client's first-talk branch (say #7418 and #7419) hands out the markers only with
-- the map (P1 = 1); without it #7420 sends the player away, but LandSandBoat's finish sets progress 1 either way, so the first talk
-- without the map is not proof of bullet 3. Proof: 100 with P0 = 0 and P1 = 1, the line only that branch says, or (inferred) the
-- reminder 100 with P0 = 2 and P1 = 1. Bullet 11: 100 with P0 = 1 plays only with all nine stones held and its finish deletes them and
-- gives the Navaratna talisman (1158): the event, its line, or a stone taken prove it (the talisman gained is a reward and is not used). Bullets 4 to 10 are the marker
-- explanation and the entrance list, notes on that step; the nine Stone key items (1145 to 1153) are gathered at unnamed ???, with no
-- bullet of their own. Bullet 12: the Shimmering Circle in the Chamber of Oracles (168) plays event 5 only with the talisman held
-- (section 4 of the script) and its finish calls mission:complete. The mkd line has no completed set in Chronicle (core/data.lua
-- get_mission_read), so the completion is also the line moving past it (min = 9). Bullet 13 (a note about the weight switches) stays plain. The talisman
-- is a reward key item (also sold by Squintrox after the Fin mission), so it is not used.
return {
    title = "Rescue! A Moogle's Labor of Love",
    completes = 's12',
    known = {{t = 'mission', line = 'mkd', eq = 8}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 8, why = "mission line: current mission = Rescue! A Moogle's Labor of Love"}}}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'make sure you possess the map'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to western altepa desert d'}},
        {id = 's3', at = {n = 3, fp = 'speak to the goblin geologist at'},
         done = {
            {t = 'event', zone = 208, event = 100, p = {[0] = 0, [1] = 1}, why = 'Goblin Geologist 100, P0 = 0 first talk, P1 = 1 map held: the markers handed out'},
            {t = 'chat', re = 'find nine tiny gems in this cavernous lair', why = 'Goblin Geologist 100 (say #7418): first talk with the map'},
            {t = 'event', zone = 208, event = 100, p = {[0] = 2, [1] = 1}, conf = 'inferred', why = 'Goblin Geologist 100, P0 = 2: the markers already assigned'},
         },
         reach = {
            {t = 'event', zone = 208, event = 100, p = {[0] = 0}, why = 'Goblin Geologist 100, first talk (without the map it hands out nothing)'},
         }},
        {id = 's4', kind = 'note', with = 's11', at = {n = 4, fp = 'the goblin will mark the locations'}},
        {id = 's5', kind = 'note', with = 's11', at = {n = 5, fp = 'the following entrances can contain the'}},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'g 5 entrance 6 to quicksand'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'j 9 entrance 2 to quicksand'}},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'k 7 entrance 1 to quicksand'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'h 10 entrance 4 to quicksand'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'these can require multiple one way'}},
        {id = 's11', at = {n = 11, fp = 'once you return to the goblin'},
         done = {
            {t = 'event', zone = 208, event = 100, p = {[0] = 1}, why = 'Goblin Geologist 100, P0 = 1: all nine stones handed over, talisman made'},
            {t = 'chat', re = 'One talisman, good as new', why = 'Goblin Geologist 100 (say #7423)'},
            {t = 'ki', id = 1145, gained = false, why = 'Stone of Surya handed over'},
         }},
        {id = 's12', at = {n = 12, fp = 'enter the chamber of oracles and'},
         done = {
            {t = 'event', zone = 168, event = 5, why = 'Shimmering Circle 5: the cutscene, completes the mission (talisman held)'},
            {t = 'mission', line = 'mkd', min = 9, why = 'mission line: moved on to Roar! A Cat Burglar Bares Her Fangs (this one completed)'},
         }},
    },
}
