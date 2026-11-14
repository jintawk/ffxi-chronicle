-- Step progress for Crying Over Onions (Windurst quest 76). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB5_Crying_Over_Onions.lua (Kohlo-Lakolo 496 begins the quest with no option
-- test; Honoi-Gomoi 774 sends you for the Star Spinel and 777 is his reminder; 775 is the accepted Star Spinel trade, but it
-- hands out the Star Necklace and confirms the trade only if the bag has room, so it is a reach; Kohlo-Lakolo 497 and Honoi-Gomoi
-- 778 play only at Prog 3, after the trade paid out, which proves bullet 5; Honoi-Gomoi 776 plays at Prog 4 and completes the
-- quest with only fame, so it has no refusal path). Bullet 6 bundles Kohlo-Lakolo's cutscene (497) and Honoi-Gomoi's last one
-- (776): 497 is its reach and 776 proves it. Client event scripts are not decoded for these NPCs, so the events rest on
-- LandSandBoat. The quest log is set at s2, so it is not silent.
return {
    title = 'Crying Over Onions',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you ll need to zone again'}},
        {id = 's2', at = {n = 2, fp = 'talk to kohlo lakolo for a'},
         done = {
            {t = 'event', zone = 240, event = 496, why = 'Kohlo-Lakolo 496: the quest begins'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to windurst waters south a'},
         done = {
            {t = 'event', zone = 238, event = 774, why = 'Honoi-Gomoi 774'},
            {t = 'event', zone = 238, event = 777, conf = 'inferred', why = 'Honoi-Gomoi 777: reminder before the trade, only after 774'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'get a star spinel from spelunking'}},
        {id = 's5', at = {n = 5, fp = 'bring the star spinel to honoi'},
         done = {
            {t = 'event', zone = 238, event = 778, conf = 'inferred', why = 'Honoi-Gomoi 778: reminder after the trade, only at Prog 3'},
            {t = 'event', zone = 240, event = 497, conf = 'inferred', why = 'Kohlo-Lakolo 497: plays only at Prog 3, after the trade paid out'},
         },
         reach = {{t = 'event', zone = 238, event = 775, why = 'Honoi-Gomoi 775 (the Star Necklace needs a free slot)'}}},
        {id = 's6', at = {n = 6, fp = 'talk to kohlo lakolo for a'},
         done = {
            {t = 'event', zone = 238, event = 776, why = 'Honoi-Gomoi 776: the last cutscene'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 240, event = 497, why = 'Kohlo-Lakolo 497'},
            {t = 'event', zone = 240, event = 512, why = 'Kohlo-Lakolo 512: reminder after 497'},
         }},
    },
}
