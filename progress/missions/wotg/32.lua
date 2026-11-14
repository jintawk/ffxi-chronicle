-- Step progress for Into the Beast's Maw (Wings of the Goddess mission id 32). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/wotg/33_Into_the_Beasts_Maw.lua. Castle Zvahl Baileys [S] (138) zone-in cutscene 1 plays at
-- Status 0; Peculiar Glint event 2 at Status 1 (then zone-in cutscenes 14 and 15, the last gives the Distress signal flare); after the
-- fight zone-in cutscene 3 plays at Status 5 and its finish completes the mission. The Ornate Block (event 11) plays whether or not the
-- player accepts the flare, so it proves nothing. The battlefield entry event is only a TODO in LandSandBoat (Entry Event 6) and is not
-- used. Bullet 1 (Rally Point: Red) is a bare message in LandSandBoat although the page says cutscene: it is a note on the next step.
-- No client script exists for these ids.
return {
    title = "Into the Beast's Maw",
    completes = 's4',
    known = {{t = 'mission', line = 'wotg', eq = 32}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'examine the rally point red at'}},
        {id = 's2', at = {n = 2, fp = 'enter castle zvahl baileys s for'},
         done = {
            {t = 'zonein', zone = 138, event = 1, why = 'Castle Zvahl Baileys [S] zone-in cutscene 1 (Status 0, LandSandBoat)'},
         }},
        {id = 's3', at = {n = 3, fp = 'examine the peculiar glint at g'},
         done = {
            {t = 'event', zone = 138, event = 2, why = 'Peculiar Glint 2 (Status 1)'},
            {t = 'zonein', zone = 138, event = 14, why = 'Baileys [S] zone-in cutscene 14 (Status 2, after the Glint)'},
            {t = 'zonein', zone = 138, event = 15, why = 'Baileys [S] zone-in cutscene 15 (Status 3): the Distress signal flare'},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the peculiar glint again to'},
         done = {
            {t = 'mission', line = 'wotg', eq = 32, completed = true, why = "mission log: Into the Beast's Maw completed"},
            {t = 'zonein', zone = 138, event = 3, why = 'Baileys [S] zone-in cutscene 3 after the fight (Status 5): completes the mission'},
         }},
    },
}
