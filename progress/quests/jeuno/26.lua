-- Step progress for Deal with Tenshodo (Jeuno quest 26). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Deal_with_Tenshodo.lua (Garnev, Lower Jeuno: 167 plays when A Clock Most
-- Delicate is accepted and Norg fame is 2, has no choice and begins the quest on its finish; 168 is the refusal for low
-- fame ("come back once you've made a name") and proves nothing; 166 plays only for an exact Gold Orcmask trade and runs
-- quest:complete, whose reward is fame, a key item and a title, nothing to refuse); client event script S4
-- 245_Garnev_010F500B.txt (167 say #7683, 166 say #7686); item id from res/items.lua (554 Gold Orcmask) and key item from
-- res/key_items.lua (19 clock tower oil). Not repeatable.
-- The Gold Orcmask going (item 554) is left out: Proof of Valor (WotG mission 21) takes it as a petition signature too.
return {
    title = 'Deal with Tenshodo',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to garnev once you have'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Garnev 167)'},
            {t = 'event', zone = 245, event = 167, why = 'Garnev 167: the offer, no choice (168 is the low fame refusal)'},
            {t = 'chat', re = 'Right now, we.re looking for', why = 'Garnev 167 (say #7685)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him a gold orcmask to'},
         done = {
            {t = 'event', zone = 245, event = 166, why = 'Garnev 166: the Gold Orcmask accepted'},
            {t = 'chat', re = 'Well, look what we have here%.%.%. Alrighty, here you go, pal!', why = 'Garnev 166 (say #7686)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 19, gained = true, conf = 'inferred', why = 'clock tower oil obtained (reward)'},
         }},
    },
}
