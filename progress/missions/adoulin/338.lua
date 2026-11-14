-- Step progress for The Key to the Turris (Seekers of Adoulin mission, page id 338). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/soa/5_2_2_The_Key_to_the_Turris.lua. The Ominous Postern (Ra'Kaznar Turris 277) plays 1 as a
-- plain progress event while the mission is current (no refusal path); its finish sets status 1 and puts you in Kamihr Drifts (267),
-- whose onZoneIn plays 58 at status 1, and the finish of 58 completes the mission. One cutscene is the whole mission: bullet 1 states
-- it, and bullets 15 and 21 repeat it as the last stop of two route guides, so they are notes on bullet 1 (the draft made 15 a
-- second required step), as is every other route and travel bullet. The adoulin line has no completed set (packet value = page id),
-- so the completion is `min = 339`, not the draft's `completed = true`. Levil's 40 is a reminder and proves nothing.
return {
    title = 'The Key to the Turris',
    completes = 's1',
    known = {{t = 'mission', line = 'adoulin', eq = 338}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'you will have to reach the'},
         done = {
            {t = 'event', zone = 277, event = 1, why = 'Ominous Postern 1: the long cutscene, no refusal path'},
            {t = 'zonein', zone = 267, event = 58, why = 'Kamihr Drifts zone-in 58 after the Postern, finish completes the mission'},
            {t = 'mission', line = 'adoulin', min = 339, why = 'mission line: the line moved past The Key to the Turris'},
         }},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'to reach ra kaznar turris you'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'if you ve cleared yumcax have'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'if you ve cleared tchakka have'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'if you ve cleared hurkan have'}},
        {id = 's6', kind = 'note', with = 's1', at = {n = 6, fp = 'if you ve cleared achuka have'}},
        {id = 's7', kind = 'note', with = 's1', at = {n = 7, fp = 'if you ve cleared colkhab have'}},
        {id = 's8', kind = 'note', with = 's1', at = {n = 8, fp = 'if you ve cleared kumhau have'}},
        {id = 's9', kind = 'note', with = 's1', at = {n = 9, fp = 'if you ve cleared none of'}},
        {id = 's10', kind = 'note', with = 's1', at = {n = 10, fp = 'the shortest path starts at yorcia'}},
        {id = 's11', kind = 'note', with = 's1', at = {n = 11, fp = 'you may have to break a'}},
        {id = 's12', kind = 'note', with = 's1', at = {n = 12, fp = 'this route starts at marjami ravine'}},
        {id = 's13', kind = 'note', with = 's1', at = {n = 13, fp = 'follow the left wall and use'}},
        {id = 's14', kind = 'note', with = 's1', at = {n = 14, fp = 'there is a home point next'}},
        {id = 's15', kind = 'note', with = 's1', at = {n = 15, fp = 'head to the bottom and examine'}},
        {id = 's16', kind = 'note', with = 's1', at = {n = 16, fp = 'you will have to pass through'}},
        {id = 's17', kind = 'note', with = 's1', at = {n = 17, fp = 'follow the arrows on the outer'}},
        {id = 's18', kind = 'note', with = 's1', at = {n = 18, fp = 'upon completing your run through outer'}},
        {id = 's19', kind = 'note', with = 's1', at = {n = 19, fp = 'using the marked map connections for'}},
        {id = 's20', kind = 'note', with = 's1', at = {n = 20, fp = 'finally after using the j warp'}},
        {id = 's21', kind = 'note', with = 's1', at = {n = 21, fp = 'head to the bottom and examine'}},
        {id = 's22', kind = 'note', with = 's1', at = {n = 22, fp = 'note this distance is measured in'}},
    },
}
