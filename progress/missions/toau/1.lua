-- Step progress for Immortal Sentries (Treasures of Aht Urhgan mission 2, mission id 1). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/toau/02_Immortal_Sentries.lua. The Immortal at a staging point (Meyaada 5 in Arrapago Reef 54,
-- Daswil 5 in Bhaflau Thickets 52, Nahshib and Nareema 5 in Caedarva Mire 79, Waudeen 4 in Mount Zhayolm 61) plays that event whenever the
-- Supplies package is held, and only option 1 hands it over, so the event is `reach`; the package leaving the key items (775, handed over
-- at once with "You hand over the % to the Immortal.") proves the delivery. The package is a reward key item of the previous mission and
-- is held when this one starts, so it is never a gain here. The Amber stratum abyssite the draft offered belongs to a Voidwatch travel
-- tip. The Runic Portal back to Whitegate plays on any use, so bullet 5 is a note. Naja Salaheem 3002 (Whitegate, played only without
-- the package) completes the mission and prints the two membership lines. The three Notes bullets stay plain.
return {
    title = 'Immortal Sentries',
    completes = 's6',
    known = {{t = 'mission', line = 'toau', eq = 1}},
    steps = {
        {id = 's4', at = {n = 4, fp = 'take the supplies package to any'},
         done = {
            {t = 'ki', id = 775, gained = false, why = 'Supplies package handed over to the Immortal'},
            {t = 'chat', re = 'You hand over the .- to the Immortal%.', why = 'staging point text HAND_OVER_TO_IMMORTAL (option 1 only)'},
         },
         reach = {
            {t = 'event', zone = 54, event = 5, why = 'Meyaada 5: hand-over offered (also plays on a refusal)'},
            {t = 'event', zone = 52, event = 5, why = 'Daswil 5: hand-over offered (also plays on a refusal)'},
            {t = 'event', zone = 79, event = 5, why = 'Nahshib and Nareema 5: hand-over offered (also plays on a refusal)'},
            {t = 'event', zone = 61, event = 4, why = 'Waudeen 4: hand-over offered (also plays on a refusal)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'after you ve delivered the supplies'}},
        {id = 's6', at = {n = 6, fp = 'speak to naja salaheem'},
         done = {
            {t = 'event', zone = 50, event = 3002, why = 'Naja Salaheem 3002: the mission completes'},
            {t = 'mission', line = 'toau', eq = 1, completed = true, why = 'mission log: Immortal Sentries completed'},
            {t = 'chat', re = "You are now a member of Salaheem's Sentinels%.", why = 'Naja Salaheem text 9271 (MEMBER_OF_SALAHEEMS_SENTINELS)'},
            {t = 'chat', re = 'You now have access to a Mog Locker%.', why = 'Naja Salaheem text 9272 (ACCESS_TO_A_MOG_LOCKER)'},
         }},
    },
}
