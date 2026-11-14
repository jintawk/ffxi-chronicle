-- Step progress for The Potential Within (Outlands quest 146). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/The_Potential_Within.lua. Jaucribaix 178 is the offer (a menu; only option 1
-- hands over the Tachi of Trials and the Weapon training guide and begins the quest), so the event and its opening line play on
-- a refusal too: the quest log's current bit is the proof and the accept-only line is "I detect no hesitation" (say #10812).
-- 179 is his reminder while accepted (the first branch of its menu also lets you quit). 181 is the Tachi of Trials trade, played
-- only when the weapon has 300 points (180 is the unfinished refusal) and gives the Map to the Annals of Truth (344); 182 is
-- his reminder once the map is held. The ??? in Kuftal Tunnel pops Kettenkaefer ("You sense an ominous presence...") and then
-- gives the Annals of Truth (345). Jaucribaix 183 runs quest:complete, takes the three key items and teaches Tachi: Kasha.
-- The three key items (343, 344, 345) are also used by the other weapon skill quests (Bugi Soden uses 344 and 345), so each
-- gain after s2 is gated on the quest-specific step before it. Client event script S4 252_Jaucribaix_010FC010.txt (178 accept
-- branch say #10812, 179 say #10816, 181 say #10827, 182 say #10828, 183 say #10829). The quest log is set at the accept step (s2): it
-- is set at the accept step, so it is not silent. Not repeatable. Bullets 3 to 5 (the latent) are an indented list, not steps.
-- Draft corrections: 178's lines and the guide's gain are not accept proof (refusal plays them), 182 belongs to bullet 6 (the
-- map is held) not bullet 10, and the Annals of Truth gain is gated after s6.
return {
    title = 'The Potential Within',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with jaucribaix will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jaucribaix 178, option 1)'},
            {t = 'chat', re = 'I detect no hesitation in your mind and spirit%.', why = 'Jaucribaix 178, accept branch (say #10812)'},
            {t = 'ki', id = 343, gained = true, why = 'weapon training guide obtained (also given by other weapon skill quests)'},
            {t = 'ki_have', id = 343, have = true, why = 'weapon training guide held'},
            {t = 'event', zone = 252, event = 179, conf = 'inferred', why = 'Jaucribaix 179: his reminder, only while accepted'},
            {t = 'chat', re = 'When you have proven your strength and ability, the', conf = 'inferred', why = 'Jaucribaix 179 (say #10816)'},
         },
         reach = {{t = 'event', zone = 252, event = 178, why = 'Jaucribaix 178 offered (its finish needs option 1)'}}},
        {id = 's6', at = {n = 6, fp = 'trade the tachi of trials back'},
         done = {
            {t = 'event', zone = 252, event = 181, after = 's2', why = 'Jaucribaix 181: the finished Tachi of Trials accepted (180 is the refusal)'},
            {t = 'chat', re = 'Wonderful! You are now ready for the final portion of your journey%.', after = 's2', why = 'Jaucribaix 181 (say #10827)'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'ki_have', id = 344, have = true, after = 's2', why = 'map to the Annals of Truth held'},
            {t = 'event', zone = 252, event = 182, after = 's2', conf = 'inferred', why = 'Jaucribaix 182: his reminder, only once the map is held'},
            {t = 'chat', re = 'Travel to the Kuftal Tunnel, as is instructed upon the', after = 's2', conf = 'inferred', why = 'Jaucribaix 182 (say #10828)'},
         }},
        {id = 's7', kind = 'note', with = 's9', at = {n = 7, fp = 'unity warp 125 brings you relatively'}},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'take silent oil and prism powder'}},
        {id = 's9', at = {n = 9, fp = 'this fight is against kettenkaefer a'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained (also given by Bugi Soden)'},
            {t = 'ki_have', id = 345, have = true, after = 's6', why = 'Annals of Truth held'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's10', at = {n = 10, fp = 'go back and speak with jaucribaix'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 252, event = 183, after = 's6', why = 'Jaucribaix 183: runs quest:complete'},
            {t = 'chat', re = 'So, you have finally completed this leg of your journey%.', after = 's6', why = 'Jaucribaix 183 (say #10829)'},
            {t = 'chat', re = 'You have learned the weapon skill Tachi: Kasha!', after = 's6', why = 'Norg TACHI_KASHA_LEARNED'},
            {t = 'ki', id = 345, gained = false, after = 's9', conf = 'inferred', why = 'Annals of Truth handed over'},
            {t = 'ki', id = 344, gained = false, after = 's9', conf = 'inferred', why = 'map to the Annals of Truth handed over'},
            {t = 'ki', id = 343, gained = false, after = 's9', conf = 'inferred', why = 'weapon training guide handed over'},
         }},
    },
}
