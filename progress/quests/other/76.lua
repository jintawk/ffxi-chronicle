-- Step progress for In the Name of Science (Other Areas quest 76). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Tavnazian_Safehold/npcs/Yurim.lua (the offer 524 is a plain cutscene whose finish adds
-- the quest; trading a base item and a chip is event 526, which only plays for a valid pair; trading the organs is event 529,
-- which completes the quest and gives the reward, but the event also plays when the reward cannot be given (full bag), so only
-- the quest log's completed bit proves the last step and 529 is the `reach`; an Apple Pie trade is the optional hint 531) and
-- Meret.lua (582/583 once the quest is done: the trade-in for vices and auras); client event script S4 026_Yurim_0101A07C.txt
-- (524 say #11454, 526 say #11466 ff, 529 say #11492). Events 524, 525, 528 and 532 are also listed for The Warrior's Path
-- in the event-owner header, so only the quest log's current bit and 526 are used as proof; 524 is a `reach`. The page's
-- speak-again bullet and the Meret/gorget/obi bullets are notes. The repeat is a fresh base trade (526), not a new accept, so
-- there is no `repeatable` entry. The quest log is set at s1, so it is not silent.
return {
    title = 'In the Name of Science',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'start the quest by talking to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Yurim 524 adds the quest)'},
         },
         reach = {{t = 'event', zone = 26, event = 524, why = 'Yurim 524 offered'}}},
        {id = 's2', at = {n = 2, fp = 'choose a reward then trade the'},
         done = {
            {t = 'event', zone = 26, event = 526, why = 'Yurim 526: a valid base item and chip traded (LandSandBoat starts it only for a valid pair)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'speak to yurim again you can'}},
        {id = 's4', at = {n = 4, fp = 'trade the appropriate items to yurim'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 26, event = 529, why = 'Yurim 529: the organs traded (also plays when the reward cannot be given)'}}},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'completing the quest once by obtaining'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'meret'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'elemental gorgets'}},
        {id = 's8', kind = 'note', with = 's4', at = {n = 8, fp = 'elemental obis'}},
    },
}
