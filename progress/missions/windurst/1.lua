-- Step progress for The Heart of the Matter (Windurst mission 1-2, mission id 1). Data only; see progress/missions/sandoria/0.lua
-- for the mission format. Evidence: LandSandBoat scripts/missions/windurst/1_2_The_Heart_of_the_Matter.lua and the client event
-- scripts (S4 pseudo) 238_Mokyokyo, 240_Janshura_Rashura, 241_Rakoh_Buuma, 241_Apururu; key item ids from res/key_items.lua.
-- The nation line holds 65535 with no mission, the mission id (1) while it is current, and 65535 again once id 1 is in the completed
-- set. Accepting is event 78/93/111/114 option 1 at a gate guard (menu, then "Accept this mission?" Yes/No, no line of its own), so
-- the offer proves nothing; what proves the accept is the nation line moving to 1, plus the briefing a gate guard plays only while
-- the mission is current (Janshura-Rashura 105 say #3399, Zokima-Rokima 107, Mokyokyo 131 say #7579, Rakoh Buuma 136 say #7738).
-- Step 2 is Apururu 137 (progressEvent, a cutscene with no text; it hands over the six dark Mana Orbs); the bullet that lists them
-- (n = 3) is its result, a note. Apururu 138 is her reminder at the next status, so it also proves step 2. Apururu 144 is the
-- post-mission dialogue and is not used. Pore-Ohre 46 (zone 116) gives the Southeastern star charm. The Outer Horutoto Ruins (194)
-- events are LandSandBoat's: 58..63 place a dark orb (the orb key item is taken), 44 at the east Gate: Magical Gizmo takes the star
-- charm, 46..51 collect a glowing orb. Completing: Apururu 145 (orbs kept, status 5, say_as #7779) or 143 (orbs lost to the Cardians,
-- status 6), both call mission:complete. Event 48 (East Sarutabaruta zone-in) only plays if you do not warp out another way, so
-- the n = 9 bullet is a note. The mission is not repeatable in LandSandBoat; no restart is mapped.
return {
    title = 'The Heart of the Matter',
    completes = 's10',
    known = {{t = 'mission', line = 'windurst', eq = 1}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'accept the mission from any gate'},
         done = {
            {t = 'mission', line = 'windurst', eq = 1, completed = false, why = 'mission line: current mission = The Heart of the Matter'},
            {t = 'event', zone = 240, event = 105, why = 'Janshura-Rashura 105, briefing while the mission is current'},
            {t = 'chat', re = 'Go ask the staff at the Cardian workshop in the Manustery for the details of your mission%.', why = 'Janshura-Rashura 105 (say #3399)'},
            {t = 'event', zone = 239, event = 107, why = 'Zokima-Rokima 107, briefing while the mission is current'},
            {t = 'event', zone = 238, event = 131, why = 'Mokyokyo 131, briefing while the mission is current'},
            {t = 'chat', re = "The Manustery's Cardian workshop is southeast of here, in Windurst Woods%.", why = 'Mokyokyo 131 (say #7579)'},
            {t = 'event', zone = 241, event = 136, why = 'Rakoh Buuma 136, briefing while the mission is current'},
            {t = 'chat', re = "I'm sure the Minister of the Manustery will fill you in on the details of your mission%.", why = 'Rakoh Buuma 136 (say #7738)'},
         }},
        {id = 's2', at = {n = 2, fp = 'then make your way to the'},
         done = {
            {t = 'event', zone = 241, event = 137, why = 'Apururu 137: the six dark Mana Orbs handed over'},
            {t = 'ki', id = 37, gained = true, why = 'first dark Mana Orb obtained (given with event 137)'},
            {t = 'event', zone = 241, event = 138, why = 'Apururu 138, her reminder after the orbs were handed over'},
            {t = 'chat', re = 'Ask Pore%-Ohre in the southeastern magic tower of the Horutoto Ruins to find out how to energize Mana Orbs properly%.', why = 'Apururu 138 (say #7758)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you will receive the following mana'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'you are now instructed to go'}},
        {id = 's5', at = {n = 5, fp = 'head to j 11 in east'},
         done = {
            {t = 'event', zone = 116, event = 46, why = 'Pore-Ohre 46: the Southeastern star charm handed over'},
            {t = 'ki', id = 112, gained = true, why = 'Southeastern star charm obtained (given with event 46)'},
         }},
        {id = 's6', at = {n = 6, fp = 'enter the tower then check the'},
         done = {
            {t = 'event', zone = 194, event = 58, why = 'Outer Horutoto Ruins 58, dark orb placed in the first Gate: Magical Gizmo'},
            {t = 'event', zone = 194, event = 59, why = 'Outer Horutoto Ruins 59, dark orb placed in the second Gate: Magical Gizmo'},
            {t = 'event', zone = 194, event = 60, why = 'Outer Horutoto Ruins 60, dark orb placed in the third Gate: Magical Gizmo'},
            {t = 'event', zone = 194, event = 61, why = 'Outer Horutoto Ruins 61, dark orb placed in the fourth Gate: Magical Gizmo'},
            {t = 'event', zone = 194, event = 62, why = 'Outer Horutoto Ruins 62, dark orb placed in the fifth Gate: Magical Gizmo'},
            {t = 'event', zone = 194, event = 63, why = 'Outer Horutoto Ruins 63, dark orb placed in the sixth Gate: Magical Gizmo'},
            {t = 'ki', id = 37, gained = false, why = 'first dark Mana Orb placed (taken on the first pedestal)'},
         }},
        {id = 's7', at = {n = 7, fp = 'after all orbs have been set'},
         done = {
            {t = 'event', zone = 194, event = 44, why = 'Outer Horutoto Ruins 44, the east Gate: Magical Gizmo cutscene (takes the Southeastern star charm)'},
            {t = 'ki', id = 112, gained = false, why = 'Southeastern star charm taken at the east Gate: Magical Gizmo'},
         }},
        {id = 's8', at = {n = 8, fp = 'after the cutscene check each pedestal'},
         done = {
            {t = 'event', zone = 194, event = 46, why = 'Outer Horutoto Ruins 46, glowing orb collected from the first pedestal'},
            {t = 'event', zone = 194, event = 47, why = 'Outer Horutoto Ruins 47, glowing orb collected from the second pedestal'},
            {t = 'event', zone = 194, event = 48, why = 'Outer Horutoto Ruins 48, glowing orb collected from the third pedestal'},
            {t = 'event', zone = 194, event = 49, why = 'Outer Horutoto Ruins 49, glowing orb collected from the fourth pedestal'},
            {t = 'event', zone = 194, event = 50, why = 'Outer Horutoto Ruins 50, glowing orb collected from the fifth pedestal'},
            {t = 'event', zone = 194, event = 51, why = 'Outer Horutoto Ruins 51, glowing orb collected from the sixth pedestal'},
            {t = 'ki', id = 59, gained = true, why = 'first glowing Mana Orb obtained'},
         }},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'when you ve collected all 6'}},
        {id = 's10', at = {n = 10, fp = 'head back to the manustery and'},
         done = {
            {t = 'mission', line = 'windurst', eq = 1, completed = true, why = 'mission log: The Heart of the Matter completed'},
            {t = 'event', zone = 241, event = 145, why = 'Apururu 145: orbs returned, mission completed'},
            {t = 'chat', re = 'Thank you very muchy%-wuchy!', why = 'Apururu 145 (say_as #7779)'},
            {t = 'event', zone = 241, event = 143, why = 'Apururu 143: mission completed after the Cardians took the orbs'},
         }},
    },
}
