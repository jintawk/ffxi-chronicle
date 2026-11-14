-- Step progress for Cauterize (Rhapsodies of Vana'diel mission, page id 180 = LandSandBoat's CAUTERIZE 72 + 108). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/2_14_Cauterize.lua: the sparkling ??? (qm_maw) beside a Cavernous Maw plays one
-- event per zone only when the Rhapsody characters are available (otherwise a message and no event): 20 in Batallia Downs
-- (105), 18 in Rolanberry Fields (110), 19 in Sauromugue Champaign (120), 23 in Batallia Downs [S] (84), 19 in Rolanberry
-- Fields [S] (91), 31 in Sauromugue Champaign [S] (98). Its finish completes Cauterize, then adds and completes Uncertain
-- Destinations (186) and adds Ganged Up On (188), so the line ends at 188; `min = 186` holds for either reading. The rov line
-- holds the page id and has no completed set. The reward key item (Lightsworm) can already be owned and is not used. The
-- indented bullets (prerequisites) are not steps.
return {
    title = 'Cauterize',
    completes = 's1',
    known = {{t = 'mission', line = 'rov', min = 180, max = 185}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'head to one of the cavernous'},
         done = {
            {t = 'event', zone = 105, event = 20, why = 'Batallia Downs ??? 20: the cutscene that completes the mission'},
            {t = 'event', zone = 110, event = 18, why = 'Rolanberry Fields ??? 18'},
            {t = 'event', zone = 120, event = 19, why = 'Sauromugue Champaign ??? 19'},
            {t = 'event', zone = 84, event = 23, why = 'Batallia Downs [S] ??? 23'},
            {t = 'event', zone = 91, event = 19, why = 'Rolanberry Fields [S] ??? 19'},
            {t = 'event', zone = 98, event = 31, why = 'Sauromugue Champaign [S] ??? 31'},
            {t = 'mission', line = 'rov', min = 186, why = 'mission log: the line moved past Cauterize'},
         }},
    },
}
