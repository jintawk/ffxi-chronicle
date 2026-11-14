-- Step progress for Mama Mia (Outlands quest 131). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Norg/npcs/Mamaulabion.lua (event 191 is the offer and its finish adds the quest with no refusal
-- branch; 192 is his talk while accepted with fewer than seven items given; each of the seven items (1202 to 1208) traded one at a time
-- plays 193, or 194 if it was given already, or 195 for the seventh, whose finish confirms the trade and sets the JST-midnight wait;
-- 196 plays during the wait; 197 plays after it and gives the Evoker's Ring, completing the quest only if a slot is free; 198 and 243 play
-- once completed). Client event script S4 252_Mamaulabion_010FC063.txt (191 say #10861, 192 say #10869, 194 say #10879, 195 say #10881,
-- 196 say #10883, 197 say #10885; 193 and 198 have no text). The seven items are battlefield rewards the player picks (an item alone is
-- never proof), so the fetching bullet (n=2) is a note on the trade step. Event 197 also plays when the bag is full (nothing is given and
-- the quest stays open), so it is reach and the log's completed bit proves s4. The quest repeats only through event 243 (a lost ring),
-- whose option cannot be seen, so repeats are not tracked.
return {
    title = 'Mama Mia',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to mamaulabion at g 6'},
         done = {
            {t = 'event', zone = 252, event = 191, why = 'Mamaulabion 191: the offer, the quest is added in its finish'},
            {t = 'chat', re = 'Rare goodieth and obthcure odditieth from around the globe', why = 'Mamaulabion 191 (say #10861)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 252, event = 192, conf = 'inferred', why = 'Mamaulabion 192: his talk while accepted'},
            {t = 'chat', re = "I'd like you to bring me thome rare itemth%.", conf = 'inferred', why = 'Mamaulabion 192 (say #10869)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'obtain the following seven items by'}},
        {id = 's3', at = {n = 3, fp = 'return all seven items to mamaulabion'},
         done = {
            {t = 'event', zone = 252, event = 195, why = 'Mamaulabion 195: the seventh item taken'},
            {t = 'chat', re = 'Thith maketh theven thuper%-duper', why = 'Mamaulabion 195 (say #10881)'},
            {t = 'event', zone = 252, event = 196, why = 'Mamaulabion 196: plays only once all seven are given'},
            {t = 'chat', re = "I'm on the verge of a thpectacular find%.", why = 'Mamaulabion 196 (say #10884)'},
         },
         reach = {
            {t = 'event', zone = 252, event = 193, why = 'Mamaulabion 193: one item taken'},
            {t = 'event', zone = 252, event = 194, why = 'Mamaulabion 194: an item given already'},
            {t = 'chat', re = 'Eh, not another .-%.', why = 'Mamaulabion 194 (say #10879)'},
         }},
        {id = 's4', at = {n = 4, fp = 'wait until midnight jst then speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Mamaulabion 197)'},
            {t = 'item', id = 14625, gained = true, after = 's3', conf = 'inferred', why = "Evoker's Ring gained (reward) (items can come from elsewhere)"},
         },
         reach = {
            {t = 'event', zone = 252, event = 197, after = 's3', why = 'Mamaulabion 197 (also plays when the bag is full: the ring is not given)'},
            {t = 'chat', re = "I wath wondering when you'd get back", after = 's3', why = 'Mamaulabion 197 (say #10885)'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'this quest is only repeatable if'}},
    },
}
