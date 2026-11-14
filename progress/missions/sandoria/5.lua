-- Step progress for Journey Abroad (San d'Oria mission 2-3, mission id 5). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/2_3_0_Journey_Abroad.lua and its four parts (2_3_1 Journey to Bastok = id 6,
-- 2_3_2 Journey to Windurst = 7, 2_3_3 Journey to Bastok2 = 8, 2_3_4 Journey to Windurst2 = 9); client event lists and scripts S4
-- 233_Halver_010E9007.txt (505, 507), 237_Savae_E_Paleade_010ED00C.txt, 237_Pius_010ED01A.txt, 237_Grohm_010ED028.txt,
-- 241_Mourices_010F1025.txt, 242_Kupipi_010F2013.txt, 145_Uu_Zhoumo_010911C9.txt; key items 13 (Kindred crest),
-- 32 (shield offering), 34 (dark key) from res/key_items.lua.
-- The mission is a tour of both foreign nations, done in one of two orders, each a full set of bullets on the page: group `a` =
-- Bastok first (bullets 11 to 25: ids 6 then 9) and group `b` = Windurst first (26 to 40: ids 7 then 8). Two groups, so the other
-- order's bullets are never shown done by the order taken. The nation line moves to the leg's id on its first event (Savae 204 ->
-- 6, Mourices 462 -> 9, Mourices 448 -> 7, Savae 206 -> 8, each `completed = false`) and each leg's last event completes its id
-- (Savae 205, Mourices 467, Mourices 457, Savae 207: `completed = true`; 205 and 207 have no client body and sit in a sibling
-- LandSandBoat script, so only the leg's completed id is used for those two). Pius 355, the Kindred crest and Halver 507 are shared
-- by both orders, so they carry `after` (a step of that group that is done). Grohm 423 / 425 (pickaxes) and 426 differ per leg.
-- Halver 505 (status 0) hands out the letter to the consuls (that key item id is not in res/key_items.lua, so no key item is used);
-- Halver 507 (status 11) completes the whole mission. There is no single `completes` step: the finish is a different bullet in
-- each order (25 or 40). A character that finished before installing Chronicle (or is past the mission) is read from the log's
-- completed ids: the mission's own id 5 ticks bullet 5, the legs' ids tick the route taken (6 and 9 = order A, 7 and 8 = order B),
-- and id 5 completed after the route's last leg ticks that route's final bullet, so only the route taken shows finished. The
-- login reads the ids ascending, so the final bullet's matcher (`after` the last leg) is tried again once the legs are in
-- (core/progress_engine.lua, the snapshot retry). Not mapped: the Mythril Sand,
-- Mine Gravel, Waughroon / Giddeus walking and Zhuu Buxu bullets (no event of their own).
-- Many of these events (Pius 355, Grohm 423 to 427, Mourices, Kupipi) are shared with the Bastok and Windurst nation missions, which
-- a San d'Orian character does not run. The draft made every bullet a note except Halver, offered no group, and used 'min' mission
-- guesses; fixed.
return {
    title = 'Journey Abroad',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    steps = {
        {id = 's5', at = {n = 5, fp = 'you will be instructed to speak'},
         done = {
            {t = 'event', zone = 233, event = 505, why = 'Halver 505: the mission briefing (status 0)'},
            {t = 'chat', re = "Ah, you are .*, are you not%? I've heard word of you from the gatehouse%.", why = 'Halver 505 (say #7062)'},
            {t = 'mission', line = 'sandoria', eq = 5, completed = true, why = 'mission log: Journey Abroad completed'},
         }},

        -- order A: Bastok (id 6), then Windurst (id 9)
        {id = 's11', group = 'a', at = {n = 11, fp = 'once you get to bastok head'},
         done = {
            {t = 'event', zone = 237, event = 204, why = 'Savae E Paleade 204: the letter handed in, Bastok first (status 2)'},
            {t = 'mission', line = 'sandoria', eq = 6, completed = false, why = 'mission line: current mission = Journey to Bastok'},
         }},
        {id = 's12', group = 'a', at = {n = 12, fp = 'next speak with pius inside the'},
         done = {
            {t = 'event', zone = 237, event = 355, after = 's11', why = 'Pius 355: the envoy (Bastok first)'},
         }},
        {id = 's13', group = 'a', at = {n = 13, fp = 'you will be asked to speak'},
         done = {
            {t = 'event', zone = 237, event = 423, why = 'Grohm 423: the pickaxes (Journey to Bastok)'},
            {t = 'event', zone = 237, event = 425, why = 'Grohm 425: the pickaxes after a full bag (Journey to Bastok)'},
            {t = 'chat', re = "Here, take these .*Good luck%. You're gonna need it%.", why = 'Grohm 423 / 425 (say #7774)'},
         }},
        {id = 's17', group = 'a', at = {n = 17, fp = 'return to the consulate and trade'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 6, completed = true, why = 'mission log: Journey to Bastok completed (Savae E Paleade 205, the Mythril Sand)'},
         }},
        {id = 's19', group = 'a', at = {n = 19, fp = 'inside speak with mourices then head'},
         done = {
            {t = 'event', zone = 241, event = 462, why = 'Mourices 462: Windurst second (status 6)'},
            {t = 'mission', line = 'sandoria', eq = 9, completed = false, why = 'mission line: current mission = Journey to Windurst (second)'},
         }},
        {id = 's20', group = 'a', at = {n = 20, fp = 'inside speak with kupipi for the'},
         done = {
            {t = 'event', zone = 242, event = 242, why = 'Kupipi 242: the dark key (Journey to Windurst, second)'},
            {t = 'ki', id = 34, gained = true, why = 'dark key obtained'},
            {t = 'chat', re = 'obtained key item: dark key', why = 'chat: key item obtained'},
         }},
        {id = 's23', group = 'a', at = {n = 23, fp = 'after you will receive a cutscene'},
         done = {
            {t = 'ki', id = 13, gained = true, after = 's20', why = "Kindred crest obtained (the Balga's Dais victory)"},
            {t = 'chat', re = 'obtained key item: kindred crest', after = 's20', why = 'chat: key item obtained'},
         }},
        {id = 's24', group = 'a', at = {n = 24, fp = 'speak with mourices at the san'},
         done = {
            {t = 'event', zone = 241, event = 467, why = 'Mourices 467: the Kindred crest handed in, completes Journey to Windurst (second)'},
            {t = 'mission', line = 'sandoria', eq = 9, completed = true, why = 'mission log: Journey to Windurst (second) completed'},
         }},
        {id = 's25', group = 'a', at = {n = 25, fp = 'next return to san d oria'},
         implies = {'s5'},
         done = {
            {t = 'event', zone = 233, event = 507, after = 's24', why = 'Halver 507: the report, completes Journey Abroad (Bastok first)'},
            {t = 'chat', re = "Let's see the report you've brought back, then!", after = 's24', why = 'Halver 507 (say #7097)'},
            {t = 'mission', line = 'sandoria', eq = 5, completed = true, after = 's24', why = 'mission log: Journey Abroad completed after the Bastok-first legs'},
         }},

        -- order B: Windurst (id 7), then Bastok (id 8)
        {id = 's27', group = 'b', at = {n = 27, fp = 'inside speak with mourices then head'},
         done = {
            {t = 'event', zone = 241, event = 448, why = 'Mourices 448: the letter handed in, Windurst first (status 2)'},
            {t = 'mission', line = 'sandoria', eq = 7, completed = false, why = 'mission line: current mission = Journey to Windurst'},
         }},
        {id = 's28', group = 'b', at = {n = 28, fp = 'inside speak with kupipi for the'},
         done = {
            {t = 'event', zone = 242, event = 238, why = 'Kupipi 238: the shield offering (Journey to Windurst)'},
            {t = 'ki', id = 32, gained = true, why = 'shield offering obtained'},
            {t = 'chat', re = 'obtained key item: shield offering', why = 'chat: key item obtained'},
         }},
        {id = 's31', group = 'b', at = {n = 31, fp = 'now head west to f 7'},
         done = {
            {t = 'event', zone = 145, event = 42, why = 'Uu Zhoumo 42: the shield offering offered up (only with the key item held)'},
            {t = 'chat', re = 'Good%. Good%. Hoot!', why = 'Uu Zhoumo 42 (say #7377)'},
         }},
        {id = 's32', group = 'b', at = {n = 32, fp = 'return to the san d orian'},
         done = {
            {t = 'event', zone = 241, event = 457, why = 'Mourices 457: the two Parana Shields accepted, completes Journey to Windurst'},
            {t = 'mission', line = 'sandoria', eq = 7, completed = true, why = 'mission log: Journey to Windurst completed'},
         }},
        {id = 's33', group = 'b', at = {n = 33, fp = 'once you get to bastok head'},
         done = {
            {t = 'event', zone = 237, event = 206, why = 'Savae E Paleade 206: Bastok second (status 7)'},
            {t = 'mission', line = 'sandoria', eq = 8, completed = false, why = 'mission line: current mission = Journey to Bastok (second)'},
         }},
        {id = 's34', group = 'b', at = {n = 34, fp = 'next speak with pius inside the'},
         done = {
            {t = 'event', zone = 237, event = 355, after = 's33', why = 'Pius 355: the envoy (Bastok second)'},
         }},
        {id = 's35', group = 'b', at = {n = 35, fp = 'you will be asked to speak'},
         done = {
            {t = 'event', zone = 237, event = 426, why = 'Grohm 426: the beastmen briefing (Journey to Bastok, second)'},
            {t = 'chat', re = "Never mind, shouting at you won't change anything%.", why = 'Grohm 426 (say #7785)'},
         }},
        {id = 's37', group = 'b', at = {n = 37, fp = 'inside follow the right wall until'},
         done = {
            {t = 'ki', id = 13, gained = true, after = 's35', why = 'Kindred crest obtained (the Waughroon Shrine victory)'},
            {t = 'chat', re = 'obtained key item: kindred crest', after = 's35', why = 'chat: key item obtained'},
         }},
        {id = 's39', group = 'b', at = {n = 39, fp = 'speak with savae e paleade at'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 8, completed = true, why = 'mission log: Journey to Bastok (second) completed (Savae E Paleade 207, the Kindred crest)'},
         }},
        {id = 's40', group = 'b', at = {n = 40, fp = 'return to san d oria and'},
         implies = {'s5'},
         done = {
            {t = 'event', zone = 233, event = 507, after = 's39', why = 'Halver 507: the report, completes Journey Abroad (Windurst first)'},
            {t = 'chat', re = "Let's see the report you've brought back, then!", after = 's39', why = 'Halver 507 (say #7097)'},
            {t = 'mission', line = 'sandoria', eq = 5, completed = true, after = 's39', why = 'mission log: Journey Abroad completed after the Windurst-first legs'},
         }},
    },
}
