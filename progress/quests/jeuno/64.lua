-- Step progress for The Requiem (Jeuno quest 64). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Requiem.lua (Bki Tbujhja, Lower Jeuno 245: 145 and 148 are the long and short
-- offers with a menu and only option 1 begins the quest, so they are only a reach, but "Thank goodness! Listen" plays only on
-- "You bet"; 151 plays only on the exact Flask of Holy Water trade; 146, 147 and 149 are his talk while accepted; the fourth
-- Sarcophagus in The Eldieme Necropolis (195) plays 46 after the guardians fall, which prints the requiem line and gives key item
-- 225 on option 0, so 46 is only a reach; 150 plays only with the Star ring held, runs quest:complete and cannot give the Choral
-- Slippers on a full bag while 150 still plays, so it is only a reach and the quest log's completed bit carries the last step);
-- client event scripts S4 245_Bki_Tbujhja_010F501E.txt (145 say #8053, sub_0114 accept #8056, 151 #8060, 147 #8066, 150 #8067) and
-- 195_Sarcophagus_010C31CE.txt (46 print #7457); key item 225 (star ring, STAR_RING1, kept until The Circle of Time, which also names it) from
-- res/key_items.lua; it counts only after s1 (own log bit) and not as a held key item, so the two quests cannot tick each other. The trade at the sarcophagus pops the guardians with no event or line, so that bullet stays plain.
-- Not repeatable (page meta).
return {
    title = 'The Requiem',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to bki tbujhja to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Bki Tbujhja 145 or 148, option 1)'},
            {t = 'chat', re = "Thank goodness! Listen, it's such an onerous task", why = 'Bki Tbujhja 145/148: "You bet" (say #8056)'},
            {t = 'event', zone = 245, event = 146, conf = 'inferred', why = 'Bki Tbujhja 146: his talk, only while accepted before the trade'},
         },
         reach = {{t = 'event', zone = 245, event = 145, why = 'Bki Tbujhja 145 offered (its finish needs option 1)'},
                  {t = 'event', zone = 245, event = 148, why = 'Bki Tbujhja 148 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade bki tbujhja the holy water'},
         done = {
            {t = 'event', zone = 245, event = 151, why = 'Bki Tbujhja 151: the Flask of Holy Water accepted'},
            {t = 'chat', re = 'Good, this will do nicely%. Now for the task!', why = 'Bki Tbujhja 151 (say #8060)'},
            {t = 'event', zone = 245, event = 147, conf = 'inferred', why = 'Bki Tbujhja 147: his talk after the trade'},
            {t = 'event', zone = 245, event = 149, conf = 'inferred', why = 'Bki Tbujhja 149: his talk after the trade'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'travel to the eldieme necropolis via'}},
        {id = 's5', at = {n = 5, fp = 'defeat all three nms that spawn'},
         done = {
            {t = 'ki', id = 225, gained = true, after = 's1', why = 'star ring obtained (kept until The Circle of Time, so only counted once this quest was seen accepted)'},
            {t = 'chat', re = 'obtained key item: star ring', after = 's1', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 195, event = 46, why = 'Sarcophagus 46 offered (the Star ring follows on option 0)'},
                  {t = 'chat', re = 'You play the requiem for the soul that sleeps in this sarcophagus%.', why = 'Sarcophagus 46 (print #7457)'}}},
        {id = 's6', at = {n = 6, fp = 'return to bki tbujhja and receive'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 245, event = 150, why = 'Bki Tbujhja 150 (also plays when the Choral Slippers cannot be given)'},
                  {t = 'chat', re = "Good work, ! Yeah, sorry I didn't tell you about the monsters%.", why = 'Bki Tbujhja 150 (say #8067)'}}},
    },
}
