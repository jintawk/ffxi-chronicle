-- Step progress for Collect Tarut Cards (Jeuno quest 10). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Collect_Tarut_Cards.lua (Chululu 28 is the offer, a menu whose option 0 gives
-- five cards and begins the quest; the "Excellent!" line plays on option 0 even when the bag is full and nothing is given, so
-- no line is used as proof, the log's current bit is; while accepted her talk is 27, or 10112 once a day, and 10112 also
-- belongs to All in the Cards, so it is not used; trading the four different cards plays 200, which runs quest:complete with
-- a title only, so there is no refusal). Client event script S4 245_Chululu_010F5023.txt (27 say #7568). The cards trade
-- between players, so that bullet stays plain; the notes are the card hand-out (given with the offer) and the daily card and
-- the follow-up quest (on the final trade). Not repeatable.
return {
    title = 'Collect Tarut Cards',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to chululu in lower jeuno'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Chululu 28, option 0)'},
            {t = 'event', zone = 245, event = 27, conf = 'inferred', why = 'Chululu 27: her reminder, only while accepted'},
            {t = 'chat', re = 'Bring me the four Tarut cards', conf = 'inferred', why = 'Chululu 27 (say #7568)'},
         },
         reach = {{t = 'event', zone = 245, event = 28, why = 'Chululu 28 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'you will randomly be given five'}},
        {id = 's4', at = {n = 4, fp = 'trade all four cards to chululu'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 200, why = 'Chululu 200: the four cards accepted, runs quest:complete'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'every real life day you can'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'note speak with chululu again to'}},
    },
}
