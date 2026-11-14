-- Step progress for Dark Legacy (Bastok quest 57). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/DRK_AF1_Dark_Legacy.lua (Raibaht 751 begins the quest at its finish; Mighty Fist
-- 752 at Prog 0 gives the Letter 234; Cochal-Monchal 697 at Prog 1 takes it, 698 and 699 are later echo talks; the Giddeus qm1
-- cherry trade plays SENSE_OF_FOREBODING when Vaa Huja spawns and its trigger gives the Darksteel Formula 235; Mighty Fist 754
-- is the extra talk while the Formula is held; Raibaht 755 completes and takes it); zones/Giddeus/IDs.lua; client event scripts
-- S4 237_Raibaht_010ED02C.txt (751 say #8566, 755 is bare), 237_Mighty_Fist_010ED03A.txt (752 say #8572, 754 say #8578),
-- 238 Cochal-Monchal (697 to 699 are not decoded there); key items from res/key_items.lua. The draft put Mighty Fist 754 on
-- bullet 2; it is the optional return of bullet 7. Quu Bokye 61 and 62 (the cherry as a bribe) are not on the page. Repeatable:
-- the restart is the next 751.
-- Shared-signal audit: the pop message "sense of foreboding" is played by many quests and missions (Borghertz quests, Talekeeper's Truth and others): gated after s1.
return {
    title = 'Dark Legacy',
    completes = 's8',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with cid s assistant raibaht'},
         done = {
            {t = 'event', zone = 237, event = 751, why = 'Raibaht 751: the quest offered and begun at its finish'},
            {t = 'chat', re = "You're a dark knight, I see%.", why = 'Raibaht 751 (say #8566)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with mighty fist in metalworks'},
         done = {
            {t = 'event', zone = 237, event = 752, why = 'Mighty Fist 752: plays at Prog 0 and gives the letter'},
            {t = 'chat', re = "I see he's finally come to his senses%.", why = 'Mighty Fist 752 (say #8572)'},
            {t = 'ki', id = 234, gained = true, why = 'letter from the Darksteel Forge obtained'},
            {t = 'ki_have', id = 234, have = true, why = 'letter from the Darksteel Forge held'},
            {t = 'chat', re = 'obtained key item: letter from the darksteel forge', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to windurst waters and speak'},
         done = {
            {t = 'event', zone = 238, event = 697, why = 'Cochal-Monchal 697: plays at Prog 1 and takes the letter'},
            {t = 'ki', id = 234, gained = false, conf = 'inferred', why = 'letter from the Darksteel Forge handed over'},
            {t = 'event', zone = 238, event = 698, conf = 'inferred', why = 'Cochal-Monchal 698: the echo talk, only after 697'},
            {t = 'event', zone = 238, event = 699, conf = 'inferred', why = 'Cochal-Monchal 699: the echo talk once the Formula is held'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'obtain a yagudo cherry from either'}},
        {id = 's5', at = {n = 5, fp = 'travel to giddeus and trade the'},
         done = {
            {t = 'chat', re = 'you are suddenly overcome with a sense of foreboding%.%.%.', after = 's1', why = 'Giddeus SENSE_OF_FOREBODING: Vaa Huja spawned'},
         }},
        {id = 's6', at = {n = 6, fp = 'defeat the nm and click on'},
         done = {
            {t = 'ki', id = 235, gained = true, why = '"Darksteel Formula" obtained'},
            {t = 'ki_have', id = 235, have = true, why = '"Darksteel Formula" held'},
            {t = 'chat', re = 'obtained key item: "darksteel formula"', why = 'chat: key item obtained'},
         }},
        {id = 's7', kind = 'optional', at = {n = 7, fp = 'optional return to metalworks and speak'},
         done = {
            {t = 'event', zone = 237, event = 754, why = 'Mighty Fist 754: plays only with the Formula held'},
            {t = 'chat', re = "Excellent! You've retrieved our copy of", why = 'Mighty Fist 754 (say #8578)'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to raibaht and speak with'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 235, gained = false, conf = 'inferred', why = '"Darksteel Formula" handed over'},
         },
         reach = {{t = 'event', zone = 237, event = 755, why = 'Raibaht 755: plays with the Formula held (a full bag plays it too, no completion)'}}},
    },
}
