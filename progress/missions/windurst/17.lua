-- Step progress for Saintly Invitation (Windurst mission id 17). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/windurst/6_2_Saintly_Invitation.lua; client event scripts S4 where an NPC body is decoded; key item ids from
-- res/key_items.lua; zone ids from res/zones.lua. Line convention: the windurst line holds the mission id while it is current (here
-- 17) and the id enters the completed set on completion, so the completes step carries mission completed = true. No bullet of this
-- page is the accept (the nation guards' option 17), so no step uses the accept; the engine reads steps from the events below.
-- The Door: Vestal Chamber and similar objects are not decoded in the pseudo-code: their event ids come from LandSandBoat.
-- s1: the Door, event 310 (progressEvent at status 0; gives the Holy One's invitation). s2: the Balga's Dais battlefield win gives the
-- Balga champion certificate and takes the invitation (the generic exit event 32001 is not used: LandSandBoat gates it inside the
-- handler). s17: Kaa Toru the Just in Castle Oztroja, event 45 (gives the Holy One's oath, takes the certificate). The page ends
-- there; the mission itself completes at the Door with event 312, so that event and the completed id also sit on s17.
-- A full bag fails npcUtil.giveItem for the Ashura Necklace, so event 45 changes nothing and replays: it is reach; the oath key item, the completed id and event 312 carry the step.
-- The fight tips (3-7) are notes on s2; the climb through Castle Oztroja (8-16, including the Judgment Key trade at the Brass
-- Door, which runs no event of this mission) are notes on s17.
return {
    title = 'Saintly Invitation',
    completes = 's17',
    known = {{t = 'mission', line = 'windurst', min = 0}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'select the door vestal chamber at'},
         done = {
            {t = 'event', zone = 242, event = 310, why = 'Door: Vestal Chamber 310'},
            {t = 'ki', id = 249, gained = true, why = 'Holy One\'s invitation obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'you will have to proceed to'},
         done = {
            {t = 'ki', id = 199, gained = true, why = 'Balga champion certificate obtained'},
            {t = 'ki', id = 249, gained = false, why = 'Holy One\'s invitation taken at the battlefield win'},
         }},
        {id = 's3', kind = 'note', with = 's2', at = {n = 3, fp = 'inside are 4 nm yagudo they'}},
        {id = 's4', kind = 'note', with = 's2', at = {n = 4, fp = 'the yagudo may be slept'}},
        {id = 's5', kind = 'note', with = 's2', at = {n = 5, fp = 'it is recommended to fight in'}},
        {id = 's6', kind = 'note', with = 's2', at = {n = 6, fp = 'it may be useful to pull'}},
        {id = 's7', kind = 'note', with = 's2', at = {n = 7, fp = 'trio of 75whm nin 75rdm blm'}},
        {id = 's8', kind = 'note', with = 's17', at = {n = 8, fp = 'once you win the bcnm proceed'}},
        {id = 's9', kind = 'note', with = 's17', at = {n = 9, fp = 'you will need to reach the'}},
        {id = 's10', kind = 'note', with = 's17', at = {n = 10, fp = 'starting from the main entrance on'}},
        {id = 's11', kind = 'note', with = 's17', at = {n = 11, fp = 'you ll now be on map'}},
        {id = 's12', kind = 'note', with = 's17', at = {n = 12, fp = 'go upstairs at point g and'}},
        {id = 's13', kind = 'note', with = 's17', at = {n = 13, fp = 'open the the large brass door'}},
        {id = 's14', kind = 'note', with = 's17', at = {n = 14, fp = 'next you will need to crack'}},
        {id = 's15', kind = 'note', with = 's17', at = {n = 15, fp = 'after the fall proceed to a'}},
        {id = 's16', kind = 'note', with = 's17', at = {n = 16, fp = 'trade the judgment key to the'}},
        {id = 's17', at = {n = 17, fp = 'speak to kaa toru the just'},
         done = {
            {t = 'ki', id = 200, gained = true, why = 'Holy One\'s oath obtained'},
            {t = 'ki', id = 199, gained = false, why = 'Balga champion certificate taken'},
            {t = 'mission', line = 'windurst', eq = 17, completed = true, why = 'mission log: Saintly Invitation completed'},
            {t = 'event', zone = 242, event = 312, why = 'Door: Vestal Chamber 312: completes, takes the oath (past the last bullet)'},
         },
         reach = {{t = 'event', zone = 151, event = 45, why = 'Kaa Toru the Just 45 offered (a full bag fails the Ashura Necklace and nothing advances, so it can replay)'}}},
    },
}
