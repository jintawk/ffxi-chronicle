-- Step progress for Crest of Davoi (Jeuno quest 0). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Crest_of_Davoi.lua (Baudin 174 is the offer and only option 1 begins the
-- quest, so it is a reach; while accepted his talk is 175 and trading the Slice of Coeurl Meat plays 171, which runs
-- quest:complete; the reward is the Crest of Davoi key item, so there is no item to refuse and 171 is a proof; 122 plays
-- only after completion and only until Save My Sister is done). Client event script S4 244_Baudin_010F4013.txt (175 say
-- #7329). Key item id from res/key_items.lua (21 crest of Davoi, the reward). Not repeatable.
return {
    title = 'Crest of Davoi',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to baudin to begin this'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Baudin 174, option 1)'},
            {t = 'event', zone = 244, event = 175, conf = 'inferred', why = 'Baudin 175: his talk, only while accepted'},
            {t = 'chat', re = "I've heard there are coeurls on the Sauromugue Champaign%.", conf = 'inferred', why = 'Baudin 175 (say #7329)'},
         },
         reach = {{t = 'event', zone = 244, event = 174, why = 'Baudin 174 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade him a slice of coeurl'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 244, event = 171, why = 'Baudin 171: the Slice of Coeurl Meat accepted, runs quest:complete'},
            {t = 'ki', id = 21, gained = true, conf = 'inferred', why = 'Crest of Davoi obtained (reward)'},
         }},
    },
}
