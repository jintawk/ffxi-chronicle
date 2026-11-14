-- Step progress for Hoist the Jelly, Roger (Windurst quest 51). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Maysoon.lua (10000 is the offer that adds the quest, played before
-- the page's first bullet and not on the page, so it proves no step here; trading exactly one Royal Jelly is event 10001,
-- which only plays while accepted and whose finish completes the quest and gives the Super Soup Pot key item with no refusal
-- path); client event script S4 238_Maysoon_010EE04B.txt (10001 say #6951); key item id from res/key_items.lua (57).
-- The jelly hunt is a note on the trade. The quest log is set before any bullet, so it is not silent.
-- Key item 57 (super soup pot) gained: dropped (it is also a reach of jeuno/16; event 10001, its line and the completed bit already prove the step).
return {
    title = 'Hoist the Jelly, Roger',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'obtain a royal jelly'}},
        {id = 's2', at = {n = 2, fp = 'trade the royal jelly to maysoon'},
         done = {
            {t = 'event', zone = 238, event = 10001, why = 'Maysoon 10001: the Royal Jelly accepted'},
            {t = 'chat', re = 'Oh, my! You actually managed to get your hands on', why = 'Maysoon 10001 (say #6951)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
