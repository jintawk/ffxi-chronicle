-- Step progress for The Lost Avatar (Rhapsodies of Vana'diel mission 1-16, page id 144; LandSandBoat enum 36, page id = enum + 108).
-- Data only; see progress/missions/adoulin/140.lua for the format. Evidence: LandSandBoat scripts/missions/rov/1_16_The_Lost_Avatar.lua.
-- Bullet 2 (examine the ??? to pop Siren) and the fight have no strong signal: the pop only prints "You are suddenly overcome with a
-- sense of foreboding..." (Yuhtunga IDs 6410), a line other missions' pops share (Lion's Roar, Somber Dreams), and Siren's death sets a
-- server variable and sends nothing of its own. They stay plain bullets, as does bullet 1 (the level warning). Bullet 3 is the proof: the
-- ??? (qm11, zone 123) plays event 213 only once Siren is dead (mission status 1), and its finish completes the mission and gives
-- "Rhapsody in Azure" (key item 2886, res/key_items.lua; no other script gives it, so its gain and its being held support the step and
-- cover a character that finished before Chronicle was installed). The other 213s in LandSandBoat (cop 5-2, sandoria 2-3) are in other
-- zones. The rov line has no completed set: the completion is `min = 148` (Volto Oscuro, enum 40 + 108; there is no page 146). The draft
-- had only the event and the line; the key item is added and the draft's bullets 1 and 2 notes are dropped (neither is a direction).
return {
    title = 'The Lost Avatar',
    completes = 's3',
    known = {{t = 'mission', line = 'rov', min = 144, max = 147}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'after the fight examine the again'},
         done = {
            {t = 'event', zone = 123, event = 213, why = '??? (qm11) in Yuhtunga Jungle, event 213: plays only after Siren is dead, completes the mission'},
            {t = 'ki', id = 2886, gained = true, why = '"Rhapsody in Azure" obtained'},
            {t = 'ki_have', id = 2886, have = true, why = '"Rhapsody in Azure" held'},
            {t = 'mission', line = 'rov', min = 148, why = 'mission log: the line moved past The Lost Avatar'},
         }},
    },
}
