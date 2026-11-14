-- Step progress for Requiem of Sin (Other Areas quest 83). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Requiem_of_Sin.lua (Despachiaire 578 gives the Letter from Shikaree Y, key
-- item 721, while the quest is available and Tango with a Tracker is done; 579 re-issues the letter (Shikaree Y while accepted,
-- the Mithran Trackers' letter, 722, once completed), so it is shared between states and only inferred; the quest begins on
-- entering the battlefield (Boneyard Gully 32000, shared with the other battlefields there, so the quest log's current bit is
-- the proof) and completes on the win (32001, same reason, so the log's completed bit is the proof)). Client event script S4
-- 026_Despachiaire_0101A009.txt (578 and 579 share the letter lines, say #11828). The letter is used up on entry (inferred).
-- The quest log stays silent until the battlefield is entered, so the first bullet rests on the letter and the event alone;
-- the fight bullets are notes on the win. Repeat runs (a conquest tally later, the Mithran letter) are not tracked: the
-- completed bit survives and they need no new accept bullet.
return {
    title = 'Requiem of Sin',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to despachiaire to obtain letter'},
         done = {
            {t = 'event', zone = 26, event = 578, why = 'Despachiaire 578: the first letter (no menu, plays only at Prog 0)'},
            {t = 'ki', id = 721, gained = true, why = 'letter from Shikaree Y obtained'},
            {t = 'ki_have', id = 721, have = true, why = 'letter from Shikaree Y held'},
            {t = 'chat', re = 'obtained key item: letter from shikaree y', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to boneyard gully and select'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted on entering the battlefield'},
            {t = 'ki', id = 721, gained = false, conf = 'inferred', why = 'letter from Shikaree Y is the battlefield entry item'},
         }},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'there is a 30 minute timer'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'this fight is against'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'the shikaree s are difficult to'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'they gain tp very quickly and'}},
        {id = 's7', at = {n = 7, fp = 'once all three are defeated a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed on the battlefield win'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'a conquest tally must have taken'}},
        {id = 's9', kind = 'note', with = 's7', at = {n = 9, fp = 'this quest can may be completed'}},
    },
}
