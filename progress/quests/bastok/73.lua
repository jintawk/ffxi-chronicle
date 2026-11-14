-- Step progress for Faded Promises (Bastok quest 73). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Faded_Promises.lua (Romualdo 802 begins the quest with no choice; Ayame 803 sets
-- Prog 1 only when its finish has option 0, so it also plays on a cancel and proves nothing; the Palborough treasure chest
-- gives the Diary of Mukunda at Prog 1; Kagetora 296 needs the Diary and sets Prog 2; Ayame 804 needs Prog 2; Alois 805 needs
-- Prog 3 and completes the quest, taking the Diary, but it also plays when the Fukuro reward cannot be given (full bag), so it is
-- only a reach and the completed bit carries the last step); client event scripts S4 236_Kagetora_010EC007.txt, 237_Alois_010ED01D.txt,
-- 237_Ayame_010ED02F.txt, 237_Romualdo_010ED036.txt; key item 493 from res/key_items.lua. The first Ayame bullet (n=2) has no
-- strong signal and stays a plain bullet (the Diary, a later step, infers it).
return {
    title = 'Faded Promises',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'change your main job to ninja'},
         done = {
            {t = 'event', zone = 237, event = 802, why = 'Romualdo 802: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to palborough mines and open'},
         done = {
            {t = 'ki', id = 493, gained = true, why = 'Diary of Mukunda obtained'},
            {t = 'ki_have', id = 493, have = true, why = 'Diary of Mukunda held'},
            {t = 'chat', re = 'obtained key item: diary of mukunda', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to bastok to speak with'},
         done = {
            {t = 'event', zone = 236, event = 296, why = 'Kagetora 296: only plays while the Diary is held'},
         }},
        {id = 's5', at = {n = 5, fp = 'after that speak with ayame again'},
         done = {
            {t = 'event', zone = 237, event = 804, why = 'Ayame 804: only plays at Prog 2, after Kagetora'},
         }},
        {id = 's6', at = {n = 6, fp = 'finally speak with alois in the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 493, gained = false, conf = 'inferred', why = 'Diary of Mukunda handed over'},
         },
         reach = {{t = 'event', zone = 237, event = 805, why = 'Alois 805: plays at Prog 3 even if the Fukuro cannot be given'}}},
    },
}
