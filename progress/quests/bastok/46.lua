-- Step progress for Bite the Dust (Bastok quest 46). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Bite_the_Dust.lua (Yazan 191 begins the quest on finish, no refusal branch,
-- Bastok rank 2; 192 is his reminder while accepted; trading one Sand Bat Fang is event 193, which runs quest:complete; 194
-- plays once it is completed); client event script S4 236_Yazan_010EC069.txt (191 say #7682, 192 say #7685, 193 say #7686);
-- item id from res/items.lua (1015 Sand Bat Fang). The quest log is set at the accept. The quest is repeatable, but a repeat
-- needs no new accept (the trade alone, same event 193), so there is no `repeatable` entry. The Notes-section bullet is not a
-- step.
return {
    title = 'Bite the Dust',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to yazan h 6 who'},
         done = {
            {t = 'event', zone = 236, event = 191, why = 'Yazan 191: the quest begun'},
            {t = 'chat', re = 'I make a living trading goods with Selbina, you see%.', why = 'Yazan 191 (say #7682)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 236, event = 192, conf = 'inferred', why = 'Yazan 192: reminder, only while accepted'},
            {t = 'chat', re = "I can't believe a bunch of filthy flying rodents are the cause of all my troubles%.%.%.", conf = 'inferred', why = 'Yazan 192 (say #7685)'},
         }},
        {id = 's2', at = {n = 2, fp = 'once you have one trade it'}, count = {item = 1015, need = 1},
         done = {
            {t = 'event', zone = 236, event = 193, why = 'Yazan 193: the Sand Bat Fang accepted, completes the quest'},
            {t = 'chat', re = 'Aha! You did it! Good work!', why = 'Yazan 193 (say #7686)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
