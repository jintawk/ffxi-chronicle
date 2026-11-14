-- Step progress for A Clock Most Delicate (Jeuno quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/A_Clock_Most_Delicate.lua (Collet 112 at Option 0 is the first cutscene and
-- leaves no trace in the log; the Door: House _6s2 then offers the quest, 119 or 118, and only option 1 begins it, so those
-- are reaches and the log's current bit proves the step; while accepted the door plays 117, or 202 when the Clock Tower oil
-- is held, which runs quest:complete; the reward includes the Engineer's Gloves, so 202 also plays when the bag is full and
-- is only a reach: the log's completed bit proves the last step and deletes the oil) and scripts/quests/jeuno/
-- Deal_with_Tenshodo.lua (Garnev 166 gives the Clock Tower oil, key item 19, as that quest's reward; it can only be done
-- while this quest is accepted). Client event script S4 244_Collet_010F4010.txt (112 has no text, 186 say #7240); the door
-- has no client script (it is in LandSandBoat's list for zone 244). Key item 19 is also Deal with Tenshodo's reward, so it
-- counts only once this quest is accepted (after = 's2'). Key item 19 from res/key_items.lua. The quest log first
-- shows the quest at the door's acceptance, so the Collet cutscene is unknown, not "to do", before it. Not repeatable.
return {
    title = 'A Clock Most Delicate',
    completes = 's4',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to collet for a cutscene'},
         done = {
            {t = 'event', zone = 244, event = 112, why = 'Collet 112: the cutscene, only at Option 0'},
            {t = 'event', zone = 244, event = 186, conf = 'inferred', why = 'Collet 186: plays only once 112 has set Option'},
            {t = 'chat', re = "I'm so scared of school%.", conf = 'inferred', why = 'Collet 186 (say #7240)'},
         }},
        {id = 's2', at = {n = 2, fp = 'check the door house to the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Door: House 119 or 118, option 1)'},
            {t = 'event', zone = 244, event = 117, conf = 'inferred', why = 'Door: House 117: plays only while accepted and the oil is not held'},
         },
         reach = {
            {t = 'event', zone = 244, event = 119, why = 'Door: House 119 offered (its finish needs option 1)'},
            {t = 'event', zone = 244, event = 118, why = 'Door: House 118 offered after a decline (its finish needs option 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'the key item you need to'},
         done = {
            {t = 'ki', id = 19, gained = true, after = 's2', why = 'Clock Tower oil obtained (Deal with Tenshodo reward)'},
            {t = 'ki_have', id = 19, have = true, after = 's2', why = 'Clock Tower oil held'},
            {t = 'chat', re = 'obtained key item: clock tower oil', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'check the door house west of'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 19, gained = false, after = 's3', conf = 'inferred', why = 'Clock Tower oil deleted on completion'},
         },
         reach = {{t = 'event', zone = 244, event = 202, why = 'Door: House 202 (also plays when the Engineer\'s Gloves cannot be given)'}}},
    },
}
