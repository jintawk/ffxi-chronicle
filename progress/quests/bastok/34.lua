-- Step progress for The Curse Collector (Bastok quest 34). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Curse_Collector.lua (Zon-Fobun 251 is a plain progress event that gives the
-- Cursepaper and begins the quest; the curses in Beadeaux only set server variable bits, with no event or key item, so bullets
-- 2 to 5 are notes; Zon-Fobun 252 plays only once both curses are taken (Prog 3), takes the Cursepaper and completes); client
-- event script S4 235_Zon_Fobun_010EB041.txt (251 say #7656, 252 say #7661); key item 139 from res/key_items.lua.
-- Disagreement with the draft: none of substance; it gains the two dialogue lines.
return {
    title = 'The Curse Collector',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with zon fobun to begin'},
         done = {
            {t = 'event', zone = 235, event = 251, why = 'Zon-Fobun 251: begins the quest'},
            {t = 'chat', re = "You! You're an adventurer, yes%-yes%?", why = 'Zon-Fobun 251 (say #7656)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 139, gained = true, why = 'cursepaper obtained'},
            {t = 'ki_have', id = 139, have = true, why = 'cursepaper held'},
            {t = 'chat', re = 'obtained key item: cursepaper', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'go to beadeaux and proceed to'}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'the first and easiest set of'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'from here head south and you'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'now head back east and then'}},
        {id = 's6', at = {n = 6, fp = 'return to zon fobun to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 139, gained = false, conf = 'inferred', why = 'cursepaper handed over'},
         },
         reach = {
            {t = 'event', zone = 235, event = 252, why = 'Zon-Fobun 252: plays only with both curses taken, completes'},
            {t = 'chat', re = 'Good! The cursepaper is full!', why = 'Zon-Fobun 252 (say #7661)'},
         }},
    },
}
