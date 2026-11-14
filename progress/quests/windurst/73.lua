-- Step progress for Fire and Brimstone (Windurst quest 73). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Perih_Vashai.lua (531 begins the quest with no option test and sets the
-- stage to 1; 532 is her talk at stages 1 to 3; 535 at stage 4 sets stage 5 and 536 is her talk at stage 5; trading the Old
-- Earring is event 537, which only completes if npcUtil.completeQuest can pay the Hunter's Beret, so it is a reach and the quest
-- log carries the last step), zones/Mhaura/npcs/Koh_Lenbalalako.lua (10007 at stage 1 chains into 10032 and sets stage 2),
-- zones/The_Eldieme_Necropolis/Zone.lua (the zone-in cutscene 4 at stage 2 sets stage 3) and npcs/Gravestone.lua (event 5 at
-- stage 3 sets stage 4); globals/job_utils/ranger.lua (the Old Earring only drops from Scavenge in the Oztroja pool at stage 5);
-- client event script S4 241_Perih_Vashai_010F1076.txt (532 say #9309, #9310; 536 say #9326 to #9328). Bullet 6 is the cutscene
-- of 535, a note on bullet 5; bullet 7 (Oztroja and Scavenge) has no event or text of its own and is a note on the trade.
-- Repeatable after a memory reset (page meta): Perih Vashai 531 opens the next run. The quest log is set at s1, so it is not
-- silent.
return {
    title = 'Fire and Brimstone',
    completes = 's8',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to perih vashai in windurst'},
         done = {
            {t = 'event', zone = 241, event = 531, why = 'Perih Vashai 531: the quest begins'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 241, event = 532, conf = 'inferred', why = 'Perih Vashai 532: her talk at stages 1 to 3, only once accepted'},
            {t = 'chat', re = "I have learned that one who knows of the fate of the sinner's daughter can be found in the Blacksmiths' Guild of Mhaura%.", conf = 'inferred', why = 'Perih Vashai 532 (say #9309)'},
         }},
        {id = 's2', at = {n = 2, fp = 'in mhaura head to f 9'},
         done = {
            {t = 'event', zone = 249, event = 10007, why = 'Koh Lenbalalako 10007'},
            {t = 'event', zone = 249, event = 10032, why = 'Koh Lenbalalako 10032: chained after 10007'},
         }},
        {id = 's3', at = {n = 3, fp = 'enter eldieme necropolis through batallia downs'},
         done = {
            {t = 'zonein', zone = 195, event = 4, why = 'Eldieme Necropolis zone-in cutscene 4 (stage 2)'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to g 9 and examine'},
         done = {
            {t = 'event', zone = 195, event = 5, why = 'Eldieme Necropolis Gravestone 5 (stage 3)'},
         }},
        {id = 's5', at = {n = 5, fp = 'after the cutscene head back to'},
         done = {
            {t = 'event', zone = 241, event = 535, why = 'Perih Vashai 535 (stage 4)'},
            {t = 'event', zone = 241, event = 536, conf = 'inferred', why = 'Perih Vashai 536: her talk at stage 5, only after 535'},
            {t = 'chat', re = "In the time of the Great War, the warriors held in Oztroja were forced to fight with Yagudo in a hall on the castle's highest floor%.", conf = 'inferred', why = 'Perih Vashai 536 (say #9326)'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'you will get another cutscene with'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'the next step in castle oztroja'}},
        {id = 's8', at = {n = 8, fp = 'take the old earring and trade'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 241, event = 537, why = 'Perih Vashai 537 (completion needs a free slot for the reward)'}}},
    },
}
