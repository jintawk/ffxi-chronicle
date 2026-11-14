-- Step progress for Secrets of Ovens Lost (Other Areas quest 73). Data only; see progress/quests/sandoria/27.lua for the format.
-- The quest log stays silent until Jonette 506 begins the quest (s2): Despachiaire 505 only sets a server variable.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Secrets_of_Ovens_Lost.lua (Despachiaire 505 sets Option 1; Jonette 506 begins
-- the quest; the ??? in Phomiuna Aqueducts or in Sacrarium gives the Tavnazian cookbook, Temporary KI 622, at Prog 1; Jonette 508
-- plays while it is held, takes it and completes the quest unless the reward cannot be given; once completed and the conquest
-- tally has passed, Jonette 507 begins the quest again); client event script S4 026_Jonette_0101A073.txt (506 say #11170, 507 say
-- #11179, 508 say #11177) and 026_Despachiaire_0101A009.txt (505 is bare). The draft completed the quest at the begin step; the
-- hand-in and the completion belong to the cookbook bullets, whose "Return to Jonette" lines are indented sub-bullets. The two
-- routes are alternatives and the key item arrives from either, so the first route (Phomiuna) carries the evidence and the
-- Sacrarium route is a branch with none. Jonette 507 starts a repeat: the restart step is s2, with s1 skipped.
return {
    title = 'Secrets of Ovens Lost',
    completes = 's3',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    repeatable = {restart = {'s2'}, skip = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to despachiaire in tavnazian safehold'},
         done = {
            {t = 'event', zone = 26, event = 505, run1 = true, why = 'Despachiaire 505'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to jonette on the middle'},
         done = {
            {t = 'event', zone = 26, event = 506, run1 = true, why = 'Jonette 506: begins the quest'},
            {t = 'chat', re = "Ah, you wouldn't happen to be an adventurer, would you%?", run1 = true, why = 'Jonette 506 (say #11170)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 26, event = 507, why = 'Jonette 507: begins the quest again after a conquest tally'},
            {t = 'chat', re = 'The information you have brought me on Tavnazian cuisine has been a wonderful help!', why = 'Jonette 507 (say #11179)'},
         }},
        {id = 's3', at = {n = 3, fp = 'phomiuna aqueducts walkthrough'},
         done = {
            {t = 'ki', id = 622, gained = true, why = 'Tavnazian cookbook obtained'},
            {t = 'ki_have', id = 622, have = true, why = 'Tavnazian cookbook held'},
            {t = 'chat', re = 'obtained key item: tavnazian cookbook', why = 'chat: key item obtained'},
            {t = 'event', zone = 26, event = 508, after = 's2', why = 'Jonette 508: the cookbook handed over, completes the quest'},
            {t = 'chat', re = 'Your kindness is a blessing that will bring smiles to the dinner tables of Tavnazia%.', why = 'Jonette 508 (say #11177)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 622, gained = false, conf = 'inferred', why = 'Tavnazian cookbook handed over'},
         }},
        {id = 's4', kind = 'branch', at = {n = 4, fp = 'sacrarium walkthrough'}, done = {}},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'repeating the quest the quest can'}},
    },
}
