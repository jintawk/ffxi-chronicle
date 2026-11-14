-- Step progress for The Wondrous Whatchamacallit (Bastok quest 90). Data only; see progress/quests/sandoria/27.lua for the format.
-- LandSandBoat has no script for this quest and Selliste's client script is not decoded, so only the quest log speaks. The
-- first bullet does not say when the log first flags the quest, so it stays a plain bullet; the completed bit proves the last
-- bullet (the Astral Matter trade to Selliste). The stone-gathering bullet has no signal and stays plain too.
return {
    title = 'The Wondrous Whatchamacallit',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'synergize the stones into astral matter'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the Astral Matter trade to Selliste)'},
         }},
    },
}
