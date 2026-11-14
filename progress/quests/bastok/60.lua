-- Step progress for Ayame and Kaede (Bastok quest 60). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Ayame_and_Kaede.lua (Kaede 240 begins the quest at its finish; Kagetora 241 at
-- Prog 0; Ensetsu 242 at Prog 1 or 2; the Korroloka Tunnel ??? plays HAIR_STANDS_ON_END when the leeches spawn and gives the
-- coral 257 once they are dead and gone; Ensetsu 245 at Prog 3 is the return with the coral, 243 the echo talk at Prog 4; Ryoma
-- 95 at Prog 4 gives the Sealed dagger 258 and takes the coral; Ensetsu 246 at Prog 5 completes and takes the dagger); client
-- event scripts S4 236_Kaede_010EC026.txt, 236_Kagetora_010EC007.txt, 236_Ensetsu_010EC025.txt (243 say #8439; 242, 245 and 246
-- are bare) and 252_Ryoma_010FC03A.txt (95 say #10390); zones/Korroloka_Tunnel/IDs.lua. The page says the log entry appears only
-- after the Ensetsu cutscene (bullet 3) while LandSandBoat begins the quest at Kaede 240; the log bit is kept on the first step,
-- where it can only under-mark. The draft put Ensetsu 245 on bullet 3; it is the return of bullet 7. Kaede 248 and Kagetora 244
-- are not on a bullet. The quest is not repeatable.
return {
    title = 'Ayame and Kaede',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to kaede in port bastok'},
         done = {
            {t = 'event', zone = 236, event = 240, why = 'Kaede 240: the quest offered and begun at its finish'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to kagetora at f 6'},
         done = {
            {t = 'event', zone = 236, event = 241, why = 'Kagetora 241: plays at Prog 0'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to kaede s house and'},
         done = {
            {t = 'event', zone = 236, event = 242, why = 'Ensetsu 242: plays at Prog 1 or 2, after Kagetora'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'travel to k 8 within korroloka'}},
        {id = 's5', at = {n = 5, fp = 'click on the to spawn 3'},
         done = {
            {t = 'chat', re = 'the hair on the back of your neck begins to stand on end!', why = 'Korroloka Tunnel HAIR_STANDS_ON_END: the leeches spawned'},
         }},
        {id = 's6', at = {n = 6, fp = 'once the leeches are defeated and'},
         done = {
            {t = 'ki', id = 257, gained = true, why = 'strangely shaped coral obtained'},
            {t = 'ki_have', id = 257, have = true, why = 'strangely shaped coral held'},
            {t = 'chat', re = 'obtained key item: strangely shaped coral', why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to ensetsu in port bastok'},
         done = {
            {t = 'event', zone = 236, event = 245, why = 'Ensetsu 245: plays at Prog 3, with the coral'},
            {t = 'event', zone = 236, event = 243, conf = 'inferred', why = 'Ensetsu 243: the echo talk at Prog 4, only after 245'},
            {t = 'chat', re = 'I appreciate all that you have done for me, and apologize for having you travel to Norg in my place%.', conf = 'inferred', why = 'Ensetsu 243 (say #8439)'},
         }},
        {id = 's8', at = {n = 8, fp = 'travel to norg and speak with'},
         done = {
            {t = 'event', zone = 252, event = 95, why = 'Ryoma 95: plays at Prog 4 and gives the dagger'},
            {t = 'chat', re = 'What%? Ensetsu asked you to bring me this', why = 'Ryoma 95 (say #10390)'},
            {t = 'ki', id = 258, gained = true, why = 'sealed dagger obtained'},
            {t = 'ki_have', id = 258, have = true, why = 'sealed dagger held'},
            {t = 'chat', re = 'obtained key item: sealed dagger', why = 'chat: key item obtained'},
            {t = 'ki', id = 257, gained = false, conf = 'inferred', why = 'strangely shaped coral handed over'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to ensetsu to complete the'},
         done = {
            {t = 'event', zone = 236, event = 246, why = 'Ensetsu 246: plays at Prog 5 with the dagger'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 258, gained = false, conf = 'inferred', why = 'sealed dagger handed over'},
         }},
    },
}
