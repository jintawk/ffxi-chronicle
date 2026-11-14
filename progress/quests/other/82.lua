-- Step progress for Tango with a Tracker (Other Areas quest 82). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Tango_with_a_Tracker.lua (Despachiaire 576 gives the Letter from Shikaree X,
-- key item 719, and plays only while the quest is available at Prog 0; 577 re-issues the letter once a conquest tally has
-- passed; the quest begins when the battlefield is entered (Boneyard Gully 32000, shared with the other battlefields there, so
-- the quest log's current bit is the proof) and completes on the win (32001, same reason, so the log's completed bit is the
-- proof)). Client event script S4 026_Despachiaire_0101A009.txt (576 bare, 577 say #11828). The letter is used up on entry
-- (inferred). The quest log stays silent until the battlefield is entered, so the first bullet rests on the letter and the
-- event alone; the fight bullets are notes on the win. Not repeatable (page meta).
return {
    title = 'Tango with a Tracker',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to despachiaire to obtain letter'},
         done = {
            {t = 'event', zone = 26, event = 576, why = 'Despachiaire 576: the letter handed over (no menu, plays only at Prog 0)'},
            {t = 'ki', id = 719, gained = true, why = 'letter from Shikaree X obtained'},
            {t = 'ki_have', id = 719, have = true, why = 'letter from Shikaree X held'},
            {t = 'chat', re = 'obtained key item: letter from shikaree x', why = 'chat: key item obtained'},
            {t = 'event', zone = 26, event = 577, conf = 'inferred', why = 'Despachiaire 577: a later letter, only once the quest is accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to boneyard gully fastest teleport'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted on entering the battlefield'},
            {t = 'ki', id = 719, gained = false, conf = 'inferred', why = 'letter from Shikaree X is the battlefield entry item'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'there is a 30 minute timer'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'this fight is against'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'the shikaree s are both difficult'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'they gain tp very quickly and'}},
        {id = 's7', at = {n = 7, fp = 'once all three are defeated the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed on the battlefield win'},
         }},
    },
}
