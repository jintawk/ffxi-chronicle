-- Step progress for The Wonder Magic Set (Jeuno quest 7). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Lower_Jeuno/npcs/Panta-Putta.lua (77 is the offer, option 1 adds the quest, so it is a
-- reach and the log's current bit proves the step; 55 is his talk while accepted without the Wonder Magic Set; 33 plays
-- whenever the key item is held, in any quest state, and completes the quest, but the reward is a Mythril Earring that needs
-- a free slot, so 33 is only a reach and the log's completed bit proves the last step; 40 is his talk once completed) and
-- Teigero-Bangero.lua (34 is the standard cutscene while the quest is still available). Client event scripts S4
-- 245_Teigero_Bangero_010F5014.txt (34 has no text) and 245_Panta_Putta_010F5016.txt (55 say #7315, 40 say #7328). Key item
-- 113 from res/key_items.lua (it comes from Child's Play, a quest of its own, so key item 113 and event 33 count only once
-- the quest is accepted: after = 's2'). The quest log first shows the quest at Panta-Putta's offer, so the cutscene before
-- it is unknown, not "to do". Not repeatable.
return {
    title = 'The Wonder Magic Set',
    completes = 's3',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to naruru teigero bangero or'},
         done = {
            {t = 'event', zone = 245, event = 34, why = 'Teigero-Bangero 34: the standard cutscene, only while the quest is available'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to panta putta he wants'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Panta-Putta 77, option 1)'},
            {t = 'event', zone = 245, event = 55, conf = 'inferred', why = 'Panta-Putta 55: his talk, only while accepted without the key item'},
            {t = 'chat', re = "I'm pretty sure everybody my age knows what", conf = 'inferred', why = 'Panta-Putta 55 (say #7315)'},
         },
         reach = {{t = 'event', zone = 245, event = 77, why = 'Panta-Putta 77 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'return to panta putta to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 40, after = 's2', conf = 'inferred', why = 'Panta-Putta 40: plays only once completed'},
            {t = 'ki', id = 113, gained = false, after = 's2', conf = 'inferred', why = 'Wonder Magic Set handed over'},
         },
         reach = {{t = 'event', zone = 245, event = 33, after = 's2', why = 'Panta-Putta 33 (also plays when the Mythril Earring cannot be given)'}}},
    },
}
