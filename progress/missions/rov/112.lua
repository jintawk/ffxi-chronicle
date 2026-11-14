-- Step progress for Set Free (Rhapsodies of Vana'diel mission 1-4, page id 112). Data only; see progress/missions/adoulin/110.lua for the format.
-- Evidence: LandSandBoat scripts/missions/rov/1_04_Set_Free.lua. The rov line holds the page id (enum + 108) and has no completed set;
-- the next value is 114 (The Beginning). The two paths (Selbina: 3 Bee Pollen to Abelard, Mhaura: 3 Mandragora Dewdrops to Ekokoko) are a
-- group each, opened by the mission being current. The trade events (Abelard 178 at Selbina, Ekokoko 370 at Mhaura) play only for the
-- right trade on that path (status 1 / 2) and finish by completing the mission. Their last param (P6) is 0 when the support job is
-- not unlocked (Gilgamesh's introductory letter is handed over, nothing can fail) and 1 when it is (a Copper Aman voucher is handed
-- over, and a full bag lets the cutscene play and then bails out before the trade is confirmed and the mission completes, so the
-- same event replays: cross-audit rule, an event that also plays without the mission advancing is never proof). So only P6 = 0 is
-- proof; P6 = 1 is `reach`, and the voucher route is carried by the line moving on.
-- Neither event has a client line. The farming bullets (1, 3) are notes on the trade they lead into. Abelard 181 and the Ekokoko 373 talk
-- are the default lines while the mission is current and prove nothing. The letter and the voucher are rewards, so they are not used.
-- The line cannot say which path was taken, so the other path's trade is only inferred done once the line has moved on.
return {
    title = 'Set Free',
    known = {{t = 'mission', line = 'rov', eq = 112}},
    groups = {
        selbina = {start = {{t = 'mission', line = 'rov', eq = 112, why = 'mission line: current mission = Set Free'}}},
        mhaura = {start = {{t = 'mission', line = 'rov', eq = 112, why = 'mission line: current mission = Set Free'}}},
    },
    steps = {
        {id = 's1', kind = 'note', with = 's2', group = 'selbina', at = {n = 1, fp = 'purchase from the auction house or'}},
        {id = 's2', group = 'selbina', at = {n = 2, fp = 'return to selbina and trade the'},
         done = {
            {t = 'event', zone = 248, event = 178, p = {[6] = 0}, why = 'Abelard 178: the pollen traded, no support job yet (the letter route cannot fail)'},
            {t = 'mission', line = 'rov', min = 114, conf = 'inferred', why = 'mission log: the line moved past Set Free (path not known)'},
         },
         reach = {{t = 'event', zone = 248, event = 178, p = {[6] = 1}, why = 'Abelard 178: the pollen traded (the voucher route, a full bag cancels it)'}}},
        {id = 's3', kind = 'note', with = 's4', group = 'mhaura', at = {n = 3, fp = 'purchase from the auction house or'}},
        {id = 's4', group = 'mhaura', at = {n = 4, fp = 'return to mhaura and trade the'},
         done = {
            {t = 'event', zone = 249, event = 370, p = {[6] = 0}, why = 'Ekokoko 370: the dewdrops traded, no support job yet (the letter route cannot fail)'},
            {t = 'mission', line = 'rov', min = 114, conf = 'inferred', why = 'mission log: the line moved past Set Free (path not known)'},
         },
         reach = {{t = 'event', zone = 249, event = 370, p = {[6] = 1}, why = 'Ekokoko 370: the dewdrops traded (the voucher route, a full bag cancels it)'}}},
    },
}
