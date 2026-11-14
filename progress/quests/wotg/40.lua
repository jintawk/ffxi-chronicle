-- Step progress for A Feast for Gnats (Crystal War quest 40, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (A_FEAST_FOR_GNATS) but has no script for it (only the mission In the Name of the
-- Father mentions the Signal firecracker); the client event script for Dhea Prandoleh (S4 094_Dhea_Prandoleh_0105E1FF.txt) carries
-- only the Tigress events, so the page is the source. Key item 1050 (Signal firecracker, res/key_items.lua) is handed over at the
-- Abandoned Mineshaft cutscene (n=3) and again by Mham Lahrih after a failed fight (n=10), so its gain is the third bullet. The
-- page ends the quest at Dhea Prandoleh after the instance (n=12), so the log's completed bit belongs to n=12, not to the
-- firecracker as the draft had it. The log's first flag is not known, so the steps before the firecracker are silent. The two
-- cutscene trips (n=1, 2), the instance and its facts (n=4 to 11) have no signal of their own: notes (the draft's empty branch
-- bullet n=10 is a note). Not repeatable.
-- Shared-signal audit: the Signal firecracker (1050) is named by no other LandSandBoat script and nowhere under progress/.
return {
    title = 'A Feast for Gnats',
    completes = 's12',
    known = {{t = 'quest'}},
    groups = {main = {silent_until = 's3'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'zone into windurst waters s for'}},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'go to sauromugue champaign s and'}},
        {id = 's3', at = {n = 3, fp = 'click on the abandoned mineshaft at'},
         done = {
            {t = 'ki', id = 1050, gained = true, why = 'Signal firecracker obtained'},
            {t = 'ki_have', id = 1050, have = true, why = 'Signal firecracker held'},
            {t = 'chat', re = 'obtained key item: signal firecracker', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's12', at = {n = 4, fp = 'click the abandoned mineshaft again to'}},
        {id = 's5', kind = 'note', with = 's12', at = {n = 5, fp = 'the objective is to destroy the'}},
        {id = 's6', kind = 'note', with = 's12', at = {n = 6, fp = 'there are a number of quadav'}},
        {id = 's7', kind = 'note', with = 's12', at = {n = 7, fp = 'eventually a number of gigas will'}},
        {id = 's8', kind = 'note', with = 's12', at = {n = 8, fp = 'trusts can be summoned'}},
        {id = 's9', kind = 'note', with = 's12', at = {n = 9, fp = 'romaa mihgo and wildcat volunteers assist'}},
        {id = 's10', kind = 'note', with = 's12', at = {n = 10, fp = 'if you fail you can receive'}},
        {id = 's11', kind = 'note', with = 's12', at = {n = 11, fp = 'see discussion for testimonials'}},
        {id = 's12', at = {n = 12, fp = 'talk to dhea prandoleh in windurst'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at Dhea Prandoleh'},
         }},
    },
}
