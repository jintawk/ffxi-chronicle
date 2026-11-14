-- Step progress for The Road to Divadom (Jeuno quest 97). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/DNC_AF2_The_Road_to_Divadom.lua (Laila 10136 begins the quest with no refusal,
-- 10137 is her talk at Prog 0; the Jugner Forest [S] zone-in cutscene 105 plays at Prog 0 and its finish sets Prog 1; the
-- Glowing Pebbles play 106 at Prog 1 and, traded exactly one Block of Yagudo Glue at Prog 2, play 107, which takes the glue;
-- Laila plays 10139, 10214 and 10215 in a row and then 10170 at Prog 3, and 10170 alone at Prog 4, which completes the quest
-- only if the Dancer's Tights could be given, so 10170 and the three before it are only reaches and the completed bit carries
-- the last bullet); client event script S4 244_Laila_010F40BD.txt (10137 say #11925, 10170 say #12111; the rest are bare).
-- Zone ids from res/zones.lua (244 Upper Jeuno, 82 Jugner Forest [S]). The glue farming advice (sub-bullets of n=1) is not
-- a step. The quest log is set at s1, so it is not silent. Not repeatable (page meta).
return {
    title = 'The Road to Divadom',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to laila in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 10136, why = 'Laila 10136: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 244, event = 10137, conf = 'inferred', why = 'Laila 10137: her talk at Prog 0, only while accepted'},
            {t = 'chat', re = 'If ye want t\'become a top%-notch dancer', conf = 'inferred', why = 'Laila 10137 (say #11925)'},
         }},
        {id = 's2', at = {n = 2, fp = 'zone into jugner forest s for'},
         done = {
            {t = 'zonein', zone = 82, event = 105, why = 'Jugner Forest [S] zone-in cutscene 105 (Prog 0)'},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the glowing pebbles in jugner'},
         done = {
            {t = 'event', zone = 82, event = 106, why = 'Glowing Pebbles 106 (Prog 1)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade the yagudo glue to the'},
         done = {
            {t = 'event', zone = 82, event = 107, why = 'Glowing Pebbles 107: exactly one Block of Yagudo Glue accepted (Prog 2)'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to laila in upper jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 244, event = 10139, why = 'Laila 10139: the first cutscene of the reward sequence (Prog 3)'},
            {t = 'event', zone = 244, event = 10170, why = 'Laila 10170 (completes only if the Dancer\'s Tights could be given)'},
         }},
    },
}
