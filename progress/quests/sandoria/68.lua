-- Step progress for Trouble at the Sluice (San d'Oria quest 68). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Trouble_at_the_Sluice.lua (Belgidiveau 57 option 0 begins the quest; 55 is
-- his reminder; Novalmauge 15 is the first talk, 16 his reminder, 17 the Dahlia trade that gives key item 166; Belgidiveau 56
-- completes and takes the key item); client event scripts S4 231_Belgidiveau_010E7068.txt (57 say #11543 on the accept
-- branch, 55 say #11545, 56 say #11546) and 167_Novalmauge_010A7107.txt (15 say #7370, 16 say #7373, 17 say #7375); key
-- item id from res/key_items.lua. The draft offered event 16 for the trade: it is the reminder and plays before the trade
-- too, so it proves only the talk before it. Event 56 plays whether or not the reward (Heavy Axe) fits; quest:complete
-- fails in the finish with a full bag, so 56 and its line are reach and the completed bit proves the last step. The quest
-- log is set at s1.
return {
    title = 'Trouble at the Sluice',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to belgidiveau to begin the'},
         done = {
            {t = 'chat', re = 'That is good news, indeed!', why = 'Belgidiveau 57, accepted (say #11543)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 55, conf = 'inferred', why = 'Belgidiveau 55: reminder, only once accepted'},
            {t = 'chat', re = "It's no easy task, finding a neutralizer, is it%?", conf = 'inferred', why = 'Belgidiveau 55 (say #11545)'},
         },
         reach = {{t = 'event', zone = 231, event = 57, why = 'Belgidiveau 57 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to novalmauge bostaunieux oubliette g'},
         done = {
            {t = 'event', zone = 167, event = 15, why = 'Novalmauge 15: first talk'},
            {t = 'chat', re = 'Eh%? Someone threw poison in the water by the sluice gate%?', why = 'Novalmauge 15 (say #7370)'},
            {t = 'event', zone = 167, event = 16, conf = 'inferred', why = 'Novalmauge 16: reminder, only after the first talk'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade novalmauge a dahlia to receive'},
         done = {
            {t = 'event', zone = 167, event = 17, why = 'Novalmauge 17: the Dahlia trade'},
            {t = 'chat', re = 'There! With this all will be well%.', why = 'Novalmauge 17 (say #7375)'},
            {t = 'ki', id = 166, gained = true, why = 'neutralizer obtained'},
            {t = 'ki_have', id = 166, have = true, why = 'neutralizer held'},
            {t = 'chat', re = 'obtained key item: neutralizer', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to belgidiveau to complete this'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 166, gained = false, conf = 'inferred', why = 'neutralizer handed over'},
         },
         reach = {
            {t = 'event', zone = 231, event = 56, why = 'Belgidiveau 56: plays even when the Heavy Axe does not fit'},
            {t = 'chat', re = "You've got the neutralizer!", why = 'Belgidiveau 56 (say #11546)'},
         }},
    },
}
