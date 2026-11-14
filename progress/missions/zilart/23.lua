-- Step progress for The Mithra and the Crystal (Zilart mission 12, mission id 23). Data only; see progress/missions/sandoria/12.lua.
-- The zilart line carries completed ids only, so the mission matcher is a completion.
-- Evidence: LandSandBoat scripts/missions/rotz/12_The_Mithra_and_the_Crystal.lua; client scripts 247_Maryoh_Comyujah_010F7003.txt
-- (81, 82, 83, 84), 251_Shimmering_Circle_010FB007.txt (event 3 listed, empty body); key items 451 (scrap of papyrus) and 452
-- (cerulean crystal) from res/key_items.lua. Maryoh 81 is the offer (a menu, only its first option accepts) and plays again on a
-- decline, so it is only `reach`; what proves the accept is event 82 (status 1 without the scrap) and its line (say #10254), which the
-- briefing plays only after the accept. The scrap (KI 451) is gained at the ??? in Quicksand Caves (208, events 12/13, option 1 gives
-- it; both play on a decline too, so 13 is `reach`). Maryoh 83 hands in the scrap and gives the crystal (KI 452): event, line, KI
-- gained and KI 451 lost; event 84 and its line play only after 83 (status 2), so they are inferred. The Cermet Grate in the Hall
-- of the Gods (251, `_6z0`, event 4) plays only while the cerulean crystal is held (LandSandBoat only); the Shimmering Circle (251,
-- event 3) completes the mission. `known` is the previous mission (id 22) or anything after it completed. Dropped from the draft:
-- Maryoh 85 (the talk after completion), the second `ki_have` snapshot on the crystal, and its current-value `known` matcher.
return {
    title = 'The Mithra and the Crystal',
    completes = 's9',
    known = {{t = 'mission', line = 'zilart', min = 22, completed = true}},
    groups = {main = {start = {{t = 'mission', line = 'zilart', min = 22, completed = true}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to rabao home point 2'},
         done = {
            {t = 'event', zone = 247, event = 82, why = 'Maryoh Comyujah 82: the briefing, only after the deal is accepted'},
            {t = 'chat', re = "My hunter's instinct tells me that there's something unusual beyond that weight%-operated device in the caves%.", why = 'Maryoh Comyujah 82 (say #10254)'},
         },
         reach = {
            {t = 'event', zone = 247, event = 81, why = 'Maryoh Comyujah 81 offered (its finish needs the first option)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'she will ask you to go'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head for the secret entrance in'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'inside on map 5 go to'}},
        {id = 's5', at = {n = 5, fp = 'enter and fall down the hole'},
         done = {
            {t = 'ki', id = 451, gained = true, why = 'scrap of papyrus obtained'},
            {t = 'chat', re = 'obtained key item: scrap of papyrus', why = 'chat: key item obtained'},
            {t = 'ki_have', id = 451, have = true, why = 'scrap of papyrus held'},
         },
         reach = {
            {t = 'event', zone = 208, event = 13, why = '??? 13 offered after the Ancient Vessel (its finish needs option 1)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to rabao and speak to'},
         done = {
            {t = 'event', zone = 247, event = 83, why = 'Maryoh Comyujah 83: the scrap handed over, the crystal given'},
            {t = 'chat', re = 'Wow, this is incrrredible!', why = 'Maryoh Comyujah 83 (say #10255)'},
            {t = 'ki', id = 452, gained = true, why = 'cerulean crystal obtained'},
            {t = 'chat', re = 'obtained key item: cerulean crystal', why = 'chat: key item obtained'},
            {t = 'ki', id = 451, gained = false, why = 'scrap of papyrus handed over'},
            {t = 'event', zone = 247, event = 84, conf = 'inferred', why = 'Maryoh Comyujah 84: plays only after 83 (status 2)'},
            {t = 'chat', re = "Those rrruins in Li'Telor are interesting to visit on a night of the full moon%.", conf = 'inferred', why = 'Maryoh Comyujah 84 (say #10264)'},
         }},
        {id = 's7', at = {n = 7, fp = 'head back to the hall of'},
         done = {
            {t = 'event', zone = 251, event = 4, why = 'Cermet Grate (_6z0) 4: plays only while the cerulean crystal is held (LandSandBoat)'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'touch the grate a second time'}},
        {id = 's9', at = {n = 9, fp = 'go down the hallway and examine'},
         done = {
            {t = 'mission', line = 'zilart', eq = 23, completed = true, why = 'mission log: The Mithra and the Crystal completed'},
            {t = 'event', zone = 251, event = 3, why = 'Shimmering Circle 3: the last cutscene, completes the mission'},
         }},
    },
}
