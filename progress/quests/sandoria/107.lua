-- Step progress for Trial-Size Trial by Ice (San d'Oria quest 107). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Castilchat.lua (733 offers it: the finish needs option 1 and
-- a free slot, then adds the quest and the Mini Fork of Ice; 708 and 737 are the accepted-state talks; trading the fork
-- plays 734, whose warp branch is the line "requests a warp", while "Not just yet" ends the event with nothing done) and scripts/battlefields/Cloister_of_Frost/trial-size_trial_by_ice.lua (the win completes the quest); client event script S4
-- 231_Castilchat_010E70C9.txt (734 say #12931 on the warp choice only; 736 plays once completed). The draft put the completed
-- bit on the first bullet: the quest completes at the fight (bullet 4). Event 733's lines play before the inventory check,
-- so with no free slot they play and the quest is not added: they are not used. Bullet 3 (entering the battlefield) has only the generic "Entering the battlefield for ..." text, so it stays plain; bullets 5-10 are tips.
-- Shared-signal audit: every Trial-Size quest NPC plays the same lines (Bastok 72 and the Rabao, Kazham, Norg ones): the 708, 737 and 736 chat lines dropped (their events are unique to Castilchat), the warp line of 734 gated after s1.
return {
    title = 'Trial-Size Trial by Ice',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with castilchat in northern san'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 1545, gained = true, conf = 'inferred', why = 'Mini Fork of Ice gained (items can come from elsewhere)'},
            {t = 'event', zone = 231, event = 708, conf = 'inferred', why = 'Castilchat 708: reminder, only once accepted'},
            {t = 'event', zone = 231, event = 737, conf = 'inferred', why = 'Castilchat 737: reminder, accepted without the fork'},
         },
         reach = {{t = 'event', zone = 231, event = 733, why = 'Castilchat 733 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'you may prepare for the upcoming'},
         done = {
            {t = 'chat', re = 'our adventurer has completed .- preparations and requests a warp', after = 's1', why = 'Castilchat 734, warp chosen (say #12931)'},
         },
         reach = {{t = 'event', zone = 231, event = 734, why = 'Castilchat 734: the fork traded (the warp is chosen in its menu)'}}},
        {id = 's4', at = {n = 4, fp = 'defeat shiva prime to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the win completes it)'},
            {t = 'event', zone = 231, event = 736, conf = 'inferred', why = 'Castilchat 736: only once completed'},
         }},
    },
}
