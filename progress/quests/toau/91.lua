-- Step progress for Promotion: Superior Private (Aht Urhgan quest 91). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Promotion_Superior_Private.lua (Naja Salaheem 5020 offers and begins the quest
-- with no choice, but no bullet names that talk; 5021 is the plain talk while accepted; the four Warhorse Hoofprints
-- (Bhaflau Thickets, Caedarva Mire, Mount Zhayolm, Wajaom Woodlands) give the Dark Rider hoofprint (789), a key item no other
-- quest hands out; with it held Naja plays 5022, whose finish runs quest:complete, takes the hoofprint and prints "has been
-- promoted to Superior Private", line 6324 of Aht_Urhgan_Whitegate/IDs.lua). 5022 plays only once the hoofprint is held and
-- always completes, so it proves the last bullet. Bullet 1 only says where to look: a note on the hoofprint step.
return {
    title = 'Promotion: Superior Private',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'after accepting the quest find the'}},
        {id = 's2', at = {n = 2, fp = 'click on the warhorse hoofprint to'},
         done = {
            {t = 'ki', id = 789, gained = true, why = 'Dark Rider hoofprint obtained'},
            {t = 'ki_have', id = 789, have = true, why = 'Dark Rider hoofprint held'},
            {t = 'chat', re = 'obtained key item: dark rider hoofprint', why = 'chat: key item obtained'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to naja to complete the'},
         done = {
            {t = 'event', zone = 50, event = 5022, why = 'Naja Salaheem 5022: hands in the hoofprint, completes the quest'},
            {t = 'chat', re = 'has been promoted to superior private', why = 'promotion message (IDs.lua 6324)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 789, gained = false, after = 's2', conf = 'inferred', why = 'Dark Rider hoofprint handed over'},
         }},
    },
}
