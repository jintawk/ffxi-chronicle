-- Step progress for Bait and Switch (Bastok quest 83). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and none of the NPCs' client scripts are decoded, so only the quest log speaks:
-- Salim begins the quest (the page says "to start the quest") and the cutscene at the Temple of the Goddess ??? completes it.
-- The switch chat lines on the page appear in no decoded client or LandSandBoat text, so they are not used. The examine,
-- clue and switch bullets have no strong signal and stay plain bullets, as do the tips and the repeat note. The page says the
-- quest can be repeated once per conquest tally; nothing tells a second run apart, so no repeat is modelled.
return {
    title = 'Bait and Switch',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to salim to start the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Salim starts the quest)'},
         }},
        {id = 's2', at = {n = 15, fp = 'once all switches have been deactivated'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the Temple of the Goddess cutscene)'},
         }},
    },
}
