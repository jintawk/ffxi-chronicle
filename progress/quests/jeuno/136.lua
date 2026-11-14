-- Step progress for Dormant Powers Dislodged (Jeuno quest 136). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB09_1_Dormant_Powers_Dislodged.lua (the Nomad Moogle's 10045 is shared by
-- every Limit Break quest from 6 to 10, so it and its lines prove nothing here; its option 11 begins the quest, option 12
-- refuses, so only the quest log's current bit carries step 1; trading exactly 1 Kindred's Crest and the wanted item with 10
-- merit points plays 10191 and sets Prog; the next talk plays 10192, the timing minigame, whose "Ready?" menu has a "Maybe
-- another time" refusal and whose finish runs quest:complete only for a push of 9 to 11 seconds, so 10192 is a reach and the
-- quest log's completed bit carries the last step, followed by "Your level limit is now 95!" and the reward key item Soul
-- gem, which may already be owned and is only supporting); client event script S4 243_Nomad_Moogle_010F3075.txt (10191 say
-- #12402, 10192 menu #12427). Key item id 2052 from res/key_items.lua. Bullet 17 (the talk that starts the minigame) stays
-- plain. Not repeatable (page meta). The quest log is set at s1.
return {
    title = 'Dormant Powers Dislodged',
    completes = 's18',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to the nomad moogle in'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's16', at = {n = 16, fp = 'trade 1 kindred s crest and'},
         done = {
            {t = 'event', zone = 243, event = 10191, why = 'Nomad Moogle 10191: the crest and the wanted item accepted'},
            {t = 'chat', re = 'Why yes, that should be everything%.', why = 'Nomad Moogle 10191 (say #12402)'},
         }},
        {id = 's18', at = {n = 18, fp = 'when the nomad moogle tells you'},
         reach = {{t = 'event', zone = 243, event = 10192, why = 'Nomad Moogle 10192: the minigame offered (its win needs a push at about 10 seconds)'}},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 95!', why = 'Ru Lude Gardens text: level limit 95, shown once the quest is completed'},
            {t = 'ki', id = 2052, gained = true, conf = 'inferred', why = 'soul gem obtained (reward)'},
         }},
    },
}
