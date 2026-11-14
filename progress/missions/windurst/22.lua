-- Step progress for Doll of the Dead (Windurst mission id 22). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/9_1_Doll_of_the_Dead.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 22) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 22), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1 Apururu 619. s2 Heavens Tower zone-in 335 (status 1). s3 the Door, event 362. s4 Apururu 620. s5 the humus trade to the
-- Mandragora Warden in The Boyahda Tree, event 13 (valid trade only; gives the Letter from Zonpa-Zippa). s6 Apururu 621 (takes the
-- letter). s7 Full Moon Fountain zone-in 61 completes.
return {
    title = 'Doll of the Dead',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to apururu in windurst woods'},
         done = {
            {t = 'event', zone = 241, event = 619, why = 'Apururu 619'},
         }},
        {id = 's2', at = {n = 2, fp = 'zone into heavens tower for a'},
         done = {
            {t = 'zonein', zone = 242, event = 335, why = 'Heavens Tower zone-in 335'},
         }},
        {id = 's3', at = {n = 3, fp = 'click the door vestal chamber on'},
         done = {
            {t = 'event', zone = 242, event = 362, why = 'Door: Vestal Chamber 362'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to apururu for a cutscene'},
         done = {
            {t = 'event', zone = 241, event = 620, why = 'Apururu 620'},
         }},
        {id = 's5', at = {n = 5, fp = 'trade goobbue humus to the single'},
         done = {
            {t = 'event', zone = 153, event = 13, why = 'Mandragora Warden 13: the humus accepted'},
            {t = 'ki', id = 475, gained = true, why = 'Letter from Zonpa-Zippa obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to apururu for a cutscene'},
         done = {
            {t = 'event', zone = 241, event = 621, why = 'Apururu 621'},
            {t = 'ki', id = 475, gained = false, why = 'Letter from Zonpa-Zippa taken'},
         }},
        {id = 's7', at = {n = 7, fp = 'zone into full moon fountain for'},
         done = {
            {t = 'mission', line = 'windurst', eq = 22, completed = true, why = 'mission log: Doll of the Dead completed'},
            {t = 'zonein', zone = 170, event = 61, why = 'Full Moon Fountain zone-in 61: completes'},
         }},
    },
}
