-- Step progress for A Forbidden Reunion (Crystal War quest 75, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (A_FORBIDDEN_REUNION) and checks its status in the Rhapsodies mission, but has no script
-- for it, and the client has no event script for the Walk of Echoes Ornate Door, so the page is the source. Key item 2596
-- (Butterfly-shaped key, res/key_items.lua) is handed over by the first Ornate Door cutscene (n=2) and appears on no other page or
-- script. The page ends the quest at the cutscene after the fight with the rewards (n=6), so the log's completed bit belongs to
-- n=6; the draft had it on the key bullet. The log's first flag is not known (the zone-in cutscene or the first door), so the
-- steps before the key are silent. The zone-in trip (n=1), entering the battlefield (n=3) and the fight's facts (n=4, 5, 7 to 10)
-- have no signal of their own: notes. Not repeatable.
-- Shared-signal audit: the Butterfly-shaped key (2596) is named by no LandSandBoat script, no other page under pages/ and nothing
-- under progress/.
return {
    title = 'A Forbidden Reunion',
    completes = 's6',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's2'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'zone into walk of echoes from'}},
        {id = 's2', at = {n = 2, fp = 'select the ornate door for another'},
         done = {
            {t = 'ki', id = 2596, gained = true, why = 'Butterfly-shaped key obtained'},
            {t = 'ki_have', id = 2596, have = true, why = 'Butterfly-shaped key held'},
            {t = 'chat', re = 'obtained key item: butterfly%-shaped key', why = 'chat: key item obtained'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'select the ornate door to enter'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'inside the battlefield you fight against'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'you fight alongside lilisette'}},
        {id = 's6', at = {n = 6, fp = 'after the fight ends you will'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed after the fight'},
         }},
        {id = 's7', kind = 'note', with = 's6', at = {n = 7, fp = 'both have access to doom moves'}},
        {id = 's8', kind = 'note', with = 's6', at = {n = 8, fp = 'both appear to have access to'}},
        {id = 's9', kind = 'note', with = 's6', at = {n = 9, fp = 'gloomscale gains a bio aura during'}},
        {id = 's10', kind = 'note', with = 's6', at = {n = 10, fp = 'gloomtalon is susceptible to sudden lunge'}},
    },
}
