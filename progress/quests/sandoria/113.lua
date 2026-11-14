-- Step progress for Lure of the Wildcat (San d'Oria) (San d'Oria quest 113). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Lure_of_the_Wildcat_Sandoria.lua (Amutiyaal 812 has a menu but both
-- answers get the badge: the finish gives key item 743 and begins the quest; each of the 20 NPCs plays one progressEvent
-- (808 and the like) that sets a bit; 813 and 814 are Amutiyaal's reminders; 815 plays only when all 20 bits are set, takes
-- the badge and runs quest:complete, whose reward is a key item, no item) and Amutiyaal.lua (881: the 300 gil teleport
-- trade, only started by a valid trade); client event script S4 230_Amutiyaal_010E6111.txt (812 say #10388, 815 #10393,
-- 881 #13315). The draft ended the quest on the card (a reward key item) without the event; 815 is the completing event.
-- Bullet 2 (the 20 NPC talks) is a note on the return: only the completing event 815 proves it, and the 20 csids sit in a
-- table-driven script that check_steps cannot read, so they are not listed. The Naja Salaheem bullet (4) has a menu event that plays
-- without trading, so it stays plain. Bullet 5 is an optional Aht Urhgan teleport after the quest.
return {
    title = "Lure of the Wildcat (San d'Oria)",
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with amutiyaal to recieve a'},
         done = {
            {t = 'event', zone = 230, event = 812, why = 'Amutiyaal 812: the badge pinned on, either answer'},
            {t = 'chat', re = 'This is the symbol of the illustrious leader of Salaheem', why = 'Amutiyaal 812 (say #10388)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 743, gained = true, why = 'red Sentinel badge obtained'},
            {t = 'ki_have', id = 743, have = true, why = 'red Sentinel badge held'},
            {t = 'chat', re = 'obtained key item: red sentinel badge', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'speak with the following people'}},
        {id = 's3', at = {n = 3, fp = 'once you have spoken to all'},
         done = {
            {t = 'event', zone = 230, event = 815, why = 'Amutiyaal 815: completes the quest'},
            {t = 'chat', re = 'You have spread the fire of fascination through the entire city', why = 'Amutiyaal 815 (say #10393)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 753, gained = true, conf = 'inferred', why = 'red invitation card obtained (reward)'},
            {t = 'ki', id = 743, gained = false, conf = 'inferred', why = 'red Sentinel badge taken'},
         }},
        {id = 's5', kind = 'optional', at = {n = 5, fp = 'after joining salaheem s sentinels alib'},
         done = {
            {t = 'event', zone = 230, event = 881, why = 'Amutiyaal 881: the 300 gil teleport trade'},
            {t = 'chat', re = 'Now let us be on our merry way!', why = 'Amutiyaal 881 (say #13315)'},
         }},
    },
}
