-- Step progress for The Weight of Your Limits (Bastok quest 66). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Weight_of_Your_Limits.lua (Iron Eater 790 is the start talk: it plays whenever
-- the quest is available, even if the bag is full, so only the quest log and the Weapon training guide prove the step; 791 is
-- the "cont" talk, only while accepted; 793 is the finished-weapon trade (792, unfinished, is a refusal and proves nothing);
-- the ??? in The Sanctuary of Zi'Tah gives the Annals of Truth after the NM falls; 794 completes and takes all three key items);
-- client event script S4 237_Iron_Eater_010ED030.txt (791 say #9019); key item ids from res/key_items.lua; item 16735 from
-- res/items.lua. The latent bullets are indented, so they are not steps.
-- Shared-signal audit: the weapon-skill trial key items 343 to 346 and their "obtained key item" lines are given by a dozen trial quests
-- (Bastok 66 to 69, San d'Oria 102, Windurst 85 to 88, Jeuno 59 and the Outlands ones). Weapon training guide (343): dropped (shared with every
-- trial quest, s2 has no earlier step). Map to the Annals of Truth (344) gain and line: gated after s2. Annals of Truth (345) gain and line:
-- gated after s6. Handing over 344 and 345: gated after s6 and s7. ki_have 343, 344 and 345 dropped (login snapshots would never pass a gate).
return {
    title = 'The Weight of Your Limits',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with iron eater will grant'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 16735, gained = true, conf = 'inferred', why = 'Axe of Trials gained (items can come from elsewhere)'},
            {t = 'event', zone = 237, event = 791, conf = 'inferred', why = 'Iron Eater 791: only plays while accepted'},
            {t = 'chat', re = 'Is something wrong%? Are you giving up so easily%?', conf = 'inferred', why = 'Iron Eater 791 (say #9019)'},
         },
         reach = {{t = 'event', zone = 237, event = 790, why = 'Iron Eater 790 offered (plays whether or not the Axe fits in the bag)'}}},
        {id = 's6', at = {n = 6, fp = 'trade the axe of trials back'},
         done = {
            {t = 'event', zone = 237, event = 793, why = 'Iron Eater 793: the finished Axe accepted'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'this fight is against greenman a'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'go back and speak with iron'},
         done = {
            {t = 'event', zone = 237, event = 794, why = 'Iron Eater 794: only plays once the Annals of Truth is held'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 344, gained = false, conf = 'inferred', after = 's6', why = 'map to the Annals of Truth handed over'},
            {t = 'ki', id = 345, gained = false, conf = 'inferred', after = 's7', why = 'Annals of Truth handed over'},
         }},
    },
}
