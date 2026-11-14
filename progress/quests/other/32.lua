-- Step progress for Waking the Beast (other areas quest 32). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Waking_the_Beast.lua (the ??? qm3 in La Theine Plateau plays 207 and, on
-- finish with no menu, gives the Rainbow Resonator (key item 363) and begins the quest the first time; the six Cloister
-- battles give the six Eye key items, which have no bullet of their own to prove; the Full Moon Fountain win gives the Faded
-- Ruby (key item 364) and takes the resonator and the eyes; qm3 with the ruby plays 208, which runs quest:complete, takes
-- the ruby and sets the title). The client has no script for the ???, so no chat lines beyond the key item lines. The six
-- fights, the fight rules and the strategy bullets are notes on the step they lead into. Repeatable weekly: the log marks the
-- first run only (run1), as for Bastok quest 0.
return {
    title = 'Waking the Beast',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to carbuncle at the g'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (qm3 207; first run only)'},
            {t = 'event', zone = 102, event = 207, why = 'qm3 207: the offer, gives the resonator and begins the quest on finish'},
            {t = 'ki', id = 363, gained = true, why = 'rainbow resonator obtained'},
            {t = 'chat', re = 'obtained key item: rainbow resonator', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you must collect six key items'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'each battle takes place at the'}},
        {id = 's4', at = {n = 4, fp = 'once you have obtained all six'},
         done = {
            {t = 'ki', id = 364, gained = true, why = 'faded ruby obtained (Full Moon Fountain won)'},
            {t = 'chat', re = 'obtained key item: faded ruby', why = 'chat: key item obtained'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'the six key items are not'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'during the cutscene you are given'}},
        {id = 's7', at = {n = 7, fp = 'return to the g 6 in'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'event', zone = 102, event = 208, why = 'qm3 208: the ruby accepted, runs quest:complete'},
         }},
        {id = 's8', kind = 'note', with = 's7', at = {n = 8, fp = 'every player who participates in the'}},
        {id = 's9', kind = 'note', with = 's7', at = {n = 9, fp = 'all other quest rewards are randomly'}},
        {id = 's10', kind = 'note', with = 's7', at = {n = 10, fp = 'you must wait until the conquest'}},
        {id = 's11', kind = 'note', with = 's7', at = {n = 11, fp = '1 defeat the carbuncles and celestial'}},
        {id = 's12', kind = 'note', with = 's7', at = {n = 12, fp = '2 defeat two of the three'}},
        {id = 's13', kind = 'note', with = 's7', at = {n = 13, fp = '3 bring the last celestial avatar'}},
        {id = 's14', kind = 'note', with = 's7', at = {n = 14, fp = '4 at this point one summoner'}},
        {id = 's15', kind = 'note', with = 's7', at = {n = 15, fp = '5 after alexander is finished quickly'}},
        {id = 's16', kind = 'note', with = 's7', at = {n = 16, fp = '6 when the 5 carbuncle primes'}},
        {id = 's17', kind = 'note', with = 's7', at = {n = 17, fp = '7 this leaves 3 carbuncle primes'}},
    },
}
