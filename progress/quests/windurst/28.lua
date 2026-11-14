-- Step progress for Teacher's Pet (Windurst quest 28). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Teachers_Pet.lua (Moreno-Toeno 437 is his first talk and 438 the offer, which
-- plays on a decline too, so both only reach; 439 is his talk whenever the quest is not available, accepted or completed, so it
-- also only reaches; 440 is the trade of a Bird Feather and a Two-Leaf Mandragora Bud and runs quest:complete with fame only,
-- no item reward, so it cannot fail). The page has one step bundling the offer and the trade, so the accepted quest log only
-- marks it reached and the trade finishes it. The quest is repeatable by a completed-state trade alone (440 plays again), so
-- there is no `repeatable` entry. The item bullet (n=2) is a note on the trade. No client event script covers these events,
-- so there are no dialogue lines.
-- Shared-signal audit: Moreno-Toeno 438 is also his line after a failed A Testing Time mission (missions/windurst/2_2): dropped.
return {
    title = "Teacher's Pet",
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to moreno toeno in the'},
         done = {
            {t = 'event', zone = 238, event = 440, why = 'Moreno-Toeno 440: the Bird Feather and Two-Leaf Mandragora Bud accepted, completes'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 238, event = 437, why = 'Moreno-Toeno 437: first talk'},
            {t = 'event', zone = 238, event = 439, why = 'Moreno-Toeno 439: his talk once the quest is not available'},
            {t = 'quest', current = true, why = 'quest log: accepted (Moreno-Toeno 438, option 0)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'a bird feather can be purchased'}},
    },
}
