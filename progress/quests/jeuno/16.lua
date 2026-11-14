-- Step progress for Cook's Pride (Jeuno quest 16). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Lower_Jeuno/npcs/Naruru.lua (189 is the long offer and 188 the short one, option 0
-- begins the quest, so both are only reaches; 186 plays only while the quest is accepted and the Super soup pot is not held;
-- 187 plays whenever the pot is held and is the hand-in, but the Mythril Ring needs a free slot and the quest is completed
-- only then, so 187 is a reach and the log's completed bit proves bullet 2); scripts/zones/Windurst_Waters/npcs/Maysoon.lua
-- (the Super soup pot, key item 57, comes from Hoist the Jelly, Roger, which starts only while Cook's Pride is accepted);
-- client event script S4 245_Naruru_010F5015.txt (188 say #7335 on the Yes branch only, 186 say #7336, 187 say #7339); key
-- item id from res/key_items.lua. Bullet 1 holds the whole errand to the guild. The pot (key item 57) is also the reward of Hoist the
-- Jelly, Roger (windurst/51), so it proves nothing on its own: it counts only as a reach of bullet 2, once the accepted bit was seen
-- (after = 's1'); it is not a signal of bullet 1, and the held-at-login check (ki_have) is left out. Not repeatable.
return {
    title = "Cook's Pride",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to naruru to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Naruru 188 or 189, option 0)'},
            {t = 'chat', re = "Thank you so much! I bet you think soup pots are all the same", why = 'Naruru 188, Yes branch only (say #7335)'},
            {t = 'event', zone = 245, event = 186, why = 'Naruru 186: accepted and no pot yet'},
            {t = 'chat', re = "I think the Culinarians' Guild in Windurst should have", why = 'Naruru 186 (say #7336)'},
         },
         reach = {
            {t = 'event', zone = 245, event = 189, why = 'Naruru 189 offered (its finish needs option 0)'},
            {t = 'event', zone = 245, event = 188, why = 'Naruru 188 offered (its finish needs option 0)'},
         }},
        {id = 's2', at = {n = 2, fp = 'once you have the super soup'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (187 also plays when the Mythril Ring cannot be given)'},
         },
         reach = {
            {t = 'event', zone = 245, event = 187, why = 'Naruru 187: the pot handed over (the reward needs a free slot)'},
            {t = 'ki', id = 57, gained = true, after = 's1', why = 'Super soup pot obtained (Maysoon, Hoist the Jelly, Roger, begun only while this quest is accepted)'},
         }},
    },
}
