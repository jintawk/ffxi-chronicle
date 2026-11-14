-- Step progress for A Flash in the Pan (Bastok quest 14). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/A_Flash_in_the_Pan.lua (Aquillina 217 is her request and begins the quest;
-- 218 is the "no more for now" cooldown line; trading four Flint Stones is event 219, which runs quest:complete and pays 100
-- gil, and works whether or not she was ever spoken to); client event script S4 235_Aquillina_010EB008.txt (217 say #7532,
-- 219 say #7533, 218 say #7534). The draft also listed 217, its line and the accepted bit on the trade step: those prove the
-- talk, not the trade. The quest can be repeated after a shared 15 minute cooldown, but a repeat needs no new accept (the trade
-- alone), so there is no observation that opens a second run and no `repeatable` entry (the page meta says No as well).
return {
    title = 'A Flash in the Pan',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to aquillina in bastok markets'},
         done = {
            {t = 'event', zone = 235, event = 217, why = 'Aquillina 217'},
            {t = 'chat', re = "I can't cook without fire, but I don't have time to go shopping!", why = 'Aquillina 217 (say #7532)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade flint stone x4 to aquillina'}, count = {item = 768, need = 4},
         done = {
            {t = 'event', zone = 235, event = 219, why = 'Aquillina 219: the Flint Stone trade'},
            {t = 'chat', re = "Now, stand back! It's cooking time!", why = 'Aquillina 219 (say #7533)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'tip if you re looking to'}},
    },
}
