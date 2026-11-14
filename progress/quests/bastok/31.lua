-- Step progress for Drachenfall (Bastok quest 31). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Drachenfall.lua (Black Mud 101 plays on every talk before the quest, but the
-- quest begins only if the Brass Canteen fits in the bag, so 101 is a reach and the quest log is the proof; 102 re-issues a
-- lost canteen, only once accepted; the Waterfall Base trade has no event, it just gives the Drachenfall Water; Black Mud 103
-- takes the water and completes); client event script S4 234_Black_Mud_010EA03B.txt (101 say #10809, 102 say #10812,
-- 103 say #10813); items 493 Brass Canteen and 492 Drachenfall Water from res/items.lua. Disagreements with the draft: 101 and
-- its line played on a full-bag refusal, so they no longer prove bullet 1; the waterfall trade (bullet 8) is proved by the
-- game's own "Obtained:" line, not left a note; the travel bullets lead into it.
return {
    title = 'Drachenfall',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with black mud to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (only if the canteen fitted in the bag)'},
            {t = 'item', id = 493, gained = true, conf = 'inferred', why = 'Brass Canteen gained (items can come from elsewhere)'},
            {t = 'event', zone = 234, event = 102, conf = 'inferred', why = 'Black Mud 102: canteen re-issue, only once accepted'},
            {t = 'chat', re = "Oh, it's you%. Did you lose the", conf = 'inferred', why = 'Black Mud 102 (say #10812)'},
         },
         reach = {{t = 'event', zone = 234, event = 101, why = 'Black Mud 101 offered (a full bag refuses the quest)'}}},
        {id = 's2', kind = 'note', with = 's8', at = {n = 2, fp = 'otherwise travel to dangruf wadi and'}},
        {id = 's3', kind = 'note', with = 's8', at = {n = 3, fp = 'once inside dangruf wadi travel to'}},
        {id = 's4', kind = 'note', with = 's8', at = {n = 4, fp = 'head northeast to j 3 and'}},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'continue following this path to zone'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'travel east and cross the bridge'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'continue following the river towards the'}},
        {id = 's8', at = {n = 8, fp = 'locate the waterfall base and trade'},
         done = {
            {t = 'chat', re = 'Obtained: .-Drachenfall water', why = 'ITEM_OBTAINED, the Waterfall Base trade is the only source'},
            {t = 'item', id = 492, gained = true, why = 'Drachenfall Water gained'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to bastok and trade the'},
         done = {
            {t = 'event', zone = 234, event = 103, why = 'Black Mud 103: the Drachenfall Water accepted, completes'},
            {t = 'chat', re = 'You got it! Thank the heavens!', why = 'Black Mud 103 (say #10813)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
