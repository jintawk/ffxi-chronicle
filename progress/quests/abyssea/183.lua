-- Step progress for Beneath a Blood-red Sky (Abyssea quest 183). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/abyssea/Beneath_a_Blood_Red_Sky.lua and zones/Qufim_Island/npcs/Transcendental_Radiance.lua;
-- client event script S4 126_Transcendental_Radiance_0107E1F8.txt (Qufim Island) and the Empyreal Paradox's Prishe file (zone 255).
-- The quest completes in the Empyreal Paradox zone-in cutscene (event 202, played on every entry while the quest is held),
-- whose finish runs quest:complete and flags The Wyrm God, so that zone-in and the log's completed bit prove bullet 3; the
-- Crimson traverser stone (1538) is handed out by the Radiance's "Proceed" just before the warp and supports it. Bullet 2 (click
-- the Radiance with a Traverser stone) is a note: LandSandBoat says the accepted state plays event 47 (empty in the client) and the
-- completed state 46, while the client's 46 is the one with the menu, and every line of 46 plays before the "Not yet" answer
-- too, so no event or line proves the click or the Proceed answer on its own. Bullets 1 and 4 are travel and a flagging note.
-- Not repeatable. Shared-signal audit: the Crimson traverser stone and Empyreal Paradox zone-in 202 are also what The Wyrm God's
-- first bullet describes, so quest 184 does not use them; the Radiance events 46 and 47 are used by no mapping.
return {
    title = 'Beneath a Blood-red Sky',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'head to qufim island f 7'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'click on the transcendental radiance with'}},
        {id = 's3', at = {n = 3, fp = 'select proceed to spend 10 000'},
         done = {
            {t = 'zonein', zone = 255, event = 202, why = 'Empyreal Paradox zone-in 202: the cutscene, runs quest:complete'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 1538, gained = true, why = 'crimson traverser stone obtained'},
            {t = 'ki_have', id = 1538, have = true, why = 'crimson traverser stone held'},
            {t = 'chat', re = 'obtained key item: crimson traverser stone', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'the next quest is automatically flagged'}},
    },
}
