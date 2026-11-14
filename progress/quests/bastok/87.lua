-- Step progress for A Proper Burial (Bastok quest 87). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest (only Lamepaue's past-event bits, which need it completed) and the client's Offa
-- script (S4 235_Offa_010EB02A.txt) holds none of its events, so only the quest log speaks: the first bullet says Offa begins
-- the quest, and the last bullet (the Rolanberry trade and the return) completes it. The travel, choice and path bullets in
-- between have no signal and stay plain bullets; the indented path bullets are never steps.
return {
    title = 'A Proper Burial',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to offa to begin quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Offa begins the quest)'},
         }},
        {id = 's12', at = {n = 12, fp = 'whichever way you decided to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
