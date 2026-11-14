-- Step progress for Escort for Hire (Bastok) (Bastok quest 70). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest but has no script for it, and the client event scripts have no Trilok or Olavia, so
-- no event is used. What is left are the quest log (accepted when Trilok begins it, completed when the player returns to him,
-- as the page's bullets say) and the Completion certificate (key item 346 in res/key_items.lua), handed over at the end of the
-- escort. The page's rule and tip bullets, the zone-in and the two bullets about moving Olavia (n=7 to 10, 13) have no
-- strong signal and stay plain bullets. The quest is repeatable, but a repeat leaves no trace of its own (the log bits stay set
-- and the return talk has no event id), so there is no `repeatable` entry and a repeat is not tracked.
-- Shared-signal audit: the Completion certificate (key item 346) is also handed over by Escort for Hire in the other nations (windurst/88),
-- so its gain and line are gated after s6 (the quest log's accepted bit); ki_have 346 dropped (login snapshots would never pass a gate).
return {
    title = 'Escort for Hire (Bastok)',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's6', at = {n = 6, fp = 'speak with trilok to begin quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's11', at = {n = 11, fp = 'escort her to the end point'},
         done = {
            {t = 'ki', id = 346, gained = true, after = 's6', why = 'completion certificate obtained'},
            {t = 'chat', re = 'obtained key item: completion certificate', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's12', at = {n = 12, fp = 'return to trilok to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
