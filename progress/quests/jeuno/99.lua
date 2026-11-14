-- Step progress for A Furious Finale (Jeuno quest 99). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names A_FURIOUS_FINALE but has no script for it, and the client's event scripts carry nothing for
-- the Qu'Bia Arena fight, so the only strong signals are the quest log's bits. Bullet 1 is Laila's cutscene that begins the
-- quest (the wiki's starting NPC is Laila): current bit. Bullet 5 is the win, which ends the quest: completed bit. The draft
-- also gave the Rhapsody in Umber key item (2885) as proof of the fight; the page only says it lets you summon Trust magic
-- if you hold it, the quest never hands it out, so it is dropped. The farming and trade bullets (2 to 4) have no signal that
-- is not an item (a Dancer's Testimony can come from elsewhere), and bullet 6 is advice; all stay plain bullets.
-- Not repeatable (page meta). The quest log is set at s1, so it is not silent.
return {
    title = 'A Furious Finale',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to laila as a level'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Laila begins the quest)'},
         }},
        {id = 's5', at = {n = 5, fp = 'bring laila to approximately 25 hp'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the win against Laila)'},
         }},
    },
}
