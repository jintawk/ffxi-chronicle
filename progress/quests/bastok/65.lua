-- Step progress for Eco-Warrior (Bastok) (Bastok quest 65). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Eco_Warrior.lua (Raifa 278 offers the quest and option 1 begins it; 283 is the
-- "already on another nation's Eco-Warrior" refusal and proves nothing; Degga 13 offers the ointment, 15 plays while it is on, 16
-- plays once the ore is held; the Gusgen Mines ??? plays OINTMENT_DRAWS_MONSTERS when the puddings spawn and gives the Indigested
-- ore 473 once they are dead; Raifa 280 is the reminder, 282 the reward talk with the ore: the reward is an item, so a full bag
-- plays 282 without completing); client event scripts S4 236_Raifa_010EC094.txt (278 accept branch say #8817, 280 say #8819,
-- 282 say #8820) and 196_Degga_010C4177.txt (13 say #7412, 15); zones/Gusgen_Mines/IDs.lua. The draft used Raifa 283 and Degga 16
-- as proof of earlier steps; both are dropped. Bullets 7 to 10 are tips. Repeatable after the next Conquest tally: the restart is
-- the next acceptance (the log bit counts for the first run only, run1).
-- Shared-signal audit: "The ointment's odor draws out the monsters" is also played by Eco-Warrior (Windurst): gated after s1.
return {
    title = 'Eco-Warrior (Bastok)',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to raifa d 6 in'},
         done = {
            {t = 'chat', re = 'Just head to the mines, and Degga, one of our V%.E%.R%.M%.I%.N%. field agents', why = 'Raifa 278, accept branch (say #8817)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 280, conf = 'inferred', run1 = true, why = 'Raifa 280: the reminder, only once accepted'},
            {t = 'chat', re = 'You can get the details of your assignment from Degga', conf = 'inferred', run1 = true, why = 'Raifa 280 (say #8819)'},
         },
         reach = {{t = 'event', zone = 236, event = 278, why = 'Raifa 278 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'head to gusgen mines and talk'},
         done = {
            {t = 'event', zone = 196, event = 13, why = 'Degga 13: the ointment offered'},
            {t = 'chat', re = 'Hey, thanks for coming%.%.%.', why = 'Degga 13 (say #7412)'},
            {t = 'event', zone = 196, event = 15, conf = 'inferred', why = 'Degga 15: plays while the ointment is on'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to h 6 to find'}},
        {id = 's4', at = {n = 4, fp = 'clicking the will spawn two pudding'},
         done = {
            {t = 'chat', re = "the ointment's odor draws out the monsters!", after = 's1', why = 'Gusgen Mines OINTMENT_DRAWS_MONSTERS: the puddings spawned'},
         }},
        {id = 's5', at = {n = 5, fp = 'click the after the nms are'},
         done = {
            {t = 'ki', id = 473, gained = true, why = 'indigested ore obtained'},
            {t = 'ki_have', id = 473, have = true, run1 = true, why = 'indigested ore held'},
            {t = 'chat', re = 'obtained key item: indigested ore', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to raifa in port bastok'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 473, gained = false, conf = 'inferred', why = 'indigested ore handed over'},
         },
         reach = {{t = 'event', zone = 236, event = 282, why = 'Raifa 282: the reward talk with the ore (a full bag plays it too, no completion)'}}},
    },
}
