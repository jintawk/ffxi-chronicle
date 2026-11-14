-- Step progress for Lure of the Wildcat (Bastok) (quest 84). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Lure_of_the_Wildcat_Bastok.lua (Alib-Mufalib 357 gives the Blue Sentinel badge
-- and begins the quest whichever menu answer is chosen, so it is no refusal; the twenty NPC cutscenes only set bits of a server
-- variable; 360 takes the badge back, runs quest:complete and gives the Blue invitation card, a key item that cannot be
-- refused); scripts/zones/Port_Bastok/npcs/Alib-Mufalib.lua (379 plays only after the 300 gil trade);
-- scripts/quests/hiddenQuests/Invitation_Cards.lua (Naja Salaheem takes every held invitation card only after the coin was
-- given); client event script S4 236_Alib_Mufalib_010EC0A7.txt (357 say #10012, 360 say #10018, 379 say #12680). Key items 744
-- and 754 are temporary, so no chat line is used for them. The twenty-people bullet (n=2) has no single strong signal and stays
-- a plain bullet; bullet 3 is the return that completes the quest. The Naja Salaheem bullet is a post bullet proved by the card
-- leaving the key item list; the teleport is optional. The draft made bullets 2 and 3 notes on bullet 1 and put the completion
-- on it.
return {
    title = 'Lure of the Wildcat (Bastok)',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with alib mufalib to recieve'},
         done = {
            {t = 'event', zone = 236, event = 357, why = 'Alib-Mufalib 357: the badge is given on either answer'},
            {t = 'chat', re = 'You would like to know more about the badge', why = 'Alib-Mufalib 357 (say #10012)'},
            {t = 'ki', id = 744, gained = true, why = 'blue Sentinel badge obtained'},
            {t = 'ki_have', id = 744, have = true, why = 'blue Sentinel badge held'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'once you have spoken to all'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 236, event = 360, why = 'Alib-Mufalib 360: the badge taken, the quest completed'},
            {t = 'chat', re = 'Many people have expressed interest in Salaheem', why = 'Alib-Mufalib 360 (say #10018)'},
            {t = 'ki', id = 744, gained = false, after = 's1', why = 'blue Sentinel badge handed over'},
            {t = 'ki', id = 754, gained = true, conf = 'inferred', why = 'blue invitation card obtained (reward)'},
         }},
        {id = 's4', kind = 'post', at = {n = 4, fp = 'after joining salaheem s sentinels speak'},
         done = {
            {t = 'ki', id = 754, gained = false, after = 's3', why = 'blue invitation card handed to Naja Salaheem (taken only after the coin)'},
         }},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'after joining salaheem s sentinels alib'},
         done = {
            {t = 'event', zone = 236, event = 379, after = 's3', why = 'Alib-Mufalib 379: the 300 gil trade accepted'},
            {t = 'chat', re = 'Now let us be off!', after = 's3', why = 'Alib-Mufalib 379 (say #12680)'},
         }},
    },
}
