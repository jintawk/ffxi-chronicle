-- Step progress for Achieving True Power (Bastok quest 85). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/PUP_LB_Achieving_True_Power.lua (Shamarhaan 441 begins the quest at its finish;
-- 442 is the reminder while accepted; the testimony trade plays 443 and sends you to the Navukgo Execution Chamber; the win in
-- the battlefield runs quest:complete; 444 plays only once completed); client event script S4 235_Shamarhaan_010EB096.txt
-- (443 say #9717, 444 say #9721; 441 is bare). The draft gave the Rhapsody in Umber key item (2885) as proof of the trade and
-- put the completion on it; the page only says the key item helps if you hold it, the quest does not hand it out, so it is
-- dropped. Event 32001 is any win in that zone (other battlefields use it), so the completed bit carries the last bullet and
-- 443 only shows the fight is under way. The testimony farming bullet is a note; the closing bullet (n=4) is advice, not a
-- step.
return {
    title = 'Achieving True Power',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'shamarhaan is the puppetmaster standing near'},
         done = {
            {t = 'event', zone = 235, event = 441, why = 'Shamarhaan 441: begins the quest at its finish'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 235, event = 442, conf = 'inferred', why = 'Shamarhaan 442: the reminder, only while accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'farm trolls for the testimony specific'}},
        {id = 's3', at = {n = 3, fp = 'trade to shamarhaan to initiate the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the battlefield win)'},
            {t = 'event', zone = 235, event = 444, conf = 'inferred', why = 'Shamarhaan 444: plays only once completed'},
            {t = 'chat', re = 'May we both grow in our trade%.', conf = 'inferred', why = 'Shamarhaan 444 (say #9721)'},
         },
         reach = {
            {t = 'event', zone = 235, event = 443, why = 'Shamarhaan 443: the testimony accepted, off to the fight'},
            {t = 'chat', re = 'It looks like you are ready%.', why = 'Shamarhaan 443 (say #9717)'},
         }},
    },
}
