-- Step progress for Treasures of the Earth (Adoulin quest 142). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (the enum names the quest only) and no client event script for Sylvie's or the Ergon Locus
-- events, so the signals are the page's key items and the quest log. The three crystals (Holla 2795, Dem 2796, Mea 2797) are
-- handed out by Sylvie at bullet 4 (any one proves it) and taken at the Ergon Locus of the chosen crag (bullets 5, 9, 11), which
-- is a branch each (the three option sections; never inferred). The Treatise on azimuth clothcraft (2794) is handed over at the
-- return to Sylvie (bullet 19), a mid-quest key item; the reward (Azimuth Coat, XP) comes only after the Selbina talks and the
-- next game day (bullet 22), so the completed bit is on bullet 22. The draft's Crystallized lifestream essence (2513, from an
-- earlier quest, only named in a sub-bullet), "Climbing" (a permanent key item from elsewhere) and the Pale azure cloth (2798,
-- the 109 fight's reward only) are dropped. Bullets 1 to 3 (the offer, the Morimar cutscenes), the fight descriptions and the
-- Selbina talks have no signal of their own: notes. The page says repeatable (a new crystal from Sylvie once per Conquest Tally);
-- nothing separates a second run from the first, so there is no `repeatable` entry.
return {
    title = 'Treasures of the Earth',
    completes = 's22',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'speak to sylvie at western adoulin'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'go to morimar basalt fields j'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'go to g h 7 and'}},
        {id = 's4', at = {n = 4, fp = 'return to sylvie she will offer'},
         done = {
            {t = 'ki', id = 2795, gained = true, why = 'Holla crystal of gales obtained (the 109 fight)'},
            {t = 'ki', id = 2796, gained = true, why = 'Dem crystal of dunes obtained (the 125 fight)'},
            {t = 'ki', id = 2797, gained = true, why = 'Mea crystal of flames obtained (the 135 fight)'},
            {t = 'chat', re = 'obtained key item: holla crystal of gales', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: dem crystal of dunes', why = 'chat: key item obtained'},
            {t = 'chat', re = 'obtained key item: mea crystal of flames', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'branch', at = {n = 5, fp = 'go to the crag of holla'},
         done = {{t = 'ki', id = 2795, gained = false, after = 's4', why = 'Holla crystal of gales taken at the Ergon Locus'}}},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'this is a solo fight you'}},
        {id = 's7', kind = 'note', with = 's5', at = {n = 7, fp = 'your enemy for this fight is'}},
        {id = 's8', kind = 'note', with = 's5', at = {n = 8, fp = 'upon defeating otherworldly rimester you will'}},
        {id = 's9', kind = 'branch', at = {n = 9, fp = 'go to the crag of dem'},
         done = {{t = 'ki', id = 2796, gained = false, after = 's4', why = 'Dem crystal of dunes taken at the Ergon Locus'}}},
        {id = 's10', kind = 'note', with = 's9', at = {n = 10, fp = 'your reward is a random assortment'}},
        {id = 's11', kind = 'branch', at = {n = 11, fp = 'go to the crag of mea'},
         done = {{t = 'ki', id = 2797, gained = false, after = 's4', why = 'Mea crystal of flames taken at the Ergon Locus'}}},
        {id = 's12', kind = 'note', with = 's11', at = {n = 12, fp = 'this is a solo fight for'}},
        {id = 's13', kind = 'note', with = 's11', at = {n = 13, fp = 'your enemy for this fight is'}},
        {id = 's14', kind = 'note', with = 's11', at = {n = 14, fp = 'the rimester has access to numerous'}},
        {id = 's15', kind = 'note', with = 's11', at = {n = 15, fp = 'rimester s tp moves are dark'}},
        {id = 's16', kind = 'note', with = 's11', at = {n = 16, fp = 'the rimester has a shifting elemental'}},
        {id = 's17', kind = 'note', with = 's11', at = {n = 17, fp = 'your reward is 1 codex of'}},
        {id = 's18', kind = 'note', with = 's11', at = {n = 18, fp = 'if you fail you must return'}},
        {id = 's19', at = {n = 19, fp = 'return to sylvie you will obtain'},
         done = {
            {t = 'ki', id = 2794, gained = true, why = 'treatise on azimuth clothcraft obtained'},
            {t = 'ki_have', id = 2794, have = true, why = 'treatise on azimuth clothcraft held'},
            {t = 'chat', re = 'obtained key item: treatise on azimuth clothcraft', why = 'chat: key item obtained'},
         }},
        {id = 's20', kind = 'note', with = 's22', at = {n = 20, fp = 'talk to wescolina h 7'}},
        {id = 's21', kind = 'note', with = 's22', at = {n = 21, fp = 'talk to helina h 9 located'}},
        {id = 's22', at = {n = 22, fp = 'wait until the next game day'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Helina gives the reward the next game day)'},
         }},
        {id = 's23', kind = 'note', with = 's22', at = {n = 23, fp = 'to repeat the quest fight after'}},
        {id = 's24', kind = 'note', with = 's22', at = {n = 24, fp = 'speak to helina in selbina to'}},
        {id = 's25', kind = 'note', with = 's22', at = {n = 25, fp = 'you have the option to either'}},
        {id = 's26', kind = 'note', with = 's22', at = {n = 26, fp = 'after turning in the items to'}},
    },
}
