-- Step progress for Blade of Evil (Bastok quest 59). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/DRK_AF3_Blade_of_Evil.lua (the Beadeaux zone-in cutscene 122 from Pashhow
-- Marshlands begins the quest at its finish; the Middle Delkfutt's Tower ??? trade plays SENSE_A_FOUL_PRESENCE when the three
-- mobs spawn; the trigger-area cutscene 14 completes the quest only when its option is 0, so the event itself is never proof and
-- the quest log is); zones/Middle_Delkfutts_Tower/IDs.lua. The zone has no decoded client event script. The draft made the log's
-- completion prove bullet 4 and left the zone-in, the trade and the closing teleport as notes. Not repeatable.
-- Shared-signal audit: "You sense a foul presence" is also played by Dark Puppet (bastok/58) and Messenger from Beyond (San d'Oria): gated after s1.
return {
    title = 'Blade of Evil',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into beadeaux from pashhow marshlands'},
         done = {
            {t = 'zonein', zone = 147, event = 122, why = 'Beadeaux zone-in cutscene 122 from Pashhow Marshlands: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'farm topaz quadav until you acquire'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'enter middle delkfutt s tower by'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'use the teleporter at j 6'}},
        {id = 's5', at = {n = 5, fp = 'trade the quadav mage blood to'},
         done = {
            {t = 'chat', re = 'you sense a foul presence%.', after = 's1', why = 'Middle Delkfutt\'s Tower SENSE_A_FOUL_PRESENCE: the three mobs spawned'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'defeat all 3 mobs and stand'}},
        {id = 's7', at = {n = 7, fp = 'upon taking the teleport back you'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 157, event = 14, why = 'Middle Delkfutt\'s Tower cutscene 14: the teleport back (its option 0 completes)'}}},
    },
}
