-- Step progress for Darkness Descends (Wings of the Goddess mission id 36). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/37_Darkness_Descends.lua. Throne Room [S] (156) zone-in cutscene 8 plays at Status 0
-- (sets Status 1); after the battlefield is won the player returns to the Throne Room at Status 2 and zone-in cutscene 10 plays; its
-- finish completes the mission, so it proves bullet 2 (the fight). The battlefield entry/win event 32001 is gated by an unfinished
-- local-variable TODO in LandSandBoat and is never proof. No client script exists for these ids.
return {
    title = 'Darkness Descends',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 36}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'continue through castle zvahl baileys s'},
         done = {
            {t = 'zonein', zone = 156, event = 8, why = 'Throne Room [S] zone-in cutscene 8 (Status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'click on the throne room door'},
         done = {
            {t = 'mission', line = 'wotg', eq = 36, completed = true, why = 'mission log: Darkness Descends completed'},
            {t = 'zonein', zone = 156, event = 10, why = 'Throne Room [S] zone-in cutscene 10 after the fight (Status 2): completes the mission'},
         }},
    },
}
