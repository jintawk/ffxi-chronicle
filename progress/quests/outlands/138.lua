-- Step progress for Like a Shining Subligar (Outlands quest 138). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Like_Shining_Subligar.lua (Heiji 123 is the offer and its finish begins the quest with
-- no refusal branch; while accepted his talk, or a trade that is not only Rusty Subligar, plays 124; a trade of only Rusty Subligar below
-- ten in total is taken and plays 124 too; the trade that makes ten plays 125, whose finish runs quest:complete and only then takes the
-- subligar, and the reward includes a Kurayami: Ichi scroll). Client event script S4 252_Heiji_010FC056.txt (123 say #10577, 124 say
-- #10581, 125 say #10582). Item 14242 (Rusty Subligar) from res/items.lua. Event 125 also plays when the bag is full (nothing is
-- given and the quest stays open), so it is reach, and the log's completed bit proves s2. Not repeatable.
return {
    title = 'Like a Shining Subligar',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to heiji in norg at'},
         done = {
            {t = 'event', zone = 252, event = 123, why = 'Heiji 123: the offer, the quest begins in its finish'},
            {t = 'chat', re = 'I am Heiji%. I teach my young pupils the ways of the ninja%.', why = 'Heiji 123 (say #10577)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 252, event = 124, conf = 'inferred', why = 'Heiji 124: his talk or a partial trade, only while accepted'},
            {t = 'chat', re = 'You have brought me .- so far%.', conf = 'inferred', why = 'Heiji 124 (say #10581)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him 10 rusty subligaria to'}, count = {item = 14242, need = 10},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Heiji 125)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 125, after = 's1', why = 'Heiji 125: the tenth subligar (also plays when the bag is full: nothing is given)'},
            {t = 'chat', re = 'Here is the reward I promised you%.', after = 's1', why = 'Heiji 125 (say #10582)'},
         }},
    },
}
