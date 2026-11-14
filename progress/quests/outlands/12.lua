-- Step progress for Trial by Fire (Outlands quest 12). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Trial_by_Fire.lua. Ronta-Onta 270 is the offer, a menu ("Take up the challenge?"):
-- only option 1 begins the quest and gives the Tuning fork of fire (KI 328), the "Great! Here, take this" line is on the accept
-- branch only; 271 is his reminder while the fork is held and 285 hands a new fork after a lost battle. The Whisper of Flames
-- (KI 320) comes from the battlefield win (Cloister of Flames, event 32001) and is used by this quest and kept for The Moonlit
-- Path, so it is the proof of s3 and is not read as a hand-in. Ronta-Onta 273 is the reward menu: it plays whenever the whisper
-- is held, and the quest completes only for an option 1 to 6 whose reward is given (an escaped cutscene or a full bag changes
-- nothing), so 273 only reaches s4 and the log's completed bit proves it. Client event script S4 250_Ronta_Onta_010FA06A.txt
-- (270 say #10511, 271 say #10512, 273 say #10517). The quest log is set at s1, so it is not silent. The quest can be repeated
-- once per day, but its restart leaves no unique trace (the fork can be kept, the log is cleared by the server), so repeats
-- are not tracked and there is no `repeatable` entry. The travel bullet is a note and bullets 5 to 11 are plain tips.
-- A zonein to the Cloister of Flames (207) was dropped: Cloister_of_Flames/Zone.lua onZoneIn (line 14) returns cs = -1, so no zone-in event exists; the whisper is the proof of s3.
return {
    title = 'Trial by Fire',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with ronta onta to obtain'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ronta-Onta 270, option 1)'},
            {t = 'ki', id = 328, gained = true, why = 'tuning fork of fire obtained'},
            {t = 'ki_have', id = 328, have = true, why = 'tuning fork of fire held'},
            {t = 'chat', re = 'obtained key item: tuning fork of fire', why = 'chat: key item obtained'},
            {t = 'chat', re = 'only a person who carries one can enter the crystal%.', why = 'Ronta-Onta 270 (say #10511, accept branch)'},
            {t = 'event', zone = 250, event = 271, conf = 'inferred', why = 'Ronta-Onta 271: reminder, only while accepted with the fork'},
            {t = 'chat', re = 'Without it, you won\'t be getting inside no matter how sneaky%-weaky you are!', conf = 'inferred', why = 'Ronta-Onta 271 (say #10513)'},
         },
         reach = {{t = 'event', zone = 250, event = 270, why = 'Ronta-Onta 270 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to yhoator jungle and look'}},
        {id = 's3', at = {n = 3, fp = 'defeat ifrit prime and you will'},
         done = {
            {t = 'ki', id = 320, gained = true, after = 's1', why = 'whisper of flames obtained'},
            {t = 'ki_have', id = 320, have = true, after = 's1', why = 'whisper of flames held'},
            {t = 'chat', re = 'obtained key item: whisper of flames', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to ronta onta with the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Ronta-Onta 273, reward given)'},
            {t = 'ki', id = 320, gained = false, after = 's3', conf = 'inferred', why = 'whisper of flames handed over'},
         },
         reach = {
            {t = 'event', zone = 250, event = 273, after = 's3', why = 'Ronta-Onta 273: the reward menu (completes only when a reward is taken)'},
            {t = 'chat', re = 'Wowy%-wow%-wow! You defeated a prime avatar!', after = 's3', why = 'Ronta-Onta 273 (say #10517)'},
         }},
    },
}
