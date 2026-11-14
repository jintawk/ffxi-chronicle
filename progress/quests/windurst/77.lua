-- Step progress for Wild Card (Windurst quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB6_Wild_Card.lua (Honoi-Gomoi 780 begins the quest with no option test;
-- Kohlo-Lakolo 545 sets Prog 1 whenever it is 0; at the House of the Hero door 386 meets Joker or 388 Apururu, by nation rank, and
-- both only set the stage; the Treasure Coffer in Toraimarai Canal gives the Joker card key item; 387 or 389 at the door and 600
-- at Apururu in Windurst Woods each take the card for 8,000 gil; Honoi-Gomoi 782 completes the quest with only fame and a title,
-- so it has no refusal path). Bullets 6 and 7 are the two branches (only one is played), so they are `branch` steps. Client
-- event scripts are not decoded for these NPCs, so the events rest on LandSandBoat; key item 264 from res/key_items.lua. The
-- quest log is set at s2, so it is not silent.
return {
    title = 'Wild Card (Quest)',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after finishing the previous quest'}},
        {id = 's2', at = {n = 2, fp = 'speak to honoi gomoi to begin'},
         done = {
            {t = 'event', zone = 238, event = 780, why = 'Honoi-Gomoi 780: the quest begins'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to kohlo lakolo port windurst'},
         done = {
            {t = 'event', zone = 240, event = 545, why = 'Kohlo-Lakolo 545'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to windurst walls g 3'},
         done = {
            {t = 'event', zone = 239, event = 386, why = 'House of the Hero door 386: meet Joker'},
            {t = 'event', zone = 239, event = 388, why = 'House of the Hero door 388: meet Apururu'},
         }},
        {id = 's5', at = {n = 5, fp = 'head to toraimarai canal and open'},
         done = {
            {t = 'ki', id = 264, gained = true, why = 'joker card obtained'},
            {t = 'ki_have', id = 264, have = true, why = 'joker card held'},
            {t = 'chat', re = 'obtained key item: joker card', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'branch', at = {n = 6, fp = 'if you spoke to joker during'},
         done = {
            {t = 'event', zone = 239, event = 387, why = 'House of the Hero door 387: the Joker card handed over'},
            {t = 'event', zone = 239, event = 389, why = 'House of the Hero door 389: the Joker card handed over'},
         }},
        {id = 's7', kind = 'branch', at = {n = 7, fp = 'if you spoke to apururu return'},
         done = {
            {t = 'event', zone = 241, event = 600, why = 'Apururu 600: the Joker card handed over'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to honoi gomoi to complete'},
         done = {
            {t = 'event', zone = 238, event = 782, why = 'Honoi-Gomoi 782: the quest completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
