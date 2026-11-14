-- Step progress for Beat Around the Bushin (Jeuno quest 67). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no quest script; the quest lives in NPC scripts. zones/Lower_Jeuno/npcs/Vola.lua (245: 160 is the
-- start talk, a bare cutscene, only for a Monk of level 71+ with Norg fame 6; 214 plays during and after the quest);
-- zones/Lower_Jeuno/npcs/_6tc.lua (the Door: "Neptune's Spire": 155 adds the quest, so the log is silent before step 2; 156, 157
-- and 158 play only on the exact Wyrm Beard, Behemoth Tongue and Adamantoise Egg trades in turn; 159 is the Brown Belt trade,
-- which with no free slot plays but gives nothing and completes nothing, so it is only a reach and the quest log's completed
-- bit carries the last step, with "Obtained: Black Belt" on success only); zones/Bastok_Markets/npcs/Degenhard.lua (235: 342
-- plays at the right point of the quest); zones/RuLude_Gardens/npcs/Maat.lua (243: 117, then the egg trade 158 ends that
-- bullet, so 117 is only a reach). Client event script S4 245_Vola_010F503B.txt (160 bare, 214 say #7822) and
-- 235_Degenhard_010EB042.txt (342 bare); the door's and Maat's events are in LandSandBoat only. Item 13186 (black belt)
-- from res/items.lua. Not repeatable (page meta).
return {
    title = 'Beat Around the Bushin',
    completes = 's7',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to vola to begin this'},
         done = {
            {t = 'event', zone = 245, event = 160, why = 'Vola 160: the start talk (a bare cutscene)'},
         }},
        {id = 's2', at = {n = 2, fp = 'exit the tenshodo through the door'},
         done = {
            {t = 'event', zone = 245, event = 155, why = 'the Door: "Neptune\'s Spire" 155: adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted (door 155)'},
            {t = 'event', zone = 245, event = 214, conf = 'inferred', why = 'Vola 214: plays during and after the quest'},
            {t = 'chat', re = 'Perhaps one day we can face each other in open%-hand combat%.', conf = 'inferred', why = 'Vola 214 (say #7822)'},
         }},
        {id = 's3', at = {n = 3, fp = 'obtain a wyrm beard from nidhogg'},
         done = {
            {t = 'event', zone = 245, event = 156, why = 'the Door: "Neptune\'s Spire" 156: the Wyrm Beard accepted'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to degenhard bastok markets i'},
         done = {
            {t = 'event', zone = 235, event = 342, why = 'Degenhard 342'},
         }},
        {id = 's5', at = {n = 5, fp = 'obtain a behemoth tongue from king'},
         done = {
            {t = 'event', zone = 245, event = 157, why = 'the Door: "Neptune\'s Spire" 157: the Behemoth Tongue accepted'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to maat ru lude gardens'},
         done = {
            {t = 'event', zone = 245, event = 158, why = 'the Door: "Neptune\'s Spire" 158: the Adamantoise Egg accepted'},
         },
         reach = {{t = 'event', zone = 243, event = 117, why = 'Maat 117'}}},
        {id = 's7', at = {n = 7, fp = 'finally trade a brown belt to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'chat', re = 'Obtained: Black Belt', why = 'ITEM_OBTAINED from the door, on success only'},
            {t = 'item', id = 13186, gained = true, conf = 'inferred', why = 'Black Belt gained (reward) (items can come from elsewhere)'},
         },
         reach = {{t = 'event', zone = 245, event = 159, why = 'the Door: "Neptune\'s Spire" 159 (also plays with no free slot, giving nothing)'}}},
    },
}
