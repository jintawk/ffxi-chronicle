-- Step progress for Guest of Hauteur (Bastok quest 3). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Guest_of_Hauteur.lua (Powhatan 55 is the offer and only option 0 begins the
-- quest; Powhatan 56 plays only while accepted and the letter is not held; Steel Bones 57 plays only with a Maul or Replica
-- Maul in the main slot and no letter, and gives key item 11; Powhatan 58 runs quest:complete and removes the letter only
-- after the completion succeeded); client event scripts S4 236_Powhatan_010EC00E.txt (55 say #7333 on the Yes branch only,
-- 56 say #7335 and the menu answer #7338, 58 say #7340) and 236_Steel_Bones_010EC028.txt (57 say #7489); key item ids from
-- res/key_items.lua (11 Letter from Domien). Bartolomeo plays nothing for this quest (the page says so), so its bullet and the
-- weapon bullet are notes on Steel Bones; the second Powhatan question gates nothing, so its bullet is optional and rests on
-- the client's own answer line.
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish after the
-- cutscene), so it is a reach only and the quest log's completed bit and the letter's removal carries the last step.
-- Shared-signal audit: "Something you didn't understand?" is a substring of Powhatan 51's line in Welcome to Bastok (bastok 2)
-- -> dropped; the log, event 56 and "My guest's name is Domien." carry s1.
return {
    title = 'Guest of Hauteur',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to powhatan to start the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (option 1 declines without it)'},
            {t = 'chat', re = "My guest's name is Domien%.", why = 'Powhatan 55, Yes branch only (say #7333)'},
            {t = 'event', zone = 236, event = 56, conf = 'inferred', why = 'Powhatan 56: only while accepted, before the letter'},
         },
         reach = {{t = 'event', zone = 236, event = 55, why = 'Powhatan 55 offered (its finish needs option 0)'}}},
        {id = 'n2', kind = 'note', with = 's5', at = {n = 2, fp = 'equip either a maul or a'}},
        {id = 'n3', kind = 'note', with = 's5', at = {n = 3, fp = 'speak to bartolomeo in port bastok'}},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'revisit powhatan and select the second'},
         done = {
            {t = 'chat', re = "He must've already arrived!", why = 'Powhatan 56, second question (say #7338)'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to steel bones in port'},
         done = {
            {t = 'ki', id = 11, gained = true, why = 'Letter from Domien obtained'},
            {t = 'ki_have', id = 11, have = true, why = 'Letter from Domien held'},
            {t = 'event', zone = 236, event = 57, why = 'Steel Bones 57: needs a Maul or Replica Maul equipped'},
            {t = 'chat', re = 'An Elvaan knight named Domien%?', why = 'Steel Bones 57 (say #7489)'},
            {t = 'chat', re = 'obtained key item: letter from domien', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to powhatan to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 11, gained = false, why = 'Letter from Domien removed (only after the completion succeeded)'},
         },
         reach = {
            {t = 'event', zone = 236, event = 58, why = 'Powhatan 58: plays even when the reward item does not fit'},
            {t = 'chat', re = "Ah, you're back! Where is Sir Domien%?", why = 'Powhatan 58 (say #7340)'},
         }},
    },
}
