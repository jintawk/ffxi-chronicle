-- Step progress for Apocalypse Nigh (Jeuno quest 89). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Apocalypse_Nigh.lua (the Ru'Lude Gardens area trigger plays 123, which begins the
-- quest with no refusal; the Sealion's Den zone-in cutscene 29 plays at Prog 0 and its finish sets Prog 1; the Grand Palace
-- of Hu'Xzoi _iya plays 4 at Prog 1; the Empyreal Paradox TR_Entrance plays 4 at Prog 2 (the Dawn mission uses event 2 there,
-- the Abyssea quest another zone); after the Eald'narche and Kam'lanaut fight the Empyreal Paradox zone-in cutscene 7 plays
-- at Prog 4 (the title comes with it), while 32001 is any win there and only a reach counted after s5; Aldo plays 10057 at Prog 4 with rank
-- 5 or better, 10058 is his reminder at Prog 5; Gilgamesh plays 232 or 234 as the earring menu whatever the player picks, and
-- the quest completes only when the earring could be given, so 232, 234 and the Norg door's 235 are only reaches and the
-- completed bit carries the last step; 233 plays once completed) and scripts/battlefields/Empyreal_Paradox/apocalypse_nigh.lua.
-- Zone ids from res/zones.lua (32 Sealion's Den, 34 Grand Palace of Hu'Xzoi, 36 Empyreal Paradox, 243 Ru'Lude Gardens,
-- 245 Lower Jeuno, 252 Norg). Entering the battlefield (the second Radiance check, n=6) shares event 32000 with every
-- battlefield there, so the win's zone-in cutscene proves the fight. Bullets 13 to 16 are the optional earring reset, which
-- deletes the quest again (qm1 event 5); they are not part of a first run and stay plain. The draft's repeatable restart and
-- its completion on the last bullet were guesses. The quest log is set at s2, so it is not silent.
return {
    title = 'Apocalypse Nigh',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note you must zone and wait'}},
        {id = 's2', at = {n = 2, fp = 'enter the palace in ru lude'},
         done = {
            {t = 'event', zone = 243, event = 123, why = 'Ru\'Lude Gardens 123: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'zone into sealion s den for'},
         done = {
            {t = 'zonein', zone = 32, event = 29, why = 'Sealion\'s Den zone-in cutscene 29 (Prog 0)'},
         }},
        {id = 's4', at = {n = 4, fp = 'zone into the grand palace of'},
         done = {
            {t = 'event', zone = 34, event = 4, why = 'Grand Palace of Hu\'Xzoi _iya 4 (Prog 1)'},
         }},
        {id = 's5', at = {n = 5, fp = 'go to the empyreal paradox and'},
         done = {
            {t = 'event', zone = 36, event = 4, why = 'Empyreal Paradox TR_Entrance 4 (Prog 2)'},
         }},
        {id = 's6', at = {n = 6, fp = 'check the transcendental radiance again to'},
         done = {
            {t = 'zonein', zone = 36, event = 7, why = 'Empyreal Paradox zone-in cutscene 7 after the win (Prog 4)'},
         },
         reach = {{t = 'event', zone = 36, event = 32001, after = 's5', why = 'battlefield win in the Empyreal Paradox (any battlefield there)'}}},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'this fight was initially uncapped at'}},
        {id = 's8', kind = 'note', with = 's6', at = {n = 8, fp = 'trusts may be summoned inside this'}},
        {id = 's9', kind = 'note', with = 's6', at = {n = 9, fp = 'in this bc you fight both'}},
        {id = 's10', kind = 'note', with = 's6', at = {n = 10, fp = 'see the discussion page for testimonials'}},
        {id = 's11', at = {n = 11, fp = 'after defeating the brothers speak to'},
         done = {
            {t = 'event', zone = 245, event = 10057, why = 'Aldo 10057 (Prog 4, rank 5 or better)'},
            {t = 'event', zone = 245, event = 10058, conf = 'inferred', why = 'Aldo 10058: reminder, only at Prog 5'},
         }},
        {id = 's12', at = {n = 12, fp = 'zone and wait until the next'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Gilgamesh, once the earring could be given)'},
            {t = 'event', zone = 252, event = 233, conf = 'inferred', why = 'Gilgamesh 233: plays only once completed'},
         },
         reach = {
            {t = 'event', zone = 252, event = 235, why = 'Norg door 235: Prog 5 but the day has not passed'},
            {t = 'event', zone = 252, event = 232, why = 'Gilgamesh 232: the earring menu (completes only if the earring could be given)'},
            {t = 'event', zone = 252, event = 234, why = 'Gilgamesh 234: the same after a cancelled choice'},
         }},
    },
}
