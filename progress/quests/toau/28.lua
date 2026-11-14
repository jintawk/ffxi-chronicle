-- Step progress for Operation Teatime (Aht Urhgan quest 28). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat zones/Aht_Urhgan_Whitegate/npcs/Iruki-Waraki.lua, zones/Nashmau/npcs/Dnegan.lua and
-- zones/Caedarva_Mire/npcs/qm10.lua (old-style scripts, no quest file): Iruki-Waraki 778 is the offer, no option, and begins the
-- quest (the shopping list of bullet 3 and the any-job remark of bullet 4 belong to it); trading the Chai and the Sleeping Potion
-- plays 780 at Prog 1 and sets Prog 2 (779 and 781 are his reminders); Dnegan 290 at Prog 2 is a menu whose option 1 moves on and
-- option 0 only waits a day, so it plays on a refusal and proves nothing: bullets 6 to 9 (the Dnegan and tea shop cutscenes) are
-- notes on the next step; the Caedarva Mire ??? at K-6 plays 15 only at Prog 3 and runs completeQuest with Puppetry Churidars (item
-- 15602) as reward, so a full bag replays 15 and only the completed bit proves the last bullet, while the click itself (bullet 17)
-- is proved by 15. The Arrapago Reef route bullets (10 to 16) have no signal and are notes. Events 15 (Mire), 778 and 780 (Whitegate)
-- are used by no other script. Not repeatable. No client event script has text for these events.
return {
    title = 'Operation Teatime',
    completes = 's18',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'must zone after previous quest in'}},
        {id = 's2', at = {n = 2, fp = 'speak with iruki waraki in aht'},
         done = {
            {t = 'event', zone = 50, event = 778, why = 'Iruki-Waraki 778: plays while available, begins the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'he gives you a shopping list'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'you can be on any job'}},
        {id = 's5', at = {n = 5, fp = 'return to iruki waraki and trade'},
         done = {
            {t = 'event', zone = 50, event = 780, why = 'Iruki-Waraki 780: the Chai and the Sleeping Potion accepted, only at Prog 1'},
         },
         reach = {{t = 'event', zone = 50, event = 779, why = 'Iruki-Waraki 779: his reminder at Prog 1 to bring the items'}}},
        {id = 's6', kind = 'note', with = 's17', at = {n = 6, fp = 'head to nashmau and seek out'}},
        {id = 's7', kind = 'note', with = 's17', at = {n = 7, fp = 'warning do not select the option'}},
        {id = 's8', kind = 'note', with = 's17', at = {n = 8, fp = 'the next part of the cutscene'}},
        {id = 's9', kind = 'note', with = 's17', at = {n = 9, fp = 'you are then presented with 3'}},
        {id = 's10', kind = 'note', with = 's17', at = {n = 10, fp = 'the next part of this quest'}},
        {id = 's11', kind = 'note', with = 's17', at = {n = 11, fp = 'the final for this quest is'}},
        {id = 's12', kind = 'note', with = 's17', at = {n = 12, fp = 'the quickest way to reef is'}},
        {id = 's13', kind = 'note', with = 's17', at = {n = 13, fp = 'if you used the survival guide'}},
        {id = 's14', kind = 'note', with = 's17', at = {n = 14, fp = 'for the reef you are going'}},
        {id = 's15', kind = 'note', with = 's17', at = {n = 15, fp = 'you ll find yourself at i'}},
        {id = 's16', kind = 'note', with = 's17', at = {n = 16, fp = 'apply sneak status and invisible status'}},
        {id = 's17', at = {n = 17, fp = 'once in caedarva mire apply invisible'},
         done = {
            {t = 'event', zone = 79, event = 15, why = 'the ??? 15 in Caedarva Mire: plays only at Prog 3, the final cutscene'},
         }},
        {id = 's18', at = {n = 18, fp = 'enjoy the final cut scene once'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 79, event = 15, why = 'the ??? 15: runs completeQuest (replays if the Puppetry Churidars cannot be given)'}}},
    },
}
