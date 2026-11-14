-- Step progress for Let Sleeping Dogs Lie (Windurst quest 46). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/windurst/Let_Sleeping_Dogs_Lie.lua. Paku-Nakku 481 is the offer and begins the quest with
-- no option test (Mashuu-Ajuu's 483 is a plain classroom line that plays before and after, so it proves nothing). Maabu-Sonbu 319
-- sets Prog 1 (320 repeats the advice afterwards). Paku-Nakku 494 is the trade: P1 = 1 for the Blazing Peppers (the lines about the
-- smell), no P1 for the Remedy of the page's "Alternate Option"; both set Prog 2. Pechiru-Mashiru 495 plays only at Prog 2 and sets
-- Prog 3 (490 and 492 are his Prog 0 and 1 talks, before the trade, so the draft's use of them for bullet 6 was wrong; 496 is the
-- Prog 3 talk). Paku-Nakku 499 is a menu where only option 2, "The automaton butler did it!", sets Prog 4 (the other answers change
-- nothing), so 499 is `reach`; Prog 4 shows in Paku-Nakku 500 and in the classmates' changed lines (Mashuu-Ajuu 501). Pechiru-Mashiru
-- 497 (Prog 4) runs quest:complete, whose Hypno Staff reward needs a free slot while the event plays regardless, so 497 is `reach`
-- and the completed bit carries the last step. Bullets 3 and 4 (the Sickles, the ???) are directions, notes on the trade; bullet 9 is
-- the alternate-route warning, a trailing note (it takes the last step's state: a note after the last step must not lean on an
-- earlier one, or the checkboxes before it would all show done). Client event scripts S4 238_Paku_Nakku_010EE03F.txt (482 say #8474, 494 say
-- #9248, 499 menu #8512, 500 say #8519), 238_Pechiru_Mashiru_010EE034.txt (495 say #9251, 496 say #8506, 497 say #8508),
-- 238_Mashuu_Ajuu_010EE03D.txt (501 say #8520), 240_Maabu_Sonbu_010F0013.txt (320 say #3952).
return {
    title = 'Let Sleeping Dogs Lie',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to mashuu ajuu k 6'},
         done = {
            {t = 'event', zone = 238, event = 481, why = 'Paku-Nakku 481: the offer, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 238, event = 482, conf = 'inferred', why = 'Paku-Nakku 482: dozing, only while accepted'},
            {t = 'chat', re = '<Nod%.%.%.nod%.%.%.doze%.%.%.>', conf = 'inferred', why = 'Paku-Nakku 482 (say #8474)'},
         }},
        {id = 's2', at = {n = 2, fp = 'next speak to maabu sonbu port'},
         done = {
            {t = 'event', zone = 240, event = 319, why = 'Maabu-Sonbu 319: the advice, sets Prog 1'},
            {t = 'event', zone = 240, event = 320, conf = 'inferred', why = 'Maabu-Sonbu 320: the advice again, only after 319'},
            {t = 'chat', re = 'To awaken someone from a Sleep spell you just have to hit them really hard', conf = 'inferred', why = 'Maabu-Sonbu 320 (say #3952)'},
         }},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'grab some sickles and head to'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'harvest at the at e 5'}},
        {id = 's5', at = {n = 5, fp = 'trade the peppers to paku nakku'},
         done = {
            {t = 'event', zone = 238, event = 494, p = {[1] = 1}, why = 'Paku-Nakku 494, P1 = 1: the Blazing Peppers accepted'},
            {t = 'chat', re = "What's that smell, dude%? My eyes are all itchy and my nose is all twitchy", why = 'Paku-Nakku 494 (say #9248)'},
            {t = 'event', zone = 238, event = 494, conf = 'inferred', why = 'Paku-Nakku 494 without P1: the Remedy of the alternate route accepted'},
         }},
        {id = 's6', at = {n = 6, fp = 'talk to pechiru mashiru'},
         done = {
            {t = 'event', zone = 238, event = 495, why = 'Pechiru-Mashiru 495: only at Prog 2, sets Prog 3'},
            {t = 'chat', re = "I'm sure I negated the Sleep spell", why = 'Pechiru-Mashiru 495 (say #8501)'},
            {t = 'event', zone = 238, event = 496, conf = 'inferred', why = 'Pechiru-Mashiru 496: only at Prog 3'},
            {t = 'chat', re = 'To wake him up right away', conf = 'inferred', why = 'Pechiru-Mashiru 496 (say #8506)'},
         }},
        {id = 's7', at = {n = 7, fp = 'talk to paku nakku again'},
         done = {
            {t = 'event', zone = 238, event = 500, why = 'Paku-Nakku 500: only after the right answer (Prog 4)'},
            {t = 'chat', re = 'I hate you sooo much, dude!', why = 'Paku-Nakku 500 (say #8519)'},
            {t = 'event', zone = 238, event = 501, conf = 'inferred', why = 'Mashuu-Ajuu 501: the class line of Prog 4'},
            {t = 'chat', re = "What's all the noise about%?", conf = 'inferred', why = 'Mashuu-Ajuu 501 (say #8520)'},
         },
         reach = {{t = 'event', zone = 238, event = 499, why = 'Paku-Nakku 499 offered (only option 2 moves on)'}}},
        {id = 's8', at = {n = 8, fp = 'finally speak to pechiru mashiru for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 238, event = 497, why = 'Pechiru-Mashiru 497: the finish (also plays with a full bag, when the reward fails)'},
            {t = 'chat', re = 'Did Paku%-Nakku yell at you%?', why = 'Pechiru-Mashiru 497 (say #8508)'},
         }},
        {id = 's9', kind = 'note', with = 's8', at = {n = 9, fp = 'after trading the remedy it will'}},
    },
}
