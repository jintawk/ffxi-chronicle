-- Step progress for Too Many Chefs (Bastok quest 86). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Metalworks/npcs/Ferghus.lua (946 begins the quest only on option 0; 947 plays after the
-- Leonhardt trade and sends you to Umberto), Leonhardt.lua (948 only after Ferghus, 950 only after the Red Oven Mitt trade),
-- Bastok_Markets_[S]/npcs/Raginmund.lua (112 only after Leonhardt) and Bastok_Markets/npcs/Umberto.lua (473 plays and then the
-- reward fails when no slot is free, so it is a reach and the completed bit carries the last bullet). Ferghus 947 is a visit
-- the page does not list; it is only a reach on the Umberto bullet (the draft used it as proof of the first bullet, but it comes
-- after the mitt trade). The mitt farming bullet is a note on the trade.
return {
    title = 'Too Many Chefs',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ferghus for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ferghus 946, option 0)'},
         },
         reach = {{t = 'event', zone = 237, event = 946, why = 'Ferghus 946 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to leonhardt for another cutscene'},
         done = {
            {t = 'event', zone = 237, event = 948, why = 'Leonhardt 948: part 2, plays only after Ferghus'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to bastok markets s and'},
         done = {
            {t = 'event', zone = 87, event = 112, why = 'Raginmund 112: part 3, plays only after Leonhardt'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'obtain a red oven mitt from'}},
        {id = 's5', at = {n = 5, fp = 'trade the red oven mitt to'},
         done = {
            {t = 'event', zone = 237, event = 950, why = 'Leonhardt 950: the mitt accepted'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to umberto in bastok markets'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 5674, gained = true, conf = 'inferred', why = "Aileen's Delight gained (reward) (items can come from elsewhere)"},
         },
         reach = {
            {t = 'event', zone = 237, event = 947, why = 'Ferghus 947: sends you to Umberto, only after the mitt trade'},
            {t = 'event', zone = 235, event = 473, why = 'Umberto 473: also plays when no slot is free for the reward'},
         }},
    },
}
