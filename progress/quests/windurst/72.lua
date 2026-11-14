-- Step progress for Sin Hunting (Windurst quest 72). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/RNG_AF1_Sin_Hunting.lua (every offer here needs option 0 in onEventFinish, so
-- Perih Vashai 523, Perchond 3 and 5, Alexius 10 and the Jugner ??? 13 play on a refusal too and are only `reach`; Perchond 4
-- plays only once 3 was accepted (Prog 1), Alexius 11 only once 10 was accepted (Prog 3); the key items come only with the accepted
-- offer and trade; Perih Vashai 527 plays only at Prog 4, which means the ??? cutscene (13) was accepted, so it proves bullet 8,
-- but completing needs quest:complete to pay the reward, so for bullet 9 it is a reach and the quest log carries the last step).
-- Client event scripts S4 166_Perchond_010A60CF.txt (4 say #7362, #7363), 104_Alexius_01068265.txt (11 say #7949) and
-- 241_Perih_Vashai_*.txt; key items from res/key_items.lua (203 Chieftainness's twinstone earring, 194 Perchond's envelope).
-- Bullets 2, 4 and 5 are notes (travel, what Perchond says, farming the Glittersand drop, an item that can drop for anyone).
-- Repeatable after a memory reset (page meta): the start key item opens the next run. The quest log is set at s1, so it is not
-- silent.
return {
    title = 'Sin Hunting',
    completes = 's9',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to perih vashai in windurst'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki', id = 203, gained = true, why = "chieftainness's twinstone earring obtained"},
            {t = 'ki_have', id = 203, have = true, why = "chieftainness's twinstone earring held"},
            {t = 'chat', re = "obtained key item: chieftainness's twinstone earring", why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 241, event = 523, why = 'Perih Vashai 523 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she will send you to ranguemont'}},
        {id = 's3', at = {n = 3, fp = 'after arriving you will not find'},
         done = {
            {t = 'event', zone = 166, event = 4, conf = 'inferred', why = 'Perchond 4: only once 3 was accepted'},
            {t = 'chat', re = 'Thinking about it now, I wonder if that', conf = 'inferred', why = 'Perchond 4 (say #7362)'},
         },
         reach = {{t = 'event', zone = 166, event = 3, why = 'Perchond 3 offered (its finish needs option 0)'}}},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'perchond will tell you about semih'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'go to the pond at e'}},
        {id = 's6', at = {n = 6, fp = 'trade the pinch of glittersand to'},
         done = {
            {t = 'ki', id = 194, gained = true, why = "Perchond's envelope obtained"},
            {t = 'ki_have', id = 194, have = true, why = "Perchond's envelope held"},
            {t = 'chat', re = "obtained key item: perchond's envelope", why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 166, event = 5, why = 'Perchond 5 offered (its finish needs option 0)'}}},
        {id = 's7', at = {n = 7, fp = 'head to jugner forest at the'},
         done = {
            {t = 'event', zone = 104, event = 11, conf = 'inferred', why = 'Alexius 11: only once 10 was accepted'},
            {t = 'chat', re = "On the night of the full moon a little while back, I saw a flickerin' shadow on the southern edge of the lake%.", conf = 'inferred', why = 'Alexius 11 (say #7949)'},
            {t = 'event', zone = 104, event = 13, conf = 'inferred', why = 'Jugner ??? 13: plays only at Prog 3, after Alexius 10 was accepted'},
         },
         reach = {{t = 'event', zone = 104, event = 10, why = 'Alexius 10 offered (its finish needs option 0)'}}},
        {id = 's8', at = {n = 8, fp = 'go to h 6 in jugner'},
         done = {
            {t = 'event', zone = 241, event = 527, conf = 'inferred', why = 'Perih Vashai 527: plays only at Prog 4, after the ??? cutscene 13 was accepted'},
         },
         reach = {{t = 'event', zone = 104, event = 13, why = 'Jugner ??? 13 offered (its finish needs option 0)'}}},
        {id = 's9', at = {n = 9, fp = 'after the cutscene return to perih'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 203, gained = false, conf = 'inferred', why = "chieftainness's twinstone earring handed over"},
            {t = 'ki', id = 194, gained = false, conf = 'inferred', why = "Perchond's envelope handed over"},
         },
         reach = {{t = 'event', zone = 241, event = 527, why = 'Perih Vashai 527 (completion needs a free slot for the reward)'}}},
    },
}
