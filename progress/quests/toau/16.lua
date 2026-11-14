-- Step progress for The Die Is Cast (Aht Urhgan quest 16). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/The_Die_is_Cast.lua (a Prog state machine: Ratihb 591 begins the quest with
-- no refusal; Ekhu Pesshyadha 592 at Prog 0 sets 1; Jijiroon 245 in Nashmau at Prog 1 sets 2; the Arrapago Reef ??? (qm9) plays
-- 212 at Prog 2 and sets 3; at Prog 3 it spawns Bukki with only a system message and no event, and killing him sets Prog 4;
-- at Prog 4 it plays 213, which sets 5 and gives the Bag of gold pieces (key item 790); Ratihb 593 at Prog 5 runs
-- quest:complete, whose reward is a Random Ring, so 593 replays on a full bag and is only a reach: the completed bit and the
-- loss of the bag (deleted only inside quest:complete) prove the last bullet). Events 212 and 213 are also used in Mamook (zone
-- 65) by Two Horn the Savage and 214 in zone 54 by No Strings Attached, so the zone is part of every match here. The events have
-- no client script text. The travel, key and map bullets (4-7) are notes on the first ??? cutscene and the spawn bullet (9) a
-- note on the final ??? (it has no event of its own). The page says the walkthrough is one part of the Random Ring chain;
-- the ring is a reward item and not used. Not repeatable.
return {
    title = 'The Die Is Cast',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ratihb j 12 in'},
         done = {
            {t = 'event', zone = 50, event = 591, why = 'Ratihb 591: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to ekhu pesshyadha h 6'},
         done = {
            {t = 'event', zone = 50, event = 592, why = 'Ekhu Pesshyadha 592: only at Prog 0, sets Prog 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to jijiroon h 8 in'},
         done = {
            {t = 'event', zone = 53, event = 245, why = 'Jijiroon 245: only at Prog 1, sets Prog 2'},
         }},
        {id = 's4', kind = 'note', with = 's8', at = {n = 4, fp = 'go up the stairs at h'}},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'obtain a lamian fang key from'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'travel to arrapago reef by way'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'go to f 10 on map'}},
        {id = 's8', at = {n = 8, fp = 'click the to see a cutscene'},
         done = {
            {t = 'event', zone = 54, event = 212, why = 'Arrapago Reef ??? 212: only at Prog 2, sets Prog 3'},
         }},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'click it again to spawns an'}},
        {id = 's10', at = {n = 10, fp = 'defeat bukki and check the again'},
         done = {
            {t = 'ki', id = 790, gained = true, why = 'bag of gold pieces obtained'},
            {t = 'ki_have', id = 790, have = true, why = 'bag of gold pieces held'},
            {t = 'event', zone = 54, event = 213, why = 'Arrapago Reef ??? 213: only at Prog 4 (Bukki dead), gives the bag'},
            {t = 'chat', re = 'obtained key item: bag of gold pieces', why = 'chat: key item obtained'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to aht urhgan whitegate and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 790, gained = false, why = 'bag of gold pieces handed over (deleted only on completion)'},
         },
         reach = {{t = 'event', zone = 50, event = 593, why = 'Ratihb 593 (replays if the Random Ring cannot be given)'}}},
    },
}
