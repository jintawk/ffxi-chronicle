-- Step progress for Methods Create Madness (San d'Oria quest 98). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Methods_Create_Madness.lua (Balasiel 8 offers it, option 1 gives the Spear of
-- Trials and key item 343 and begins it; trading the finished spear is event 9, an unfinished one is the separate refusal event
-- 10; 12 is his reminder once key item 344 is held; the ??? in Sea Serpent Grotto pops Water Leaper, then gives key item 345;
-- Balasiel 13 with 345 completes it). Client event scripts S4 230_Balasiel_010E603F.txt (12 say #9347, 10 say #9341);
-- 8, 9 and 13 are not decoded and rest on the event id and zone. Key item ids from res/key_items.lua (343 weapon training
-- guide, 344 map to the Annals of Truth, 345 Annals of Truth). The three key items are shared with Souls in Shadow (99) and
-- every other nation's weapon skill quest, and the engine reads an observation against every mapping, so a key item here could
-- tick the wrong quest: the Annals matchers carry after = 's6' (this quest's own trade event) and key items 343 and 344 are
-- not used at all. Bullets 1 and 3 are a warning and a heading, 4-5 are indented (never steps), 7-8 are travel into the
-- Annals bullet (n=9). The quest log is set at s2, so it is not silent.
-- Shared-signal audit: key item 345 (and its chat line) shared with Old Wounds, Souls in Shadow and the other nations' weapon skill quests, gated after s6; ki_have 345 dropped (a login snapshot arrives before the gate opens).
return {
    title = 'Methods Create Madness',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with balasiel at f 7'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Balasiel 8, option 1)'},
         },
         reach = {{t = 'event', zone = 230, event = 8, why = 'Balasiel 8 offered (its finish needs option 1)'}}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'breaking the latent'}},
        {id = 's6', at = {n = 6, fp = 'trade the spear of trials back'},
         done = {
            {t = 'event', zone = 230, event = 9, why = 'Balasiel 9: the finished spear accepted (an unfinished one is event 10)'},
            {t = 'event', zone = 230, event = 12, conf = 'inferred', why = 'Balasiel 12: reminder, only once the map is held'},
            {t = 'chat', re = 'travel to the Sea Serpent Grotto%.', conf = 'inferred', why = 'Balasiel 12 (say #9347)'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'take silent oil with you and'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'after entering the grotto head south'}},
        {id = 's9', at = {n = 9, fp = 'this fight is against water leaper'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained (after this quest\'s trade)'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's10', at = {n = 10, fp = 'go back and speak with balasiel'},
         done = {
            {t = 'event', zone = 230, event = 13, why = 'Balasiel 13: completes (no item reward to fail on)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
