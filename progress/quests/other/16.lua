-- Step progress for Donate to Recycling (quest other 16). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Selbina/npcs/Romeo.lua (event 20 plays only while the quest is available, has no menu and
-- its finish adds the quest, so it is the accept; 22 is his talk while accepted; trading five of one Onion weapon is event
-- 21, whose finish completes the quest and gives the Wastebasket, which needs a free slot, and the same event plays
-- without one, so 21 is only a reach and the quest log's completed bit proves the step; 23 is the after-completion line).
-- The second bullet is the trade itself, not a note: the draft made it a note and put the completion on the first bullet.
-- Client event script S4 248_Romeo_010F8012.txt (20 say #6717, 21 say #6723, 22 say #6722). Not repeatable.
return {
    title = 'Donate to Recycling',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to romeo'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Romeo 20 runs addQuest)'},
            {t = 'event', zone = 248, event = 20, why = 'Romeo 20: the offer, no refusal'},
            {t = 'chat', re = 'Another adventurer in Selbina%?', why = 'Romeo 20 (say #6717)'},
            {t = 'event', zone = 248, event = 22, conf = 'inferred', why = 'Romeo 22: his talk, only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade him five pieces of the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 248, event = 21, why = 'Romeo 21: the onion trade (also plays with no room for the Wastebasket)'},
            {t = 'chat', re = 'Yes, these will do nicely!', why = 'Romeo 21 (say #6723)'},
         }},
    },
}
