-- Step progress for Those Who Lurk in Shadows (II) (A Crystalline Prophecy mission 6, mission id 5). Data only; see progress/missions/acp/1.lua.
-- Evidence: LandSandBoat scripts/zones/FeiYin/npcs/Seed_Afterglow.lua (zone 204) and zones/FeiYin/IDs.lua. Each of the nine Seed
-- Afterglows is touched once: the first prints YOU_REACH_OUT_TO_THE_LIGHT (text 7511) and starts the 30 minute Mark of Seed status
-- effect, the following ones print EVEN_GREATER_INTENSITY (7513); touching the ninth plays event 28, whose finish gives the Mark of
-- Seed (key item 1091) with option 100 (and prints SCINTILLATING_BURST_OF_LIGHT, 7515) or the Azure Key (1108) with option 200.
-- Event 28 also plays when the player picks neither (the effect is removed and nothing is given), so it is `reach`; the key item
-- gain is the proof of the gathering. Those lines and event ids are LandSandBoat's (no client script is decoded for this NPC).
-- The page's bullet 1 is the gathering itself (30 minutes, nine afterglows); bullets 2 and 3 (where they move, the route) are tips on
-- it. LandSandBoat completes the mission in a Qu'Bia Arena Burning Circle cutscene (event 5, code disabled there) that this page
-- has no bullet for (it opens the next page), so s1 is `completes` and also takes the acp line having moved to 6, which covers a
-- character that finished before installing Chronicle. The Mark of Seed is taken again at the Qu'Bia battlefield entry and comes
-- back on a repeat, which only re-ticks. Bullet 6, the Azure Key use, is a post step: the key's only source is this event and the
-- Treasure Coffer (Lower Jeuno 245) deletes it when a prize is given. The draft chose the tip bullet 2 as the step and guessed a
-- repeat restart; the mission is not run again as a unit, the repeat is only the daily key, so there is no `repeatable`.
return {
    title = 'Those Who Lurk in Shadows (II)',
    completes = 's1',
    known = {{t = 'mission', line = 'acp', eq = 5}},
    groups = {main = {start = {{t = 'mission', line = 'acp', min = 5, why = 'mission line: Those Who Lurk in Shadows (II) is current'}}}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you have 30 minutes earth time'},
         done = {
            {t = 'ki', id = 1091, gained = true, why = 'Mark of Seed obtained (the ninth Seed Afterglow, option 100)'},
            {t = 'ki', id = 1108, gained = true, why = 'Azure Key obtained (the ninth Seed Afterglow, option 200)'},
            {t = 'chat', re = 'As you extend your hand, there is a scintillating burst of light!', why = 'Seed Afterglow text 7515 (SCINTILLATING_BURST_OF_LIGHT), option 100 only'},
            {t = 'ki_have', id = 1091, have = true, why = 'Mark of Seed held'},
            {t = 'ki_have', id = 1108, have = true, why = 'Azure Key held'},
            {t = 'mission', line = 'acp', min = 6, why = 'mission line: Those Who Lurk in Shadows (III) is current, (II) is done'},
         },
         reach = {
            {t = 'event', zone = 204, event = 28, why = 'Seed Afterglow 28: the ninth afterglow touched (also plays when no reward is picked)'},
            {t = 'chat', re = 'You reach out to the light, and one facet of a curious seed%-shaped emblem materializes on the back of your hand%.', why = 'Seed Afterglow text 7511: the first afterglow touched'},
            {t = 'chat', re = 'The emblem on your hand glows with even greater intensity!', why = 'Seed Afterglow text 7513: a further afterglow touched'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'the seed afterglows move periodically but'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'recommended route'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'you may only repeat this process'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'rewards are listed on the add'}},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'use the azure key level 60'},
         done = {
            {t = 'ki', id = 1108, gained = false, why = 'Azure Key used at the Treasure Coffer (deleted when the prize is given)'},
         }},
    },
}
