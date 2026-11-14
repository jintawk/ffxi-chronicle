-- Step progress for Tenshodo Membership (Jeuno quest 17). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Tenshodo_Membership.lua (the quest never shows in the log until it is
-- completed, so the group is silent until bullet 6; Ghebi Damomohe 106 is his shop menu, whose third row (option 2) says
-- "Ordinary travelers don't ask about Tenshodo" and sets Prog 1; Jabbar or Silver Owl 151 plays only at Prog 1 without the
-- form and gives the Tenshodo application form (key item 121), 152 is the same talk again while holding it; Ghebi 107 (with
-- the form) and 108 (trading a Tenshodo Invite) both run quest:complete, but the reward is a Tenshodo Invite, so both also
-- play when the bag is full and are only reaches: the log's completed bit proves bullet 6, and the form is deleted only when
-- the quest completes, so its loss proves the hand-in too). Bullet 7 is the other way in (an Invite bought on the AH): a
-- branch, never inferred. Client event scripts S4 245_Ghebi_Damomohe_010F5006.txt (106 say #7615, option 2 say #7618) and
-- 236_Jabbar_010EC00A.txt (151 say #6748); key item ids from res/key_items.lua (121 Tenshodo application form).
-- Ghebi's 106 menu also plays outside the quest (Pso'Xja pass, Astral Covenant), so no step uses it: bullets 1 and 2 are plain bullets
-- and bullet 3 rests on the third-row line alone.
return {
    title = 'Tenshodo Membership',
    completes = 's6',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's6'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'select the third blank line of'},
         done = {
            {t = 'chat', re = "Ordinary travelers don't ask about Tenshodo%.", why = 'Ghebi Damomohe 106, third row only (say #7618)'},
            {t = 'event', zone = 236, event = 151, conf = 'inferred', why = 'Jabbar 151: plays only after the third row (Prog 1)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head to port bastok and into'}},
        {id = 's5', at = {n = 5, fp = 'once inside talk to jabbar to'},
         done = {
            {t = 'event', zone = 236, event = 151, why = 'Jabbar or Silver Owl 151: the form handed over'},
            {t = 'chat', re = 'Ah, you have come from headquarters%.', why = 'Jabbar 151 (say #6748)'},
            {t = 'ki', id = 121, gained = true, why = 'Tenshodo application form obtained'},
            {t = 'ki_have', id = 121, have = true, why = 'Tenshodo application form held'},
            {t = 'event', zone = 236, event = 152, conf = 'inferred', why = 'Jabbar 152: the same talk again, only while holding the form'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to ghebi damomohe to receive'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (107 and 108 also play when the Tenshodo Invite cannot be given)'},
            {t = 'ki', id = 121, gained = false, after = 's5', why = 'Tenshodo application form deleted by the completing event'},
         },
         reach = {
            {t = 'event', zone = 245, event = 107, why = 'Ghebi Damomohe 107: the form handed over (the Invite needs a free slot)'},
         }},
        {id = 's7', kind = 'branch', at = {n = 7, fp = 'search the auction house ah others'},
         done = {},
         reach = {
            {t = 'event', zone = 245, event = 108, why = 'Ghebi Damomohe 108: a Tenshodo Invite traded (the reward needs a free slot)'},
         }},
    },
}
