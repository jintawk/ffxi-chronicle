-- Step progress for Promotion: Private First Class (Aht Urhgan quest 90). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Private_First_Class.lua (Naja Salaheem 5000 offers and begins the
-- quest with no choice, but no bullet names that talk; 5001 is the plain talk while accepted; trading an Imp Wing plays 5002,
-- whose finish runs quest:complete, takes the PSC Wildcat badge and prints "has been promoted to Private First Class", line
-- 6272 of Aht_Urhgan_Whitegate/IDs.lua). Bullet 2 is the alternative of buying the PFC Wildcat badge from the Curio Vendor
-- Moogle instead (a branch: the badge is also this quest's reward and the purchase may use up the previous badge, so neither
-- the badge nor the loss of the PSC badge is a proof of anything). Bullet 1 is the prerequisites. Not repeatable in practice
-- (a promotion happens once).
return {
    title = 'Promotion: Private First Class',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'players must be in possession of'}},
        {id = 's2', kind = 'branch', at = {n = 2, fp = 'you can skip this quest by'}},
        {id = 's3', at = {n = 3, fp = 'trade an imp wing to naja'},
         done = {
            {t = 'event', zone = 50, event = 5002, why = 'Naja Salaheem 5002: the Imp Wing traded, completes the quest'},
            {t = 'chat', re = 'has been promoted to private first class', why = 'promotion message (IDs.lua 6272)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
