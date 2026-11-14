-- Step progress for Save My Sister (Jeuno quest 1). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Save_My_Sister.lua (the quest is never begun: it is only completed, so the log
-- shows nothing before the end; Baudin 172 at Prog 0, Mailloquetat 159, Baudin 105 at Prog 1, Neraf-Najiruf 98 at Prog 2
-- gives the Ducal Guard's lantern with option 0, Baudin 27 plays at Prog 3, the four Brazier examinations are all event 44
-- (right or wrong order alike, so it only counts as a reach once the lantern is held) and are told apart only by the zone's message, Baudin 107 at Prog 4 runs quest:complete but the reward includes the Holy
-- Mace, so 107 also plays when the bag is full and is only a reach: the log's completed bit proves the last step; Baudin 176
-- plays once completed; Neraf-Najiruf 97 takes the lantern back once completed). Mailloquetat 158 (any later talk) is not
-- used: LandSandBoat plays it after Baudin 172 as well, so it does not prove the cutscene. Client event scripts S4
-- 244_Baudin_010F4013.txt (172 say #7346, 27 say #7370, 176 say #7418), 244_Mailloquetat_010F4015.txt (159 has no text) and
-- 243_Neraf_Najiruf_010F3010.txt (98: the menu's Yes branch says #10240, 99 say #10242, 97 say #10245); the Brazier messages are
-- LandSandBoat's (zones/The_Eldieme_Necropolis/IDs.lua THE_LIGHT_IS_FULLY_LIT 7398, only the fourth correct examination). Key item 48 from res/key_items.lua. The travel bullet
-- (n=5) is a note on the brazier step. Not repeatable.
return {
    title = 'Save My Sister',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's7'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to baudin to begin this'},
         done = {
            {t = 'event', zone = 244, event = 172, why = 'Baudin 172: the first talk, only at Prog 0'},
            {t = 'chat', re = "I don't like to show her like this, but I don't know what to do anymore%.", why = 'Baudin 172 (say #7346)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to mailloquetat h 9 for'},
         done = {
            {t = 'event', zone = 244, event = 159, why = 'Mailloquetat 159: the cutscene, only at Prog 0'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to baudin'},
         done = {
            {t = 'event', zone = 244, event = 105, why = 'Baudin 105: only at Prog 1'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to neraf najiruf ru lude'},
         done = {
            {t = 'ki', id = 48, gained = true, why = "Ducal Guard's lantern obtained (Neraf-Najiruf 98, option 0)"},
            {t = 'ki_have', id = 48, have = true, why = "Ducal Guard's lantern held"},
            {t = 'chat', re = "obtained key item: ducal guard's lantern", why = 'chat: key item obtained'},
            {t = 'chat', re = 'I seem to remember there were four torches', why = 'Neraf-Najiruf 98, Yes branch only (say #10240)'},
            {t = 'event', zone = 244, event = 27, conf = 'inferred', why = 'Baudin 27: plays only at Prog 3, after the lantern'},
            {t = 'chat', re = 'Oh, you think that could cure her%?', conf = 'inferred', why = 'Baudin 27 (say #7370)'},
            {t = 'event', zone = 243, event = 99, conf = 'inferred', why = 'Neraf-Najiruf 99: plays only from Prog 3'},
            {t = 'chat', re = "Don't forget it's the stone%-wrought room", conf = 'inferred', why = 'Neraf-Najiruf 99 (say #10242)'},
         },
         reach = {{t = 'event', zone = 243, event = 98, why = 'Neraf-Najiruf 98 offered (its finish needs option 0)'}}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'enter eldieme necropolis from batallia downs'}},
        {id = 's6', at = {n = 6, fp = 'you must find and examine the'},
         done = {
            {t = 'chat', re = "ducal guard's lantern is fully lit!", why = 'Eldieme Necropolis text 7398: the fourth Brazier lit in order'},
         },
         reach = {{t = 'event', zone = 195, event = 44, after = 's4', why = 'Brazier 44 (every examination, right or wrong order; counts once the lantern is held)'}}},
        {id = 's7', at = {n = 7, fp = 'return to baudin obtain reward and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 244, event = 176, conf = 'inferred', why = 'Baudin 176: plays only once completed'},
            {t = 'chat', re = "Looks like she's okay now%.", conf = 'inferred', why = 'Baudin 176 (say #7418)'},
         },
         reach = {{t = 'event', zone = 244, event = 107, why = 'Baudin 107 (also plays when the Holy Mace cannot be given)'}}},
        {id = 's8', kind = 'post', at = {n = 8, fp = 'speak to neraf najiruf'},
         done = {
            {t = 'event', zone = 243, event = 97, after = 's7', why = "Neraf-Najiruf 97: takes the Ducal Guard's lantern back"},
            {t = 'chat', re = "Oh, the flame thing didn't work, huh%?", why = 'Neraf-Najiruf 97 (say #10245)'},
            {t = 'ki', id = 48, gained = false, after = 's7', conf = 'inferred', why = "Ducal Guard's lantern handed over"},
         }},
    },
}
