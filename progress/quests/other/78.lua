-- Step progress for Knocking on Forbidden Doors (Other Areas quest 78). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Knocking_on_Forbidden_Doors.lua (Enaremand 535 is a plain cutscene that
-- begins the quest; Chemioue 536 plays once at Prog 0; the Phomiuna ladder plays 38 with P0 = 27, the only quest use of 38 in
-- that zone; the ??? at I-6 in Misareaux Coast gives the Mire incense; the ??? at F-4 plays 556 (first touch, incense held),
-- 557 (second touch, spawns Alsha) and 558 (after the kill: takes the incense, gives Better Humes and Mannequins); Fyi
-- Chalmwoh 321 in Mhaura completes the quest, but 321 is also her menu on every later talk, so it is only used after s7, and
-- the quest log's completed bit is the proof). Client event scripts S4 026_Enaremand_0101A07F.txt (535 bare) and
-- 026_Chemioue_0101A00C.txt (536). The Misareaux and Phomiuna events are LandSandBoat's (the client has no script for those
-- objects). The quest log is set at s1, so it is not silent.
return {
    title = 'Knocking on Forbidden Doors',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk with enaremand j 7'},
         done = {
            {t = 'event', zone = 26, event = 535, why = 'Enaremand 535: the offer cutscene (no menu, begins the quest)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to chemioue j 6'},
         done = {
            {t = 'event', zone = 26, event = 536, why = 'Chemioue 536: plays once while accepted at Prog 0'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to phomiuna aqueducts find a'},
         done = {
            {t = 'event', zone = 27, event = 38, p = {[0] = 27}, why = 'Wooden Ladder 38 with P0 = 27: the quest ladder (LandSandBoat)'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to misareaux coast and select'},
         done = {
            {t = 'ki', id = 709, gained = true, why = 'mire incense obtained'},
            {t = 'ki_have', id = 709, have = true, why = 'mire incense held'},
            {t = 'chat', re = 'obtained key item: mire incense', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'go to the base of the'},
         done = {
            {t = 'event', zone = 25, event = 556, why = 'qm alsha 556: first touch with the Mire incense held'},
         }},
        {id = 's6', at = {n = 6, fp = 'select the again to spawn the'},
         done = {
            {t = 'event', zone = 25, event = 557, why = 'qm alsha 557: second touch, Alsha spawns'},
         }},
        {id = 's7', at = {n = 7, fp = 'once alsha is defeated select the'},
         done = {
            {t = 'ki', id = 713, gained = true, why = 'Better Humes and Mannequins obtained'},
            {t = 'ki_have', id = 713, have = true, why = 'Better Humes and Mannequins held'},
            {t = 'event', zone = 25, event = 558, why = 'qm alsha 558: after the kill'},
            {t = 'chat', re = 'obtained key item: better humes and mannequins', why = 'chat: key item obtained'},
            {t = 'ki', id = 709, gained = false, conf = 'inferred', why = 'mire incense handed over'},
         }},
        {id = 's8', at = {n = 8, fp = 'travel to mhaura and talk to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 249, event = 321, after = 's7', why = 'Fyi Chalmwoh 321 after the kill (her menu on every later talk too)'},
         }},
    },
}
