-- Step progress for Back to the Beginning (Wings of the Goddess mission 2, mission id 1). Data only; see progress/missions/sandoria/5.lua
-- for groups. Evidence: LandSandBoat scripts/missions/wotg/02_Back_to_the_Beginning.lua and quests/crystalWar/WOTG_*.lua.
-- The mission is completed by a Cavernous Maw once any one nation's pair of follow-up quests is done: the maws in Batallia Downs
-- 105, Rolanberry Fields 110 and Sauromugue Champaign 120 play event 501, their Shadowreign twins 84, 91 and 98 play 701, and the
-- finish calls mission:complete (the client's event lists of those six Cavernous Maw scripts carry 501 and 701, bodies empty).
-- That is bullet 42, the only step common to the three routes. There is no `completes` step: the three nation routes are
-- alternatives (groups sa / wi / ba, like Journey Abroad), so a log snapshot alone cannot tell which bullets were done.
-- Bullets 1 to 3, 17, 25 and 28 are information and travel for the whole mission: notes on bullet 42.
-- San d'Oria: handing in the Red recommendation letter (key item 921) starts Steamed Rams (Mainchelite 7 or 8 takes the letter at
-- the accept), but the bullet also says to complete the quest, and the quest's end is proven by Mainchelite's finish taking the
-- East Ronfaure (S) key items (Charred propeller 950, Oxidized plate 952, Piece of shattered lumber 951) only on the completion,
-- so the lumber's loss is the proof and the letter's loss only a reach. Bullet 35 ends with Claws of the Griffon, completed by qm6
-- event 203 in Jugner Forest [S] (zone 82), but the client has no script for that NPC and check_steps cannot confirm the id from
-- the quest script, so bullet 35 stays a plain bullet.
-- Windurst and Bastok: the two letter bullets (36, 39) end in a quest whose completion event (Miah Riyuh 106, Adelbrecht 143) needs
-- option 0 and a free inventory slot (a full bag returns without completing), so neither leaves a clean signal and they stay plain
-- bullets. Bullets 38 and 41 end in The Tigress Strikes (Dhea Prandoleh 134 in Windurst Waters [S], zone 94, Prog 3) and Fires of
-- Discontent (Engelhart 164 in Bastok Markets [S], zone 87, Prog 6); both are the complete call with no refusal path. Bullets 37
-- and 40 are notes on them. The draft put the mission's completion on bullet 34 and offered the recommendation letters' gains and
-- chat lines as proof; the letters are handed out at the indented bullets and returned by a cancel, so none of that is used.
return {
    title = 'Back to the Beginning',
    known = {{t = 'mission', line = 'wotg', eq = 1}},
    steps = {
        {id = 's1', kind = 'note', with = 's42', at = {n = 1, fp = 'in the last mission you had'}},
        {id = 's2', kind = 'note', with = 's42', at = {n = 2, fp = 'there are three potential recommendation letters'}},
        {id = 's3', kind = 'note', with = 's42', at = {n = 3, fp = 'your choice of nation allegiance has'}},
        {id = 's17', kind = 'note', with = 's42', at = {n = 17, fp = 'you will have to take at'}},
        {id = 's25', kind = 'note', with = 's42', at = {n = 25, fp = 'note at this point the maps'}},
        {id = 's28', kind = 'note', with = 's42', at = {n = 28, fp = 'once you reach one of the'}},

        -- San d'Oria
        {id = 's34', group = 'sa', at = {n = 34, fp = 'once you arrive in southern san'},
         done = {
            {t = 'ki', id = 951, gained = false, why = 'Piece of shattered lumber taken: Steamed Rams completed (Mainchelite 12 / 624)'},
         },
         reach = {
            {t = 'ki', id = 921, gained = false, why = 'Red recommendation letter handed to Mainchelite (Steamed Rams begun)'},
         }},

        -- Windurst
        {id = 's37', kind = 'note', with = 's38', group = 'wi', at = {n = 37, fp = 'finishing the above step will declare'}},
        {id = 's38', group = 'wi', at = {n = 38, fp = 'complete the following quests the tigress'},
         done = {
            {t = 'event', zone = 94, event = 134, why = 'Dhea Prandoleh 134: The Tigress Strikes completed (Windurst Waters [S], Prog 3)'},
         }},

        -- Bastok
        {id = 's40', kind = 'note', with = 's41', group = 'ba', at = {n = 40, fp = 'finishing the above step will declare'}},
        {id = 's41', group = 'ba', at = {n = 41, fp = 'complete the following quests better part'},
         done = {
            {t = 'event', zone = 87, event = 164, why = 'Engelhart 164: Fires of Discontent completed (Bastok Markets [S], Prog 6)'},
         }},

        {id = 's42', at = {n = 42, fp = 'once a single questline has been'},
         done = {
            {t = 'event', zone = 105, event = 501, why = 'Cavernous Maw 501: completes the mission (Batallia Downs, LandSandBoat)'},
            {t = 'event', zone = 110, event = 501, why = 'Cavernous Maw 501: completes the mission (Rolanberry Fields)'},
            {t = 'event', zone = 120, event = 501, why = 'Cavernous Maw 501: completes the mission (Sauromugue Champaign)'},
            {t = 'event', zone = 84, event = 701, why = 'Cavernous Maw 701: completes the mission (Batallia Downs [S])'},
            {t = 'event', zone = 91, event = 701, why = 'Cavernous Maw 701: completes the mission (Rolanberry Fields [S])'},
            {t = 'event', zone = 98, event = 701, why = 'Cavernous Maw 701: completes the mission (Sauromugue Champaign [S])'},
            {t = 'mission', line = 'wotg', eq = 1, completed = true, why = 'mission log: Back to the Beginning completed'},
         }},
    },
}
