-- Step progress for The Wayward Automaton (Aht Urhgan quest 27). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Aht_Urhgan_Whitegate/npcs/Iruki-Waraki.lua, zones/Nashmau/npcs/Dnegan.lua and
-- zones/Caedarva_Mire/npcs/qm9.lua (an old-style script, no quest file): Iruki-Waraki 774 is the offer, no option, and begins the
-- quest; his 775 is the reminder at Prog 1; Dnegan 289 plays at Prog 1 and again at Prog 2 as a hint and sets Prog 2; the Caedarva
-- Mire ??? prints HIDEOUS_BEAST_EMERGES and raises the Caedarva Toad (Mire text 7601), and once the toad is dead plays 14 and sets
-- Prog 3; Iruki-Waraki 776 at Prog 3 runs completeQuest with the Turbo Animator as reward, so a full bag replays 776 and only the
-- completed bit proves the last bullet. Events 14 (Mire), 289 (Nashmau) and 774 to 776 (Whitegate) are used by no other script.
-- Bullet 2 is the backstory of the offer, a note. Not repeatable. Client event script S4 050_Iruki_Waraki_01032135.txt (774 to 776
-- have no text); 053_Dnegan_0103506C.txt (289 is bare).
return {
    title = 'The Wayward Automaton',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with iruki waraki at k'},
         done = {
            {t = 'event', zone = 50, event = 774, why = 'Iruki-Waraki 774: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'you can tell the automaton belongs'}},
        {id = 's3', at = {n = 3, fp = 'once in nashmau proceed to h'},
         done = {
            {t = 'event', zone = 53, event = 289, why = 'Dnegan 289: plays only at Prog 1 and 2, sets Prog 2'},
         },
         reach = {{t = 'event', zone = 50, event = 775, why = 'Iruki-Waraki 775: his reminder at Prog 1 to head to Nashmau'}}},
        {id = 's4', at = {n = 4, fp = 'exit nashmau by the east gate'},
         done = {
            {t = 'event', zone = 79, event = 14, why = 'the ??? 14 in Caedarva Mire: plays only at Prog 2 once the Caedarva Toad is dead, sets Prog 3'},
         },
         reach = {{t = 'chat', re = 'A hideous beast emerges from the depths of the swamp', why = 'Caedarva Mire HIDEOUS_BEAST_EMERGES: the toad raised'}}},
        {id = 's5', at = {n = 5, fp = 'go back to iruki waraki in'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 50, event = 776, why = 'Iruki-Waraki 776: plays only at Prog 3, runs completeQuest (replays if the Turbo Animator cannot be given)'}}},
    },
}
