-- Step progress for Order Up (Adoulin quest 30). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no quest script, only the five Western Adoulin visit NPCs (Terwok 67, Marjoirelle 68, Grevan 69,
-- Mastan 70, Oka Qhantari 71 each play once while the quest is accepted and set one bit of Order_Up_NPCs on finish, no
-- refusal). Client event scripts S4 256_Terwok_0110010E.txt, 256_Grevan_01100115.txt, 256_Mastan_0110010B.txt,
-- 256_Oka_Qhantari_01100100.txt. Those events prove one visit each, and bullet 4 is twelve visits (seven Eastern Adoulin NPCs
-- have no script), so nothing proves the bullet as a whole: it is a note on the return to Reja Ygridhi, which the log's completed
-- bit proves. The draft's "dinner invitation" (key item 2200) is another quest's item, not named by this page: dropped, as is
-- its completed bit on bullet 4 (the quest completes at bullet 5). The library card (2411, permanent) and the Twelve Orders
-- dossier (2381, temporary) are from res/key_items.lua; the card can be handed out by other Library quests, so it is inferred.
-- The quest is accepted at bullet 3 (the dossier is handed over then), so the log is silent before it. Not repeatable.
-- Shared-signal audit: the library card (2411, its chat line) is bought with bayld and also needed for mission 2-5-1 and the other Library quests, so both signals are dropped and bullet 1 is a note on bullet 3.
return {
    title = 'Order Up',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'obtain celennia memorial library card from'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak with reja ygridhi inside the'}},
        {id = 's3', at = {n = 3, fp = 'after a brief conversation and accepting'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Reja Ygridhi)'},
            {t = 'ki', id = 2381, gained = true, why = 'Twelve Orders dossier obtained'},
            {t = 'ki_have', id = 2381, have = true, why = 'Twelve Orders dossier held'},
            {t = 'chat', re = 'obtained key item: twelve orders dossier', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'visit the following people for each'}},
        {id = 's5', at = {n = 5, fp = 'return to reja ygridhi inside the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
