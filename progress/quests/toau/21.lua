-- Step progress for Beginnings (Aht Urhgan quest 21). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/BLU_AF1_Beginnings.lua (Waoud 705 is the offer in one cutscene whose
-- "Gaze away" and "I have" answers are bullets 2 and 3; only option 1 begins the quest, so 705 is a reach and the log's accepted
-- bit proves the first bullet, bullet 4 being that log entry; each of the five staging-point Immortals hands over a Brand key item
-- through a cutscene (Meyaada 10 zone 54, Daswil 8 zone 52, Nahshib 10 and Nareema 12 zone 79, Waudeen 10 zone 61); Waoud 707 plays
-- only with all five brands and runs quest:complete, whose reward is the Immortal's Scimitar, so a full bag replays 707 and only the
-- completed bit proves the last bullet). The five brand cutscenes cannot map to one bullet: the engine marks a step on any one
-- matcher, so the first brand would tick "visit all five", and the draft's post step ticked the same way; bullets 5 and 6 are notes
-- on the return to Waoud and the brands are not used. Key item ids from res/key_items.lua (829 to 833). Client event script
-- S4 050_Waoud_01032119.txt (705 and 707 have no text). Not repeatable (the draft's restart was a guess).
return {
    title = 'Beginnings',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'begin this quest by speaking to'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Waoud 705, option 1)'},
         },
         reach = {{t = 'event', zone = 50, event = 705, why = 'Waoud 705 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'tell waoud that you want him'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'in the cut scene select i'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'the quest will now show in'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'once you have the quest started'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'you will obtain a permanent key'}},
        {id = 's7', at = {n = 7, fp = 'after you have all five brand'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 707, why = "Waoud 707: all five brands held, runs quest:complete (replays if the Immortal's Scimitar cannot be given)"}}},
    },
}
