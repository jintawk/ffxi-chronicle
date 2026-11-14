-- Step progress for Old Wounds (San d'Oria quest 102). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Old_Wounds.lua (Curilla 43 offers it, the finish needs option 1 and then
-- gives the Sapara and key item 343 and begins the quest; 46 is her reminder while accepted; 44 is the exact trade of a
-- finished Sapara and gives key item 344 (45 is the unfinished-weapon refusal, never proof); 47 plays while 344 is held;
-- the Quicksand Caves ??? gives key item 345 after Girtablulu dies; 48 plays with 345 held and completes the quest);
-- client event script S4 233_Curilla_010E900C.txt (46 say #7927; 47 and 48 carry no usable line); key item ids from
-- res/key_items.lua. The draft put event 47 on the last bullet and the loss of 343/344 on the first and last: 47 only says
-- 344 is held, and abandoning (46 option 2) also removes 343 and 344, so neither loss is proof. The Loadstone is a permanent
-- key item from Open Sesame, not a gain of this quest, so the Quicksand Caves bullet is a note on the Annals bullet.
-- Shared-signal audit: key items 343, 344, 345 and their chat lines are shared with the other nations' weapon skill quests (Bastok, Windurst, Methods Create Madness, Souls in Shadow, Jeuno, outlands): 343 dropped (s1 keeps the accepted bit and Curilla 46), 344 and 345 gated after s1 (the accepted bit), all ki_have dropped.
return {
    title = 'Old Wounds',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speaking with curilla will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 233, event = 46, conf = 'inferred', why = 'Curilla 46: reminder, only once accepted'},
            {t = 'chat', re = 'Trade me the sword if you wish me to evaluate your progress', conf = 'inferred', why = 'Curilla 46 (say #7927)'},
         },
         reach = {{t = 'event', zone = 233, event = 43, why = 'Curilla 43 offered (its finish needs option 1)'}}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'the bight uragnite at k 8'}},
        {id = 's5', at = {n = 5, fp = 'trade the sapara of trials back'},
         done = {
            {t = 'event', zone = 233, event = 44, why = 'Curilla 44: the finished Sapara traded'},
            {t = 'ki', id = 344, gained = true, after = 's1', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's1', why = 'chat: key item obtained'},
            {t = 'event', zone = 233, event = 47, conf = 'inferred', why = 'Curilla 47: reminder, only while the map is held'},
         }},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'you will be instructed to travel'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'take echo drops and silent oil'}},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'head to western altepa desert you'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'once you are behind the altepa'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'this fight is against girtablulu a'}},
        {id = 's11', at = {n = 11, fp = 'once you kill it re examine'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's1', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's12', at = {n = 12, fp = 'go back and speak with curilla'},
         done = {
            {t = 'event', zone = 233, event = 48, why = 'Curilla 48: completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
