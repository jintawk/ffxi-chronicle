-- Step progress for Only the Best (quest other 18). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Selbina/npcs/Melyon.lua (event 60 is the offer with a Yes/No menu and its finish adds
-- the quest on option 10 only, so it is a reach, and the "Ye will? Tha's a braw lad" line plays on Yes only; the three trade
-- events 62 (five La Theine Cabbage), 63 (three Millioncorn) and 64 (one Boyahda Moss) each pay gil and complete the quest,
-- no item reward, and any of them works whether or not the quest was ever accepted; 61 is his reminder in every state and
-- proves nothing). Client event script S4 248_Melyon_010F8019.txt (60 say #6758, 62-64 say #6762). Repeatable (page meta),
-- but a repeat is the same trade with no new accept, so there is no restart step and no `repeatable` entry (as bastok 14).
-- The log is flagged only at the accept and the trade can be the very first contact, so s1 is not silent; three tip
-- bullets (2 to 5) are not steps. Not tracked: the repeats.
return {
    title = 'Only the Best',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade melyon any of the following'},
         done = {
            {t = 'event', zone = 248, event = 62, why = 'Melyon 62: five La Theine Cabbage accepted, completes the quest'},
            {t = 'event', zone = 248, event = 63, why = 'Melyon 63: three Millioncorn accepted, completes the quest'},
            {t = 'event', zone = 248, event = 64, why = 'Melyon 64: Boyahda Moss accepted, completes the quest'},
            {t = 'chat', re = "Ye've brought me these", why = 'Melyon 62/63/64 (say #6762)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'Ye will%? Tha\'s a', why = 'Melyon 60, accepted (say #6758)'},
            {t = 'event', zone = 248, event = 60, why = 'Melyon 60 offered (its finish needs option 10)'},
         }},
    },
}
