-- Step progress for Blood of Heroes (Crystal War quest 52, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/crystalWar/WOTG_SAN_10_Blood_of_Heroes.lua (all events are in Xarcabard [S], zone 137; the
-- client has no event script for the Animal Spoor, Wheel Rut or Forbidding Portal, so there are no lines to match). Animal Spoor 1
-- begins the quest (no menu); Wheel Rut 2 sets Prog 1; Animal Spoor 3 (Prog 1) hands over the Vial of military prism powder (1180)
-- and sets Prog 2; Forbidding Portal 4 is the first cutscene (Prog 3) and a second visit opens the instance prompt (event 12 with
-- the quest id, which has a menu and is shared with other Xarcabard [S] instance quests, so it is not matched). The page says a
-- lost fight needs a new vial from the Spoor (LandSandBoat's Spoor 13), so the vial is used up when the battle is entered; its loss
-- after bullet 3 is inferred for bullet 4. Leaving the battle sets Prog 4 and the zone-in 6 plays, then Wheel Rut 7 runs
-- quest:complete. The page has no bullet for that last Wheel Rut visit, so the battle bullet (n=6) carries the win, event 7 and the
-- completed bit. The draft's 'post' kinds are dropped (nothing here follows the log's completion). Not repeatable.
-- Shared-signal audit: events 1 to 4, 6, 7 and 13 of zone 137 are used by no other script naming Xarcabard [S] (the other quests
-- and missions there use 8 to 10, 17 to 26, 30 to 34, 39 to 42); key item 1180 is named by this quest alone; nothing under
-- progress/ uses zone 137.
return {
    title = 'Blood of Heroes',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the animal spoor in xarcabard'},
         done = {
            {t = 'event', zone = 137, event = 1, why = 'Animal Spoor 1: begins the quest (no menu)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the wheel rut at i'},
         done = {
            {t = 'event', zone = 137, event = 2, why = 'Wheel Rut 2: plays only at Prog 0, sets Prog 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the animal spoor at j'},
         done = {
            {t = 'event', zone = 137, event = 3, why = 'Animal Spoor 3: plays only at Prog 1, hands over the vial'},
            {t = 'ki', id = 1180, gained = true, why = 'Vial of military prism powder obtained'},
            {t = 'ki_have', id = 1180, have = true, why = 'Vial of military prism powder held'},
            {t = 'chat', re = 'obtained key item: vial of military prism powder', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the forbidding portal door in'},
         done = {
            {t = 'ki', id = 1180, gained = false, after = 's3', conf = 'inferred', why = 'vial used up when the battle is entered (page: a lost fight needs a new vial)'},
         },
         reach = {{t = 'event', zone = 137, event = 4, why = 'Forbidding Portal 4: the first cutscene, plays at Prog 2, sets Prog 3'}}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'you will be assisted by excenmille'}},
        {id = 's6', at = {n = 6, fp = 'defeating kingslayer doggvdegg will end the'},
         done = {
            {t = 'zonein', zone = 137, event = 6, why = 'Xarcabard [S] zone-in cutscene 6: back from the battle (Prog 4), sets Prog 5'},
            {t = 'event', zone = 137, event = 7, why = 'Wheel Rut 7: the ending, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed (Wheel Rut 7, after the battle)'},
         }},
    },
}
