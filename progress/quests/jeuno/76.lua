-- Step progress for Beyond the Sun (Jeuno quest 76). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB05_2_Beyond_the_Sun.lua (the quest is never accepted: while it is available
-- and Shattering Stars is done, Maat plays 78, the job-dependent rematch dialogue, until all 15 jobs are beaten, and 74, the
-- wish cutscene, once they are; 74's finish runs quest:complete, which pays Maat's Cap, so 74 also plays when the bag is full
-- and is only a reach, and the quest log's completed bit carries the last step; 78 plays again after the completion). Client
-- event script S4 243_Maat_010F3031.txt (78 say #10527 and #10528 with the BC name by job, 74 say #11039 on). The quest log
-- stays silent until the completion. Bullet 1 is the rematch talk (Maat names the Testimony and the arena); bullet 2 (beat Maat
-- on every job) has no signal that is not a battlefield win on one of 15 jobs, so it stays a plain bullet, as do the notes in
-- bullets 3 and 4. Disagreement with the draft: it put the completion on bullet 1 and made bullet 4 a post step after it.
return {
    title = 'Beyond the Sun',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's5'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to maat at h 5'},
         done = {
            {t = 'event', zone = 243, event = 78, why = 'Maat 78: the rematch dialogue (names the arena and the Testimony)'},
            {t = 'chat', re = "Now that you've reached the stars, there's nothing left that I can do for you%.", why = 'Maat 78 (say #10527)'},
         }},
        {id = 's5', at = {n = 5, fp = 'upon defeating maat for the last'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 243, event = 74, why = 'Maat 74: the wish cutscene (also plays when the bag is full)'},
            {t = 'chat', re = 'I remember every single blow, every tiny shift of your stance%.', why = 'Maat 74 (say #11040)'},
         }},
    },
}
