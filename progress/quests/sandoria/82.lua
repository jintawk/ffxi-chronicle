-- Step progress for Healing the Land (San d'Oria quest 82). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Eperdur.lua (681 option 0 adds the quest and gives the Seal of
-- banishing, key item 177; 682 is his reminder while the seal is held; 683 completes it once the seal is gone) and
-- scripts/zones/Gusgen_Mines/npcs/qm3.lua (the ??? takes the seal and says FOUND_LOCATION_SEAL, IDs.lua 7408); client event
-- scripts S4 231_Eperdur_010E70AE.txt (683 say #12195); key item and item ids from res/. Eperdur's line #12193 plays in
-- both 681 (offer, even refused) and 682, so it proves nothing. The directions bullet (n=3) ends at the Gusgen ???, which
-- takes the seal: key item 177 lost, after the quest was accepted, proves it. The quest log is set at s1, so it is not silent.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'Healing the Land',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with eperdur at m 7'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 177, gained = true, why = 'seal of banishing obtained'},
            {t = 'ki_have', id = 177, have = true, why = 'seal of banishing held'},
            {t = 'chat', re = 'obtained key item: seal of banishing', why = 'chat: key item obtained'},
            {t = 'event', zone = 231, event = 682, conf = 'inferred', why = 'Eperdur 682: reminder, only while accepted with the seal'},
         },
         reach = {{t = 'event', zone = 231, event = 681, why = 'Eperdur 681 offered (its finish needs option 0)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to gusgen mines from konschtat'}},
        {id = 's3', at = {n = 3, fp = 'follow these directions to reach the'},
         done = {
            {t = 'chat', re = 'You have found the location of the seal%.', why = 'Gusgen Mines ???: the seal placed (IDs.lua 7408)'},
            {t = 'ki', id = 177, gained = false, after = 's1', why = 'seal of banishing placed at the ???'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak with eperdur again for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 4730, gained = true, conf = 'inferred', why = 'Scroll of Teleport-Holla gained (reward)'},
         },
         reach = {
            {t = 'event', zone = 231, event = 683, why = 'Eperdur 683: plays even if the reward does not fit (giveItem fails after it)'},
            {t = 'chat', re = 'You have returned! Word is that you strengthened the seal with the', why = 'Eperdur 683 (say #12195), same'},
         }},
    },
}
