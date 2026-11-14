-- Step progress for Yomi Okuri (Outlands quest 141). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/SAM_AF2_Yomi_Okuri.lua. Jaucribaix 146 is the offer (a yes/no menu, the finish
-- begins the quest on option 1) so it is a reach and the accept lines are the proof; 142 plays before the quest (must-zone wait)
-- and proves nothing. Washu 148 (Prog 1, progressEvent) is the first talk; the trade event 150 plays only when the four items
-- match and gives Washu's tasty wurst (461). The ??? in the Labyrinth of Onzozo: event 0 needs the wurst and plays on a refusal
-- too (option 1 spawns Ubume and takes the wurst), so the wurst being taken is the proof; event 1 gives the Yomotsu feather
-- (462). Jaucribaix 152 takes the feather (played only with it held), 154 gives Yomotsu Hirasaka (463) after the zone wait (153
-- is the wait line). The ??? in Valkurm Dunes: event 10 (night, with 463) plays on a refusal too, its accept option spawns Doman
-- and Onryo with "sudden chill" (Valkurm IDs SUDDEN_CHILL, used by this quest only); event 11 swaps 463 for the faded one (464)
-- on option 0. Jaucribaix 156 runs quest:complete. Client event script S4 252_Jaucribaix_010FC010.txt (146 accept branch say
-- #10670, 147 say #10689, 152 say #10690, 153 say #10691, 154 say #10692/#10693, 155 say #10694, 156 say #10696); there are no
-- client scripts for the Onzozo and Valkurm ??? events (LandSandBoat only). The quest log is set at s1, so it is not silent.
-- Bullet 6 is a real step here (event 152 hands the feather over), not a travel note. The page says repeatable after a memory
-- reset; nothing observable marks a second run, so there is no `repeatable` entry.
return {
    title = 'Yomi Okuri',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to jaucribaix in norg k'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jaucribaix 146, yes)'},
            {t = 'chat', re = "Now let me show you into Gilgamesh's quarters%.", why = 'Jaucribaix 146, accept branch (say #10670)'},
            {t = 'event', zone = 252, event = 147, conf = 'inferred', why = 'Jaucribaix 147: his talk, only while accepted before the feather'},
            {t = 'chat', re = "Do not forget to obtain some of Washu's tasty wurst before you set off for the Labyrinth of Onzozo%.", conf = 'inferred', why = 'Jaucribaix 147 (say #10689)'},
         },
         reach = {{t = 'event', zone = 252, event = 146, why = 'Jaucribaix 146 offered (its finish needs the yes option)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to washu at j 8'},
         done = {
            {t = 'event', zone = 252, event = 148, why = 'Washu 148: first talk, Prog 1'},
            {t = 'chat', re = "So you're the adventurer that Gilgamesh sent, eh%?", why = 'Washu 148 (say #10699)'},
            {t = 'event', zone = 252, event = 149, conf = 'inferred', why = 'Washu 149: his reminder, only after 148'},
            {t = 'chat', re = 'What, did you forget what I need you to bring already%?', conf = 'inferred', why = 'Washu 149 (say #10703)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade washu bastore sardine frost turnip'},
         done = {
            {t = 'event', zone = 252, event = 150, why = 'Washu 150: the four items accepted, gives the wurst'},
            {t = 'chat', re = 'Well, that was quick%. Pretty good for an adventurer%.', why = 'Washu 150 (say #10704)'},
            {t = 'ki', id = 461, gained = true, why = "Washu's tasty wurst obtained"},
            {t = 'ki_have', id = 461, have = true, why = "Washu's tasty wurst held"},
            {t = 'chat', re = "obtained key item: washu's tasty wurst", why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 151, conf = 'inferred', why = 'Washu 151: his talk once the wurst is held'},
            {t = 'chat', re = "Why are you still here%? You've got to get my bait to the birdy before it goes bad%.", conf = 'inferred', why = 'Washu 151 (say #10707)'},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the in labyrinth of onzozo'},
         done = {
            {t = 'ki', id = 461, gained = false, after = 's3', why = "Washu's tasty wurst taken at the ??? (option 1 spawns Ubume)"},
         },
         reach = {{t = 'event', zone = 213, event = 0, after = 's3', why = '??? 0 offered (its finish needs option 1)'}}},
        {id = 's5', at = {n = 5, fp = 'examine the after defeating ubume to'},
         done = {
            {t = 'ki', id = 462, gained = true, why = 'yomotsu feather obtained'},
            {t = 'ki_have', id = 462, have = true, why = 'yomotsu feather held'},
            {t = 'chat', re = 'obtained key item: yomotsu feather', why = 'chat: key item obtained'},
            {t = 'event', zone = 213, event = 1, after = 's3', why = '??? 1: gives the feather after Ubume'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to norg and speak to'},
         done = {
            {t = 'event', zone = 252, event = 152, after = 's5', why = 'Jaucribaix 152: takes the feather'},
            {t = 'chat', re = 'is exactly what I need to complete the sacred katana%.', why = 'Jaucribaix 152 (say #10690)'},
            {t = 'ki', id = 462, gained = false, after = 's5', conf = 'inferred', why = 'yomotsu feather handed over'},
            {t = 'event', zone = 252, event = 153, after = 's5', conf = 'inferred', why = 'Jaucribaix 153: the wait line, only after 152'},
            {t = 'chat', re = 'Do not rush me! This job requires extreme concentration%.', after = 's5', conf = 'inferred', why = 'Jaucribaix 153 (say #10691)'},
         }},
        {id = 's7', at = {n = 7, fp = 'exit norg re enter and speak'},
         done = {
            {t = 'event', zone = 252, event = 154, why = 'Jaucribaix 154: gives Yomotsu Hirasaka'},
            {t = 'chat', re = 'It is during this time beyond dusk that you must thrust', why = 'Jaucribaix 154 (say #10693)'},
            {t = 'ki', id = 463, gained = true, why = 'Yomotsu Hirasaka obtained'},
            {t = 'ki_have', id = 463, have = true, why = 'Yomotsu Hirasaka held'},
            {t = 'chat', re = 'obtained key item: yomotsu hirasaka', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 155, conf = 'inferred', why = 'Jaucribaix 155: his talk once Hirasaka is held'},
            {t = 'chat', re = 'From the hour in which the sands are ruled by darkness until they once again are graced by light%.%.%.', conf = 'inferred', why = 'Jaucribaix 155 (say #10694)'},
         }},
        {id = 's8', at = {n = 8, fp = 'examine the in valkurm dunes at'},
         done = {
            {t = 'chat', re = 'You feel a sudden chill in the air%.', after = 's7', why = 'Doman and Onryo spawn (Valkurm SUDDEN_CHILL)'},
         },
         reach = {{t = 'event', zone = 103, event = 10, after = 's7', why = '??? 10 offered (its finish needs option 1)'}}},
        {id = 's9', at = {n = 9, fp = 'examine the after defeating doman and'},
         done = {
            {t = 'ki', id = 464, gained = true, why = 'faded Yomotsu Hirasaka obtained'},
            {t = 'ki_have', id = 464, have = true, why = 'faded Yomotsu Hirasaka held'},
            {t = 'chat', re = 'obtained key item: faded yomotsu hirasaka', why = 'chat: key item obtained'},
            {t = 'ki', id = 463, gained = false, after = 's7', conf = 'inferred', why = 'Yomotsu Hirasaka handed over'},
         },
         reach = {{t = 'event', zone = 103, event = 11, after = 's7', why = '??? 11 offered (its finish needs option 0)'}}},
        {id = 's10', at = {n = 10, fp = 'speak to jaucribaix to receive your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 252, event = 156, why = 'Jaucribaix 156: runs quest:complete'},
            {t = 'chat', re = 'Gilgamesh has asked me to present you with this as a token of our appreciation%.', why = 'Jaucribaix 156 (say #10696)'},
            {t = 'ki', id = 464, gained = false, conf = 'inferred', why = 'faded Yomotsu Hirasaka handed over'},
         }},
    },
}
