-- Step progress for From Saplings Grow (Windurst quest 85). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/From_Saplings_Grow.lua (Perih Vashai 661 plays whether or not the Bow of Trials
-- fits, then gives the bow and the Weapon Training Guide and begins the quest; 662 is the accepted-quest menu and its option 3
-- abandons the quest and takes both key items; 663 is an unfinished bow and refuses; 664 takes a finished bow and gives the
-- map; 665 is the reminder once the map is held; 666 completes the quest, takes the key items and teaches Empyreal Arrow;
-- Cape Teriggan qm1 pops Stolas, then gives the Annals of Truth); client event script S4 241_Perih_Vashai_010F1076.txt
-- (661 say #9748, 662 say #9752, 664 say #9761, 665 say #9764, 666 say #9766); zone texts SENSE_OMINOUS_PRESENCE and
-- EMPYREAL_ARROW_LEARNED. The draft counted the loss of key items 343 and 344 as completion, but option 3 of 662 takes them
-- too, and gave 665 to the last step although it plays before the Stolas fight; both fixed. Bullets 3 to 5 (the trial points) leave
-- no signal and stay plain bullets. Bullets 7 and 8 (travel) are notes on the fight. The quest log is set at s2, so it is not silent.
-- Weapon skill trial key items 343-345 and their 'obtained key item' lines are shared with the other weapon skill quests (bastok/66-69, sandoria/98 99 102, jeuno/59, windurst/85-87):
-- 343 gain, held checks (ki_have) and the guide line dropped from s2 (quest log and the NPC event prove it); 344 and 345 gains and lines gated after s2 / s6, ki_have dropped;
-- the 'You sense an ominous presence' reach is shared with every other NM pop of that kind: gated after s6.
return {
    title = 'From Saplings Grow',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with perih vashai will grant'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 662, conf = 'inferred', why = 'Perih Vashai 662: only once the quest is accepted'},
         },
         reach = {
            {t = 'event', zone = 241, event = 661, why = 'Perih Vashai 661 (also plays when the bow cannot be given)'},
            {t = 'chat', re = 'Do you know where your place is%?', why = 'Perih Vashai 661 (say #9748)'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the bow of trials back'},
         done = {
            {t = 'event', zone = 241, event = 664, why = 'Perih Vashai 664: a finished bow'},
            {t = 'chat', re = 'This bow is no longer the sapling I gave you%.', why = 'Perih Vashai 664 (say #9761)'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
            {t = 'event', zone = 241, event = 665, conf = 'inferred', why = 'Perih Vashai 665: the reminder, only once the map is held'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'take silent oil and prism powder'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'once you are at the cape'}},
        {id = 's9', at = {n = 9, fp = 'this fight is against stolas a'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'chat', re = 'You sense an ominous presence', after = 's6', why = 'qm1: Stolas pops (Cape Teriggan IDs.lua SENSE_OMINOUS_PRESENCE)'},
         }},
        {id = 's10', at = {n = 10, fp = 'go back and speak with perih'},
         done = {
            {t = 'event', zone = 241, event = 666, why = 'Perih Vashai 666: the Annals of Truth handed in'},
            {t = 'chat', re = 'It appears your arrows flew fast and true%.', why = 'Perih Vashai 666 (say #9766)'},
            {t = 'chat', re = 'You have learned the weapon skill Empyreal Arrow!', why = 'EMPYREAL_ARROW_LEARNED, only when the quest completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 345, gained = false, after = 's9', conf = 'inferred', why = 'Annals of Truth handed over'},
         }},
    },
}
