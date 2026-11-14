-- Step progress for Against All Odds (Aht Urhgan quest 26). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/COR_AF3_Against_All_Odds.lua (the Whitegate trigger area plays 797 while available
-- and begins the quest, handing over the Life float (key item 848); the Cutter's area in Arrapago Reef plays 237 at Prog 0 and
-- then 240 and sets Prog 1; the fight is the instance zones/The_Ashu_Talif/instances/against_all_odds.lua, which takes the Life
-- float on entry (FADES_INTO_NOTHINGNESS, zone text 7431 "The <item> fades into nothingness...") and sets Prog 2 on a win; the
-- Cutter 238, or the 238 zone-in from the Ashu Talif, runs quest:complete at Prog 2, whose reward is Corsair's Tricorne, so a full
-- bag replays 238 and only the completed bit proves bullet 5; Ratihb 798 re-issues the float after a loss and is not a step).
-- Bullets 6 to 8 are the Crafted Corsair Artifact hidden quest (scripts/quests/hiddenQuests/Crafted_Corsair_Artifact.lua): Leleroon
-- hands out one letter per piece (key items 845 green, 846 blue, 847 red in res/key_items.lua) after the quest, in any order, so each is
-- an optional step marked by its key item. Travel bullet 2 is a note on the Cutter. Not repeatable. No client event script covers
-- these events.
return {
    title = 'Against All Odds',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'while on corsair head to the'},
         done = {
            {t = 'event', zone = 50, event = 797, why = 'Whitegate trigger area 797: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 848, gained = true, why = 'life float obtained'},
            {t = 'chat', re = 'obtained key item: life float', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'head to the the ashu talif'}},
        {id = 's3', at = {n = 3, fp = 'approach the cutter for a cutscene'},
         done = {
            {t = 'event', zone = 54, event = 237, why = 'Arrapago Reef trigger area 237: plays only at Prog 0'},
            {t = 'event', zone = 54, event = 240, why = 'Arrapago Reef 240: follows 237, sets Prog 1'},
         }},
        {id = 's4', at = {n = 4, fp = 'examine the cutter to enter a'},
         done = {
            {t = 'ki', id = 848, gained = false, why = 'life float taken on entry to the battlefield'},
            {t = 'chat', re = 'life float fades into nothingness', why = 'The Ashu Talif FADES_INTO_NOTHINGNESS: the instance entered'},
         }},
        {id = 's5', at = {n = 5, fp = 'you will receive your reward immediately'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 54, event = 238, why = "the Cutter 238: plays only at Prog 2, runs quest:complete (replays if Corsair's Tricorne cannot be given)"},
            {t = 'zonein', zone = 54, event = 238, why = 'Arrapago Reef zone-in 238 from The Ashu Talif at Prog 2'},
         }},
        {id = 's6', kind = 'optional', at = {n = 6, fp = 'leleroon s letter green hands'},
         done = {
            {t = 'ki', id = 845, gained = true, why = "Leleroon's letter (green) obtained"},
            {t = 'ki_have', id = 845, have = true, why = "Leleroon's letter (green) held"},
            {t = 'chat', re = "obtained key item: leleroon's letter %(green%)", why = 'chat: key item obtained'},
         }},
        {id = 's7', kind = 'optional', at = {n = 7, fp = 'leleroon s letter blue feet'},
         done = {
            {t = 'ki', id = 846, gained = true, why = "Leleroon's letter (blue) obtained"},
            {t = 'ki_have', id = 846, have = true, why = "Leleroon's letter (blue) held"},
            {t = 'chat', re = "obtained key item: leleroon's letter %(blue%)", why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'optional', at = {n = 8, fp = 'leleroon s letter red body'},
         done = {
            {t = 'ki', id = 847, gained = true, why = "Leleroon's letter (red) obtained"},
            {t = 'ki_have', id = 847, have = true, why = "Leleroon's letter (red) held"},
            {t = 'chat', re = "obtained key item: leleroon's letter %(red%)", why = 'chat: key item obtained'},
         }},
    },
}
