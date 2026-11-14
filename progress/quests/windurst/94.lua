-- Step progress for Lure of the Wildcat (Windurst quest 94). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Lure_of_the_Wildcat_Windurst.lua (the draft read the Bastok script of the
-- same name): Ibwam 736 gives the Green Sentinel badge and begins the quest whichever answer is chosen; each of the twenty NPCs
-- plays its own event once and sets a bit; Ibwam 739 plays only when all twenty bits are set, takes the badge and completes the
-- quest, with the Green invitation card as reward; Ibwam 794 (300 gil, after completion) teleports to Whitegate). Client event
-- script S4 241_Ibwam_010F10EF.txt (736 say #10408, 739 say #10418). The twenty talks are one bullet, so no single NPC event proves
-- it and no event of its own closes it (739 is the next bullet's event): it is a note on s3. Bullets 4 and 5
-- come after the completion and their page text names Salaheem's staff and Alib-Mufalib (copied from the Bastok page); no
-- event in LandSandBoat's Windurst script covers them, so they stay plain bullets. The quest log is set at s1, so it is not silent.
return {
    title = 'Lure of the Wildcat (Windurst)',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ibwam to recieve a'},
         done = {
            {t = 'event', zone = 241, event = 736, why = 'Ibwam 736: Green Sentinel badge, begins the quest'},
            {t = 'chat', re = "Here, put this on, quick!", why = 'Ibwam 736, Yes answer (say #10410)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 745, gained = true, why = 'green Sentinel badge obtained'},
            {t = 'ki_have', id = 745, have = true, why = 'green Sentinel badge held'},
            {t = 'chat', re = 'obtained key item: green sentinel badge', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak to all twenty 20 npcs'}},
        {id = 's3', at = {n = 3, fp = 'return to ibwam he will exchange'},
         done = {
            {t = 'event', zone = 241, event = 739, why = 'Ibwam 739: badge exchanged, quest completed'},
            {t = 'chat', re = "We're swamped with inquiries about Salaheem's Sentinels now!", why = 'Ibwam 739 (say #10418)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 755, gained = true, why = 'green invitation card obtained'},
            {t = 'ki_have', id = 755, have = true, why = 'green invitation card held'},
            {t = 'chat', re = 'obtained key item: green invitation card', why = 'chat: key item obtained'},
            {t = 'ki', id = 745, gained = false, after = 's1', conf = 'inferred', why = 'green Sentinel badge handed over'},
         }},
    },
}
