-- Step progress for Reap What You Sow (Windurst quest 29). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Mashuu-Ajuu.lua (463 is the offer: it plays on a decline, and a
-- full bag also refuses it, so it is a reach; the Bag of Herb Seeds comes with the quest and the zone's ITEM_OBTAINED line;
-- 464 and 476 are his talks while accepted, or during a repeat run; 475 is the Sobbing Fungus trade and 477 the Deathball
-- trade, both of which do nothing but print "cannot obtain" when the bag is full on the first turn-in, so they are a reach and
-- the quest log's completed bit and the Stationery Set's ITEM_OBTAINED line prove the turn-in; 478 is his talk after the quest
-- until the player zones, played for either fungus). The two trade bullets are alternatives: the quest log completes at
-- whichever is traded first, so the Deathball bullet carries the completion and the Sobbing Fungus bullet is a post bullet,
-- proved only by a later (completed-state) 475, which gives gil without the full-bag check. A repeat run needs a new offer (479)
-- that the first run's log bits cannot tell apart, so there is no `repeatable` entry. Client event script S4
-- 238_Mashuu_Ajuu_010EE03D.txt (464 say #8442, 476 #8460, 477 #8462, 478 #8464); item ids from res/items.lua (572 Herb Seeds,
-- 131 Stationery Set). The quest log is set at s1.
-- Shared-signal audit: Herb Seeds 572 (item and the Obtained line) come from chocobo digging, HELM, Mog Garden and Grove Guardians loot too: dropped.
return {
    title = 'Reap What You Sow',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to mashuu ajuu who will'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 464, why = 'Mashuu-Ajuu 464: reminder, only while accepted'},
            {t = 'chat', re = 'For me to be top of the class, then you.ll at least need to grow', why = 'Mashuu-Ajuu 464 (say #8442)'},
            {t = 'event', zone = 238, event = 476, why = 'Mashuu-Ajuu 476: another talk, only while accepted'},
            {t = 'chat', re = "I wonder if I'll ever get the chance to meet a higher%-level adventurer", why = 'Mashuu-Ajuu 476 (say #8460)'},
         },
         reach = {{t = 'event', zone = 238, event = 463, why = 'Mashuu-Ajuu 463 offered (its finish needs option 3 and a free slot)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you can plant the seeds and'}},
        {id = 's3', at = {n = 3, fp = 'trading mashuu ajuu a deathball will'},
         reach = {
            {t = 'event', zone = 238, event = 477, why = 'Mashuu-Ajuu 477: the Deathball (also plays with a full bag, the Stationery Set may not fit)'},
            {t = 'chat', re = 'Wow! Well done!', why = 'Mashuu-Ajuu 477 (say #8462)'},
         },
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Obtained: .-Stationery set', why = 'ITEM_OBTAINED, only on the first turn-in'},
            {t = 'item', id = 131, gained = true, conf = 'inferred', why = 'Stationery Set gained (reward) (items can come from elsewhere)'},
            {t = 'event', zone = 238, event = 478, why = 'Mashuu-Ajuu 478: his talk once completed'},
            {t = 'chat', re = 'With this, I.ll be able to beat Kirarara at last', why = 'Mashuu-Ajuu 478 (say #8464)'},
         }},
        {id = 's4', kind = 'post', at = {n = 4, fp = 'trading mashuu ajuu a sobbing fungus'},
         reach = {
            {t = 'event', zone = 238, event = 475, why = 'Mashuu-Ajuu 475: the Sobbing Fungus (also plays with a full bag on the first turn-in)'},
            {t = 'chat', re = 'Humph! You only brought me what I asked for', why = 'Mashuu-Ajuu 475 (say #8459)'},
         },
         done = {
            {t = 'event', zone = 238, event = 475, after = 's3', why = 'Mashuu-Ajuu 475 once completed: the Sobbing Fungus accepted, gil paid'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'repeat attempts will not reward the'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'you will not get any more'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'if you set your home point'}},
    },
}
