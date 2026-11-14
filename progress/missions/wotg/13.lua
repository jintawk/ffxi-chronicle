-- Step progress for A Nation on the Brink (Wings of the Goddess mission 14, mission id 13). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/14_A_Nation_on_the_Brink.lua. The Underpass Hatch in Batallia Downs [S] (zone 84)
-- plays event 3 on a touch while the mission is current and its finish sets status 1 (bullet 1). Entering the Everbloom Hollow
-- instance (bullet 2) and the fight leave no event of their own in a trustworthy form (LandSandBoat catches event 10000 in zone 86
-- as an unverified guess, its own TODO); the win is followed by the zone-in cutscenes 4, 20 and 21 in Batallia Downs [S] (statuses
-- 2 to 4, one per re-zone after the setPos), and 22 completes the mission and hands out the Jeunoan Flag. So bullet 8 is zone-in
-- 22 plus the log, 4 / 20 / 21 are reach, and bullets 2 to 7 (entry, instance tips) are notes on it, as are the outro bullet 9. The
-- Jeunoan Flag (item 184) is a reward and the Underpass hatch key (Bulwark Gate 6, zone 98) is a recovery handed out if the key
-- was lost; neither is used. The draft put the mission's completion on bullet 3 and used the guessed event 10000 and zone-in 21
-- as bullet 2 and 1; fixed.
return {
    title = 'A Nation on the Brink',
    completes = 's8',
    known = {{t = 'mission', line = 'wotg', eq = 13}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the underpass hatch in batallia'},
         done = {
            {t = 'event', zone = 84, event = 3, why = 'Underpass Hatch 3: the cutscene at the hatch (status 0)'},
         }},
        {id = 's2', kind = 'note', with = 's8', at = {n = 2, fp = 'click the underpass hatch again to'}},
        {id = 's3', kind = 'note', with = 's8', at = {n = 3, fp = 'up to six players may enter'}},
        {id = 's4', kind = 'note', with = 's8', at = {n = 4, fp = 'the objective is to defeat one'}},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'trusts can be summoned'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'all of the mobs inside the'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'you will be assisted by 9'}},
        {id = 's8', at = {n = 8, fp = 'once you defeat one eyed gwajboj'},
         done = {
            {t = 'zonein', zone = 84, event = 22, why = 'Batallia Downs [S] zone-in cutscene 22: completes the mission, the Jeunoan Flag (status 5)'},
            {t = 'mission', line = 'wotg', eq = 13, completed = true, why = 'mission log: A Nation on the Brink completed'},
         },
         reach = {
            {t = 'zonein', zone = 84, event = 4, why = 'Batallia Downs [S] zone-in cutscene 4, after the instance (status 2)'},
            {t = 'zonein', zone = 84, event = 20, why = 'Batallia Downs [S] zone-in cutscene 20 (status 3)'},
            {t = 'zonein', zone = 84, event = 21, why = 'Batallia Downs [S] zone-in cutscene 21 (status 4)'},
         }},
        {id = 's9', kind = 'note', with = 's8', at = {n = 9, fp = 'you will be able to continue'}},
    },
}
