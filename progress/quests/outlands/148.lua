-- Step progress for Trial-Size Trial by Water (Outlands quest 148). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Norg/npcs/Verctissa.lua (199 is the offer, a menu: option 1 adds the quest and the Mini Tuning
-- Fork of Water only with a free slot, and the line "The researcher who made the" plays on any yes, so the quest log's current
-- bit is the proof; 111 is the reminder with the fork held and 203 the fork-lost offer; 200 is the fork trade that teleports to
-- the Cloister of Tides on option 1, so it plays on a refusal too; 202 plays once the quest is done) and
-- battlefields/Cloister_of_Tides/trial-size_trial_by_water.lua (the Water Protocrystal trade enters the arena; the win teaches
-- Leviathan and completes the quest). Client event script S4 252_Verctissa_010FC05A.txt (199 accept branch say #10540). The
-- arena entry and the fight have no event or key item of their own, so bullets 2 and 3 are notes on the completion; the log's
-- completed bit proves bullet 4. The quest log is set at s1, so it is not silent. Repeating the fight needs no new marker
-- (the quest stays completed), so there is no `repeatable` entry.
-- Draft corrections: the draft put the whole quest on s1 (completes = s1); it now has an accept step and a completion step.
return {
    title = 'Trial-Size Trial by Water',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with verctissa in norg h'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Verctissa 199, option 1, fork given)'},
            {t = 'event', zone = 252, event = 111, conf = 'inferred', why = 'Verctissa 111: reminder with the fork held, only while accepted'},
            {t = 'chat', re = "If you don't prepare yourself for battle, you'll get beaten to a pulp, like we did!", conf = 'inferred', why = 'Verctissa 111 (say #10467)'},
            {t = 'event', zone = 252, event = 203, conf = 'inferred', why = 'Verctissa 203: the fork-lost offer, only while accepted'},
         },
         reach = {{t = 'event', zone = 252, event = 199, why = 'Verctissa 199 offered (its finish needs option 1 and a free slot)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you may prepare for the upcoming'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'trade the fork to the water'}},
        {id = 's4', at = {n = 4, fp = 'defeat leviathan prime to complete quest'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (battlefield win)'},
            {t = 'event', zone = 252, event = 202, after = 's1', conf = 'inferred', why = 'Verctissa 202: his talk once the quest is done'},
         }},
    },
}
