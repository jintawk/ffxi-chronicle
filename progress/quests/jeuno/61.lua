-- Step progress for Scattered Into Shadow (Jeuno quest 61). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Scattered_into_Shadow.lua (Brutus, Upper Jeuno 244: 141 and 143 are the long and
-- short offers and only option 1 begins the quest and gives the three Aquaflora, so they are only a reach, and "You are given
-- three sprigs" plays only on acceptance; 142 is his talk while any Aquaflora is held; the three Underground Pools in Fei'Yin
-- (204) play 21 and 20 (each throws in one Aquaflora) and, after Dabotz's Ghost falls, 18; 144 is the progress cutscene after
-- the third pool, 149 his talk afterwards; Tebhi in Castle Oztroja takes the Beast Collar with "Tebhi happily accepts" on
-- success only; 135 completes, but the Beast Gaiters reward cannot be given on a full bag while 135 still plays, so it is only
-- a reach and the quest log's completed bit carries the last step); client event scripts S4 244_Brutus_010F400C.txt (142-149,
-- 135) and 204_Underground_Pool_*.txt; text ids from Upper_Jeuno and Castle_Oztroja IDs.lua; key item 229 (aquaflora) from
-- res/key_items.lua, item 13121 (beast collar) from res/items.lua. The pools at (H-8) and (H-5) are one bullet with two events
-- that come in either order, so that bullet and the F-5 spawn bullet are plain (neither event proves the bullet alone); the
-- Oztroja Chest Key bullet has no signal and is plain too. Tebhi's line is in Castle Oztroja (151), a zone no event here names,
-- hence the one check_steps warning. The quest log is set at the start, so it is not silent. Not repeatable (page meta).
return {
    title = 'Scattered Into Shadow',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to brutus at g 7'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Brutus 141 or 143, option 1)'},
            {t = 'chat', re = 'You are given three sprigs of', why = 'Brutus 141/143: accepted (text 7738)'},
            {t = 'ki', id = 229, gained = true, why = 'aquaflora obtained'},
            {t = 'event', zone = 244, event = 142, conf = 'inferred', why = 'Brutus 142: his talk, only while accepted with an Aquaflora held'},
            {t = 'chat', re = "Find the three ponds of Fei'Yin and toss", conf = 'inferred', why = 'Brutus 142 (say #7737)'},
         },
         reach = {{t = 'event', zone = 244, event = 141, why = 'Brutus 141 offered (its finish needs option 1)'},
                  {t = 'event', zone = 244, event = 143, why = 'Brutus 143 offered (its finish needs option 1)'}}},
        {id = 's4', at = {n = 4, fp = 'after defeating dabotz s ghost check'},
         done = {
            {t = 'event', zone = 204, event = 18, why = 'Underground Pool 18: the third pool, once Dabotz\'s Ghost has fallen'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to brutus for a cutscene'},
         done = {
            {t = 'event', zone = 244, event = 144, why = 'Brutus 144: the cutscene after the third pool'},
            {t = 'chat', re = "Why, thanks a gillion! I'm sure the spirit of that fallen animal can rest peacefully now%.", why = 'Brutus 144 (say #7739)'},
            {t = 'event', zone = 244, event = 149, conf = 'inferred', why = 'Brutus 149: his talk after 144'},
         }},
        {id = 's7', at = {n = 7, fp = 'use the key to open a'},
         done = {
            {t = 'chat', re = 'Obtained: Beast Collar', why = 'ITEM_OBTAINED from the Oztroja chest'},
            {t = 'item', id = 13121, gained = true, conf = 'inferred', why = 'Beast Collar gained (items can come from elsewhere)'},
         }},
        {id = 's8', at = {n = 8, fp = 'trade the beast collar to the'},
         done = {
            {t = 'chat', re = 'Tebhi happily accepts the beast collar and leaves', why = 'Tebhi accepts the Beast Collar (TEBHI_ACCEPTS)'},
            {t = 'item', id = 13121, lost = true, after = 's7', conf = 'inferred', why = 'Beast Collar gone (traded, or dropped)'},
         }},
        {id = 's9', at = {n = 9, fp = 'return to brutus for your reward'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 244, event = 135, why = 'Brutus 135 (also plays when the Beast Gaiters cannot be given)'},
                  {t = 'chat', re = 'So, did that ghost finally go to rest%?', why = 'Brutus 135 (say #7749)'}}},
    },
}
