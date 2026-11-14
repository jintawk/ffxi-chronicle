-- Step progress for Daughter of a Knight (Wings of the Goddess mission 10, mission id 9). Data only; see progress/missions/cop/110.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/10_Daughter_of_a_Knight.lua; key item 1061 (Cernunnos resin) from res/key_items.lua.
-- Status 0: Amaura in Southern San d'Oria (zone 230) plays 935, status 1. Status 1: trading the Cernunnos Bulb plays 937 (only on a
-- matching trade; the bulb is kept), status 2. Status 2: trading the bulb to the Humus-rich Earth in Jugner Forest [S] (zone 82)
-- takes it and prints "You plant <item>." (no event; the message is the client's own text and only the matching trade prints it),
-- status 3. Status 3: the Humus-rich Earth in Jugner Forest (104) plays 33, status 4. Status 4: after Cernunnos falls the earth plays
-- 34 and hands out the Cernunnos resin (a reward, not used alone), status 5; the bullet before it (spawning the mob) is a note.
-- Status 5: Amaura plays 939 and takes the resin (key item loss, status 6); the reminder 940 and 936 / 938 prove nothing and are not
-- used. Status 6: after the next game day and a zone, Amaura plays 941, which completes the mission and hands out the Bottle of
-- treant tonic (a reward key item, not used). The draft was right apart from bullet 3, which had no signal: the plant message
-- is used, counted only after the Amaura trade of bullet 2, and the reward key items and the resin handing-in guess were dropped.
return {
    title = 'Daughter of a Knight',
    completes = 's8',
    known = {{t = 'mission', line = 'wotg', eq = 9}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to amaura in southern san'},
         done = {
            {t = 'event', zone = 230, event = 935, why = 'Amaura 935: asks for a Cernunnos Bulb (status 0)'},
         }},
        {id = 's2', at = {n = 2, fp = 'trade the cernunnos bulb to amaura'},
         done = {
            {t = 'event', zone = 230, event = 937, why = 'Amaura 937: the Cernunnos Bulb shown (status 1)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade the cernunnos bulb to the'},
         done = {
            {t = 'chat', re = 'you plant .*cernunnos bulb', after = 's2', why = 'Humus-rich Earth: "You plant <item>." (status 2)'},
         },
         reach = {
            {t = 'item', id = 2728, lost = true, why = 'Cernunnos Bulb planted (tradeComplete)'},
         }},
        {id = 's4', at = {n = 4, fp = 'now time travel to jugner forest'},
         done = {
            {t = 'event', zone = 104, event = 33, why = 'Humus-rich Earth 33: the cutscene in the present day (status 3)'},
         }},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'examine the humus rich earth again'}},
        {id = 's6', at = {n = 6, fp = 'examine the humus rich earth again'},
         done = {
            {t = 'event', zone = 104, event = 34, why = 'Humus-rich Earth 34: Cernunnos defeated, the resin handed out (status 4)'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to amaura with the key'},
         done = {
            {t = 'event', zone = 230, event = 939, why = 'Amaura 939: the resin handed in (status 5)'},
         }},
        {id = 's8', at = {n = 8, fp = 'speak to amaura after waiting until'},
         done = {
            {t = 'event', zone = 230, event = 941, why = 'Amaura 941: completes the mission (status 6)'},
            {t = 'mission', line = 'wotg', eq = 9, completed = true, why = 'mission log: Daughter of a Knight completed'},
         }},
    },
}
