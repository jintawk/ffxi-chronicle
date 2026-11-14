-- Step progress for Acting in Good Faith (Windurst quest 64). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Acting_in_Good_Faith.lua (Gantineux 10019 offers the quest, and only option 0
-- gives the Spirit incense and begins it, so it is `reach`; 10020 is his talk with the incense held; the Eldieme ??? is event 50
-- and only plays with the incense, its finish takes the incense; 10021 is his talk with neither key item and gives
-- Gantineux's letter; 10022 his talk with the letter held; Eperdur 680 is the hand-in with the letter held. Quest:complete
-- runs npcUtil.completeQuest with a Scroll of Teleport-Mea reward, which fails when the bag is full after the cutscene
-- played, so 680 is a refusal-played event (`reach`); the letter is taken only after a successful completion, so its loss
-- and the quest log's completed bit carry the last step; 10023 is Gantineux after completion); client event scripts S4
-- 238_Gantineux_010EE0C6.txt (10020 say #9240, 10021 say #9242, 10022 say #9245, 10023 say #9246) and
-- 231_Eperdur_010E70AE.txt; key items 175 and 176 from res/key_items.lua, zone 195 and item 4732 from res/. The first two
-- bullets are one talk (the visit, then what he gives), so both are steps with the same accepted proof. The quest log is set
-- at s1, so it is not silent. The travel bullet is a note on the ??? step.
-- Item 4732 (Scroll of Teleport-Mea) is sold by Amalasanda: shared, gated after s1.
return {
    title = 'Acting in Good Faith',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to gantineux on the second'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 10020, conf = 'inferred', why = 'Gantineux 10020: his talk with the incense held'},
         },
         reach = {{t = 'event', zone = 238, event = 10019, why = 'Gantineux 10019 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'gantineux will give you the spirit'},
         done = {
            {t = 'ki', id = 175, gained = true, why = 'spirit incense obtained'},
            {t = 'ki_have', id = 175, have = true, why = 'spirit incense held'},
            {t = 'chat', re = 'obtained key item: spirit incense', why = 'chat: key item obtained'},
            {t = 'chat', re = 'Please give peace to the spirits of the Eldieme Necropolis%.', conf = 'inferred', why = 'Gantineux 10020 (say #9240)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to eldieme necropolis and look'}},
        {id = 's4', at = {n = 4, fp = 'click the'},
         done = {
            {t = 'event', zone = 195, event = 50, why = 'Eldieme ??? 50: only plays with the incense held'},
            {t = 'ki', id = 175, gained = false, conf = 'inferred', why = 'spirit incense used up'},
         }},
        {id = 's5', at = {n = 5, fp = 'go back to gantineux he will'},
         done = {
            {t = 'event', zone = 238, event = 10021, why = 'Gantineux 10021: gives the letter'},
            {t = 'chat', re = 'In any case, I must thank you for your assistance%.', why = 'Gantineux 10021 (say #9242)'},
            {t = 'ki', id = 176, gained = true, why = "Gantineux's letter obtained"},
            {t = 'ki_have', id = 176, have = true, why = "Gantineux's letter held"},
            {t = 'chat', re = "obtained key item: gantineux's letter", why = 'chat: key item obtained'},
            {t = 'event', zone = 238, event = 10022, conf = 'inferred', why = 'Gantineux 10022: his talk with the letter held'},
            {t = 'chat', re = "Please take this letter of introduction to Eperdur of the San d'Oria Cathedral%.", conf = 'inferred', why = 'Gantineux 10022 (say #9245)'},
         }},
        {id = 's6', at = {n = 6, fp = 'go to northern san d oria'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 176, gained = false, why = "Gantineux's letter handed over (taken only after a successful completion)"},
            {t = 'item', id = 4732, gained = true, after = 's1', conf = 'inferred', why = 'Scroll of Teleport-Mea gained (reward) (items can come from elsewhere)'},
            {t = 'event', zone = 238, event = 10023, conf = 'inferred', why = 'Gantineux 10023: his talk after completion'},
            {t = 'chat', re = 'A communication from the cathedral arrived to encourage me in my ongoing research%.', conf = 'inferred', why = 'Gantineux 10023 (say #9246)'},
         },
         reach = {{t = 'event', zone = 231, event = 680, why = 'Eperdur 680: the letter handed in (also plays when the reward cannot be given)'}}},
    },
}
