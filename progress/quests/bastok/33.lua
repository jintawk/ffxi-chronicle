-- Step progress for Beadeaux Smog (Bastok quest 33). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Evidence: LandSandBoat scripts/quests/bastok/Beadeaux_Smog.lua (High Bear 731 is a plain progress event that begins the quest
-- with no option test; the Beadeaux ??? gives the corrupted dirt key item; High Bear 732 is the hand-in and runs quest:complete,
-- so it proves the last step); client event script S4 237_High_Bear_010ED03E.txt (731 say
-- #7999, 732 say #8003); key item 140 from res/key_items.lua, item 17284 from res/items.lua.
-- Shared-signal audit: item 17284 (Chakram) is sold in guild shops and Rabao and drops from caskets -> dropped; the completed bit
-- still carries s8.
return {
    title = 'Beadeaux Smog',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to high bear to begin'},
         done = {
            {t = 'event', zone = 237, event = 731, why = 'High Bear 731: begins the quest'},
            {t = 'chat', re = "I am compiling data on the effects of Bastok's mining and industrial projects on the environment%.", why = 'High Bear 731 (say #7999)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'travel to beadeaux'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'upon entry proceed straight in then'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'from here head south and you'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'from here go west and south'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'follow the surface path along south'}},
        {id = 's7', at = {n = 7, fp = 'when the weather is raining a'},
         done = {
            {t = 'ki', id = 140, gained = true, why = 'corrupted dirt obtained'},
            {t = 'ki_have', id = 140, have = true, why = 'corrupted dirt held'},
            {t = 'chat', re = 'obtained key item: corrupted dirt', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to high bear and speak'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 237, event = 732, why = 'High Bear 732: the corrupted dirt handed in, completes'},
            {t = 'chat', re = "Ah, you've brought me some of the", why = 'High Bear 732 (say #8003)'},
         }},
    },
}
