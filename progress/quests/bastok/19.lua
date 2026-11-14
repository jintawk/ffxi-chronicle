-- Step progress for Fallen Comrades (Bastok quest 19). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Fallen_Comrades.lua (Pavvke 90 begins it at Bastok fame 2; trading one Silver
-- Name Tag is event 91 the first time and 92 on a repeat, each running quest:complete and paying 550 gil, no reward item);
-- client event script S4 234_Pavvke_010EA037.txt (90 say #10758, 91 and 92 both end on say #10776). The quest is repeatable
-- (page meta), but a repeat is the trade alone (92), with no talk that opens a second run, so there is no `repeatable` entry
-- (the draft guessed a restart on s1). Bullets 2 and 3 (where the tags come from, one at a time) are notes on the trade.
-- The quest log is set at s1, so it is not silent.
return {
    title = 'Fallen Comrades',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to pavvke who asks of'},
         done = {
            {t = 'event', zone = 234, event = 90, why = 'Pavvke 90'},
            {t = 'chat', re = "I thought I told you I don't want any help, I%-%-", why = 'Pavvke 90 (say #10758)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'silver name tags can be bought'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'since the tags are rare you'}},
        {id = 's4', at = {n = 4, fp = 'trade it to him for your'},
         done = {
            {t = 'event', zone = 234, event = 91, why = 'Pavvke 91: the name tag trade'},
            {t = 'event', zone = 234, event = 92, why = 'Pavvke 92: the name tag trade on a repeat'},
            {t = 'chat', re = 'There should be others where you found this one%.', why = 'Pavvke 91 and 92 (say #10776)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
