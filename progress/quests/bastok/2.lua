-- Step progress for Welcome to Bastok (Bastok quest 2). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Welcome_to_Bastok.lua (Powhatan 50 is the offer and only option 0 begins the
-- quest; Powhatan 51 plays only while accepted with Prog 0; Bartolomeo 52 plays only with a Shell Shield in the sub slot and
-- Prog 0, and sets Prog 1; Powhatan 53 runs quest:complete); client event scripts S4 236_Powhatan_010EC00E.txt (50 say #7320
-- plays on the Yes branch only, 51 say #7322, 53 say #7327) and 236_Bartolomeo_010EC013.txt (52 say_as #7373). The shield
-- and slot bullets lead into the steps they prepare: obtaining one into the start, equipping it into Bartolomeo.
-- Completion: the final event also plays when the item reward cannot be given (npcUtil.completeQuest fails in onEventFinish after the
-- cutscene), so it is a reach only and the quest log's completed bit carries the last step.
return {
    title = 'Welcome to Bastok',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 'n1', kind = 'note', with = 's3', at = {n = 1, fp = 'obtain a shell shield either via'}},
        {id = 'n2', kind = 'note', with = 's3', at = {n = 2, fp = 'you will notice that only levels'}},
        {id = 's3', at = {n = 3, fp = 'speak to powhatan to start the'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (option 1 declines without it)'},
            {t = 'chat', re = "My guest's name is Evrain%.", why = 'Powhatan 50, Yes branch only (say #7320)'},
            {t = 'event', zone = 236, event = 51, conf = 'inferred', why = 'Powhatan 51: only while accepted with Prog 0'},
            {t = 'chat', re = "Was there something you didn't understand%?", conf = 'inferred', why = 'Powhatan 51 (say #7322)'},
         },
         reach = {{t = 'event', zone = 236, event = 50, why = 'Powhatan 50 offered (its finish needs option 0)'}}},
        {id = 'n4', kind = 'note', with = 's5', at = {n = 4, fp = 'equip the shield'}},
        {id = 's5', at = {n = 5, fp = 'speak to bartolomeo in port bastok'},
         done = {
            {t = 'event', zone = 236, event = 52, why = 'Bartolomeo 52: needs the Shell Shield equipped'},
            {t = 'chat', re = "No%? You've come in his place%?", why = 'Bartolomeo 52 (say_as #7373)'},
         }},
        {id = 's6', at = {n = 6, fp = 'after the cutscene return to powhatan'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 236, event = 53, why = 'Powhatan 53: plays even when the reward item does not fit'},
            {t = 'chat', re = 'Thanks to you, I was able to meet Mister Evrain!', why = 'Powhatan 53 (say #7327)'},
         }},
    },
}
