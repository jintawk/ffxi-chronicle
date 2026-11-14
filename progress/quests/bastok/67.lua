-- Step progress for Shoot First, Ask Questions Later (Bastok quest 67). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Shoot_First_Ask_Questions_Later.lua (Cid 795 is the start talk and plays even with a
-- full bag, so the quest log and the Weapon training guide prove the step; 796 is the "cont" talk, only while accepted; 798 is the
-- finished-weapon trade (797, unfinished, is a refusal); the ??? in The Boyahda Tree gives the Annals of Truth after the NM;
-- 799 completes and takes the key items); client event script S4 for Cid (796 say #9046); key item ids from res/key_items.lua;
-- item 18146 from res/items.lua. The latent bullets are indented, so they are not steps; the fight bullet (n=7) has no signal.
-- Shared-signal audit: the weapon-skill trial key items 343 to 346 and their "obtained key item" lines are given by a dozen trial quests
-- (Bastok 66 to 69, San d'Oria 102, Windurst 85 to 88, Jeuno 59 and the Outlands ones). Weapon training guide (343): dropped (shared with every
-- trial quest, s1 has no earlier step). Map to the Annals of Truth (344) gain and line: gated after s1. Annals of Truth (345) gain and line:
-- gated after s5. Handing over 344 and 345: gated after s5 and s8. ki_have 343, 344 and 345 dropped (login snapshots would never pass a gate).
return {
    title = 'Shoot First, Ask Questions Later',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speaking with cid will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 18146, gained = true, conf = 'inferred', why = 'Gun of Trials gained (items can come from elsewhere)'},
            {t = 'event', zone = 237, event = 796, conf = 'inferred', why = 'Cid 796: only plays while accepted'},
            {t = 'chat', re = "What's wrong%? My weapon didn't backfire on you, did it%?", conf = 'inferred', why = 'Cid 796 (say #9046)'},
         },
         reach = {{t = 'event', zone = 237, event = 795, why = 'Cid 795 offered (plays whether or not the Gun fits in the bag)'}}},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'you will need to break the'}},
        {id = 's5', at = {n = 5, fp = 'trade the gun of trials back'},
         done = {
            {t = 'event', zone = 237, event = 798, why = 'Cid 798: the finished Gun accepted'},
            {t = 'ki', id = 344, gained = true, after = 's1', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'you will be instructed to travel'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'this fight is against beet leafhopper'}},
        {id = 's8', at = {n = 8, fp = 'once you kill it re examine'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's5', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's5', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'go back and speak with cid'},
         done = {
            {t = 'event', zone = 237, event = 799, why = 'Cid 799: only plays once the Annals of Truth is held'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 344, gained = false, conf = 'inferred', after = 's5', why = 'map to the Annals of Truth handed over'},
            {t = 'ki', id = 345, gained = false, conf = 'inferred', after = 's8', why = 'Annals of Truth handed over'},
         }},
    },
}
