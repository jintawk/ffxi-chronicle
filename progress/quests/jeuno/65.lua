-- Step progress for The Circle of Time (Jeuno quest 65). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Circle_of_Time.lua. Mertaire (Lower Jeuno 245) plays hint 139 while the quest is
-- still available; the quest is added only by Imasuke (Port Jeuno 246: 30 and 29 are the long and short offers with a menu and
-- only option 1 begins it, so they are only a reach), so the log is silent before step 2; Perennial Snow (Xarcabard 112) plays
-- 3 when the ring is buried and 2 after the wait; Imasuke 33 follows with the ring cleaned; Chalvatot (Chateau d'Oraguille 233)
-- plays 99 or 98 (option 1 gives the Moon ring, option 0 declines, so they are only a reach) and then 97 as a reminder; the
-- Altar (Monastic Cavern 150) plays 3 after Bugaboo falls and on option 0 takes the Star ring and the Moon ring; Chalvatot 96
-- runs quest:complete and cannot give the Choral Justaucorps on a full bag while 96 still plays, so it is only a reach and the
-- quest log's completed bit carries the last step. Client event scripts S4 245_Mertaire_010F501C.txt (139 say #8071),
-- 246_Imasuke_010F6008.txt (33 say #7333), 233_Chalvatot_010E900E.txt (97 say #7504), 112_Perennial_Snow_0107015B.txt and
-- 150_Altar_010960DD.txt (3, 2: bare cutscenes). Key item ids from res/key_items.lua (227 moon ring, used by no other quest; the star ring 225 is shared with The Requiem, so it is not used here). The Bugaboo pop has no event, so that bullet and the
-- Davoi travel bullets stay plain or notes. Not repeatable (page meta).
return {
    title = 'The Circle of Time',
    completes = 's11',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to mertaire in lower jeuno'},
         done = {
            {t = 'event', zone = 245, event = 139, why = 'Mertaire 139: the hint, while the quest is still available'},
            {t = 'chat', re = 'So, what did you do with that ring%?', why = 'Mertaire 139 (say #8071)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to imasuke e 6 in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Imasuke 30 or 29, option 1)'},
         },
         reach = {{t = 'event', zone = 246, event = 30, why = 'Imasuke 30 offered (its finish needs option 1)'},
                  {t = 'event', zone = 246, event = 29, why = 'Imasuke 29 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'travel to i 10 in xarcabard'},
         done = {
            {t = 'event', zone = 112, event = 3, why = 'Perennial Snow 3: the ring buried'},
         }},
        {id = 's4', at = {n = 4, fp = 'retrieve the star ring indecipherable by'},
         done = {
            {t = 'event', zone = 112, event = 2, why = 'Perennial Snow 2: the ring retrieved'},
         }},
        {id = 's5', at = {n = 5, fp = 'go back to imasuke who tells'},
         done = {
            {t = 'event', zone = 246, event = 33, why = 'Imasuke 33: the cleaned ring'},
            {t = 'chat', re = 'Well, look at this! Clean as a whistle!', why = 'Imasuke 33 (say #7333)'},
         }},
        {id = 's6', at = {n = 6, fp = 'head to chateau d oraguille and'},
         done = {
            {t = 'ki', id = 227, gained = true, why = 'moon ring obtained'},
            {t = 'ki_have', id = 227, have = true, why = 'moon ring held'},
            {t = 'chat', re = 'obtained key item: moon ring', why = 'chat: key item obtained'},
            {t = 'event', zone = 233, event = 97, conf = 'inferred', why = 'Chalvatot 97: the reminder, only once the Moon ring is given'},
            {t = 'chat', re = 'Take the two rings and place them upon the altar', conf = 'inferred', why = 'Chalvatot 97 (say #7504)'},
         },
         reach = {{t = 'event', zone = 233, event = 99, why = 'Chalvatot 99 (option 1 gives the Moon ring, option 0 declines)'},
                  {t = 'event', zone = 233, event = 98, why = 'Chalvatot 98 (option 1 gives the Moon ring)'}}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'listen to his instructions and travel'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'walk to the small circular room'}},
        {id = 's10', at = {n = 10, fp = 'defeat him then examine the altar'},
         done = {
            {t = 'ki', id = 227, gained = false, why = 'moon ring placed on the altar'},
         },
         reach = {{t = 'event', zone = 150, event = 3, why = 'Altar 3: the cutscene (the rings go on option 0)'}}},
        {id = 's11', at = {n = 11, fp = 'return and speak to chalvatot for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 233, event = 96, why = 'Chalvatot 96 (also plays when the Choral Justaucorps cannot be given)'}}},
    },
}
