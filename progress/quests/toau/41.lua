-- Step progress for Breaking the Bonds of Fate (Aht Urhgan quest 41, the Corsair level cap 75 flag). Data only; see
-- progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/COR_LB_Breaking_the_Bonds_of_Fate.lua (the Arrapago Reef ??? qm6 plays 234,
-- the offer, and option 0 begins the quest; while accepted a trade of the Corsair's Testimony plays 235, whose finish with option 0
-- teleports to Talacca Cove; the battlefield win runs quest:complete there, so the completed bit proves the last bullet).
-- 234 is only a reach (option 0 is needed), 235 plays only while accepted. The "Rhapsody in Umber" key item is not used: no
-- LandSandBoat script gives it here and it can be owned from elsewhere. No client event script or text exists for these events,
-- and the zone-in is not an event of its own, so bullets 1 and 2 (the drop, the prerequisite) and bullet 4 (the trade, which
-- ends in the teleport) and 6 (the fight's end) are notes on the step they lead into. Not repeatable.
return {
    title = 'Breaking the Bonds of Fate',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'obtain a corsair s testimony from'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you end up in the correct'}},
        {id = 's3', at = {n = 3, fp = 'head to h 10 arrapago reef'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 54, event = 235, why = '??? 235: the testimony trade, only while accepted'},
         },
         reach = {{t = 'event', zone = 54, event = 234, why = '??? 234 offered (its finish needs option 0)'}}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'upon trading the testimony to the'}},
        {id = 's5', at = {n = 5, fp = 'trade the corsair s testimony to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the battlefield win)'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'the fight will end when the'}},
    },
}
