-- Step progress for Trial-Size Trial by Earth (Bastok quest 72). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Trial_Size_Trial_by_Earth.lua (Ferrol 297 is a long cutscene that ends in a choice,
-- and the quest is begun only on option 1 with a free slot, so the event and its lines prove nothing; the quest log and the
-- Mini Fork of Earth do; 301 re-issues the fork and 298 is the fork trade, both only while accepted; the win in the Cloister of
-- Tremors runs quest:complete, so the completed bit proves the last bullet. Event 32001 is any battlefield win in that zone
-- (Trial by Earth uses it too), so it is not used). Client event script S4 236_Ferrol_010EC089.txt (301 say #8676); item 1547
-- from res/items.lua. The trade-to-Ferrol and trade-to-Protocrystal bullets (n=2, n=3) have no strong signal and stay plain
-- bullets; the tip bullets after the steps are not steps.
-- Shared-signal audit: the line "Remember that you must fight the prime avatar as a level" is shared with the other Trial-Size Trial quests (sandoria/107 and
-- others): dropped (s1 has no earlier step); the log bit, item 1547 and events 297, 298 and 301 stay.
return {
    title = 'Trial-Size Trial by Earth',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ferrol at port bastok'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'item', id = 1547, gained = true, conf = 'inferred', why = 'Mini Fork of Earth gained (items can come from elsewhere)'},
            {t = 'event', zone = 236, event = 301, conf = 'inferred', why = 'Ferrol 301: fork re-issue, only while accepted'},
            {t = 'event', zone = 236, event = 298, conf = 'inferred', why = 'Ferrol 298: the fork trade, only while accepted'},
         },
         reach = {{t = 'event', zone = 236, event = 297, why = 'Ferrol 297 offered (plays whether or not the fork is taken)'}}},
        {id = 's4', at = {n = 4, fp = 'defeat titan prime to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 236, event = 300, conf = 'inferred', why = 'Ferrol 300: only plays once the quest is completed'},
         }},
    },
}
