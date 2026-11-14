-- Step progress for Under Oath (San d'Oria quest 92). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Chateau_dOraguille/npcs/_6h0.lua (90 option 1 begins the quest, UnderOathCS 0; 89 at
-- UnderOathCS 8 gives the Gallant Surcoat and completes it, but plays with a full bag too, so it only reaches the step) and the
-- chain by UnderOathCS: Southern_San_dOria/npcs/Vemalpeau.lua (7 at 0; 5 at 3 with key item 219, takes it), Najjar.lua (16 at 1),
-- Ullasa.lua (40 at 2), Castle_Zvahl_Baileys/npcs/Treasure_Coffer.lua (key item 219 at 3), qm3.lua (41 option 1 gives key item
-- 220 at 4), Exoroche.lua (77 at 4 with 220), Davoi/npcs/Village_Well.lua (trade the Well Weight, 113 at 5: gives key item 221,
-- takes 220), Northern_San_dOria/npcs/Ailbeche.lua (59 at 6 with 221), Jugner_Forest/Zone.lua (trigger area, 14 at 7). Client
-- event scripts S4 230_Vemalpeau_010E60D1.txt (7 say #9155, 5 say #9166); the other events are not in the decoded scripts, so
-- they rest on the event id and zone. Key item ids from res/key_items.lua (219 Mique's paintbrush, 220 strange sheet of paper,
-- 221 knight's confession); item 12644 from res/items.lua. The draft's key item 2885 matched the wrong name; the draft put
-- Vemalpeau 5, 3 and 2 on bullet 3 and the completed bit on the Well trade, all wrong. Bullets 10 and 11 (go to Davoi, examine
-- the Well to spawn two NMs) leave no signal and are notes on the Well trade. The quest log is set at s1, so it is not silent.
return {
    title = 'Under Oath',
    completes = 's15',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the door to prince trion'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Trion 90 option 1)'},
         },
         reach = {{t = 'event', zone = 233, event = 90, why = "Trion's door 90 offered (its finish needs option 1)"}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'the rest of this quest can'}},
        {id = 's3', at = {n = 3, fp = 'speak to vemalpeau southern san d'},
         done = {
            {t = 'event', zone = 230, event = 7, why = 'Vemalpeau 7: the boy is missing'},
            {t = 'chat', re = 'What are you here for%? You ask about my son%?', why = 'Vemalpeau 7 (say #9155)'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to najjar southern san d'},
         done = {
            {t = 'event', zone = 230, event = 16, why = 'Najjar 16: only at UnderOathCS 1'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to ullasa southern san d'},
         done = {
            {t = 'event', zone = 230, event = 40, why = 'Ullasa 40: only at UnderOathCS 2'},
         }},
        {id = 's6', at = {n = 6, fp = 'obtain a zvahl coffer key and'},
         done = {
            {t = 'ki', id = 219, gained = true, why = "Mique's paintbrush obtained"},
            {t = 'ki_have', id = 219, have = true, why = "Mique's paintbrush held"},
            {t = 'chat', re = "obtained key item: mique's paintbrush", why = 'chat: key item obtained'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to vemalpeau'},
         done = {
            {t = 'event', zone = 230, event = 5, why = 'Vemalpeau 5: only at UnderOathCS 3 with the paintbrush'},
            {t = 'chat', re = 'Why, you would offer this to me!%?', why = 'Vemalpeau 5 (say #9166)'},
            {t = 'ki', id = 219, gained = false, conf = 'inferred', why = "Mique's paintbrush handed over"},
         }},
        {id = 's8', at = {n = 8, fp = 'head to the second story in'},
         done = {
            {t = 'ki', id = 220, gained = true, why = 'strange sheet of paper obtained'},
            {t = 'ki_have', id = 220, have = true, why = 'strange sheet of paper held'},
            {t = 'chat', re = 'obtained key item: strange sheet of paper', why = 'chat: key item obtained'},
            {t = 'event', zone = 230, event = 3, conf = 'inferred', why = 'Vemalpeau 3: only at UnderOathCS 4 with the paper'},
            {t = 'chat', re = 'Come to think of it, often he would read a letter from his commanding officer%.', conf = 'inferred', why = 'Vemalpeau 3 (say #9170)'},
         },
         reach = {{t = 'event', zone = 230, event = 41, why = 'painting 41 examined (key item only with option 1)'}}},
        {id = 's9', at = {n = 9, fp = 'speak to exoroche k 7 in'},
         done = {
            {t = 'event', zone = 230, event = 77, why = 'Exoroche 77: only at UnderOathCS 4 with the paper'},
         }},
        {id = 's10', kind = 'note', with = 's12', at = {n = 10, fp = 'head to davoi and locate the'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'examine the village well will spawn'}},
        {id = 's12', at = {n = 12, fp = 'trade the well weight to the'},
         done = {
            {t = 'event', zone = 149, event = 113, why = 'Village Well 113: the Well Weight accepted'},
            {t = 'ki', id = 221, gained = true, why = "knight's confession obtained"},
            {t = 'ki_have', id = 221, have = true, why = "knight's confession held"},
            {t = 'chat', re = "obtained key item: knight's confession", why = 'chat: key item obtained'},
            {t = 'ki', id = 220, gained = false, conf = 'inferred', why = 'strange sheet of paper handed over'},
         }},
        {id = 's13', at = {n = 13, fp = 'speak to ailbeche northern san d'},
         done = {
            {t = 'event', zone = 231, event = 59, why = 'Ailbeche 59: only at UnderOathCS 6 with the confession'},
         }},
        {id = 's14', at = {n = 14, fp = 'travel to jugner forest and head'},
         done = {
            {t = 'event', zone = 104, event = 14, why = 'Jugner Forest trigger area 14: only at UnderOathCS 7'},
         }},
        {id = 's15', at = {n = 15, fp = 'head back to chateau d oraguille'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 12644, gained = true, conf = 'inferred', why = 'Gallant Surcoat gained (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 233, event = 89, why = "Trion's door 89 (also plays with a full bag, so it proves nothing)"}}},
        {id = 's16', kind = 'optional', at = {n = 16, fp = 'you may additionally talk to ailbeche'}, done = {}},
    },
}
