-- Step progress for Orastery Woes (Windurst quest 86). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Orastery_Woes.lua (Kuroido-Moido 578 plays whether or not the Club of Trials
-- fits, then gives the club and the Weapon Training Guide and begins the quest; 579 is the accepted-quest menu and its option 3
-- abandons the quest and takes both key items; 580 is an unfinished club and refuses; 581 takes a finished club and gives the
-- map; 582 is the reminder once the map is held; 583 completes the quest, takes the key items and teaches Black Halo; Ro'Maeve
-- qm1 pops Eldhrimnir, then gives the Annals of Truth); client event script S4 240_Kuroido_Moido_010F0012.txt (579 say #12658,
-- 581 say #12667, 582 say #12672, 583 say #12674); zone texts SENSE_OMINOUS_PRESENCE (RoMaeve) and BLACK_HALO_LEARNED (Port
-- Windurst). The draft counted the loss of key items 343 and 344 as completion, but option 3 of 579 takes them too, and gave 582
-- to the last step although it plays before the Eldhrimnir fight; both fixed. Bullets 3 to 5 (the trial points) leave no signal
-- and stay plain bullets. Bullets 7 to 9 (travel) are notes on the fight. The quest log is set at s2, so it is not silent.
-- Weapon skill trial key items 343-345 and their 'obtained key item' lines are shared with the other weapon skill quests (bastok/66-69, sandoria/98 99 102, jeuno/59, windurst/85-87):
-- 343 gain, held checks (ki_have) and the guide line dropped from s2 (quest log and the NPC event prove it); 344 and 345 gains and lines gated after s2 / s6, ki_have dropped;
-- the 'You sense an ominous presence' reach is shared with every other NM pop of that kind: gated after s6.
return {
    title = 'Orastery Woes',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with kuroido moido will grant'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 579, conf = 'inferred', why = 'Kuroido-Moido 579: only once the quest is accepted'},
         },
         reach = {
            {t = 'event', zone = 240, event = 578, why = 'Kuroido-Moido 578 (also plays when the club cannot be given)'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the club of trials back'},
         done = {
            {t = 'event', zone = 240, event = 581, why = 'Kuroido-Moido 581: a finished club'},
            {t = 'chat', re = "Good work%. We've managed to compile%-wile some useful data", why = 'Kuroido-Moido 581 (say #12667)'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
            {t = 'event', zone = 240, event = 582, conf = 'inferred', why = 'Kuroido-Moido 582: the reminder, only once the map is held'},
         }},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'take silent oil and head to'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'inside ro maeve go down the'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'through the door turn right and'}},
        {id = 's10', at = {n = 10, fp = 'this fight is against eldhrimnir a'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'chat', re = 'You sense an ominous presence', after = 's6', why = 'qm1: Eldhrimnir pops (Ro\'Maeve IDs.lua SENSE_OMINOUS_PRESENCE)'},
         }},
        {id = 's11', at = {n = 11, fp = 'go back and speak with kuroido'},
         done = {
            {t = 'event', zone = 240, event = 583, why = 'Kuroido-Moido 583: the Annals of Truth handed in'},
            {t = 'chat', re = "Amazing! You've returned victorious!", why = 'Kuroido-Moido 583 (say #12674)'},
            {t = 'chat', re = 'You have learned the weapon skill Black Halo!', why = 'BLACK_HALO_LEARNED, only when the quest completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 345, gained = false, after = 's10', conf = 'inferred', why = 'Annals of Truth handed over'},
         }},
    },
}
