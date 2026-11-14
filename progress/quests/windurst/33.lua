-- Step progress for Curses, Foiled...Again!? (Windurst quest 33). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Curses_Foiled_Again_2.lua. Before the quest is accepted its steps are server
-- variables only (Prog): Shantotto 178 (Prog 0, sends you to Hiwon-Biwon, so it is `reach` for that step), Hiwon-Biwon 179
-- (sets Prog 1), Shantotto 177 (Prog 1, sets Prog 2 and the must-zone flag), then after zoning Shantotto 180 is the offer and
-- only option 3 begins the quest (quest log current bit, title Tarutaru Murder Suspect); 181 is her reminder and plays only once
-- accepted; 183 plays on the exact trade of 2 Bomb Arms + Revival Tree Root + Hiwon's Hair and runs quest:complete, but the
-- Misery Staff reward needs a free slot and 183 plays without that check, so 183 is `reach` and the completed bit carries the
-- last step. Hiwon-Biwon 284 is not used: it also plays during Curses, Foiled Again! and is Making Headlines' own line. The
-- log is silent until the offer is accepted. The questions bullet describes the answers inside event 180 (a note on that step);
-- the Hiwon-Biwon hair talk (event 182) is an indented bullet, so it is not a step. Client event scripts S4
-- 239_Shantotto_010EF01A.txt (177 say #7494, 178 say #7497, 180 say #7500/#7501, 181 say #7520) and 239_Hiwon_Biwon_010EF01B.txt
-- (179 say #7499).
-- Shared-signal audit: the line '...Erck...!' also plays in Hiwon-Biwon 283 and 284 (Making Headlines, windurst/37): dropped.
return {
    title = 'Curses, Foiled...Again!?',
    completes = 's8',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's5'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'this quest can be completed with'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the quest will not show up'}},
        {id = 's3', at = {n = 3, fp = 'speak to hiwon biwon k 8'},
         done = {
            {t = 'event', zone = 239, event = 179, why = 'Hiwon-Biwon 179'},
         },
         reach = {
            {t = 'event', zone = 239, event = 178, why = 'Shantotto 178: nobody has been cursed yet, so Hiwon-Biwon is still to see'},
            {t = 'chat', re = "Oh%? You didn't see anyone doing the old Skeleton Dance, eh%?", why = 'Shantotto 178 (say #7497)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to shantotto k 8'},
         done = {
            {t = 'event', zone = 239, event = 177, why = 'Shantotto 177: the curse has worked'},
            {t = 'chat', re = "Our peeping Tom's been enjoying that Skeleton Dance curse", why = 'Shantotto 177 (say #7494)'},
         }},
        {id = 's5', at = {n = 5, fp = 'zone out of the area and'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Shantotto 180, option 3)'},
         },
         reach = {
            {t = 'event', zone = 239, event = 180, why = 'Shantotto 180 offered (its finish needs option 3)'},
            {t = 'chat', re = "I've been looking all over Windurst for you!", why = 'Shantotto 180 (say #7500)'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'for her first question choose either'}},
        {id = 's7', at = {n = 7, fp = 'shantotto asks you to bring her'},
         done = {
            {t = 'event', zone = 239, event = 181, conf = 'inferred', why = 'Shantotto 181: reminder of the items, only once accepted'},
            {t = 'chat', re = "If you want to avoid imprisonment, you'll just have to go find:", why = 'Shantotto 181 (say #7520)'},
         }},
        {id = 's8', at = {n = 8, fp = 'trade the items to shantotto to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 239, event = 183, why = 'Shantotto 183: the trade accepted (also plays with a full bag, when the reward fails)'},
         }},
    },
}
