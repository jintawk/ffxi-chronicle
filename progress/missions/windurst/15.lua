-- Step progress for The Shadow Awaits (Windurst mission id 15). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/5_2_The_Shadow_Awaits.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 15) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 15), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1: the Door in Heavens Tower, event 214 (progressEvent, only while the Star crested summons is held; it takes the summons, so
-- the summons' loss is not used: the id is also deleted in A New Journey). s3: the Throne Room zone-in 7 after the Shadow Lord
-- battlefield (LandSandBoat onZoneIn, gives the Shadow fragment). s4: Heavens Tower zone-in 215. s5: the Door again, 216, completes.
-- The way to Castle Zvahl and the fight (bullets 6-20) have no signal: notes, attached to s5 so they sit after every step they cover. Bullet 2 is the home point tip.
return {
    title = 'The Shadow Awaits',
    completes = 's5',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to the top of the'},
         done = {
            {t = 'event', zone = 242, event = 214, why = 'Door: Vestal Chamber 214: the Star crested summons handed in'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'castle zvahl keep home point 1'}},
        {id = 's3', at = {n = 3, fp = 'after you clear the bcnm you'},
         done = {
            {t = 'ki', id = 74, gained = true, why = 'Shadow fragment obtained'},
            {t = 'zonein', zone = 165, event = 7, why = 'Throne Room zone-in 7 after the Shadow Lord: the Shadow fragment is given'},
         }},
        {id = 's4', at = {n = 4, fp = 'zone into heavens tower for a'},
         done = {
            {t = 'zonein', zone = 242, event = 215, why = 'Heavens Tower zone-in 215: the brief cutscene (Shadow fragment held)'},
         }},
        {id = 's5', at = {n = 5, fp = 'click the door vestal chamber for'},
         done = {
            {t = 'mission', line = 'windurst', eq = 15, completed = true, why = 'mission log: The Shadow Awaits completed'},
            {t = 'event', zone = 242, event = 216, why = 'Door: Vestal Chamber 216: completes, takes the Shadow fragment'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'head for xarcabard castle zvahl is'}},
        {id = 's7', kind = 'note', with = 's5', at = {n = 7, fp = 'enter castle zvahl baileys follow the'}},
        {id = 's8', kind = 'note', with = 's5', at = {n = 8, fp = 'turn left and follow the right'}},
        {id = 's9', kind = 'note', with = 's5', at = {n = 9, fp = 'on the next map turn right'}},
        {id = 's10', kind = 'note', with = 's5', at = {n = 10, fp = 'head up the stairs and you'}},
        {id = 's11', kind = 'note', with = 's5', at = {n = 11, fp = 'next get to the top left'}},
        {id = 's12', kind = 'note', with = 's5', at = {n = 12, fp = 'work your way into the center'}},
        {id = 's13', kind = 'note', with = 's5', at = {n = 13, fp = 'inside walk out of the hallway'}},
        {id = 's14', kind = 'note', with = 's5', at = {n = 14, fp = 'once on the second level you'}},
        {id = 's15', kind = 'note', with = 's5', at = {n = 15, fp = 'follow the teleporters four times until'}},
        {id = 's16', kind = 'note', with = 's5', at = {n = 16, fp = 'the shadow lord has 2 forms'}},
        {id = 's17', kind = 'note', with = 's5', at = {n = 17, fp = 'while immune to magic he will'}},
        {id = 's18', kind = 'note', with = 's5', at = {n = 18, fp = 'during physical immunity he can use'}},
        {id = 's19', kind = 'note', with = 's5', at = {n = 19, fp = 'defeating the first form will get'}},
        {id = 's20', kind = 'note', with = 's5', at = {n = 20, fp = 'the second form will only use'}},
    },
}
