-- Step progress for Fly High (Other Areas quest 71). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Tavnazian_Safehold/npcs/Ferchinne.lua (there is no quest script: 241 begins the quest, 242 is
-- his reminder, two Hippogryph Tailfeathers traded while accepted play 243 and complete it with a Mistmelt; once completed the same
-- trade plays 245 and pays another Mistmelt, and a plain talk plays 244); client event script S4 026_Ferchinne_0101A048.txt (241
-- say #10811, 242 say #10815, 243 say #10819, 244 say #10824, 245 say #10825). The draft completed the quest at 245, which is the
-- repeat trade after completion, and read the Mistmelt (an item that can come from elsewhere) as a marker. The quest log goes to
-- completed once, so the repeat trade is no restart: no `repeatable`. Bullets 3-4 are advice about Mistmelts.
return {
    title = 'Fly High',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ferchinne at g 9'},
         done = {
            {t = 'event', zone = 26, event = 241, why = 'Ferchinne 241: begins the quest'},
            {t = 'chat', re = 'My name is Ferchinne%. I was tired of seeing my people suffer, so I decided to journey forth from the confines of the safehold in order to earn the title of Dragon Slayer%.', why = 'Ferchinne 241 (say #10811)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 242, conf = 'inferred', why = 'Ferchinne 242: his reminder while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade ferchinne two hippogryph tailfeathers to'}, count = {item = 1690, need = 2},
         done = {
            {t = 'event', zone = 26, event = 243, after = 's1', why = 'Ferchinne 243: two Hippogryph Tailfeathers traded while accepted, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 26, event = 244, conf = 'inferred', why = 'Ferchinne 244: his talk once the quest is completed'},
            {t = 'chat', re = 'I am sorry to bother you again, but if you come across any more of the legendary tailfeathers, I beg of you to bring them to me%.', conf = 'inferred', why = 'Ferchinne 244 (say #10824)'},
            {t = 'event', zone = 26, event = 245, conf = 'inferred', why = 'Ferchinne 245: the repeat trade, only once completed'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'mistmelts are able to force ouryu'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'has no effect in the savage'}},
    },
}
