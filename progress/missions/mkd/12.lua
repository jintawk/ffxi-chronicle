-- Step progress for A Challenge! You Could Be a Winner (A Moogle Kupo d'Etat mission 13, mission id 12). Data only; see
-- progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/amk/13_A_Challenge_You_Could_Be_a_Winner.lua (+ helpers.lua puzzle functions) and the
-- client scripts 161_Shadowy_Pillar_010A1158, 161_Flame_of_Fate_010A1159, 111_Lonely_Evergreen_0106F1AF, 111_Goblin_Grenadier_0106F1B1
-- and 162_Ominous_Pillar_010A2146 in the client's event pseudo-code, . The mission is four puzzles in sequence.
-- 1 Shadowy Pillar, Castle Zvahl Baileys (161), event 100: LandSandBoat sends P0 = 3 until the Gauntlet Challenge Kupon (1155) is held;
--   the client's P0 = 3 branch is the briefing (say #7613, "prove your mettle at our Xarcabard trivia challenge"), a plain cutscene
--   without a refusal. The draft's line "Splendid! Ladies and gentlemen" (#7598) is the accept branch of the gauntlet start (P0 = 1,
--   bullet 12), not this bullet.
-- 2 Lonely Evergreen, Beaucedine Glacier (111), event 504: a menu; "Sure" (say #7405 "That's the spirit, kupo!") needs option 1, which
--   sets needToZone, "No thanks" (#7404) does not. So 504 is `reach` and the accept-only line proves the bullet, as does the reminder
--   503 ("First you'll have to speak with my Gobbie associate"), which plays only while needToZone is set.
-- 3 Goblin Grenadier (111): 509 is the "busy Gobbie" brush-off without the Map of the Northlands Area (`reach`; it only plays after the
--   accept); 508 plays when the puzzle is not yet set (first talk with the map) and 507 once it is, so either proves bullet 3.
-- 4 to 6 puzzle one (the six Pips, the password): bullets 4 and 5 are notes on bullet 7; bullet 6 (the pocket mogbomb, 1157, given by
--   the Grenadier's finish on a correct guess) stays a plain bullet, the prize being its only signal. 7 Lonely Evergreen 502 plays
--   only with the mogbomb held, takes it and gives the Trivia Challenge Kupon (1154); the event, the mogbomb taken and the line
--   ("no particular reason at all") prove it.
-- 8 to 11 puzzle two (Xarcabard, three Options): the win gives the Gauntlet Challenge Kupon (1155) and takes the Trivia Challenge Kupon
--   (puzzleTwoOnEventFinish); the Option events (200) play on every question and every wrong answer, so they prove nothing. Bullets 8 to
--   10 are notes on bullet 11 ("Upon winning"), whose proof is the Trivia kupon taken (the Gauntlet kupon gained is a reward and is not used).
-- 12 puzzle three: Shadowy Pillar 100 with P0 = 1 (kupon held, not yet running) offers the run behind two menus, and only option 1 starts
--   it, so the offer and the accept-only line "Splendid!" are `reach`. The Flame of Fate (161) 101 with P0 = 2 means the 8 minutes were
--   met (P0 = 1 too late, 4 no run, 3 the reminder after a win); its finish takes the Gauntlet kupon and gives the Festival Souvenir
--   Kupon (1156), so event 101 with P0 = 2, the Gauntlet kupon taken and the line "redeem this for a truly spectacular prize" (#7611, plays
--   on P0 = 2 and 3) prove it.
-- 13 puzzle four: Ominous Pillar, Castle Zvahl Keep (162), event 100: P0 = 1 is the first talk with a menu ("Let's do it" #7277 or
--   "Do your own job" #7276), P0 = 2 the repeat once a cohort was assigned. The accept line and the repeat prove the bullet, the first
--   talk is `reach`. 14 Craggy Pillars (events 101 to 104, P0 = 1 on the right one, 2 on a wrong one): the right pillar's finish gives
--   the Mega Bonanza Kupon (1159) and takes the Festival Souvenir Kupon, so P0 = 1 on any of the four, or the
--   Festival kupon taken, prove it. 15 is a travel note on the door step.
-- 16 Throne Room door (165, `_4l1`) plays event 4 with the Mega Bonanza Kupon held and its finish calls mission:complete (the draft's
--   "? 101" at zone 162 is the first Craggy Pillar). The mkd line has no completed set in Chronicle (core/data.lua get_mission_read), so
--   the completion is also the line moving past it (min = 13).
return {
    title = 'A Challenge! You Could Be a Winner',
    completes = 's16',
    known = {{t = 'mission', line = 'mkd', eq = 12}},
    groups = {main = {start = {{t = 'mission', line = 'mkd', eq = 12, why = 'mission line: current mission = A Challenge! You Could Be a Winner'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the shadowy pillar at castle'},
         done = {
            {t = 'event', zone = 161, event = 100, p = {[0] = 3}, why = 'Shadowy Pillar 100, P0 = 3: the briefing, no gauntlet kupon yet'},
            {t = 'chat', re = 'prove your mettle at our Xarcabard trivia challenge', why = 'Shadowy Pillar 100 (say #7613), P0 = 3 branch'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the lonely evergreen at the'},
         done = {
            {t = 'chat', re = "That's the spirit, kupo!", why = 'Lonely Evergreen 504 (say #7405): the accept branch'},
            {t = 'event', zone = 111, event = 503, why = 'Lonely Evergreen 503: the reminder, plays only after the accept (needToZone)'},
         },
         reach = {
            {t = 'event', zone = 111, event = 504, why = 'Lonely Evergreen 504 offered (its finish needs option 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to the tower at h'},
         done = {
            {t = 'event', zone = 111, event = 508, why = 'Goblin Grenadier 508: first talk with the Northlands map, the puzzle is set'},
            {t = 'event', zone = 111, event = 507, why = 'Goblin Grenadier 507: the puzzle in progress (plays after 508)'},
         },
         reach = {
            {t = 'event', zone = 111, event = 509, why = 'Goblin Grenadier 509: the busy Gobbie, no map yet'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'you will need to enter a'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'speak to the goblin grenadier to'}},
        {id = 's7', at = {n = 7, fp = 'return to the lonely evergreen at'},
         done = {
            {t = 'event', zone = 111, event = 502, why = 'Lonely Evergreen 502: plays only with the mogbomb held, hands over the Trivia Challenge Kupon'},
            {t = 'ki', id = 1157, gained = false, why = 'Pocket mogbomb handed over'},
            {t = 'chat', re = 'no particular reason at all, kupo!', why = 'Lonely Evergreen 502 (say #7412)'},
         }},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'in xarcabard you will find three'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'you must answer three questions correctly'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'you are given 2 options each'}},
        {id = 's11', at = {n = 11, fp = 'upon winning you will receive gauntlet'},
         done = {
            {t = 'ki', id = 1154, gained = false, why = 'Trivia Challenge Kupon taken: the trivia won (puzzleTwoOnEventFinish)'},
         }},
        {id = 's12', at = {n = 12, fp = 'zone into castle zvahl baileys and'},
         done = {
            {t = 'event', zone = 161, event = 101, p = {[0] = 2}, why = 'Flame of Fate 101, P0 = 2: reached within the time limit'},
            {t = 'ki', id = 1155, gained = false, why = 'Gauntlet Challenge Kupon taken at the Flame of Fate'},
            {t = 'chat', re = "You'll be able to redeem this for a truly spectacular prize", why = 'Flame of Fate 101 (say #7611), P0 = 2 or 3'},
         },
         reach = {
            {t = 'event', zone = 161, event = 100, p = {[0] = 1}, why = 'Shadowy Pillar 100, P0 = 1: the gauntlet offered (its finish needs option 1)'},
            {t = 'chat', re = 'Splendid! Ladies and gentlemen, our brave challenger will enter the fray!', why = 'Shadowy Pillar 100 (say #7598): the run accepted'},
            {t = 'event', zone = 161, event = 100, p = {[0] = 2}, why = 'Shadowy Pillar 100, P0 = 2: the run is on'},
         }},
        {id = 's13', at = {n = 13, fp = 'upon zoning into castle zvahl keep'},
         done = {
            {t = 'chat', re = 'a thousand thank%-yous, kind adventurer', why = 'Ominous Pillar 100 (say #7277): the errand accepted'},
            {t = 'event', zone = 162, event = 100, p = {[0] = 2}, why = 'Ominous Pillar 100, P0 = 2: the cohort already assigned'},
         },
         reach = {
            {t = 'event', zone = 162, event = 100, p = {[0] = 1}, why = 'Ominous Pillar 100, P0 = 1: first talk, a menu'},
         }},
        {id = 's14', at = {n = 14, fp = 'craggy pillars are pillars located somewhere'},
         done = {
            {t = 'event', zone = 162, event = 101, p = {[0] = 1}, why = 'Craggy Pillar 101 (Kupignol), P0 = 1: the right one'},
            {t = 'event', zone = 162, event = 102, p = {[0] = 1}, why = 'Craggy Pillar 102 (Kupert), P0 = 1: the right one'},
            {t = 'event', zone = 162, event = 103, p = {[0] = 1}, why = 'Craggy Pillar 103 (Kupuckl), P0 = 1: the right one'},
            {t = 'event', zone = 162, event = 104, p = {[0] = 1}, why = 'Craggy Pillar 104 (Kupatete), P0 = 1: the right one'},
            {t = 'ki', id = 1156, gained = false, why = 'Festival Souvenir Kupon taken by the right pillar'},
         }},
        {id = 's15', kind = 'note', with = 's16', at = {n = 15, fp = 'after obtaining the mega bonanza kupon'}},
        {id = 's16', at = {n = 16, fp = 'examine the throne room door for'},
         done = {
            {t = 'event', zone = 165, event = 4, why = 'Throne Room door 4: the cutscene, completes the mission'},
            {t = 'mission', line = 'mkd', min = 13, why = 'mission line: moved on to Smash! A Malevolent Menace (this one completed)'},
         }},
    },
}
