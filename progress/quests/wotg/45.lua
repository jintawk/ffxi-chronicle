-- Step progress for Bonds That Never Die (Crystal War quest 45, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/crystalWar/WOTG_SAN_8_Bonds_That_Never_Die.lua; client event scripts S4
-- 080_Rholont_01050207.txt (649 is a bare cutscene, 651 his reminder while the letter is held) and 080_Rongelouts_N_Distaud_010501ED.txt.
-- Rholont 649 (quest still available, letter not held) hands over the Letter to Count Aurchiat (1074); the Shimmering Pondweed 107
-- (Pashhow Marshlands [S], zone 90) begins the quest and takes the letter back; the quest log is silent before that. Overgrown
-- Mushrooms 212 (Jugner Forest [S], zone 82) gives the Hatchet and sets Prog 1 only if the bag has room (a full bag replays the
-- cutscene), so it has no proof value and bullet 3 is a note on the ivy step; the Length of Jugner ivy (1075) comes from the logging points while Prog is 1
-- (missions/wotg/helpers.lua) and Mushrooms 213 needs it. Mossy Stump 214 is bullet 6; the battle is not implemented in LandSandBoat,
-- but leaving it sets Prog 4 and the next Jugner Forest [S] zone-in plays 215, which proves the battle (bullet 7). Rongelouts N
-- Distaud 650 runs quest:complete. The draft's 213 on bullet 3 is moved to bullet 5 (where the page returns to the Mushrooms) and its
-- 215 from bullet 6 to bullet 7. Not repeatable.
-- Shared-signal audit: events 649 to 651 and 654 of zone 80, 107 of zone 90 and 212 to 215 of zone 82 are used by no other script
-- naming those zones (the other 107s and 213s in LandSandBoat are in Batallia Downs [S], Vunkerl Inlet [S] and Bastok Markets [S]);
-- key items 1074 and 1075 are used by this quest alone; nothing under progress/ uses zones 80, 82 or 90.
return {
    title = 'Bonds That Never Die',
    completes = 's8',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to rholont in southern san'},
         done = {
            {t = 'event', zone = 80, event = 649, why = 'Rholont 649: the cutscene that hands over the letter (no menu)'},
            {t = 'ki', id = 1074, gained = true, why = 'Letter to Count Aurchiat obtained'},
            {t = 'ki_have', id = 1074, have = true, why = 'Letter to Count Aurchiat held'},
            {t = 'chat', re = 'obtained key item: letter to count aurchiat', why = 'chat: key item obtained'},
            {t = 'event', zone = 80, event = 651, conf = 'inferred', why = 'Rholont 651: his reminder, plays only once the letter is held'},
         }},
        {id = 's2', at = {n = 2, fp = 'head back to pashhow marshlands s'},
         done = {
            {t = 'event', zone = 90, event = 107, why = 'Shimmering Pondweed 107: begins the quest and takes the letter (no menu)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 1074, gained = false, after = 's1', why = 'Letter to Count Aurchiat taken at the Pondweed'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to jugner forest s and'}},
        {id = 's4', at = {n = 4, fp = 'use hatchets on logging points in'},
         done = {
            {t = 'ki', id = 1075, gained = true, why = 'Length of Jugner ivy obtained'},
            {t = 'ki_have', id = 1075, have = true, why = 'Length of Jugner ivy held'},
            {t = 'chat', re = 'obtained key item: length of jugner ivy', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to the overgrown mushrooms at'},
         done = {
            {t = 'event', zone = 82, event = 213, why = 'Overgrown Mushrooms 213: plays only at Prog 1 with the ivy, sets Prog 2'},
         }},
        {id = 's6', at = {n = 6, fp = 'travel to the lower right corner'},
         done = {
            {t = 'event', zone = 82, event = 214, why = 'Mossy Stump 214: plays only at Prog 2, sets Prog 3'},
         }},
        {id = 's7', at = {n = 7, fp = 'after the cutscene inspect the mossy'},
         done = {
            {t = 'zonein', zone = 82, event = 215, why = 'Jugner Forest [S] zone-in cutscene 215: after the battle (Prog 4), sets Prog 5'},
         }},
        {id = 's8', at = {n = 8, fp = 'after you have cleared the battlefield'},
         done = {
            {t = 'event', zone = 80, event = 650, why = 'Rongelouts N Distaud 650: plays only at Prog 5, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
