-- Step progress for The Walls of Your Mind (Bastok quest 69). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Walls_of_Your_Mind.lua (Oggbi 286 is the start talk and plays even with a full
-- bag, so the quest log and the Weapon training guide prove the step; 287 is the "cont" talk, only while accepted; 289 is the
-- finished-weapon trade (288, unfinished, is a refusal); the ??? in Bostaunieux Oubliette gives the Annals of Truth after Bodach;
-- 290 completes and takes the key items); client event script S4 for Oggbi (287 say #8846); key item ids from res/key_items.lua;
-- item 17507 from res/items.lua. The latent bullets are indented, so they are not steps; the travel bullet (n=7) is a note.
-- Shared-signal audit: the weapon-skill trial key items 343 to 346 and their "obtained key item" lines are given by a dozen trial quests
-- (Bastok 66 to 69, San d'Oria 102, Windurst 85 to 88, Jeuno 59 and the Outlands ones). Weapon training guide (343): dropped (shared with every
-- trial quest, s2 has no earlier step). Map to the Annals of Truth (344) gain and line: gated after s2. Annals of Truth (345) gain and line:
-- gated after s6. Handing over 344 and 345: gated after s6 and s8. ki_have 343, 344 and 345 dropped (login snapshots would never pass a gate).
return {
    title = 'The Walls of Your Mind',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with oggbi will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 17507, gained = true, conf = 'inferred', why = 'Knuckles of Trials gained (items can come from elsewhere)'},
            {t = 'event', zone = 236, event = 287, conf = 'inferred', why = 'Oggbi 287: only plays while accepted'},
            {t = 'chat', re = 'Why have you returned%? Do not tell me you shudder in the shadow of the wall that looms before you%?', conf = 'inferred', why = 'Oggbi 287 (say #8846)'},
         },
         reach = {{t = 'event', zone = 236, event = 286, why = 'Oggbi 286 offered (plays whether or not the Knuckles fit in the bag)'}}},
        {id = 's6', at = {n = 6, fp = 'trade the knuckles of trials back'},
         done = {
            {t = 'event', zone = 236, event = 289, why = 'Oggbi 289: the finished Knuckles accepted'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'unity npc warp 122 is available'}},
        {id = 's8', at = {n = 8, fp = 'this fight is against bodach a'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'go back and speak with oggbi'},
         done = {
            {t = 'event', zone = 236, event = 290, why = 'Oggbi 290: only plays once the Annals of Truth is held'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 344, gained = false, conf = 'inferred', after = 's6', why = 'map to the Annals of Truth handed over'},
            {t = 'ki', id = 345, gained = false, conf = 'inferred', after = 's8', why = 'Annals of Truth handed over'},
         }},
    },
}
