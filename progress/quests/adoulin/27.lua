-- Step progress for Wayward Waypoints (Adoulin quest 27). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no quest script, only Shipilolo (Western Adoulin, event 79 plays while the quest is accepted, the
-- character variable WW_Need_Shipilolo is set and the recalibration kit is not held; its finish gives the Waypoint recalibration
-- kit with no refusal) and the page. Client event script S4 256_Shipilolo_0110010C.txt (79 says "Sharuru? That hussy?" and hands
-- over key item 2380; the scanner kit 2264 is named in the same event). Sharuru has no client script and no LandSandBoat script, so
-- her three talks have no event proof: the scanner kit (key item 2264, bullet 1's own text) carries bullet 1 and the log's
-- completed bit carries the last bullet (the quest is accepted at the first bullet, so the accepted bit is a bullet 1 signal).
-- The draft put the completed bit on bullet 5; the quest completes only when Sharuru is seen again at bullet 7. The frontier
-- station adjustments, the Lower Jeuno waypoint tries and the return talk have no signal of their own and are notes on the step
-- they lead into. Not repeatable.
-- Shared-signal audit: the Waypoint scanner kit (2264, its chat line) is also handed out by Sharuru for Meg-alomaniac (quest 89, the previous quest), so all three are dropped (s1 keeps the accepted bit); the Shipilolo 79 event and line stay gated after s1 (event 2850 of Fertile Ground says the same line).
return {
    title = 'Wayward Waypoints',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sharuru in eastern adoulin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Sharuru starts the quest)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'adjust the waypoints at the frontier'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'attempt the waypoint in lower jeuno'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'return to sharuru'}},
        {id = 's5', at = {n = 5, fp = 'head to shipilolo outside the inventors'},
         done = {
            {t = 'event', zone = 256, event = 79, after = 's1', why = 'Shipilolo 79: needs the quest accepted and the Lower Jeuno try made; gives the recalibration kit'},
            {t = 'chat', re = "Here to see the loveliest lady of the Inventors' Coalition%?", after = 's1', why = 'Shipilolo 79 (say #8105)'},
            {t = 'ki', id = 2380, gained = true, after = 's1', why = 'waypoint recalibration kit obtained'},
            {t = 'ki_have', id = 2380, have = true, why = 'waypoint recalibration kit held'},
            {t = 'chat', re = 'obtained key item: waypoint recalibration kit', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'return to lower jeuno waypoint and'}},
        {id = 's7', at = {n = 7, fp = 'go back to sharuru to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
