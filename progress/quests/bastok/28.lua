-- Step progress for Blade of Darkness (Bastok quest 28). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Blade_of_Darkness.lua (marked "needs verification" there: Gumbah 99 is a plain
-- cutscene that begins the quest; arriving in Zeruhn Mines from Palborough plays zone-in 130 and gives the Chaosbringer (131
-- re-issues it); arriving in Beadeaux from Pashhow with 100 kills plays zone-in 121 and completes); client event script S4
-- 234_Gumbah_010EA004.txt (99 has no dialogue; 130 there belongs to Blade of Death, another quest). The zone-in events are
-- LandSandBoat's only: if retail differs they simply never match, and the completed quest log still ticks the last step.
-- Bullets 5 and 6 (the sword's reward line and the 100 kills) have no signal (the kill count is a server variable), so they
-- stay plain bullets. The draft mapped everything to bullet 1 and guessed the completion; corrected here.
-- Shared-signal audit: item 16607 (Chaosbringer) and the Zeruhn Mines zone-in 131 are also Blade of Death's (it re-issues the
-- sword on the same zone-in) -> shared with Blade of Death, gated after s2. Zone-in 130 and Beadeaux 121 are this quest's only.
return {
    title = 'Blade of Darkness',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'teleport to bastok mines home point'}},
        {id = 's2', at = {n = 2, fp = 'speak to him repeatedly until you'},
         done = {
            {t = 'event', zone = 234, event = 99, why = 'Gumbah 99: begins the quest (no menu)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to the palborough mines and'}},
        {id = 's4', at = {n = 4, fp = 'go to the boat docks at'},
         done = {
            {t = 'zonein', zone = 172, event = 130, why = 'Zeruhn Mines zone-in 130 from Palborough: the Zeid cutscene, gives the sword (LandSandBoat)'},
            {t = 'item', id = 16607, gained = true, after = 's2', conf = 'inferred', why = 'Chaosbringer gained'},
            {t = 'zonein', zone = 172, event = 131, after = 's2', conf = 'inferred', why = 'Zeruhn Mines zone-in 131: sword re-issued, only after 130'},
         }},
        {id = 's7', at = {n = 7, fp = 'upon the completion of the mass'},
         done = {
            {t = 'zonein', zone = 147, event = 121, why = 'Beadeaux zone-in 121 from Pashhow: completes (LandSandBoat)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
