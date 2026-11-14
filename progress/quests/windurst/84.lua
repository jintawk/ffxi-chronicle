-- Step progress for Eco-Warrior (Windurst quest 84). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Eco_Warrior.lua (the draft read the Bastok script of the same name, which has
-- other NPCs and events): Lumomo 818 offers the quest and begins it on option 1 only, 820 is the reminder, 822 completes it and
-- takes the Indigested meat; Ahko Mhalijikhari 62 offers the ointment (the level restriction), qm2 pops the three Wyrmflys with
-- a zone text line and later gives key item 474. Client event scripts S4 238_Lumomo_010EE0E1.txt (818 accept say #10203,
-- decline #10205; 820 say #10206; 822 say #10207) and 198_Ahko_Mhalijikhari_010C6218.txt (62 accept say #7318, decline
-- #7316). Events 818, 62 and 822 play on a refusal (declined offer, quest:complete refused in onEventFinish), so each is a
-- reach and the accept lines, the key item and the quest log carry the steps. The level cap travel bullets (3) is a note on the ???
-- step. The quest log is set at s1, so it is not silent. Repeatable after the next conquest tally: 818 reopens it.
-- Chat "The ointment's odor draws out the monsters!" also plays in Eco-Warrior (Bastok), Gusgen Mines: shared, gated after s1.
return {
    title = 'Eco-Warrior (Windurst)',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to lumomo in the timbre'},
         done = {
            {t = 'chat', re = 'Excellentaru! Bring me back proof', why = 'Lumomo 818, accepted (say #10203)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 820, conf = 'inferred', why = 'Lumomo 820: the reminder, only once accepted'},
         },
         reach = {{t = 'event', zone = 238, event = 818, why = 'Lumomo 818 offered (also plays on a decline)'}}},
        {id = 's2', at = {n = 2, fp = 'travel to the maze of shakhrami'},
         done = {
            {t = 'chat', re = 'Rrright, here we go!', why = 'Ahko 62, ointment applied (say #7318)'},
         },
         reach = {{t = 'event', zone = 198, event = 62, why = 'Ahko 62 offered (also plays on a decline)'}}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to h 8 on map'}},
        {id = 's4', at = {n = 4, fp = 'travel to i 10 on map'},
         done = {
            {t = 'chat', re = "The ointment's odor draws out the monsters!", after = 's1', why = 'qm2: the Wyrmflys pop (Maze of Shakhrami IDs.lua OINTMENT_DRAWS_MONSTERS)'},
         }},
        {id = 's5', at = {n = 5, fp = 'after defeating all three examine the'},
         done = {
            {t = 'ki', id = 474, gained = true, why = 'indigested meat obtained'},
            {t = 'ki_have', id = 474, have = true, why = 'indigested meat held'},
            {t = 'chat', re = 'obtained key item: indigested meat', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'report to lumomo for your reward'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
            {t = 'ki', id = 474, gained = false, after = 's5', conf = 'inferred', why = 'indigested meat taken (only when the quest completes)'},
         },
         reach = {
            {t = 'event', zone = 238, event = 822, why = 'Lumomo 822: the turn-in (also plays when the reward cannot be given)'},
         }},
    },
}
