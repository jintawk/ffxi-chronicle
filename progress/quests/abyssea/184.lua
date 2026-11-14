-- Step progress for The Wyrm God (Abyssea quest 184). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/abyssea/The_Wyrm_God.lua; client event script S4 255_Prishe_010FF01D.txt (Abyssea -
-- Empyreal Paradox: event 203 has no text). The quest is flagged by Beneath a Blood-red Sky's closing cutscene inside the
-- Empyreal Paradox, so its current bit is set exactly when bullet 1 (enter the Paradox through the Radiance) is done, and
-- that bit is the only signal of the bullet. The draft proved bullet 1 by the Crimson traverser stone (1538) and its chat
-- line; those are the same signals as quest 183's third bullet (the stone is handed out once, during 183), so they are dropped
-- here, as is the zone-in 202. Bullet 2 (the Radiance cutscene 208 and the battlefield) is a note: 208 plays only at Prog 0 and
-- the second examine that enters the battlefield has no signal, so the bullet cannot be proved as a whole. Prishe 203 plays
-- only after the battle is won (Prog 2), has no refusal branch and its finish runs quest:complete, so it proves bullet 3 with the
-- log's completed bit. 206 (the completed-quest talk) is not used. Not repeatable. The log is set before bullet 1, so it is
-- not silent. Shared-signal audit: Prishe 203 belongs to this quest alone (204 and 207 are Meanwhile, Back on Abyssea's).
return {
    title = 'The Wyrm God',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'enter abyssea empyreal paradox through the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: flagged by the Paradox cutscene that ends Beneath a Blood-red Sky'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examine the transcendental radiance in the'}},
        {id = 's3', at = {n = 3, fp = 'speak to prishe after defeating shinryu'},
         done = {
            {t = 'event', zone = 255, event = 203, why = 'Prishe 203: after Shinryu, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
