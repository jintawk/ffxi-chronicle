-- Step progress for A Barrel of Laughs (Adoulin quest 105). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no client event script for the Mischief Marker, the doors or Peladi Shalmohr, so the
-- page is the only source. The Guffawshroom (key item 2962, res/key_items.lua) is the objective of the Sih Gates bullet and
-- is not a reward; the page says the quest is complete at the return to the Mischief Marker (n=9: "The quest is considered
-- complete at this point. You may choose your reward at a later time"), so the log's completed bit belongs to n=9 and the
-- Peladi talk (n=10) is after it. The cutscene, door, battlefield and travel bullets (n=2-6, n=8) have no signal: notes. The
-- battlefield win has no known wording, so n=5 stays a note. Not repeatable.
return {
    title = 'A Barrel of Laughs',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's2', kind = 'note', with = 's7', at = {n = 2, fp = 'examine the mischief marker at j'}},
        {id = 's3', kind = 'note', with = 's7', at = {n = 3, fp = 'to the left of the mischief'}},
        {id = 's4', kind = 'note', with = 's7', at = {n = 4, fp = 'travel to rala waterways m 6'}},
        {id = 's5', kind = 'note', with = 's7', at = {n = 5, fp = 'examine the door again to enter'}},
        {id = 's6', kind = 'note', with = 's7', at = {n = 6, fp = 'upon successfully clearing the battlefield head'}},
        {id = 's7', at = {n = 7, fp = 'travel to sih gates and harvest'},
         done = {
            {t = 'ki', id = 2962, gained = true, why = 'guffawshroom obtained'},
            {t = 'ki_have', id = 2962, have = true, why = 'guffawshroom held'},
            {t = 'chat', re = 'obtained key item: guffawshroom', why = 'chat: key item obtained'},
         }},
        {id = 's8', kind = 'note', with = 's9', at = {n = 8, fp = 'next click on the door to'}},
        {id = 's9', at = {n = 9, fp = 'return to the mischief marker at'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at the return to the Mischief Marker'},
         }},
        {id = 's10', kind = 'optional', at = {n = 10, fp = 'talk to peladi shalmohr at the'}, done = {}},
    },
}
