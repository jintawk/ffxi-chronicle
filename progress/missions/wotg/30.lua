-- Step progress for Prelude to a Storm (Wings of the Goddess mission id 30). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/31_Prelude_to_a_Storm.lua. Rally Point: Green (Xarcabard [S] 137) plays event 21 at
-- Status 0 and gives the Magelight signal flare (key item 1237); event 25 re-gives a lost flare at Status 1. The Spell-worked Snow
-- starts the Ghoyu's Reverie battlefield: LandSandBoat only notes "Event 27" for it (no handler, and an entry event may play on a
-- decline), so bullet 2 is a note. After the fight the player returns to Xarcabard [S] at Status 2 and zone-in cutscene 22 plays;
-- its finish gives the reward and completes the mission, so it proves bullet 3 only as reach (see below). LandSandBoat's Ghoyu's Reverie event 10000 is marked
-- by its own author as an unverified assumption and is not used. Bullet 4 (full inventory: go back to the Rally Point) is a note.
-- A full bag fails npcUtil.giveItem before mission:complete and zone-in 22 replays (LandSandBoat 31_Prelude_to_a_Storm.lua:91), so 22 is reach; the completed bit carries the step.
return {
    title = 'Prelude to a Storm',
    completes = 's3',
    known = {{t = 'mission', line = 'wotg', eq = 30}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the rally point green in'},
         done = {
            {t = 'event', zone = 137, event = 21, why = 'Rally Point: Green 21 (Status 0)'},
            {t = 'event', zone = 137, event = 25, why = 'Rally Point: Green 25 (Status 1, flare lost): the flare again'},
            {t = 'ki', id = 1237, gained = true, why = 'Magelight signal flare obtained'},
            {t = 'ki_have', id = 1237, have = true, why = 'Magelight signal flare held'},
            {t = 'chat', re = 'obtained key item: magelight signal flare', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'examine the spell worked snow just'}},
        {id = 's3', at = {n = 3, fp = 'you will receive the express message'},
         done = {
            {t = 'mission', line = 'wotg', eq = 30, completed = true, why = 'mission log: Prelude to a Storm completed'},
         },
         reach = {
            {t = 'zonein', zone = 137, event = 22, why = 'Xarcabard [S] zone-in cutscene 22 after the fight (Status 2): replays on a full bag, so it does not prove the mission completed'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'note if your inventory is full'}},
    },
}
