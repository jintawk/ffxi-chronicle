-- Step progress for Blade of Death (Bastok quest 47). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Blade_of_Death.lua (Gumbah 130 begins the quest and gives the Letter from Zeid
-- on finish, no refusal branch; trading the Chaosbringer to the Gusgen Mines ??? is event 10, which needs the kill count and
-- runs quest:complete, then takes the letter); client event script S4 234_Gumbah_010EA004.txt (130 say #10957); key item id
-- from res/key_items.lua (170 letter from Zeid). Event 10 has no decoded client script (LandSandBoat only), so the quest log
-- and the loss of the letter carry the last step as well. The draft put the Zeruhn Mines zone-in cutscene (131, which hands
-- out the Chaosbringer) and the Chaosbringer itself on the last step; both come before the kill bullet and belong to no
-- bullet, so they are dropped. Event 10 also plays when the reward item (Deathbringer) cannot be given, so it is `reach`;
-- the quest log and the loss of the letter (deleted only after the completion succeeded) prove the step. The kill bullet is a note on the trade: the kill count is a server variable. Not repeatable.
return {
    title = 'Blade of Death',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to gumbah to receive the'},
         done = {
            {t = 'event', zone = 234, event = 130, why = 'Gumbah 130: the quest begun, the letter given'},
            {t = 'chat', re = 'He wrote you a letter%. I think he meant for Werei to give it to you', why = 'Gumbah 130 (say #10957)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 170, gained = true, why = 'letter from Zeid obtained'},
            {t = 'ki_have', id = 170, have = true, why = 'letter from Zeid held'},
            {t = 'chat', re = 'obtained key item: letter from zeid', why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'use the chaosbringer to slay 100'}},
        {id = 's3', at = {n = 3, fp = 'go to gusgen mines and trade'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 170, gained = false, after = 's1', why = 'letter from Zeid taken (only after the completion succeeded)'},
         },
         reach = {{t = 'event', zone = 196, event = 10, why = 'Gusgen Mines ??? 10: plays even when the Deathbringer does not fit, so it is not proof'}}},
    },
}
