-- Step progress for Promotion: Sergeant (Aht Urhgan quest 94). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Sergeant.lua (Prog 0: Naja 5055 offers the quest and begins it only
-- on option 0, the Balrahn Way choice; 5058 is his plain talk while accepted; the Whitegate region plays 5056 and option 0
-- ("Where have you been") sets Prog 1, any other option replays it; Prog 1: the Nashmau region plays 303 once a game day and
-- option 2 ("No, let's keep trying") sets Prog 2, any other answer waits a day; Prog 2: Totoroon says 252 and trading exactly
-- one Sutlac plays 304 (sets Prog 3); Prog 3: qm11 in Caedarva Mire plays 20, a plain cutscene (sets Prog 4); Prog 4: Naja
-- 5057 runs quest:complete and prints "has been promoted to Sergeant", line 7749 of Aht_Urhgan_Whitegate/IDs.lua); client event
-- script S4 053_Totoroon_01035050.txt (252 say #10676). 5055, 5056 and 303 play whether or not the right option is chosen, so
-- they are reaches; each trial step is proved by an event only reachable after it, as the server's stage requires. The quest
-- log goes current at the option-0 talk (bullet 1). Event 20 in Caedarva Mire is also played by the later Chief Sergeant
-- quest, so it is gated after the Totoroon trade. Bullet 3 (get a Sutlac) is a note. Not repeatable.
return {
    title = 'Promotion: Sergeant',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to naja when presented an'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (the Balrahn Way choice)'},
            {t = 'event', zone = 50, event = 5058, why = 'Naja Salaheem 5058: his talk while the quest is accepted'},
         },
         reach = {{t = 'event', zone = 50, event = 5055, why = 'Naja Salaheem 5055 offered (its finish needs option 0)'}}},
        {id = 's2', at = {n = 2, fp = 'go to balrahn way for another'},
         done = {
            {t = 'event', zone = 53, event = 303, why = 'Nashmau region 303: only played once the Balrahn Way cutscene is passed (Prog 1)'},
         },
         reach = {{t = 'event', zone = 50, event = 5056, why = 'Balrahn Way region 5056 (its finish needs option 0)'}}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'obtain a sutlac and head off'}},
        {id = 's4', at = {n = 4, fp = 'at h 9 in nashmau another'},
         done = {
            {t = 'event', zone = 53, event = 252, why = 'Totoroon 252: only played once the Nashmau cutscene is passed (Prog 2)'},
            {t = 'chat', re = 'Totoroon let yooo know when yooo bring shooogary thing', why = 'Totoroon 252 (say #10676)'},
         },
         reach = {{t = 'event', zone = 53, event = 303, why = 'Nashmau region 303 (any answer plays it)'}}},
        {id = 's5', at = {n = 5, fp = 'trade a sutlac to totoroon'},
         done = {
            {t = 'event', zone = 53, event = 304, why = 'Totoroon 304: exactly one Sutlac traded'},
         }},
        {id = 's6', at = {n = 6, fp = 'exit east to caedarva mire and'},
         done = {
            {t = 'event', zone = 79, event = 20, after = 's5', why = 'qm11 20: cutscene after the Sutlac, sets Prog 4'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to naja to complete the'},
         done = {
            {t = 'event', zone = 50, event = 5057, why = 'Naja Salaheem 5057: runs quest:complete'},
            {t = 'chat', re = 'has been promoted to sergeant!', why = 'promotion message (IDs.lua 7749)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
