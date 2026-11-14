-- Step progress for Like Shining Leggings (Outlands quest 139). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Like_Shining_Leggings.lua (Heizo 127 is the offer and its finish begins the quest with
-- no refusal branch; while accepted his talk, or a trade that is not only Rusty Leggings, plays 128; a trade of only Rusty Leggings below
-- ten in total is taken and plays 128 too; the trade that makes ten plays 129, whose finish runs quest:complete and only then takes the
-- leggings, and the reward includes a Dokumori: Ichi scroll). Client event script S4 252_Heizo_010FC057.txt (127 say #10583, 128 say
-- #10587, 129 say #10588). Item 14117 (Rusty Leggings) from res/items.lua. Event 129 also plays when the bag is full (nothing is
-- given and the quest stays open), so it is reach, and the log's completed bit proves s2. Not repeatable.
return {
    title = 'Like Shining Leggings',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to heizo in norg at'},
         done = {
            {t = 'event', zone = 252, event = 127, why = 'Heizo 127: the offer, the quest begins in its finish'},
            {t = 'chat', re = 'I am Heizo%. Like Master Heiji, I teach my young pupils the ways of the ninja%.', why = 'Heizo 127 (say #10583)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 252, event = 128, conf = 'inferred', why = 'Heizo 128: his talk or a partial trade, only while accepted'},
            {t = 'chat', re = 'You have brought me .- so far%.', conf = 'inferred', why = 'Heizo 128 (say #10587)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him 10 pairs of rusty'}, count = {item = 14117, need = 10},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Heizo 129)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 129, after = 's1', why = 'Heizo 129: the tenth legging (also plays when the bag is full: nothing is given)'},
            {t = 'chat', re = 'Here is the reward I promised you%.', after = 's1', why = 'Heizo 129 (say #10588)'},
         }},
    },
}
