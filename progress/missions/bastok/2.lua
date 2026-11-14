-- Step progress for Fetichism (Bastok mission 1-3, mission id 2). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/1_3_Fetichism.lua. The four mission givers (Rashid 234, Cleades 235, Argus 236,
-- Malduc 237) offer it through event 1001, a menu whose description lines and accept menu play on a decline too, so only the nation
-- line moving to id 2 proves the accept (65535 = no mission before; completing sets it back to 65535 and adds id 2 to the completed
-- set). The four Fetich pieces are traded together to any of the four: 1008 on the first completion, 1005 on a repeat, played only
-- when the trade matches Fetich Head/Torso/Arms/Legs (a wrong trade plays nothing) and the mission is current; onEventFinish
-- completes the mission. Their bodies are not in the pseudo-code; both ids are in each NPC's event list. Collecting the pieces
-- (bullets 2 and 3) has no signal of its own, the pieces drop from several monsters and can be bought, so they are notes.
return {
    title = 'Fetichism',
    completes = 's4',
    known = {{t = 'mission', line = 'bastok', eq = 2}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to any bastokan gate guard'},
         done = {
            {t = 'mission', line = 'bastok', eq = 2, completed = false, why = 'mission line: current mission = Fetichism'},
         }},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'you will have to obtain 4'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'if you elect to get these'}},
        {id = 's4', at = {n = 4, fp = 'once you obtained your 4 fetich'},
         done = {
            {t = 'mission', line = 'bastok', eq = 2, completed = true, why = 'mission log: Fetichism completed'},
            {t = 'event', zone = 234, event = 1008, why = 'Rashid 1008: the four Fetich pieces accepted, first completion'},
            {t = 'event', zone = 234, event = 1005, why = 'Rashid 1005: the four Fetich pieces accepted, repeat'},
            {t = 'event', zone = 235, event = 1008, why = 'Cleades 1008: the four Fetich pieces accepted, first completion'},
            {t = 'event', zone = 235, event = 1005, why = 'Cleades 1005: the four Fetich pieces accepted, repeat'},
            {t = 'event', zone = 236, event = 1008, why = 'Argus 1008: the four Fetich pieces accepted, first completion'},
            {t = 'event', zone = 236, event = 1005, why = 'Argus 1005: the four Fetich pieces accepted, repeat'},
            {t = 'event', zone = 237, event = 1008, why = 'Malduc 1008: the four Fetich pieces accepted, first completion'},
            {t = 'event', zone = 237, event = 1005, why = 'Malduc 1005: the four Fetich pieces accepted, repeat'},
         }},
    },
}
