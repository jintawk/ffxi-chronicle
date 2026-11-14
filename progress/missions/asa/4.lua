-- Step progress for Enemy of the Empire (I) (ASA mission 5, mission id 4). Data only; see progress/missions/asa/0.lua.
-- Evidence: LandSandBoat scripts/missions/asa/05_Enemy_Of_The_Empire_I.lua and the client script S4 252_Andrause_010FC076 (Norg
-- 252; events 237 to 242). Andrause's first talk (237) assigns the three monsters in the trigger, before the choice, so the event
-- plays on a refusal too ("Do as he says?" Yes / No) and is only `reach`; the line that proves the accept is one said only inside
-- the Yes branch (say #9972, "I'm currently investigating the X, the Y, and the Z."; the name slots fill from the server). The
-- reminder 238 plays on any later talk whether or not the offer was accepted, so it proves nothing, and neither do the Soultrapper
-- or the Blank Soulplate (bought, optional): the draft's 238 and item matchers for bullet 1 are dropped. Each correct plate plays
-- 241 ("Ah, yes..."), but only the third carries the line that finishes the task (say #9982, "I've eagerly awaited your return. /
-- With this image of the X, I hold your task fulfilled."), whose finish completes the mission and gives the Black book (key item
-- 1203, a reward, not used). 240 ("Is there something else you wish of me? / You already have what you came for, no?") plays on a
-- talk only while the Black book is held, which only the completion gives, so it also proves bullet 5; 241 itself is `reach` (a
-- first or second plate). The asa line moves to 5 on completion (no completed set: `min = 5`). Bullets 6 and 7 are the
-- Outcropping scenes of the next mission (its page opens the same way) and stay plain bullets; bullets 2 to 4 are notes.
return {
    title = 'Enemy of the Empire (I)',
    completes = 's5',
    known = {{t = 'mission', line = 'asa', eq = 4}},
    groups = {main = {start = {{t = 'mission', line = 'asa', eq = 4, completed = false, why = 'mission line: current mission = Enemy of the Empire (I)'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to andrause at i 8'},
         done = {
            {t = 'chat', re = "I.m currently investigating the", why = 'Andrause 237 (say #9972), Yes branch only'},
         },
         reach = {
            {t = 'event', zone = 252, event = 237, why = 'Andrause 237: the offer (also plays on a refusal)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'you will be given 3 specific'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'how to take pictures'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'andrause will mention which monsters he'}},
        {id = 's5', at = {n = 5, fp = 'trade the required soul plates to'},
         done = {
            {t = 'chat', re = "I.ve eagerly awaited your return", why = 'Andrause 241 (say #9982): the last plate, the mission completes'},
            {t = 'event', zone = 252, event = 240, why = 'Andrause 240: plays only while the Black book is held'},
            {t = 'mission', line = 'asa', min = 5, why = 'mission line: past Enemy of the Empire (I) (Enemy of the Empire (II) is 5)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 241, why = 'Andrause 241: a correct plate accepted (the first or second)'},
         }},
    },
}
