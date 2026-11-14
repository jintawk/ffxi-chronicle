-- Step progress for Say It with Flowers (Windurst quest 50). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Say_It_With_Flowers.lua (Moari-Kaaori 514 offers the quest and begin needs
-- option 1; 515 is his talk while Prog is 1; Ohbiru-Dohbiru 516 is the quiz menu (option 7 = the right answers, 0 to 5 = buy a
-- wrong flower), 517 plays only once the right answers are given (Option 1), 518 only after a wrong flower was bought (must
-- zone); Kenapa-Keppa 519 plays only with Option 1; the Tahrongi cacti give the cactus; the trade is 520 (the Iron Sword
-- reward: the finish completes only if the sword can be given, so it is a refusal-played event and only `reach`), 525 (cactus
-- repeat, 400 gil) or 522 (another flower, 100 gil), the last two run quest:complete). After a completion Moari-Kaaori 523 or
-- 685 (a talk after zoning) sets Prog back to 1: a repeat run, so they sit on s1 as its restart signal (no client event
-- scripts exist for zone 238's NPCs, so there are no chat lines). The quest log is set at s1, so it is not silent; its
-- accepted and completed bits count for the first run only. The cactus bullet is a branch (only the right answers lead to it).
-- Item 950 (Tahrongi Cactus) is wanted by A Lady's Heart, Pretty Little Things, Growing Flowers and Flower Child: shared, gated after s1.
-- Item 16536 (Iron Sword) is sold by shops (Zhikkom, Sugandhi, Ashene): shared, gated after s2.
return {
    title = 'Say It with Flowers',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to moari kaaori in windurst'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 238, event = 515, conf = 'inferred', why = 'Moari-Kaaori 515: only while the quest runs'},
            {t = 'event', zone = 238, event = 523, why = 'Moari-Kaaori 523: a new run after a flower trade'},
            {t = 'event', zone = 238, event = 685, why = 'Moari-Kaaori 685: a new run after a cactus trade'},
         },
         reach = {{t = 'event', zone = 238, event = 514, why = 'Moari-Kaaori 514 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to ohbiru dohbiru j 9'},
         done = {
            {t = 'event', zone = 238, event = 517, why = 'Ohbiru-Dohbiru 517: plays only once the right answers were given'},
            {t = 'event', zone = 238, event = 518, why = 'Ohbiru-Dohbiru 518: plays only after a wrong flower was bought'},
            {t = 'event', zone = 238, event = 519, conf = 'inferred', why = 'Kenapa-Keppa 519: plays only once the right answers were given'},
         },
         reach = {{t = 'event', zone = 238, event = 516, why = 'Ohbiru-Dohbiru 516: the quiz offered (its finish needs option 7 for the cactus)'}}},
        {id = 's3', kind = 'branch', at = {n = 3, fp = 'head to tahrongi canyon f 6'},
         done = {
            {t = 'item', id = 950, gained = true, after = 's1', conf = 'inferred', why = 'Tahrongi Cactus gained'},
         }},
        {id = 's4', at = {n = 4, fp = 'give the flower to moari kaaori'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'event', zone = 238, event = 525, why = 'Moari-Kaaori 525: the cactus traded again'},
            {t = 'event', zone = 238, event = 522, why = 'Moari-Kaaori 522: another flower traded'},
            {t = 'item', id = 16536, gained = true, after = 's2', conf = 'inferred', why = 'Iron Sword gained (reward) (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 238, event = 520, why = 'Moari-Kaaori 520: the cactus traded (also plays with a full bag)'}}},
    },
}
