-- Step progress for Gourmet (Bastok quest 12). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Gourmet.lua (Salimah 200 has no option and its finish begins the quest; it also
-- plays on every later talk unless the player must zone, when 121 plays instead; 201, 202 and 203 each play on a trade of a
-- Sleepshroom, Treant Bulb or Wild Onion, the right item for the hour, 203 the wrong hour, and every one runs quest:complete,
-- so any of the three proves the trade); client event script S4 235_Salimah_010EB027.txt (200 say #7540, 203 say #7548; 201
-- and 202 are not in the decoded set). The draft ended the quest at the first bullet; the trade is the second. The indented hour-by-hour
-- item bullets are not steps; the farming bullet and the repeat bullet are notes on the trade. A repeat needs no new accept (the trade
-- alone, after zoning), so there is no `repeatable` entry (as in sandoria 5 and 15).
return {
    title = 'Gourmet',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to salimah to begin quest'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 235, event = 200, why = 'Salimah 200: begins the quest (and plays on every later talk)'},
            {t = 'chat', re = 'You look surprised%.', why = 'Salimah 200 (say #7540)'},
         }},
        {id = 's2', at = {n = 2, fp = 'obtain any of the following item'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 235, event = 201, why = 'Salimah 201: Sleepshroom or Treant Bulb at the right hour, runs quest:complete'},
            {t = 'event', zone = 235, event = 202, why = 'Salimah 202: Wild Onion at the right hour, runs quest:complete'},
            {t = 'event', zone = 235, event = 203, why = 'Salimah 203: any of the three at the wrong hour, runs quest:complete'},
            {t = 'chat', re = 'Here, let me pay you%.', why = 'Salimah 203 (say #7548)'},
         }},
        {id = 'n7', kind = 'note', with = 's2', at = {n = 7, fp = 'all 3 items may be farmed'}},
        {id = 'n8', kind = 'note', with = 's2', at = {n = 8, fp = 'important note this quest is repeatable'}},
    },
}
