-- Step progress for Promotion: Second Lieutenant (Aht Urhgan quest 97). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Second_Lieutenant.lua, client event script S4
-- 050_Abquhbah_0103208D.txt (events 5071-5079 have no text). Server stage by stage:
-- the Naja's-office region or Abquhbah plays 5071 (no choice) and begins the quest; Prog 0: Abquhbah 5072 is a reminder,
-- trading exactly three Imperial Gold Pieces plays 5073 (gives the Officer Academy manual, 896, sets Prog 1); Prog 1: trading
-- exactly two Imperial Mythril Pieces plays 5075 (trial 1, the questions; option 1 = passed sets Prog 2); Prog 2: the same
-- trade plays 5076 (trial 2 begins, sets Prog 3 whatever happens next), so 5076 only exists once trial 1 is passed; Prog 3:
-- trading one of the beastmen items plays 5077 (sets Prog 4); Prog 4: two Mythril Pieces play 5078 (trial 3, the quiz;
-- option 1 = passed runs quest:complete and prints "has been promoted to Second Lieutenant", line 12070 of
-- Aht_Urhgan_Whitegate/IDs.lua). Each trade event only plays for the exact trade and the pieces are taken in its finish, so
-- the event proves its "trade ... to start the trial" bullet, not that the trial was passed. The bullets that follow the
-- third trade (the quiz answers) and the item notes are notes; the last bullet is the promotion, proved by the completed bit
-- and the message. Not repeatable.
return {
    title = 'Promotion: Second Lieutenant',
    completes = 's21',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter naja s office to start'},
         done = {
            {t = 'event', zone = 50, event = 5071, why = 'Abquhbah 5071: begins the quest (no choice)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 5072, why = 'Abquhbah 5072: his reminder while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade 3 imperial gold pieces to'},
         done = {
            {t = 'event', zone = 50, event = 5073, why = 'Abquhbah 5073: three Imperial Gold Pieces traded'},
            {t = 'ki', id = 896, gained = true, why = 'Officer Academy manual obtained'},
            {t = 'ki_have', id = 896, have = true, why = 'Officer Academy manual held'},
            {t = 'chat', re = 'obtained key item: officer academy manual', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade 2 imperial mythril pieces to'},
         done = {
            {t = 'event', zone = 50, event = 5075, why = 'Abquhbah 5075: two Imperial Mythril Pieces traded, trial 1 starts'},
         }},
        {id = 's8', at = {n = 8, fp = 'trade 2 imperial mythril pieces to'},
         done = {
            {t = 'event', zone = 50, event = 5076, why = 'Abquhbah 5076: two Imperial Mythril Pieces traded, trial 2 starts (only once trial 1 is passed)'},
         }},
        {id = 's9', at = {n = 9, fp = 'examples include'},
         done = {
            {t = 'event', zone = 50, event = 5077, why = 'Abquhbah 5077: a beastmen item traded (sets Prog 4)'},
            {t = 'event', zone = 50, event = 5079, why = 'Abquhbah 5079: his reminder while the item is outstanding'},
         }},
        {id = 's10', kind = 'note', with = 's9', at = {n = 10, fp = 'upgraded beastmen items such as lamian'}},
        {id = 's11', kind = 'note', with = 's9', at = {n = 11, fp = 'beastmen items from the west yagudo'}},
        {id = 's12', at = {n = 12, fp = 'trade 2 imperial mythril pieces to'},
         done = {
            {t = 'event', zone = 50, event = 5078, why = 'Abquhbah 5078: two Imperial Mythril Pieces traded, trial 3 starts'},
         }},
        {id = 's13', kind = 'note', with = 's21', at = {n = 13, fp = 'fulfill requests without fail'}},
        {id = 's14', kind = 'note', with = 's21', at = {n = 14, fp = 'bigger than a marid'}},
        {id = 's15', kind = 'note', with = 's21', at = {n = 15, fp = 'mythralline wellspring'}},
        {id = 's16', kind = 'note', with = 's21', at = {n = 16, fp = 'a detective agency'}},
        {id = 's17', kind = 'note', with = 's21', at = {n = 17, fp = 'empyrean incense'}},
        {id = 's18', kind = 'note', with = 's21', at = {n = 18, fp = 'warjal'}},
        {id = 's19', kind = 'note', with = 's21', at = {n = 19, fp = 'blackrust'}},
        {id = 's20', kind = 'note', with = 's21', at = {n = 20, fp = 'he tripped over his right foot'}},
        {id = 's21', at = {n = 21, fp = 'after all 3 trials are complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'has been promoted to second lieutenant', why = 'promotion message (IDs.lua 12070)'},
         }},
    },
}
