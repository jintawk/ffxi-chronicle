-- Step progress for The Pursuit of Paradise (the Tenzen path of Three Paths, page id 550). Data only; see progress/missions/cop/530.lua, whose tenzen group
-- carries the same steps with the same matchers: each is proved by nibble 3 of the CoP progress word (the server's status of the path) and
-- by the NPC events of LandSandBoat scripts/missions/cop/5_3_Three_Paths.lua and the client scripts it names (Monberaux 74/5/6, Pherimociel 58, La Theine ??? 203, Pso'Xja events 3, 4, 5, Cermet Door 25, Cid 854; key items 612, 613). The single group starts
-- when the cop line moves to 530. The last bullet (Cid, status 14) is the page's completion.
-- The Disaster Idol kill, the first Batallia ??? cutscene (event 0 only sets a script variable), the maze and the "other 2 paths" bullet have
-- no signal of their own and stay plain bullets or notes.

return {
    title = 'The Pursuit of Paradise',
    completes = 's20',
    known = {{t = 'mission', line = 'cop', eq = 530}},
    groups = {main = {start = {{t = 'mission', line = 'cop', eq = 530, completed = false, why = 'mission line: current mission = Three Paths'}}}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'head to g 6 in la'},
         done = {
            {t = 'word', nib = 3, min = 2, max = 2, why = 'Tenzen status 2: La Theine ??? 203 (:303-306)'},
            {t = 'event', zone = 102, event = 203, why = 'La Theine Plateau ??? 203 (status 0 only; LandSandBoat only, no client script)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'head to the tower at j'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'this tower is not a maze'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'after you have made your way'}},
        {id = 's6', at = {n = 6, fp = 'check the avatar gate at the'},
         done = {
            {t = 'word', nib = 3, min = 3, max = 4, why = 'Tenzen status 3: Pso\'Xja gate cutscene 3 (:313-319, 342-343)'},
            {t = 'event', zone = 9, event = 3, why = 'Pso\'Xja gate cutscene 3 (status 2 only; LandSandBoat only)'},
         }},
        {id = 's7', at = {n = 7, fp = 'head to g 10 in upper'},
         done = {
            {t = 'word', nib = 3, min = 5, max = 5, why = 'Tenzen status 5: Monberaux 74 (:379-381)'},
            {t = 'event', zone = 244, event = 74, why = 'Monberaux 74 (status 3 only)'},
            {t = 'ki', id = 612, gained = true, why = 'envelope from Monberaux obtained'},
            {t = 'event', zone = 244, event = 5, conf = 'inferred', why = 'Monberaux 5: the reminder at status 5'},
            {t = 'chat', re = 'the boy first appeared in delkfutt', conf = 'inferred', why = 'Monberaux 5 (say #8403)'},
            {t = 'chat', re = 'obtained key item: envelope from monberaux', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'speak with pherimociel at g 6'},
         done = {
            {t = 'word', nib = 3, min = 6, max = 7, why = 'Tenzen status 6: Pherimociel 58 (:397-400)'},
            {t = 'event', zone = 243, event = 58, why = 'Pherimociel 58 (status 5 only)'},
         }},
        {id = 's9', kind = 'optional', at = {n = 9, fp = 'return to monberaux in upper jeuno'},
         done = {
            {t = 'event', zone = 244, event = 6, why = 'Monberaux 6 (Tenzen status 6 only; LandSandBoat gates nothing on it)'},
            {t = 'chat', re = 'i see by his reaction that wolfgang understood', why = 'Monberaux 6 (say #8405)'},
         }},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'enter batallia downs from upper jeuno'}},
        {id = 's11', at = {n = 11, fp = 'check the again to obtain a'},
         done = {
            {t = 'word', nib = 3, min = 8, max = 8, why = 'Tenzen status 8: the ??? in Batallia Downs, event 1 (:426-429)'},
            {t = 'ki', id = 613, gained = true, why = 'Delkfutt recognition device obtained'},
            {t = 'chat', re = 'obtained key item: delkfutt recognition device', why = 'chat: key item obtained'},
         }},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'head to the entrance of lower'}},
        {id = 's13', kind = 'note', with = 's14', at = {n = 13, fp = 'go to h 5 on the'}},
        {id = 's14', at = {n = 14, fp = 'after you defeat the disaster idol'},
         done = {
            {t = 'word', nib = 3, min = 9, max = 10, why = 'Tenzen status 9: Cermet Door cutscene 25 (:466-469)'},
            {t = 'event', zone = 184, event = 25, why = 'Lower Delkfutt\'s Tower Cermet Door cutscene 25 (status 8, Idol killed)'},
         }},
        {id = 's15', at = {n = 15, fp = 'head to the tower at h'},
         done = {
            {t = 'word', nib = 3, min = 11, max = 11, why = 'Tenzen status 11: Pso\'Xja zone-in cutscene 4 (:331-347)'},
            {t = 'zonein', zone = 9, event = 4, why = 'Pso\'Xja zone-in cutscene 4 (status 9 only)'},
         }},
        {id = 's16', kind = 'note', with = 's19', at = {n = 16, fp = 'there are a few one way'}},
        {id = 's17', kind = 'note', with = 's19', at = {n = 17, fp = 'head west through the wall and'}},
        {id = 's18', kind = 'note', with = 's19', at = {n = 18, fp = 'exit the room to the south'}},
        {id = 's19', at = {n = 19, fp = 'take the elevator down to the'},
         done = {
            {t = 'word', nib = 3, min = 12, max = 13, why = 'Tenzen status 12: Pso\'Xja gate cutscene 5 (:322-327, 350-351)'},
            {t = 'event', zone = 9, event = 5, why = 'Pso\'Xja gate cutscene 5 (status 11 only; LandSandBoat only)'},
         }},
        {id = 's20', at = {n = 20, fp = 'return to cid once again to'},
         done = {
            {t = 'word', nib = 3, min = 14, max = 14, why = 'Tenzen status 14: Cid 854 (:487-489)'},
            {t = 'event', zone = 237, event = 854, why = 'Cid 854 (status 12 only)'},
         }},
    },
}
