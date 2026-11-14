-- Step progress for The Curious Case of Melvien (Adoulin quest 138). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Western_Adoulin/npcs/Mastan.lua (event 184, played only while the quest is accepted and
-- Melvien's turn is held without Melvien's death?; option 1 gives key item 2814, so the key item proves the Mastan bullet; the
-- event also plays on the refusing menu rows and is shared with Order Up, so neither it nor its first line is proof, only a
-- reach). Client event script S4 256_Mastan_0110010B.txt (184 say #11705, which plays before the menu). LandSandBoat has no
-- script for the rest of the quest, so the other bullets rest on the page's key items, each a temporary quest key item with no
-- other source: Margret's writ of summons 2811 (Estelle), portrait of Melvien 2812 (the crate), Melvien's turn 2813 (Chumli-Mojumli),
-- Margret's memo 2815 (the crate again). The draft's Ring of supernal disjunction (2350) is dropped: it is the Monstrosity ring
-- a requirement of this quest, never handed out by it. Bullets 6 to 10 (Rala Waterways cutscene, the two quiz
-- answers, the crate cutscene) have no signal of their own: notes. Bullet 11 (Estelle) carries the completed bit; the draft put
-- the completion on the optional bullet 12. Bullets 12 and 13 are the Optional section after the quest: they turn the writ and
-- memo into ciphers (2811/2815 become 2816/2817) and the ferry trade takes the ciphers. Not repeatable.
-- Shared-signal audit: Mastan 184 is listed for Order Up too (client event header), so it is gated after s3 (Melvien's turn, held when 184 plays).
return {
    title = 'The Curious Case of Melvien',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to estelle f 9 in'},
         done = {
            {t = 'ki', id = 2811, gained = true, why = "Margret's writ of summons obtained"},
            {t = 'ki_have', id = 2811, have = true, why = "Margret's writ of summons held"},
            {t = 'chat', re = "obtained key item: margret's writ of summons", why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'check the in the crates in'},
         done = {
            {t = 'ki', id = 2812, gained = true, why = 'portrait of Melvien obtained'},
            {t = 'ki_have', id = 2812, have = true, why = 'portrait of Melvien held'},
            {t = 'chat', re = 'obtained key item: portrait of melvien', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'talk to chumli mojumli k 10'},
         done = {
            {t = 'ki', id = 2813, gained = true, why = "Melvien's turn obtained"},
            {t = 'ki_have', id = 2813, have = true, why = "Melvien's turn held"},
            {t = 'chat', re = "obtained key item: melvien's turn", why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'talk to mastan g 6 in'},
         done = {
            {t = 'ki', id = 2814, gained = true, why = "Melvien's death? obtained (Mastan 184, option 1)"},
            {t = 'ki_have', id = 2814, have = true, why = "Melvien's death? held"},
            {t = 'chat', re = "obtained key item: melvien's death%?", why = 'chat: key item obtained'},
         },
         reach = {{t = 'event', zone = 256, event = 184, after = 's3', why = 'Mastan 184 offered (its finish needs option 1; shared with Order Up)'}}},
        {id = 's5', at = {n = 5, fp = 'return to the crate at eastern'},
         done = {
            {t = 'ki', id = 2815, gained = true, why = "Margret's memo obtained"},
            {t = 'ki_have', id = 2815, have = true, why = "Margret's memo held"},
            {t = 'chat', re = "obtained key item: margret's memo", why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's11', at = {n = 6, fp = 'go to rala waterways h 6'}},
        {id = 's7', kind = 'note', with = 's11', at = {n = 7, fp = 'you have to answer 2 questions'}},
        {id = 's8', kind = 'note', with = 's11', at = {n = 8, fp = 'arciela'}},
        {id = 's9', kind = 'note', with = 's11', at = {n = 9, fp = 'morimar'}},
        {id = 's10', kind = 'note', with = 's11', at = {n = 10, fp = 'return to the crate at eastern'}},
        {id = 's11', at = {n = 11, fp = 'talk to estelle f 9 for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Estelle gives the reward)'},
         }},
        {id = 's12', kind = 'optional', at = {n = 12, fp = 'go to foret de hennetiel f'},
         done = {
            {t = 'ki', id = 2816, gained = true, why = "Margret's imposter's cipher obtained (the writ turns into it)"},
            {t = 'ki', id = 2817, gained = true, why = "Margret's imposter's cipher redux obtained (the memo turns into it)"},
         }},
        {id = 's13', kind = 'optional', at = {n = 13, fp = 'go to selbina and board for'},
         done = {
            {t = 'ki', id = 2816, gained = false, after = 's12', why = "Margret's imposter's cipher handed over on the ferry"},
            {t = 'ki', id = 2817, gained = false, after = 's12', why = "Margret's imposter's cipher redux handed over on the ferry"},
         }},
    },
}
