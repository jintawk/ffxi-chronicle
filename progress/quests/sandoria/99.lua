-- Step progress for Souls in Shadow (San d'Oria quest 99). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Souls_in_Shadow.lua (Novalmauge 0 offers it, option 1 gives the Scythe of
-- Trials and key item 343 and begins it; trading the finished scythe is event 1, an unfinished one the separate refusal event 2;
-- 4 is his reminder once key item 344 is held; the ??? in Den of Rancor pops Mokumokuren, then gives key item 345; Novalmauge 5
-- with 345 completes it). Client event scripts S4 167_Novalmauge_010A7107.txt (2 say #7407 and 3 say #7398 are the refusal and menu events;
-- 0, 1, 4 and 5 are not decoded and rest on the event id and zone). Key item 345 from res/key_items.lua. The key items are shared with
-- Methods Create Madness (98) and every other nation's weapon skill quest, and the engine reads an observation against every
-- mapping, so the Annals matchers carry after = 's2' (this quest's own accept) and key items 343 and 344 are not used. The
-- trade-back bullet (n=6) is indented, so it is never a step (it leads, with the other indented and travel bullets 3 and
-- 9-12, into the Annals bullet n=13); the only unique trade signal, Novalmauge 1, therefore proves nothing a step can hold.
-- The quest log is set at s2, so it is not silent.
-- Shared-signal audit: key item 345 (and its chat line) shared with Methods Create Madness, Old Wounds and the other nations' weapon skill quests, gated after s2; ki_have 345 dropped (a login snapshot arrives before the gate opens).
return {
    title = 'Souls in Shadow',
    completes = 's14',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with novalmauge will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Novalmauge 0, option 1)'},
         },
         reach = {{t = 'event', zone = 167, event = 0, why = 'Novalmauge 0 offered (its finish needs option 1)'}}},
        {id = 's3', kind = 'note', with = 's13', at = {n = 3, fp = 'breaking the latent'}},
        {id = 's9', kind = 'note', with = 's13', at = {n = 9, fp = 'take silent oil and prism powder'}},
        {id = 's10', kind = 'note', with = 's13', at = {n = 10, fp = 'once inside the temple head to'}},
        {id = 's11', kind = 'note', with = 's13', at = {n = 11, fp = 'this time when you enter the'}},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'inside the den head south and'}},
        {id = 's13', at = {n = 13, fp = 'this fight is against mokumokuren a'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's2', why = 'Annals of Truth obtained (after this quest\'s accept)'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's14', at = {n = 14, fp = 'go back and speak with novalmauge'},
         done = {
            {t = 'event', zone = 167, event = 5, why = 'Novalmauge 5: completes (no item reward to fail on)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
