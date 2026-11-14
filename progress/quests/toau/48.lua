-- Step progress for Embers of His Past (Aht Urhgan quest 48). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/Embers_of_His_Past.lua (a Prog state machine; none of these event numbers is
-- used by another quest in the same zone: Fari-Wari 916 begins the quest with no refusal and sends you to Wajaom Woodlands, whose
-- zone-ins then play cutscenes 16 (Prog 1) and 17 (Prog 2) before returning you; Fari-Wari plays 917 at Prog 3-4; Sprightly
-- Footsteps (Mount Zhayolm, night only) plays 15 at Prog 3, Withered Petals plays 16 at Prog 4 and returns you; at Prog 5
-- Fari-Wari plays 924 on a plain talk and 918 when the Hydrangea is traded (exact trade only), then Wajaom zone-ins play 18
-- (Prog 6) and 19 (Prog 7, returns the Hydrangea); Fari-Wari plays 919 at Prog 8; the Withered Petals trade (night only, exact)
-- plays 17 then 18; Fari-Wari 920 at Prog 9 runs quest:complete; once completed and the zone has been changed, Fari-Wari 921
-- hands over the Mercenary Camp Entry Slip). The Wajaom zone-in cutscenes 16 and 17 are part of the opening cutscene of bullet 1
-- and 18 and 19 of the Hydrangea trade of bullet 4. The imperial-standing message is shared by other quests and is not used;
-- the reward items are not used. Bullet 7 follows the completion (a note on the post step). Not repeatable.
return {
    title = 'Embers of His Past',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to fari wari at the'},
         done = {
            {t = 'event', zone = 50, event = 916, why = 'Fari-Wari 916: the offer, begins the quest with no refusal'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'zonein', zone = 51, event = 16, why = 'Wajaom Woodlands zone-in cutscene 16: only at Prog 1'},
            {t = 'zonein', zone = 51, event = 17, why = 'Wajaom Woodlands zone-in cutscene 17: only at Prog 2'},
            {t = 'event', zone = 50, event = 917, why = 'Fari-Wari 917: only at Prog 3-4'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to mount zhayolm and click'},
         done = {
            {t = 'event', zone = 61, event = 15, why = 'Sprightly Footsteps 15: only at Prog 3, night only'},
         }},
        {id = 's3', at = {n = 3, fp = 'click on on withered petals l'},
         done = {
            {t = 'event', zone = 61, event = 16, why = 'Withered Petals 16: only at Prog 4, night only'},
            {t = 'event', zone = 50, event = 924, why = 'Fari-Wari 924: his plain talk at Prog 5'},
         }},
        {id = 's4', at = {n = 4, fp = 'trade a hydrangea to fari wari'},
         done = {
            {t = 'event', zone = 50, event = 918, why = 'Fari-Wari 918: the exact Hydrangea trade, only at Prog 5'},
            {t = 'zonein', zone = 51, event = 18, why = 'Wajaom Woodlands zone-in cutscene 18: only at Prog 6'},
            {t = 'zonein', zone = 51, event = 19, why = 'Wajaom Woodlands zone-in cutscene 19: only at Prog 7'},
            {t = 'event', zone = 50, event = 919, why = 'Fari-Wari 919: only at Prog 8'},
         }},
        {id = 's5', at = {n = 5, fp = 'trade the hydrangea to the withered'},
         done = {
            {t = 'event', zone = 61, event = 17, why = 'Withered Petals 17: the exact Hydrangea trade, only at Prog 8, night only'},
            {t = 'event', zone = 61, event = 18, why = 'Withered Petals 18: follows 17'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to fari wari for a'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 50, event = 920, why = 'Fari-Wari 920: only at Prog 9, runs quest:complete'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'speak to fari wari after this'}},
        {id = 's8', kind = 'post', at = {n = 8, fp = 'speak to fari wari after the'},
         done = {
            {t = 'event', zone = 50, event = 921, after = 's6', why = 'Fari-Wari 921: only once completed, the camp slip'},
            {t = 'item', id = 2487, gained = true, after = 's6', conf = 'inferred', why = 'Mercenary Camp Entry Slip gained (items can come from elsewhere)'},
         }},
    },
}
