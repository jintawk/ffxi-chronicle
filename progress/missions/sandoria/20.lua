-- Step progress for Coming of Age (San d'Oria mission 8-1, mission id 20). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/8_1_Coming_of_Age.lua; client event script S4 233_Halver_010E9007.txt (58: say #6814;
-- 102: say #6827 and #6828); key item 288 drops of Amnio (res/key_items.lua); Quicksand Caves zone text SENSE_SOMETHING_EVIL (7382).
-- Chateau d'Oraguille zone-in 116 (status 0, a cutscene on entering; sets status 1), Halver 58 (status 1 -> 2), the Fountain of Kings
-- ("You sense something evil." when Honor and Valor spawn at status 2; the same words are King Ranperre's Tomb's line from mission 6-2,
-- so the matcher carries after = 's2'), the drops of Amnio (given at status 3, an intermediate key item taken at the end) and Halver 102
-- (needs the drops; completes, takes them). The final cutscene (zone-in 16 in Northern San d'Oria, a minute after completing) plays after
-- the log completes, so it is a post step; the zone-in is shared by nothing else in LandSandBoat but carries after = 's8' anyway. The
-- zone-in 116 and 16 and the cave events have no decoded body, so their ids come from LandSandBoat. The two Prince's doors (64, 75)
-- are optional cutscenes bracketed under bullet 2 (indented) and are not steps.
return {
    title = 'Coming of Age',
    completes = 's8',
    known = {{t = 'mission', line = 'sandoria', min = 20}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to chateau d oraguille where'},
         done = {
            {t = 'zonein', zone = 233, event = 116, why = "Chateau d'Oraguille zone-in 116 (status 0, LandSandBoat)"},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to halver for instructions'},
         done = {
            {t = 'event', zone = 233, event = 58, why = 'Halver 58 (status 1 only)'},
            {t = 'chat', re = 'requires much preparation%. This is where your assistance is necessary', why = 'Halver 58 (say #6815)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'travel to the quicksand caves map'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'you will need to drop down'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'once you drop down travel to'}},
        {id = 's6', at = {n = 6, fp = 'clear the area and check fountain'},
         done = {
            {t = 'chat', re = 'You sense something evil%.', after = 's2', why = 'the Fountain of Kings checked, Honor and Valor spawn (Quicksand Caves text 7382)'},
         }},
        {id = 's7', at = {n = 7, fp = 'check the fountain of kings again'},
         done = {
            {t = 'ki', id = 288, gained = true, why = 'drops of Amnio obtained'},
            {t = 'ki_have', id = 288, have = true, why = 'drops of Amnio held'},
            {t = 'chat', re = 'obtained key item: drops of amnio', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to halver'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 20, completed = true, why = 'mission log: Coming of Age completed'},
            {t = 'event', zone = 233, event = 102, why = 'Halver 102 (needs the drops of Amnio, completes)'},
            {t = 'chat', re = 'Tradition prohibits us from allowing you to attend the ceremony', why = 'Halver 102 (say #6828)'},
         }},
        {id = 's9', kind = 'post', at = {n = 9, fp = 'wait 1 earth minute then exit'},
         done = {
            {t = 'zonein', zone = 231, event = 16, after = 's8', why = 'Northern San d\'Oria zone-in 16: the final cutscene (LandSandBoat)'},
         }},
    },
}
