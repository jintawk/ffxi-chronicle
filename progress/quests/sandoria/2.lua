-- Step progress for Rosel the Armorer (San d'Oria quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Rosel_the_Armorer.lua (Rosel 523/524 option 0 begins the quest and gives
-- the receipt, key item 119; Guilerme 507 takes it; Rosel 527 pays 100 or 200 gil and completes it); client event scripts
-- S4 230_Rosel_010E605A.txt (523/524 accept branch say #7824; 527 say #7838 / #7841 / #7842) and 231_Guilerme_010E7005.txt
-- (507 say #11373); key item ids from res/key_items.lua. The draft missed event 527 (no bullet names Rosel there) and
-- guessed the completion: 527 is the completing event, so it proves the last bullet. The quest log is set at s1.
-- Rosel's "Begging your pardon" and "Oh, it's you again" lines also play when the offer is refused, so they are not used.
return {
    title = 'Rosel the Armorer',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'upon speaking to rosel in southern'},
         done = {
            {t = 'chat', re = "I thank you%. Remember, it's for Prince", why = 'Rosel 523/524, accepted (say #7824)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 119, gained = true, why = 'receipt for the prince obtained'},
            {t = 'ki_have', id = 119, have = true, why = 'receipt for the prince held'},
            {t = 'chat', re = 'obtained key item: receipt for the prince', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 230, event = 523, why = 'Rosel 523 offered (its finish needs option 0)'},
                  {t = 'event', zone = 230, event = 524, why = 'Rosel 524 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'leave rosel s armour shop and'}},
        {id = 's3', at = {n = 3, fp = 'look for the npc guilerme a'},
         done = {
            {t = 'event', zone = 231, event = 507, why = 'Guilerme 507'},
            {t = 'chat', re = "A receipt, eh%? I can't read this fancy writing", why = 'Guilerme 507 (say #11373)'},
            {t = 'ki', id = 119, gained = false, conf = 'inferred', why = 'receipt for the prince handed over'},
         }},
        {id = 's4', at = {n = 4, fp = 'after the cutscene with guilerme is'},
         done = {
            {t = 'event', zone = 230, event = 527, why = 'Rosel 527: the reward'},
            {t = 'chat', re = "Ah, thanks for your help%. It's not much, but please accept this as payment", why = 'Rosel 527, right prince (say #7838)'},
            {t = 'chat', re = "That's what I get for sending a recruit", why = 'Rosel 527, wrong prince (say #7841)'},
            {t = 'chat', re = 'What%? They complained about your attire%?', why = 'Rosel 527, both branches (say #7842)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
