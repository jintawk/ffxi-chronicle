-- Step progress for Better the Demon You Know (other quest 105). Data only: which observation proves which step bullet of
-- pages/quests/other/105.lua. Bullet 1 (bring a Demon Pen) is preparation and carries no step.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Better_The_Demon_You_Know.lua. Koblakiq (Oldton Movalpolos 11): 20 offers
-- and begins (no refuse branch); 21 reminder at Prog 0; 22 plays only for a Demon Pen trade; 23 is the wait-longer reminder
-- (not a step: Prog 1 before the minute is up); 24 plays at Prog 1 once the minute has passed; 25 reminder at Prog 2; 26
-- plays at Prog 3 and completes (takes Zeelozok's earplug). Zeelozok's earplug (key item 634) comes from the ??? in Castle
-- Zvahl Baileys once Marquis Andrealphus is dead. Client event script S4 011_Koblakiq_0100B0EC.txt (21: say #7890;
-- 24: say #7904; 25: say #7908).
return {
    title = 'Better the Demon You Know',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'speak to koblakiq to begin this'},
         done = {
            {t = 'event', zone = 11, event = 20, why = 'Koblakiq 20 (offer, begins the quest)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 11, event = 21, conf = 'inferred', why = 'Koblakiq 21 (reminder, only while the quest is accepted)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to castle zvahl baileys and'}},
        {id = 's4', at = {n = 4, fp = 'trade the demon pen to koblakiq'},
         done = {
            {t = 'event', zone = 11, event = 22, why = 'Koblakiq 22 (Demon Pen trade)'},
         }},
        {id = 's5', at = {n = 5, fp = 'wait 1 earth minute then speak'},
         done = {
            {t = 'event', zone = 11, event = 24, why = 'Koblakiq 24 (after the wait)'},
            {t = 'chat', re = "They've found out about Zeelozok's visits to the other beastmen!", why = 'Koblakiq 24 (say #7904)'},
            {t = 'event', zone = 11, event = 25, conf = 'inferred', why = 'Koblakiq 25 (reminder, only after 24)'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'return to castle zvahl baileys and'}},
        {id = 's7', at = {n = 7, fp = 'examine the again after marquis andrealphus'},
         done = {
            {t = 'ki', id = 634, gained = true, why = "Zeelozok's earplug obtained"},
            {t = 'ki_have', id = 634, have = true, why = "Zeelozok's earplug held"},
            {t = 'chat', re = "obtained key item: zeelozok's earplug", why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to koblakiq to complete this'},
         done = {
            {t = 'event', zone = 11, event = 26, why = 'Koblakiq 26 (completes)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 634, gained = false, conf = 'inferred', why = "Zeelozok's earplug handed over"},
         }},
    },
}
