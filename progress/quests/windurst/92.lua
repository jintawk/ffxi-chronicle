-- Step progress for One Good Deed? (Windurst quest 92). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/One_Good_Deed.lua (Chipmy-Popmy 594 offers the quest and begins it on option 1
-- only, 596 is the reminder before the Peerifools, 595 is the hand-in of the deed, 597 completes, 598 is the closing dialogue
-- after completion; Bibiki Bay qm_deed pops the six Peerifools with the zone texts IT_WAS_A_TRAP and YOU_ARE_NOT_ALONE, then
-- cutscene 34 gives key item 614; Boneyard Gully zone-in cutscene 8 follows once the deed is handed in); client event script
-- S4 240_Chipmy_Popmy_010F0035.txt (596 say #12922, 598 say #12950; 594 holds no text). 594 plays on a decline, so it is a
-- reach and the quest log carries bullet 1. The draft's single step put the completion on bullet 1; the reward cutscene 597 is
-- bullet 9. Bullets 2, 3 and 7 are travel notes; bullet 10 is the optional closing talk. The quest log is set at s1, so it is
-- not silent. Not repeatable (page meta).
-- Chat 'You are not alone!' also plays in the CoP mission 7-4: dropped ('It was a trap!' stays).
-- Key item 432 (map of the Attohwa Chasm) is also sold by the map NPCs (globals/maps.lua): shared, gated after s6.
return {
    title = 'One Good Deed?',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to chipmy popmy to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 596, conf = 'inferred', why = 'Chipmy-Popmy 596: the reminder, only while accepted'},
            {t = 'chat', re = 'In Bibiki Bay there be a place known as Purgonorgo Isle%.', conf = 'inferred', why = 'Chipmy-Popmy 596 (say #12922)'},
         },
         reach = {{t = 'event', zone = 240, event = 594, why = 'Chipmy-Popmy 594 offered (also plays on a decline)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'hop aboard the manaclipper in bibiki'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'head to h 9 to find'}},
        {id = 's4', at = {n = 4, fp = 'examine the to spawn 6 peerifools'},
         done = {
            {t = 'chat', re = 'It was a trap!', why = 'qm_deed: the Peerifools pop (Bibiki Bay IDs.lua IT_WAS_A_TRAP)'},
         }},
        {id = 's5', at = {n = 5, fp = 'once defeated check the again to'},
         done = {
            {t = 'event', zone = 4, event = 34, why = 'Bibiki Bay ??? 34: the deed cutscene'},
            {t = 'ki', id = 614, gained = true, why = 'deed to Purgonorgo Isle obtained'},
            {t = 'ki_have', id = 614, have = true, why = 'deed to Purgonorgo Isle held'},
            {t = 'chat', re = 'obtained key item: deed to purgonorgo isle', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to chipmy popmy may have'},
         done = {
            {t = 'event', zone = 240, event = 595, why = 'Chipmy-Popmy 595: the deed handed in'},
            {t = 'event', zone = 240, event = 599, conf = 'inferred', why = 'Chipmy-Popmy 599: the reminder once the deed is in'},
            {t = 'chat', re = 'Get yerself to Attohwa Chasm', conf = 'inferred', why = 'Chipmy-Popmy 599 (say #12938)'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'head to boneyard gully by going'}},
        {id = 's8', at = {n = 8, fp = 'as soon as you zone into'},
         done = {
            {t = 'event', zone = 8, event = 8, why = 'Boneyard Gully zone-in cutscene 8'},
            {t = 'ki', id = 432, gained = true, after = 's6', why = 'map of the Attohwa Chasm obtained (if not owned)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to chipmy popmy for the'},
         done = {
            {t = 'event', zone = 240, event = 597, why = 'Chipmy-Popmy 597: the reward cutscene'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's10', kind = 'optional', at = {n = 10, fp = 'optional speak to chipmy popmy again'},
         done = {
            {t = 'event', zone = 240, event = 598, why = 'Chipmy-Popmy 598: closing dialogue'},
            {t = 'chat', re = "If Windurst wasn't in cahoots with the Mithran pirates", why = 'Chipmy-Popmy 598 (say #12950)'},
         }},
    },
}
