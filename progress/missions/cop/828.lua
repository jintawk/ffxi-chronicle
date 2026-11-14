-- Step progress for When Angels Fall (Chains of Promathia 8-3, mission id 828). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/8_3_When_Angels_Fall.lua (no client script for any Garden of Ru'Hmet object, so every
-- event is LandSandBoat only); key items 590 to 594 (the five lights) from res/key_items.lua. Bullet 1 is the Garden zone-in
-- cutscene 201 (status 0; the Mysterious Amulet, whose key item id is ambiguous in res/key_items.lua, is not used). Bullet 3 is the
-- Ebon Panel pair: 202 on the first check (status 1, any panel) and 120 to 124 on the second (status 2, your race's panel; the
-- finish only gives the key item on option 1, so the events only mark the step as under way); a light key item gained after bullet
-- 1 proves it, which keeps the Light of Al'Taieu that Warrior's Path hands out at its end (748) from counting. The brands on the
-- third floor (events 110 / 111, Brand of Dawn / Twilight, key items 710 / 711) can be fetched before the panels and one alone does
-- not finish bullet 7, so they prove nothing here; bullets 2 and 4 to 9 are notes on the next provable bullet. The Particle Gate
-- (_0z0, event 203, status 3) is bullet 10, the Luminous Convergence (_0zt, 204, status 5) bullet 14, and the Al'Taieu zone-in
-- cutscene 165 (status 6) completes the mission (bullet 15). Entering the battlefield (11 to 13) leaves no event of its own (32001
-- is a battlefield exit, never proof); the Gate of the Gods exit (_0zs, 112) plays on a refusal too. The draft put every bullet
-- after the second on a note and used the hold-snapshot matchers; fixed.
return {
    title = 'When Angels Fall',
    completes = 's15',
    known = {{t = 'mission', line = 'cop', eq = 828}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'first check the gate of the'},
         done = {
            {t = 'zonein', zone = 35, event = 201, why = "The Garden of Ru'Hmet zone-in cutscene 201 (status 0, LandSandBoat)"},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you need to climb to the'}},
        {id = 's3', at = {n = 3, fp = 'note once you re on the'},
         done = {
            {t = 'ki', id = 590, gained = true, after = 's1', why = 'light of Holla obtained at the Ebon Panel'},
            {t = 'ki', id = 591, gained = true, after = 's1', why = 'light of Dem obtained at the Ebon Panel'},
            {t = 'ki', id = 592, gained = true, after = 's1', why = 'light of Mea obtained at the Ebon Panel'},
            {t = 'ki', id = 593, gained = true, after = 's1', why = 'light of Vahzl obtained at the Ebon Panel'},
            {t = 'ki', id = 594, gained = true, after = 's1', why = "light of Al'Taieu obtained at the Ebon Panel"},
            {t = 'chat', re = 'obtained key item: light of', after = 's1', why = 'chat: a light obtained'},
         },
         reach = {
            {t = 'event', zone = 35, event = 202, why = 'Ebon Panel 202: the first check (status 1)'},
            {t = 'event', zone = 35, event = 120, why = 'Ebon Panel 120: the second check (Hume, status 2)'},
            {t = 'event', zone = 35, event = 121, why = 'Ebon Panel 121: the second check (Elvaan, status 2)'},
            {t = 'event', zone = 35, event = 122, why = 'Ebon Panel 122: the second check (Galka, status 2)'},
            {t = 'event', zone = 35, event = 123, why = 'Ebon Panel 123: the second check (Tarutaru, status 2)'},
            {t = 'event', zone = 35, event = 124, why = 'Ebon Panel 124: the second check (Mithra, status 2)'},
         }},
        {id = 's4', kind = 'note', with = 's10', at = {n = 4, fp = 'go to the central area of'}},
        {id = 's5', kind = 'note', with = 's10', at = {n = 5, fp = 'there are four spinning qn zdei'}},
        {id = 's6', kind = 'note', with = 's10', at = {n = 6, fp = 'once in the elevator room step'}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'you must navigate this floor to'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'if you want to save time'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'head back to the central elevator'}},
        {id = 's10', at = {n = 10, fp = 'check the particle gate on the'},
         done = {
            {t = 'event', zone = 35, event = 203, why = 'Particle Gate 203 (status 3, LandSandBoat)'},
         }},
        {id = 's11', kind = 'note', with = 's14', at = {n = 11, fp = 'check it again to enter the'}},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'you begin the bc at the'}},
        {id = 's13', kind = 'note', with = 's14', at = {n = 13, fp = 'the bc is against four ix'}},
        {id = 's14', at = {n = 14, fp = 'walk across the empty room and'},
         done = {
            {t = 'event', zone = 35, event = 204, why = 'Luminous Convergence 204 (status 5, after the battle, LandSandBoat)'},
         }},
        {id = 's15', at = {n = 15, fp = 'after the fight and the following'},
         done = {
            {t = 'mission', line = 'cop', eq = 828, completed = true, why = 'mission log: When Angels Fall completed'},
            {t = 'zonein', zone = 33, event = 165, why = "Al'Taieu zone-in cutscene 165 (status 6): completes"},
         }},
    },
}
