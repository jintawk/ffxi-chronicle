-- Step progress for Behind the Smile (Other Areas quest 77). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Behind_the_Smile.lua (Enaremand 533 is a plain cutscene that begins the
-- quest; Fyi Chalmwoh 320 in Mhaura plays once while Prog is 0; the ??? in Carpenters' Landing spawns Bullheaded Grosvez and,
-- after the kill, gives the Red oil; Enaremand 534 with the Red oil runs quest:complete and takes it, but the event also plays
-- when the reward cannot be given, so only the quest log's completed bit proves the last step and 534 is the `reach`; while
-- accepted without the oil Enaremand plays 541). Client event scripts S4 026_Enaremand_0101A07F.txt (533, 534 bare; 541 say
-- #11145) and 249_Fyi_Chalmwoh_010F906F.txt (320 bare). Travel and spawn bullets are notes on the oil step. The quest log
-- is set at s1, so it is not silent.
return {
    title = 'Behind the Smile',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to enaremand j 7 home'},
         done = {
            {t = 'event', zone = 26, event = 533, why = 'Enaremand 533: the offer cutscene (no menu, begins the quest)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 541, conf = 'inferred', why = 'Enaremand 541: plays only while accepted'},
            {t = 'chat', re = 'I thought that in a p%-place like this, I m%-m%-m%-might be able to hide from the r%-ridicule of the w%-world%.', conf = 'inferred', why = 'Enaremand 541 (say #11145)'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to mhaura kolshushu to talk'},
         done = {
            {t = 'event', zone = 249, event = 320, why = 'Fyi Chalmwoh 320: plays only while accepted with Prog 0'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'go to carpenters landing where you'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'go to i 10 where you'}},
        {id = 's5', at = {n = 5, fp = 'after you ve defeated bullheaded grosvez'},
         done = {
            {t = 'ki', id = 704, gained = true, why = 'red oil obtained'},
            {t = 'ki_have', id = 704, have = true, why = 'red oil held'},
            {t = 'chat', re = 'obtained key item: red oil', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'go back to the tavnazian safehold'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 704, gained = false, conf = 'inferred', why = 'red oil handed over'},
         },
         reach = {{t = 'event', zone = 26, event = 534, why = 'Enaremand 534: the oil handed in (also plays when the reward cannot be given)'}}},
    },
}
