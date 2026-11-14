-- Step progress for Face of the Future (Crystal War quest 61, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/crystalWar/WOTG_SAN_12_Face_of_the_Future.lua; client event scripts S4
-- 105_Cavernous_Maw_01069262.txt and 105_Cavernous_Maw_01069263.txt (504 and 505, bare cutscenes). There is no menu event in the
-- chain except the instance prompt (event 103 with the quest id, declinable, not matched). The quest is already accepted when the
-- chain starts (the previous quest hands it on), so the log's current bit proves nothing here. The steps are the zone-in and
-- object cutscenes in order: Jugner Forest zone-in 44 (from Batallia Downs, zone 104), Metallic Hodgepodge 45, the Ghelsba
-- Outpost zone-in 57 (zone 140; the Orcish infiltration kit, 1278, is the pickup), Scrape Mark 1 (Yughott Grotto, zone 142). The
-- battle is not implemented in LandSandBoat but leaving it sets Prog 5 and the Yughott Grotto zone-in 2 plays, so that is the win
-- (attached to the Scrape Mark enter bullet, n=5; the page has no bullet for the win itself). Then the Batallia Downs [present]
-- Cavernous Maw 504 (only once the maw is unlocked in the past), zone-in 505, Xarcabard [S] zone-in 40, Batallia Downs zone-in
-- 508 and the last Batallia Downs zone-in 507, which runs quest:complete: n=10 is the whole closing chain, 507 and the completed
-- bit prove it and the others are reach. The draft's 'silent_until' and the completed bit on the first step are dropped. Not repeatable.
-- Shared-signal audit: events 44 and 45 of zone 104, 57 of zone 140, 1 and 2 of zone 142, 504 to 508 of zone 105 and 40 of zone
-- 137 are used by no other script naming those zones (other quests and missions there use 5, 6 to 10, 13, 15, 18, 48, 49 in zone
-- 104; 3, 4, 500 to 503, 5 in zone 105; 8 to 10, 17 to 26, 30 to 34, 39, 41, 42 in zone 137; the same numbers elsewhere are in other
-- zones); the Orcish infiltration kit (1278) is named by this quest alone; nothing under progress/ uses zones 105, 140 or 142 (zones 104
-- and 137 are used only by other ids).
-- Second audit (2026-10-31): the Clandestine Marking at Ghelsba Outpost hands out the kit whenever it is not held, with no Prog
-- check (LandSandBoat), so the kit's gain, hold and chat line are gated after s2 and cannot tick the zone-in step early; the
-- final zone-in 507 moved to a reach (a full bag plays it without completing, per the page).
-- Screen review (2026-10-31): the page's closing step ("After the battle, examine the Cavernous Maw...") is a plain paragraph, not a
-- bullet, and bullets 10 to 13 are notes, so no step may sit on them. The completed bit and the closing chain (reach) are folded into
-- the last real step, the Scrape Mark battlefield bullet (n=5), as in wotg/52; completes is s5 and bullets 10 to 13 are notes on it.
return {
    title = 'Face of the Future',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone into jugner forest from batallia'},
         done = {
            {t = 'zonein', zone = 104, event = 44, why = 'Jugner Forest zone-in cutscene 44 from Batallia Downs: plays only at Prog 0, sets Prog 1'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the metallic hodgepodge in jugner'},
         done = {
            {t = 'event', zone = 104, event = 45, why = 'Metallic Hodgepodge 45: plays only at Prog 1, sets Prog 2'},
         }},
        {id = 's3', at = {n = 3, fp = 'zone into ghelsba outpost for a'},
         done = {
            {t = 'zonein', zone = 140, event = 57, why = 'Ghelsba Outpost zone-in cutscene 57: plays only at Prog 2, sets Prog 3'},
            {t = 'ki', id = 1278, gained = true, after = 's2', why = 'Orcish infiltration kit obtained'},
            {t = 'ki_have', id = 1278, have = true, after = 's2', why = 'Orcish infiltration kit held'},
            {t = 'chat', re = 'obtained key item: orcish infiltration kit', after = 's2', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'travel from ghelsba outpost to map'},
         done = {
            {t = 'event', zone = 142, event = 1, why = 'Scrape Mark 1: plays only at Prog 3, sets Prog 4'},
         }},
        {id = 's5', at = {n = 5, fp = 'examine the scrape mark again to'},
         done = {
            {t = 'zonein', zone = 142, event = 2, why = 'Yughott Grotto zone-in cutscene 2: back from the battle (Prog 5), sets Prog 6'},
            {t = 'quest', completed = true, why = 'quest log: completed (the closing Batallia Downs cutscenes, which the page does not list as a bullet)'},
         },
         reach = {
            {t = 'zonein', zone = 105, event = 507, why = 'Batallia Downs zone-in cutscene 507: the last one; with a full bag it plays without completing (page: the reward waits at a ???), so it is only a reach'},
            {t = 'event', zone = 105, event = 504, why = 'Cavernous Maw 504: plays at Prog 6 once the maw is unlocked, sets Prog 7'},
            {t = 'zonein', zone = 105, event = 505, why = 'Batallia Downs zone-in cutscene 505 (Prog 7)'},
            {t = 'zonein', zone = 137, event = 40, why = 'Xarcabard [S] zone-in cutscene 40 (Prog 8)'},
            {t = 'zonein', zone = 105, event = 508, why = 'Batallia Downs zone-in cutscene 508 (Prog 9)'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'you only need to kill fangmonger'}},
        {id = 's7', kind = 'note', with = 's5', at = {n = 7, fp = 'each tombstone defeated will weaken the'}},
        {id = 's8', kind = 'note', with = 's5', at = {n = 8, fp = 'the colossus and tombstones use the'}},
        {id = 's9', kind = 'note', with = 's5', at = {n = 9, fp = 'kiting the statues while keeping the'}},
        {id = 's10', kind = 'note', with = 's5', at = {n = 10, fp = 'this cavernous maw must be unlocked'}},
        {id = 's11', kind = 'note', with = 's5', at = {n = 11, fp = 'quickest way there is to use'}},
        {id = 's12', kind = 'note', with = 's5', at = {n = 12, fp = 'if you have a full inventory'}},
        {id = 's13', kind = 'note', with = 's5', at = {n = 13, fp = 'you may now speak to rholont'}},
    },
}
