-- Step progress for Grave Concerns (San d'Oria quest 11). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Grave_Concerns.lua (Andecia 540 is the first talk and only sets a variable;
-- 541 begins the quest on the accept answer and hands over the Well Water; 622/623 are her reminders for a lost waterskin,
-- only while accepted; the Tombstone in King Ranperre's Tomb (zone 190) takes the Well Water with only the message "You change
-- the water." (King_Ranperres_Tomb IDs.lua CHANGE_WATER) and plays event 2 when examined; 558 or 624 are the Tomb Waterskin
-- trade to Andecia and run quest:complete); client event script S4 230_Andecia_010E600C.txt (541 accept branch say #7914,
-- 558 say #7927, 624 say #7931). The Notes bullets (n=5..8, the lost-water detour) stay plain bullets. Bullet 2 is a travel
-- note on the tombstone trade. Andecia 622/623 only play while the quest is accepted, so they are inferred evidence for s1.
-- Tombstone event 2 also plays before the trade, so it only marks s3 as reached. The quest log is set at s1 (once the Well
-- Water is handed over).
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
return {
    title = 'Grave Concerns',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to andecia located in the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 567, gained = true, conf = 'inferred', why = 'Well Water gained (items can come from elsewhere)'},
            {t = 'event', zone = 230, event = 623, conf = 'inferred', why = 'Andecia 623: reminder, only while accepted'},
            {t = 'event', zone = 230, event = 622, conf = 'inferred', why = 'Andecia 622: reminder, only while accepted'},
         },
         reach = {{t = 'chat', re = "Then you'll help%? Excellent!", why = 'Andecia 541, accept answer (the Well Water may not fit)'},
                  {t = 'event', zone = 230, event = 540, why = 'Andecia 540: the first talk'},
                  {t = 'event', zone = 230, event = 541, why = 'Andecia 541 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to king ranperre s tomb'}},
        {id = 's3', at = {n = 3, fp = 'trade the well water to the'},
         done = {
            {t = 'chat', re = 'You change the water%.', why = 'Tombstone: Well Water traded (King Ranperre\'s Tomb text CHANGE_WATER)'},
         },
         reach = {{t = 'event', zone = 190, event = 2, why = 'Tombstone 2: examined (also plays before the trade)'}}},
        {id = 's4', at = {n = 4, fp = 'return to andecia and trade her'},
         done = {
            {t = 'event', zone = 230, event = 558, why = 'Andecia 558: the Tomb Waterskin, completes the quest'},
            {t = 'chat', re = 'I thank you, kind adventurer%.', why = 'Andecia 558 (say #7927)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 230, event = 624, why = 'Andecia 624: the Tomb Waterskin after a lost one, completes the quest'},
            {t = 'chat', re = "Well, you lost the waterskin, but to travel to the late king's tomb and back is no mean feat%.", why = 'Andecia 624 (say #7931)'},
         }},
    },
}
