-- Step progress for The Emissary (Bastok mission 2-3, mission id 5). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/2_3_0..2_3_4 (The Emissary and its four sub-missions, ids 6 to 9 in the
-- nation line); client event scripts S4 (Naji 237, Helaku 231, Halver 233, Melek 240, Kupipi 242, Uu Zhoumo 145). The mission has
-- two orderings, and the page has a heading for each: San d'Oria first (bullets 6-16, group sd) and Windurst first (bullets 17-30,
-- group win), after the shared start (bullets 4-5, group main). The nation line holds 5, then the first path's sub-mission
-- (6 San d'Oria, 7 Windurst), back to 5 when that path is finished (its id joins the completed set), then the second path's
-- (9 Windurst after San d'Oria, 8 San d'Oria after Windurst), back to 5, and Naji 714 completes id 5. So ids 6 and 9 mark
-- the sd group, 7 and 8 the win group. Naji's 714 plays at the end of both, so its matcher waits for the group's previous step
-- (`after`). The completed id 5 alone cannot tell the orderings apart, so it also waits for the route's last leg (ids 6 and 9 = sd,
-- 7 and 8 = win, read from the completed set), which a character that finished before installing Chronicle, or is past the mission,
-- carries: the route taken shows finished and the other stays open (the snapshot is tried again once its ids are in, core/progress_engine.lua).
-- There is no `completes` step for that reason: the snapshot test of test_steps.lua feeds the completed id alone, and the finish is bullet 16 or 30.
-- Key items: 31 sword offering, 33 dull sword, 34 dark key, 13 Kindred crest (res/key_items.lua); the Letter to the consuls is
-- ids 5, 6 and 7 there with no way to tell which is Bastok's, so it is not used. The Kindred crest is handed over in both
-- orderings, so only the win group's crest step uses it, behind its previous step. None of the listed events plays on a refusal.
-- Events without a body in the pseudo-code (Naji 713 and 714, Gold Skull 53) take their ids from LandSandBoat and the NPCs' event
-- lists. Killing Warchief Vatgit and the Aspir Knife drop have no signal of their own; the next NPC talk (543, 41) proves them.
return {
    title = 'The Emissary',
    known = {{t = 'mission', line = 'bastok', eq = 5}},
    steps = {
        {id = 's4', group = 'main', at = {n = 4, fp = 'talk to naji outside the president'},
         done = {
            {t = 'event', zone = 237, event = 713, why = 'Naji 713: the escort to President Karst, the Letter to the consuls handed over'},
         }},
        {id = 's5', group = 'main', kind = 'note', with = 's4', at = {n = 5, fp = 'you will be able to ask'}},

        {id = 's6', group = 'sd', kind = 'note', with = 's7', at = {n = 6, fp = 'if you have not been to'}},
        {id = 's7', group = 'sd', implies = {'s4'}, at = {n = 7, fp = 'journey to the consulate of bastok'},
         done = {
            {t = 'event', zone = 231, event = 536, why = 'Helaku 536: briefing after Baraka (San d Oria first)'},
            {t = 'chat', re = "Hello there%. I'm the consul from Bastok%. Name's Helaku%.", why = 'Helaku 536 (say #11409)'},
         },
         reach = {
            {t = 'event', zone = 231, event = 581, why = 'Baraka 581: the San d Oria path started'},
            {t = 'mission', line = 'bastok', eq = 6, completed = false, why = 'mission line: current = The Emissary (San d Oria)'},
         }},
        {id = 's8', group = 'sd', at = {n = 8, fp = 'next go to chateau d oraguille'},
         done = {
            {t = 'event', zone = 233, event = 501, why = 'Halver 501: sent on to Ghelsba Outpost'},
            {t = 'chat', re = 'An adventurer from Bastok, are you%? Well, you have my respect for coming all the way here%.', why = 'Halver 501 (say #7072)'},
         }},
        {id = 's9', group = 'sd', kind = 'note', with = 's10', at = {n = 9, fp = 'at h 7 inside the ghelsba'}},
        {id = 's10', group = 'sd', at = {n = 10, fp = 'return to the consulate of bastok'},
         done = {
            {t = 'event', zone = 231, event = 543, why = 'Helaku 543: Warchief Vatgit defeated, the San d Oria path completed'},
            {t = 'chat', re = "Welcome back! You didn't get hurt, did you%?", why = 'Helaku 543 (say #11440)'},
            {t = 'mission', line = 'bastok', eq = 6, completed = true, why = 'mission log: The Emissary (San d Oria) completed'},
         }},
        {id = 's11', group = 'sd', kind = 'note', with = 's12', at = {n = 11, fp = 'if you have not been to'}},
        {id = 's12', group = 'sd', at = {n = 12, fp = 'journey to the consulate of bastok'},
         done = {
            {t = 'event', zone = 240, event = 61, why = 'Melek 61: the second (Windurst) path started'},
            {t = 'mission', line = 'bastok', eq = 9, completed = false, why = 'mission line: current = The Emissary (Windurst), second'},
         }},
        {id = 's13', group = 'sd', at = {n = 13, fp = 'next go to heavens tower located'},
         done = {
            {t = 'event', zone = 242, event = 242, why = 'Kupipi 242: the Dark key handed over'},
            {t = 'ki', id = 34, gained = true, why = 'Dark key obtained'},
            {t = 'chat', re = 'obtained key item: dark key', why = 'chat: key item obtained'},
         }},
        {id = 's14', group = 'sd', at = {n = 14, fp = 'travel to giddeus enter balga s'},
         done = {
            {t = 'ki', id = 34, gained = false, why = 'Dark key taken at the Balga s Dais win'},
         }},
        {id = 's15', group = 'sd', at = {n = 15, fp = 'afterwards head back to port windurst'},
         done = {
            {t = 'event', zone = 240, event = 66, why = 'Melek 66: the second path completed, the Kindred report handed over'},
            {t = 'mission', line = 'bastok', eq = 9, completed = true, why = 'mission log: The Emissary (Windurst), second, completed'},
         }},
        {id = 's16', group = 'sd', implies = {'s4'}, at = {n = 16, fp = 'speak with naji outside the president'},
         done = {
            {t = 'event', zone = 237, event = 714, after = 's15', why = 'Naji 714: the mission completed, the Kindred report taken'},
            {t = 'mission', line = 'bastok', eq = 5, completed = true, after = 's15', why = 'mission log: The Emissary completed after the San d Oria-first legs'},
         }},

        {id = 's17', group = 'win', kind = 'note', with = 's18', at = {n = 17, fp = 'if you have not been to'}},
        {id = 's18', group = 'win', implies = {'s4'}, at = {n = 18, fp = 'speak to melek in port windurst'},
         done = {
            {t = 'event', zone = 240, event = 48, why = 'Melek 48: the Windurst path started (Windurst first)'},
            {t = 'mission', line = 'bastok', eq = 7, completed = false, why = 'mission line: current = The Emissary (Windurst)'},
         }},
        {id = 's19', group = 'win', at = {n = 19, fp = 'speak to kupipi inside the heavens'},
         done = {
            {t = 'event', zone = 242, event = 239, why = 'Kupipi 239: the Sword offering handed over'},
            {t = 'ki', id = 31, gained = true, why = 'Sword offering obtained'},
            {t = 'chat', re = 'obtained key item: sword offering', why = 'chat: key item obtained'},
         }},
        {id = 's20', group = 'win', at = {n = 20, fp = 'speak to gold skull in port'},
         done = {
            {t = 'event', zone = 240, event = 53, why = 'Gold Skull 53: the Sword offering swapped for the Dull sword'},
            {t = 'ki', id = 33, gained = true, why = 'Dull sword obtained'},
            {t = 'chat', re = 'obtained key item: dull sword', why = 'chat: key item obtained'},
         }},
        {id = 's21', group = 'win', at = {n = 21, fp = 'travel to giddeus via west sarutabaruta'},
         done = {
            {t = 'event', zone = 145, event = 40, why = 'Uu Zhoumo 40: the dull sword refused, an Aspir Knife asked for'},
            {t = 'chat', re = 'You be bringing weapon more fitting for Uu Zhoumo!', why = 'Uu Zhoumo 40 (say #7371)'},
         }},
        {id = 's22', group = 'win', kind = 'note', with = 's23', at = {n = 22, fp = 'kill eyy mon the ironbreaker spawns'}},
        {id = 's23', group = 'win', at = {n = 23, fp = 'trade the aspir knife to uu'},
         done = {
            {t = 'event', zone = 145, event = 41, why = 'Uu Zhoumo 41: the Aspir Knife accepted'},
            {t = 'chat', re = 'Deal done%. Deal done%.', why = 'Uu Zhoumo 41 (say #7376)'},
         }},
        {id = 's24', group = 'win', at = {n = 24, fp = 'return to melek'},
         done = {
            {t = 'event', zone = 240, event = 55, why = 'Melek 55: the Windurst path completed'},
            {t = 'mission', line = 'bastok', eq = 7, completed = true, why = 'mission log: The Emissary (Windurst) completed'},
         }},
        {id = 's25', group = 'win', at = {n = 25, fp = 'speak to helaku in northern san'},
         done = {
            {t = 'event', zone = 233, event = 503, why = 'Halver 503: sent on to the Horlais Peak battlefield (after Helaku 537)'},
            {t = 'chat', re = 'An adventurer from Bastok, are you%? Consul Helaku sent word about you%.', why = 'Halver 503 (say #7085)'},
         },
         reach = {
            {t = 'event', zone = 231, event = 537, why = 'Helaku 537: the San d Oria path started (second)'},
            {t = 'mission', line = 'bastok', eq = 8, completed = false, why = 'mission line: current = The Emissary (San d Oria), second'},
         }},
        {id = 's26', group = 'win', kind = 'note', with = 's28', at = {n = 26, fp = 'next travel to horlais peak through'}},
        {id = 's27', group = 'win', kind = 'note', with = 's28', at = {n = 27, fp = 'examine the burning circle inside to'}},
        {id = 's28', group = 'win', at = {n = 28, fp = 'you will obtain the kindred crest'},
         done = {
            {t = 'ki', id = 13, gained = true, after = 's25', why = 'Kindred crest obtained at the Horlais Peak win'},
            {t = 'chat', re = 'obtained key item: kindred crest', after = 's25', why = 'chat: key item obtained'},
         }},
        {id = 's29', group = 'win', at = {n = 29, fp = 'return to helaku you will obtain'},
         done = {
            {t = 'event', zone = 231, event = 545, why = 'Helaku 545: the second path completed, the Kindred report handed over'},
            {t = 'chat', re = "You've done it again! You make me proud!", why = 'Helaku 545 (say #11454)'},
            {t = 'mission', line = 'bastok', eq = 8, completed = true, why = 'mission log: The Emissary (San d Oria), second, completed'},
         }},
        {id = 's30', group = 'win', implies = {'s4'}, at = {n = 30, fp = 'finally speak to naji to complete'},
         done = {
            {t = 'event', zone = 237, event = 714, after = 's29', why = 'Naji 714: the mission completed, the Kindred report taken'},
            {t = 'mission', line = 'bastok', eq = 5, completed = true, after = 's29', why = 'mission log: The Emissary completed after the Windurst-first legs'},
         }},
    },
}
