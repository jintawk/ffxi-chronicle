-- Step progress for Somber Dreams (Rhapsodies of Vana'diel mission, page id 194 = LandSandBoat's SOMBER_DREAMS 86 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_18_Somber_Dreams.lua. The first click on the ??? (qm_cetus, Grauberg [S] zone 89)
-- only spawns Cetus and prints a message, with no event, and its generic "sense of foreboding" line plays elsewhere, so bullet 2 has
-- no signal. After Cetus dies the same ??? plays event 48 (bullet 3). The ??? beside the Veridical Conflux plays event 49 whether
-- the player says yes or no (only option 99 enters the Walk of Echoes), so it only shows the step is reached. Entering the Walk of
-- Echoes (zone 182) from Grauberg [S] plays the zone-in cutscene 28 and its finish completes the mission only when option == 1 (bullet 4;
-- cross-audit: an explicit option branch, so the scene is `reach` and the line moving on proves the step). The reward is
-- only the next mission. Bullet 1 is the tail of Sacrifice's scene (its event 47 belongs to the previous page) and bullet 5 is
-- travel advice, so they are notes with the step they lead into. The rov line holds the page id and has no completed set, so
-- the completion is `min = 200` (Of Light and Darkness, 92 + 108, the next value in the enum).
return {
    title = 'Somber Dreams',
    completes = 's4',
    known = {{t = 'mission', line = 'rov', min = 194, max = 199}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'you ll automatically be in grauberg'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examine the blue glowing closest to'}},
        {id = 's3', at = {n = 3, fp = 're examine the for a cutscene'},
         done = {
            {t = 'event', zone = 89, event = 48, why = 'Grauberg [S] ??? (qm_cetus) 48: plays only after Cetus is dead'},
         }},
        {id = 's4', at = {n = 4, fp = 're enter walk of echoes for'},
         done = {
            {t = 'mission', line = 'rov', min = 200, why = 'mission log: the line moved past Somber Dreams'},
         },
         reach = {
            {t = 'event', zone = 89, event = 49, why = 'Grauberg [S] Veridical Conflux ??? 49 (plays on yes and no)'},
            {t = 'zonein', zone = 182, event = 28, why = 'Walk of Echoes zone-in 28 (completes only on option 1)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'note if you brought some sort'}},
    },
}
