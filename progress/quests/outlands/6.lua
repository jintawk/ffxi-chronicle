-- Step progress for You Call That a Knife? (Outlands quest 6). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/You_Call_That_a_Knife.lua. The quest begins late: Mhebi Juhbily 127 (the Sandfish
-- trade, a menu: "Nope" plays the same event, so only the "Forrr me?" line of the accept branch counts) sets Prog 1, then the
-- shed `_6y9` event 128 (option 1) runs quest:begin, so the quest log's current bit closes the first bullet. Vah Keshura 130
-- (Prog 1 to 2, no refusal) is the second; 131 is his reminder after it. Chef Nonberry 27 plays only on a correct Tonberry Board
-- (28 is any other trade and pops the cook mobs) and gives Nonberry's knife (KI 253); Vah Keshura 132 is his line while the
-- knife is held. Mhebi 133 runs quest:complete and takes the knife; 134/135 are after completion. Client event scripts S4
-- 250_Mhebi_Juhbily_010FA042.txt (127 say #10190, 129 say #10208, 133 print #10219), 250_Vah_Keshura_010FA029.txt (131 say
-- #10214, 132 say #10216; 130 has no line), 159_Chef_Nonberry_0109F1C4.txt (27 say #7460). The quest log is set at s1, so it is
-- not silent (the draft's silent_until was wrong). The Tonberry Board, directions and the knife bullet are notes. Not repeatable.
return {
    title = 'You Call That a Knife?',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'trade mhebi juhbily i 10 a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (shed event 128, option 1)'},
            {t = 'chat', re = 'Forrr me%? Oh, this is absolutely lovely!', why = 'Mhebi Juhbily 127 (say #10190, accept branch)'},
            {t = 'event', zone = 250, event = 318, conf = 'inferred', why = 'Mhebi Juhbily 318: only after the trade, before the shed'},
            {t = 'event', zone = 250, event = 129, conf = 'inferred', why = 'Mhebi Juhbily 129: reminder, only while accepted'},
            {t = 'chat', re = 'I want to take Tonberriqo back to the jungle, but we have to do something about his knife%.', conf = 'inferred', why = 'Mhebi Juhbily 129 (say #10208)'},
         },
         reach = {{t = 'event', zone = 250, event = 127, why = 'Mhebi Juhbily 127 offered (its finish needs option 511)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to vah keshura h 9'},
         done = {
            {t = 'event', zone = 250, event = 130, why = 'Vah Keshura 130: Prog 2, no refusal'},
            {t = 'event', zone = 250, event = 131, conf = 'inferred', why = 'Vah Keshura 131: his reminder, only after 130'},
            {t = 'chat', re = "If you still want a Tonberry knife, you're going to have to go to the Temple of Uggalepih%.", conf = 'inferred', why = 'Vah Keshura 131 (say #10214)'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'obtain a tonberry board'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'use a unity concord npc warp'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'back inside head west then south'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'turn west once more and pass'}},
        {id = 's7', at = {n = 7, fp = 'speak to chef nonberry then trade'},
         done = {
            {t = 'event', zone = 159, event = 27, why = 'Chef Nonberry 27: the correct Tonberry Board (28 is a wrong trade)'},
            {t = 'chat', re = "Can't cut!!!", why = 'Chef Nonberry 27 (say #7460)'},
            {t = 'ki', id = 253, gained = true, why = "Nonberry's knife obtained"},
            {t = 'ki_have', id = 253, have = true, why = "Nonberry's knife held"},
            {t = 'chat', re = "obtained key item: nonberry's knife", why = 'chat: key item obtained'},
            {t = 'event', zone = 250, event = 132, conf = 'inferred', why = 'Vah Keshura 132: only while the knife is held'},
            {t = 'chat', re = 'Wow, you rrreally got one!', conf = 'inferred', why = 'Vah Keshura 132 (say #10216)'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'he will give you the key'}},
        {id = 's9', at = {n = 9, fp = 'return to mhebi juhbily for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 250, event = 133, why = 'Mhebi Juhbily 133: runs quest:complete'},
            {t = 'chat', re = 'Tonberriqo begins to steam with happiness%.%.%.', why = 'Mhebi Juhbily 133 (print #10219)'},
            {t = 'ki', id = 253, gained = false, after = 's7', conf = 'inferred', why = "Nonberry's knife handed over"},
         }},
    },
}
