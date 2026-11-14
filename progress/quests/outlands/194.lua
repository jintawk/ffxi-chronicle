-- Step progress for Trial by Wind (Outlands quest 194). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Rabao/npcs/Agado-Pugado.lua (66 is the offer and the restart: its finish gives the Tuning
-- fork of wind and begins the quest only on option 1, so it also plays on a refusal; 107 re-gives a lost fork; 67 is his talk
-- while the fork is held and the whisper not; 69 is the reward menu once the Whisper of gales is held, and it runs
-- completeQuest only for a valid choice with a free slot, so it plays on a refusal and a cancel; 86 to 88 are Carbuncle Debacle's
-- lines on the same NPC and are not used); scripts/battlefields/Cloister_of_Gales/trial_by_wind.lua (entry needs the fork; the
-- win gives the Whisper of gales). The client event script S4 247_Agado_Pugado_010F7030.txt holds only 86 to 88, so there are
-- no chat lines for this quest. The cloister travel bullet is a note on the battle step. Repeatable once per earth day: a
-- fork gained after a finished run opens the next one; the quest log and held key items count for the first run only. The
-- Notes section stays plain.
return {
    title = 'Trial by Wind',
    completes = 's4',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak with agado pugado to obtain'},
         done = {
            {t = 'ki', id = 331, gained = true, why = 'Tuning fork of wind obtained'},
            {t = 'chat', re = 'obtained key item: tuning fork of wind', why = 'chat: key item obtained'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'ki_have', id = 331, have = true, run1 = true, why = 'Tuning fork of wind held'},
            {t = 'event', zone = 247, event = 67, conf = 'inferred', run1 = true, why = 'Agado-Pugado 67: his talk, fork held and no whisper yet'},
         },
         reach = {{t = 'event', zone = 247, event = 66, why = 'Agado-Pugado 66 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to cape teriggan f 5'}},
        {id = 's3', at = {n = 3, fp = 'defeat garuda prime and you will'},
         done = {
            {t = 'ki', id = 323, gained = true, why = 'Whisper of gales obtained (the win)'},
            {t = 'chat', re = 'obtained key item: whisper of gales', why = 'chat: key item obtained'},
            {t = 'ki_have', id = 323, have = true, run1 = true, why = 'Whisper of gales held'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to agado pugado with the'},
         done = {
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'ki', id = 323, gained = false, conf = 'inferred', why = 'Whisper of gales handed over'},
         },
         reach = {{t = 'event', zone = 247, event = 69, after = 's3', why = 'Agado-Pugado 69: the reward menu (also on a cancel or a full bag)'}}},
    },
}
