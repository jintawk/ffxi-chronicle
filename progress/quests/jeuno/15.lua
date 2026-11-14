-- Step progress for Community Service (Jeuno quest 15). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Community_Service.lua (Zauko 116 is the evening offer; its update begins the
-- quest and sends P0 = 1, so the "Don't worry" and "Light the twelve lamps" lines play only once the run is accepted, while
-- the decline lines ("Come back if you change your mind", "I already have a helper tonight") prove nothing and 116 itself is
-- only a reach; 114 plays only while a run is in progress; each of the twelve lamps (events 120-131) prints "You light the
-- lamp." and the twelfth also "All the lamps are lit." (zones/Lower_Jeuno/IDs.lua 7275, 7276); Zauko 117 is the turn-in, it
-- runs quest:complete (reward is a title, nothing to refuse) and offers the Lamp lighter's membership card, taken on a menu
-- choice; 118 returns it). Client event script S4 245_Zauko_010F508F.txt (116 say #7257/#7260 accepted, 114 say #7264, 117 say
-- #7265/#7266). Bullet 4 is the card that a second completion offers: optional, proved by the key item itself (706, from
-- res/key_items.lua). Repeatable (page meta): a new run opens with the accept lines or the in-progress talk after a finished run.
return {
    title = 'Community Service',
    completes = 's3',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note this quest is only offered'}},
        {id = 's2', at = {n = 2, fp = 'speak to zauko in lower jeuno'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = "Don't worry%. It's easy%. See the twelve lamps on the sea side%?", why = 'Zauko 116 after accepting, first time (say #7257)'},
            {t = 'chat', re = 'Light the twelve lamps facing the ocean%.', why = 'Zauko 116 after accepting, repeat (say #7260)'},
            {t = 'event', zone = 245, event = 114, why = 'Zauko 114: a run is in progress'},
         },
         reach = {{t = 'event', zone = 245, event = 116, why = 'Zauko 116 offered (the lines after it need the helper to be accepted)'}}},
        {id = 's3', at = {n = 3, fp = 'you must light all of the'},
         done = {
            {t = 'chat', re = 'All the lamps are lit%.', why = 'twelfth lamp lit (IDs.lua 7276)'},
            {t = 'event', zone = 245, event = 117, why = 'Zauko 117: the turn-in, runs quest:complete'},
            {t = 'chat', re = "Good work%. I can't pay you, but I hope you found the experience rewarding%.", why = 'Zauko 117, first completion (say #7265)'},
            {t = 'chat', re = "Good work%. It's rewarding each and every time, isn't it%?", why = 'Zauko 117, repeat completion (say #7266)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         },
         reach = {{t = 'chat', re = 'You light the lamp%.', why = 'a lamp lit (IDs.lua 7275)'}}},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'repeating this quest a second time'},
         done = {
            {t = 'ki', id = 706, gained = true, why = "Lamp lighter's membership card obtained"},
            {t = 'ki_have', id = 706, have = true, why = "Lamp lighter's membership card held"},
         }},
    },
}
