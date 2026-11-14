-- Step progress for Waters of the Cheval (San d'Oria quest 1). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Waters_of_the_Cheval.lua (Miageau 504 begins the quest on any answer; 571 is
-- the 10 gil trade to Nouveil, who then hands over the Blessed Waterskin; the Cheval River in East Ronfaure takes the waterskin
-- with no event, only a message; 515 is the Cheval Water trade to Miageau and runs quest:complete; 512/519 are Miageau's
-- accepted-state reminders, 572/573 Nouveil's); client event scripts S4 231_Miageau_010E700C.txt (504 say #11190, 515 say
-- #11205) and 231_Nouveil_010E700D.txt (571 say #11199, which no other Nouveil event has). The lines "You will need ..." and
-- "May Paradise open its gates to you." play in several events, so they prove nothing. The quest log is set at s1.
-- Bullet 3 is a direction bullet, a note on the trade at the river and Miageau (bullet 4), which has no event to mark half of it.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
return {
    title = 'Waters of the Cheval',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to miageau and he will'},
         done = {
            {t = 'event', zone = 231, event = 504, why = 'Miageau 504: begins the quest'},
            {t = 'chat', re = 'Weary traveler, come pray with us%.', why = 'Miageau 504 (say #11190)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 519, conf = 'inferred', why = 'Miageau 519: reminder, only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade 10 gil to nouveil who'},
         done = {
            {t = 'event', zone = 231, event = 572, conf = 'inferred', why = 'Nouveil 572: reminder, only with the waterskin held'},
            {t = 'event', zone = 231, event = 512, conf = 'inferred', why = 'Miageau 512: reminder, only with the waterskin held'},
            {t = 'item', id = 602, gained = true, conf = 'inferred', why = 'Blessed Waterskin gained (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 231, event = 571, why = 'Nouveil 571: the 10 gil trade (the waterskin may not fit)'},
                  {t = 'chat', re = 'Trade it to the Cheval River to draw its hallowed water', why = 'Nouveil 571 (say #11199)'}}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to the mouth of the'}},
        {id = 's4', at = {n = 4, fp = 'trade the waterskin to it then'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 231, event = 573, why = 'Nouveil 573: reminder, only with the Cheval Water held'},
                  {t = 'event', zone = 231, event = 515, why = 'Miageau 515: the Cheval Water (the reward may not fit)'},
                  {t = 'chat', re = 'In testament to your devotion, I give you this', why = 'Miageau 515 (say #11205)'}}},
    },
}
