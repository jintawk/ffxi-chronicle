-- Step progress for Onion Rings (Windurst quest 42). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SOB4_Onion_Rings.lua. Kohlo-Lakolo 429 (no Old ring yet) only starts a 24 hour
-- timer and does NOT add the quest, so the quest log is silent until step 6: 430 (Old ring held, in time) begins it, 432 (Old ring
-- held, too late) completes it at once, and while accepted 433 completes it when the time is up (431, the in-time reminder, has no body in the
-- client script or LandSandBoat, so it is not used). The House of the Hero door in Windurst Walls (289) completes it in time. Completing here gives fame and a title only, so none
-- of 432, 433 and 289 can fail; the draft's quest-current bit on bullet 2 was wrong (429 does not set it). Bullet 6 bundles Kohlo
-- (430, `reach`) and the door (the completion). Bullet 7 (zone, return) has no signal and is a note on bullet 6; bullets 3 and 4
-- are Castle Oztroja directions, notes; bullet 5 is the Blank Target, the only source of the Old ring (Castle_Oztroja/npcs/_47d.lua,
-- event 44 then the key item). Client event scripts S4 240_Kohlo_Lakolo_010F0052.txt (429 say #4359, 432 say #4368);
-- Castle Oztroja has no script for the target, so event 44 comes from LandSandBoat; key item 130 from res/key_items.lua.
return {
    title = 'Onion Rings',
    completes = 's6',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's6'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after completing the previous quest'}},
        {id = 's2', at = {n = 2, fp = 'speak to kohlo lakolo for a'},
         done = {
            {t = 'event', zone = 240, event = 429, why = 'Kohlo-Lakolo 429: the story, starts the timer (no Old ring yet)'},
            {t = 'chat', re = 'the Cat Burglar has been coming and going in and out of the ghosty house', why = 'Kohlo-Lakolo 429 (say #4359)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'head to castle oztroja and head'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'using the handles in front of'}},
        {id = 's5', at = {n = 5, fp = 'check the blank target in this'},
         done = {
            {t = 'event', zone = 151, event = 44, why = 'Blank Target 44: only without the Old ring, then it is given'},
            {t = 'ki', id = 130, gained = true, why = 'Old ring obtained'},
            {t = 'chat', re = 'obtained key item: old ring', why = 'chat: key item obtained'},
            {t = 'ki_have', id = 130, have = true, why = 'Old ring held'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to kohlo lakolo who will'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 239, event = 289, why = 'House of the Hero door 289: completes the quest in time'},
            {t = 'event', zone = 240, event = 433, why = 'Kohlo-Lakolo 433: the time is up, completes the quest'},
            {t = 'event', zone = 240, event = 432, why = 'Kohlo-Lakolo 432: Old ring held and too late, completes the quest at once'},
            {t = 'chat', re = "That's a little old, but it looks like the minister's ring", why = 'Kohlo-Lakolo 432 (say #4368)'},
         },
         reach = {
            {t = 'quest', current = true, why = 'quest log: accepted (Kohlo-Lakolo 430, Old ring held and in time)'},
            {t = 'event', zone = 240, event = 430, why = 'Kohlo-Lakolo 430: begins the quest'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'zone and return to kohlo lakolo'}},
    },
}
