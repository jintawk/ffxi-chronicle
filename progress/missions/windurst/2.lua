-- Step progress for The Price of Peace (Windurst mission 1-3, mission id 2). Data only; see progress/missions/sandoria/0.lua and
-- progress/missions/windurst/1.lua for the format. Evidence: LandSandBoat scripts/missions/windurst/1_3_The_Price_of_Peace.lua and
-- the client event scripts (S4 pseudo) 240_Janshura_Rashura, 239_Zokima_Rokima, 238_Mokyokyo, 241_Rakoh_Buuma, 238_Leepe_Hoppe,
-- 145_Laa_Mozi, 145_Ghoo_Pakya; key item ids from res/key_items.lua.
-- The nation line holds 65535 with no mission, the mission id (2) while it is current, then 65535 with id 2 in the completed set.
-- Accepting is the guard menu (events 78/93/111/114, option 2 here) plus a Yes/No with no line of its own, so the offer proves
-- nothing: step 1 rests on the nation line moving to 2 and on the briefing each gate guard plays only while the mission is current
-- (Janshura-Rashura 110, Zokima-Rokima 112, Mokyokyo 136, Rakoh Buuma 150). Leepe-Hoppe 140 (progressEvent, no text) hands over the
-- Food and Drink offerings; his 142 is the reminder at the next status. The Giddeus Yagudo play 45 (Laa Mozi, food) and 49 (Ghoo
-- Pakya, drink) at status 2 and take the offering key item; at status 3 they play the replacement 48 / 52, which also say
-- "no offering" and are not used. Event 146 is the trigger area on the Rhinostery stairs (status 3 to 4). Completing is the
-- gate guard's progressEvent at status 4: Janshura-Rashura 114, Zokima-Rokima 116, Mokyokyo 148 or Rakoh Buuma 154. The post-mission
-- dialogue events (Puo Rhen 116, Ten of Hearts 154 and the like) play after completion and are not used.
return {
    title = 'The Price of Peace',
    completes = 's7',
    known = {{t = 'mission', line = 'windurst', eq = 2}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'accept the mission from any gate'},
         done = {
            {t = 'mission', line = 'windurst', eq = 2, completed = false, why = 'mission line: current mission = The Price of Peace'},
            {t = 'event', zone = 240, event = 110, why = 'Janshura-Rashura 110, briefing while the mission is current'},
            {t = 'chat', re = "First head to the Rhinostery's biological laboratory in Windurst Waters", why = 'Janshura-Rashura 110 (say #3418)'},
            {t = 'event', zone = 239, event = 112, why = 'Zokima-Rokima 112, briefing while the mission is current'},
            {t = 'chat', re = 'Head over to the Rhinostery in Windurst Waters and pick up the food offerings for the Yagudo%.', why = 'Zokima-Rokima 112 (say #7351)'},
            {t = 'event', zone = 238, event = 136, why = 'Mokyokyo 136, briefing while the mission is current'},
            {t = 'chat', re = "First, head to the Rhinostery's biological laboratory here in the south of Windurst Waters%.", why = 'Mokyokyo 136 (say #7599)'},
            {t = 'event', zone = 241, event = 150, why = 'Rakoh Buuma 150, briefing while the mission is current'},
            {t = 'chat', re = 'Anyway, you had better head on over to the Rrrhinostery in Windurst Waters', why = 'Rakoh Buuma 150 (say #7796)'},
         }},
        {id = 's2', at = {n = 2, fp = 'then make your way to the'},
         done = {
            {t = 'event', zone = 238, event = 140, why = 'Leepe-Hoppe 140: the Food and Drink offerings handed over'},
            {t = 'ki', id = 17, gained = true, why = 'Food offering obtained (given with event 140)'},
            {t = 'event', zone = 238, event = 142, why = 'Leepe-Hoppe 142, his reminder after the offerings were handed over'},
            {t = 'chat', re = 'The places where the altars of offering stand', why = 'Leepe-Hoppe 142 (say #7614)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head out for giddeus which is'}},
        {id = 's4', at = {n = 4, fp = 'make your way to h 7'},
         done = {
            {t = 'event', zone = 145, event = 45, why = 'Laa Mozi 45: the Food offering taken at status 2'},
            {t = 'chat', re = "Good! We are taking smoothskin's food offering%.", why = 'Laa Mozi 45 (say #7357)'},
            {t = 'ki', id = 17, gained = false, why = 'Food offering handed over'},
         }},
        {id = 's5', at = {n = 5, fp = 'next head to g 7 and'},
         done = {
            {t = 'event', zone = 145, event = 49, why = 'Ghoo Pakya 49: the Drink offering taken at status 2'},
            {t = 'chat', re = 'You be coming long way to deliver this, kyah%?', why = 'Ghoo Pakya 49 (say #7364)'},
            {t = 'ki', id = 18, gained = false, why = 'Drink offering handed over'},
         }},
        {id = 's6', at = {n = 6, fp = 'head back to the rhinostery as'},
         done = {
            {t = 'event', zone = 238, event = 146, why = 'Windurst Waters 146: the cutscene on the Rhinostery stairs (status 3 to 4)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to the gate guard to'},
         done = {
            {t = 'mission', line = 'windurst', eq = 2, completed = true, why = 'mission log: The Price of Peace completed'},
            {t = 'event', zone = 240, event = 114, why = 'Janshura-Rashura 114: mission completed'},
            {t = 'event', zone = 239, event = 116, why = 'Zokima-Rokima 116: mission completed'},
            {t = 'chat', re = 'Thataru seemed to go withoutaru a hitch this time%.', why = 'Zokima-Rokima 116 (say #7359)'},
            {t = 'event', zone = 238, event = 148, why = 'Mokyokyo 148: mission completed'},
            {t = 'event', zone = 241, event = 154, why = 'Rakoh Buuma 154: mission completed'},
            {t = 'chat', re = "I suggest you try your hand at conquests now, as you'll need to gain more rrrank points before we can issue you further missions%.", why = 'Rakoh Buuma 154 (say #7805)'},
         }},
    },
}
