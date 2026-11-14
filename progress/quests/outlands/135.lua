-- Step progress for Secret of the Damp Scroll (Outlands quest 135). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Secret_of_the_Damp_Scroll.lua (Shivivi 31 is the offer, only with the Damp Scroll
-- (item 1210) held, and its finish begins the quest with no refusal branch; while accepted his talk is 32; trading exactly the scroll to the
-- Horlais Peak Hot Springs plays 2, and its finish runs quest:complete, which gives the Jubaku: Ichi scroll (item 4949) and only then takes
-- the Damp Scroll). Client event scripts S4 252_Shivivi_010FC01D.txt (31 say #10267, 32 say #10277) and 139_Hot_Springs_0108B241.txt
-- (2 print #7768). Event 2 also plays when the bag is full (the quest stays open and the scroll is kept), so it is reach and the log's
-- completed bit proves s3. The Damp Scroll is found while fishing (it has no step of its own), so its bullet (n=1) is a note on the offer,
-- and the transformation bullet (n=4) is a note on the dip. Not repeatable.
return {
    title = 'Secret of the Damp Scroll',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'to begin this quest you first'}},
        {id = 's2', at = {n = 2, fp = 'you need to have the damp'},
         done = {
            {t = 'event', zone = 252, event = 31, why = 'Shivivi 31: the offer, the quest begins in its finish'},
            {t = 'chat', re = 'Well, shivivi me timbers!', why = 'Shivivi 31 (say #10267)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 252, event = 32, conf = 'inferred', why = 'Shivivi 32: his talk while accepted'},
            {t = 'chat', re = 'If you wanna read da scroll, jus. take it to da hot spring', conf = 'inferred', why = 'Shivivi 32 (say #10277)'},
         }},
        {id = 's3', at = {n = 3, fp = 'take the scroll to horlais peak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Hot Springs 2)'},
            {t = 'item', id = 4949, gained = true, after = 's2', conf = 'inferred', why = 'Jubaku: Ichi scroll gained (reward) (items can come from elsewhere)'},
         },
         reach = {
            {t = 'event', zone = 139, event = 2, after = 's2', why = 'Hot Springs 2 (also plays when the bag is full: the quest stays open)'},
            {t = 'chat', re = 'Letters appeared on the scroll!', after = 's2', why = 'Hot Springs 2 (print #7768)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'this will transform the scroll into'}},
    },
}
