-- Step progress for Missionary Man (Outlands quest 7). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Rauteinot.lua (137 is the offer, a menu whose "No" plays the same event, so
-- the log's current bit proves the accept; 138 is the reminder before the marble; 139 is the trade, no refusal, gives
-- Rauteinot's parcel KI 255; 140 is the reminder after it; 141 is the finish: it plays whenever the statue is held, but the
-- reward scroll is given and the quest completed only with a free slot, so the log's completed bit proves s5 and 141 only
-- reaches it) and scripts/zones/Northern_San_dOria/npcs/Mulaujeant.lua (698 takes the parcel and starts the one-minute wait,
-- 699 plays during it, 700 gives the Sublime statue KI 254, 701 plays after). Client event script S4 250_Rauteinot_010FA019.txt
-- (138 say #10239/#10240, 140 say #10243, 141 say #10246; 139 has no line); Mulaujeant has no client script. The quest log is
-- set at s1, so it is not silent. The reward scroll (item 4728) is not used. Not repeatable.
return {
    title = 'Missionary Man',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to rauteinot who asks for'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Rauteinot 137, option 1)'},
            {t = 'event', zone = 250, event = 138, conf = 'inferred', why = 'Rauteinot 138: reminder, only while accepted before the marble'},
            {t = 'chat', re = 'Do not worry%. Your kindness will not go unrewarded%.', conf = 'inferred', why = 'Rauteinot 138 (say #10240)'},
         },
         reach = {{t = 'event', zone = 250, event = 137, why = 'Rauteinot 137 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade the elshimo marble to rauteinot'},
         done = {
            {t = 'event', zone = 250, event = 139, why = 'Rauteinot 139: the marble accepted, no refusal'},
            {t = 'ki', id = 255, gained = true, why = "Rauteinot's parcel obtained"},
            {t = 'ki_have', id = 255, have = true, why = "Rauteinot's parcel held"},
            {t = 'chat', re = "obtained key item: rauteinot's parcel", why = 'chat: key item obtained'},
            {t = 'event', zone = 250, event = 140, conf = 'inferred', why = 'Rauteinot 140: his reminder, only after the trade'},
            {t = 'chat', re = "Please deliver my letter and the ore you retrieved to Mulaujeant the sculptor in San d'Oria%.", conf = 'inferred', why = 'Rauteinot 140 (say #10243)'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to northern san d oria'},
         done = {
            {t = 'event', zone = 231, event = 698, why = 'Mulaujeant 698: takes the parcel, starts the wait'},
            {t = 'ki', id = 255, gained = false, conf = 'inferred', why = "Rauteinot's parcel handed over"},
            {t = 'event', zone = 231, event = 699, conf = 'inferred', why = 'Mulaujeant 699: during the wait'},
         }},
        {id = 's4', at = {n = 4, fp = 'wait until one earth minute has'},
         done = {
            {t = 'event', zone = 231, event = 700, why = 'Mulaujeant 700: the statue given'},
            {t = 'ki', id = 254, gained = true, why = 'sublime statue of the Goddess obtained'},
            {t = 'ki_have', id = 254, have = true, why = 'sublime statue of the Goddess held'},
            {t = 'chat', re = 'obtained key item: sublime statue of the goddess', why = 'chat: key item obtained'},
            {t = 'event', zone = 231, event = 701, conf = 'inferred', why = 'Mulaujeant 701: only after the statue'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to rauteinot for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Rauteinot 141, with a free slot for the scroll)'},
            {t = 'ki', id = 254, gained = false, after = 's4', conf = 'inferred', why = 'sublime statue of the Goddess handed over'},
         },
         reach = {
            {t = 'event', zone = 250, event = 141, why = 'Rauteinot 141: the finish talk (completes only with a free slot)'},
            {t = 'chat', re = 'When the heathens of this backwards village lay their eyes upon this immaculate sculpture, they will surely come to their senses!', why = 'Rauteinot 141 (say #10246)'},
         }},
    },
}
