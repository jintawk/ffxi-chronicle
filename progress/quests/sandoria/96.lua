-- Step progress for Knight Stalker (San d'Oria quest 96). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Chateau_dOraguille/npcs/Rahal.lua (121 or 120 option 1 begins the quest; 119 is his
-- reminder at KnightStalker_Progress 0; 78 at 1 with key item 298 sets 2; 69 is the reminder at 2; 110 at 3 sets 4),
-- Port_San_dOria/npcs/Ceraulian.lua (19 at 0 sets 1; 23 at 1 without the key item; 22 after completion),
-- Kuftal_Tunnel/npcs/Treasure_Coffer.lua (key item 298 from any coffer at 1), Southern_San_dOria/npcs/Balasiel.lua (63 at 2
-- sets 3), Temple_of_Uggalepih/npcs/qm15.lua (the first examine with the wyvern pops the two NMs; 67 after the kill completes
-- it and gives the Drachen Armet, but with a full bag the event still plays and nothing completes, so it only reaches the
-- step); client event scripts S4 233_Rahal_010E9008.txt (119 say #6896, 78 say #6897, 69 say #6899, 110 say #6900, 118 say
-- #6902), 232_Ceraulian_010E8048.txt (23 say #8440); 121, 120, 19, 63, 67 and 22 are not decoded and rest on the event id and
-- zone. Key item 298 and item 12519 from res/key_items.lua and res/items.lua. Repeatable after a memory reset (page meta): the
-- log bits count for the first run only. Bullets 8-10 (the Temple, the ???, the examine that pops the NMs) lead into the
-- second examine (n=11); the pop line "Your wyvern reacts violently to this spot!" has no name in Temple of Uggalepih's IDs.lua,
-- so it is not used. Bullets 12-13 are the optional scenes after completion (Ceraulian 22 and Rahal 118 play only then).
-- The quest log is set at s1, so it is not silent.
-- Shared-signal audit: the Rahal 78 line is tightened from 'This handwriting' (also in Apururu's Windurst talk) to "That's what this is all about".
return {
    title = 'Knight Stalker',
    completes = 's11',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to rahal in chateau d'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 233, event = 119, conf = 'inferred', why = 'Rahal 119: reminder, only while accepted at Progress 0'},
            {t = 'chat', re = 'The people at the Brugaire Consortium may have information', conf = 'inferred', why = 'Rahal 119 (say #6896)'},
         },
         reach = {{t = 'event', zone = 233, event = 121, why = 'Rahal 121 offered (its finish needs option 1)'},
                  {t = 'event', zone = 233, event = 120, why = 'Rahal 120 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'speak to ceraulian port san d'},
         done = {
            {t = 'event', zone = 232, event = 19, why = 'Ceraulian 19: only at Progress 0, sets 1'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to ceraulian once more after'},
         done = {
            {t = 'event', zone = 232, event = 23, why = 'Ceraulian 23: only at Progress 1 without the key item'},
            {t = 'chat', re = "You've got nerve, keeping secrets from the boss", why = 'Ceraulian 23 (say #8440)'},
         }},
        {id = 's4', at = {n = 4, fp = 'obtain a kuftal coffer key use'},
         done = {
            {t = 'ki', id = 298, gained = true, why = 'challenge to the Royal Knights obtained'},
            {t = 'ki_have', id = 298, have = true, why = 'challenge to the Royal Knights held'},
            {t = 'chat', re = 'obtained key item: challenge to the royal knights', why = 'chat: key item obtained'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to rahal and speak to'},
         done = {
            {t = 'event', zone = 233, event = 78, why = 'Rahal 78: only at Progress 1 with the challenge, sets 2'},
            {t = 'chat', re = "That's what this is all about", why = 'Rahal 78 (say #6897)'},
            {t = 'event', zone = 233, event = 69, conf = 'inferred', why = 'Rahal 69: reminder, only once he has read the challenge'},
            {t = 'chat', re = 'You must take this matter to Sir Balasiel', conf = 'inferred', why = 'Rahal 69 (say #6899)'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to balasiel southern san d'},
         done = {
            {t = 'event', zone = 230, event = 63, why = 'Balasiel 63: only at Progress 2, sets 3'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to rahal again'},
         done = {
            {t = 'event', zone = 233, event = 110, why = 'Rahal 110: only at Progress 3 with the challenge, sets 4'},
            {t = 'chat', re = 'Ancolain was a powerful warrior', why = 'Rahal 110 (say #6900)'},
         }},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'head to temple of uggalepih for'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'once inside head to f 10'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'click the with your wyvern summoned'}},
        {id = 's11', at = {n = 11, fp = 'once the nm s are dead'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
            {t = 'ki', id = 298, gained = false, conf = 'inferred', why = 'challenge to the Royal Knights used up'},
            {t = 'item', id = 12519, gained = true, conf = 'inferred', why = 'Drachen Armet gained (reward; items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 159, event = 67, why = '??? 67 (also plays with a full bag, so it proves nothing)'}}},
        {id = 's12', kind = 'post', at = {n = 12, fp = 'although it is not necessarry you'},
         done = {
            {t = 'event', zone = 232, event = 22, after = 's11', why = 'Ceraulian 22: the optional scene, only after completion'},
         }},
        {id = 's13', kind = 'post', at = {n = 13, fp = 'rahal will also have some additional'},
         done = {
            {t = 'event', zone = 233, event = 118, after = 's11', why = 'Rahal 118: the optional scene, only after completion'},
            {t = 'chat', re = 'The misunderstanding that long surrounded King Ranperre', after = 's11', why = 'Rahal 118 (say #6902)'},
         }},
    },
}
