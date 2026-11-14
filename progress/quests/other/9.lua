-- Step progress for A Potter's Preference (quest other 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Mhaura/npcs/Nereus.lua (event 111 is the offer with two menus and adds the quest only
-- on option 1, so it is a reach; the accept path's last line "Just make sure to get a map" plays only on accept; 114 is his
-- talk while accepted; trading the Gusgen Clay is event 113, which pays and completes the quest, and works for a repeat run
-- after event 112 sets the repeat flag; 112 itself is an offer with a Yes/No menu whose "Very good!" line plays on Yes only;
-- 110 and 115 are the not-yet and cooldown lines). Client event script S4 249_Nereus_010F9023.txt (111 say #7037, 112 say
-- #7042, 113 say #7040, 114 say #7039). Repeatable (page meta, 8 hours): the repeat's accept line opens the next run, so the
-- quest-log matchers count for the first run only (run1). Gusgen Clay id 569 (LandSandBoat DISH_OF_GUSGEN_CLAY).
return {
    title = "A Potter's Preference",
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nereus i 8 near'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = 'Just make sure to get a map so you don\'t get lost in there', why = 'Nereus 111, accepted (say #7037)'},
            {t = 'chat', re = "Remember, it's in those mines I told you about before", why = 'Nereus 112, repeat accepted (say #7042)'},
            {t = 'event', zone = 249, event = 114, conf = 'inferred', why = 'Nereus 114: his talk, only while accepted'},
            {t = 'chat', re = 'Yes%? Did you forget something%?', conf = 'inferred', why = 'Nereus 114 (say #7039)'},
         },
         reach = {
            {t = 'event', zone = 249, event = 111, why = 'Nereus 111 offered (its finish needs option 1)'},
            {t = 'event', zone = 249, event = 112, why = 'Nereus 112 offered again after a run (Yes/No)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'go to i 7 third map'}},
        {id = 's3', at = {n = 3, fp = 'bring the gusgen clay back to'}, count = {item = 569, need = 1},
         done = {
            {t = 'event', zone = 249, event = 113, why = 'Nereus 113: the Gusgen Clay accepted, completes the quest'},
            {t = 'chat', re = 'Oho! Well done!', why = 'Nereus 113 (say #7040)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'you must wait 8 hours before'}},
    },
}
