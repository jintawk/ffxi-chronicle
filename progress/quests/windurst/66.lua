-- Step progress for The Three Magi (Windurst quest 66). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Heavens_Tower/npcs/Chumimi.lua (260 is the offer, played only while the quest is
-- available, and its finish adds the quest whichever of the three magi is chosen; 261 is her talk while accepted; trading one
-- Glowstone is event 269, but its finish gives the Casting Wand through npcUtil.giveItem inside an `if` and does nothing else
-- when the bag is full, so 269 is a refusal-played event: `reach`, and the quest log's completed bit carries the last step).
-- Client event script S4 242_Chumimi_010F2053.txt (261 say #7886). The draft hung the completion on the telepoint bullet (n=2)
-- and made the last bullet a note; it is the other way round: the Telepoint trade for a Faded Crystal, the Faded Crystal trade at
-- the Xarcabard ??? (a plain qm1 trade with only chat messages) and the Chaos Elemental hunt leave no event or key item of their
-- own (the Faded Crystal and Glowstone are plain items, also sold), so bullets 2 to 5 are not mapped and stay plain bullets.
-- Repeatable only after a memory reset, which leaves nothing to observe, so no `repeatable` entry. The quest log is set at s1.
-- Item 17423 (Casting Wand) comes out of a Porter Moogle slip too: shared, gated after s1.
return {
    title = 'The Three Magi',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'begin the quest by speaking with'},
         done = {
            {t = 'event', zone = 242, event = 260, why = 'Chumimi 260: the offer, adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 242, event = 261, conf = 'inferred', why = 'Chumimi 261: her talk while accepted'},
            {t = 'chat', re = 'I had a feeling something like that was going to happen%.%.%.', conf = 'inferred', why = 'Chumimi 261 (say #7886)'},
         }},
        {id = 's6', at = {n = 6, fp = 'take the glowstone that drops from'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 17423, gained = true, after = 's1', conf = 'inferred', why = 'Casting Wand gained (reward) (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 242, event = 269, why = 'Chumimi 269: the Glowstone traded (also plays when the Casting Wand cannot be given)'}}},
    },
}
