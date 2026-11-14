-- Step progress for Shattering Stars (Jeuno quest 132). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/LB05_1_Shattering_Stars.lua (Maat 92 has no menu and its finish begins the
-- quest, so it proves the accept; 91 is his talk while accepted and no testimony was ever traded, 63 once one was; trading
-- the testimony of the player's job plays 64 (a "Challenge Maat?" menu inside it, but the trade is done either way, and it
-- plays only while Prog is 0); 93 plays once the fight is won and runs quest:complete, which pays no item and so cannot be
-- refused, then "Your level limit is now 75." is shown); client event script S4 243_Maat_010F3031.txt (92 say #10470, 64 say
-- #10484, 93 say #10497; ids 63 and 91 carry the reminder). The battlefield win (32001 in five zones) is the generic win
-- event shared by every battle there and the Instant Warp scroll can also be stolen, so the win bullet stays plain, as do the
-- fight notes and the rematch bullets. Not repeatable (page meta). The quest log is set at s3, so it is not silent.
return {
    title = 'Shattering Stars',
    completes = 's28',
    known = {{t = 'quest'}},
    steps = {
        {id = 's3', at = {n = 3, fp = 'speak to maat on any level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 243, event = 92, why = 'Maat 92: the accept cutscene, its finish begins the quest'},
            {t = 'chat', re = "It's been a long road to the top, and I'm sure you've had your share of hard times along the way%.", why = 'Maat 92 (say #10470)'},
            {t = 'event', zone = 243, event = 91, conf = 'inferred', why = 'Maat 91: his talk while accepted, testimony never traded'},
         }},
        {id = 's5', at = {n = 5, fp = 'once you trade the testimony to'},
         done = {
            {t = 'event', zone = 243, event = 64, why = 'Maat 64: the job testimony traded, he asks if you are ready'},
            {t = 'chat', re = "That wasn't so hard now, was it%?", why = 'Maat 64 (say #10484)'},
            {t = 'event', zone = 243, event = 63, conf = 'inferred', why = 'Maat 63: his talk after a testimony was traded at least once'},
         }},
        {id = 's28', at = {n = 28, fp = 'return to ru lude gardens and'},
         done = {
            {t = 'event', zone = 243, event = 93, why = 'Maat 93: the fight won, runs quest:complete'},
            {t = 'chat', re = 'that was one fine display of fighting', why = 'Maat 93 (say #10497)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Your level limit is now 75%.', why = 'Ru Lude Gardens text: level limit 75, shown once the quest is completed'},
         }},
    },
}
