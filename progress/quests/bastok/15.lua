-- Step progress for Smoke on the Mountain (Bastok quest 15). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Smoke_on_the_Mountain.lua (Hungry Wolf 428 in Metalworks begins the quest;
-- trading the Galkan Sausage is event 429, which runs quest:complete and pays 300 gil; Offa 222 in Bastok Markets plays only
-- once accepted) and zones/South_Gustaberg/npcs/qm2.lua (the campfire: FIRE_PUT only after a Giant Sheep Meat trade that
-- succeeded, FIRE_TAKE only when the sausage was given); client event scripts S4 237_Hungry_Wolf_010ED027.txt (428 say
-- #7519, 429 say #7523 with a placeholder) and 235_Offa_010EB02A.txt (222 say #7509). The two campfire lines are zone texts
-- from South_Gustaberg/IDs.lua (7430 and 7431), so check_steps warns that they sit in another zone. The Offa sub-bullet is an
-- indented optional bullet, not a step; his 222 only supports bullet 1. Bullets 2, 3 and 5 (get the meat, travel, wait) have
-- no signal and are notes. The quest is repeatable, but a repeat needs no new accept (campfire and trade only), so there is
-- no `repeatable` entry. The quest log is set at s1, so it is not silent.
return {
    title = 'Smoke on the Mountain',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to hungry wolf inside the'},
         done = {
            {t = 'event', zone = 237, event = 428, why = 'Hungry Wolf 428'},
            {t = 'chat', re = "The food here isn't bad, but a little more variety wouldn't hurt, you know what I mean%?", why = 'Hungry Wolf 428 (say #7519)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 235, event = 222, conf = 'inferred', why = 'Offa 222: plays only once accepted'},
            {t = 'chat', re = 'Hungry Wolf told you about', conf = 'inferred', why = 'Offa 222 (say #7509)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'obtain a giant sheep meat from'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to south gustaberg k 9'}},
        {id = 's4', at = {n = 4, fp = 'trade the giant sheep meat to'},
         done = {
            {t = 'chat', re = 'You put .- in the fire%.', why = 'campfire: the meat put in (zone text 7430, only after the trade succeeded)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'wait for a minute earth time'}},
        {id = 's6', at = {n = 6, fp = 'after the required wait time check'},
         done = {
            {t = 'chat', re = 'You take .- out of the fire%.', why = 'campfire: the sausage taken out (zone text 7431, only when given)'},
         }},
        {id = 's7', at = {n = 7, fp = 'trade the galkan sausage to hungry'},
         done = {
            {t = 'event', zone = 237, event = 429, why = 'Hungry Wolf 429: the Galkan Sausage trade'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
