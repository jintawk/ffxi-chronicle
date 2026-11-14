-- Step progress for The Root of the Problem (Windurst quest 68). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Heavens_Tower/npcs/Chumimi.lua (276 offers and adds the quest with no option test, 277 is
-- her talk while the Silk Cloth is owed, 279 gives the Sluice Surveyor Mk. I, 281 pays the Wizard's Petasos and completes only if
-- the item can be given, so it is a reach and the quest log carries the last step); zones/Windurst_Walls/npcs/Koru-Moru.lua (348 is
-- his talk before the trade and plays whether or not the cloth is held, so it is a reach; 349 plays only for the accepted
-- trade); zones/Toraimarai_Canal/npcs/qm10.lua (46 the cutscene asking for black power, 47 the same with Manafont active),
-- qm11.lua (48 offers the Magic Sludge fight and also plays on a declined option, 55 plays only after the kill) and the mob
-- Magic_Sludge.lua (its death moves the quest on). Client event script S4 239_Koru_Moru_010EF021.txt (349 say #8325, #8326);
-- Chumimi's and the canal's scripts are not decoded, so those events rest on LandSandBoat. The two ??? points of bullets 5
-- and 6 share event 42 (the second point plays it again once done), so they are notes on the step they lead into. Bullets
-- 8 and 9 (the Magic Sludge fight: event 48 also plays on a declined option and no event marks the kill but 55, which proves
-- bullet 10) and 12 to 15 (the optional Kupipi and Gate of Earth cutscenes) have no event in this quest's scripts: plain bullets.
-- Key item 180 from res/key_items.lua. Repeatable after a memory reset: Chumimi 276 opens the next run. The quest log is set
-- at s1, so it is not silent.
return {
    title = 'The Root of the Problem',
    completes = 's11',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'begin quest by speaking with chumimi'},
         done = {
            {t = 'event', zone = 242, event = 276, why = 'Chumimi 276: the quest begins'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 242, event = 277, conf = 'inferred', why = 'Chumimi 277: reminder, only once accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'after the cutscene trade a silk'},
         done = {
            {t = 'event', zone = 239, event = 349, why = 'Koru-Moru 349: the Silk Cloth accepted'},
            {t = 'chat', re = 'This should fix the doll%-doddily%-do%.', why = 'Koru-Moru 349 (say #8325)'},
         },
         reach = {{t = 'event', zone = 239, event = 348, why = 'Koru-Moru 348: asks for the Silk Cloth'}}},
        {id = 's3', at = {n = 3, fp = 'return to chumimi afterwards to receive'},
         done = {
            {t = 'event', zone = 242, event = 279, why = 'Chumimi 279'},
            {t = 'ki', id = 180, gained = true, why = '"Sluice Surveyor Mk. I" obtained'},
            {t = 'ki_have', id = 180, have = true, why = '"Sluice Surveyor Mk. I" held'},
            {t = 'chat', re = 'obtained key item: "sluice surveyor mk%. i"', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'proceed to toraimarai canal and locate'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'the first is in the north'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'the second is at i 9'}},
        {id = 's7', at = {n = 7, fp = 'at one of the you ll'},
         done = {
            {t = 'event', zone = 169, event = 46, why = 'Toraimarai Canal 46: the cutscene asking for black power'},
            {t = 'event', zone = 169, event = 47, why = 'Toraimarai Canal 47: the same point with Manafont active'},
         }},
        {id = 's10', at = {n = 10, fp = 'click the again for another cutscene'},
         done = {
            {t = 'event', zone = 169, event = 55, why = 'Toraimarai Canal 55: the ??? after the kill'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to chumimi for the final'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 180, gained = false, conf = 'inferred', why = '"Sluice Surveyor Mk. I" handed over'},
         },
         reach = {{t = 'event', zone = 242, event = 281, why = 'Chumimi 281 (completion needs a free slot for the reward)'}}},
    },
}
