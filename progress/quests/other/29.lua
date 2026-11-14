-- Step progress for It's Raining Mannequins (other areas quest 29). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/otherAreas/Its_Raining_Mannequins.lua (Fyi Chalmwoh 305 is the offer and begins the quest
-- on finish with no menu; her hints are 306 (go to Selbina), 307 (go to San d'Oria), 308 (diagrams in hand), 310 (wait); Ramona
-- 1103 gives key item 509 and Cheupirudaux 759 gives key item 510, each on its own Prog step; the five mannequin pieces traded
-- to her play 309; the reward event 311 only completes the quest with a free slot and no mannequin of your race, so it also
-- plays on a refusal and the log's completed bit is the proof). Client event scripts S4 249_Fyi_Chalmwoh_010F906F.txt (305 say
-- #7564, 309 say #7579), 248_Ramona_010F801A.txt (1103 say #7348), 231_Cheupirudaux_010E7023.txt (759). Not repeatable.
return {
    title = "It's Raining Mannequins",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to fyi chalmwoh in mhaura'},
         done = {
            {t = 'event', zone = 249, event = 305, why = 'Fyi Chalmwoh 305: the offer, begins the quest on finish'},
            {t = 'chat', re = 'Hey! You look like a well%-trrraveled', why = 'Fyi Chalmwoh 305 (say #7564)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 249, event = 306, conf = 'inferred', why = 'Fyi Chalmwoh 306: hint to Selbina, only while accepted'},
            {t = 'chat', re = "I already checked the Weavers' Guild in Windurst", conf = 'inferred', why = 'Fyi Chalmwoh 306 (say #7571)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak to ramona in selbina at'},
         done = {
            {t = 'ki', id = 509, gained = true, why = 'Ye Olde Mannequin Catalogue obtained'},
            {t = 'event', zone = 248, event = 1103, why = 'Ramona 1103: gives the catalogue'},
            {t = 'chat', re = 'Do we have a mannequin!%? What do you think we are, crazy%?', why = 'Ramona 1103 (say #7348)'},
            {t = 'chat', re = 'obtained key item: ye olde mannequin catalogue', why = 'chat: key item obtained'},
            {t = 'event', zone = 249, event = 307, conf = 'inferred', why = 'Fyi Chalmwoh 307: hint to San d\'Oria, only after the catalogue'},
         }},
        {id = 's3', at = {n = 3, fp = 'speak to cheupirudaux in northern san'},
         done = {
            {t = 'ki', id = 510, gained = true, why = 'mannequin joint diagrams obtained'},
            {t = 'event', zone = 231, event = 759, why = 'Cheupirudaux 759: gives the diagrams'},
            {t = 'chat', re = 'obtained key item: mannequin joint diagrams', why = 'chat: key item obtained'},
            {t = 'event', zone = 249, event = 308, conf = 'inferred', why = 'Fyi Chalmwoh 308: diagrams in hand, only after them'},
         }},
        {id = 's4', at = {n = 4, fp = 'gather all 5 mannequin pieces and'},
         done = {
            {t = 'event', zone = 249, event = 309, why = 'Fyi Chalmwoh 309: the five pieces accepted'},
            {t = 'chat', re = "Unbelievable! You've found all the parts!", why = 'Fyi Chalmwoh 309 (say #7579)'},
            {t = 'event', zone = 249, event = 310, conf = 'inferred', why = 'Fyi Chalmwoh 310: please wait, only after the pieces'},
         }},
        {id = 's5', at = {n = 5, fp = 'zone and speak to fyi chalmwoh'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Fyi Chalmwoh 311 with a free slot)'},
         }},
    },
}
