-- Step progress for Promotion: Chief Sergeant (Aht Urhgan quest 96). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Chief_Sergeant.lua, client event scripts S4
-- 050_Abquhbah_0103208D.txt and 050_Hagakoff_01032050.txt (none of these events has text). Server stage by stage: Abquhbah
-- 5060 offers and begins the quest with no choice; Prog 0: Abquhbah 5062 is his reminder, Hagakoff 5067 sets Prog 1; Prog 1:
-- Abquhbah 5068 sets Prog 2; Prog 2: Abquhbah 5069 is his reminder, Hagakoff 5063 sets Prog 3; Prog 3: the Aydeewa Subterrane
-- mushroom patches (events 14-21, which are numbers other quests also use in that zone, so none is used) hand out and take the
-- Scourshroom key item (876, unique to this quest), Abquhbah 5061 plays the cleaning (an option under 11 cleans, 20 and up
-- completes, so it replays through the cleaning rounds and is only a reach) and quest:complete prints "has been promoted to
-- Chief Sergeant", line 12374 of Aht_Urhgan_Whitegate/IDs.lua. The bullet after Hagakoff's second talk ("Talk to Abquhbah
-- again") has no event of its own, and the pond, planting, wait, harvest and cleaning bullets leave no signal that is not
-- shared or option-dependent: notes on the step they lead into. Not repeatable.
return {
    title = 'Promotion: Chief Sergeant',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to abquhbah to initiate the'},
         done = {
            {t = 'event', zone = 50, event = 5060, why = 'Abquhbah 5060: begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 5062, why = 'Abquhbah 5062: his reminder while accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'he will redirect you to hagakoff'},
         done = {
            {t = 'event', zone = 50, event = 5067, why = 'Hagakoff 5067: sets Prog 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to abquhbah again'},
         done = {
            {t = 'event', zone = 50, event = 5068, why = 'Abquhbah 5068: sets Prog 2'},
            {t = 'event', zone = 50, event = 5069, why = 'Abquhbah 5069: his reminder once Prog 2'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to hagakoff again'},
         done = {
            {t = 'event', zone = 50, event = 5063, why = 'Hagakoff 5063: sets Prog 3'},
         }},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'talk to abquhbah again'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'enter aydeewa subterrane from wajaom woodlands'}},
        {id = 's7', at = {n = 7, fp = 'head to the room at i'},
         done = {
            {t = 'ki', id = 876, gained = true, why = 'Scourshroom obtained'},
            {t = 'ki_have', id = 876, have = true, why = 'Scourshroom held'},
            {t = 'chat', re = 'obtained key item: scourshroom', why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'note', with = 's12', at = {n = 8, fp = 'repeat the same process but at'}},
        {id = 's9', kind = 'note', with = 's12', at = {n = 9, fp = 'zone and wait for the game'}},
        {id = 's10', kind = 'note', with = 's12', at = {n = 10, fp = 'return to both patches of mushrooms'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'return to abquhbah to help clean'}},
        {id = 's12', at = {n = 12, fp = 'after cleaning the weapon twice you'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'has been promoted to chief sergeant', why = 'promotion message (IDs.lua 12374)'},
         },
         reach = {{t = 'event', zone = 50, event = 5061, why = 'Abquhbah 5061: the cleaning (replays until the quest is completed)'}}},
    },
}
