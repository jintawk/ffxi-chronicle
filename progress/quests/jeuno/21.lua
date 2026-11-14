-- Step progress for The Clockmaster (Jeuno quest 21). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Clockmaster.lua (Upper Jeuno, Door: House _6s2, plays event 152 when Save
-- the Clock Tower is done and Jeuno fame is 5; it has no choice and runs quest:complete, but the reward is a Time Hammer, so
-- 152 also plays when the bag is full and is only a reach: the log's completed bit proves the step; the quest is never
-- accepted, so there is nothing before it in the log). The door's event has no client script (the door is not in the
-- exported S4 set; 152 is in LandSandBoat's list for zone 244). Bullet 2 only says the quest then completes, so it is a note.
-- Not repeatable.
return {
    title = 'The Clockmaster',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after completing the previous quest speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (152 also plays when the Time Hammer cannot be given)'},
         },
         reach = {{t = 'event', zone = 244, event = 152, why = 'Door: House 152: the cutscene (the Time Hammer needs a free slot)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'this quest will then be completed'}},
    },
}
