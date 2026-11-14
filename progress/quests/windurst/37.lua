-- Step progress for Making Headlines (Windurst quest 37). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Naiko-Paneiko.lua (665 is the offer and adds the quest on any
-- outcome; 666 and 671 are reminders and 673 plays only once all four scoops are in and the door is not yet confirmed; 674
-- and 670 are the finish, completeQuest with gil and a title only, so it cannot fail), Port_Windurst/npcs/Yujuju.lua (314
-- gives the Port Windurst scoop), Windurst_Walls/npcs/Hiwon-Biwon.lua (281, 283 or 284 give the Walls scoop), Windurst_Waters/
-- npcs/Kyume-Romeh.lua (668), Windurst_Woods/npcs/Umumu.lua (381 gives the Woods scoop; 383 plays only after the door), and
-- Inner_Horutoto_Ruins/npcs/_5ca.lua (the Mahogany Door has no event, only the zone text "lies behind this door", under the
-- same conditions as 673 plus the door not yet confirmed; check_steps warns that its text sits in another zone's IDs.lua, which is expected). Bullet 2 is four collections in any order, so no single scoop
-- proves it: each one is `reach`, and Naiko's 673 (only possible with all four) proves it. Bullet 3 is that same 673 talk
-- (and the travel that follows), so it is a note on the door step; the travel bullets 4 and 5 are notes too. Client event
-- scripts S4 240_Yujuju_010F006D.txt (314 say #3933), 241_Umumu_010F1089.txt (381 say #8433, 383 say #8439); key item ids from
-- res/key_items.lua (40 Waters, 41 Walls, 42 Port, 43 Woods scoop). The draft's per-scoop done matchers would have ticked
-- bullet 2 on the first scoop; its Hiwon-Biwon 284 also plays during Curses, Foiled Again!, a different quest.
return {
    title = 'Making Headlines',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to naiko paneiko in southern'},
         done = {
            {t = 'event', zone = 238, event = 665, why = 'Naiko-Paneiko 665: adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 666, conf = 'inferred', why = 'Naiko-Paneiko 666: reminder, only while accepted'},
            {t = 'event', zone = 238, event = 671, conf = 'inferred', why = 'Naiko-Paneiko 671: reminder, only while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to the following npcs to'},
         done = {
            {t = 'event', zone = 238, event = 673, why = 'Naiko-Paneiko 673: plays only with all four scoops in'},
         },
         reach = {
            {t = 'event', zone = 240, event = 314, why = 'Yujuju 314: the Port Windurst scoop'},
            {t = 'chat', re = 'Darn%. I needed more time to come up with a better story', why = 'Yujuju 314 (say #3935; 340, his default talk, shares the first line)'},
            {t = 'ki', id = 42, gained = true, why = 'Port Windurst scoop obtained'},
            {t = 'ki', id = 41, gained = true, why = 'Windurst Walls scoop obtained'},
            {t = 'ki', id = 40, gained = true, why = 'Windurst Waters scoop obtained'},
            {t = 'ki', id = 43, gained = true, why = 'Windurst Woods scoop obtained'},
            {t = 'event', zone = 239, event = 281, why = 'Hiwon-Biwon 281: the Walls scoop'},
            {t = 'event', zone = 238, event = 668, why = 'Kyume-Romeh 668: the Waters scoop'},
            {t = 'event', zone = 241, event = 381, why = 'Umumu 381: the Woods scoop'},
            {t = 'chat', re = "So%.%.%.you've found me, huh%?", why = 'Umumu 381 (say #8433)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'return to naiko paneiko he will'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'enter from east sarutabaruta j 7'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'examine the cracked wall at g'}},
        {id = 's6', at = {n = 6, fp = 'examine the mahogany door at g'},
         done = {
            {t = 'chat', re = "that Cat Burglar's hideout lies behind this door", why = 'Mahogany Door (zone text 7287): the story confirmed'},
            {t = 'event', zone = 241, event = 383, conf = 'inferred', why = 'Umumu 383: plays only once the door is confirmed'},
            {t = 'chat', re = 'I knew it! My sources were correctaru!', conf = 'inferred', why = 'Umumu 383 (say #8439)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to naiko paneiko to finish'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 238, event = 674, why = 'Naiko-Paneiko 674: the finish'},
            {t = 'event', zone = 238, event = 670, why = 'Naiko-Paneiko 670: the finish'},
         }},
    },
}
