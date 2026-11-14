-- Step progress for Moogles in the Wild (other quest 102). Data only: which observation proves which step bullet of
-- pages/quests/other/102.lua.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Moogles_in_the_Wild.lua. The quest lives in the Mog House of the
-- player's home nation, so its events (30013 offer, 30014 reminder, 30015 trade, 30016 reward) play in whichever of the ten
-- home-nation city zones the Mog House stands in (Southern/Northern/Port San d'Oria 230-232, Bastok Mines/Markets/Port
-- 234-236, Windurst Waters/Walls/Port/Woods 238-241; xi.moghouse.inMogHouseInHomeNation), hence one matcher per zone.
-- 30013 plays on accept and refuse (quest:begin only on option 1), so the accept rests on the quest log's current bit.
-- 30015 plays only for a matching trade (tradeMatches Raptor Mantle + Wool Hat) while the quest is accepted; 30016 is the
-- completing event (quest:complete, Mog Safe +10). There is no client event script for these Mog House events, so no
-- dialogue line is used.
return {
    title = 'Moogles in the Wild',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'place a noble s bed in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (event 30013 option 1)'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'zone out of your mog house'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'wait one earth minute speak to'}},
        {id = 's4', at = {n = 4, fp = 'trade your moogle a raptor mantle'},
         done = {
            {t = 'event', zone = 230, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 231, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 232, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 234, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 235, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 236, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 238, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 239, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 240, event = 30015, why = 'Moogle 30015 (trade accepted)'},
            {t = 'event', zone = 241, event = 30015, why = 'Moogle 30015 (trade accepted)'},
         }},
        {id = 's5', at = {n = 5, fp = 'when your moogle returns from his'},
         done = {
            {t = 'event', zone = 230, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 231, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 232, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 234, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 235, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 236, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 238, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 239, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 240, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'event', zone = 241, event = 30016, why = 'Moogle 30016 (reward, completes)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
