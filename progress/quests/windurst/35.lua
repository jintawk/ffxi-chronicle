-- Step progress for To Bee or Not to Bee? (Windurst quest 35). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Walls/npcs/{Raamimi,Zayhi-Bauhi,Kalupa-Tawalupa,Rutango-Botango}.lua. Raamimi 67 is
-- the offer and its finish adds the quest and the Honey only with a free slot (otherwise a "cannot be obtained" message), so 67
-- is `reach` and the quest log's current bit proves the step. Zayhi-Bauhi takes five Honey, one trade each: 69 is the first
-- (a Honey trade at var 10, replayed on talk at var 1), then 70, 73, 74, and 75 is the fifth, which runs completeQuest (no item
-- reward, so it cannot fail). The page splits those trades into bullet 3 (the first, plus the two onlookers) and bullet 4 (four
-- more), so the completed bit belongs to bullet 4 and the draft's `completes = s3` was wrong. Bullet 5 comes after the
-- completion: Raamimi 80 gives 3 Mulsum only with a free slot (otherwise the event plays and nothing is given), so 80 is
-- `reach` and the game's "You obtain" line proves it. Kalupa-Tawalupa 72 and Rutango-Botango 71 play only while accepted with
-- at least one Honey given. Bullet 1 is a hint for getting the quest to start (Zayhi 64, Kalupa 66, Rutango 65 set it up), a
-- note. Client event scripts S4 239_Raamimi_010EF035.txt (67 say #7255, 68 say #7257, 79 say #7275, 80 say #7276),
-- 239_Zayhi_Bauhi_010EF032.txt (69 say #7252, 70 say #7258, 73 say #7261, 74 say #7262), 239_Kalupa_Tawalupa_010EF034.txt (72 say
-- #7260), 239_Rutango_Botango_010EF033.txt (71 say #7259); item ids from res/items.lua (4370 Honey, 4156 Mulsum).
-- Shared-signal audit: Honey 4370 (casket loot, drops, shops) dropped. Step s5 (the 3 Mulsum) dropped: the Mulsum item and its 'You obtain' line are also given or sold by guild shops and the RoE rewards, and its only own signals (Raamimi 80, the Raamimi line) are reach only, so it is a plain bullet now.
return {
    title = 'To Bee or Not to Bee?',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'if zayhi bauhi speaks normally rather'}},
        {id = 's2', at = {n = 2, fp = 'speak to raamimi to receive honey'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Raamimi 67 adds the quest and the Honey)'},
            {t = 'event', zone = 239, event = 68, conf = 'inferred', why = 'Raamimi 68: reminder, only while accepted'},
            {t = 'chat', re = 'If he swallows some of that honey, honey, it should fix his sore throat right up%.', conf = 'inferred', why = 'Raamimi 68 (say #7257)'},
         },
         reach = {
            {t = 'event', zone = 239, event = 67, why = 'Raamimi 67 offered (with a full bag the quest is not added)'},
            {t = 'chat', re = 'Oh, goodness%-gracious me%.%.%.', why = 'Raamimi 67 (say #7255)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade honey to zayhi bauhi then'},
         done = {
            {t = 'event', zone = 239, event = 69, why = 'Zayhi-Bauhi 69: the first Honey'},
            {t = 'chat', re = 'Ha%-hrr%-hrr%-hrrmmm', why = 'Zayhi-Bauhi 69 (say #7252)'},
            {t = 'event', zone = 239, event = 72, conf = 'inferred', why = 'Kalupa-Tawalupa 72: only after a Honey was given'},
            {t = 'chat', re = 'Hey, did that honey help you to talk a little just now%?', conf = 'inferred', why = 'Kalupa-Tawalupa 72 (say #7260)'},
            {t = 'event', zone = 239, event = 71, conf = 'inferred', why = 'Rutango-Botango 71: only after a Honey was given'},
            {t = 'chat', re = 'Mister speaker!', conf = 'inferred', why = 'Rutango-Botango 71 (say #7259)'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade 4 more honey one at'},
         done = {
            {t = 'event', zone = 239, event = 75, why = 'Zayhi-Bauhi 75: the fifth Honey, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 239, event = 70, why = 'Zayhi-Bauhi 70: the second Honey'},
            {t = 'event', zone = 239, event = 73, why = 'Zayhi-Bauhi 73: the third Honey'},
            {t = 'event', zone = 239, event = 74, why = 'Zayhi-Bauhi 74: the fourth Honey'},
         }},
    },
}
