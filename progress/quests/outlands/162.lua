-- Step progress for Soul Searching (Outlands quest 162). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Soul_Searching.lua (the Cermet Headstone in The Sanctuary of Zi'Tah plays event
-- 202 only with the Prismatic Fragment held, and its finish runs quest:complete; with no fragment it shows a message and no
-- event). Client event script S4 121_Cermet_Headstone_0107922E.txt: the LSB-owner header gives 200 and 201 to Headstone
-- Pilgrimage and 202 to this quest; 202 has no line of its own. One step only: the page has a single walkthrough bullet.
-- The quest is added by the Zilart mission line, not by an NPC, so nothing earlier is observable. Not repeatable.
return {
    title = 'Soul Searching',
    completes = 's1',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'touch the cermet headstone with the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 121, event = 202, why = 'Cermet Headstone 202: the Prismatic Fragment held, runs quest:complete'},
         }},
    },
}
