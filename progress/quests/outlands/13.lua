-- Step progress for Cloak and Dagger (Outlands quest 13). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Cloak_and_Dagger.lua. Jakoh Wahcondalo 279 is the offer (no menu), but it
-- begins the quest and gives the Weapon training guide (KI 343) only when the Dagger of Trials fits in the bag, so the log's
-- current bit proves the accept and 279 only reaches it; the guide is the KI of every weapon skill quest (Bastok, San d'Oria,
-- Jeuno and Outlands), so it proves nothing. 280 is his reminder while no map is held (its menu has an abandon option, so it
-- is only inferred). Breaking the latent (bullets 3 to 5, indented) leaves no trace of its own and is part of bullet 2. 281 is
-- the refused trade (under 300 points) and is not used; 282 is the accepted dagger, gives the Map to the Annals of Truth (KI
-- 344); 283 is his reminder while the map is held. The Baronial Bat fight and the second ??? examine give the Annals of Truth
-- (KI 345, "You sense an ominous presence..." is the pop message and plays even on a lost fight, so not used). 284 runs
-- quest:complete, takes the three key items and teaches Evisceration (Kazham IDs.lua EVISCERATION_LEARNED). Client event
-- script S4 250_Jakoh_Wahcondalo_010FA008.txt (279 say #10650, 280 say #10657, 282 say #10667, 283 say #10670, 284 say #10671).
-- The quest log is set at s2, so it is not silent. Not repeatable (the page says nothing about repeating).
return {
    title = 'Cloak and Dagger',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with jakoh wahcondalo j 9'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Jakoh Wahcondalo 279, dagger and guide given)'},
            {t = 'event', zone = 250, event = 280, conf = 'inferred', why = 'Jakoh Wahcondalo 280: his reminder, only while accepted without the map'},
            {t = 'chat', re = "If you want to learn my new technique, you're going to have to train with that daggerrr%.", conf = 'inferred', why = 'Jakoh Wahcondalo 280 (say #10657)'},
         },
         reach = {
            {t = 'event', zone = 250, event = 279, why = 'Jakoh Wahcondalo 279 offered (begins only with room for the dagger)'},
            {t = 'chat', re = "I'm not one to brrrag, but I, too, am quite skilled with knives%.", why = 'Jakoh Wahcondalo 279 (say #10650)'},
         }},
        {id = 's6', at = {n = 6, fp = 'trade the dagger of trials back'},
         done = {
            {t = 'event', zone = 250, event = 282, why = 'Jakoh Wahcondalo 282: the finished dagger accepted (281 is the unfinished one)'},
            {t = 'chat', re = "Ah, so you're finally done%.", why = 'Jakoh Wahcondalo 282 (say #10667)'},
            {t = 'ki', id = 344, gained = true, why = 'map to the Annals of Truth obtained'},
            {t = 'ki_have', id = 344, have = true, why = 'map to the Annals of Truth held'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', why = 'chat: key item obtained'},
            {t = 'event', zone = 250, event = 283, conf = 'inferred', why = 'Jakoh Wahcondalo 283: his reminder, only while the map is held'},
            {t = 'chat', re = 'Now get out of here! The quicker you get back from the Gustav Tunnel, the quicker I can start prrracticing!', conf = 'inferred', why = 'Jakoh Wahcondalo 283 (say #10670)'},
         }},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'take silent oils and prism powders'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'head north and hug the east'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'the spawn is near the intersection'}},
        {id = 's10', at = {n = 10, fp = 'this fight is against baronial bat'},
         done = {
            {t = 'ki', id = 345, gained = true, why = 'Annals of Truth obtained'},
            {t = 'ki_have', id = 345, have = true, why = 'Annals of Truth held'},
            {t = 'chat', re = 'obtained key item: annals of truth', why = 'chat: key item obtained'},
         },
         reach = {{t = 'ki_have', id = 344, have = true, after = 's6', why = 'map to the Annals of Truth still held'}}},
        {id = 's11', at = {n = 11, fp = 'go back and speak with jakoh'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 250, event = 284, why = 'Jakoh Wahcondalo 284: runs quest:complete'},
            {t = 'chat', re = "You're finally back! Congrrratulations on taking out the monster in the tunnel%.", why = 'Jakoh Wahcondalo 284 (say #10671)'},
            {t = 'chat', re = 'You have learned the weapon skill Evisceration!', why = 'Kazham EVISCERATION_LEARNED (quest:complete)'},
            {t = 'ki', id = 345, gained = false, after = 's10', conf = 'inferred', why = 'Annals of Truth handed over'},
         }},
    },
}
