-- Step progress for Trust: Windurst (Windurst quest 96). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Wetata.lua (863 or 867 offers the quest; only the Yes answer, option 2
-- in LandSandBoat, begins it and gives the Green institute card; 864 is the reminder while the card is held) and
-- Heavens_Tower/npcs/Kupipi.lua (435 teaches the Kupipi trust on a first Trust quest and completes nothing; 436 is a chat line;
-- 437 completes it after the spell has been cast; 439 completes it at once when another nation's Trust quest is done); client event
-- scripts S4 241_Wetata_010F11BA.txt (the accept line #14164 plays only on the Yes answer of both 863 and 867) and
-- 242_Kupipi_010F2012.txt. The draft took the Kupipi 435 talk as proof of the last step; it only teaches the spell, so it is a reach.
-- The quest-log completed bit, 437, 439, the Windurst Trust permit and the CALL_MULTIPLE_ALTER_EGO text carry it. 863 and 867 play on a
-- decline, so they are reach. The quest log is set at s1, so it is not silent. Not repeatable (page meta).
-- Chat 'You are now able to call multiple alter egos' is shared with sandoria/119 and the Bastok Trust quest: gated after s1.
return {
    title = 'Trust: Windurst',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to wetata in windurst woods'},
         done = {
            {t = 'chat', re = 'Excellentaru! I knew I could turn that frown upside down!', why = 'Wetata 863 or 867, Yes answer (say #14164)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2496, gained = true, why = 'green institute card obtained'},
            {t = 'ki_have', id = 2496, have = true, why = 'green institute card held'},
            {t = 'chat', re = 'obtained key item: green institute card', why = 'chat: key item obtained'},
            {t = 'event', zone = 241, event = 864, conf = 'inferred', why = 'Wetata 864: the reminder, only while the card is held'},
         },
         reach = {
            {t = 'event', zone = 241, event = 863, why = 'Wetata 863 offered (also plays on a decline)'},
            {t = 'event', zone = 241, event = 867, why = 'Wetata 867 offered (also plays on a decline)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to heavens tower and speak'},
         done = {
            {t = 'event', zone = 242, event = 439, why = 'Kupipi 439: completes at once when another Trust quest is done'},
            {t = 'event', zone = 242, event = 437, why = 'Kupipi 437: completes after the Kupipi spell has been cast'},
            {t = 'chat', re = 'You are now able to call multiple alter egos%.', after = 's1', why = 'Kupipi 437 (CALL_MULTIPLE_ALTER_EGO)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 2497, gained = true, why = 'Windurst Trust permit obtained (reward)'},
            {t = 'ki_have', id = 2497, have = true, why = 'Windurst Trust permit held'},
            {t = 'chat', re = 'obtained key item: windurst trust permit', why = 'chat: key item obtained'},
            {t = 'ki', id = 2496, gained = false, after = 's1', conf = 'inferred', why = 'green institute card handed over'},
         },
         reach = {
            {t = 'event', zone = 242, event = 435, why = 'Kupipi 435: first Trust quest, teaches the Kupipi spell'},
            {t = 'event', zone = 242, event = 436, why = 'Kupipi 436: after the spell is learned'},
         }},
    },
}
