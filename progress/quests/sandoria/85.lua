-- Step progress for Enveloped in Darkness (San d'Oria quest 85). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/RDM_AF2_Enveloped_in_Darkness.lua (Curilla 94 or 95 option 1 begins the
-- quest and gives the Old pocket watch, key item 197; 92 is her reminder, only while accepted; Pagisalis 37 is the trade of
-- exactly one Velvet Cloth, swapping the watch for the Old boots, 198; 101 is Curilla's optional ghost talk; the Crawlers'
-- Nest chest gives Crawler blood, 201; the ??? 4 asks to bury the boots and blood and deletes both key items only on
-- option 1, so event 4 alone proves nothing (the offer can be declined); a minute later ??? 5 completes the quest and
-- gives the Warlock's Boots) and scripts/zones/Crawlers_Nest/IDs.lua (YOU_BURY_THE 7287); client event scripts S4
-- 233_Curilla_010E900C.txt (92 say #7447; 94, 95, 101 have no text) and 231_Pagisalis_010E7020.txt (37 no text, 58 say
-- #12233). The draft's key item 2884 on bullet n=5 was a mismatch, and its completion sat on bullet 6: event 5 and the
-- completed bit belong to bullet 7 (the second check of the ???). The page's repeat ("after a Memory reset") is not modelled.
-- Crawlers' Nest ??? events 4 and 5 are not used: check_steps cannot find them (it matches a quest script only by title) and 5 completes the quest (the completed bit proves it).
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'Enveloped in Darkness',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after completing the crimson trial and'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 197, gained = true, why = 'old pocket watch obtained'},
            {t = 'ki_have', id = 197, have = true, why = 'old pocket watch held'},
            {t = 'chat', re = 'obtained key item: old pocket watch', why = 'chat: key item obtained'},
            {t = 'event', zone = 233, event = 92, conf = 'inferred', why = 'Curilla 92: reminder, only while accepted'},
            {t = 'chat', re = 'Often would my father visit that place%.', conf = 'inferred', why = 'Curilla 92 (say #7447)'},
         },
         reach = {{t = 'event', zone = 233, event = 94, why = 'Curilla 94 offered (its finish needs option 1)'},
                  {t = 'event', zone = 233, event = 95, why = 'Curilla 95 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'next go to the cathedral back'}},
        {id = 's3', at = {n = 3, fp = 'trade him a velvet cloth you'},
         done = {
            {t = 'event', zone = 231, event = 37, why = 'Pagisalis 37: the Velvet Cloth accepted'},
            {t = 'ki', id = 198, gained = true, why = 'old boots obtained'},
            {t = 'ki_have', id = 198, have = true, why = 'old boots held'},
            {t = 'chat', re = 'obtained key item: old boots', why = 'chat: key item obtained'},
            {t = 'ki', id = 197, gained = false, conf = 'inferred', why = 'old pocket watch handed over'},
            {t = 'event', zone = 231, event = 58, conf = 'inferred', why = 'Pagisalis 58: only once the ghost was seen'},
            {t = 'chat', re = 'You have angered His Holiness!', conf = 'inferred', why = 'Pagisalis 58 (say #12233)'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'speak to curilla again'},
         done = {
            {t = 'event', zone = 233, event = 101, why = 'Curilla 101: the optional ghost talk, only after the trade'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to crawlers nest and open'},
         done = {
            {t = 'ki', id = 201, gained = true, why = 'crawler blood obtained from the chest'},
            {t = 'ki_have', id = 201, have = true, why = 'crawler blood held'},
            {t = 'chat', re = 'obtained key item: crawler blood', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'on map 2 at i 10'},
         done = {
            {t = 'chat', re = 'You bury the', why = 'Crawlers Nest ??? 4, option 1 (IDs.lua 7287)'},
            {t = 'ki', id = 201, gained = false, after = 's5', why = 'crawler blood buried'},
            {t = 'ki', id = 198, gained = false, after = 's3', why = 'old boots buried'},
         }},
        {id = 's7', at = {n = 7, fp = 'check the again after about a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 14093, gained = true, conf = 'inferred', why = "Warlock's Boots gained (reward)"},
         }},
    },
}
