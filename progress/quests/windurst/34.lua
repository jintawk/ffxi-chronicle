-- Step progress for Mandragora-Mad (Windurst quest 34). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Windurst_Walls/npcs/Yoran-Oran.lua (event 249 is his one-off introduction and adds the
-- quest on any outcome; 256 is the reminder while accepted; a trade of any of the five items he buys is event 251-255 and
-- plays whenever the quest is not still available, completing it the first time and paying gil, with no item reward, so
-- nothing can fail; 250 is the wrong-item refusal and proves nothing); client event script S4 239_Yoran_Oran_010EF01C.txt
-- (249 say #7683/#7684, 251 say #7686, 252 say #7687). The page has one step: the talk that makes him request an item, with the
-- item chart in a box. The draft's repeat handling is kept but fixed: the quest log bits mark the first run only, a trade
-- after a finished run opens the next one (the trade needs no new talk). The Notes bullets are fame hints, not steps.
return {
    title = 'Mandragora-Mad',
    completes = 's1',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to yoran oran who will'},
         done = {
            {t = 'event', zone = 239, event = 249, why = 'Yoran-Oran 249: the introduction, adds the quest'},
            {t = 'chat', re = "I'm thinking of carrying%-ethy out a study on where mandragora", why = 'Yoran-Oran 249 (say #7683)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'event', zone = 239, event = 256, conf = 'inferred', why = 'Yoran-Oran 256: reminder, only while accepted'},
            {t = 'event', zone = 239, event = 251, conf = 'inferred', why = 'Yoran-Oran 251: Cornette bought, only once the talk has happened'},
            {t = 'event', zone = 239, event = 252, conf = 'inferred', why = 'Yoran-Oran 252: Yuhtunga Sulfur bought'},
            {t = 'event', zone = 239, event = 253, conf = 'inferred', why = 'Yoran-Oran 253: Three-Leaf Mandragora Bud bought'},
            {t = 'event', zone = 239, event = 254, conf = 'inferred', why = 'Yoran-Oran 254: Four-Leaf Mandragora Bud bought'},
            {t = 'event', zone = 239, event = 255, conf = 'inferred', why = 'Yoran-Oran 255: Snobby Letter bought'},
         }},
    },
}
