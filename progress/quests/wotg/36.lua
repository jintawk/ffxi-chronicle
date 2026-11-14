-- Step progress for Fire in the Hole (Crystal War quest 36, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/crystalWar/WOTG_BAS_6_Fire_in_the_Hole.lua; client event scripts S4
-- 087_Gentle_Tiger_010571D7.txt (63 and 65 are bare cutscenes), 087___01057244.txt (event 77, a zone event), 088_Solitary_Ant_01058336.txt
-- (7 and 8, the key reminders). Zoning into Bastok Markets [S] from North Gustaberg [S] plays 60, whose finish starts 77, and the
-- finish of 77 begins the quest and hands over the Silvermine key (988); neither has a menu. The Stonehoused Adit plays 5 once
-- (Prog 0, key held); after that its trigger is the instance prompt 203 (instance table args {203, 0, 0, 36}), which has a menu and
-- can be declined, so it is only a reach for the fight. LandSandBoat does not implement the battle (the instance is missing), but
-- its Solitary Ant 8 ("lost your key") plays only after the fight began with the key gone, and the page says a failed fight needs a
-- new key from the Ant, so the key's loss after the Adit cutscene marks the fight (inferred). The zone-in cutscene 6 back in North
-- Gustaberg [S] (Prog 3, from Ruhotz Silvermines) is the win; the zone-in 62 into Bastok Markets [S] is bullet 6; Gentle Tiger 63
-- and 65 are the last two talks, 65 runs quest:complete. The draft's Solitary Ant 7 (a plain reminder while the key is held) and
-- the zone-in 62 on the fight bullet are dropped. Not repeatable.
-- Shared-signal audit: Silvermine key 988 is used only by this quest; events 5, 6, 203 of zone 88 and 60, 62, 63, 65, 77 of zone
-- 87 are owned by this quest alone among the scripts that name those zones (event headers; grep of quests, missions and the
-- two zone folders); nothing under progress/ uses zone 88 or those ids.
-- check_steps (2026-10-31): the Adit 203 reach is dropped, the id is in neither the quest script nor the client scripts (only the instance table).
-- Second audit (2026-10-31): the Adit is the shared entrance of the Ruhotz Silvermines instances (LandSandBoat instance table: 203 with
-- the quest id as its third argument), so the prompt is gated on P2 = 36 and stays a reach.
return {
    title = 'Fire in the Hole',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into bastok markets s from'},
         done = {
            {t = 'event', zone = 87, event = 77, why = 'zone cutscene 77: no menu, its finish begins the quest and gives the Silvermine key'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 988, gained = true, why = 'Silvermine key obtained'},
            {t = 'ki_have', id = 988, have = true, why = 'Silvermine key held'},
            {t = 'chat', re = 'obtained key item: silvermine key', why = 'chat: key item obtained'},
         },
         reach = {{t = 'zonein', zone = 87, event = 60, why = 'zone-in cutscene 60 from North Gustaberg [S], leads into 77'}}},
        {id = 's2', at = {n = 2, fp = 'go to north gustaberg s top'},
         done = {
            {t = 'event', zone = 88, event = 5, why = 'Stonehoused Adit 5: plays at Prog 0 with the key, sets Prog 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the stonehoused adit again to'},
         done = {
            {t = 'ki', id = 988, gained = false, after = 's2', conf = 'inferred', why = 'Silvermine key used up when the fight starts (LandSandBoat Solitary Ant 8)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'your goal is to protect the'}},
        {id = 's5', at = {n = 5, fp = 'once you defeat all of the'},
         done = {
            {t = 'zonein', zone = 88, event = 6, why = 'North Gustaberg [S] zone-in cutscene 6: back from Ruhotz Silvermines after the battle (Prog 3)'},
         }},
        {id = 's6', at = {n = 6, fp = 'enter bastok markets s from north'},
         done = {
            {t = 'zonein', zone = 87, event = 62, why = 'Bastok Markets [S] zone-in cutscene 62: plays only at Prog 4, sets Prog 5'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to gentle tiger in bastok'},
         done = {
            {t = 'event', zone = 87, event = 63, why = 'Gentle Tiger 63: plays only at Prog 5, sets Prog 6'},
         }},
        {id = 's8', at = {n = 8, fp = 'speak to gentle tiger again for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 87, event = 65, why = 'Gentle Tiger 65: the second cutscene, runs quest:complete'},
         }},
    },
}
