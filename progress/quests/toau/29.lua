-- Step progress for Puppetmaster Blues (Aht Urhgan quest 29). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/PUP_AF3_Puppetmaster_Blues.lua (Iruki-Waraki 782 is the offer, no option, and
-- begins the quest; Shamarhaan 437 at Prog 0 hands over Valkeng's memory chip (key item 843) and sets Prog 1; the ??? on the
-- Mount Zhayolm steam vent gives the Toggle switch (key item 844) with no event; the Talacca Cove win, event 32001 shared by every
-- battlefield there, takes both key items and sets Prog 2, so the two losses prove the fight (bullet 10), while entering the
-- battlefield (bullet 6) has no signal and, like the strategy bullets, is a note; Shamarhaan 439 at Prog 2 sets Prog 3; Iruki-Waraki
-- 784 at Prog 3 sets Prog 4; Sajhra 291 at Prog 4 sets Prog 5; Iruki-Waraki 786 at Prog 5 runs quest:complete, whose reward is
-- Puppetry Taj, so a full bag replays 786 and only the completed bit proves the last bullet). Events 437 and 439 (Bastok Markets)
-- and 291 (Nashmau) are used by no other script of those zones that the quest log shares. Key item ids from res/key_items.lua.
-- Not repeatable. Client event script S4 235_Shamarhaan_010EB096.txt (437 and 439 are bare, their text is not shown); 784, 786 and
-- 291 have no text.
return {
    title = 'Puppetmaster Blues',
    completes = 's14',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with iruki waraki who during'},
         done = {
            {t = 'event', zone = 50, event = 782, why = 'Iruki-Waraki 782: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you can be any job from'}},
        {id = 's3', at = {n = 3, fp = 'travel to bastok markets and talk'},
         done = {
            {t = 'event', zone = 235, event = 437, why = 'Shamarhaan 437: plays only at Prog 0, hands over the memory chip'},
            {t = 'ki', id = 843, gained = true, why = "Valkeng's memory chip obtained"},
            {t = 'ki_have', id = 843, have = true, why = "Valkeng's memory chip held"},
            {t = 'chat', re = "obtained key item: valkeng's memory chip", why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to mount zhayolm and reach'},
         done = {
            {t = 'ki', id = 844, gained = true, why = 'toggle switch obtained'},
            {t = 'ki_have', id = 844, have = true, why = 'toggle switch held'},
            {t = 'chat', re = 'obtained key item: toggle switch', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's10', at = {n = 5, fp = 'after obtaining valkeng s memory chip'}},
        {id = 's6', kind = 'note', with = 's10', at = {n = 6, fp = 'examine the rock slab in the'}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'if underleveled geared this battle can'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'valkeng is an automaton type mob'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'each frame valkeng changes to has'}},
        {id = 's10', at = {n = 10, fp = 'upon defeating valkeng a cut scene'},
         done = {
            {t = 'ki', id = 843, gained = false, why = "Valkeng's memory chip taken at the Talacca Cove win"},
            {t = 'ki', id = 844, gained = false, why = 'toggle switch taken at the Talacca Cove win'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to bastok markets and speak'},
         done = {
            {t = 'event', zone = 235, event = 439, why = 'Shamarhaan 439: plays only at Prog 2 (Valkeng beaten), sets Prog 3'},
         }},
        {id = 's12', at = {n = 12, fp = 'travel back to aht urhgan whitegate'},
         done = {
            {t = 'event', zone = 50, event = 784, why = 'Iruki-Waraki 784: plays only at Prog 3, sets Prog 4'},
         }},
        {id = 's13', at = {n = 13, fp = 'travel to nashmau and speak with'},
         done = {
            {t = 'event', zone = 53, event = 291, why = 'Sajhra 291: plays only at Prog 4, sets Prog 5'},
         }},
        {id = 's14', at = {n = 14, fp = 'return to iruki waraki in aht'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 786, why = 'Iruki-Waraki 786: plays only at Prog 5, runs quest:complete (replays if Puppetry Taj cannot be given)'}}},
    },
}
