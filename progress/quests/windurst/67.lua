-- Step progress for Recollections (Windurst quest 67). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Heavens_Tower/npcs/Chumimi.lua (270 is the offer and its finish adds the quest with no
-- choice; 268 is her standard dialogue after The Three Magi when the offer's conditions are not met, so it proves nothing and
-- the draft's use of it is dropped; trading the Bag of Seeds is event 271; 275 is the hand-in with the Foe Finder held, whose
-- finish gives the Wizard's Sabots through npcUtil.giveItem inside an `if` and does nothing otherwise, so 275 is a
-- refusal-played event: `reach`, and the Foe Finder's loss (taken only in the success branch) and the quest log's completed bit
-- carry the last step) and Castle_Zvahl_Keep/npcs/_4i5.lua (the Ore door: trading the Whine Cellar Key is event 8, which
-- needs the quest and its variable, takes the key and gives key item 181, no refusal path); client event script S4
-- 242_Chumimi_010F2053.txt (271 say #7967); key item 181, zones 162 and 242, item 14092 from res/. The Laityn cutscene is an
-- indented optional remark, not a step. Bullets 3, 5 and 6 (the Bag of Seeds hunt, the Whine Cellar Key hunt and the zoning)
-- are notes on the step they lead into; the hunts are plain items with no event of their own. Repeatable only after a memory
-- reset, which leaves nothing to observe, so no `repeatable` entry. The quest log is set at s2, so it is not silent.
-- Item 14092 (Wizard's Sabots) comes out of a Porter Moogle slip too: shared, gated after s2.
return {
    title = 'Recollections',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zoning out of the tower is'}},
        {id = 's2', at = {n = 2, fp = 'begin quest by speaking with chumimi'},
         done = {
            {t = 'event', zone = 242, event = 270, why = 'Chumimi 270: the offer, adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'after speaking with chumimi head to'}},
        {id = 's4', at = {n = 4, fp = 'return to chumimi and trade her'},
         done = {
            {t = 'event', zone = 242, event = 271, why = 'Chumimi 271: the Bag of Seeds accepted'},
            {t = 'chat', re = 'I commend%-ethy you on your efforts%.', why = 'Chumimi 271 (say_as #7967)'},
         }},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'following this cutscene head to castle'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'zone into castle zvahl keep'}},
        {id = 's7', at = {n = 7, fp = 'head to the ore door at'},
         done = {
            {t = 'event', zone = 162, event = 8, why = 'Ore door 8: the Whine Cellar Key accepted'},
            {t = 'ki', id = 181, gained = true, why = '"Foe Finder Mk. I" obtained'},
            {t = 'ki_have', id = 181, have = true, why = '"Foe Finder Mk. I" held'},
            {t = 'chat', re = 'obtained key item: "foe finder mk%. i"', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to chumimi after the cutscene'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 181, gained = false, after = 's7', why = '"Foe Finder Mk. I" handed over (taken only after a successful completion)'},
            {t = 'item', id = 14092, gained = true, after = 's2', conf = 'inferred', why = "Wizard's Sabots gained (reward) (items can come from elsewhere)"},
         },
         reach = {{t = 'event', zone = 242, event = 275, why = "Chumimi 275: the hand-in (also plays when the Wizard's Sabots cannot be given)"}}},
    },
}
