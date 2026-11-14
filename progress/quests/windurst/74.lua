-- Step progress for Unbridled Passion (Windurst quest 74). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Woods/npcs/Perih_Vashai.lua (541 begins the quest with no option test; 542 is her
-- talk at stages 1 to 6; 546 plays only at stage 7, after the Ice Arrows were handed over, but completing needs
-- npcUtil.completeQuest to pay, so for the last bullet it is a reach and the quest log carries it), zones/Mhaura/npcs/
-- Koh_Lenbalalako.lua (10009 and 10010 are her two talks, 10011 the accepted Gold Earring trade that gives Koh's letter, 10012 her
-- talk after it), zones/Xarcabard/Zone.lua (zone-in cutscenes 4 and 5 at stage 3), npcs/qm7.lua (event 8 at stage 4 pops the
-- Koenigstiger), npcs/qm6.lua (event 6 at stage 5, which means the Koenigstiger died, then event 7 hands out the 99 Ice Arrows
-- and is played even with a full bag, so it proves nothing); key item 236 from res/key_items.lua. Bullet 6 (the Ice Arrows) has
-- no signal of its own, but Perih Vashai 546 only plays at stage 7, which needs them, so it proves bullet 6 and is a reach for
-- bullet 7. Bullet 4 is shown by the pop cutscene (the kill is proven by bullet 5's event). Repeatable after a memory reset
-- (page meta): Perih Vashai 541 opens the next run. The quest log is set at s1, so it is not silent.
return {
    title = 'Unbridled Passion',
    completes = 's7',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to perih vashai in windurst'},
         done = {
            {t = 'event', zone = 241, event = 541, why = 'Perih Vashai 541: the quest begins'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 241, event = 542, conf = 'inferred', why = 'Perih Vashai 542: her talk at stages 1 to 6, only once accepted'},
         }},
        {id = 's2', at = {n = 2, fp = 'in mhaura speak twice with koh'},
         done = {
            {t = 'event', zone = 249, event = 10011, why = 'Koh Lenbalalako 10011: the Gold Earring accepted'},
            {t = 'ki', id = 236, gained = true, why = "Koh's letter obtained"},
            {t = 'ki_have', id = 236, have = true, why = "Koh's letter held"},
            {t = 'chat', re = "obtained key item: koh's letter", why = 'chat: key item obtained'},
            {t = 'event', zone = 249, event = 10012, conf = 'inferred', why = 'Koh Lenbalalako 10012: her talk after the trade'},
         },
         reach = {
            {t = 'event', zone = 249, event = 10009, why = 'Koh Lenbalalako 10009'},
            {t = 'event', zone = 249, event = 10010, why = 'Koh Lenbalalako 10010: asks for the Gold Earring'},
         }},
        {id = 's3', at = {n = 3, fp = 'zone into xarcabard for a cutscene'},
         done = {
            {t = 'zonein', zone = 112, event = 4, why = 'Xarcabard zone-in cutscene 4 (stage 3)'},
            {t = 'zonein', zone = 112, event = 5, why = 'Xarcabard zone-in cutscene 5 (stage 3, from the Vahzl point)'},
         }},
        {id = 's4', at = {n = 4, fp = 'find the cave at e 7'},
         done = {
            {t = 'event', zone = 112, event = 8, why = 'Xarcabard ??? 8: the cutscene and the Koenigstiger pop'},
         }},
        {id = 's5', at = {n = 5, fp = 'now head south to the cave'},
         done = {
            {t = 'event', zone = 112, event = 6, why = 'Xarcabard ??? 6: plays only after the Koenigstiger died (stage 5)'},
         }},
        {id = 's6', at = {n = 6, fp = 'after the cutscene is over check'},
         done = {
            {t = 'event', zone = 241, event = 546, conf = 'inferred', why = 'Perih Vashai 546: plays only at stage 7, after the Ice Arrows were handed over'},
         },
         reach = {{t = 'event', zone = 112, event = 7, why = 'Xarcabard ??? 7 (the arrows need a free slot)'}}},
        {id = 's7', at = {n = 7, fp = 'head back to windurst woods and'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 236, gained = false, conf = 'inferred', why = "Koh's letter handed over"},
         },
         reach = {{t = 'event', zone = 241, event = 546, why = 'Perih Vashai 546 (completion needs a free slot for the reward)'}}},
    },
}
