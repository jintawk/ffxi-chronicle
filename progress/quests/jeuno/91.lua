-- Step progress for The Road to Aht Urhgan (Jeuno quest 91). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/The_Road_to_Aht_Urhgan.lua (Faursel 10062 is the first cutscene and grants
-- nothing; only its option 1 sets Prog 1, and from then on a talk plays 10063, so 10063 proves the hidden option; the quest
-- is added to the log only when 10063 ends on option 2 or 3, which is the log's current bit; 10064 is the menu while accepted;
-- a trade of one of the lists plays 10069 only when it matches, and Faursel is the only NPC that takes it; 10070 completes
-- the trade route a day later and 10067 + 10068 the gil route, both with no item to refuse; 10071 plays once completed).
-- Client event script S4 245_Faursel_010F50BC.txt (10069 say #9588, 10071 say #9593; 10062, 10063, 10067, 10068, 10070 are
-- bare). Key ids from res/key_items.lua (781 boarding permit, 1858 map of Wajaom Woodlands). The quest log stays silent until
-- s3, so s1 and s2 are seen only through events. The trade (n=6) is a branch (paying 500,000 gil skips it); the four-way
-- menu and the item gathering (n=4, 5) are notes on it; the item lists (n=9 to 20) stay plain. The draft put the completion on bullet 1
-- and let event 10064 prove bullet 1; the menu is the second cutscene's. Bullet 8 (Naja Salaheem) has no signal here and
-- stays plain. The boarding permit and the Wajaom map are also given by other missions (Inescapable
-- Binds, Land of Sacred Serpents), so both count only after s3. Not repeatable (page meta).
return {
    title = 'The Road to Aht Urhgan',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to faursel neptune s spire'},
         done = {
            {t = 'event', zone = 245, event = 10062, why = 'Faursel 10062: the first cutscene'},
         }},
        {id = 's2', at = {n = 2, fp = 'he will give you three options'},
         done = {
            {t = 'event', zone = 245, event = 10063, why = 'Faursel 10063: plays only once the hidden option was chosen (Prog 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to faursel a second time'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (10063 ended on option 2 or 3)'},
            {t = 'event', zone = 245, event = 10064, conf = 'inferred', why = 'Faursel 10064: the menu, only while accepted'},
            {t = 'chat', re = "You say you want t' go to Aht Urhgan, but you're too big o' a coward to face a challenge, eh%?", conf = 'inferred', why = 'Faursel 10064, beginner list (say #9573)'},
         },
         reach = {{t = 'event', zone = 245, event = 10063, why = 'Faursel 10063 (its finish needs option 2 or 3)'}}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'faursel will give you four ways'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'collect the required item s for'}},
        {id = 's6', kind = 'branch', at = {n = 6, fp = 'trade the requested item s to'},
         done = {
            {t = 'event', zone = 245, event = 10069, why = 'Faursel 10069: a matching list accepted'},
            {t = 'chat', re = 'Exactly what I asked for!', why = 'Faursel 10069 (say #9588)'},
         }},
        {id = 's7', at = {n = 7, fp = 'zone and return to lower jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 245, event = 10070, why = 'Faursel 10070: the trade route, runs quest:complete'},
            {t = 'event', zone = 245, event = 10068, why = 'Faursel 10068: the gil route, runs quest:complete'},
            {t = 'ki', id = 781, gained = true, after = 's3', conf = 'inferred', why = 'boarding permit obtained (reward)'},
            {t = 'event', zone = 245, event = 10071, conf = 'inferred', why = 'Faursel 10071: plays only once completed'},
            {t = 'chat', re = "I 'ave got t' tell you up front, though, that the high seas are a dangerous place%.", conf = 'inferred', why = 'Faursel 10071 (say #9593)'},
         },
         reach = {
            {t = 'event', zone = 245, event = 10067, why = 'Faursel 10067: the gil route, the day after paying (warps to Wajaom)'},
            {t = 'ki', id = 1858, gained = true, after = 's3', why = 'map of Wajaom Woodlands obtained (gil route)'},
         }},
    },
}
