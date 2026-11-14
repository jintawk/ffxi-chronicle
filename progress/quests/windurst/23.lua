-- Step progress for All at Sea (Windurst quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/All_At_Sea.lua (Paytah 291 is his talk before the quest, the only trace of
-- bullet 1; trading the Ripped Cap to him is 292 and begins the quest; once accepted Paytah plays 293 and Odilia 294;
-- Baren-Moren 547 takes the cap and sets Prog 1, 548 and 550 are his talks at Prog 1 and 2, and 549, the Dhalmel Hide trade, plays
-- only from Prog 1, so all four prove the cap was handed over; Paytah 295 takes the Sailor's Cap and runs quest:complete, which
-- also gives the Leather Ring, so it also plays with a full bag and is a reach, and the quest log's completed bit carries the
-- last step; 296 and Odilia 297 are completed-state talks until the player zones). Client event scripts S4 240_Paytah_010F005E.txt,
-- 240_Odilia_010F005F.txt, 238_Baren_Moren_010EE044.txt. Item ids from res/items.lua. The Dhalmel Hide bullet (n=4) tells the
-- player what the repair needs and is a note on the hand-in. The quest log is silent until Paytah's 292 (s2), so bullet 1
-- rests on the event alone.
-- Shared-signal audit: Dhalmel Mantle 13588 is also sold in guild shops and found in caskets (data/guild_shops.lua, casket_loot.lua): shared, gated after s2.
return {
    title = 'All at Sea',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to paytah who is at'},
         done = {
            {t = 'event', zone = 240, event = 291, why = 'Paytah 291: his talk before the quest'},
         }},
        {id = 's2', at = {n = 2, fp = 'fish the ripped cap out of'},
         done = {
            {t = 'event', zone = 240, event = 292, why = 'Paytah 292: the Ripped Cap accepted, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 293, why = 'Paytah 293: only while accepted'},
            {t = 'event', zone = 240, event = 294, why = 'Odilia 294: only while accepted'},
            {t = 'chat', re = "Oh, no! Daddy's cap is all torn up!", why = 'Odilia 294 (say #3828)'},
         }},
        {id = 's3', at = {n = 3, fp = 'go to baren moren in windurst'},
         done = {
            {t = 'event', zone = 238, event = 547, why = 'Baren-Moren 547: the Ripped Cap accepted'},
            {t = 'event', zone = 238, event = 548, why = 'Baren-Moren 548: only at Prog 1, after the cap'},
            {t = 'chat', re = 'Might as well try full%-scale surgery', why = 'Baren-Moren 548 (say #8774)'},
            {t = 'event', zone = 238, event = 549, why = 'Baren-Moren 549: the hides, only from Prog 1'},
            {t = 'event', zone = 238, event = 550, why = 'Baren-Moren 550: only at Prog 2'},
            {t = 'item', id = 590, gained = true, conf = 'inferred', why = "Sailor's Cap gained (items can come from elsewhere)"},
            {t = 'item', id = 13588, gained = true, after = 's2', conf = 'inferred', why = 'Dhalmel Mantle gained (items can come from elsewhere)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'baren moren requires 4 dhalmel hides'}},
        {id = 's5', at = {n = 5, fp = 'return the repaired cap to paytah'},
         reach = {{t = 'event', zone = 240, event = 295, why = 'Paytah 295: the Sailor\'s Cap (also plays with a full bag, the Leather Ring may not fit)'}},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 240, event = 296, why = 'Paytah 296: his talk once completed'},
            {t = 'chat', re = 'Now my daddy can go sailing again!', why = 'Paytah 296 (say #3831)'},
            {t = 'event', zone = 240, event = 297, why = 'Odilia 297: her talk once completed'},
         }},
    },
}
