-- Step progress for The Stars of Ifrit (Bastok quest 42). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Stars_of_Ifrit.lua (Agapito 180 begins the quest on finish, no refusal
-- branch, with the Airship pass and Bastok rank 3 as the gate; the ??? on the San d'Oria-Jeuno airship gives the permanent
-- Carrier pigeon letter while the quest is accepted; Agapito 181 plays only with the letter held and runs quest:complete);
-- client event script S4 236_Agapito_010EC01E.txt (180 say #7648, 181 say #7653); key item ids from res/key_items.lua (8
-- airship pass, 162 carrier pigeon letter). The first bullet is the Airship pass prerequisite, a note on the start talk (event
-- 180 cannot play without the pass). The quest log is set at the accept, so no step is silent. Not repeatable.
return {
    title = 'The Stars of Ifrit',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you may work on this quest'}},
        {id = 's2', at = {n = 2, fp = 'if you fulfill all the prerequisites'},
         done = {
            {t = 'event', zone = 236, event = 180, why = 'Agapito 180: the quest begun'},
            {t = 'chat', re = "Ah! An adventurer! And I see you've also earned your", why = 'Agapito 180 (say #7648)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'during a full moon at night'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'search for an abnormal somewhere on'}},
        {id = 's5', at = {n = 5, fp = 'touch the to receive the carrier'},
         done = {
            {t = 'ki', id = 162, gained = true, why = 'carrier pigeon letter obtained'},
            {t = 'ki_have', id = 162, have = true, why = 'carrier pigeon letter held'},
            {t = 'chat', re = 'obtained key item: carrier pigeon letter', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to agapito to complete the'},
         done = {
            {t = 'event', zone = 236, event = 181, why = 'Agapito 181: the letter shown, completes the quest'},
            {t = 'chat', re = 'Ah! Let me see! Let me see!', why = 'Agapito 181 (say #7653)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
