-- Step progress for Thanks for All the Fish (Outlands quest 203). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: none beyond the quest log. LandSandBoat has no script for this quest (its enum has no entry) and the client dump has no
-- Jourdenaux event script, so no event id or line can be tied to a bullet. The quest log's current bit is set when Jourdenaux
-- flags the quest (bullet 1; the Records of Eminence unlock in bullet 2 is the same moment), and its completed bit when the
-- Lu Shang's Fishing Rod is traded back (bullet 4). The 60 fish and the Fishing (Tenacity) objectives (bullet 3) are Records of
-- Eminence progress, not a packet Chronicle reads, so that bullet is a note on the last step. Not repeatable.
return {
    title = 'Thanks for All the Fish',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to jourdenaux while in possession'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jourdenaux)'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'this will unlock a new records'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'you must now do the following'}},
        {id = 's4', at = {n = 4, fp = 'after completing all of the objectives'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the rod traded back)'},
         }},
    },
}
