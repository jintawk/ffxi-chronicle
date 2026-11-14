-- Step progress for A Job for the Consortium (San d'Oria quest 67). Data only; see progress/quests/sandoria/27.lua for the format.
-- Repeatable (page meta): the same quest goes round again from Portaure, and retail keeps the log bits set (see the Siren's
-- Tear mapping), so the log bits count for the first run only and a new Brugaire goods opens the next run.
-- Evidence: LandSandBoat scripts/quests/sandoria/A_Job_for_the_Consortium.lua (Portaure 651 option 1 gives key item 159 and
-- begins the quest; 652 is his reminder; Haubijoux or _6u2 event 54 is customs, the goods may be confiscated; Yin Pocanakhu
-- 218 (goods damaged, customs skipped) or 219 delivers and takes the goods; Portaure 653, 654 or 655 completes). Portaure 571
-- is a one-time chat before the offer and 651's "Hear what he has to say" lines play before the menu, so neither proves the
-- accept; "That's what I like to hear!" (say #7858) plays only on the accept branch. Client event scripts S4
-- 232_Portaure_010E8011.txt, 245_Yin_Pocanakhu_010F500C.txt (218 say #7699, 219 say #7698), 246_Haubijoux_010F600B.txt
-- (event 54 is a cutscene with no line). 653-655 are not in the decoded client scripts: LandSandBoat names them. Key item 159
-- (res/key_items.lua) is lost at Haubijoux when confiscated and at Yin, so its loss proves neither step. The Yin bullet is a
-- branch: a confiscated run goes straight back to Portaure. Bullets 7-9 (fame, update history, link) are not steps.
-- Shared-signal audit (2026-10-28): event 54 in Port Jeuno is also the default talk of Haubijoux, _6u2 and Roupatour for everyone, so s4 is shared with those NPCs, gated after s1 (quest log accepted, first run).
return {
    title = 'A Job for the Consortium',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to portaure in the cargo'},
         done = {
            {t = 'ki', id = 159, gained = true, why = 'Brugaire goods obtained'},
            {t = 'ki_have', id = 159, have = true, why = 'Brugaire goods held'},
            {t = 'chat', re = "That's what I like to hear!", why = 'Portaure 651, accepted (say #7858)'},
            {t = 'chat', re = 'obtained key item: brugaire goods', why = 'chat: key item obtained'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only)'},
            {t = 'event', zone = 232, event = 652, conf = 'inferred', why = 'Portaure 652: reminder, only once accepted'},
            {t = 'chat', re = 'Just make the delivery to Yin Pocanakhu at the Tenshodo in Jeuno%.', conf = 'inferred', why = 'Portaure 652 (say #7861)'},
         },
         reach = {{t = 'event', zone = 232, event = 651, why = 'Portaure 651 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'note to guarantee going through customs'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'travel to port jeuno'}},
        {id = 's4', at = {n = 4, fp = 'speak to haubijoux at the air'},
         done = {
            {t = 'event', zone = 246, event = 54, after = 's1', why = 'Haubijoux or _6u2 54: customs'},
         }},
        {id = 's5', kind = 'branch', at = {n = 5, fp = 'if you cleared customs go to'},
         done = {
            {t = 'event', zone = 245, event = 219, why = 'Yin Pocanakhu 219: delivered'},
            {t = 'event', zone = 245, event = 218, why = 'Yin Pocanakhu 218: delivered, goods damaged'},
            {t = 'chat', re = 'Hey, you made it through!', why = 'Yin Pocanakhu 219 / 218 (say #7698 / #7699)'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to portaure for your reward'},
         done = {
            {t = 'event', zone = 232, event = 653, why = 'Portaure 653: completes, delivered'},
            {t = 'event', zone = 232, event = 654, why = 'Portaure 654: completes, confiscated'},
            {t = 'event', zone = 232, event = 655, why = 'Portaure 655: completes, damaged'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
         }},
    },
}
