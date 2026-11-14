-- Step progress for Dawn (Chains of Promathia 8-4, mission id 840). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/8_4_Dawn.lua and quests/hiddenQuests/Trust_Ulmia.lua / Trust_Prishe.lua (no client
-- script for any of these events, so all are LandSandBoat only); key item 716 (Tear of Altana) and items 15543 to 15545 (the three
-- rings) from res. The Cermet Portal in the Garden (_0zy, Ru'Hmet 35) plays 140 / 141 (bullet 1). The Transcendental Radiance in
-- Empyreal Paradox (36) plays 2 at status 0 (bullet 3); the descent (bullet 2) and the fight leave no event, and 32001 is a
-- battlefield exit, never proof, so bullets 2 and 4 to 8 are notes on bullet 9, which the two zone-in cutscenes after the win prove
-- (6 at status 2, 3 at status 3, with the Tear of Altana and the JST midnight timer). The five side cutscenes of bullet 12 are
-- indented sub-bullets (and bullets 10 to 12 are plain text), so they are not steps; bullet 13 (the Palace trigger area in Ru'Lude
-- Gardens, 122, needs all five done), 14 (the Marble Bridge door, 129), 16 (the Walnut Door, 543) and 17 (the Blueblade Fell trigger
-- area in Lufaise Meadows, 116) are one event each. Bullet 15 (choose a ring) is optional: the ring menu (84 / 204) plays on a
-- refusal and the choice can be put off, so only a ring gained marks it. The mission completes through the Norg quest menus (events
-- 232 / 234 with an option 1 to 4 at status 8), which play on a refusal too, so bullet 18 rests on the mission log alone. The trust
-- bullets are optional and proved by the server's learn line (zone text YOU_LEARNED_TRUST). The draft's repeat guess is dropped (the
-- page says repeatable but LandSandBoat has no repeat run), as are Hinaree 757 / 758, the Uleguerand zone-in 17 and the other side
-- cutscenes, and bullets 21 to 26 stay plain bullets.
-- Trust bullet left plain: the learned line is not in client scripts or LandSandBoat text.
return {
    title = 'Dawn',
    completes = 's18',
    known = {{t = 'mission', line = 'cop', eq = 840}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into the garden of ru'},
         done = {
            {t = 'event', zone = 35, event = 140, why = "Cermet Portal 140 in the Garden of Ru'Hmet (south side, mission 840 or later)"},
            {t = 'event', zone = 35, event = 141, why = "Cermet Portal 141 in the Garden of Ru'Hmet (north side, mission 840 or later)"},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'choose to descend to zone into'}},
        {id = 's3', at = {n = 3, fp = 'check the transcendental radiance for'},
         done = {
            {t = 'event', zone = 36, event = 2, why = 'Transcendental Radiance 2 (status 0)'},
         }},
        {id = 's4', kind = 'note', with = 's9', at = {n = 4, fp = 'see final cutscenes below to receive'}},
        {id = 's5', kind = 'note', with = 's9', at = {n = 5, fp = 'prishe joins you for this fight'}},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'selh teus joins you for this'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'if the entire party is ko'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'promathia has low evasion and is'}},
        {id = 's9', at = {n = 9, fp = 'promathia has two forms once'},
         done = {
            {t = 'zonein', zone = 36, event = 6, why = 'Empyreal Paradox zone-in cutscene 6 after the win (status 2)'},
            {t = 'zonein', zone = 36, event = 3, why = 'Empyreal Paradox zone-in cutscene 3: the Tear of Altana (status 3)'},
            {t = 'ki', id = 716, gained = true, why = 'Tear of Altana obtained'},
            {t = 'chat', re = 'obtained key item: tear of altana', why = 'chat: key item obtained'},
         }},
        {id = 's13', at = {n = 13, fp = 'once you ve completed the previous'},
         done = {
            {t = 'event', zone = 243, event = 122, why = "Ru'Lude Gardens Palace trigger area 122 (status 4, all side cutscenes seen)"},
         }},
        {id = 's14', at = {n = 14, fp = 'head to upper jeuno and click'},
         done = {
            {t = 'event', zone = 244, event = 129, why = 'Marble Bridge door 129 (status 5)'},
         }},
        {id = 's15', kind = 'optional', at = {n = 15, fp = 'click on the marble bridge door'},
         done = {
            {t = 'item', id = 15543, gained = true, conf = 'inferred', why = 'Rajas Ring gained'},
            {t = 'item', id = 15544, gained = true, conf = 'inferred', why = 'Sattva Ring gained'},
            {t = 'item', id = 15545, gained = true, conf = 'inferred', why = 'Tamas Ring gained'},
         },
         reach = {
            {t = 'event', zone = 244, event = 84, why = 'Marble Bridge door 84: the ring menu (first time)'},
            {t = 'event', zone = 244, event = 204, why = 'Marble Bridge door 204: the ring menu'},
         }},
        {id = 's16', at = {n = 16, fp = 'head to tavnazian safehold home point'},
         done = {
            {t = 'event', zone = 26, event = 543, why = 'Walnut Door 543 (status 6)'},
         }},
        {id = 's17', at = {n = 17, fp = 'head to lufaise meadows and approach'},
         done = {
            {t = 'event', zone = 24, event = 116, why = 'Blueblade Fell trigger area 116 (status 7): the final cutscene'},
         }},
        {id = 's18', at = {n = 18, fp = 'after all cutscenes are over you'},
         done = {
            {t = 'mission', line = 'cop', eq = 840, completed = true, why = 'mission log: Dawn completed (Norg, status 8)'},
         }},
    },
}
