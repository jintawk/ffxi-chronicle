-- Step progress for Synergistic Support (Bastok quest 91). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and Hildolf's client script is not decoded, so only the quest log speaks. The page
-- does not say whether the log flags the quest at the first talk or at the Slime Oil trade, so the first two bullets stay plain
-- bullets; the completed bit proves the last (choosing the Fewell type completes the quest).
return {
    title = 'Synergistic Support',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'choose a type from the list'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the Fewell type chosen)'},
         }},
    },
}
