-- Step progress for The All-New C-3000 (Windurst quest 18). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Kopuro-Popuro.lua (655 is the offer: LandSandBoat adds the quest on
-- any finish, but the client's script has a Yes/No menu, so 655 is a reach and the "get cracking" line, played on the
-- accepting branch only, plus the quest log prove it; 316 is the post-quest text of another quest; 656 is the wrong-trade
-- refusal; 657 takes the Beetle Shell and Hecteyes Eye and runs completeQuest with gil and fame only; 659 is his talk once
-- completed). The draft made the trade bullet (n=3) a note and put the completion on the accept bullet: the trade is a real
-- step, proved by 657. The quest is repeatable by trade alone (657 also plays in the completed state, no new accept), so there
-- is no `repeatable` entry. Client event script S4 241_Kopuro_Popuro_010F1016.txt (655 Yes branch say #9733, 657 say #9736,
-- 659 say #9741). The quest log is set at s2, so it is not silent. The first bullet (zone after the previous quest) is a note.
return {
    title = 'The All-New C-3000',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you will have to zone after'}},
        {id = 's2', at = {n = 2, fp = 'speak to kopuro popuro to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'get cracking! Time is gil', why = 'Kopuro-Popuro 655, accepting branch only (say #9733)'},
         },
         reach = {{t = 'event', zone = 241, event = 655, why = 'Kopuro-Popuro 655 offered (the menu can decline)'}}},
        {id = 's3', at = {n = 3, fp = 'trade kopuro popuro a beetle shell'},
         done = {
            {t = 'event', zone = 241, event = 657, why = 'Kopuro-Popuro 657: the Beetle Shell and Hecteyes Eye accepted, completes'},
            {t = 'chat', re = 'Excellentaru work! Here', why = 'Kopuro-Popuro 657 (say #9736)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 241, event = 659, why = 'Kopuro-Popuro 659: his talk once completed'},
         }},
    },
}
