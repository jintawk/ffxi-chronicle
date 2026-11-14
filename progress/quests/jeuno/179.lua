-- Step progress for Full Speed Ahead! (Jeuno quest 179). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Upper_Jeuno/npcs/Mapitoto.lua (10223 offers it, 10224 offers a retry while accepted;
-- both are a menu and only option 1 adds the quest and sends the player to Batallia Downs, so they are only a reach; 10225
-- plays only when the minigame is won (status 4) and runs completeQuest and the whistle and companion key items) and
-- scripts/quests/full_speed_ahead.lua (the Batallia Downs minigame: each food gives RAPTOR_OVERCOME_MUNCHIES, the fifth
-- also MEET_SYRILLIA, then the trigger area at Syrillia starts event 24, "End CS and teleport", back to Upper Jeuno; text
-- from scripts/zones/Batallia_Downs/IDs.lua). Client event script S4 244_Mapitoto_010F4100.txt: 10223 says #13730 ("Wheeeeee!
-- Finally, someone says yes!") on the accepting branch only, the decline says #13729; 10225 says #13749. Event 24 of
-- Batallia Downs (105) has no client script on disk (the zone has no minigame file) and is LandSandBoat's only: inferred.
-- Key item ids from res/key_items.lua (3055 trainer's whistle and 3073 Raptor companion, the rewards, may already be owned).
-- Bullet 1 (the first talk, before the menu) plays on a decline too: a note on the accept. Bullets 3, 5, 6, 8 and the
-- Repeating the Quest bullets (10 to 12) are notes or plain; the quest is not repeatable by page meta.
return {
    title = 'Full Speed Ahead!',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak to mapitoto on any job'}},
        {id = 's2', at = {n = 2, fp = 'accept the offer to feed her'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Mapitoto 10223 / 10224, option 1)'},
            {t = 'chat', re = 'Wheeeeee! Finally, someone says yes!', why = 'Mapitoto 10223, accepting branch only (say #13730)'},
         },
         reach = {
            {t = 'event', zone = 244, event = 10223, why = 'Mapitoto 10223 offered (its finish needs option 1)'},
            {t = 'event', zone = 244, event = 10224, why = 'Mapitoto 10224 offered (its finish needs option 1)'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'she will mark several locations on'}},
        {id = 's4', at = {n = 4, fp = 'travel to the points on the'},
         done = {
            {t = 'chat', re = 'Meet up with Syrillia%.', why = 'MEET_SYRILLIA: the fifth food given (Batallia_Downs/IDs.lua)'},
         },
         reach = {{t = 'chat', re = 'has overcome the munchies', why = 'RAPTOR_OVERCOME_MUNCHIES: a food given'}}},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'the raptor will get agitated and'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'successfully feeding the raptor will result'}},
        {id = 's7', at = {n = 7, fp = 'once you have successfully fed the'},
         done = {
            {t = 'event', zone = 105, event = 24, conf = 'inferred', why = 'Batallia Downs 24: Syrillia, end cutscene and warp (LandSandBoat only)'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'a comfortable example route j 8'}},
        {id = 's9', at = {n = 9, fp = 'return to mapitoto in upper jeuno'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 244, event = 10225, why = 'Mapitoto 10225: plays only after the minigame is won, runs completeQuest'},
            {t = 'chat', re = 'Look who made it back%-%-and no worse for the wear%.', why = 'Mapitoto 10225 (say #13749)'},
            {t = 'ki', id = 3055, gained = true, conf = 'inferred', why = "trainer's whistle obtained (reward)"},
            {t = 'ki', id = 3073, gained = true, conf = 'inferred', why = 'Raptor companion obtained (reward)'},
         }},
    },
}
