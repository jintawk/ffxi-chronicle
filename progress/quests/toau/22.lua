-- Step progress for Omens (Aht Urhgan quest 22). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/BLU_AF2_Omens.lua (Waoud 710 begins the quest at once, no option; the Navukgo
-- Execution Chamber win sets Prog 1 through event 32001, which every battlefield there shares, so the fight has no signal of its own
-- and bullets 3 and 4 are notes on the next step; Waoud 712 at Prog 1 hands over the Sealed Immortal envelope (key item 835) and
-- sets Prog 2; Lathuya 714 at Prog 2 takes it on and sets Prog 3 (his 715 at Prog 3 is the reminder, a reach for the Aydeewa
-- bullet); the ??? in Aydeewa Subterrane plays 9 only at Prog 3 and sets Prog 4; Lathuya 716 at Prog 4 runs quest:complete, whose
-- reward is Magus Charuq's, so a full bag replays 716 and only the completed bit proves the last bullet). The draft put events 712
-- and the envelope on the begin bullet, collapsed the Lathuya delivery, the Aydeewa ??? and the return into one step and dropped
-- the ???. Client event script S4 050_Lathuya_0103211E.txt (715 say #8910; 714 and 716 are bare); 710, 712 and Aydeewa 9 have no text.
-- Key item id from res/key_items.lua. Not repeatable (the draft's restart was a guess).
return {
    title = 'Omens',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'wait one in game day since'}},
        {id = 's2', at = {n = 2, fp = 'speak to waoud to begin the'},
         done = {
            {t = 'event', zone = 50, event = 710, why = 'Waoud 710: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'raubahn will direct you to find'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'when in the navukgo execution chamber'}},
        {id = 's5', at = {n = 5, fp = 'return to aht urhgan whitegate and'},
         done = {
            {t = 'event', zone = 50, event = 712, why = 'Waoud 712: plays only at Prog 1 (the Flan beaten), hands over the envelope'},
            {t = 'ki', id = 835, gained = true, why = 'sealed Immortal envelope obtained'},
            {t = 'ki_have', id = 835, have = true, why = 'sealed Immortal envelope held'},
            {t = 'chat', re = 'obtained key item: sealed immortal envelope', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'you will be given a sealed'}},
        {id = 's7', at = {n = 7, fp = 'deliver the envelope to lathuya aht'},
         done = {
            {t = 'event', zone = 50, event = 714, why = 'Lathuya 714: plays only at Prog 2, sets Prog 3'},
            {t = 'ki', id = 835, gained = false, conf = 'inferred', why = 'sealed Immortal envelope handed over'},
         }},
        {id = 's8', at = {n = 8, fp = 'zone into wajaom woodlands from aht'},
         done = {
            {t = 'event', zone = 68, event = 9, why = 'the ??? 9 in Aydeewa Subterrane: plays only at Prog 3, sets Prog 4'},
         },
         reach = {
            {t = 'event', zone = 50, event = 715, why = 'Lathuya 715: his talk at Prog 3, telling you where his boss went'},
            {t = 'chat', re = 'My m%-most humble apologies%.', why = 'Lathuya 715 (say #8910)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to aht urhgan whitegate and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 716, why = "Lathuya 716: plays only at Prog 4, runs quest:complete (replays if Magus Charuq's cannot be given)"}}},
    },
}
