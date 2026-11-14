-- Step progress for Axe the Competition (Jeuno quest 59). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Axe_the_Competition.lua (Brutus, Upper Jeuno 244: 12 is the offer and only
-- option 1 begins the quest and gives the Pick of Trials and the Weapon training guide, so it is only a reach; 13 plays only on
-- the finished Pick of Trials trade (300 points) and gives the Map to the Annals of Truth, 14 is the unfinished-weapon refusal
-- and proves nothing; 15 is his talk while accepted with no map (it also offers to quit the quest); 16 plays only with the map
-- held and no Annals of Truth; 17 plays only with the Annals of Truth held, runs quest:complete and has no item reward to refuse;
-- the ??? qm9 in the Temple of Uggalepih gives the Annals of Truth after Yallery Brown falls, with no event id); client event
-- script S4 244_Brutus_010F400C.txt (12, 13, 17 are bare cutscenes; 15 say #8178, 16 say #8193); key item ids from
-- res/key_items.lua (343 weapon training guide, 344 map to the annals of truth, 345 annals of truth) and item 17933 from
-- res/items.lua (pick of trials). The three key items are the same for every weapon skill trial quest and observations are not
-- scoped to a quest, so key item signals count only once the quest's own log bit was seen set (after = 's2'); Brutus's own
-- events are specific to this quest and need no guard. The latent bullets are indented, so they are not steps. Not repeatable.
return {
    title = 'Axe the Competition',
    completes = 's14',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with brutus will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Brutus 12, option 1)'},
            {t = 'item', id = 17933, gained = true, conf = 'inferred', why = 'Pick of Trials gained (items can come from elsewhere)'},
            {t = 'event', zone = 244, event = 15, conf = 'inferred', why = 'Brutus 15: his talk, only while accepted'},
            {t = 'chat', re = "When you feel the axe has sliced her last slice, show her to me", conf = 'inferred', why = 'Brutus 15 (say #8178)'},
         },
         reach = {{t = 'event', zone = 244, event = 12, why = 'Brutus 12 offered (its finish needs option 1)'}}},
        {id = 's6', at = {n = 6, fp = 'trade the pick of trials back'},
         done = {
            {t = 'event', zone = 244, event = 13, why = 'Brutus 13: the finished Pick of Trials accepted'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
            {t = 'event', zone = 244, event = 16, conf = 'inferred', why = 'Brutus 16: plays only with the map held and no Annals of Truth'},
            {t = 'chat', re = 'Take that map to the annals of truth and head to the Temple of Uggalepih', conf = 'inferred', why = 'Brutus 16 (say #8193)'},
         }},
        {id = 's7', kind = 'note', with = 's13', at = {n = 7, fp = 'bring some form of sneak and'}},
        {id = 's8', kind = 'note', with = 's13', at = {n = 8, fp = 'if you enter the temple conventionally'}},
        {id = 's13', at = {n = 13, fp = 'this fight is against yallery brown'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's2', why = 'Annals of Truth obtained'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's14', at = {n = 14, fp = 'go back and speak with brutus'},
         done = {
            {t = 'event', zone = 244, event = 17, why = 'Brutus 17: only plays with the Annals of Truth held, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 345, gained = false, after = 's13', conf = 'inferred', why = 'Annals of Truth handed over'},
         }},
    },
}
