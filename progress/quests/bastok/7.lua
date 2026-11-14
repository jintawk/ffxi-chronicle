-- Step progress for The Eleventh's Hour (Bastok quest 7). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Elevenths_Hour.lua (Elki 43 is the offer and only option 1 begins the quest;
-- the Old Toolbox event 23 asks twice and only option 0 of the second menu adds key item 24; Elki 44 plays only while key item 24
-- is held and sets Prog 1; Babenn 45 plays only at Prog 1 and runs quest:complete, deleting the key item after the completion
-- succeeded); client event scripts S4 234_Elki_010EA017.txt (43 say #10665 on the Help branch only, 44 say #10668),
-- 143_Old_Toolbox_0108F19E.txt (23) and 234_Babenn_010EA026.txt (45, no text); key item ids from res/key_items.lua (24 old
-- toolbox). The draft put Elki 44 on the first Elki bullet, but it needs the toolbox, so it belongs to the return visit; the
-- toolbox's "You find one with a name engraved" line plays before the take-it menu, so it is only a reach. Parraggoh 46 and
-- Pavvke 48 are idle lines, not used.
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish after the
-- cutscene), so it is a reach only and the quest log's completed bit and the toolbox's removal carries the last step.
return {
    title = "The Eleventh's Hour",
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 'n1', kind = 'note', with = 's2', at = {n = 1, fp = 'after just completing hearts of mythril'}},
        {id = 's2', at = {n = 2, fp = 'speak to elki to start quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (only option 1 begins it)'},
            {t = 'chat', re = 'If you find anything out, please tell me right away%.', why = 'Elki 43, Help branch only (say #10665)'},
         },
         reach = {{t = 'event', zone = 234, event = 43, why = 'Elki 43 offered (its finish needs option 1)'}}},
        {id = 'n3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to the top floor of'}},
        {id = 's4', at = {n = 4, fp = 'examine the old toolbox at the'},
         done = {
            {t = 'ki', id = 24, gained = true, why = 'old toolbox obtained'},
            {t = 'ki_have', id = 24, have = true, why = 'old toolbox held'},
            {t = 'chat', re = 'obtained key item: old toolbox', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 143, event = 23, why = 'Old Toolbox 23 offered (taking it needs option 0 of the second menu)'}}},
        {id = 's5', at = {n = 5, fp = 'return to elki and speak to'},
         done = {
            {t = 'event', zone = 234, event = 44, why = 'Elki 44: plays only while the old toolbox is held'},
            {t = 'chat', re = "The eleventh pioneer's name was%.%.%.Vigilant Owl%?", why = 'Elki 44 (say #10668)'},
         }},
        {id = 's6', at = {n = 6, fp = 'after the cutscene speak to babenn'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 24, gained = false, why = 'old toolbox removed (only after the completion succeeded)'},
         },
         reach = {
            {t = 'event', zone = 234, event = 45, why = 'Babenn 45: only at Prog 1, plays even when the reward item does not fit'},
         }},
    },
}
