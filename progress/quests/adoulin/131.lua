-- Step progress for Saved by the Bell (Adoulin quest 131, the Idris weapon quest). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest but has no script for it, so the page is the source. The key items are temporary
-- ones handed out by the bullets that say so (res/key_items.lua): 2565 Rusted handbell (bullet 2, the Inlet of Whispers), 2566
-- Emblazoned handbell (bullet 6, after the first Bayld trade), 2567 Ripple Prominence concretion (13), 2568 Inferno concretion
-- (17), 2569 Cyclone concretion (21). The page says the quest log moves to completed once the base weapon is received after
-- the Bygone Geomancer fight (bullet 10), so the log's completed bit belongs to bullet 9, not the last bullet (the draft put
-- it on 22). Fixed from the draft: the Broken rapier hilt belongs to Quiescence (132), and Climbing and Watercrafting are
-- only access notes on bullets 14 and 22, so none of them marks a step. Talks and trades with no signal of their own are
-- notes on the next step that has one. The Nodal Wand III trade for Idris (22) is an item, not a key item, so it is
-- optional with no signal, as is the Dropped Item recovery. The quest log's current bit is not mapped (nothing says which
-- bullet flags it). Every part after the completing step is kind post (it stays open after a completed log).
-- Not repeatable.
return {
    title = 'Saved by the Bell',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak with nhili uvolep and she'}},
        {id = 's2', at = {n = 2, fp = 'travel to f 12 in dho'},
         done = {
            {t = 'ki', id = 2565, gained = true, why = 'rusted handbell obtained'},
            {t = 'ki_have', id = 2565, have = true, why = 'rusted handbell held'},
            {t = 'chat', re = 'obtained key item: rusted handbell', why = 'chat: key item obtained'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'return to nhili uvolep'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'speak with runje desaali j 11'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'trade 100 high purity bayld to'}},
        {id = 's6', at = {n = 6, fp = 'you will receive the emblazoned handbell'},
         done = {
            {t = 'ki', id = 2566, gained = true, why = 'emblazoned handbell obtained'},
            {t = 'ki_have', id = 2566, have = true, why = 'emblazoned handbell held'},
            {t = 'chat', re = 'obtained key item: emblazoned handbell', why = 'chat: key item obtained'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'speak with nhili uvolep again'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'with your main job set to'}},
        {id = 's9', at = {n = 9, fp = 'after the fight return to nhili'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the page: moved to completed on receiving Nodal Wand I)'},
         }},
        {id = 's10', kind = 'note', with = 's9', at = {n = 10, fp = 'the quest is technically completed at'}},
        {id = 's11', kind = 'note', with = 's13', at = {n = 11, fp = 'trade nodal wand i to runje'}},
        {id = 's12', kind = 'note', with = 's13', at = {n = 12, fp = 'trade the following to geosuke'}},
        {id = 's13', kind = 'post', at = {n = 13, fp = 'you will receive a ripple prominence'},
         done = {
            {t = 'ki', id = 2567, gained = true, why = 'Ripple Prominence concretion obtained'},
            {t = 'ki_have', id = 2567, have = true, why = 'Ripple Prominence concretion held'},
            {t = 'chat', re = 'obtained key item: ripple prominence concretion', why = 'chat: key item obtained'},
         }},
        {id = 's14', kind = 'note', with = 's17', at = {n = 14, fp = 'trade your nodal wand i to'}},
        {id = 's15', kind = 'note', with = 's17', at = {n = 15, fp = 'trade nodal wand ii to runje'}},
        {id = 's16', kind = 'note', with = 's17', at = {n = 16, fp = 'trade the following to geosuke'}},
        {id = 's17', kind = 'post', at = {n = 17, fp = 'you will receive an inferno concretion'},
         done = {
            {t = 'ki', id = 2568, gained = true, why = 'inferno concretion obtained'},
            {t = 'ki_have', id = 2568, have = true, why = 'inferno concretion held'},
            {t = 'chat', re = 'obtained key item: inferno concretion', why = 'chat: key item obtained'},
         }},
        {id = 's18', kind = 'note', with = 's21', at = {n = 18, fp = 'trade your nodal wand ii to'}},
        {id = 's19', kind = 'note', with = 's21', at = {n = 19, fp = 'trade nodal wand iii to runje'}},
        {id = 's20', kind = 'note', with = 's21', at = {n = 20, fp = 'trade the following to geosuke'}},
        {id = 's21', kind = 'post', at = {n = 21, fp = 'you will receive a cyclone concretion'},
         done = {
            {t = 'ki', id = 2569, gained = true, why = 'cyclone concretion obtained'},
            {t = 'ki_have', id = 2569, have = true, why = 'cyclone concretion held'},
            {t = 'chat', re = 'obtained key item: cyclone concretion', why = 'chat: key item obtained'},
         }},
        {id = 's22', kind = 'optional', at = {n = 22, fp = 'trade your nodal wand iii to'}, done = {}},
        {id = 's23', kind = 'optional', at = {n = 23, fp = 'talk to geosuke you might need'}, done = {}},
        {id = 's24', kind = 'optional', at = {n = 24, fp = 'answer yes'}, done = {}},
        {id = 's25', kind = 'optional', at = {n = 25, fp = 'trade information needed 1 000 000'}, done = {}},
    },
}
