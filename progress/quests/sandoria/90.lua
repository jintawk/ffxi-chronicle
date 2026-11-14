-- Step progress for Sharpening the Sword (San d'Oria quest 90). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Sharpening_the_Sword.lua (Ailbeche 45 or 43 option 1 begins the quest; 42 is
-- his reminder, only while accepted and before the Ordelle whetstone; Sobane 52 is a hint talk while accepted; the Ordelle's
-- Caves Stalagmite gives key item 233 once Polevik is dead; 44, with the whetstone held, completes the quest, takes the
-- whetstone and gives the Honor Sword); client event scripts S4 231_Ailbeche_010E7009.txt (42 say #12426, 44 say #12427) and
-- 230_Sobane_010E601A.txt (52 say #9263); key item id from res/key_items.lua. Ailbeche 45 and 43 play their lines on a
-- refusal too, so only the quest log's current bit and the reminder prove s2. The draft put the whetstone on s2: it is
-- obtained at bullet 7. The quest is repeatable (page meta): a new run is told apart by a new whetstone, and the talks
-- before it are not needed on a repeat (the hint talks are optional in LandSandBoat). The quest log's bits are first-run
-- only because retail keeps the current bit after completion.
-- Completion events that giveItem/complete in onEventFinish play whether or not the reward fits (no separate refusal event), so they are reach only and the completed bit / key item loss proves the step.
return {
    title = 'Sharpening the Sword',
    completes = 's8',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s7'}, skip = {'s2', 's3'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'in order to start this quest'}},
        {id = 's2', at = {n = 2, fp = 'speak with ailbeche near home point'},
         done = {
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
            {t = 'event', zone = 231, event = 42, conf = 'inferred', why = 'Ailbeche 42: reminder, only while accepted without the whetstone'},
            {t = 'chat', re = 'I wish I could tell you where', conf = 'inferred', why = 'Ailbeche 42 (say #12426)'},
         },
         reach = {{t = 'event', zone = 231, event = 45, why = 'Ailbeche 45 offered (its finish needs option 1)'},
                  {t = 'event', zone = 231, event = 43, why = 'Ailbeche 43 offered (its finish needs option 1)'}}},
        {id = 's3', at = {n = 3, fp = 'talk to sobane in d 6'},
         done = {
            {t = 'event', zone = 230, event = 52, why = 'Sobane 52: only while accepted'},
            {t = 'chat', re = 'What does one use to sharpen a knife%?', why = 'Sobane 52 (say #9263)'},
         }},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'enter ordelle s caves from the'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'take the first left and walk'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'examine the stalagmite in the circular'}},
        {id = 's7', at = {n = 7, fp = 'defeat the polevik then examine the'},
         done = {
            {t = 'ki', id = 233, gained = true, why = 'Ordelle whetstone obtained'},
            {t = 'ki_have', id = 233, have = true, why = 'Ordelle whetstone held'},
            {t = 'chat', re = 'obtained key item: ordelle whetstone', why = 'chat: key item obtained'},
         }},
        {id = 's8', at = {n = 8, fp = 'return to ailbeche to end the'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed'},
            {t = 'ki', id = 233, gained = false, after = 's7', why = 'Ordelle whetstone handed over (deleted only when the quest completes)'},
         },
         reach = {
            {t = 'event', zone = 231, event = 44, why = 'Ailbeche 44: plays even if the reward does not fit'},
            {t = 'chat', re = 'Thank you%. Here, this is for you%.', why = 'Ailbeche 44 (say #12427), same'},
         }},
    },
}
