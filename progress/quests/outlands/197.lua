-- Step progress for Trial-Size Trial by Wind (Outlands quest 197). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Rabao/npcs/Rahi_Fohlatti.lua (108 is the offer, a menu whose option 0 begins the quest and
-- gives the Mini Fork of Wind when a slot is free, so it also plays on a refusal; while accepted 68 reminds him with the fork held
-- and 112 re-offers it without; trading the fork plays 109, a menu whose option 0 warps to the Cloister of Gales; 111 plays after
-- completion); scripts/battlefields/Cloister_of_Gales/trial-size_trial_by_wind.lua (the win completes the quest and teaches
-- Garuda); client event script S4 247_Rahi_Fohlatti_010F7031.txt (108 say #10181 on option 0, 109 say #10186 on option 0, 111
-- say #10192). The warp is optional (the cloister can be walked to), so bullet 2 is optional and only the option-0 line marks
-- it; bullet 3 is the protocrystal entry, whose events are the Cloister of Gales battlefields' shared ones (Trial by Wind uses the
-- same room), so it is a note on the battle. Not repeatable as a quest.
return {
    title = 'Trial-Size Trial by Wind',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with rahi fohlatti in rabao'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Rahi Fohlatti 108, option 0, a free slot)'},
            {t = 'chat', re = 'The researcher who made the', why = 'Rahi Fohlatti 108, the accepting branch (say #10181)'},
            {t = 'item', id = 1546, gained = true, conf = 'inferred', why = 'Mini Fork of Wind gained (reward of the offer; also re-given by 112)'},
            {t = 'event', zone = 247, event = 68, conf = 'inferred', why = 'Rahi Fohlatti 68: his reminder, only while accepted'},
            {t = 'event', zone = 247, event = 112, conf = 'inferred', why = 'Rahi Fohlatti 112: a new fork offered, only while accepted'},
         },
         reach = {{t = 'event', zone = 247, event = 108, why = 'Rahi Fohlatti 108 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'optional', at = {n = 2, fp = 'you may prepare for the upcoming'},
         done = {
            {t = 'chat', re = 'preparations and requests a warp%.', after = 's1', why = 'Rahi Fohlatti 109, the warp accepted (say #10186)'},
         },
         reach = {{t = 'event', zone = 247, event = 109, after = 's1', why = 'Rahi Fohlatti 109 (the warp menu; also on a refusal)'}}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'trade the fork to the wind'}},
        {id = 's4', at = {n = 4, fp = 'defeat garuda prime to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the battlefield win)'},
            {t = 'event', zone = 247, event = 111, conf = 'inferred', why = 'Rahi Fohlatti 111: plays only after completion'},
            {t = 'chat', re = 'You defeated the prime avatar', conf = 'inferred', why = 'Rahi Fohlatti 111 (say #10192)'},
         }},
    },
}
