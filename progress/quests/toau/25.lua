-- Step progress for Navigating the Unfriendly Seas (Aht Urhgan quest 25). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/COR_AF2_Navigating_the_Unfriendly_Seas.lua (the ??? in Arrapago Reef plays 232 while
-- available, no option, and begins the quest; fishing up the Hydrogauge has no event (an item can come from elsewhere), so bullet 3
-- is a note on the trade; Leleroon 283 plays only for a Hydrogauge trade at Prog 0 and sets Prog 1, his 292 is the reminder at Prog
-- 1 and 2; trading exactly the Hydrogauge to the Leypoint in Wajaom Woodlands at Prog 1 prints PLACE_HYDROGAUGE and sets Prog 2 with
-- a one minute wait (before the wait it prints ENIGMATIC_LIGHT instead); the Leypoint 508 plays at Prog 2 after the wait and sets
-- Prog 3; the ??? 233 at Prog 3 runs quest:complete, whose reward is Corsair's Culottes, so a full bag replays 233 and only the
-- completed bit proves the last bullet). Text from zones/Wajaom_Woodlands/IDs.lua (PLACE_HYDROGAUGE 7363, "You set the <item> in
-- the glowing trench."). Not repeatable. Events 283 (Nashmau), 508 (Wajaom) and 232 and 233 (Arrapago) are used by no other script.
return {
    title = 'Navigating the Unfriendly Seas',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the in arrapago reef at'},
         done = {
            {t = 'event', zone = 54, event = 232, why = 'the ??? 232: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you no longer have to be'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'you are asked to fish up'}},
        {id = 's4', at = {n = 4, fp = 'once you ve fished up a'},
         done = {
            {t = 'event', zone = 53, event = 283, why = 'Leleroon 283: a Hydrogauge trade accepted, only at Prog 0'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to g 8 in wajaom'},
         done = {
            {t = 'chat', re = 'in the glowing trench%.', why = 'Wajaom Woodlands PLACE_HYDROGAUGE: the Hydrogauge accepted by the Leypoint'},
         },
         reach = {{t = 'event', zone = 53, event = 292, why = 'Leleroon 292: his talk at Prog 1 and 2, after the trade'}}},
        {id = 's6', at = {n = 6, fp = 'wait one minute then examine the'},
         done = {
            {t = 'event', zone = 51, event = 508, why = 'Leypoint 508: plays only at Prog 2 after the wait, sets Prog 3'},
         },
         reach = {{t = 'chat', re = 'is giving off an enigmatic light%.', why = 'Wajaom Woodlands ENIGMATIC_LIGHT: the wait is not over'}}},
        {id = 's7', at = {n = 7, fp = 'return to the in arrapago reef'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 54, event = 233, why = "the ??? 233: plays only at Prog 3, runs quest:complete (replays if Corsair's Culottes cannot be given)"}}},
    },
}
