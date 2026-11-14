-- Step progress for Magicite (San d'Oria mission 4-1, mission id 13). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/4_1_Magicite.lua; client event lists S4 243_Nelcabrit_010F3001.txt (36, "At long
-- last you return!"), 245_Aldo_010F5007.txt (152); key items 56 (archducal audience permit), 22 (letter to Aldo), 14 / 15 / 16
-- (Magicite: Optistone / Aurastone / Orastone) from res/key_items.lua.
-- This mission starts in Ru'Lude Gardens, not at a gate guard. Event 130 at the Door: San d'Orian Emb. is a menu that can be cancelled
-- (a cancelled event leaves the mission unstarted), so it is not used; the accept is proved by the nation line moving to id 13
-- (completed = false, run1 as in the pilot) or by the archducal audience permit being handed out (a permanent key item that a
-- repeating character may already hold, hence only supporting alone). Door: Audience Chamber 128 (243, status 1) gives the letter to
-- Aldo (KI 22); Aldo 152 (Lower Jeuno 245, status 2) takes it and gives the silver bell (which may already be held, so it is not used);
-- Door: Audience Chamber 60 (243, only with all three Magicite key items held) takes them and pays the reward; Nelcabrit 36
-- (status 4) completes. The doors have no client script; their ids are LandSandBoat's. Bullet 4 ("obtain the 3 Magicite") has no single
-- signal, so it is an unproved bullet shown done once event 60 is seen. The three Magicite pickups (bullets 40, 50, 54, any order)
-- are branch bullets proved by their key item gain only (they sit after the completing step on the page, so `implies` from the
-- earlier steps would show the completion as inferred before it is seen).
-- The Magicite events themselves (event 0 in Monastic Cavern 150 and Qulun Dome 148, 44 in the Altar Room 152) are not used: a
-- key item gain says the same without the generic event 0. The draft knew none of the doors and guessed the completion.
return {
    title = 'Magicite',
    completes = 's6',
    known = {{t = 'mission', line = 'sandoria', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'to flag the mission speak with'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 13, completed = false, run1 = true, why = 'mission line: current mission = Magicite'},
            {t = 'ki', id = 56, gained = true, conf = 'inferred', why = 'archducal audience permit handed out on the accept'},
         }},
        {id = 's2', at = {n = 2, fp = 'click on the door audience chamber'},
         done = {
            {t = 'event', zone = 243, event = 128, why = 'Door: Audience Chamber 128: the letter to Aldo (status 1, LandSandBoat)'},
            {t = 'ki', id = 22, gained = true, why = 'letter to Aldo obtained'},
            {t = 'chat', re = 'obtained key item: letter to aldo', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to aldo in lower jeuno'},
         done = {
            {t = 'event', zone = 245, event = 152, why = 'Aldo 152: the letter handed in (status 2)'},
            {t = 'ki', id = 22, gained = false, conf = 'inferred', why = 'letter to Aldo handed over'},
         }},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'obtain the 3 magicite key items'}, done = {}},
        {id = 's5', at = {n = 5, fp = 'click the audience chamber in ru'},
         done = {
            {t = 'event', zone = 243, event = 60, why = 'Door: Audience Chamber 60: the three Magicite handed in (LandSandBoat)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to nelcabrit in the san'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 13, completed = true, why = 'mission log: Magicite completed'},
            {t = 'event', zone = 243, event = 36, why = 'Nelcabrit 36: completes (status 4)'},
            {t = 'chat', re = 'At long last you return! Congratulations on your success!', why = 'Nelcabrit 36 (say #10180)'},
         }},
        {id = 's40', kind = 'branch', at = {n = 40, fp = 'inside there will not be any'},
         done = {
            {t = 'ki', id = 14, gained = true, why = 'Magicite: Optistone obtained'},
            {t = 'chat', re = 'obtained key item: magicite: optistone', why = 'chat: key item obtained'},
         }},
        {id = 's50', kind = 'branch', at = {n = 50, fp = 'proceed forward and click on the'},
         done = {
            {t = 'ki', id = 16, gained = true, why = 'Magicite: Orastone obtained'},
            {t = 'chat', re = 'obtained key item: magicite: orastone', why = 'chat: key item obtained'},
         }},
        {id = 's54', kind = 'branch', at = {n = 54, fp = 'there are no monsters in here'},
         done = {
            {t = 'ki', id = 15, gained = true, why = 'Magicite: Aurastone obtained'},
            {t = 'chat', re = 'obtained key item: magicite: aurastone', why = 'chat: key item obtained'},
         }},
    },
}
