-- Step progress for Fear of the Dark III (Abyssea quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/abyssea/Fear_of_the_Dark_III.lua; client event script S4 132_Secodiand_010842D5.txt
-- (Abyssea - La Theine). Secodiand 161 is the offer: its menu ("Will you gather the materials?") also has a refusal, and the
-- first lines ("There's something foul in the air") play on both answers, so the event and that line are only `reach`; the
-- accept answer alone prints "I am in your debt!" (say #7917), and the quest log's current bit follows it. 159 is his talk
-- while the quest is held (say #7919, "Make haste!"). Trading three Clionid Wings (item 2890) plays 160, which runs
-- quest:complete (200 cruor, no item reward, no refusal branch), so it proves bullet 2, the last step; the draft put 160 on
-- the start bullet. The page says repeatable and the script has no repeat code: after a completion LandSandBoat keeps
-- answering 159 and the trade plays 160 again with no new accept, and the client's 161 has a menu-less branch for a repeat
-- ("I must have more charms!", say #7921). So a repeat is the trade alone and the page's "can be completed multiple times"
-- needs no re-accept: restart is the trade step. Every other matcher of that step is first-run only (run1), because the
-- chat line plays on every run and would open a second run from the same trade. The log is set at bullet 1, so it is not
-- silent. Shared-signal audit: Secodiand's events 159 to 161 are his alone (LandSandBoat names no other owner) and nothing
-- else under progress/ uses zone 132 or item 2890. The chat lines are not unique: "I am in your debt!" (the draft's accept
-- proof) and "Make haste!" are also said by Fear of the Dark I (Secodiand, Northern San d'Oria) and Fear of the Dark II
-- (Suldiran, mapped in toau/14), and "Make haste!" by a dozen other NPCs, so both are dropped (s1 keeps the accepted bit).
-- "Thank you! This should hold the darkness at bay" is also the completion line of those two quests, so it stays only as
-- support gated after s1; event 160 and the completed bit carry s2.
return {
    title = 'Fear of the Dark III',
    completes = 's2',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to secodiand a at e'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 132, event = 159, conf = 'inferred', why = 'Secodiand 159: plays only while the quest is held'},
         },
         reach = {{t = 'event', zone = 132, event = 161, why = 'Secodiand 161 offered (its menu can be refused)'}}},
        {id = 's2', at = {n = 2, fp = 'bring back 3 clionid wings'}, count = {item = 2890, need = 3},
         done = {
            {t = 'event', zone = 132, event = 160, why = 'Secodiand 160: three Clionid Wings traded, runs quest:complete'},
            {t = 'chat', re = 'Thank you! This should hold the darkness at bay', run1 = true, after = 's1', why = 'Secodiand 160 (say #7920, shared with Fear of the Dark I and II)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'this quest can be completed multiple'}},
    },
}
