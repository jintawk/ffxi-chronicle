-- Step progress for Moon Reading (Windurst mission id 23). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/9_2_Moon_Reading.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 23) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 23), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s2 the Door, event 384. s4 Qu'Hau Spring 4 (Ancient Verse of Ro'Maeve), s5 the Chamber of Oracles zone-in 3 (Ancient Verse of Altepa),
-- s6 the ??? in the Temple of Uggalepih 68 (Ancient Verse of Uggalepih): the three in any order. s7 the Door 385 (needs all three
-- verses). s8 the Full Moon Fountain battlefield: the win takes the three verses (the generic exit event 32001 is not used).
-- s15 the Door 386. s16 the Door 407 (the final cutscene), then Windurst Walls zone-in 443 completes. Bullets 1 and 3 are an optional
-- dialogue tip and the header of the three-verse list (notes); 9-13 are fight tips and 10-11 the crash remedy (notes); 14 is the
-- optional Kupipi talk (event 400, plays from status 3 on).
-- A full bag fails the Windurstian Flag in mission:complete (zone-in 443 plays at status 4 with no slot check), so events 407 and 443 are reach; the completed bit carries the step.
return {
    title = 'Moon Reading',
    completes = 's16',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'optional talk to everyone from kupipi'}},
        {id = 's2', at = {n = 2, fp = 'click the door vestal chamber on'},
         done = {
            {t = 'event', zone = 242, event = 384, why = 'Door: Vestal Chamber 384'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'collect the following 3 key items'}},
        {id = 's4', at = {n = 4, fp = 'interact with the qu hua spring'},
         done = {
            {t = 'event', zone = 122, event = 4, why = 'Qu\'Hau Spring 4'},
            {t = 'ki', id = 478, gained = true, why = 'Ancient Verse of Ro\'Maeve obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'zone into chamber of oracles'},
         done = {
            {t = 'zonein', zone = 168, event = 3, why = 'Chamber of Oracles zone-in 3'},
            {t = 'ki', id = 479, gained = true, why = 'Ancient Verse of Altepa obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'interact with the in temple of'},
         done = {
            {t = 'event', zone = 159, event = 68, why = 'the ??? in the Temple of Uggalepih 68'},
            {t = 'ki', id = 480, gained = true, why = 'Ancient Verse of Uggalepih obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to the door vestal chamber'},
         done = {
            {t = 'event', zone = 242, event = 385, why = 'Door: Vestal Chamber 385: the three verses held'},
         }},
        {id = 's8', at = {n = 8, fp = 'go to full moon fountain and'},
         done = {
            {t = 'ki', id = 478, gained = false, why = 'Ancient Verse of Ro\'Maeve taken at the battlefield win'},
            {t = 'ki', id = 479, gained = false, why = 'Ancient Verse of Altepa taken at the battlefield win'},
            {t = 'ki', id = 480, gained = false, why = 'Ancient Verse of Uggalepih taken at the battlefield win'},
         }},
        {id = 's9', kind = 'note', with = 's8', at = {n = 9, fp = 'commands to unload them lua u'}},
        {id = 's10', kind = 'note', with = 's16', at = {n = 10, fp = 'if you crash the game after'}},
        {id = 's11', kind = 'note', with = 's16', at = {n = 11, fp = 'not everyone has this issue but'}},
        {id = 's12', kind = 'note', with = 's8', at = {n = 12, fp = 'the first part is against four'}},
        {id = 's13', kind = 'note', with = 's8', at = {n = 13, fp = 'the next fight is with a'}},
        {id = 's14', kind = 'optional', at = {n = 14, fp = 'optional talk to kupipi for optional'},
         done = {
            {t = 'event', zone = 242, event = 400, why = 'Kupipi 400, from status 3 on'},
         }},
        {id = 's15', at = {n = 15, fp = 'return to the door vestal chamber'},
         done = {
            {t = 'event', zone = 242, event = 386, why = 'Door: Vestal Chamber 386'},
         }},
        {id = 's16', at = {n = 16, fp = 'click the door vestal chamber again'},
         done = {
            {t = 'mission', line = 'windurst', eq = 23, completed = true, why = 'mission log: Moon Reading completed'},
         },
         reach = {
            {t = 'event', zone = 242, event = 407, why = 'Door: Vestal Chamber 407: the final cutscene (completion is the zone-in after it)'},
            {t = 'zonein', zone = 239, event = 443, why = 'Windurst Walls zone-in 443 (a full bag fails the Windurstian Flag and it replays)'},
         }},
    },
}
