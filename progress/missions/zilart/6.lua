-- Step progress for Kazham's Chieftainess (Rise of the Zilart mission 3, mission id 6). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/rotz/03_Kazhams_Chieftainess.lua; client event script S4 250_Jakoh_Wahcondalo_010FA008.txt
-- (event 114: say #9979 "Well, don't say I didn't warn you." and #9980 "Here, take this key. It opens the door ..."); key item 238
-- (Sacrificial Chamber key) from res/key_items.lua. Jakoh Wahcondalo 114 plays only while this mission is current, has no menu to
-- refuse, hands over the key and completes the mission (onEventFinish -> mission:complete). The key item is the reward and the mission
-- log only carries the completed id, so both are supporting. Gilgamesh 7 in Norg is a reminder that proves nothing. `known` is the
-- previous mission (id 4) or anything after it completed. The draft's mission and event proofs are kept; its say #9979 line is
-- replaced by #9980, which only the key hand-over speaks.
return {
    title = "Kazham's Chieftainess",
    completes = 's1',
    known = {{t = 'mission', line = 'zilart', min = 4, completed = true}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to kazham j 9 and'},
         done = {
            {t = 'event', zone = 250, event = 114, why = 'Jakoh Wahcondalo 114: the key handed over, completes the mission'},
            {t = 'chat', re = 'Here, take this key%. It opens the door that leads to the deeper', why = 'Jakoh Wahcondalo 114 (say #9980)'},
            {t = 'mission', line = 'zilart', eq = 6, completed = true, why = "mission log: Kazham's Chieftainess completed"},
            {t = 'ki', id = 238, gained = true, conf = 'inferred', why = 'Sacrificial Chamber key obtained (the reward)'},
            {t = 'ki_have', id = 238, have = true, conf = 'inferred', why = 'Sacrificial Chamber key held'},
         }},
    },
}
