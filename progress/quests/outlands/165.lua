-- Step progress for Open Sesame (Outlands quest 165). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Open_Sesame.lua (Lokpix 20 is the offer, begun only on menu option 1, so it
-- also plays on a refusal; while accepted a plain talk plays 21, and a trade of the wrong things plays 23; the right trade (a
-- Tremorstone with a Meteorite, a Soil Gem or 12 Soil Geodes) plays 22, which runs quest:complete and gives the Loadstone);
-- client event script S4 114_Lokpix_010721F0.txt (22 say #11101; the "Bring me ..." lines are shared by 20, 21 and 23, so they
-- are not used). The draft's "Fragmenting" and "Pulverizing" key items are only the Meteorite's sources, not this quest. The
-- Tremorstone and Unity Warp bullet is a note on the trade. The Loadstone is a reward key item, so it only supports the last step.
return {
    title = 'Open Sesame',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to lokpix in eastern altepa'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Lokpix 20, option 1)'},
            {t = 'event', zone = 114, event = 21, conf = 'inferred', why = 'Lokpix 21: his talk, only while accepted'},
         },
         reach = {{t = 'event', zone = 114, event = 20, why = 'Lokpix 20 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you may find unity warp 125'}},
        {id = 's3', at = {n = 3, fp = 'trade him the items at the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 114, event = 22, why = 'Lokpix 22: the right trade, runs quest:complete'},
            {t = 'chat', re = "I see ya broughts 'em%. Now stand back whiles I works my magic%.", why = 'Lokpix 22 (say #11101)'},
            {t = 'ki', id = 2051, gained = true, conf = 'inferred', why = 'Loadstone obtained (reward)'},
            {t = 'chat', re = 'obtained key item: loadstone', why = 'chat: key item obtained'},
         }},
    },
}
