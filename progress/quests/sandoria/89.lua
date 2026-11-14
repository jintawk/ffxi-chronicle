-- Step progress for Pieuje's Decision (San d'Oria quest 89). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Chateau_dOraguille/npcs/_6h1.lua (the Door: Prince Regent's Rm, event 552, adds the
-- quest on finish with no option to refuse), scripts/zones/FeiYin/Zone.lua (zone-in event 19, only while the quest is
-- accepted and coming from Beaucedine Glacier), scripts/zones/FeiYin/npcs/qm1.lua (the bell pops Altedour I Tavnazia) and
-- scripts/zones/Northern_San_dOria/npcs/Narcheral.lua (692: trading exactly the Tavnazian Mask completes it and gives the
-- Healer's Bliaut). None of these events has a client script or text. The Dark Stalker drop (bullet 2) and the pop and
-- fight (bullet 4) are items and a fight, notes on the trade they feed: the pop message in Fei'Yin proves the bell was
-- traded, not that the NM is dead. The page's repeat ("after a Memory reset") is not modelled.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = "Pieuje's Decision",
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'open door prince regent s rm'},
         done = {
            {t = 'event', zone = 233, event = 552, why = "Door: Prince Regent's Rm 552: adds the quest"},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'go to eldieme necropolis and kill'}},
        {id = 's3', at = {n = 3, fp = 'travel to fei yin and zone'},
         done = {
            {t = 'zonein', zone = 204, event = 19, why = "Fei'Yin zone-in event 19: only while accepted, from Beaucedine"},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'locate the at g 8 on'}},
        {id = 's5', at = {n = 5, fp = 'trade the tavnazian mask to narcheral'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 12640, gained = true, conf = 'inferred', why = "Healer's Bliaut gained (reward)"},
         },
         reach = {{t = 'event', zone = 231, event = 692, why = 'Narcheral 692: plays even with no free slot (the quest then stays open)'}}},
    },
}
