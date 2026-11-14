-- Step progress for An Eye for Revenge (Abyssea quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/abyssea/An_Eye_for_Revenge.lua; client event script S4 132_Curilla_010842D6.txt
-- (Abyssea - La Theine). Curilla 189 is the "......" brush-off while Lost Memories is not done: not a step, dropped. 190 is the
-- accept: its only menu ("Avenge Curilla's left eye?") loops back on the refusal, so the event cannot end without accepting,
-- and its script takes the Vial of lambent potion (key item 1563) before it plays. The draft listed the vial as GAINED on
-- bullet 1; it is the previous quest's reward (Lost Memories gives it, this quest deletes it), so it is handed over here and
-- the matcher is key item 1563 LOST. 191 is Curilla's talk while the quest is held and no eyeball is in hand (say #7944, also
-- printed at the end of 190). Lugarhoo's eyeball (1580) is given only by the NM's death while the quest is held and by nothing
-- else, so it proves bullet 2. 192 needs the eyeball, plays no refusal branch (both name answers finish the same way), and its
-- finish runs quest:complete, so it proves the last bullet; the eyeball is taken then. The reward key item (1430) can already
-- be owned from other sources and is not used. 193 (the completed-quest talk) is not used. Not repeatable. The log is set at
-- bullet 1, so it is not silent. Shared-signal audit: 1563, 1580 and Curilla 189 to 193 appear in no other quest script or
-- progress file.
return {
    title = 'An Eye for Revenge',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to curilla a at e'},
         done = {
            {t = 'event', zone = 132, event = 190, why = 'Curilla 190: the accept (its menu loops on a refusal)'},
            {t = 'chat', re = 'This means more to me than you know', why = 'Curilla 190 (say #7943, after the accept answer)'},
            {t = 'ki', id = 1563, gained = false, why = 'vial of lambent potion handed over'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 132, event = 191, conf = 'inferred', why = 'Curilla 191: plays only while the quest is held'},
            {t = 'chat', re = 'Be warned that Lugarhoo is no ordinary gnole', conf = 'inferred', why = 'Curilla 191 (say #7944)'},
         }},
        {id = 's2', at = {n = 2, fp = 'defeat lugarhoo to receive lugarhoo s'},
         done = {
            {t = 'ki', id = 1580, gained = true, why = "Lugarhoo's eyeball obtained"},
            {t = 'ki_have', id = 1580, have = true, why = "Lugarhoo's eyeball held"},
            {t = 'chat', re = "obtained key item: lugarhoo's eyeball", why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to curilla a to complete'},
         done = {
            {t = 'event', zone = 132, event = 192, why = 'Curilla 192: the eyeball handed over, runs quest:complete'},
            {t = 'chat', re = 'Incredible! You truly defeated Lugarhoo!', why = 'Curilla 192 (say #7945)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1580, gained = false, after = 's2', why = "Lugarhoo's eyeball taken by Curilla 192"},
         }},
    },
}
