-- Step progress for Past Sins (the Louverance path of Three Paths, page id 540). Data only; see progress/missions/cop/530.lua, whose louverance group
-- carries the same steps with the same matchers: each is proved by nibble 2 of the CoP progress word (the server's status of the path) and
-- by the NPC events of LandSandBoat scripts/missions/cop/5_3_Three_Paths.lua and the client scripts it names (Despachiaire 118/134, Perih Vashai 686/687, Warmachine 33, Yoran-Oran 481, Oldton zone-in 1, Cid 852/853, Mine Shaft event 3). The single group starts
-- when the cop line moves to 530. The last bullet (Cid, status 14) is the page's completion.
-- The battlefield win (word value 9, at bullet 9), the Gold Key farm, the "other 2 paths" cutscene and the One Good Deed pointer have no
-- signal of their own and stay plain bullets or notes.

return {
    title = 'Past Sins',
    completes = 's13',
    known = {{t = 'mission', line = 'cop', eq = 530}},
    groups = {main = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'talk to despachiaire at the tavnazian'},
         done = {
            {t = 'word', nib = 2, min = 2, max = 2, why = 'Louverance status 2: Despachiaire 118 (5_3_Three_Paths.lua:128-131)'},
            {t = 'event', zone = 26, event = 118, why = 'Despachiaire 118: the path begins (status 0 only)'},
            {t = 'event', zone = 26, event = 134, conf = 'inferred', why = 'Despachiaire 134: the reminder, plays at every status above 0'},
            {t = 'chat', re = 'a young mithran sin hunter visited the safehold', conf = 'inferred', why = 'Despachiaire 134 (say #10279)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak with perih vashai at k'},
         done = {
            {t = 'word', nib = 2, min = 3, max = 5, why = 'Louverance status 3: Perih Vashai 686 (:151-154)'},
            {t = 'event', zone = 241, event = 686, why = 'Perih Vashai 686 (status 2 only)'},
            {t = 'event', zone = 241, event = 687, conf = 'inferred', why = 'Perih Vashai 687: the reminder at status 3'},
            {t = 'chat', re = 'advise against traveling with that elvaan', conf = 'inferred', why = 'Perih Vashai 687 (say #10028)'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to h 11 on purgonorgo'},
         done = {
            {t = 'word', nib = 2, min = 6, max = 7, why = 'Louverance status 6: Warmachine 33 (:170-173)'},
            {t = 'event', zone = 4, event = 33, why = 'Warmachine 33 (status 3 only)'},
         }},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'optional head to e 5 in'},
         done = {
            {t = 'event', zone = 239, event = 481, why = 'Yoran-Oran 481 (Louverance status 6 only)'},
            {t = 'chat', re = 'where the statue in tavnazia came from', why = 'Yoran-Oran 481 (say #9558)'},
         }},
        {id = 's6', at = {n = 6, fp = 'travel to oldton movalpolos and zone'},
         done = {
            {t = 'word', nib = 2, min = 8, max = 8, why = 'Louverance status 8: Oldton zone-in cutscene 1 (:201-210)'},
            {t = 'zonein', zone = 11, event = 1, why = 'Oldton Movalpolos zone-in cutscene 1 (status 6 only)'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'the next step is the bc'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'before the battle is commenced make'}},
        {id = 's9', at = {n = 9, fp = 'after you have made your way'},
         done = {
            {t = 'word', nib = 2, min = 9, max = 10, why = 'Louverance status 9: Century of Hardship won (:238-244)'},
         }},
        {id = 's10', at = {n = 10, fp = 'after clearing the bc speak with'},
         done = {
            {t = 'word', nib = 2, min = 11, max = 11, why = 'Louverance status 11: Cid 852 (:266-268)'},
            {t = 'event', zone = 237, event = 852, why = 'Cid 852 (status 9 only)'},
         }},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'head to newton movalpolos and farm'}},
        {id = 's12', at = {n = 12, fp = 'head to mine shaft 2716 see'},
         done = {
            {t = 'word', nib = 2, min = 12, max = 13, why = 'Louverance status 12: the Gold Key traded (:219-235)'},
            {t = 'event', zone = 13, event = 3, why = 'Mine Shaft #2716 event 3: the Gold Key trade (status 11, a successful trade only)'},
         }},
        {id = 's13', at = {n = 13, fp = 'return to cid once again to'},
         done = {
            {t = 'word', nib = 2, min = 14, max = 14, why = 'Louverance status 14: Cid 853 (:271-273)'},
            {t = 'event', zone = 237, event = 853, why = 'Cid 853 (status 12 only)'},
         }},
    },
}
