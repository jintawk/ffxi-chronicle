-- Step progress for Luck of the Draw (Aht Urhgan quest 6, the Corsair job flag). Data only; see progress/quests/sandoria/27.lua
-- for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Luck_of_the_Draw.lua (a Prog state machine: Ratihb 547 begins the quest with
-- no refusal and sets Prog 1; Mafwahb 548 at Prog 1 sets 2, 647 plays at Prog 2; the Arrapago Reef ??? (qm6) plays cutscene 211
-- at Prog 2 and sets 3; the Talacca Cove ??? (qm1) plays 2 at Prog 3, sets 4 and gives the Forgotten hexagun (key item 791); the
-- Rock Slab (_1l0) plays 3 at Prog 4 and runs quest:complete, whose reward includes a Corsair Die, so 3 replays on a full bag
-- and is only a reach: the completed bit and the loss of the hexagun (deleted only inside quest:complete) prove the last
-- bullet; Ratihb 552 plays only once completed, so it is not used). Cutscene 211 is the Arrapago Reef one only: the same number
-- in Mamook belongs to Give Peace a Chance, and the other cutscenes on that ??? (Zweeha, the pier) are other event ids. Client
-- event scripts S4 050_Mafwahb_0103205F.txt (647 say #9358); the other events have no text; key item 791 from res/key_items.lua.
-- The travel, key and gate bullets (3-5), the Talacca Cove entry (7) are notes on the next signal. Not repeatable.
return {
    title = 'Luck of the Draw',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to ratihb at aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 547, why = 'Ratihb 547: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to mafwahb at aht urhgan'},
         done = {
            {t = 'event', zone = 50, event = 548, why = 'Mafwahb 548: only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 50, event = 647, why = 'Mafwahb 647: only at Prog 2'},
            {t = 'chat', re = "The Seagull Phratrie's headquarters are said to be located somewhere on Arrapago Reef", why = 'Mafwahb 647 (say #9358)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'go to arrapago reef map 1'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'ensure you have a lamian fang'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'use the lamian fang key on'}},
        {id = 's6', at = {n = 6, fp = 'click on the not the shining'},
         done = {
            {t = 'event', zone = 54, event = 211, why = 'Arrapago Reef ??? 211: only at Prog 2, sets Prog 3'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'enter talacca cove from caedarva mire'}},
        {id = 's8', at = {n = 8, fp = 'go around the left side of'},
         done = {
            {t = 'ki', id = 791, gained = true, why = 'forgotten hexagun obtained'},
            {t = 'ki_have', id = 791, have = true, why = 'forgotten hexagun held'},
            {t = 'event', zone = 57, event = 2, why = 'Talacca Cove ??? 2: only at Prog 3, gives the hexagun'},
            {t = 'chat', re = 'obtained key item: forgotten hexagun', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'travel west into the tunnel entrance'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 791, gained = false, why = 'forgotten hexagun handed over (deleted only on completion)'},
         },
         reach = {{t = 'event', zone = 57, event = 3, why = 'Rock Slab 3 (replays if the Corsair Die cannot be given)'}}},
    },
}
