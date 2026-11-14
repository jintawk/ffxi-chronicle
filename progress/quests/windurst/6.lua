-- Step progress for Wondering Minstrel (Windurst quest 6). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Wondering_Minstrel.lua (Jatan-Paratan 633 is the "how did you like it" menu
-- and 634 the offer, option 0 begins the quest, so both are only reaches; Yuli Yaam 637 and Yung Yaam 636 play in the
-- available AND the accepted state and the first bullet bundles three NPCs, so they prove nothing and the quest log's
-- current bit carries it; Aramu-Paramu 683 plays only while accepted; Ruslan 10009 is the lumber request (it sets Prog 2,
-- which Jatan's trade needs) and 10010 his reminder after it; the lumber trade plays 638, which completes the quest, but the
-- Faerie Piccolo reward cannot be given on a full bag while 638 still plays, so it is only a reach and the quest log's
-- completed bit carries the last step; 639 and Ruslan 10011 play only once completed). Disagreement with the draft: it used
-- Yuli and Yung and the whole tavern as proof of the first bullet, left the Ruslan bullet without a signal although 10009 and
-- 10010 are his, and used 638 as completion. Client event scripts S4 238_Jatan_Paratan_010EE04F.txt (633 menu #8910, 635 say
-- #8922, 639 say #8945), 238_Aramu_Paramu_010EE04E.txt (683) and 245_Ruslan_010F5020.txt (10009 say #6743, 10010 say #6745).
-- The quest log is set at s1, so it is not silent.
return {
    title = 'Wondering Minstrel',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'in windurst waters north go into'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jatan-Paratan 634, option 0)'},
            {t = 'event', zone = 238, event = 635, conf = 'inferred', why = 'Jatan-Paratan 635: reminder, only once accepted'},
         },
         reach = {
            {t = 'event', zone = 238, event = 633, why = 'Jatan-Paratan 633 offered (its finish needs option 3)'},
            {t = 'event', zone = 238, event = 634, why = 'Jatan-Paratan 634 offered (its finish needs option 0)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to aramu paramu'},
         done = {
            {t = 'event', zone = 238, event = 683, why = 'Aramu-Paramu 683: plays only while accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to lower jeuno and speak'},
         done = {
            {t = 'event', zone = 245, event = 10009, why = 'Ruslan 10009: the lumber request'},
            {t = 'chat', re = 'What%? You say the great Jatan%-Paratan is worried%?', why = 'Ruslan 10009 (say #6743)'},
            {t = 'event', zone = 245, event = 10010, conf = 'inferred', why = 'Ruslan 10010: reminder, only after 10009'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade a piece of rosewood lumber'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 238, event = 639, conf = 'inferred', why = 'Jatan-Paratan 639: plays only once completed'},
         },
         reach = {{t = 'event', zone = 238, event = 638, why = 'Jatan-Paratan 638 (also plays when the Faerie Piccolo cannot be given)'}}},
    },
}
