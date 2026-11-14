-- Step progress for Sins of the Mothers (Crystal War quest 53, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (SINS_OF_THE_MOTHERS) in its id list only, with no script; the client event scripts for
-- Dhea Prandoleh and Velda-Galda carry no lines for it, so the page is the source. Key item 1173 (Succulent dragon fruit,
-- res/key_items.lua) is picked up at the Succulent Cactus (n=3) and, after a lost fight, again from the same cactus. The page ends
-- the quest on the zone-in to Windurst Waters [S] with the reward (n=9), so the log's completed bit belongs to n=9. The log's first
-- flag is not known, so the steps before the fruit are silent. The cutscene trips (n=1, 2, 4, 5), the battle and its facts (n=6 to
-- 8) have no signal of their own: notes. Not repeatable.
-- Shared-signal audit: the Succulent dragon fruit (1173) is named by no LandSandBoat script and nowhere under progress/.
return {
    title = 'Sins of the Mothers',
    completes = 's9',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'speak to dhea prandoleh h 10'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to fort karugo narugo s'}},
        {id = 's3', at = {n = 3, fp = 'check the succulent cactus at f'},
         done = {
            {t = 'ki', id = 1173, gained = true, why = 'Succulent dragon fruit obtained'},
            {t = 'ki_have', id = 1173, have = true, why = 'Succulent dragon fruit held'},
            {t = 'chat', re = 'obtained key item: succulent dragon fruit', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's9', at = {n = 4, fp = 'return to the stone monument for'}},
        {id = 's5', kind = 'note', with = 's9', at = {n = 5, fp = 'examine the sunken hollow at g'}},
        {id = 's6', kind = 'note', with = 's9', at = {n = 6, fp = 'examine it again to enter a'}},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'the object of this bcnm is'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'when you finish the bcnm you'}},
        {id = 's9', at = {n = 9, fp = 'zone into windurst waters s for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the Windurst Waters [S] zone-in'},
         }},
    },
}
