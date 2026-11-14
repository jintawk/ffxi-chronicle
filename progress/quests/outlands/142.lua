-- Step progress for A Thief in Norg!? (Outlands quest 142). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/SAM_AF3_A_Thief_in_Norg.lua. Jaucribaix 158 is the offer (a yes/no menu, the
-- finish begins the quest on option 1) so it is a reach and the accept line is the proof; 157 plays before the quest (must-zone
-- wait). Prog runs 1 Sanosuke 304 (progressEvent) -> 2 Phoochuchu 301 (progressEvent) -> 3 the Bastok Mines door _6i8 event 186
-- (progressEvent, only at Prog 3; its NPC is the door the bullet names) -> 4 the Waughroon Shrine zone-in event 2 (only at Prog
-- 4, its finish sets Prog 5) -> 5 Jaucribaix 166 (gives the Banishing Charm; it plays on a full bag too, so only inferred) ->
-- the Burning Circle trade (no event) and the win give the Charred helm (454) with Prog 7 -> Jaucribaix 160 (Prog 7, the gold
-- thread request: bullet 9, a real step here) -> 162 (the gold thread trade, takes the helm) -> 164 after the zone wait runs
-- quest:complete (163 is the wait line). Client event scripts S4 252_Jaucribaix_010FC010.txt (158 accept branch say #10710,
-- 159 say #10720, 160 say #10726, 161 say #10730, 162 say #10731, 163 say #10732, 164 say #10733, 166 say #10721, 167 say
-- #10723, 168 say #10724), 246_Sanosuke_010F607A.txt (304 say #7762, 305 say #7768), 249_Phoochuchu_010F906D.txt (301 say #7514,
-- 303 say #7518, 302 say #7520). Lines that open with the player's name are matched on the words after it. The quest log is set
-- at s1, so it is not silent.
-- Draft corrections: Jaucribaix 157/160/161 and the Waughroon zone-in were on the wrong bullets (157 is pre-quest; 160 is bullet 9
-- and 161 its reminder; the zone-in is bullet 5); the door event 186 (zone 234) now proves bullet 4. Not repeatable.
return {
    title = 'A Thief in Norg!?',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with jaucribaix in norg k'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jaucribaix 158, yes)'},
            {t = 'chat', re = 'Your gratitude is appreciated by all of us here in Norg%.', why = 'Jaucribaix 158, accept branch (say #10710)'},
            {t = 'event', zone = 252, event = 159, conf = 'inferred', why = 'Jaucribaix 159: his talk, only while accepted before the charm'},
            {t = 'chat', re = "Currently, Gilgamesh has men combing Vana'diel for clues on the whereabouts of the thieves%.", conf = 'inferred', why = 'Jaucribaix 159 (say #10720)'},
         },
         reach = {{t = 'event', zone = 252, event = 158, why = 'Jaucribaix 158 offered (its finish needs the yes option)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to sanosuke in port jeuno'},
         done = {
            {t = 'event', zone = 246, event = 304, why = 'Sanosuke 304: first talk, Prog 1'},
            {t = 'chat', re = 'I have been waiting for your arrival%.', why = 'Sanosuke 304 (say #7762)'},
            {t = 'event', zone = 246, event = 305, conf = 'inferred', why = 'Sanosuke 305: his talk, only after 304'},
            {t = 'chat', re = 'The type of helmet that was stolen is known in the Far East as a kabuto%.', conf = 'inferred', why = 'Sanosuke 305 (say #7768)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to phoochuchu in mhaura h'},
         done = {
            {t = 'event', zone = 249, event = 301, why = 'Phoochuchu 301: first talk, Prog 2'},
            {t = 'chat', re = 'Ha ha ha! I knew it! Just like Gilgamesh described%.', why = 'Phoochuchu 301 (say #7514)'},
            {t = 'event', zone = 249, event = 303, conf = 'inferred', why = 'Phoochuchu 303: his talk, only after 301'},
            {t = 'chat', re = "Wa%-wa%-wait! There's something else%.", conf = 'inferred', why = 'Phoochuchu 303 (say #7518)'},
            {t = 'event', zone = 249, event = 302, conf = 'inferred', why = 'Phoochuchu 302: his talk once the door is done'},
            {t = 'chat', re = 'I thought that this might have been the work of some large groupy%-woop, but when I heard that it was just one guy%.%.%.', conf = 'inferred', why = 'Phoochuchu 302 (say #7520)'},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the door on the lower'},
         done = {
            {t = 'event', zone = 234, event = 186, after = 's3', why = 'Bastok Mines door _6i8 event 186, only at Prog 3'},
         }},
        {id = 's5', at = {n = 5, fp = 'enter the waughroon shrine through the'},
         done = {
            {t = 'zonein', zone = 144, event = 2, after = 's4', why = 'Waughroon Shrine zone-in event 2, only at Prog 4'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to jaucribaix in norg to'},
         done = {
            {t = 'event', zone = 252, event = 166, after = 's5', conf = 'inferred', why = 'Jaucribaix 166: gives the charm (also plays on a full bag)'},
            {t = 'chat', re = 'The situation has grown graver than I had imagined%.', after = 's5', conf = 'inferred', why = 'Jaucribaix 166 (say #10721)'},
            {t = 'item', id = 1166, gained = true, after = 's5', conf = 'inferred', why = 'Banishing Charm gained (items can come from elsewhere)'},
            {t = 'event', zone = 252, event = 167, after = 's5', conf = 'inferred', why = 'Jaucribaix 167: his talk, only at Prog 6 with the charm held'},
            {t = 'chat', re = 'into the magic portal%.', after = 's5', conf = 'inferred', why = 'Jaucribaix 167 (say #10723)'},
            {t = 'event', zone = 252, event = 168, after = 's5', conf = 'inferred', why = 'Jaucribaix 168: his talk at Prog 6 without the charm'},
            {t = 'chat', re = 'You fool! How could you just dispose of such an important item%?', after = 's5', conf = 'inferred', why = 'Jaucribaix 168 (say #10724)'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'trade the banishing charm to the'}},
        {id = 's8', at = {n = 8, fp = 'after defeating the demons you will'},
         done = {
            {t = 'ki', id = 454, gained = true, why = 'charred helm obtained'},
            {t = 'ki_have', id = 454, have = true, why = 'charred helm held'},
            {t = 'chat', re = 'obtained key item: charred helm', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'speak to jaucribaix he will request'},
         done = {
            {t = 'event', zone = 252, event = 160, after = 's8', why = 'Jaucribaix 160: the helm seen, asks for the gold thread (Prog 7)'},
            {t = 'chat', re = 'Without your strength and perseverance, we would not have been able to silence that evil spirit%.', after = 's8', why = 'Jaucribaix 160 (say #10726)'},
            {t = 'event', zone = 252, event = 161, after = 's8', conf = 'inferred', why = 'Jaucribaix 161: his reminder, only after 160'},
            {t = 'chat', re = 'The helmet is in terrible condition%.', after = 's8', conf = 'inferred', why = 'Jaucribaix 161 (say #10730)'},
         }},
        {id = 's10', at = {n = 10, fp = 'trade a gold thread to jaucribaix'},
         done = {
            {t = 'event', zone = 252, event = 162, after = 's8', why = 'Jaucribaix 162: the gold thread accepted, takes the helm'},
            {t = 'chat', re = 'Yes, this is what I require to repair the damaged helmet%.', after = 's8', why = 'Jaucribaix 162 (say #10731)'},
            {t = 'ki', id = 454, gained = false, after = 's8', conf = 'inferred', why = 'charred helm handed over'},
         }},
        {id = 's11', at = {n = 11, fp = 'zone out of norg then return'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 252, event = 164, why = 'Jaucribaix 164: runs quest:complete'},
            {t = 'chat', re = 'I have just finished the repairs to the', why = 'Jaucribaix 164 (say #10733)'},
            {t = 'event', zone = 252, event = 163, after = 's8', conf = 'inferred', why = 'Jaucribaix 163: the wait line, only after 162'},
            {t = 'chat', re = 'Why must you rush me in my work!%?', after = 's8', conf = 'inferred', why = 'Jaucribaix 163 (say #10732)'},
         }},
    },
}
