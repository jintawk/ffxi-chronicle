-- Step progress for The Jester Who'd Be King (Windurst mission id 21). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/8_2_The_Jester_Whod_be_King.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 21) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 21), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1 Apururu 588 (the Manustery ring). s2 is one bullet for three NPCs in any order (Rukususu's door in Fei'Yin 22, Sedal-Godjal 122,
-- Tosuka-Porika 801): no signal says all three are done, so each only marks the bullet reached and a later step finishes it. s3
-- Apururu 601. s4 Kupipi 326. s5-s7 the walk and the Cracked Walls (the Queens spawn on a message, no event): notes on s8. s8 the
-- Cracked Wall in Outer Horutoto Ruins, event 71 (the Orastery ring). s9 Apururu 590. s10 Shantotto 397 (the Glove of perpetual
-- twilight). s11 Apururu 592. s12 the Gate of Darkness in Inner Horutoto Ruins, event 75 (takes the Book of the Gods). s13 Apururu
-- 609 completes.
return {
    title = 'The Jester Who\'d Be King',
    completes = 's13',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to apururu in windurst woods'},
         done = {
            {t = 'event', zone = 241, event = 588, why = 'Apururu 588'},
            {t = 'ki', id = 281, gained = true, why = 'Manustery ring obtained'},
         }},
        {id = 's2', kind = 'branch', at = {n = 2, fp = 'talk to the following npcs in'},
         reach = {
            {t = 'event', zone = 204, event = 22, why = 'Fei\'Yin Cermet Door 22: the Rhinostery ring'},
            {t = 'event', zone = 149, event = 122, why = 'Sedal-Godjal 122: the Aurastery ring'},
            {t = 'event', zone = 238, event = 801, why = 'Tosuka-Porika 801: the Optistery ring'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to apururu for dialogue regarding'},
         done = {
            {t = 'event', zone = 241, event = 601, why = 'Apururu 601: the final ring'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to kupipi in heavens tower'},
         done = {
            {t = 'event', zone = 242, event = 326, why = 'Kupipi 326'},
         }},
        {id = 's5', kind = 'note', with = 's8', at = {n = 5, fp = 'go to the tower in west'}},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'go through the cracked wall at'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'find the cracked wall at g'}},
        {id = 's8', at = {n = 8, fp = 'click the cracked wall again multiple'},
         done = {
            {t = 'event', zone = 194, event = 71, why = 'Cracked Wall 71 after the Queens'},
            {t = 'ki', id = 265, gained = true, why = 'Orastery ring obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to apururu for a cutscene'},
         done = {
            {t = 'event', zone = 241, event = 590, why = 'Apururu 590'},
         }},
        {id = 's10', at = {n = 10, fp = 'talk to shantotto in windurst walls'},
         done = {
            {t = 'event', zone = 239, event = 397, why = 'Shantotto 397'},
            {t = 'ki', id = 282, gained = true, why = 'Glove of perpetual twilight obtained'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to apururu for a cutscene'},
         done = {
            {t = 'event', zone = 241, event = 592, why = 'Apururu 592'},
         }},
        {id = 's12', at = {n = 12, fp = 'go to inner horutoto ruins and'},
         done = {
            {t = 'event', zone = 192, event = 75, why = 'Gate of Darkness 75'},
            {t = 'ki', id = 252, gained = false, why = 'Book of the Gods taken'},
         }},
        {id = 's13', at = {n = 13, fp = 'return to apururu for a cutscene'},
         done = {
            {t = 'mission', line = 'windurst', eq = 21, completed = true, why = 'mission log: The Jester Who\'d Be King completed'},
            {t = 'event', zone = 241, event = 609, why = 'Apururu 609: completes'},
         }},
    },
}
