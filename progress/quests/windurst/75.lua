-- Step progress for I Can Hear a Rainbow (Windurst quest 75). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/SMN_I_Can_Hear_a_Rainbow.lua (the door of the House of the Hero, event 384, begins
-- the quest with no option test and needs the Carbuncle's Ruby in the bag; 385 is its reminder while accepted and the weather
-- count is below seven; the weather cutscenes are one zone-in event per field zone that fire once per colour and only count
-- through their update packet, so no single one proves bullet 4; La Theine Plateau ??? 124 plays only for the exact Ruby
-- trade at Prog 1 and its finish completes the quest, whose reward is a key item, so there is no refusal path). The Ruby
-- (bullet 1) is an item that can come from anywhere, the seven colours (bullet 4) have no event that says "all seven", and bullets
-- 5 to 7 are tips: plain bullets. Bullet 3 is the explanation the cutscene of bullet 2 plays and bullet 8 the cutscene of the
-- seventh colour. The quest log is set at s2, so it is not silent.
return {
    title = 'I Can Hear a Rainbow',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', at = {n = 2, fp = 'go to windurst walls g 3'},
         done = {
            {t = 'event', zone = 239, event = 384, why = 'House of the Hero door 384: the quest begins'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 239, event = 385, conf = 'inferred', why = 'House of the Hero door 385: reminder, only once accepted'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'you will be instructed to experience'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'once you ve experienced all 7'}},
        {id = 's9', at = {n = 9, fp = 'go to la theine plateau g'},
         done = {
            {t = 'event', zone = 102, event = 124, why = 'La Theine Plateau ??? 124: the Ruby accepted'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
