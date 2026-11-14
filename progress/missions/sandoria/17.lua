-- Step progress for Ranperre's Final Rest (San d'Oria mission 6-2, mission id 17). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/6_2_Ranperres_Final_Rest.lua; client event scripts S4 230_Ambrotien_010E6062.txt,
-- 230_Endracion_010E6061.txt, 231_Grilau_010E7022.txt (say #7350/#116 on 1035 and 1036, #7351/#117 on 1037 and 1038, #7353/#119 on
-- 1039 and 1040, #7354/#120 on 1033 and 1034) and 233_Perfaumand_010E901B.txt (event 50); key item 269 ancient San d'Orian book.
-- The gate guards' events are this mission's own (1033 to 1040 are used by no other script): with the book 1035 (Endracion, Grilau) and
-- 1036 (Ambrotien) take it and set status 4 (a local flag requires a zone); 1037 and 1038 are the "will take time" talk before the zone;
-- 1039 and 1040 the talk after it (status 5); 1033 and 1034 complete. Door _6h0 (Prince Royal's Rm, zone 233) 81 starts the mission
-- (status 0 -> 1) and 21 plays at status 5 (-> 6); Perfaumand 50 plays at status 6 only (the second talk of bullet 9). The Heavy Stone Door
-- in King Ranperre's Tomb (zone 190) 5 plays at status 6 (-> 7) and the lower Tombstone 8 gives the book (status 3); the door's event 6
-- is not used (it can be cancelled and 9-2 shares the door). Killing the three skeletons leaves no trace; the door only says "You sense
-- something evil." (zone text 7330) when it spawns them at status 1. The door events 81 and 21 and the tomb events 5 and 8 have no
-- decoded body, so their ids come from LandSandBoat. The piece of paper is lost with event 8 and is not used.
return {
    title = "Ranperre's Final Rest",
    completes = 's11',
    known = {{t = 'mission', line = 'sandoria', min = 17}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you ll be instructed to go'},
         done = {
            {t = 'event', zone = 233, event = 81, why = "Door: Prince Royal's Rm 81 (status 0, LandSandBoat)"},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'if you re low level gather'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head for h 8 in king'}},
        {id = 's4', at = {n = 4, fp = 'when ready check the heavy stone'},
         done = {
            {t = 'chat', re = 'You sense something evil%.', why = 'Heavy Stone Door: the skeletons spawn (King Ranperre\'s Tomb text 7330)'},
         }},
        {id = 's5', at = {n = 5, fp = 'when defeated check the heavy stone'},
         done = {
            {t = 'event', zone = 190, event = 8, why = 'Tombstone 8: the cutscene that gives the ancient San d\'Orian book (LandSandBoat)'},
            {t = 'ki', id = 269, gained = true, why = "ancient San d'Orian book obtained"},
            {t = 'ki_have', id = 269, have = true, why = "ancient San d'Orian book held"},
            {t = 'chat', re = "obtained key item: ancient san d.orian book", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'talk to any gate guard a'},
         done = {
            {t = 'event', zone = 230, event = 1036, why = 'Ambrotien 1036: the book handed over'},
            {t = 'event', zone = 230, event = 1035, why = 'Endracion 1035: the book handed over'},
            {t = 'event', zone = 231, event = 1035, why = 'Grilau 1035: the book handed over'},
            {t = 'chat', re = 'I will deliver this book to the scholars for deciphering%.', why = 'a gate guard (say #7350 and #116)'},
            {t = 'ki', id = 269, gained = false, conf = 'inferred', why = "ancient San d'Orian book handed over"},
         }},
        {id = 's7', at = {n = 7, fp = 'you must talk to the gate'},
         done = {
            {t = 'event', zone = 230, event = 1038, why = 'Ambrotien 1038: the deciphering will take time'},
            {t = 'event', zone = 230, event = 1037, why = 'Endracion 1037: the deciphering will take time'},
            {t = 'event', zone = 231, event = 1037, why = 'Grilau 1037: the deciphering will take time'},
            {t = 'chat', re = 'will take a considerable amount of time%.', why = 'a gate guard (say #7351 and #117)'},
         }},
        {id = 's8', at = {n = 8, fp = 'zone and talk to the guard'},
         done = {
            {t = 'event', zone = 230, event = 1040, why = 'Ambrotien 1040: see Prince Trion (status 5)'},
            {t = 'event', zone = 230, event = 1039, why = 'Endracion 1039: see Prince Trion (status 5)'},
            {t = 'event', zone = 231, event = 1039, why = 'Grilau 1039: see Prince Trion (status 5)'},
            {t = 'chat', re = 'Prince Trion is calling for you%.', why = 'a gate guard (say #7353 and #119)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to prince trion and speak'},
         done = {
            {t = 'event', zone = 233, event = 21, why = "Door: Prince Royal's Rm 21 (status 5, LandSandBoat)"},
            {t = 'event', zone = 233, event = 50, why = 'Perfaumand 50 (status 6 only)'},
         }},
        {id = 's10', at = {n = 10, fp = 'return to the heavy stone door'},
         done = {
            {t = 'event', zone = 190, event = 5, why = 'Heavy Stone Door 5 (status 6, LandSandBoat)'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to a gate guard to'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 17, completed = true, why = "mission log: Ranperre's Final Rest completed"},
            {t = 'event', zone = 230, event = 1034, why = 'Ambrotien 1034: completes'},
            {t = 'event', zone = 230, event = 1033, why = 'Endracion 1033: completes'},
            {t = 'event', zone = 231, event = 1033, why = 'Grilau 1033: completes'},
            {t = 'chat', re = 'I knew you would not let the Kingdom down%.', why = 'a gate guard (say #7354 and #120)'},
         }},
    },
}
