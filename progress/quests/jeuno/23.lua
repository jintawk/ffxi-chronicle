-- Step progress for Child's Play (Jeuno quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Childs_Play.lua (Karl, Port Jeuno: 0 is a plain cutscene with no choice that
-- begins the quest on its finish, offered while The Wonder Magic Set is accepted, so it is only a reach here; 61 is the
-- reminder and plays only while accepted; 1 plays only for an exact White Rock trade and runs quest:complete, whose reward
-- is a key item and a title, nothing to refuse); client event script S4 246_Karl_010F6004.txt (61 say #7067, 1 say #7068);
-- item id from res/items.lua (776 White Rock) and key item from res/key_items.lua (113 Wonder Magic Set). Not repeatable.
-- Karl 1's line is matched on its last sentence: the shorter "Okay, here's your" also matches Lumomo's "Okay, okay, here's your reward"
-- (Windurst Waters event 822), and chat is not scoped to an NPC.
return {
    title = "Child's Play",
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'karl tells you that he will'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Karl 0)'},
            {t = 'event', zone = 246, event = 61, why = 'Karl 61: the reminder, only while accepted'},
            {t = 'chat', re = 'I heard you can find .- somewhere around Castle Oztroja%.', why = 'Karl 61 (say #7067)'},
         },
         reach = {{t = 'event', zone = 246, event = 0, why = 'Karl 0: the offer cutscene'}}},
        {id = 's2', at = {n = 2, fp = 'trade a white rock to karl'},
         done = {
            {t = 'event', zone = 246, event = 1, why = 'Karl 1: the White Rock accepted'},
            {t = 'chat', re = "And don't come back saying you want to return it%!", why = 'Karl 1 (say #7068)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 113, gained = true, conf = 'inferred', why = 'Wonder Magic Set obtained (reward)'},
            {t = 'item', id = 776, lost = true, after = 's1', conf = 'inferred', why = 'White Rock gone (traded, or sold)'},
         }},
    },
}
