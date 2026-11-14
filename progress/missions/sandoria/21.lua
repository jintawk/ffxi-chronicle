-- Step progress for Lightbringer (San d'Oria mission 8-2, mission id 21). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/8_2_Lightbringer.lua; client event script S4 233_Rahal_010E9008.txt (106: say #6845;
-- 107 repeats it); Temple of Uggalepih zone text BEGINS_TO_QUIVER (IDs.lua, 7468); key items 285 to 287 piece of a broken key
-- (res/key_items.lua).
-- The Great Hall door (_6h4, zone 233) plays 100 at status 0 (-> 1) and 104 at status 6 (completes, takes the crystal dowser); Rahal 106
-- (status 1 -> 2, gives the crystal dowser, key item 284, which mission 7-2 also hands out and so is not used); in the Temple of Uggalepih
-- (zone 159) the door _4fv says "The crystal dowser begin to quiver!" when it spawns the dolls (only with all three pieces in hand,
-- status 5) and plays 65 after they are dead (status 5 -> 6, takes the three pieces). The three ??? give a piece each and one status step
-- each, in any order: no single observation proves all three, so s6 is optional (never ticked alone), its three key items only reach it,
-- and s7 (which needs all three) implies it. Events 100, 104 and 65 have no decoded body, so their ids come from LandSandBoat. The
-- reward bullet is a note on the step that completes the mission.
return {
    title = 'Lightbringer',
    completes = 's9',
    known = {{t = 'mission', line = 'sandoria', min = 21}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to chateau d oraguille and'},
         done = {
            {t = 'event', zone = 233, event = 100, why = 'Door: Great Hall 100 (status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with rahal h 9 western'},
         done = {
            {t = 'event', zone = 233, event = 106, why = 'Rahal 106: the crystal dowser (status 1 -> 2)'},
            {t = 'event', zone = 233, event = 107, why = 'Rahal 107 (status 2 only)'},
            {t = 'chat', re = 'I want you to investigate the Temple of Uggalepih%.', why = 'Rahal 106 and 107 (say #6845)'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'head to the temple of uggalepih'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'make your way through the temple'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'pass into the big room and'}},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'in the south hallway examine the'},
         reach = {
            {t = 'ki', id = 285, gained = true, why = 'piece of a broken key obtained'},
            {t = 'ki', id = 286, gained = true, why = 'piece of a broken key obtained'},
            {t = 'ki', id = 287, gained = true, why = 'piece of a broken key obtained'},
         },
         done = {}},
        {id = 's7', implies = {'s6'}, at = {n = 7, fp = 'after you have all 3 keys'},
         done = {
            {t = 'chat', re = 'begin to quiver!', why = 'the door says the dowser quivers: the dolls spawn, all three pieces held (Temple of Uggalepih text 7468)'},
         }},
        {id = 's8', at = {n = 8, fp = 'after the dolls have been defeated'},
         done = {
            {t = 'event', zone = 159, event = 65, why = 'Granite Door 65 (status 5, dolls dead; takes the three pieces; LandSandBoat)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to chateau d oraguille and'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 21, completed = true, why = 'mission log: Lightbringer completed'},
            {t = 'event', zone = 233, event = 104, why = 'Door: Great Hall 104 (status 6, completes; LandSandBoat)'},
         }},
        {id = 's10', kind = 'note', with = 's9', at = {n = 10, fp = 'you will be awarded rank 9'}},
    },
}
