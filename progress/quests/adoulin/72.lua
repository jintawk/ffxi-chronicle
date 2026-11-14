-- Step progress for Scaredy-Cats (Adoulin quest 72). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Western_Adoulin/npcs/Bilp.lua and Eamonn.lua (the cutscene 5024 is the offer and runs
-- addQuest only on option 1, so it plays on a refusal too and proves nothing; the quest log flags the quest at it, which
-- is what bullet 1 means; 5025, 5026 and 5027 are reminder talks and are not used). Nothing in LandSandBoat or the client
-- scripts covers the Earthen Mound, the Foreboding Presence, the Fomor Pioneer or the closing cutscene, so the walk to the
-- end is notes and the completed bit proves the last bullet. The draft put the completion on bullet 6; the page has the
-- Coalition cutscene and reward at bullet 7. Reive unity (key item 2234) is listed as the quest's reward and is not used:
-- a reward key item cannot prove a step, and it is not clear whether bullet 6 or bullet 7 hands it out.
return {
    title = 'Scaredy-Cats',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'after registering with the pioneers coalition'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (the offer at the Pioneers Coalition, option 1)'},
         }},
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'proceed to the eastern half of'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'head southwest to e 10 and'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'once inside head west to e'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'click on it again to spawn'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'click on the foreboding presence one'}},
        {id = 's7', at = {n = 7, fp = 'head back to the pioneers coalition'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
