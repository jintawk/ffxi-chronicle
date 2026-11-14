-- Step progress for Three Paths (Chains of Promathia 5-3, mission id 530). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/5_3_Three_Paths.lua (every status value is one of its setMissionStatus calls; line numbers
-- in the word matchers), its test tests/missions/cop.lua (the event order), client event scripts S4 026_Despachiaire, 230_Hinaree,
-- 231_Chasalvige, 237_Cid, 238_Kerutoto, 239_Yoran_Oran, 241_Perih_Vashai, 243_Pherimociel, 244_Monberaux (event ids, reminder lines),
-- key items 612 and 613 from res/key_items.lua. The server keeps one counter per path in the CoP progress word (0x056 0xFFFF +0x14,
-- nibble 2 Louverance, 3 Tenzen, 4 Ulmia), so each path step is proved by its own `word` range: a nibble
-- inside [min, max] is the step's own status, a bigger one marks it done behind a later step. Only the final value 14 is confirmed on
-- retail (a recorded word 0x3FBEEEEE); the middle values are LandSandBoat's (pilot README, in-game check G1). Each path is a
-- group started by the cop line moving to 530, so each has its own next step; Cid's three "finish this path" events close the paths
-- and the last one to close completes the mission (m2, also the log's completed id or any later mission). Dropped from the draft
-- (which had no word matchers): event 32001 and 32000 as battlefield proof (they are any battlefield in the zone; the wins are word
-- values 9 and 8, at the "click the ... and enter" bullets), the Disaster Idol kill (a local variable), the first Batallia ??? cutscene
-- (event 0 only sets a script variable), the Gold Key (an item that can be bought or dropped), the "completed the other 2 paths" extra
-- Cid cutscene bullets and the Chipmy-Popmy / Out of the Depths / squire quest pointers (conditional or no signal: plain bullets), the
-- indented bullets (never steps) and the travel and maze bullets (notes on the step they lead into). Flames for the Dead is the
-- indented fight under bullet 10, so bullet 10 ticks on its win (word value 9). Notes in the "Note: speak with Cid" style stay plain bullets.
-- The single path pages 540, 550 and 560 use the same matchers.
-- Trust bullet left plain: the learned line is not in client scripts or LandSandBoat text.
return {
    title = 'Three Paths',
    completes = 'm2',
    known = {{t = 'mission', line = 'cop', eq = 530}},
    groups = {
        main = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}},
        louverance = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}},
        tenzen = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}},
        ulmia = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}},
    },
    steps = {
        {id = 'm1', at = {n = 1, fp = 'speak with cid in the metalworks'},
         done = {
            {t = 'mission', line = 'cop', eq = 530, why = 'mission log: Three Paths is the current mission, or already completed'},
            {t = 'chat', re = 'so what are you going to do', why = 'Cid 851 (say #9644): the path menu, plays only while Three Paths is current'},
            {t = 'event', zone = 237, event = 851, why = 'Cid 851: the path menu, plays only while Three Paths is current'},
         }},
        {id = 'l2', group = 'louverance', at = {tab = 'Past Sins', n = 2, fp = 'talk to despachiaire at the tavnazian'},
         done = {
            {t = 'word', nib = 2, min = 2, max = 2, why = 'Louverance status 2: Despachiaire 118 (5_3_Three_Paths.lua:128-131)'},
            {t = 'event', zone = 26, event = 118, why = 'Despachiaire 118: the path begins (status 0 only)'},
            {t = 'event', zone = 26, event = 134, conf = 'inferred', why = 'Despachiaire 134: the reminder, plays at every status above 0'},
            {t = 'chat', re = 'a young mithran sin hunter visited the safehold', conf = 'inferred', why = 'Despachiaire 134 (say #10279)'},
         }},
        {id = 'l3', group = 'louverance', at = {tab = 'Past Sins', n = 3, fp = 'speak with perih vashai at k'},
         done = {
            {t = 'word', nib = 2, min = 3, max = 5, why = 'Louverance status 3: Perih Vashai 686 (:151-154)'},
            {t = 'event', zone = 241, event = 686, why = 'Perih Vashai 686 (status 2 only)'},
            {t = 'event', zone = 241, event = 687, conf = 'inferred', why = 'Perih Vashai 687: the reminder at status 3'},
            {t = 'chat', re = 'advise against traveling with that elvaan', conf = 'inferred', why = 'Perih Vashai 687 (say #10028)'},
         }},
        {id = 'l4', group = 'louverance', at = {tab = 'Past Sins', n = 4, fp = 'travel to h 11 on purgonorgo'},
         done = {
            {t = 'word', nib = 2, min = 6, max = 7, why = 'Louverance status 6: Warmachine 33 (:170-173)'},
            {t = 'event', zone = 4, event = 33, why = 'Warmachine 33 (status 3 only)'},
         }},
        {id = 'l5', group = 'louverance', kind = 'optional', at = {tab = 'Past Sins', n = 5, fp = 'optional head to e 5 in'},
         done = {
            {t = 'event', zone = 239, event = 481, why = 'Yoran-Oran 481 (Louverance status 6 only)'},
            {t = 'chat', re = 'where the statue in tavnazia came from', why = 'Yoran-Oran 481 (say #9558)'},
         }},
        {id = 'l6', group = 'louverance', at = {tab = 'Past Sins', n = 6, fp = 'travel to oldton movalpolos and zone'},
         done = {
            {t = 'word', nib = 2, min = 8, max = 8, why = 'Louverance status 8: Oldton zone-in cutscene 1 (:201-210)'},
            {t = 'zonein', zone = 11, event = 1, why = 'Oldton Movalpolos zone-in cutscene 1 (status 6 only)'},
         }},
        {id = 'l7', group = 'louverance', kind = 'note', with = 'l9', at = {tab = 'Past Sins', n = 7, fp = 'the next step is the bc'}},
        {id = 'l8', group = 'louverance', kind = 'note', with = 'l9', at = {tab = 'Past Sins', n = 8, fp = 'before the battle is commenced make'}},
        {id = 'l9', group = 'louverance', at = {tab = 'Past Sins', n = 9, fp = 'after you have made your way'},
         done = {
            {t = 'word', nib = 2, min = 9, max = 10, why = 'Louverance status 9: Century of Hardship won (:238-244)'},
         }},
        {id = 'l10', group = 'louverance', at = {tab = 'Past Sins', n = 10, fp = 'after clearing the bc speak with'},
         done = {
            {t = 'word', nib = 2, min = 11, max = 11, why = 'Louverance status 11: Cid 852 (:266-268)'},
            {t = 'event', zone = 237, event = 852, why = 'Cid 852 (status 9 only)'},
         }},
        {id = 'l11', group = 'louverance', kind = 'note', with = 'l12', at = {tab = 'Past Sins', n = 11, fp = 'head to newton movalpolos and farm'}},
        {id = 'l12', group = 'louverance', at = {tab = 'Past Sins', n = 12, fp = 'head to mine shaft 2716 see'},
         done = {
            {t = 'word', nib = 2, min = 12, max = 13, why = 'Louverance status 12: the Gold Key traded (:219-235)'},
            {t = 'event', zone = 13, event = 3, why = 'Mine Shaft #2716 event 3: the Gold Key trade (status 11, a successful trade only)'},
         }},
        {id = 'l13', group = 'louverance', at = {tab = 'Past Sins', n = 13, fp = 'return to cid once again to'},
         done = {
            {t = 'word', nib = 2, min = 14, max = 14, why = 'Louverance status 14: Cid 853 (:271-273)'},
            {t = 'event', zone = 237, event = 853, why = 'Cid 853 (status 12 only)'},
         }},
        {id = 't2', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 2, fp = 'head to g 6 in la'},
         done = {
            {t = 'word', nib = 3, min = 2, max = 2, why = 'Tenzen status 2: La Theine ??? 203 (:303-306)'},
            {t = 'event', zone = 102, event = 203, why = 'La Theine Plateau ??? 203 (status 0 only; LandSandBoat only, no client script)'},
         }},
        {id = 't3', group = 'tenzen', kind = 'note', with = 't6', at = {tab = 'The Pursuit of Paradise', n = 3, fp = 'head to the tower at j'}},
        {id = 't4', group = 'tenzen', kind = 'note', with = 't6', at = {tab = 'The Pursuit of Paradise', n = 4, fp = 'this tower is not a maze'}},
        {id = 't5', group = 'tenzen', kind = 'note', with = 't6', at = {tab = 'The Pursuit of Paradise', n = 5, fp = 'after you have made your way'}},
        {id = 't6', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 6, fp = 'check the avatar gate at the'},
         done = {
            {t = 'word', nib = 3, min = 3, max = 4, why = 'Tenzen status 3: Pso\'Xja gate cutscene 3 (:313-319, 342-343)'},
            {t = 'event', zone = 9, event = 3, why = 'Pso\'Xja gate cutscene 3 (status 2 only; LandSandBoat only)'},
         }},
        {id = 't7', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 7, fp = 'head to g 10 in upper'},
         done = {
            {t = 'word', nib = 3, min = 5, max = 5, why = 'Tenzen status 5: Monberaux 74 (:379-381)'},
            {t = 'event', zone = 244, event = 74, why = 'Monberaux 74 (status 3 only)'},
            {t = 'ki', id = 612, gained = true, why = 'envelope from Monberaux obtained'},
            {t = 'event', zone = 244, event = 5, conf = 'inferred', why = 'Monberaux 5: the reminder at status 5'},
            {t = 'chat', re = 'the boy first appeared in delkfutt', conf = 'inferred', why = 'Monberaux 5 (say #8403)'},
            {t = 'chat', re = 'obtained key item: envelope from monberaux', why = 'chat: key item obtained'},
         }},
        {id = 't8', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 8, fp = 'speak with pherimociel at g 6'},
         done = {
            {t = 'word', nib = 3, min = 6, max = 7, why = 'Tenzen status 6: Pherimociel 58 (:397-400)'},
            {t = 'event', zone = 243, event = 58, why = 'Pherimociel 58 (status 5 only)'},
         }},
        {id = 't9', group = 'tenzen', kind = 'optional', at = {tab = 'The Pursuit of Paradise', n = 9, fp = 'return to monberaux in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 6, why = 'Monberaux 6 (Tenzen status 6 only; LandSandBoat gates nothing on it)'},
            {t = 'chat', re = 'i see by his reaction that wolfgang understood', why = 'Monberaux 6 (say #8405)'},
         }},
        {id = 't10', group = 'tenzen', kind = 'note', with = 't11', at = {tab = 'The Pursuit of Paradise', n = 10, fp = 'enter batallia downs from upper jeuno'}},
        {id = 't11', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 11, fp = 'check the again to obtain a'},
         done = {
            {t = 'word', nib = 3, min = 8, max = 8, why = 'Tenzen status 8: the ??? in Batallia Downs, event 1 (:426-429)'},
            {t = 'ki', id = 613, gained = true, why = 'Delkfutt recognition device obtained'},
            {t = 'chat', re = 'obtained key item: delkfutt recognition device', why = 'chat: key item obtained'},
         }},
        {id = 't12', group = 'tenzen', kind = 'note', with = 't14', at = {tab = 'The Pursuit of Paradise', n = 12, fp = 'head to the entrance of lower'}},
        {id = 't13', group = 'tenzen', kind = 'note', with = 't14', at = {tab = 'The Pursuit of Paradise', n = 13, fp = 'go to h 5 on the'}},
        {id = 't14', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 14, fp = 'after you defeat the disaster idol'},
         done = {
            {t = 'word', nib = 3, min = 9, max = 10, why = 'Tenzen status 9: Cermet Door cutscene 25 (:466-469)'},
            {t = 'event', zone = 184, event = 25, why = 'Lower Delkfutt\'s Tower Cermet Door cutscene 25 (status 8, Idol killed)'},
         }},
        {id = 't15', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 15, fp = 'head to the tower at h'},
         done = {
            {t = 'word', nib = 3, min = 11, max = 11, why = 'Tenzen status 11: Pso\'Xja zone-in cutscene 4 (:331-347)'},
            {t = 'zonein', zone = 9, event = 4, why = 'Pso\'Xja zone-in cutscene 4 (status 9 only)'},
         }},
        {id = 't16', group = 'tenzen', kind = 'note', with = 't19', at = {tab = 'The Pursuit of Paradise', n = 16, fp = 'there are a few one way'}},
        {id = 't17', group = 'tenzen', kind = 'note', with = 't19', at = {tab = 'The Pursuit of Paradise', n = 17, fp = 'head west through the wall and'}},
        {id = 't18', group = 'tenzen', kind = 'note', with = 't19', at = {tab = 'The Pursuit of Paradise', n = 18, fp = 'exit the room to the south'}},
        {id = 't19', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 19, fp = 'take the elevator down to the'},
         done = {
            {t = 'word', nib = 3, min = 12, max = 13, why = 'Tenzen status 12: Pso\'Xja gate cutscene 5 (:322-327, 350-351)'},
            {t = 'event', zone = 9, event = 5, why = 'Pso\'Xja gate cutscene 5 (status 11 only; LandSandBoat only)'},
         }},
        {id = 't20', group = 'tenzen', at = {tab = 'The Pursuit of Paradise', n = 20, fp = 'return to cid once again to'},
         done = {
            {t = 'word', nib = 3, min = 14, max = 14, why = 'Tenzen status 14: Cid 854 (:487-489)'},
            {t = 'event', zone = 237, event = 854, why = 'Cid 854 (status 12 only)'},
         }},
        {id = 'u2', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 2, fp = 'head to southern san d oria'},
         done = {
            {t = 'word', nib = 4, min = 2, max = 2, why = 'Ulmia status 2: Hinaree 22 (:523-526)'},
            {t = 'event', zone = 230, event = 22, why = 'Hinaree 22 (status 0 only)'},
            {t = 'event', zone = 230, event = 25, conf = 'inferred', why = 'Hinaree 25: the reminder at status 2'},
            {t = 'chat', re = 'ulmia journeys to the port every day', conf = 'inferred', why = 'Hinaree 25 (say #9675)'},
         }},
        {id = 'u3', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 3, fp = 'zone into port san d oria'},
         done = {
            {t = 'word', nib = 4, min = 3, max = 3, why = 'Ulmia status 3: Port San d\'Oria zone-in cutscene 4 (:531-542)'},
            {t = 'zonein', zone = 232, event = 4, why = 'Port San d\'Oria zone-in cutscene 4 (status 2 only)'},
         }},
        {id = 'u4', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 4, fp = 'speak with chasalvige l 6 in'},
         done = {
            {t = 'word', nib = 4, min = 4, max = 5, why = 'Ulmia status 4: Chasalvige 762 (:562-565)'},
            {t = 'event', zone = 231, event = 762, why = 'Chasalvige 762 (status 3 only)'},
         }},
        {id = 'u5', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 5, fp = 'travel to windurst waters j 8'},
         done = {
            {t = 'word', nib = 4, min = 6, max = 6, why = 'Ulmia status 6: Kerutoto 876 (:585-588)'},
            {t = 'event', zone = 238, event = 876, why = 'Kerutoto 876 (status 4 only)'},
            {t = 'event', zone = 238, event = 882, conf = 'inferred', why = 'Kerutoto 882: the reminder at status 6'},
            {t = 'chat', re = 'looking for a girl with crikey', conf = 'inferred', why = 'Kerutoto 882 (say #10609)'},
         }},
        {id = 'u7', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 7, fp = 'go to windurst walls e 5'},
         done = {
            {t = 'word', nib = 4, min = 7, max = 7, why = 'Ulmia status 7: Yoran-Oran 473 (:608-611)'},
            {t = 'event', zone = 239, event = 473, why = 'Yoran-Oran 473 (status 6 only)'},
            {t = 'event', zone = 239, event = 479, conf = 'inferred', why = 'Yoran-Oran 479: the reminder at status 7'},
            {t = 'chat', re = 'using my house as a stage', conf = 'inferred', why = 'Yoran-Oran 479 (say #9549)'},
         }},
        {id = 'u8', group = 'ulmia', kind = 'note', with = 'u9', at = {tab = 'Where Messengers Gather', n = 8, fp = 'head to attohwa chasm h 6'}},
        {id = 'u9', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 9, fp = 'after your party is geared up'},
         done = {
            {t = 'word', nib = 4, min = 8, max = 8, why = 'Ulmia status 8: Head Wind won (:616-627)'},
         }},
        {id = 'u10', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 10, fp = 'head to j 9 of uleguerand'},
         done = {
            {t = 'word', nib = 4, min = 9, max = 13, why = 'Ulmia status 9: Flames for the Dead won (:631-642); the fight is the indented bullets under this one'},
         }},
        {id = 'u15', group = 'ulmia', at = {tab = 'Where Messengers Gather', n = 15, fp = 'after you defeat the snoll tzar'},
         done = {
            {t = 'word', nib = 4, min = 14, max = 14, why = 'Ulmia status 14: Cid 855 (:659-661)'},
            {t = 'event', zone = 237, event = 855, why = 'Cid 855 (status 9 only)'},
         }},
        {id = 'm2', implies = {'l13', 't20', 'u15'}, at = {n = 2, fp = 'once you have finished all three'},
         done = {
            {t = 'mission', line = 'cop', eq = 530, completed = true, why = 'mission log: Three Paths completed'},
            {t = 'mission', line = 'cop', min = 578, why = 'mission log: past Three Paths (For Whom the Verse Is Sung is 578)'},
            {t = 'event', zone = 237, event = 853, p = {[0] = 6}, why = 'Cid 853 with Tenzen and Ulmia done (P0 = 2 + 4): the last path closes and mission:complete runs'},
            {t = 'event', zone = 237, event = 854, p = {[0] = 5}, why = 'Cid 854 with Louverance and Ulmia done (P0 = 1 + 4): the last path closes'},
            {t = 'event', zone = 237, event = 855, p = {[0] = 3}, why = 'Cid 855 with Louverance and Tenzen done (P0 = 1 + 2): the last path closes'},
         }},
    },
}
