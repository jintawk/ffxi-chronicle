-- Step progress for Light in the Darkness (Crystal War quest 19, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/crystalWar/WOTG_BAS_3_Light_in_the_Darkness.lua; client event scripts S4
-- 087_Gentle_Tiger_010571D7.txt, 087_Pagdako_010571D4.txt, 087_Blatherix_0105723E.txt (all in Bastok Markets [S], zone 87).
-- Gentle Tiger 16 is the offer (a cutscene with no menu; its finish runs quest:begin, so the log's current bit is the accept);
-- Pagdako 19 sets Prog 1 and Blatherix 21 sets Prog 2 (no refusal branch on either); Blatherix 22 is his ask (30 Goblin Chocolate
-- or 5,000 gil, say #12574) and 23 plays only on that exact trade (a wrong trade plays nothing), hands over the Mine shaft key
-- (961) and sets Prog 3. Registering the battlefield deletes the key (the instance script, afterInstanceRegister), so its loss
-- proves the Corroded Door step; the failure path hands out a new one through the same 23. The zone-in cutscenes 901 and 902 in
-- Pashhow Marshlands [S] are LandSandBoat numbers with no client script behind them, so the zone-in bullet and the battle are
-- notes. Gentle Tiger 27 (Prog 6) runs quest:complete, so it and the completed bit belong to the last Gentle Tiger bullet (n=7),
-- not the first; bullet 8 is its reward line. The draft's Bundle of half-inscribed scrolls (2510) is dropped: it is the unrelated
-- item Gentle Tiger remarks on in the sub-bullet (LandSandBoat gives it in Batallia Downs [S] only). Reminder events 17, 20 and 24
-- play only after the step they follow, so they are inferred. The count of 30 Goblin Chocolate is dropped (5,000 gil also pays).
-- Not repeatable.
-- Shared-signal audit: events 16 to 25 and 27 of zone 87 are defined by one NPC each and owned by this quest alone (event
-- headers); the Mine shaft key (961) is used by this quest and its instance only (no other script, nothing under progress/).
-- Second audit (2026-10-31): event 27 moved from the done list to a reach: the page warns that a full bag at the final
-- cutscene means no reward and the whole cutscene again (LandSandBoat: quest:complete fails, the quest stays at Prog 6), so
-- the cutscene is not proof of completion; the completed bit carries the step.
return {
    title = 'Light in the Darkness',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to gentle tiger in bastok'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Gentle Tiger 16)'},
            {t = 'event', zone = 87, event = 16, why = 'Gentle Tiger 16: the offer cutscene (no menu, its finish begins the quest)'},
            {t = 'event', zone = 87, event = 17, conf = 'inferred', why = 'Gentle Tiger 17: his reminder, plays only while accepted'},
            {t = 'chat', re = "I've been alert the entire time%.", conf = 'inferred', why = 'Gentle Tiger 17 (say #12527)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to pagdako at h 9'},
         done = {
            {t = 'event', zone = 87, event = 19, why = 'Pagdako 19: plays only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 87, event = 20, conf = 'inferred', why = 'Pagdako 20: his reminder, plays only after 19'},
            {t = 'chat', re = "I'm so glad Elder Werei and Gumbah are free from those horrible accusations%.", conf = 'inferred', why = 'Pagdako 20 (say #12569)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to blatherix at f 8'},
         done = {
            {t = 'event', zone = 87, event = 23, why = 'Blatherix 23: the exact trade accepted, hands over the Mine shaft key'},
            {t = 'ki', id = 961, gained = true, why = 'Mine shaft key obtained'},
            {t = 'ki_have', id = 961, have = true, why = 'Mine shaft key held'},
            {t = 'chat', re = 'obtained key item: mine shaft key', why = 'chat: key item obtained'},
            {t = 'event', zone = 87, event = 24, conf = 'inferred', why = 'Blatherix 24: his reminder, plays only after the trade'},
            {t = 'chat', re = "There's an entrance to a mine shaft in the Pashhow Marshlands%.", conf = 'inferred', why = 'Blatherix 24 (say #12578)'},
         },
         reach = {
            {t = 'event', zone = 87, event = 21, why = 'Blatherix 21: the first talk, sets Prog 2'},
            {t = 'event', zone = 87, event = 22, why = 'Blatherix 22: his ask for 30 Gob. Chocolate or 5,000 gil'},
            {t = 'chat', re = 'A Quadav mine in the Pashhow Marshlands%?', why = 'Blatherix 22 (say #12574)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'zone in to pashhow marshlands s'}},
        {id = 's5', at = {n = 5, fp = 'examine the corroded door in pashhow'},
         done = {
            {t = 'ki', id = 961, gained = false, after = 's3', why = 'Mine shaft key deleted when the battlefield is registered'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'in the battlefield you will encounter'}},
        {id = 's7', at = {n = 7, fp = 'speak to gentle tiger for a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 87, event = 27, why = 'Gentle Tiger 27: the final cutscene; with a full bag it plays and replays without completing (page notice), so it is only a reach'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'when the cutscene ends you will'}},
    },
}
