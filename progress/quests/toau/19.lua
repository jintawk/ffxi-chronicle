-- Step progress for What Friends Are For (Aht Urhgan quest 19). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/What_Friends_Are_For.lua (Tsetseroon 4 is the plain greeting at Prog 0; the
-- trigger area in Aydeewa Subterrane plays 7 at Prog 0 and sets Prog 1; Tsetseroon 16 at Prog 1 begins the quest (no option), so
-- the log stays silent until the third bullet; while accepted his talk is 17 at Prog 2 and 19 at Prog 3; trading exactly a Tin Ore
-- and a Cobalt Jellyfish plays 18 and hands over the Pot of Tsetseroon's stew (key item 796); the ??? plays 8 only at Prog 3 with
-- the stew in hand and takes it; Tsetseroon 20 at Prog 4 runs quest:complete, whose reward is an Imperial Bronze Piece (or the map
-- when the bronze piece branch is not taken), so 20 replays on a full bag and is only a reach: the completed bit proves the last
-- bullet. The draft put events 18, 16 and 17 on the last bullet and event 7 on the ??? bullet; event 7 is the zone-in cutscene of
-- bullet 2 and 8 is the ??? of bullet 5. Event 21 (his talk once completed) and the map key item (reward, may already be owned)
-- are not used. The last bullet is the alternative reward, a note on the completion. Client event script S4
-- 053_Tsetseroon_01035029.txt (4 say #10511, 17 say #10530, 19 say #10539); events 7, 8, 16, 18 and 20 have no text.
return {
    title = 'What Friends Are For',
    completes = 's6',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to tsetseroon to begin this'},
         done = {
            {t = 'event', zone = 53, event = 4, why = 'Tsetseroon 4: his greeting while the quest is not begun (Prog 0)'},
            {t = 'chat', re = 'Tsetseroon so looonely%.', why = 'Tsetseroon 4 (say #10511)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to wajaom woodlands d 9'},
         done = {
            {t = 'event', zone = 68, event = 7, why = 'Aydeewa Subterrane trigger area 7: plays only at Prog 0, sets Prog 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to tsetseroon to offically begin'},
         done = {
            {t = 'event', zone = 53, event = 16, why = 'Tsetseroon 16: plays only at Prog 1, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade tsetseroon a tin ore and'},
         done = {
            {t = 'event', zone = 53, event = 18, why = 'Tsetseroon 18: the exact trade accepted, only at Prog 2'},
            {t = 'ki', id = 796, gained = true, why = "pot of Tsetseroon's stew obtained"},
            {t = 'ki_have', id = 796, have = true, why = "pot of Tsetseroon's stew held"},
            {t = 'chat', re = "obtained key item: pot of tsetseroon's stew", why = 'chat: key item obtained'},
         },
         reach = {
            {t = 'event', zone = 53, event = 17, why = 'Tsetseroon 17: his talk at Prog 2, asking for the ore and the jellyfish'},
            {t = 'chat', re = 'Tsetseroon block his Treasooor Huntooor', why = 'Tsetseroon 17 (say #10530)'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to aydeewa subterrane g 10'},
         done = {
            {t = 'event', zone = 68, event = 8, why = 'the ??? 8: plays only at Prog 3 with the stew in hand, takes it'},
            {t = 'ki', id = 796, gained = false, conf = 'inferred', why = "pot of Tsetseroon's stew handed over"},
         },
         reach = {
            {t = 'event', zone = 53, event = 19, why = 'Tsetseroon 19: his talk at Prog 3, asking for the stew to be taken to the smell'},
            {t = 'chat', re = 'Yooo bring stooo to place that smell like Wawaroon', why = 'Tsetseroon 19 (say #10539)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to tsetseroon for an imperial'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 53, event = 20, why = 'Tsetseroon 20: plays only at Prog 4 (replays if the Imperial Bronze Piece cannot be given)'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'if you chose not to look'}},
    },
}
