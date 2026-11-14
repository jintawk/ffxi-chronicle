-- Step progress for One to be Feared (Chains of Promathia 6-4, mission id 638). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/6_4_One_to_be_Feared.lua. Cid in Metalworks (237) event 856 plays only at status 0
-- (the client body is empty, the id is in 237_Cid_010ED02B.txt); the Sealion's Den (32) zone-in cutscene 15 plays only at status 1;
-- the Iron Gate (_0w0, event 31) only at status 2 (LandSandBoat only: no client script for either zone-in or the gate). The battle
-- has no event of its own (32001 is a battlefield exit, never proof): the zone-in cutscene 33 in Sealion's Den (status 4, after the
-- win) completes the mission, which the cop log shows as 638 completed. Bullets 4 to 10 (the airship, the door, the fight) are notes
-- on that completing step, and bullet 7 (enter the battlefield) proves nothing. The trust bullet is a post step: Taillegeas event
-- 10235 (Ru'Lude Gardens 243) plays on a decline too, so only the server line that follows the accept proves it (zone text
-- YOU_LEARNED_TRUST, LandSandBoat Trust_Cherukiki.lua). The draft put the Iron Gate event on bullet 2, left the completing step
-- without a signal, and listed Tavnazian Safehold / Sueleen reminders (318, 306, 267, 24) that are dropped.
-- Trust bullet left plain: the learned line is not in client scripts or LandSandBoat text.
return {
    title = 'One to be Feared',
    completes = 's11',
    known = {{t = 'mission', line = 'cop', eq = 638}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'go to the metalworks and speak'},
         done = {
            {t = 'event', zone = 237, event = 856, why = 'Cid 856 (status 0 only)'},
         }},
        {id = 's2', at = {n = 2, fp = 'make your way to sealion s'},
         done = {
            {t = 'zonein', zone = 32, event = 15, why = "Sealion's Den zone-in cutscene 15 (status 1, LandSandBoat)"},
         }},
        {id = 's3', at = {n = 3, fp = 'click the iron gate to get'},
         done = {
            {t = 'event', zone = 32, event = 31, why = 'Iron Gate 31 (status 2, LandSandBoat)'},
         }},
        {id = 's4', kind = 'note', with = 's11', at = {n = 4, fp = 'you will then be aboard the'}},
        {id = 's5', kind = 'note', with = 's11', at = {n = 5, fp = 'click the door on the airship'}},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'the time limit in the battle'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'after you have discussed your strategies'}},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'you will appear on the deck'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'this is a three stage fight'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'after you defeat each stage you'}},
        {id = 's11', at = {n = 11, fp = 'after you defeat ultima the last'},
         done = {
            {t = 'mission', line = 'cop', eq = 638, completed = true, why = 'mission log: One to be Feared completed'},
            {t = 'zonein', zone = 32, event = 33, why = "Sealion's Den zone-in cutscene 33 (status 4, after the win): completes"},
         }},
    },
}
