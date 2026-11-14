-- Step progress for Flyers for Regine (San d'Oria quest 16). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/flyers_for_regine.lua and zones/Port_San_dOria/npcs/Regine.lua (Regine 510 is her
-- shop menu and plays on every talk; only the "looking for work" answer and the accept give 15 flyers and add the quest, so
-- the line "Here are the flyers, then." (say #7595) proves the accept; each delivery shows "Your flyer is accepted!" (zone
-- text FLYER_ACCEPTED in Port and Northern San d'Oria, "The flyer is accepted." in Southern); Regine 603 plays only once all
-- 15 are delivered and runs the completion); client event script S4 232_Regine_010E8013.txt (510 option 2 say #7595, 603 say
-- #7605). Bullet 6 is the 15 deliveries (the indented bullets are not steps): nothing marks them one by one and event 603,
-- which proves they are all done, also finishes bullet 25 in the same talk, so bullet 6 stays a plain bullet. Bullets 1, 3
-- and 4 are tips (notes). The quest log is set at the accept.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
return {
    title = 'Flyers for Regine',
    completes = 's25',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'make sure you have two slots'}},
        {id = 's2', at = {n = 2, fp = 'speak with regine to begin quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 532, gained = true, conf = 'inferred', why = 'Magicmart Flyer gained (items can come from elsewhere)'},
            {t = 'chat', re = 'flyer is accepted', conf = 'inferred', why = 'a flyer delivered, only while accepted'},
         },
         reach = {{t = 'chat', re = 'Here are the flyers, then%.', why = 'Regine 510, accept answer (the flyers may not fit)'}}},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'after her story magicmart flyer x15'}},
        {id = 's4', kind = 'note', with = 's25', at = {n = 4, fp = 'while this quest is active if'}},
        {id = 's25', at = {n = 25, fp = 'once all 15 magicmart flyers have'},
         done = {
            {t = 'event', zone = 232, event = 603, why = 'Regine 603: completes the quest'},
            {t = 'chat', re = "You've handed out all the flyers%?", why = 'Regine 603 (say #7605)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
