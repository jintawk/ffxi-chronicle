-- Step progress for Inheritance (Bastok quest 68). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Inheritance.lua (Gumbah 190 is the start talk and plays even with a full bag, so the
-- quest log and the Weapon training guide prove the step; 191 is the "cont" talk, only while accepted; 193 is the finished-weapon
-- trade (192, unfinished, is a refusal); the ??? in Western Altepa Desert gives the Annals of Truth after Maharaja; 194 completes,
-- takes the key items and shows Ground Strike learned); client event script S4 for Gumbah (191 say #11739); key item ids from
-- res/key_items.lua; item 16952 from res/items.lua. The latent bullets are indented, so they are not steps; the travel and spawn
-- bullets (n=7, n=8) have no signal of their own.
-- Shared-signal audit: the weapon-skill trial key items 343 to 346 and their "obtained key item" lines are given by a dozen trial quests
-- (Bastok 66 to 69, San d'Oria 102, Windurst 85 to 88, Jeuno 59 and the Outlands ones). Weapon training guide (343): dropped (shared with every
-- trial quest, s2 has no earlier step). Map to the Annals of Truth (344) gain and line: gated after s2. Annals of Truth (345) gain and line:
-- gated after s6. Handing over 344 and 345: gated after s6 and s9. ki_have 343, 344 and 345 dropped (login snapshots would never pass a gate).
return {
    title = 'Inheritance',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with gumbah will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 16952, gained = true, conf = 'inferred', why = 'Sword of Trials gained (items can come from elsewhere)'},
            {t = 'event', zone = 234, event = 191, conf = 'inferred', why = 'Gumbah 191: only plays while accepted'},
            {t = 'chat', re = "What's wrong%? You didn't go and lose the sword now, did you%?", conf = 'inferred', why = 'Gumbah 191 (say #11739)'},
         },
         reach = {{t = 'event', zone = 234, event = 190, why = 'Gumbah 190 offered (plays whether or not the Sword fits in the bag)'}}},
        {id = 's6', at = {n = 6, fp = 'trade the sword of trials back'},
         done = {
            {t = 'event', zone = 234, event = 193, why = 'Gumbah 193: the finished Sword accepted'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'next travel to the oasis in'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'examine the on the south side'}},
        {id = 's9', at = {n = 9, fp = 're examine the after winning to'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's10', at = {n = 10, fp = 'go back and speak with gumbah'},
         done = {
            {t = 'event', zone = 234, event = 194, why = 'Gumbah 194: only plays once the Annals of Truth is held'},
            {t = 'chat', re = 'You have learned the weapon skill Ground Strike!', why = 'Gumbah 194 (GROUND_STRIKE_LEARNED)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 344, gained = false, conf = 'inferred', after = 's6', why = 'map to the Annals of Truth handed over'},
            {t = 'ki', id = 345, gained = false, conf = 'inferred', after = 's9', why = 'Annals of Truth handed over'},
         }},
    },
}
