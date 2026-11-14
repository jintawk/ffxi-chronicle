-- Step progress for The Silent Forest (Adoulin quest 144). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat enum entry or script and no client event script for its NPCs, so the signals are the page's
-- key item and the quest log. The Inert geomancy bell (3189) is handed over at Escha - Ru'Aun (bullet 3) and is not a reward.
-- The Fistful of familiar soil (3190, bullet 6) is also handed out by the Crags for Dances with Luopans and for the repeat
-- Winds of Eternity (quest 145), so it is a shared signal and proves nothing here; the draft's Holla/Dem/Mea crystals belong
-- to Treasures of the Earth and are dropped. The page puts the cutscene after the Siren fight and the reward choice on
-- bullet 10, which carries the completed bit. The quest appears in the log after bullet 2 (page note), but that is not
-- used: no signal is named for bullets 1 and 2. The cutscenes (1, 2, 4, 5, 7, 8) and the BCNM entry (9) have no signal
-- of their own: notes. Not repeatable (Winds of Eternity, quest 145, is the repeat).
return {
    title = 'The Silent Forest',
    completes = 's10',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'speak with levil in the pioneers'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak with ploh trishbahk at k'}},
        {id = 's3', at = {n = 3, fp = 'go to escha ru aun and'},
         done = {
            {t = 'ki', id = 3189, gained = true, why = 'inert geomancy bell obtained'},
            {t = 'ki_have', id = 3189, have = true, why = 'inert geomancy bell held'},
            {t = 'chat', re = 'obtained key item: inert geomancy bell', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's10', at = {n = 4, fp = 'return to ploh trishbahk for another'}},
        {id = 's5', kind = 'note', with = 's10', at = {n = 5, fp = 'meet arciela ygnas and darrcuiln in'}},
        {id = 's6', kind = 'note', with = 's10', at = {n = 6, fp = 'venture to the crag closest to'}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'enter leafallia for a cutscene'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'examine the glowing spot drifting feather'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'examine the drifting feather again to'}},
        {id = 's10', at = {n = 10, fp = 'upon defeating siren a cutscene will'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the reward choice after the Siren fight)'},
         }},
        {id = 's11', kind = 'note', with = 's10', at = {n = 11, fp = 'see also testimonial discussion page'}},
    },
}
