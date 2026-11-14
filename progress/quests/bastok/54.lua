-- Step progress for The Doorman (Bastok quest 54). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/WAR_AF1_The_Doorman.lua (Phara 151 begins the quest at its finish; Davoi Hide
-- Flap 110 plays on every click with both NMs dead and gives Sword grip material 208 only after both are killed, so the event is
-- never proof of the key item; Phara 152 takes the material and starts the one-day wait; Phara 153 gives Yasin's sword 209 after
-- the day; Naji 750 completes and takes the sword); client event script S4 234_Phara_010EA06B.txt (151 say #11037, 152 say
-- #11043, 153 say #11045); 237 Naji 750 has no decoded line; key items from res/key_items.lua. The draft put Phara 152 on the
-- first bullet; it is the hand-in of bullet 4. Bullet 2 (click the Hide Flap) has no signal of its own: event 110 also plays at
-- bullet 3. Repeatable after a Memory reset: the restart is the next 151.
return {
    title = 'The Doorman',
    completes = 's6',
    known = {{t = 'quest'}},
    repeatable = {restart = {'s1'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to phara in bastok mines'},
         done = {
            {t = 'event', zone = 234, event = 151, why = 'Phara 151: the quest offered and begun at its finish'},
            {t = 'chat', re = 'My darling son, may his soul rest in peace, was a warrior, and so was my grandson%.%.%.', why = 'Phara 151 (say #11037)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'go to davoi and click the'}},
        {id = 's3', at = {n = 3, fp = 'kill them then check the hide'},
         done = {
            {t = 'ki', id = 208, gained = true, why = 'sword grip material obtained'},
            {t = 'ki_have', id = 208, have = true, why = 'sword grip material held'},
            {t = 'chat', re = 'obtained key item: sword grip material', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'speak to phara then wait a'},
         done = {
            {t = 'event', zone = 234, event = 152, why = 'Phara 152: the material handed over'},
            {t = 'chat', re = "Well I'll be! You've brought me", why = 'Phara 152 (say #11043)'},
            {t = 'ki', id = 208, gained = false, conf = 'inferred', why = 'sword grip material handed over'},
         }},
        {id = 's5', at = {n = 5, fp = 'speak to phara again for yasin'},
         done = {
            {t = 'event', zone = 234, event = 153, why = 'Phara 153'},
            {t = 'chat', re = "Thanks to you, my son's sword is as good as it was the day it was forged%.", why = 'Phara 153 (say #11045)'},
            {t = 'ki', id = 209, gained = true, why = "Yasin's sword obtained"},
            {t = 'ki_have', id = 209, have = true, why = "Yasin's sword held"},
            {t = 'chat', re = "obtained key item: yasin's sword", why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'speak to naji outside the president'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 209, gained = false, conf = 'inferred', why = "Yasin's sword handed over"},
         },
         reach = {{t = 'event', zone = 237, event = 750, why = 'Naji 750: plays with the sword held (a full bag plays it too, no completion)'}}},
    },
}
