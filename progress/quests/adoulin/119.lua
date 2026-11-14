-- Step progress for Children of the Rune (Adoulin quest 119). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Eastern_Adoulin/npcs/Octavien.lua (Octavien offers with 23 or, after a first decline, 24;
-- option 1 on either begins the quest, so the quest log's current bit is the accept; while accepted he plays 25 without the
-- Yahse wildflower petal and 26 with it; 26 is also the rune enhancement attempt, option 1 on it sets the reward-pending state,
-- 29 plays when the reward is pending (full bag) and the finish runs quest:complete, so the completed bit proves the last step;
-- once completed he plays 28) and zones/Yahse_Hunting_Grounds/npcs/Yahse_Wildflower.lua (the petal is given only while the
-- quest is accepted). Client event script S4 257_Octavien_01101074.txt has no dialogue for any of these events. Key item 2279
-- from res/key_items.lua. The quest log is not silent: the accept sets the current bit. The reward line (bullet 4) is a note on
-- the last step. Not repeatable.
-- Shared-signal audit: the petal (2279) and its chat line are also handed out for Destiny's Device (quest 25), so they are gated after s1 (the accepted bit).
return {
    title = 'Children of the Rune',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with octavien at i 8'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Octavien 23 or 24, option 1)'},
            {t = 'event', zone = 257, event = 25, conf = 'inferred', why = 'Octavien 25: plays only while accepted, before the petal'},
         },
         reach = {
            {t = 'event', zone = 257, event = 23, why = 'Octavien 23 offered (its finish needs option 1)'},
            {t = 'event', zone = 257, event = 24, why = 'Octavien 24 offered after a decline (its finish needs option 1)'},
         }},
        {id = 's2', at = {n = 2, fp = 'obtain a yahse wildflower petal from'},
         done = {
            {t = 'ki', id = 2279, gained = true, after = 's1', why = 'Yahse wildflower petal obtained (given only while accepted)'},
            {t = 'ki_have', id = 2279, have = true, after = 's1', why = 'Yahse wildflower petal held'},
            {t = 'chat', re = 'obtained key item: yahse wildflower petal', after = 's1', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak with octavien again and attempt'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 257, event = 28, conf = 'inferred', why = 'Octavien 28: plays only once completed'},
         },
         reach = {
            {t = 'event', zone = 257, event = 26, why = 'Octavien 26: the rune enhancement attempts (repeated until it succeeds)'},
            {t = 'event', zone = 257, event = 29, why = 'Octavien 29: reward pending (also plays when the Sowilo Claymore cannot be given)'},
         }},
        {id = 's4', kind = 'note', with = 's3', at = {n = 4, fp = 'when you succeed you will be'}},
    },
}
