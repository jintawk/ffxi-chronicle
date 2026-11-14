-- Step progress for To Cure a Cough (San d'Oria quest 20). Data only; see progress/quests/sandoria/27.lua for the format.
-- From the research pilot's hand mapping (checked against Logger chat logs of
-- 2026-10-18/19), reviewed against the draft. The quest log stays silent until Amaura (s3) adds the quest, so Nenne's talk
-- and the diary are seen only through events and dialogue; it is completed at Nenne (s5), two bullets before the page ends.
-- Evidence: LandSandBoat scripts/zones/Southern_San_dOria/npcs/{Nenne,Amaura,Diary}.lua (Nenne 538 first talk, 647 reward
-- and completion; Amaura 645 adds the quest, 646 swaps the moss for the medicine; Diary 641 page 3 needs option 3, 722 is
-- page 4 and needs page 3 read), zones/Davoi/npcs/qm1.lua (thyme moss), zones/East_Ronfaure/npcs/Signpost.lua (event 20 takes
-- the scroll for 3,000 gil); client event scripts S4 230_Nenne_010E601C.txt, 230_Amaura_010E601F.txt, 230_Diary_010E6086.txt;
-- key items from res/key_items.lua (153 thyme moss, 154 cough medicine, 155 scroll of treasure). The post bullet comes
-- after completion by design. The pilot's chat line for the signpost ("You find a cloth sack...") exists only in the Logger
-- log, in no decoded client or LandSandBoat text, so check_steps could not verify it and it is not used; the "scroll leads
-- you to the signpost" bullet (n=6) has no signal of its own and is a note on n=7.
-- Shared-signal audit (2026-10-28): the Diary (events 641 and 722 and its page 3 line) is read by any player and is part of A Squire's Test II and The Medicine Woman as well, so s2 is shared with those, gated after s1 (Nenne 538, unique to this quest).
return {
    title = 'To Cure a Cough',
    completes = 's5',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to nenne southern san d'},
         done = {
            {t = 'event', zone = 230, event = 538, why = 'Nenne 538'},
            {t = 'chat', re = "Who are you%? If you're looking for my son", why = 'Nenne 538 (say #8094)'},
         }},
        {id = 's2', at = {n = 2, fp = 'once you have heard nenne s'},
         done = {
            {t = 'chat', re = 'A traveler told me the other day that a certain kind of moss', after = 's1', why = 'Diary 641, page 3 (print #7971)'},
            {t = 'event', zone = 230, event = 722, after = 's1', conf = 'inferred', why = 'Diary 722: page 4, only once page 3 is read'},
         },
         reach = {{t = 'event', zone = 230, event = 641, after = 's1', why = 'Diary 641 offers page 3 (640 hides it)'}}},
        {id = 's3', at = {n = 3, fp = 'speak to amaura g 6 who'},
         done = {
            {t = 'event', zone = 230, event = 645, why = 'Amaura 645: adds the quest'},
            {t = 'chat', re = "If ye need somethin' for coughs, bring me that", why = 'Amaura 645 (say #7978)'},
            {t = 'quest', current = true, why = 'quest log: accepted (Amaura 645 adds the quest)'},
            {t = 'ki', id = 153, gained = true, why = 'thyme moss obtained from the Davoi ???'},
            {t = 'ki_have', id = 153, have = true, why = 'thyme moss held'},
         }},
        {id = 's4', at = {n = 4, fp = 'return the moss to amaura who'},
         done = {
            {t = 'event', zone = 230, event = 646, why = 'Amaura 646'},
            {t = 'chat', re = 'Oooh! This is it! This is the moss!', why = 'Amaura 646 (say #7984)'},
            {t = 'ki', id = 154, gained = true, why = 'cough medicine obtained'},
            {t = 'ki_have', id = 154, have = true, why = 'cough medicine held'},
            {t = 'ki', id = 153, gained = false, conf = 'inferred', why = 'thyme moss handed over'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to nenne who will give'},
         done = {
            {t = 'event', zone = 230, event = 647, why = 'Nenne 647'},
            {t = 'chat', re = 'But I have little money%. Here, this belonged to my late husband%.', why = 'Nenne 647 (say #7989)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 155, gained = true, conf = 'inferred', why = 'scroll of treasure obtained (reward)'},
            {t = 'ki', id = 154, gained = false, conf = 'inferred', why = 'cough medicine handed over'},
         }},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'the scroll leads you to the'}},
        {id = 's7', kind = 'post', at = {n = 7, fp = 'examine the signpost for 3 000'},
         done = {
            {t = 'event', zone = 101, event = 20, after = 's5', why = 'Signpost 20: the scroll for 3,000 gil'},
            {t = 'ki', id = 155, gained = false, after = 's5', why = 'scroll of treasure handed over'},
         }},
    },
}
