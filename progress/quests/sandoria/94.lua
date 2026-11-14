-- Step progress for A Craftsman's Work (San d'Oria quest 94). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Miaux.lua (73 or 71 option 1 begins the quest; 69 is his reminder
-- until the stone is held; 70 with the stone gives the Peregrine, takes the stone and completes it, but with a full bag the
-- event still plays and nothing completes, so it only reaches the step), zones/Eastern_Altepa_Desert/npcs/qm.lua (the first
-- examine pops Decurio I-III, a line shared with Twenty in Pirate Years' ??? so it proves nothing; after the kill the second examine gives key item 297);
-- client event scripts S4 231_Miaux_010E7032.txt (71 accept line say #12768, 69 say #12770); key item 297 and item 16887 from
-- res/key_items.lua and res/items.lua; The quest is repeatable after
-- a memory reset (page meta): the log bits count for the first run only. The draft put the stone on the accept step; it is the
-- second examine's (n=3); the first examine (n=2) has no signal of its own and is a note on it. The quest log is set at s1, so it is not silent.
return {
    title = "A Craftsman's Work",
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to miaux in northern san'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'chat', re = "You'll help me%?", why = 'Miaux 71, accepted (say #12768)'},
            {t = 'event', zone = 231, event = 69, conf = 'inferred', why = 'Miaux 69: reminder, only while accepted'},
            {t = 'chat', re = 'can be found in the Eastern Altepa Desert%.', conf = 'inferred', why = 'Miaux 69 (say #12770)'},
         },
         reach = {{t = 'event', zone = 231, event = 73, why = 'Miaux 73 offered (its finish needs option 1)'},
                  {t = 'event', zone = 231, event = 71, why = 'Miaux 71 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examine the in eastern altepa desert'}},
        {id = 's3', at = {n = 3, fp = 'examine the after defeating decurio i'},
         done = {
            {t = 'ki', id = 297, gained = true, why = 'Altepa polishing stone obtained'},
            {t = 'ki_have', id = 297, have = true, why = 'Altepa polishing stone held'},
            {t = 'chat', re = 'obtained key item: altepa polishing stone', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to miaux again to receive'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 297, gained = false, conf = 'inferred', why = 'Altepa polishing stone handed over'},
            {t = 'item', id = 16887, gained = true, conf = 'inferred', why = 'Peregrine gained (reward; items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 231, event = 70, why = 'Miaux 70 (also plays with a full bag, so it proves nothing)'}}},
    },
}
