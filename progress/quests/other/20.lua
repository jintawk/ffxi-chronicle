-- Step progress for Cargo (other areas quest 20). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Selbina/npcs/Vuntar.lua (event 50 is the offer at level 20 and adds the quest on finish
-- with no menu, so it is the accept; 51 is the reminder while accepted or after; 52 is the accepted berry trade, it completes
-- the quest only the first time and pays by the berry's age; a second trade the same day plays 1134 and is a refusal). Client
-- event script S4 248_Vuntar_010F8021.txt (50 say #6790, 52 say #6792; #6788/#6789 also play for the level refusal 53, #6791
-- also in 51). The quest is repeatable and retail keeps the current bit, so the log marks the first run only (run1), as for
-- Bastok quest 0. The berry bullets are notes (items can come from anywhere).
return {
    title = 'Cargo',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to vuntar h 9 in'},
         done = {
            {t = 'event', zone = 248, event = 50, why = 'Vuntar 50: the offer, adds the quest on finish'},
            {t = 'chat', re = 'The thing was, regular .* didn\'t work!', why = 'Vuntar 50 (say #6790)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 248, event = 51, conf = 'inferred', why = 'Vuntar 51: reminder, only once accepted or done'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'purchase some rolanberries'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'proceed to crawler s nest to'}},
        {id = 's4', at = {n = 4, fp = 'bring the rolanberries that drop from'},
         done = {
            {t = 'event', zone = 248, event = 52, why = 'Vuntar 52: the berries accepted'},
            {t = 'chat', re = 'Hey, thanks a lot%. Bring me all you find', why = 'Vuntar 52 (say #6792)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}
