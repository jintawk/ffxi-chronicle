-- Step progress for The Seamstress (San d'Oria quest 5). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Seamstress.lua (Hanaa Punaa 528/531 offer the quest and only the
-- accept answer begins it, a refusal plays the same event; 529 is her reminder while accepted; the trade of 3 Sheepskins is
-- event 530, which runs quest:complete the first time); client event script S4 230_Hanaa_Punaa_010E6059.txt (528/531 accept
-- branch say #7862, 530 say #7864). Bullet 2 bundles the offer and the trade in one step, so the offer only marks it reached
-- and the trade finishes it. The quest is repeatable, but a repeat needs no new accept (the trade alone), so there is no
-- observation that opens a second run and no `repeatable` entry. The quest log is set at the accept.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
-- Shared-signal audit (2026-10-28): dropped item 12696 (Leather Gloves are sold by NPC shops and gained from other sources); the completed bit and the 530 reach stay.
return {
    title = 'The Seamstress',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain 3 sheepskins cletae in the'}},
        {id = 's2', at = {n = 2, fp = 'speak with hanaa punaa on the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 530, why = 'Hanaa Punaa 530: the 3 Sheepskins (the gloves may not fit)'},
                  {t = 'chat', re = "What fine skins you've brrrought me!", why = 'Hanaa Punaa 530 (say #7864)'},
                  {t = 'chat', re = "Perrrfect! I'll be waiting for those three", why = 'Hanaa Punaa 528/531, accepted (say #7862)'},
                  {t = 'event', zone = 230, event = 529, why = 'Hanaa Punaa 529: reminder, only while accepted'}}},
    },
}
