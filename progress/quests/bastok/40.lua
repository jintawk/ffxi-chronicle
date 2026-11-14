-- Step progress for The Darksmith (Bastok quest 40). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Darksmith.lua (Mighty Fist 565 begins the quest on finish, no refusal
-- branch, Bastok rank 3; his first talk afterwards is 561 (the forge speech, 560 on later talks); trading exactly 2 Darksteel
-- Ore is event 566, which runs quest:complete); client event script S4 237_Mighty_Fist_010ED03A.txt (565 say #8022, 561 say
-- #7905, 566 say #8025); item id from res/items.lua (645 Darksteel Ore). The quest log is set at the accept. The first
-- bullet (get the ores) is a note on the start talk. The quest is repeatable at once, but a repeat needs no new accept (the
-- trade alone, same event 566), so there is no `repeatable` entry.
return {
    title = 'The Darksmith',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain 2 darksteel ores via the'}},
        {id = 's2', at = {n = 2, fp = 'speak to mighty fist on the'},
         done = {
            {t = 'event', zone = 237, event = 565, why = 'Mighty Fist 565: the quest begun'},
            {t = 'chat', re = "You've become quite an experienced adventurer, I hear%.", why = 'Mighty Fist 565 (say #8022)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 237, event = 561, conf = 'inferred', why = 'Mighty Fist 561: first talk once the quest is begun'},
            {t = 'chat', re = 'This is the Darksteel Forge%.', conf = 'inferred', why = 'Mighty Fist 561 (say #7905)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade him the two ores to'}, count = {item = 645, need = 2},
         done = {
            {t = 'event', zone = 237, event = 566, why = 'Mighty Fist 566: 2 Darksteel Ore accepted, completes the quest'},
            {t = 'chat', re = 'Thank you%. Here is your payment%.', why = 'Mighty Fist 566 (say #8025)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'you may immediately repeat this quest'}},
    },
}
