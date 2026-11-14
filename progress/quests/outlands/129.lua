-- Step progress for Forge Your Destiny (Outlands quest 129). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Forge_Your_Destiny.lua (Jaucribaix 25 offers it, option 1 begins it; Aeka 44 gives the
-- Oriental Steel and sets Option bit 0, 45 and 49 are reminders while the steel or the Bomb Steel is held, 46 and 47 need that bit (47
-- is the Darksteel trade for a replacement); Ranemaud 40 gives the Sacred Sprig and sets Option bit 1, 41 and 48 are reminders, 42 and
-- 43 need that bit; the Konschtat qm3 and Zi'Tah qm2 raise no event, only zone text, which plays on success only; Jaucribaix 27 takes
-- the Bomb Steel and Sacred Branch and sets the 3-day wait, 28 plays during it and Aeka 50 only once it is set, 29 plays when it is over
-- and runs quest:complete). Client event scripts S4 252_Jaucribaix_010FC010.txt (25 say #10199, 26 say #10203, 27 say #10206, 28 say
-- #10209, 29 say #10211), 252_Aeka_010FC013.txt (44, 45, 46, 47, 49 say #10246, 50 say #10247), 252_Ranemaud_010FC00D.txt (40, 41, 42, 43,
-- 48). Zone text: Konschtat_Highlands/IDs.lua 7463 (the steel placed, plays only when the Forger spawns), The_Sanctuary_of_ZiTah/IDs.lua 7790
-- (the Treant spawns) and 7792 (the Sacred Branch sprouts). Item ids from res/items.lua (1151 Oriental Steel, 1152 Bomb Steel, 1153 Sacred
-- Branch, 1198 Sacred Sprig): they come only from this quest but an item alone is never proof, so they carry inferred.
-- Events 44 and 40 are reach only: each gives its item in the finish, so it also plays when the bag is full and nothing is given. Event
-- 29 runs quest:complete but the reward includes the Mumeito, so it also plays on a full bag: reach, and the log's completed bit proves
-- s9. The page's Aeka and Ranemaud bullets can be done in either order. The Mumeito tip (n=10) is a note on the last step. Not repeatable.
return {
    title = 'Forge Your Destiny',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to jaucribaix in norg k'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jaucribaix 25, option 1)'},
            {t = 'chat', re = 'I am grateful for your assistance%.', why = 'Jaucribaix 25, Yes branch only (say #10199)'},
            {t = 'event', zone = 252, event = 26, conf = 'inferred', why = 'Jaucribaix 26: his reminder, only while accepted and before the trade'},
            {t = 'chat', re = 'To learn of where you may come across the items I wish you to bring me', conf = 'inferred', why = 'Jaucribaix 26 (say #10203)'},
         },
         reach = {{t = 'event', zone = 252, event = 25, why = 'Jaucribaix 25 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to aeka i 8 to'},
         done = {
            {t = 'event', zone = 252, event = 46, after = 's1', why = 'Aeka 46: needs Option bit 0, set once the steel was given'},
            {t = 'event', zone = 252, event = 47, after = 's1', why = 'Aeka 47: the Darksteel Ore traded for a replacement steel'},
            {t = 'event', zone = 252, event = 45, after = 's1', conf = 'inferred', why = 'Aeka 45: plays only while the Oriental Steel is held'},
            {t = 'chat', re = 'Place the .- on the charred area in a cave', after = 's1', conf = 'inferred', why = 'Aeka 45 (say #10242)'},
            {t = 'item', id = 1151, gained = true, after = 's1', conf = 'inferred', why = 'Oriental Steel gained (items can come from elsewhere)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 44, after = 's1', why = 'Aeka 44 (also plays when the bag is full and nothing is given)'},
            {t = 'chat', re = 'Master Jaucribaix sent you%. Then I guess I have to give you this%.', after = 's1', why = 'Aeka 44 (say #10236)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to ranemaud i 7 to'},
         done = {
            {t = 'event', zone = 252, event = 42, after = 's1', why = 'Ranemaud 42: needs Option bit 1, set once the sprig was given'},
            {t = 'event', zone = 252, event = 43, after = 's1', why = 'Ranemaud 43: the gold and platinum ore traded for a replacement sprig'},
            {t = 'event', zone = 252, event = 41, after = 's1', conf = 'inferred', why = 'Ranemaud 41: plays only while the Sacred Sprig is held'},
            {t = 'item', id = 1198, gained = true, after = 's1', conf = 'inferred', why = 'Sacred Sprig gained (items can come from elsewhere)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 40, after = 's1', why = 'Ranemaud 40 (also plays when the bag is full and nothing is given)'},
            {t = 'chat', re = 'So, you need .-%. I see Master Jaucribaix is starting another project', after = 's1', why = 'Ranemaud 40 (say #10227)'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel to konschtat highlands d 8'},
         done = {
            {t = 'chat', re = 'You place .- on the blackened spot%.', after = 's1', why = 'Konschtat Highlands text 7463: the steel placed, only when the Forger spawns'},
         }},
        {id = 's5', at = {n = 5, fp = 'once the forger is defeated a'},
         done = {
            {t = 'event', zone = 252, event = 49, after = 's1', conf = 'inferred', why = 'Aeka 49: plays only while the Bomb Steel is held'},
            {t = 'chat', re = 'I see you made it back safely%.', after = 's1', conf = 'inferred', why = 'Aeka 49 (say #10246)'},
            {t = 'item', id = 1152, gained = true, after = 's1', conf = 'inferred', why = 'Bomb Steel gained (items can come from elsewhere)'},
         }},
        {id = 's6', at = {n = 6, fp = 'purchase a hatchet and travel to'},
         done = {
            {t = 'chat', re = 'You can sense a strong, evil presence!', after = 's1', why = "Sanctuary of Zi'Tah text 7790: the Treant spawns on the hatchet"},
         }},
        {id = 's7', at = {n = 7, fp = 'once the treant is defeated trade'},
         done = {
            {t = 'chat', re = 'The strange force has vanished, and .- has newly sprouted in the cut!', after = 's1', why = "Sanctuary of Zi'Tah text 7792: only when the branch is given"},
            {t = 'event', zone = 252, event = 48, after = 's1', conf = 'inferred', why = 'Ranemaud 48: plays only while the Sacred Branch is held'},
            {t = 'chat', re = 'Welcome back from your journey%.', after = 's1', conf = 'inferred', why = 'Ranemaud 48 (say #10235)'},
            {t = 'item', id = 1153, gained = true, after = 's1', conf = 'inferred', why = 'Sacred Branch gained (items can come from elsewhere)'},
         }},
        {id = 's8', at = {n = 8, fp = 'trade the bomb steel and the'},
         done = {
            {t = 'event', zone = 252, event = 27, after = 's1', why = 'Jaucribaix 27: the Bomb Steel and Sacred Branch accepted, sets the wait'},
            {t = 'chat', re = 'Wonderful%. These are the materials that I require%.', after = 's1', why = 'Jaucribaix 27 (say #10206)'},
            {t = 'event', zone = 252, event = 28, after = 's1', why = 'Jaucribaix 28: plays only during the wait the trade started'},
            {t = 'chat', re = 'My work is not yet complete%.', after = 's1', why = 'Jaucribaix 28 (say #10209)'},
            {t = 'event', zone = 252, event = 50, after = 's1', why = 'Aeka 50: plays only once the wait is set'},
            {t = 'chat', re = 'You do not have to worry about your reward%.', after = 's1', why = 'Aeka 50 (say #10247)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return in 72 in game hours'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Jaucribaix 29)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 29, after = 's1', why = 'Jaucribaix 29 (also plays when the bag is full: the Mumeito is not given)'},
            {t = 'chat', re = 'you have finally returned%.', after = 's1', why = 'Jaucribaix 29 (say #10211)'},
         }},
        {id = 's10', kind = 'note', with = 's9', at = {n = 10, fp = 'the mumeito is required to do'}},
    },
}
