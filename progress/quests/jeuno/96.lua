-- Step progress for The Unfinished Waltz (Jeuno quest 96). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/DNC_AF1_The_Unfinished_Waltz.lua (Laila 10129 begins the quest with no
-- refusal; Rhea Myuliah 10131 at Prog 0 sets Prog 1, 10132 is her talk after it; the Grauberg [S] ??? plays 12 at Prog 1
-- (Dancer, first examine) and 13 once the Migratory Hippogryph is dead, and 13 hands over the key item; Laila 10130 is her
-- talk while accepted, 10133 plays once the key item has been read and runs quest:complete, but it also plays when the War
-- Hoop cannot be given, so it is only a reach and the completed bit carries the last bullet); client event scripts S4
-- 244_Laila_010F40BD.txt (10130 say #11884) and 244_Rhea_Myuliah_010F40BB.txt (10132 say #11891). Key item 962 ("The Essence
-- of Dance") and zone 89 (Grauberg [S]) from res/. The draft's lightsworm key item (2843) is not given by this quest and the
-- ??? 12 only starts the fight, so it is dropped; the second examine that spawns the NM (n=4) is a note on the kill, whose
-- message ("A shiver runs down your spine...") is not specific to this quest; reading the key item (n=6) leaves no trace
-- and is a note on the reward. The War Hoop counts only after s5. The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'The Unfinished Waltz',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to laila in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 10129, why = 'Laila 10129: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 244, event = 10130, conf = 'inferred', why = 'Laila 10130: her talk, only while accepted'},
            {t = 'chat', re = 'What Troupe Brilioth is aimin\' fer is a dance style that captivates and enchants%.', conf = 'inferred', why = 'Laila 10130 (say #11884)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to rhea myuliah next to'},
         done = {
            {t = 'event', zone = 244, event = 10131, why = 'Rhea Myuliah 10131 (Prog 0)'},
            {t = 'event', zone = 244, event = 10132, conf = 'inferred', why = 'Rhea Myuliah 10132: her talk after Prog 1'},
            {t = 'chat', re = 'Laila\'s mother selected only the most talented dancers', conf = 'inferred', why = 'Rhea Myuliah 10132 (say #11891)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to grauberg s and examine'},
         done = {
            {t = 'event', zone = 89, event = 12, why = 'Grauberg [S] ??? 12: the first examine as a Dancer (Prog 1)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'examine the again to spawn the'}},
        {id = 's5', at = {n = 5, fp = 'examine the after defeating the nm'},
         done = {
            {t = 'event', zone = 89, event = 13, why = 'Grauberg [S] ??? 13: after the Hippogryph, hands over the key item'},
            {t = 'ki', id = 962, gained = true, why = '"The Essence of Dance" obtained'},
            {t = 'ki_have', id = 962, have = true, why = '"The Essence of Dance" held'},
            {t = 'chat', re = 'obtained key item: "the essence of dance"', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'open the key item the essence'}},
        {id = 's7', at = {n = 7, fp = 'speak to laila in upper jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 19203, gained = true, after = 's5', conf = 'inferred', why = 'War Hoop obtained (reward)'},
         },
         reach = {{t = 'event', zone = 244, event = 10133, why = 'Laila 10133 (completes only if the War Hoop could be given)'}}},
    },
}
