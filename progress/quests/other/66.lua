-- Step progress for A Bitter Past (Other Areas quest 66). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/A_Bitter_Past.lua (Frescheque 151 begins the quest; Raminey 152 plays at
-- Prog 0 and Equette 153 at Prog 1; the Lufaise Meadows ??? spawns the two orc NMs, and once both are dead a second touch gives
-- the Tiny wristlet, Temporary KI 602; Frescheque 154 plays only while the wristlet is held, takes it and completes the quest;
-- Equette 155 is a one-off cutscene after completion). The ??? pop line (Lufaise Meadows SENSE_OF_FOREBODING) is shared with
-- other quests, so bullet 4 stays a note. Client event scripts S4 026_Frescheque, 026_Raminey and 026_Equette are bare for
-- these events.
return {
    title = 'A Bitter Past',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to frescheque h 8 3rd'},
         done = {
            {t = 'event', zone = 26, event = 151, why = 'Frescheque 151: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to raminey j 7 3rd'},
         done = {
            {t = 'event', zone = 26, event = 152, why = 'Raminey 152 (Prog 0)'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to equette i 9 2nd'},
         done = {
            {t = 'event', zone = 26, event = 153, why = 'Equette 153 (Prog 1)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'go to lufaise meadows and click'}},
        {id = 's5', at = {n = 5, fp = 'defeat the nms and select again'},
         done = {
            {t = 'ki', id = 602, gained = true, why = 'Tiny wristlet obtained'},
            {t = 'ki_have', id = 602, have = true, why = 'Tiny wristlet held'},
            {t = 'chat', re = 'obtained key item: tiny wristlet', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to the tavnazian safehold and'},
         done = {
            {t = 'event', zone = 26, event = 154, why = 'Frescheque 154: the wristlet handed over, completes the quest'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 602, gained = false, conf = 'inferred', why = 'Tiny wristlet handed over'},
         }},
        {id = 's7', kind = 'post', at = {n = 7, fp = 'talk to equette again for an'},
         done = {
            {t = 'event', zone = 26, event = 155, after = 's6', why = 'Equette 155: the after-quest cutscene'},
         }},
    },
}
