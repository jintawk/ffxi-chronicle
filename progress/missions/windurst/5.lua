-- Step progress for The Three Kingdoms (Windurst mission 2-3, mission id 5). Data only; see progress/missions/sandoria/5.lua and
-- bastok/5.lua for the two-route format this follows.
-- Evidence: LandSandBoat scripts/missions/windurst/2_3_0_The_Three_Kingdoms.lua and its four legs (2_3_1 Sandoria = id 6, 2_3_2 Bastok
-- = 7, 2_3_3 Sandoria2 = 8, 2_3_4 Bastok2 = 9); client event scripts S4 242_Kupipi_010F2013.txt, 237_Patt_Pott_010ED010.txt,
-- 237_Pius_010ED01A.txt, 237_Grohm_010ED028.txt, 231_Kasaroro_010E7043.txt, 231_Heruze_Moruze_010E7045.txt, 233_Halver_010E9007.txt;
-- key item 13 (Kindred crest) from res/key_items.lua.
-- The mission is a tour of Bastok and San d'Oria in either order, and the page gives each order its own headings: group `bas` =
-- Bastok first (bullets 6 to 16: ids 7 then 8) and group `san` = San d'Oria first (bullets 17 to 28: ids 6 then 9), after the shared
-- start (bullets 4 and 5, group main). The nation line moves to a leg's id on its first event (Patt-Pott 254 -> 7, Kasaroro 547 -> 8,
-- Kasaroro 546 -> 6, Patt-Pott 256 -> 9, each `completed = false`) and each leg's last event completes its id (Kasaroro 551 and 550
-- by event; Patt-Pott 255, the Mythril Sand trade, and 257 sit in a sibling LandSandBoat script with no client body, so only the
-- leg's completed id is used for those two: `completed = true`). Pius 355 plays in both orders (status 3 in the Bastok-first leg,
-- 8 in the San d'Oria-first one) and Kupipi 101 ends both, so they carry `after` (a step of that group that is done). Grohm 423 / 425
-- (Bastok first) and 426 (San d'Oria first), the Halver events 504 / 502 and the Kasaroro events are one order only.
-- A character that finished before installing Chronicle (or is past the mission) carries the completed ids: id 5 ticks bullet 5, the
-- legs' ids tick the route taken and id 5 `after` the route's last leg ticks its final bullet, so the other route stays open. No
-- `completes` step: the finish is bullet 16 or 28, and the snapshot test of test_steps.lua feeds the completed id alone.
-- Kupipi 95's one line (#114) plays only with the Trust Semih branch, so it is not used; Kupipi 97 / 98 repeat at any time. Heruze-Moruze
-- 582 (San d'Oria first, status 1 -> 2) is `reach` on the bullet that also needs Kasaroro. The Pius bullet of the San d'Oria-first order
-- also sends you to Grohm: Pius 355 is `reach`, Grohm 426 (status 9) is the proof. Not mapped: the Mythril Sand, Mine Gravel,
-- Palborough / Waughroon walking, the Warchief Vatgit kill (the next Kasaroro talk proves it) and the travel bullets; the Cipher items
-- can come from elsewhere, and the letter to the consuls is not in res/key_items.lua. None of the listed events plays on a refusal.
return {
    title = 'The Three Kingdoms',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    groups = {main = {start = {{t = 'mission', line = 'windurst', eq = 5, completed = false, why = 'mission log: current mission = The Three Kingdoms'}}}},
    steps = {
        {id = 's4', group = 'main', kind = 'note', with = 's5', at = {n = 4, fp = 'this mission can be long if'}},
        {id = 's5', group = 'main', at = {n = 5, fp = 'speak with kupipi in heavens tower'},
         done = {
            {t = 'event', zone = 242, event = 95, why = 'Kupipi 95: the Letter to the consuls handed over (status 0)'},
            {t = 'mission', line = 'windurst', eq = 5, completed = true, why = 'mission log: The Three Kingdoms completed'},
         }},

        -- order A: Bastok (id 7), then San d'Oria (id 8)
        {id = 's6', group = 'bas', implies = {'s5'}, at = {n = 6, fp = 'speak to patt pott in bastok'},
         done = {
            {t = 'event', zone = 237, event = 254, why = 'Patt-Pott 254: the Bastok leg started (status 1)'},
            {t = 'mission', line = 'windurst', eq = 7, completed = false, why = 'mission line: current mission = The Three Kingdoms (Bastok)'},
         }},
        {id = 's7', group = 'bas', at = {n = 7, fp = 'speak to pius in the president'},
         done = {
            {t = 'event', zone = 237, event = 355, after = 's6', why = 'Pius 355: sent on to Grohm (Bastok first)'},
         }},
        {id = 's8', group = 'bas', at = {n = 8, fp = 'speak to grohm at h 9'},
         done = {
            {t = 'event', zone = 237, event = 423, why = 'Grohm 423: the pickaxes (Bastok leg)'},
            {t = 'event', zone = 237, event = 425, why = 'Grohm 425: the pickaxes after a full bag (Bastok leg)'},
            {t = 'chat', re = "Here, take these .*Good luck%. You're gonna need it%.", why = 'Grohm 423 / 425 (say #7774)'},
         }},
        {id = 's9', group = 'bas', kind = 'note', with = 's11', at = {n = 9, fp = 'make your way to palborough mines'}},
        {id = 's10', group = 'bas', kind = 'note', with = 's11', at = {n = 10, fp = 'once you receive the mine gravel'}},
        {id = 's11', group = 'bas', at = {n = 11, fp = 'trade the mythril sand to patt'},
         done = {
            {t = 'mission', line = 'windurst', eq = 7, completed = true, why = 'mission log: The Three Kingdoms (Bastok) completed'},
         }},
        {id = 's12', group = 'bas', implies = {'s5'}, at = {n = 12, fp = 'speak to kasaroro in the windurstian'},
         done = {
            {t = 'event', zone = 231, event = 547, why = 'Kasaroro 547: sent to Halver, the San d Oria leg started (status 7)'},
            {t = 'chat', re = "Why, it's .*! I heard about your success from Consul Patt%-Pott in Bastok%.", why = 'Kasaroro 547 (say #11487)'},
            {t = 'mission', line = 'windurst', eq = 8, completed = false, why = 'mission line: current mission = The Three Kingdoms (San d Oria), second'},
         }},
        {id = 's13', group = 'bas', at = {n = 13, fp = 'speak to halver in chateau d'},
         done = {
            {t = 'event', zone = 233, event = 504, why = 'Halver 504: sent on to the Horlais Peak battlefield (status 8)'},
            {t = 'chat', re = 'An adventurer from Windurst, are you%? Consul Kasaroro sent word about you%.', why = 'Halver 504 (say #7086)'},
         }},
        {id = 's14', group = 'bas', at = {n = 14, fp = 'go to horlais peak and clear'},
         done = {
            {t = 'ki', id = 13, gained = true, after = 's13', why = 'Kindred crest obtained at the Horlais Peak win'},
            {t = 'chat', re = 'obtained key item: kindred crest', after = 's13', why = 'chat: key item obtained'},
         }},
        {id = 's15', group = 'bas', at = {n = 15, fp = 'return to kasaroro at northern san'},
         done = {
            {t = 'event', zone = 231, event = 551, why = 'Kasaroro 551: the Kindred crest handed in, completes the San d Oria leg'},
            {t = 'chat', re = "I've heard of what you did, and I have to say I'm impressed! You make me proud to be a Windurstian!", why = 'Kasaroro 551 (say #11493)'},
            {t = 'mission', line = 'windurst', eq = 8, completed = true, why = 'mission log: The Three Kingdoms (San d Oria), second, completed'},
         }},
        {id = 's16', group = 'bas', implies = {'s5'}, at = {n = 16, fp = 'return to kupipi in heavens tower'},
         done = {
            {t = 'event', zone = 242, event = 101, after = 's15', why = 'Kupipi 101: the mission completed, the Kindred report taken (Bastok first)'},
            {t = 'mission', line = 'windurst', eq = 5, completed = true, after = 's15', why = 'mission log: The Three Kingdoms completed after the Bastok-first legs'},
         }},

        -- order B: San d'Oria (id 6), then Bastok (id 9)
        {id = 's17', group = 'san', kind = 'note', with = 's18', at = {n = 17, fp = 'make your way to san d'}},
        {id = 's18', group = 'san', implies = {'s5'}, at = {n = 18, fp = 'speak to heruze moruze and then'},
         done = {
            {t = 'event', zone = 231, event = 546, why = 'Kasaroro 546: the San d Oria leg started (status 2)'},
            {t = 'chat', re = 'Greetings, .*! I am Consul Kasaroro%.', why = 'Kasaroro 546 (say #11468)'},
            {t = 'mission', line = 'windurst', eq = 6, completed = false, why = 'mission line: current mission = The Three Kingdoms (San d Oria)'},
         },
         reach = {
            {t = 'event', zone = 231, event = 582, why = 'Heruze-Moruze 582: sent to Kasaroro (status 1 to 2)'},
            {t = 'chat', re = "You've come on orders from the homeland, have you%? You should speak with Consul Kasaroro%.", why = 'Heruze-Moruze 582 (say #11467)'},
         }},
        {id = 's19', group = 'san', at = {n = 19, fp = 'head over to chateau d oraguille'},
         done = {
            {t = 'event', zone = 233, event = 502, why = 'Halver 502: sent on to Ghelsba Outpost (status 3)'},
            {t = 'chat', re = 'An adventurer from Windurst, are you%? Well, you have my respect for coming all the way here%.', why = 'Halver 502 (say #7073)'},
         }},
        {id = 's20', group = 'san', kind = 'note', with = 's21', at = {n = 20, fp = 'inside head for h 7 and'}},
        {id = 's21', group = 'san', at = {n = 21, fp = 'speak to kasaroro again you are'},
         done = {
            {t = 'event', zone = 231, event = 550, why = 'Kasaroro 550: Warchief Vatgit defeated, completes the San d Oria leg'},
            {t = 'chat', re = "Welcome back%. I trust you weren't hurtaru%?", why = 'Kasaroro 550 (say #11478)'},
            {t = 'mission', line = 'windurst', eq = 6, completed = true, why = 'mission log: The Three Kingdoms (San d Oria) completed'},
         }},
        {id = 's22', group = 'san', implies = {'s5'}, at = {n = 22, fp = 'make your way to bastok enter'},
         done = {
            {t = 'event', zone = 237, event = 256, why = 'Patt-Pott 256: the second leg started, the letter taken (status 6)'},
            {t = 'mission', line = 'windurst', eq = 9, completed = false, why = 'mission line: current mission = The Three Kingdoms (Bastok), second'},
         }},
        {id = 's23', group = 'san', at = {n = 23, fp = 'speak to pius in the president'},
         done = {
            {t = 'event', zone = 237, event = 426, why = 'Grohm 426: the beastmen briefing (status 9, after Pius)'},
            {t = 'chat', re = "Never mind, shouting at you won't change anything%.", why = 'Grohm 426 (say #7785)'},
         },
         reach = {
            {t = 'event', zone = 237, event = 355, after = 's22', why = 'Pius 355: sent on to Grohm (San d Oria first)'},
         }},
        {id = 's24', group = 'san', kind = 'note', with = 's26', at = {n = 24, fp = 'make your way to palborough mines'}},
        {id = 's25', group = 'san', kind = 'note', with = 's26', at = {n = 25, fp = 'inside make your way to i'}},
        {id = 's26', group = 'san', at = {n = 26, fp = 'prepare and enter buffs will wear'},
         done = {
            {t = 'ki', id = 13, gained = true, after = 's23', why = 'Kindred crest obtained at the Waughroon Shrine win'},
            {t = 'chat', re = 'obtained key item: kindred crest', after = 's23', why = 'chat: key item obtained'},
         }},
        {id = 's27', group = 'san', at = {n = 27, fp = 'once cleared return to patt pott'},
         done = {
            {t = 'mission', line = 'windurst', eq = 9, completed = true, why = 'mission log: The Three Kingdoms (Bastok), second, completed'},
         }},
        {id = 's28', group = 'san', implies = {'s5'}, at = {n = 28, fp = 'your journey is almost complete head'},
         done = {
            {t = 'event', zone = 242, event = 101, after = 's27', why = 'Kupipi 101: the mission completed, the Kindred report taken (San d Oria first)'},
            {t = 'mission', line = 'windurst', eq = 5, completed = true, after = 's27', why = 'mission log: The Three Kingdoms completed after the San d Oria-first legs'},
         }},
    },
}
