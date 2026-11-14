-- Step progress for Stamp Hunt (Bastok quest 16). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Stamp_Hunt.lua (Arawn 225 gives the Stamp Sheet and begins the quest; the seven
-- guards set one Prog bit each, events 227, 86, 85, 725, 726, 121 and 120, which the client never shows as a whole; Arawn 226 runs
-- quest:complete, which also gives the Leather Gorget, and only then takes the sheet); client event script S4
-- 235_Arawn_010EB006.txt (225 say #7519, 226 say #7524); key item 102 from res/key_items.lua. Bullets 3 to 9 are the guards,
-- indented, so not steps; bullet 2 (collect the stamps) has no signal of its own and is a note on the hand-in. Full-inventory
-- rule: 226 plays the same with a full bag, so it is `reach` only; the quest log and the loss of the sheet (deleted only after
-- the completion succeeded) prove s10. The quest log is set at s1, so it is not silent.
return {
    title = 'Stamp Hunt',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to arawn to start quest'},
         done = {
            {t = 'event', zone = 235, event = 225, why = 'Arawn 225'},
            {t = 'chat', re = "Emrys is bragging how he's already finished collecting all his stamps!", why = 'Arawn 225 (say #7519)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 102, gained = true, why = 'stamp sheet obtained'},
            {t = 'ki_have', id = 102, have = true, why = 'stamp sheet held'},
            {t = 'chat', re = 'obtained key item: stamp sheet', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's10', at = {n = 2, fp = 'speak to the following 7 guards'}},
        {id = 's10', at = {n = 10, fp = 'speak to arawn again once you'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 102, gained = false, why = 'stamp sheet handed over (taken only after the completion succeeded)'},
         },
         reach = {{t = 'event', zone = 235, event = 226, why = 'Arawn 226 (also plays with a full bag, the Leather Gorget may not fit)'}}},
    },
}
