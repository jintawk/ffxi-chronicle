-- Step progress for A Timely Visit (San d'Oria quest 105). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Timely_Visit.lua (Deraquien 33 or 47 offers it and the finish needs
-- option 1; every later step is a progressEvent that sets Prog: Narvecaint 0 -> 1, Deraquien 80 -> 2, Halver 112 -> 3,
-- Deraquien 87 -> 4, Phillone 78 -> 5, Deraquien 38 -> Stage 1, Jugner qm1 18 -> 6, Phillone 21 -> 7, Narvecaint 1 -> 8,
-- Phillone 14 completes; 34, 6, 20, 7, 30, 91, 27 and 48 are reminders that only play from their Prog on); client event
-- scripts S4 230_Deraquien_010E6022.txt (47 say #9398 on the accept branch only, 34 #9400, 20 #9419, 30 #9438, 27 #9512),
-- 102_Narvecaint_0106625E.txt (6 #7745, 7 #7746), 230_Phillone_010E6023.txt (91 #9477, 48 #9511). The draft put Jugner
-- event 18 (the cutscene after the NMs die) on the spawn bullet and Phillone 48 (Stage 1 reminder) on the cutscene bullet:
-- 18 belongs to bullet 10 and 48 only says bullet 7 is done. The spawn bullet (9) rests on the Jugner text "A sense of
-- foreboding fills the air..." (IDs.lua SENSE_OF_FOREBODING, used by this quest alone in that zone); bullet 8 is travel.
-- Shared-signal audit: the pop line 'A sense of foreboding fills the air' is shared with every other ??? pop (32 zone texts), gated after s7 (Deraquien 38, unique).
return {
    title = 'A Timely Visit',
    completes = 's13',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to deraquien for a cutscene'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'chat', re = 'Then you must make haste for La Theine Plateau%.', why = 'Deraquien 47, accepted (say #9398)'},
            {t = 'event', zone = 230, event = 34, conf = 'inferred', why = 'Deraquien 34: reminder, only once accepted'},
            {t = 'chat', re = "You've forgotten already%?", conf = 'inferred', why = 'Deraquien 34 (say #9400)'},
         },
         reach = {{t = 'event', zone = 230, event = 33, why = 'Deraquien 33 offered (its finish needs option 1)'},
                  {t = 'event', zone = 230, event = 47, why = 'Deraquien 47 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'go to la theine plateau and'},
         done = {
            {t = 'event', zone = 102, event = 0, why = 'Narvecaint 0'},
            {t = 'event', zone = 102, event = 6, conf = 'inferred', why = 'Narvecaint 6: reminder, Prog 1 or 2'},
            {t = 'chat', re = 'Sir Elmemague has taken the suspect to the chateau for questioning', conf = 'inferred', why = 'Narvecaint 6 (say #7745)'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to deraquien and speak to'},
         done = {
            {t = 'event', zone = 230, event = 80, why = 'Deraquien 80'},
            {t = 'event', zone = 230, event = 20, conf = 'inferred', why = 'Deraquien 20: reminder, Prog 2'},
            {t = 'chat', re = 'If the man they caught is really the burglar, you will be eligible for a reward from Monarlais Halver%.', conf = 'inferred', why = 'Deraquien 20 (say #9419)'},
         }},
        {id = 's4', at = {n = 4, fp = 'head to chateau d oraguille and'},
         done = {
            {t = 'event', zone = 233, event = 112, why = 'Halver 112'},
            {t = 'event', zone = 102, event = 7, conf = 'inferred', why = 'Narvecaint 7: reminder, from Prog 3'},
            {t = 'chat', re = 'We have received a report from Sir Elmemague that the suspect we apprehended', conf = 'inferred', why = 'Narvecaint 7 (say #7746)'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to deraquien again'},
         done = {
            {t = 'event', zone = 230, event = 87, why = 'Deraquien 87'},
            {t = 'event', zone = 230, event = 30, conf = 'inferred', why = 'Deraquien 30: reminder, Prog 4'},
            {t = 'chat', re = 'Could you go and find out more about the lady who calls herself Phillone%?', conf = 'inferred', why = 'Deraquien 30 (say #9438)'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to phillone d 7'},
         done = {
            {t = 'event', zone = 230, event = 78, why = 'Phillone 78'},
            {t = 'event', zone = 230, event = 91, conf = 'inferred', why = 'Phillone 91: reminder, Prog 5'},
            {t = 'chat', re = 'Find a knight of caliber to save my family from this looming disaster', conf = 'inferred', why = 'Phillone 91 (say #9477)'},
         }},
        {id = 's7', at = {n = 7, fp = 'go back to speak with deraquien'},
         done = {
            {t = 'event', zone = 230, event = 38, why = 'Deraquien 38'},
            {t = 'event', zone = 230, event = 27, conf = 'inferred', why = 'Deraquien 27: reminder, only from Stage 1'},
            {t = 'chat', re = 'That lady had nothing to do with the theft%?', conf = 'inferred', why = 'Deraquien 27 (say #9512)'},
            {t = 'event', zone = 230, event = 48, conf = 'inferred', why = 'Phillone 48: reminder, Stage 1 before the NMs'},
            {t = 'chat', re = 'My brother has hidden the scepter somewhere in the vast forest', conf = 'inferred', why = 'Phillone 48 (say #9511)'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'head to jugner forest through king'}},
        {id = 's9', at = {n = 9, fp = 'click on the at f 5'},
         done = {
            {t = 'chat', re = 'A sense of foreboding fills the air', after = 's7', why = 'Jugner ???: the NMs spawn (text 8035)'},
         }},
        {id = 's10', at = {n = 10, fp = 'once defeated click on the again'},
         done = {
            {t = 'event', zone = 104, event = 18, why = 'Jugner ??? 18: the cutscene after the NMs'},
         }},
        {id = 's11', at = {n = 11, fp = 'return to phillone for a cutscene'},
         done = {
            {t = 'event', zone = 230, event = 21, why = 'Phillone 21'},
         }},
        {id = 's12', at = {n = 12, fp = 'speak to narvecaint f 7 in'},
         done = {
            {t = 'event', zone = 102, event = 1, why = 'Narvecaint 1'},
         }},
        {id = 's13', at = {n = 13, fp = 'return to phillone to receive your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 14, why = 'Phillone 14: plays even when the Medieval Collar does not fit, so it is not proof'}}},
    },
}
