-- Step progress for A Pioneer's Best (Imaginary) Friend (Adoulin quest 75). Data only; see progress/quests/sandoria/27.lua for
-- the format. Evidence: LandSandBoat zones/Western_Adoulin/npcs/Merleg.lua and Ruth.lua (Merleg 2520 is shown while the quest
-- is available and addQuest runs on its finish with no option; while accepted his talk is 2521 without Ionis and 2522 with it,
-- and 2522 runs completeQuest; if Ionis is already on at the start, 2522 follows 2520 at once, so bullet 2 may never be seen.
-- Ruth (Fleuricette on the page) gives the Ionis in event 2523 when the quest is accepted and Ionis is off: 2523 is shared with
-- the Life on the Frontier mission, so only its quest lines are used: "Ah, so Merleg wants you to show him..." (say #7903) and
-- "Now you're now outfitted with an ionis" (say #7909). The Fail Badge (reward key item) is not used. The log is flagged at the
-- first bullet, so it is not silent. Client event scripts S4 256_Merleg_01100117.txt (2520 say #7897, 2521 say #7901, 2522 say
-- #7911 on both branches) and 256_Ruth_011000FC.txt (2523).
return {
    title = "A Pioneer's Best (Imaginary) Friend",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with merleg at h 11'},
         done = {
            {t = 'event', zone = 256, event = 2520, why = 'Merleg 2520: the offer, begins the quest with no option'},
            {t = 'chat', re = "If you're smart like me, you'll already know where to get it%.", why = 'Merleg 2520 (say #7897)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'get ionis from fleuricette at d'},
         done = {
            {t = 'chat', re = 'Ah, so Merleg wants you to show him the power of an ionis%.', why = 'Ruth 2523 (say #7903), only while the quest is accepted'},
            {t = 'chat', re = "Now you're now outfitted with an ionis%.", why = 'Ruth 2523 (say #7909): the Ionis given'},
         },
         reach = {
            {t = 'event', zone = 256, event = 2521, why = 'Merleg 2521: his talk while accepted without Ionis'},
            {t = 'chat', re = "Wow, you're kind of dumb for an adult%.", why = 'Merleg 2521 (say #7901)'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak with merleg again for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 256, event = 2522, why = 'Merleg 2522: plays only with Ionis on, runs completeQuest'},
            {t = 'chat', re = 'I guess you pass%.', why = 'Merleg 2522 (say #7911, both branches)'},
         }},
    },
}
