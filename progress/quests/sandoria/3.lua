-- Step progress for The Pickpocket (San d'Oria quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Altiret begins the quest (s2): Miene's cutscene only sets a server variable.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Pickpocket.lua (Miene 502 sets Prog; Altiret 547 begins the quest;
-- Miene 549 gives the Eagle Button, 611 re-issues it; Esca 120 asks for evidence (123 plays once the glasses are held,
-- 122 is the wrong-item refusal); Esca 121 takes the button and gives the Gilt Glasses; Altiret 550 completes (551 is the
-- wrong-item refusal)); client event scripts S4 232_Miene_010E8007.txt, 232_Altiret_010E8008.txt, 100_Esca_010642A5.txt;
-- item ids from res/items.lua (578 Eagle Button, 579 Gilt Glasses). Disagreements with the draft: it mapped Esca 123 to the
-- "she demands evidence" bullet (that is 120; 123 comes after the glasses) and used the refusal event 122 as proof of the
-- trade; the rank-gated Miene line "You are an adventurer" is not shown to every player, so it is not used.
return {
    title = 'The Pickpocket',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to miene by the water'},
         done = {
            {t = 'event', zone = 232, event = 502, why = 'Miene 502: the burglary cutscene'},
            {t = 'chat', re = 'Nobody can catch Esca the Swift', why = 'Miene 502 (say_as #7478)'},
            {t = 'chat', re = "Say, that man needs help! Why don't you help him%?", why = 'Miene 502 end / 554 (say #7480)'},
            {t = 'event', zone = 232, event = 554, conf = 'inferred', why = 'Miene 554: repeat of the cutscene line, only after 502'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to altiret who asks you'},
         done = {
            {t = 'event', zone = 232, event = 547, why = 'Altiret 547'},
            {t = 'chat', re = "You%.%.%.saw her didn't you%?", why = 'Altiret 547 (say #7483)'},
            {t = 'quest', current = true, why = 'quest log: accepted (Altiret 547 begins the quest)'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to miene to obtain a'},
         done = {
            {t = 'event', zone = 232, event = 549, why = 'Miene 549'},
            {t = 'chat', re = 'Say, is this yours%? It looks like a button', why = 'Miene 549 (say #7486)'},
            {t = 'item', id = 578, gained = true, conf = 'inferred', why = 'Eagle Button gained (items can come from elsewhere)'},
            {t = 'event', zone = 232, event = 611, conf = 'inferred', why = 'Miene 611: button re-issue, only after 549'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'optional several guard and bystander npcs'}, done = {}},
        {id = 's5', at = {n = 5, fp = 'head out to west ronfaure and'},
         done = {
            {t = 'event', zone = 100, event = 120, why = 'Esca 120: demands evidence'},
            {t = 'chat', re = 'If you insist on playing the sheriff', why = 'Esca 120 (say #7394)'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the button to her prompting'},
         done = {
            {t = 'event', zone = 100, event = 121, why = 'Esca 121: the button accepted'},
            {t = 'chat', re = "Whoops, I've gone and said it now%.", why = 'Esca 121 (say #7396)'},
            {t = 'item', id = 579, gained = true, conf = 'inferred', why = 'Gilt Glasses gained (items can come from elsewhere)'},
            {t = 'event', zone = 100, event = 123, conf = 'inferred', why = 'Esca 123: plays only once the glasses are held or the quest is done'},
         }},
        {id = 's7', at = {n = 7, fp = 'after receiving the gilt glasses return'},
         done = {
            {t = 'event', zone = 232, event = 550, why = 'Altiret 550'},
            {t = 'chat', re = "Oooh! You've found them! My wife's", why = 'Altiret 550 (say #7505)'},
            {t = 'chat', re = "Please accept this%. Go ahead, it's yours%.", why = 'Altiret 550 (say #7506)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
