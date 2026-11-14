-- Step progress for Got It All (Aht Urhgan quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Got_It_All.lua (a Prog state machine, every talk is told apart by the
-- Prog it needs: Tehf Kimasnahya 520 begins the quest and sets Prog 1 with no refusal; Tehf 521 plays at Prog 1-3; Ekhu
-- Pesshyadha 522 at Prog 1 sets 2, 536 plays at Prog 2; Zabahf 523 at Prog 2 or 3 sets 3; Ekhu 524 at Prog 3 gives the
-- Vial of luminous water (key item 772) and sets 4, 537 plays at Prog 4 and up; Tehf 525 at Prog 4 is a choice: only option 0
-- sets Prog 5 and deletes the vial, so 525 is a reach and the vial's loss proves the bullet; Tehf 534 and Zabahf 538 play at
-- Prog 5; the trigger area at the lower level plays 526 at Prog 5 and sets 6; Zabahf 540 plays at Prog 6; Tehf 527 at Prog 6
-- sets 7 and needs a zone; Tehf 539 and Zabahf 535 play at Prog 7; Tehf 528 at Prog 7 after zoning runs quest:complete, whose
-- reward is a Bibiki Seashell, so 528 replays on a full bag and is only a reach: the completed bit proves the last bullet).
-- Ekhu 532 and Zabahf 533 also play before the quest (533 is also the fallback talk), so neither is used. Client event
-- scripts S4 050_Tehf_Kimasnahya_0103212F.txt (521 say #5015, 534 say #5061, 539 say #5106), 050_Ekhu_Pesshyadha_0103212A.txt
-- (536 say #5022, 537 say #5028) and 050_Zabahf_0103212C.txt (523 say #5023, 538 say #5062, 540 say #5082, 535 say #5100);
-- 520, 522, 524, 525, 526, 527 and 528 have no text. Key item 772 from res/key_items.lua. Not repeatable.
return {
    title = 'Got It All',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to tehf kimasnahya in aht'},
         done = {
            {t = 'event', zone = 50, event = 520, why = 'Tehf Kimasnahya 520: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 521, why = 'Tehf Kimasnahya 521: his talk at Prog 1-3'},
            {t = 'chat', re = 'Ekhu Pesshyadha has the', why = 'Tehf Kimasnahya 521 (say #5015)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to ekhu pesshyadha in aht'},
         done = {
            {t = 'event', zone = 50, event = 522, why = 'Ekhu Pesshyadha 522: only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 50, event = 536, why = 'Ekhu Pesshyadha 536: only at Prog 2'},
            {t = 'chat', re = "I can't stop thinking about that handsome Elvaan", why = 'Ekhu Pesshyadha 536 (say #5022)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to zabahf in aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 523, why = 'Zabahf 523: only at Prog 2 or 3, sets Prog 3'},
            {t = 'chat', re = 'Wh%-why would I want to go back and speak to Ekhu%?', why = 'Zabahf 523 (say #5023)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to ekhu pesshyadha to receive'},
         done = {
            {t = 'ki', id = 772, gained = true, why = 'vial of luminous water obtained'},
            {t = 'ki_have', id = 772, have = true, why = 'vial of luminous water held'},
            {t = 'event', zone = 50, event = 524, why = 'Ekhu Pesshyadha 524: only at Prog 3, gives the vial'},
            {t = 'chat', re = 'obtained key item: vial of luminous water', why = 'chat: key item obtained'},
            {t = 'event', zone = 50, event = 537, why = 'Ekhu Pesshyadha 537: only at Prog 4 and up'},
            {t = 'chat', re = "To think I'd become more obsessed with Zabahf than Fernan", why = 'Ekhu Pesshyadha 537 (say #5028)'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to tehf kimasnahya'},
         done = {
            {t = 'ki', id = 772, gained = false, why = 'vial of luminous water handed over (only on option 0)'},
            {t = 'event', zone = 50, event = 534, why = 'Tehf Kimasnahya 534: only at Prog 5'},
            {t = 'chat', re = "I wonder if the old lady's having any luck with the potion", why = 'Tehf Kimasnahya 534 (say #5061)'},
            {t = 'event', zone = 50, event = 538, why = 'Zabahf 538: only at Prog 5'},
            {t = 'chat', re = "Fixing someone's materialism with a potion%?", why = 'Zabahf 538 (say #5062)'},
         },
         reach = {{t = 'event', zone = 50, event = 525, why = 'Tehf Kimasnahya 525 offered (its finish needs option 0)'}}},
        {id = 's6', at = {n = 6, fp = 'go to the lower level of'},
         done = {
            {t = 'event', zone = 50, event = 526, why = 'the lower level trigger area 526: only at Prog 5, sets Prog 6'},
            {t = 'event', zone = 50, event = 540, why = 'Zabahf 540: only at Prog 6'},
            {t = 'chat', re = 'It was just as I suspected%.', why = 'Zabahf 540 (say #5082)'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to tehf kimasnahya'},
         done = {
            {t = 'event', zone = 50, event = 527, why = 'Tehf Kimasnahya 527: only at Prog 6, sets Prog 7'},
            {t = 'event', zone = 50, event = 539, why = 'Tehf Kimasnahya 539: only at Prog 7, before zoning'},
            {t = 'chat', re = "I can't think of anything I want you to get for me", why = 'Tehf Kimasnahya 539 (say #5106)'},
            {t = 'event', zone = 50, event = 535, why = 'Zabahf 535: only at Prog 7'},
            {t = 'chat', re = 'I think I need a potion too', why = 'Zabahf 535 (say #5100)'},
         }},
        {id = 's8', at = {n = 8, fp = 'zone and then speak to tehf'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 528, why = 'Tehf Kimasnahya 528 (replays if the Bibiki Seashell cannot be given)'}}},
    },
}
