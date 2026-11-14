-- Step progress for Lost Memories (Abyssea quest 9). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/abyssea/Lost_Memories.lua; client event script S4 132_Halver_010842ED.txt (Abyssea -
-- La Theine). Halver 162 is the brush-off below Abyssea - La Theine fame 5 ("indolent outsiders", say #8054): not a step, the
-- draft's use of it is dropped. 165 is the offer with two menus: "Hear his plea?" can be refused, so the event and its first
-- line (say #8055) are only `reach`; the accept answer prints "You have my boundless gratitude!" (say #8058) and the quest
-- log's current bit follows. 163 is his talk while the quest is held and the tome line (say #8067, also the end of the accept
-- branch of 165) appears only after accepting. Trading two Lambent Scales (item 2874) plays 164, which runs quest:complete; its
-- first-time branch says "Using the scales, I've concocted the Vial of lambent potion" (say #8070) and the reward is that key
-- item (1563) plus cruor, so the draft's bullet is right. A repeat (the page says "Zoning is not required to repeat this
-- quest"; the script has only a TODO for it) is the same trade with no new accept: the client's 164 and 165 both have a
-- repeat branch (the flag P7, 165 prints "Ah, 'tis heartening to see you again"), and the repeat gives the Coeurl Mantle
-- augment. So the restart step is the trade, and every other matcher of that step is first-run only (run1): the vial,
-- the first-time line and the log bits do not come again, and the login snapshot of the vial must not open a run. Bullets 2
-- and 3 (what he asks for, where it drops) and 5 (the fame note) have no signal: notes; bullet 6 is the Augments tab's
-- "(unknown)" and is not a step. The log is set at bullet 1, so it is not silent. Shared-signal audit: the vial (1563) is
-- also deleted by An Eye for Revenge (quest 3, LOST, not gained), and Halver 162 to 165 are his alone.
return {
    title = 'Lost Memories',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s4'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to halver a at l'},
         done = {
            {t = 'chat', re = 'You have my boundless gratitude!', why = 'Halver 165 (say #8058, the accept answer only)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = 'According to the tome of healing', conf = 'inferred', why = 'Halver 165 accept branch / 163 (say #8067)'},
            {t = 'event', zone = 132, event = 163, conf = 'inferred', why = 'Halver 163: plays only while the quest is held'},
         },
         reach = {{t = 'event', zone = 132, event = 165, why = 'Halver 165 offered (its menu can be refused)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'he will request two lambent scales'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'lambent scales drop from farfadets a'}},
        {id = 's4', at = {n = 4, fp = 'trade the lambent scales to halver'}, count = {item = 2874, need = 2},
         done = {
            {t = 'event', zone = 132, event = 164, why = 'Halver 164: two Lambent Scales traded, runs quest:complete'},
            {t = 'chat', re = "Using the scales, I've concocted the", run1 = true, why = 'Halver 164 (say #8070, first completion only)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 1563, gained = true, run1 = true, why = 'vial of lambent potion obtained (first completion only)'},
            {t = 'ki_have', id = 1563, have = true, run1 = true, why = 'vial of lambent potion held'},
            {t = 'chat', re = 'obtained key item: vial of lambent potion', run1 = true, why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'completing this quest 8 more times'}},
    },
}
