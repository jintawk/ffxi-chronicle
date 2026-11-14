-- Step progress for Striking a Balance (Aht Urhgan quest 63). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Striking_a_Balance.lua (a Prog state machine; the quest log shows nothing until
-- Saliyahf 686 begins it, so the first bullet is silent until then: Wazyih 684 is his first talk and 685 the repeat; Saliyahf 686
-- begins it with no refusal; while accepted Saliyahf plays 687 at Prog 0-1, Wazyih 688 at Prog 0 (sets 1) and 689 at Prog 1, the
-- Whitegate trigger area 9 plays 690 at Prog 1 (sets 2), Wazyih 691 at Prog 2 (sets 3) and 694 at Prog 3, Saliyahf 692 or 693 at
-- Prog 2-3; the Al Zahbi ??? (it moves each time) gives Munahda's package (key item 805) and sets Prog 4, the Whitegate zone-in
-- plays 695 at Prog 4, takes the package and sets 5; at Prog 5 Wazyih plays 697 and Saliyahf plays 696, which runs quest:complete).
-- The search bullets 7-13 list where the ??? can stand: notes on the zone-in, with the package as its reach marker. 692 and 693
-- play from Prog 2, so they prove the Saliyahf bullet. The client scripts S4 050_Wazyih_01032104.txt and
-- 050_Saliyahf_01032103.txt have no text for these events. The reward is not used. Not repeatable.
return {
    title = 'Striking a Balance',
    completes = 's16',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to wazyih at f 11'},
         done = {
            {t = 'event', zone = 50, event = 684, why = 'Wazyih 684: his first talk while available'},
            {t = 'event', zone = 50, event = 685, why = 'Wazyih 685: his repeat talk while available'},
         }},
        {id = 's2', at = {n = 2, fp = 'talk to saliyahf at g 7'},
         done = {
            {t = 'event', zone = 50, event = 686, why = 'Saliyahf 686: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 50, event = 687, why = 'Saliyahf 687: only at Prog 0-1'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to wazyih'},
         done = {
            {t = 'event', zone = 50, event = 688, why = 'Wazyih 688: only at Prog 0, sets Prog 1'},
            {t = 'event', zone = 50, event = 689, why = 'Wazyih 689: only at Prog 1'},
         }},
        {id = 's4', at = {n = 4, fp = 'walk towards the crates at f'},
         done = {
            {t = 'event', zone = 50, event = 690, why = 'Whitegate trigger area 9: 690, only at Prog 1, sets Prog 2'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to saliyahf'},
         done = {
            {t = 'event', zone = 50, event = 692, why = 'Saliyahf 692: only at Prog 2-3'},
            {t = 'event', zone = 50, event = 693, why = 'Saliyahf 693: only at Prog 2-3, after 692'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to wazyih again'},
         done = {
            {t = 'event', zone = 50, event = 691, why = 'Wazyih 691: only at Prog 2, sets Prog 3'},
            {t = 'event', zone = 50, event = 694, why = 'Wazyih 694: only at Prog 3'},
         }},
        {id = 's7', kind = 'note', with = 's14', at = {n = 7, fp = 'g 7 in the water'}},
        {id = 's8', kind = 'note', with = 's14', at = {n = 8, fp = 'g 8 entrance to the south'}},
        {id = 's9', kind = 'note', with = 's14', at = {n = 9, fp = 'i 10 chocobo alley'}},
        {id = 's10', kind = 'note', with = 's14', at = {n = 10, fp = 'j 7 behind kahah hobichai'}},
        {id = 's11', kind = 'note', with = 's14', at = {n = 11, fp = 'i 5 flameserpent square'}},
        {id = 's12', kind = 'note', with = 's14', at = {n = 12, fp = 'h 9 tunnel to chocobo alley'}},
        {id = 's13', kind = 'note', with = 's14', at = {n = 13, fp = 'j 9 galeserpent square'}},
        {id = 's14', at = {n = 14, fp = 'zone back in to aht urhgan'},
         done = {
            {t = 'zonein', zone = 50, event = 695, why = 'Whitegate zone-in cutscene 695: only at Prog 4, takes the package'},
            {t = 'ki', id = 805, gained = false, conf = 'inferred', why = "Munahda's package handed over"},
         },
         reach = {{t = 'ki', id = 805, gained = true, why = "Munahda's package found"}}},
        {id = 's15', at = {n = 15, fp = 'return to wazyih at f 11'},
         done = {
            {t = 'event', zone = 50, event = 697, why = 'Wazyih 697: only at Prog 5'},
         }},
        {id = 's16', at = {n = 16, fp = 'finally speak to saliyahf at g'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 50, event = 696, why = 'Saliyahf 696: only at Prog 5, runs quest:complete'},
         }},
    },
}
