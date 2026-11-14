-- Step progress for Lizard Skins (San d'Oria quest 15). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Lizard_Skins.lua (Hanaa Punaa 559/562 offer the quest and only the accept
-- answer begins it, a refusal plays the same event; 560 is her reminder while accepted; the trade of 3 Lizard Skins is event
-- 561, which runs quest:complete the first time); client event script S4 230_Hanaa_Punaa_010E6059.txt (559/562 accept branch
-- say #7939, 560 say #7941, 561 say #7942). Bullet 2 bundles the offer and the trade in one step, so the offer only marks it
-- reached and the trade finishes it. The quest is repeatable, but a repeat needs no new accept (the trade alone), so there is
-- no observation that opens a second run and no `repeatable` entry. The quest log is set at the accept.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
-- Shared-signal audit (2026-10-28): dropped item 12697 (Lizard Gloves are sold by guild shops); the completed bit and the 561 reach stay.
return {
    title = 'Lizard Skins',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain 3 lizard skins'}},
        {id = 's2', at = {n = 2, fp = 'speak with hanaa punaa to begin'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 561, why = 'Hanaa Punaa 561: the 3 Lizard Skins (the gloves may not fit)'},
                  {t = 'chat', re = "You've brought them%? Joy!", why = 'Hanaa Punaa 561 (say #7942)'},
                  {t = 'chat', re = "Excellent! I know you'll be pleased with the results", why = 'Hanaa Punaa 559/562, accepted (say #7939)'},
                  {t = 'event', zone = 230, event = 560, why = 'Hanaa Punaa 560: reminder, only while accepted'}}},
    },
}
