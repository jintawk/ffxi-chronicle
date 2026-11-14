-- Step progress for The Temple of Uggalepih (Rise of the Zilart mission 4, mission id 8). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/rotz/04_The_Temple_of_Uggalepih.lua; key items 238 (Sacrificial Chamber key) and 246 (Dark
-- fragment) from res/key_items.lua; zone 163 = Sacrificial Chamber (res/zones.lua). Winning the battlefield (exit event 32001, which
-- any win in that zone plays) sets status 1 and moves the player back into the chamber: the zone-in cutscene 7 plays only at status 1,
-- so it proves the win; its finish sets status 2 and the next zone-in plays 8, which completes the mission, takes the Sacrificial
-- Chamber key and hands out the Dark fragment. The zone-in events 7 and 8 have no client script (LandSandBoat's ids). Gilgamesh 8 and
-- Jakoh 115 are reminders that prove nothing. The draft hung the completion on bullet 3 (the "already completed" shortcut) and left
-- bullet 9 (the Rancor Flame trade: an item trade with no event or key item of its own) with no proof; both are dropped, and so are
-- the shortcut, route and puzzle bullets (1 to 13) which have no signal. `known` is the previous mission (id 6) or anything after it
-- completed.
return {
    title = 'The Temple of Uggalepih',
    completes = 's15',
    known = {{t = 'mission', line = 'zilart', min = 6, completed = true}},
    steps = {
        {id = 's14', at = {n = 14, fp = 'inside gather up and prepare you'},
         done = {
            {t = 'zonein', zone = 163, event = 7, why = 'Sacrificial Chamber zone-in 7: the battlefield won (status 1, LandSandBoat)'},
         }},
        {id = 's15', at = {n = 15, fp = 'once you ve cleared the bc'},
         done = {
            {t = 'mission', line = 'zilart', eq = 8, completed = true, why = 'mission log: The Temple of Uggalepih completed'},
            {t = 'zonein', zone = 163, event = 8, why = 'Sacrificial Chamber zone-in 8: completes (status 2, LandSandBoat)'},
            {t = 'ki', id = 238, gained = false, why = 'Sacrificial Chamber key taken at the completion'},
            {t = 'ki', id = 246, gained = true, conf = 'inferred', why = 'Dark fragment obtained (the reward)'},
         }},
        {id = 's16', kind = 'note', with = 's15', at = {n = 16, fp = 'after winning the bcnm you may'}},
    },
}
