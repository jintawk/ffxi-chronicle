-- Step progress for Where Messengers Gather (the Ulmia path of Three Paths, page id 560). Data only; see progress/missions/cop/530.lua, whose ulmia group
-- carries the same steps with the same matchers: each is proved by nibble 4 of the CoP progress word (the server's status of the path) and
-- by the NPC events of LandSandBoat scripts/missions/cop/5_3_Three_Paths.lua and the client scripts it names (Hinaree 22/25, Port San d'Oria zone-in 4, Chasalvige 762, Kerutoto 876/882, Yoran-Oran 473/479, Cid 855). The single group starts
-- when the cop line moves to 530. The last bullet (Cid, status 14) is the page's completion.
-- Head Wind and Flames for the Dead have no event of their own (32001 is any win in the zone), so their wins are word values 8 and 9: Head Wind at
-- bullet 9, Flames for the Dead at bullet 10 (its fight is the indented bullets 11-14, which are never steps). The "other 2 paths" bullet and the
-- Out of the Depths / squire quest pointers have no signal and stay plain bullets.

return {
    title = 'Where Messengers Gather',
    completes = 's15',
    known = {{t = 'mission', line = 'cop', eq = 530}},
    groups = {main = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'head to southern san d oria'},
         done = {
            {t = 'word', nib = 4, min = 2, max = 2, why = 'Ulmia status 2: Hinaree 22 (:523-526)'},
            {t = 'event', zone = 230, event = 22, why = 'Hinaree 22 (status 0 only)'},
            {t = 'event', zone = 230, event = 25, conf = 'inferred', why = 'Hinaree 25: the reminder at status 2'},
            {t = 'chat', re = 'ulmia journeys to the port every day', conf = 'inferred', why = 'Hinaree 25 (say #9675)'},
         }},
        {id = 's3', at = {n = 3, fp = 'zone into port san d oria'},
         done = {
            {t = 'word', nib = 4, min = 3, max = 3, why = 'Ulmia status 3: Port San d\'Oria zone-in cutscene 4 (:531-542)'},
            {t = 'zonein', zone = 232, event = 4, why = 'Port San d\'Oria zone-in cutscene 4 (status 2 only)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak with chasalvige l 6 in'},
         done = {
            {t = 'word', nib = 4, min = 4, max = 5, why = 'Ulmia status 4: Chasalvige 762 (:562-565)'},
            {t = 'event', zone = 231, event = 762, why = 'Chasalvige 762 (status 3 only)'},
         }},
        {id = 's5', at = {n = 5, fp = 'travel to windurst waters j 8'},
         done = {
            {t = 'word', nib = 4, min = 6, max = 6, why = 'Ulmia status 6: Kerutoto 876 (:585-588)'},
            {t = 'event', zone = 238, event = 876, why = 'Kerutoto 876 (status 4 only)'},
            {t = 'event', zone = 238, event = 882, conf = 'inferred', why = 'Kerutoto 882: the reminder at status 6'},
            {t = 'chat', re = 'looking for a girl with crikey', conf = 'inferred', why = 'Kerutoto 882 (say #10609)'},
         }},
        {id = 's7', at = {n = 7, fp = 'go to windurst walls e 5'},
         done = {
            {t = 'word', nib = 4, min = 7, max = 7, why = 'Ulmia status 7: Yoran-Oran 473 (:608-611)'},
            {t = 'event', zone = 239, event = 473, why = 'Yoran-Oran 473 (status 6 only)'},
            {t = 'event', zone = 239, event = 479, conf = 'inferred', why = 'Yoran-Oran 479: the reminder at status 7'},
            {t = 'chat', re = 'using my house as a stage', conf = 'inferred', why = 'Yoran-Oran 479 (say #9549)'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'head to attohwa chasm h 6'}},
        {id = 's9', at = {n = 9, fp = 'after your party is geared up'},
         done = {
            {t = 'word', nib = 4, min = 8, max = 8, why = 'Ulmia status 8: Head Wind won (:616-627)'},
         }},
        {id = 's10', at = {n = 10, fp = 'head to j 9 of uleguerand'},
         done = {
            {t = 'word', nib = 4, min = 9, max = 13, why = 'Ulmia status 9: Flames for the Dead won (:631-642); the fight is the indented bullets under this one'},
         }},
        {id = 's15', at = {n = 15, fp = 'after you defeat the snoll tzar'},
         done = {
            {t = 'word', nib = 4, min = 14, max = 14, why = 'Ulmia status 14: Cid 855 (:659-661)'},
            {t = 'event', zone = 237, event = 855, why = 'Cid 855 (status 9 only)'},
         }},
    },
}
