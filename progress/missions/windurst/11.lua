-- Step progress for Written in the Stars (Windurst mission 3-2, mission id 11). Data only; see progress/missions/windurst/1.lua
-- for the format notes. Evidence: LandSandBoat scripts/missions/windurst/3_2_Written_in_the_Stars.lua and the client event scripts
-- (S4 pseudo) 241_Rakoh_Buuma, 242_Kupipi, 242_Zubaba; key item id from res/key_items.lua.
-- Accepting is the guard menu (event 78/93/111/114, option 11) plus a Yes/No with no line of its own: step 2 rests on the nation
-- line moving to 11 and on two lines played only while the mission is current on a first run (Rakoh Buuma 188, Kupipi 120).
-- Zubaba 121 (progressEvent, no text) hands over the Charm of light; her 122 is the reminder at status 1. The Gate of Light in the
-- Inner Horutoto Ruins (zone 192, event 41 from LandSandBoat; the client scripts for that zone are not decoded) takes the charm.
-- Zubaba 135 completes the first run. Bullets 8 and 9 are the repeat (or already-moved-on) version: Zubaba 257 asks for three Rusty
-- Daggers and 151 is the trade that completes it (150 is her reminder in between). They are branch bullets, so an unused branch
-- is never ticked or inferred. A repeat completion adds nothing new to the completed set, so only the trade event marks it. The
-- notes (n = 1, 4, 5) carry no signal of their own; the Sibyl Guard lines and the post-mission events (136, 138, 147) are not used.
return {
    title = 'Written in the Stars',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', eq = 11}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'this mission can not be soloed unless'}},
        {id = 's2', at = {n = 2, fp = 'accept the mission and make your'},
         done = {
            {t = 'mission', line = 'windurst', eq = 11, completed = false, why = 'mission line: current mission = Written in the Stars'},
            {t = 'event', zone = 241, event = 188, why = 'Rakoh Buuma 188, briefing while the mission is current'},
            {t = 'chat', re = 'The head lady%-in%-waiting, Zubaba, is expecting you at Heavens Tower%.', why = 'Rakoh Buuma 188 (say #7880)'},
            {t = 'event', zone = 242, event = 120, why = 'Kupipi 120, her line while the mission is current'},
            {t = 'chat', re = 'You say that the old%.%.%.the head lady%-in%-waiting, Zubaba, requests your audience%?', why = 'Kupipi 120 (say #211)'},
         }},
        {id = 's3', at = {n = 3, fp = 'pass by kupipi and on to'},
         done = {
            {t = 'event', zone = 242, event = 121, why = 'Zubaba 121: the Charm of light handed over'},
            {t = 'ki', id = 66, gained = true, why = 'Charm of light obtained (given with event 121)'},
            {t = 'event', zone = 242, event = 122, why = 'Zubaba 122, her reminder at status 1'},
            {t = 'chat', re = 'I would like you to travel to the central tower of the Horutoto Ruins', why = 'Zubaba 122 (say #242)'},
         }},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'next you will need to get'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'pass the three mage gate inside'}},
        {id = 's6', at = {n = 6, fp = 'check the gate of light at'},
         done = {
            {t = 'event', zone = 192, event = 41, why = 'Inner Horutoto Ruins 41: the Gate of Light cutscene (takes the Charm of light)'},
            {t = 'ki', id = 66, gained = false, why = 'Charm of light taken at the Gate of Light'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to heavens tower and speak'},
         done = {
            {t = 'mission', line = 'windurst', eq = 11, completed = true, why = 'mission log: Written in the Stars completed'},
            {t = 'event', zone = 242, event = 135, why = 'Zubaba 135: mission completed'},
         }},
        {id = 's8', kind = 'branch', at = {n = 8, fp = 'accept the mission and speak to'},
         done = {
            {t = 'event', zone = 242, event = 257, why = 'Zubaba 257: asks for three Rusty Daggers (status 0 to 3)'},
            {t = 'event', zone = 242, event = 150, why = 'Zubaba 150, her reminder at status 3'},
            {t = 'chat', re = 'Journey to the central tower of the Horutoto Ruins and rid the place of those pernicious%-vicious vermin%.', why = 'Zubaba 150 (say #304)'},
         }},
        {id = 's9', kind = 'branch', at = {n = 9, fp = 'trade zubaba the daggers to'},
         done = {
            {t = 'event', zone = 242, event = 151, why = 'Zubaba 151: the three Rusty Daggers accepted, mission completed'},
            {t = 'chat', re = 'I am impressed that a mere adventurer such as yourself was able to carry out my biddy%-bidding%.', why = 'Zubaba 151 (say #306)'},
         }},
    },
}
