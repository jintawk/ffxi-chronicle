-- Step progress for Shadows of the Departed (Jeuno quest 88). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Shadows_of_the_Departed.lua (the Ru'Lude Gardens area trigger plays 161 with no
-- refusal, gives the Note written by Esha'ntarl and begins the quest; each Promyvion's ??? gives one sliver key item; the
-- trigger plays 162 only when all three slivers are held, and its finish runs quest:complete, takes the slivers and shows
-- "You hand the three crystal slivers to Esha'ntarl." from the zone's IDs.lua). Key item ids from res/key_items.lua (362 the
-- note, 358 Holla, 359 Dem, 360 Mea sliver). Each sliver alone is one Promyvion, so the three are only a reach of bullet 3;
-- event 162 proves the three were collected. The draft put the completion on the slivers (a guess). Not repeatable (page
-- meta). The quest log is set at s2, so it is not silent.
return {
    title = 'Shadows of the Departed',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'note you need to wait until'}},
        {id = 's2', at = {n = 2, fp = 'walk into the palace in ru'},
         done = {
            {t = 'event', zone = 243, event = 161, why = 'Ru\'Lude Gardens 161: the note and the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 362, gained = true, why = "note written by Esha'ntarl obtained"},
            {t = 'ki_have', id = 362, have = true, why = "note written by Esha'ntarl held"},
            {t = 'chat', re = "obtained key item: note written by esha'ntarl", why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'visit three promyvions through the shattered'},
         done = {
            {t = 'event', zone = 243, event = 162, why = 'Ru\'Lude Gardens 162: plays only with all three slivers held'},
         },
         reach = {
            {t = 'ki', id = 358, gained = true, why = 'Promyvion - Holla sliver obtained'},
            {t = 'ki', id = 359, gained = true, why = 'Promyvion - Dem sliver obtained'},
            {t = 'ki', id = 360, gained = true, why = 'Promyvion - Mea sliver obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to the palace in ru'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = "You hand the three crystal slivers to Esha'ntarl%.", why = 'Ru\'Lude Gardens 162 finish (YOU_HAND_THE_THREE_SLIVERS)'},
            {t = 'ki', id = 358, gained = false, after = 's3', conf = 'inferred', why = 'Promyvion - Holla sliver handed over'},
         }},
    },
}
