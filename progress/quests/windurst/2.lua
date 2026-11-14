-- Step progress for A Crisis in the Making (Windurst quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Waters/npcs/Ranpi-Monpi.lua (258 is the offer menu and can be declined, so
-- it only proves the offer, as does 259 on a repeat; option 1 adds the quest; 262 is the reminder while the offering is
-- still to fetch, so it follows the accept; 267 finishes the quest with no refusal path and 268 is the same finish on a
-- repeat) and zones/Giddeus/npcs/Altar_of_Offerings.lua (53 is a retrieve-or-leave menu, option 1 gives the Off offering);
-- client event scripts S4 238_Ranpi_Monpi_010EE04A.txt (258 menu #7908, 262 say #7920, 267 say #7931/#7932) and
-- 145_Altar_of_Offerings_010911CB.txt (53 menu #7345); key item id from res/key_items.lua (39 off offering).
-- Repeatable (page meta): the repeat is a new offer at Ranpi-Monpi, and the reminder 262 opens the next run, so the quest-log
-- matchers count for the first run only (run1). The travel bullets (2 to 4) are notes on the altar. The quest log is set
-- at s1, so it is not silent.
return {
    title = 'A Crisis in the Making',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to ranpi monpi at the'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 238, event = 262, conf = 'inferred', why = 'Ranpi-Monpi 262: reminder, only once accepted'},
         },
         reach = {
            {t = 'event', zone = 238, event = 258, why = 'Ranpi-Monpi 258 offered (its finish needs option 1)'},
            {t = 'event', zone = 238, event = 259, why = 'Ranpi-Monpi 259: repeat offered (its finish needs option 1)'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'go to giddeus via west sarutabaruta'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'enter the caves via f 8'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head to the lower level of'}},
        {id = 's5', at = {n = 5, fp = 'click on the altar to retrieve'},
         done = {
            {t = 'ki', id = 39, gained = true, why = 'off offering obtained'},
            {t = 'ki_have', id = 39, have = true, why = 'off offering held'},
            {t = 'chat', re = 'obtained key item: off offering', why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 145, event = 53, why = 'Altar of Offerings 53 offered (its finish needs option 1)'}}},
        {id = 's6', at = {n = 6, fp = 'return the key item to ranpi'},
         done = {
            {t = 'event', zone = 238, event = 267, why = 'Ranpi-Monpi 267: the offering handed over'},
            {t = 'event', zone = 238, event = 268, why = 'Ranpi-Monpi 268: the same finish on a repeat'},
            {t = 'chat', re = 'You saved my life!', why = 'Ranpi-Monpi 267 (say #7931)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 39, gained = false, conf = 'inferred', why = 'off offering handed over'},
         }},
    },
}
