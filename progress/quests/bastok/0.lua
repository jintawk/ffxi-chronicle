-- Step progress for The Siren's Tear (Bastok quest 0). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Sirens_Tear.lua (Wahid 81 begins the quest; Wahid 82 takes the tear and runs
-- quest:complete, and also runs on any later repeat); scripts/zones/North_Gustaberg/npcs/qm1.lua (the ??? plays event 10 on every
-- examine, then gives the tear only with both hands empty and a free slot, otherwise "slips through your fingers"); client event
-- script S4 234_Wahid_010EA013.txt (81 say #10715/#10716, 82 say #10725). The Otto and Carmelo hints are an indented bullet, so
-- they are not used. The page's travel and slot bullets are notes on the step they lead into. The quest is repeatable: a repeat
-- needs no talk (the trade alone) and retail keeps the current bit set, so the log marks the first run only and a new tear
-- after a finished run opens the next one (pilot case 5).
-- A zonein to North Gustaberg (106) was dropped: LandSandBoat's North_Gustaberg/Zone.lua onZoneIn (line 21) returns cs = -1, so no zone-in event exists to match.
-- Shared-signal audit: the tear (item 576, its ??? at event 106/10, the "Obtained" line, a zone-in to North Gustaberg) is also
-- fetched for Aht Urhgan An Empty Vessel and Jeuno LB09 Dormant Powers Dislodged -> shared with those quests, gated after s1
-- (zonein, event 10, both lines, item gained); item_have 576 dropped (a held tear is no proof of this quest). A restart after a
-- finished run still opens on any new tear (the repeat has no other trace), so another quest's tear can reopen this page.
-- Repeat runs are not tracked: `repeatable.restart` removed, because a new tear/stone (also fetched for other quests) would reopen a finished page. First run and its completion stay.
return {
    title = "The Siren's Tear",
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to wahid hp 1 bastok'},
         done = {
            {t = 'event', zone = 234, event = 81, why = 'Wahid 81: begins the quest'},
            {t = 'chat', re = 'Mind you, I am not interested in stones with only monetary value%.', why = 'Wahid 81 (say #10716)'},
            {t = 'quest', current = true, run1 = true, why = 'quest log: accepted (first run only: it never clears on retail)'},
         }},
        {id = 'n2', kind = 'note', with = 's3', at = {n = 2, fp = 'travel to j 9 in north'}},
        {id = 'n3', kind = 'note', with = 's3', at = {n = 3, fp = 'make sure you have 1 free'}},
        {id = 's3', at = {n = 4, fp = 'unequip all weapons and shield in'},
         reach = {
            {t = 'event', zone = 106, event = 10, after = 's1', why = '??? examined (plays whether or not the tear is picked)'},
            {t = 'chat', re = 'The shining object slips through your fingers', after = 's1', why = 'a failed pick (weapon on or bag full)'},
         },
         done = {
            {t = 'chat', re = "Obtained: Siren's Tear", after = 's1', why = "ITEM_OBTAINED, the only source of the tear (qm1.lua:24)"},
            {t = 'item', id = 576, gained = true, after = 's1', why = "Siren's Tear gained"},
         }},
        {id = 's4', at = {n = 5, fp = 'go back to wahid trade siren'},
         done = {
            {t = 'event', zone = 234, event = 82, why = 'Wahid 82: the tear accepted'},
            {t = 'chat', re = 'Yes, yes! Look how it glitters!', why = 'Wahid 82 (say #10725)'},
            {t = 'quest', completed = true, run1 = true, why = 'quest log: completed (first run only)'},
            {t = 'item', id = 576, lost = true, after = 's3', conf = 'inferred', why = "Siren's Tear gone (traded, or dropped)"},
         }},
        {id = 'n6', kind = 'note', with = 's4', at = {n = 6, fp = 'can be repeated as many times'}},
    },
}
