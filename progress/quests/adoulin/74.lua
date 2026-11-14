-- Step progress for Exotic Delicacies (Adoulin quest 74). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Western_Adoulin/npcs/Flapano.lua (every other talk offers the quest with event 2860, whose
-- finish adds the quest only on option 1, so the event and its first lines play on a refusal too; the line "Yer a real pal!"
-- (say #8096) plays only on the accepting choice, and the log flags the quest there; trading exactly 1 Saffron, 2 Barnacles and
-- 1 Mussel plays 2861, which runs npcUtil.completeQuest and gives a Plate of Flapano's Paella, so 2861 replays on a full bag
-- and is only a reach: the completed bit proves the hand-in; 2862 (a paella traded) is a refusal and 2863 is the reminder
-- talk, shared with another quest in the client, so neither is used). The log is flagged at the first bullet, so it is not
-- silent. Bullet 2 only lists the three ingredients (a note on the hand-in). Client event script S4 256_Flapano_01100104.txt
-- (2860 menu #8094 and accepting line #8096, 2861 say #8099).
return {
    title = 'Exotic Delicacies',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to flapano i 8 to'},
         done = {
            {t = 'chat', re = 'Yer a real pal! Here', why = 'Flapano 2860, accepting choice only (say #8096)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'he requires 1 saffron 2 barnacles'}},
        {id = 's3', at = {n = 3, fp = 'return with the ingredients for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 256, event = 2861, why = 'Flapano 2861: the exact trade (replays if the Plate of Flapano\'s Paella cannot be given)'},
            {t = 'chat', re = 'Gotta love that pioneer dependability%.', why = 'Flapano 2861 (say #8099)'},
         }},
    },
}
