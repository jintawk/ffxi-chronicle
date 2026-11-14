-- Step progress for Emissaries of God (Abyssea quest 182). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/abyssea/Emissaries_of_God.lua; client event script S4 246_Joachim_010F6093.txt (Port
-- Jeuno: event 344 has no text). The quest is flagged when Death and Rebirth completes, so the log's current bit says nothing
-- about a step and bullets 1 to 3 (kill the six caturae, the titles they give, the list) are notes on bullet 4. Joachim 344
-- is a cutscene that plays only with the quest held and all six titles owned; it has no refusal branch and its finish gives
-- the Abyssite of discernment (key item 1442, given by this event alone) and sets Prog 1, so it proves bullet 4. The completion
-- is NOT at Joachim, as the draft guessed: quest:complete runs in the Hall of the Gods zone-in cutscene (event 8, only between
-- 18:00 and 5:00 and only at Prog 1), so bullet 5 carries the zone-in and the log's completed bit. Hall of the Gods zone-in
-- 6, 7 and 9 belong to A Sea Dog's Summons, Death and Rebirth and Meanwhile, Back on Abyssea; 8 is this quest's alone. Not
-- repeatable. Shared-signal audit: event 344 and 1442 are used by no other quest or progress file; the Hall of the Gods
-- zone-in is not gated because event 8 names this quest only.
return {
    title = 'Emissaries of God',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'defeat all 6 known subspecies of'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'obtaining the title associated with each'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'the titles necessary are'}},
        {id = 's4', at = {n = 4, fp = 'talk to joachim after killing all'},
         done = {
            {t = 'event', zone = 246, event = 344, why = 'Joachim 344: the cutscene, gives the Abyssite of discernment'},
            {t = 'ki', id = 1442, gained = true, why = 'abyssite of discernment obtained'},
            {t = 'ki_have', id = 1442, have = true, why = 'abyssite of discernment held'},
            {t = 'chat', re = 'obtained key item: abyssite of discernment', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'enter the hall of the gods'},
         done = {
            {t = 'zonein', zone = 251, event = 8, why = 'Hall of the Gods zone-in 8: the night cutscene, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
