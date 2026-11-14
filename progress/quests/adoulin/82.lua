-- Step progress for Transporting (Adoulin quest 82). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/adoulin/Transporting.lua (Vaulois 2590 begins the quest and gives the Misdelivered
-- parcel, no refusal; Kongramm 2592 plays only at Prog 0 and sets Prog 1; the Rala Waterways ??? at the Sluice Gate (C-6)
-- plays 2802 only at Prog 1, takes the parcel and sets Prog 2; Vaulois 2591 plays only at Prog 2 and runs quest:complete,
-- the reward being bayld and experience with no item, so it has no refusal). Client event scripts S4
-- 256_Vaulois_01100109.txt (2590 say #8000, 2591 say #8010) and 256_Kongramm_01100124.txt (2592 say #8006); the Sluice Gate
-- has no client script of its own, so 2802 rests on LandSandBoat and the parcel's loss. Key item 2275 from res/key_items.lua.
-- The bullet "Use the Rala Waterways entrance" is a travel note on the Sluice Gate step. Not repeatable.
return {
    title = 'Transporting',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to vaulois at h 6'},
         done = {
            {t = 'event', zone = 256, event = 2590, why = 'Vaulois 2590: the first talk, begins the quest'},
            {t = 'chat', re = 'What excellent timing! I am loath to impose, but I require your assistance%.', why = 'Vaulois 2590 (say #8000)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 2275, gained = true, why = 'misdelivered parcel obtained'},
            {t = 'ki_have', id = 2275, have = true, why = 'misdelivered parcel held'},
            {t = 'chat', re = 'obtained key item: misdelivered parcel', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'then head to the waterfront and'},
         done = {
            {t = 'event', zone = 256, event = 2592, why = 'Kongramm 2592: only at Prog 0'},
            {t = 'chat', re = 'What!%? The wrong destination!%?', why = 'Kongramm 2592 (say #8006)'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'use the rala waterways entrance at'}},
        {id = 's4', at = {n = 4, fp = 'once inside head to c 6'},
         done = {
            {t = 'event', zone = 258, event = 2802, why = 'Sluice Gate ??? 2802: only at Prog 1, takes the parcel'},
            {t = 'ki', id = 2275, gained = false, why = 'misdelivered parcel taken at the Sluice Gate'},
         }},
        {id = 's5', at = {n = 5, fp = 'return to vaulois to complete the'},
         done = {
            {t = 'event', zone = 256, event = 2591, why = 'Vaulois 2591: only at Prog 2, runs quest:complete'},
            {t = 'chat', re = 'I have been informed that the package made it to its destination safely%.', why = 'Vaulois 2591 (say #8010)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
