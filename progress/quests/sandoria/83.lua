-- Step progress for Sorcery of the North (San d'Oria quest 83). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Northern_San_dOria/npcs/Eperdur.lua (684 and 685 only after Healing the Land; 685
-- option 0 adds the quest; 686 is his reminder while the tome is missing; 687 takes the Fei'Yin magic tome, gives the
-- Scroll of Teleport-Vahzl and completes it) and scripts/zones/FeiYin/npcs/Treasure_Chest.lua (the chest gives key item
-- 179, only while the quest is accepted); no client event script exists for Eperdur 684-687. Event 684 is the "zone first"
-- dialog and proves nothing. The draft's key item 2884 for the chest key was a mismatch (the key is item 1037, droppable
-- elsewhere), and the key is optional (Thief's Tools open the chest too), so s4 is optional with no signal.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'Sorcery of the North',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone after completing healing the land'}},
        {id = 's2', at = {n = 2, fp = 'speak to eperdur in northern san'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 686, conf = 'inferred', why = 'Eperdur 686: reminder, only while accepted'},
         },
         reach = {{t = 'event', zone = 231, event = 685, why = 'Eperdur 685 offered (its finish needs option 0)'}}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'travel to fei yin to open'}},
        {id = 's4', kind = 'optional', at = {n = 4, fp = 'obtain a fei yin chest key'}, done = {}},
        {id = 's5', at = {n = 5, fp = 'open a treasure chest using either'},
         done = {
            {t = 'ki', id = 179, gained = true, why = "Fei'Yin magic tome obtained"},
            {t = 'ki_have', id = 179, have = true, why = "Fei'Yin magic tome held"},
            {t = 'chat', re = "obtained key item: fei'yin magic tome", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to eperdur to receive your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 179, gained = false, after = 's5', why = "Fei'Yin magic tome handed over (deleted only once the reward is given)"},
            {t = 'item', id = 4747, gained = true, conf = 'inferred', why = 'Scroll of Teleport-Vahzl gained (reward)'},
         },
         reach = {{t = 'event', zone = 231, event = 687, why = 'Eperdur 687: plays even if the reward does not fit'}}},
    },
}
