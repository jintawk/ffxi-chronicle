-- Step progress for Endeavoring to Awaken (Adoulin quest 22). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no decoded client event (Octavien's events 55-82 are bare cutscenes in S4
-- 257_Octavien_01101074.txt), so the signals are key items and the log, from BG-wiki's walkthrough (Octavien starts the quest and
-- hands over "Ephemeral Endeavor" in the same cutscene; clearing the fight awards "Enlightened Endeavor"; Octavien completes it).
-- Key item ids from res/key_items.lua (2352 temporary, 2353 permanent). The draft also gave bullet 2 "Rhapsody in Umber" (2885):
-- the page names it only as an optional Trust unlock, not as a result of the door, so it is dropped. "Enlightened Endeavor" is the
-- fight's reward and a permanent key item, so it supports bullet 5 only (inferred). The draft put the log's completed bit on
-- bullet 5; the quest completes when Octavien is seen again at bullet 6. The fight setup bullets (2 to 4) have no signal of their
-- own and are notes on the clear. Bullets 7 and 8 are notes of the page, not steps. Not repeatable.
-- Shared-signal audit: "Ephemeral Endeavor" (2352, its chat line) is also bought again from Octavien during Forging New Bonds (quest 23, page note), so all three are dropped (s1 keeps the accepted bit).
return {
    title = 'Endeavoring to Awaken',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to octavien to receive the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Octavien)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'the fight is triggered by speaking'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'after ascending the stairs zurko bazurko'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'in the center of the arena'}},
        {id = 's5', at = {n = 5, fp = 'clearing the fight will award you'},
         done = {
            {t = 'ki', id = 2353, gained = true, conf = 'inferred', after = 's1', why = '"Enlightened Endeavor" obtained (the fight reward, a permanent key item)'},
            {t = 'ki_have', id = 2353, have = true, conf = 'inferred', why = '"Enlightened Endeavor" held'},
            {t = 'chat', re = 'obtained key item: .?enlightened endeavor', conf = 'inferred', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to octavien to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
