-- Step progress for Mysteries of Beadeaux I (Jeuno quest 31). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/jeuno/Mysteries_of_Beadeaux_I.lua (Sattal-Mansal, Lower Jeuno: 89 is a cutscene with
-- no choice, offered with P0 = 0 when the player holds the Silver bell and begins this quest and Mysteries of Beadeaux II on
-- its finish, and replayed with P0 = 1 as the reminder while accepted; the "Wait, so all you got from Aldo" line is the
-- P0 = 0 branch only; 91 plays only for an exact Quadav Charm trade, hands the Coruscant rosary over as it starts and ends
-- in completeQuest, nothing to refuse); client event script S4 245_Sattal_Mansal_010F500E.txt (89 say #7715/#7716, 91 say
-- #7718); item id from res/items.lua (495 Quadav Charm) and key item from res/key_items.lua (46 coruscant rosary). Bullet 2
-- is a drop to hunt, so it is a note on the trade. Not repeatable.
-- Sattal-Mansal 92 (Mysteries of Beadeaux II) says the identical line (#7720), so the line counts only once the accepted bit was seen
-- (after = 's1'). The Quadav Charm going (item 495) is left out: The Rescue takes a Quadav Charm too (Beadeaux door _43b).
return {
    title = 'Mysteries of Beadeaux I',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sattal mansal to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Sattal-Mansal 89)'},
            {t = 'chat', re = 'Wait, so all you got from Aldo was', why = 'Sattal-Mansal 89, the offer (P0 = 0, say #7715)'},
            {t = 'event', zone = 245, event = 89, p = {[0] = 1}, why = 'Sattal-Mansal 89, P0 = 1: the reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 245, event = 89, why = 'Sattal-Mansal 89: the offer or the reminder'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to beadeaux and kill de'}},
        {id = 's3', at = {n = 3, fp = 'trade the quadav charm to sattal'},
         done = {
            {t = 'event', zone = 245, event = 91, why = 'Sattal-Mansal 91: the Quadav Charm accepted'},
            {t = 'chat', re = 'Okey%-dokey, here you go%.', after = 's1', why = 'Sattal-Mansal 91 (say #7718)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 46, gained = true, conf = 'inferred', why = 'coruscant rosary obtained (reward)'},
         }},
    },
}
