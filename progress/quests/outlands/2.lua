-- Step progress for Greetings to the Guardian (Outlands quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Kazham/npcs/Hari_Pakhroib.lua (68 is the offer, a menu: option 1 "I'm busy" refuses and
-- plays the same event, so only the log's current bit proves the accept; 69 is the reminder, played only while accepted before
-- the offering; 71 gives the reward and runs quest:complete) and zones/Ifrits_Cauldron/npcs/Altar_of_Ashes.lua (the offering is
-- a trade that sets a char var and shows a message only: no event, no key item, so the trip and the trade are notes on the
-- hand-in). Client event script S4 250_Hari_Pakhroib_010FA03A.txt (69 say #10059, 71 say #10063). The quest log is set at
-- s1, so it is not silent. A repeat run is a trade at the altar with no marker (the quest stays completed), so it is not
-- tracked and there is no `repeatable` entry.
return {
    title = 'Greetings to the Guardian',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to hari pakhroib i 11'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Hari Pakhroib 68, option 1)'},
            {t = 'event', zone = 250, event = 69, conf = 'inferred', why = 'Hari Pakhroib 69: reminder, only while accepted'},
            {t = 'chat', re = 'Travel east to the towerrring volcano%.', conf = 'inferred', why = 'Hari Pakhroib 69 (say #10059)'},
         },
         reach = {{t = 'event', zone = 250, event = 68, why = 'Hari Pakhroib 68 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'head to ifrit s cauldron using'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'once inside ifrit s cauldron take'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'trade the wild pamamas to the'}},
        {id = 's5', at = {n = 5, fp = 'return to hari pakhroib for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 250, event = 71, why = 'Hari Pakhroib 71: reward, runs quest:complete'},
            {t = 'chat', re = 'Oh, you made it back in one piece!', why = 'Hari Pakhroib 71 (say #10063)'},
         }},
    },
}
