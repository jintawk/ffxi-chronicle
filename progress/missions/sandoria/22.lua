-- Step progress for Breaking Barriers (San d'Oria mission 9-1, mission id 22). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/sandoria/9_1_Breaking_Barriers.lua; key items 483 figure of Titan, 482 figure of Garuda and
-- 481 figure of Leviathan (res/key_items.lua, used by no other script); Batallia Downs zone text SENSE_SOMETHING_LURKING (IDs.lua, 7454).
-- The Great Hall door (_6h4, zone 233) plays 32 at status 0 (-> 1) and 76 at status 4 with all three figures (completes, takes them);
-- the ??? in Valley of Sorrows (zone 128, event 0, status 1 -> 2), Xarcabard (zone 112, event 12, status 2 -> 3) and Batallia Downs (zone
-- 105: "You sense something lurking close by!" when the two Suparna spawn at status 3, then event 904 once they are dead, status 3 -> 4)
-- each give one figure. The figures are intermediate key items, taken at the end. None of these event ids is used by another script in
-- those zones, and none has a decoded body, so the ids come from LandSandBoat. Bullet 1 is the optional-steps preface.
return {
    title = 'Breaking Barriers',
    completes = 's13',
    known = {{t = 'mission', line = 'sandoria', min = 22}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'optional the following are optional steps'}},
        {id = 's2', at = {n = 2, fp = 'go to the chateau and check'},
         done = {
            {t = 'event', zone = 233, event = 32, why = 'Door: Great Hall 32 (status 0, LandSandBoat)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'you must now travel to 3'}},
        {id = 's4', at = {n = 4, fp = 'in valley of sorrows if you'},
         done = {
            {t = 'event', zone = 128, event = 0, why = 'Valley of Sorrows ??? 0 (status 1, LandSandBoat)'},
            {t = 'ki', id = 483, gained = true, why = 'figure of Titan obtained'},
            {t = 'ki_have', id = 483, have = true, why = 'figure of Titan held'},
            {t = 'chat', re = 'obtained key item: figure of titan', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'head for xarcabard and go to'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'the is in a group of'}},
        {id = 's7', at = {n = 7, fp = 'select the to obtain the figure'},
         done = {
            {t = 'event', zone = 112, event = 12, why = 'Xarcabard ??? 12 (status 2, LandSandBoat)'},
            {t = 'ki', id = 482, gained = true, why = 'figure of Garuda obtained'},
            {t = 'ki_have', id = 482, have = true, why = 'figure of Garuda held'},
            {t = 'chat', re = 'obtained key item: figure of garuda', why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'head for the southern eldieme necropolis'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'make your way to the southern'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'now on map 2 follow the'}},
        {id = 's11', at = {n = 11, fp = 'check the j 11 near the'},
         done = {
            {t = 'chat', re = 'You sense something lurking close by!', why = 'the ??? checked, Suparna and Suparna Fledgling spawn (Batallia Downs text 7454)'},
         }},
        {id = 's12', at = {n = 12, fp = 'defeat both nms once the corpses'},
         done = {
            {t = 'event', zone = 105, event = 904, why = 'Batallia Downs ??? 904 (status 3, both NMs dead; LandSandBoat)'},
            {t = 'ki', id = 481, gained = true, why = 'figure of Leviathan obtained'},
            {t = 'ki_have', id = 481, have = true, why = 'figure of Leviathan held'},
            {t = 'chat', re = 'obtained key item: figure of leviathan', why = 'chat: key item obtained'},
         }},
        {id = 's13', at = {n = 13, fp = 'head back to the chateau and'},
         done = {
            {t = 'mission', line = 'sandoria', eq = 22, completed = true, why = 'mission log: Breaking Barriers completed'},
            {t = 'event', zone = 233, event = 76, why = 'Door: Great Hall 76 (status 4 with the three figures, completes; LandSandBoat)'},
         }},
    },
}
