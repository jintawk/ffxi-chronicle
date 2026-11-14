-- Step progress for Monstrosity (Other Areas quest 34). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Monstrosity.lua (the Suspicious Hume's event 40 begins the quest; a valid trade to
-- a city Suspicious NPC plays an event computed as base + 1 (883 San d'Oria, 419 Bastok, 881 Windurst, from
-- scripts/globals/monstrosity/constants.lua), which appears as no literal in LandSandBoat or the client scripts, so it is not a
-- matcher: the Ring of supernal disjunction (KI 2350) that its finish gives proves the trade bullet instead; the Feretory zone-in
-- event 2 completes the quest); client event script S4 109_Suspicious_Hume_0106D2BA.txt (40 say #12762; the Hume's 41 is not
-- in the scripts, only in the file header).
-- The draft put completion on the trade bullet; the quest completes at the Feretory zone-in, bullet 5. Bullet 6 (the Gladiatorial
-- writ, Temporary KI 2351) is only open after completion.
return {
    title = 'Monstrosity (Quest)',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to the suspicious hume in'},
         done = {
            {t = 'event', zone = 109, event = 40, why = 'Suspicious Hume 40: begins the quest'},
            {t = 'chat', re = 'Eke, thy training hath not been in vain%.', why = 'Suspicious Hume 40 (say #12762)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'he will ask you to acquire'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'procure one of the items and'}},
        {id = 's4', at = {n = 4, fp = 'after a brief cutscene you are'},
         done = {
            {t = 'ki', id = 2350, gained = true, why = 'Ring of supernal disjunction obtained'},
            {t = 'ki_have', id = 2350, have = true, why = 'Ring of supernal disjunction held'},
            {t = 'chat', re = 'obtained key item: ring of supernal disjunction', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'examine the odyssean passage and enter'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'zonein', zone = 285, event = 2, after = 's4', why = 'Feretory zone-in 2: its finish completes the quest'},
         }},
        {id = 's6', kind = 'post', at = {n = 6, fp = 'to obtain gladiatorial writ of summons'},
         done = {
            {t = 'ki', id = 2351, gained = true, after = 's5', why = 'Gladiatorial writ of summons obtained'},
            {t = 'chat', re = 'obtained key item: gladiatorial writ of summons', after = 's5', why = 'chat: key item obtained'},
         }},
    },
}
