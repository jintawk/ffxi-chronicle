-- Step progress for An Undying Pledge (Outlands quest 149). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Norg/npcs/Stray_Cloud.lua (225 starts the quest with no menu and adds it on finish; 228 is his
-- talk while the char var is 1 and 229 while it is 2; 227 plays once the Caliginous Blade (715) is held and completes the quest
-- and takes the blade, but gives the Light Buckler only with room, so it is inferred and the log's completed bit and the blade
-- being taken prove the step; 230 plays once the quest is done). LandSandBoat has no script for the Sea Serpent Grotto cutscene,
-- ???s or Glyryvilu, so bullets 2 to 4 have no signal and are notes on bullet 5, which the Caliginous Blade key item (temporary,
-- used by this quest only) proves. Client event scripts S4 252_Stray_Cloud_010FC06B.txt (228 say #11188, 229 say #11227,
-- 230 say #11252; 225 has no line) and 252_Stray_Cloud_010FC074.txt (227, no line). The quest log is set at s1, so it is not
-- silent. Not repeatable.
-- Draft corrections: the completed bit and event 227 were on bullet 5 (they belong to the reward bullet 6, now a step) and
-- 227 was on bullet 1; 229 is not used for bullet 2 because nothing in LandSandBoat sets the var it tests.
return {
    title = 'An Undying Pledge',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to stray cloud for a'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Stray Cloud 225)'},
            {t = 'event', zone = 252, event = 225, why = 'Stray Cloud 225: starts the quest, no menu'},
            {t = 'event', zone = 252, event = 228, conf = 'inferred', why = 'Stray Cloud 228: his talk, only while accepted (var 1)'},
            {t = 'chat', re = "I've heard the monsters out there are no laughin' matter, so please be takin' care of yerself%.", conf = 'inferred', why = 'Stray Cloud 228 (say #11188)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head towards sea serpent grotto you'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'once inside sea serpent grotto head'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'check the to spawn glyryvilu'}},
        {id = 's5', at = {n = 5, fp = 'defeat glyryvilu then check the again'},
         done = {
            {t = 'ki', id = 715, gained = true, why = 'Caliginous Blade obtained'},
            {t = 'ki_have', id = 715, have = true, why = 'Caliginous Blade held'},
            {t = 'chat', re = 'obtained key item: caliginous blade', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to stray cloud for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 715, gained = false, after = 's5', why = 'Caliginous Blade taken (only when the quest completes)'},
            {t = 'event', zone = 252, event = 227, after = 's5', conf = 'inferred', why = 'Stray Cloud 227: also plays on a full bag'},
            {t = 'event', zone = 252, event = 230, after = 's5', conf = 'inferred', why = 'Stray Cloud 230: his talk once the quest is done'},
            {t = 'chat', re = "I was able to ge' closure with Gomoya, and it's all thanks t' you%.", after = 's5', conf = 'inferred', why = 'Stray Cloud 230 (say #11252)'},
         }},
    },
}
