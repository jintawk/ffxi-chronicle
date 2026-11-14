-- Step progress for A Token of Troth (Wings of the Goddess, mission id 52). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/53_Token_of_Troth.lua: the Bulwark Gate (Sauromugue Champaign [S] 98) plays 117 with a
-- weapon equipped (a refusal, not used), 115 at status 0 with none (sets status 1) and 116 at status 1, whose finish runs
-- mission:complete and takes the Wedding invitation.
return {
    title = 'A Token of Troth',
    completes = 's2',
    known = {{t = 'mission', line = 'wotg', eq = 52}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'unequip your weapon and examine the'},
         done = {
            {t = 'event', zone = 98, event = 115, why = 'Bulwark Gate 115: the first cutscene (status 0, no weapon)'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the bulwark gate again for'},
         done = {
            {t = 'event', zone = 98, event = 116, why = 'Bulwark Gate 116: the second cutscene, completes the mission'},
            {t = 'mission', line = 'wotg', eq = 52, completed = true, why = 'mission log: A Token of Troth completed'},
         }},
    },
}
