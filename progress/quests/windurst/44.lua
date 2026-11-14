-- Step progress for Legendary Plan B (Windurst quest 44). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Kopuro-Popuro.lua (306 is a nudge while the previous quest still
-- needs a zone; 308 is the offer and its finish adds the quest with no option test; 309 is his reminder while accepted; the
-- trade of Luminicloth + Revival Tree Root + Wolf Hide is event 314, whose finish runs npcUtil.completeQuest with the Scentless
-- Armlets plus gil and fame, which fails without a free slot while 314 plays regardless, so 314 is `reach` and the quest log's
-- completed bit carries the last step). The draft made the trade bullet a note and put the completed bit on the first step; the
-- bullet is the completing step. Client event script S4 241_Kopuro_Popuro_010F1016.txt (309 say #8163; 308 and 314 have no
-- dialogue line in it). The page's quest-log flag is set at the offer, so the log is not silent.
return {
    title = 'Legendary Plan B',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you will have to zone after'}},
        {id = 's2', at = {n = 2, fp = 'speak to kopuro popuro to begin'},
         done = {
            {t = 'event', zone = 241, event = 308, why = 'Kopuro-Popuro 308: the offer, adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 241, event = 309, conf = 'inferred', why = 'Kopuro-Popuro 309: reminder, only while accepted'},
            {t = 'chat', re = "You'll help us out as well, won'taru you%?", conf = 'inferred', why = 'Kopuro-Popuro 309 (say #8163)'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade kopuro popuro a luminicloth revival'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 241, event = 314, why = 'Kopuro-Popuro 314: the items accepted (also plays with a full bag, when the reward fails)'}}},
    },
}
