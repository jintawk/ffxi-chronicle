-- Step progress for Blood and Glory (Windurst quest 87). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Blood_and_Glory.lua (Shantotto 445 plays whether or not the Pole of Trials
-- fits, then gives the pole and the Weapon Training Guide and begins the quest; 446 is the accepted-quest menu and its option 3
-- abandons the quest and takes both key items; 447 is an unfinished pole and refuses; 448 takes a finished pole and gives the
-- map; 449 is the reminder once the map is held; 450 completes the quest, takes the key items and teaches Retribution; Ifrit's
-- Cauldron qm3 pops Cailleach Bheur, then gives the Annals of Truth); client event script S4 239_Shantotto_010EF01A.txt (446
-- say #9089, 448 say #9091, 449 say #9095, 450 say #9097); zone texts SENSE_OMINOUS_PRESENCE (Ifrit's Cauldron) and
-- RETRIBUTION_LEARNED (Windurst Walls). The draft counted the loss of key items 343 and 344 as completion, but option 3 of 446
-- takes them too, and gave 449 to the last step although it plays before the Cailleach Bheur fight; both fixed. Bullets 3 to 5
-- (the trial points) leave no signal and stay plain bullets. Bullets 7 and 8 (routes to the ???) are notes on the fight; 9 to 11 sit in an indented list and are not steps. The quest
-- log is set at s2, so it is not silent.
-- Weapon skill trial key items 343-345 and their 'obtained key item' lines are shared with the other weapon skill quests (bastok/66-69, sandoria/98 99 102, jeuno/59, windurst/85-87):
-- 343 gain, held checks (ki_have) and the guide line dropped from s2 (quest log and the NPC event prove it); 344 and 345 gains and lines gated after s2 / s6, ki_have dropped;
-- the 'You sense an ominous presence' reach is shared with every other NM pop of that kind: gated after s6.
return {
    title = 'Blood and Glory',
    completes = 's13',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with shantotto will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 239, event = 446, conf = 'inferred', why = 'Shantotto 446: only once the quest is accepted'},
         },
         reach = {
            {t = 'event', zone = 239, event = 445, why = 'Shantotto 445 (also plays when the pole cannot be given)'},
            {t = 'chat', re = 'The snap in the wrist, a sturdy arm%.', why = 'Shantotto 445 (say #9073)'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the pole of trials back'},
         done = {
            {t = 'event', zone = 239, event = 448, why = 'Shantotto 448: a finished pole'},
            {t = 'chat', re = "Oho! You've done a masterful job of demolishing that staff!", why = 'Shantotto 448 (say #9091)'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
            {t = 'event', zone = 239, event = 449, conf = 'inferred', why = 'Shantotto 449: the reminder, only once the map is held'},
         }},
        {id = 's7', kind = 'note', with = 's12', at = {n = 7, fp = 'take ifrit s cauldron hp 1'}},
        {id = 's8', kind = 'note', with = 's12', at = {n = 8, fp = 'alternatively if you don t have'}},
        {id = 's12', at = {n = 12, fp = 'this fight is against cailleach bheur'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'chat', re = 'You sense an ominous presence', after = 's6', why = 'qm3: Cailleach Bheur pops (Ifrit\'s Cauldron IDs.lua SENSE_OMINOUS_PRESENCE)'},
         }},
        {id = 's13', at = {n = 13, fp = 'go back and speak with shantotto'},
         done = {
            {t = 'event', zone = 239, event = 450, why = 'Shantotto 450: the Annals of Truth handed in'},
            {t = 'chat', re = 'Oho! The triumphantaru hero has returned!', why = 'Shantotto 450 (say #9097)'},
            {t = 'chat', re = 'You have learned the weapon skill Retribution!', why = 'RETRIBUTION_LEARNED, only when the quest completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 345, gained = false, after = 's12', conf = 'inferred', why = 'Annals of Truth handed over'},
         }},
    },
}
