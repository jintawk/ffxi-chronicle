-- Step progress for To Catch a Falling Star (Windurst quest 53). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/zones/Port_Windurst/npcs/Sigismund.lua (196 is the offer, played only while the quest is
-- available, and its finish adds the quest with no choice; 197 is the reminder while accepted; trading one Starfall Tear is
-- event 199, which only plays while accepted and whose finish completes the quest and gives the Fish Scale Shield with no
-- refusal path; 200 is the talk after completion) and Tohopka.lua (198, accepted only); client event scripts S4
-- 240_Sigismund_010F007B.txt (197 say #3586, 200 say #3595) and 240_Tohopka_010F007C.txt (198 say #3588); item id from
-- res/items.lua (12316 Fish Scale Shield). The Twinkle Tree has no event and its two messages also play when the tree is merely
-- examined at night, so the scale trade (n=5) has no strong signal and is left a plain bullet; the auction house remark and the
-- directions to the tree are notes on the hand-in. The quest log is set at s1, so it is not silent.
-- Item 12316 (Fish Scale Shield) is also a fishing catch: shared, gated after s1.
return {
    title = 'To Catch a Falling Star',
    completes = 's6',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'to start this quest speak to'},
         done = {
            {t = 'event', zone = 240, event = 196, why = 'Sigismund 196: the offer, adds the quest'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 240, event = 197, conf = 'inferred', why = 'Sigismund 197: reminder, only once accepted'},
            {t = 'chat', re = "Out in Sarutabaruta somewhere there's a place called Starfall Hillock where,", conf = 'inferred', why = 'Sigismund 197 (say #3586)'},
         }},
        {id = 's2', at = {n = 2, fp = 'speak with tohopka who is standing'},
         done = {
            {t = 'event', zone = 240, event = 198, why = 'Tohopka 198: only while accepted'},
            {t = 'chat', re = 'I see Master Sigismund has asked you to go get him a memento of Windurst to take back as a souvenir%.', why = 'Tohopka 198 (say #3588)'},
         }},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'you can also find the starfall'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'with some scales in your possession'}},
        {id = 's6', at = {n = 6, fp = 'head back to sigismund and give'},
         done = {
            {t = 'event', zone = 240, event = 199, why = 'Sigismund 199: the Starfall Tear accepted'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'item', id = 12316, gained = true, after = 's1', conf = 'inferred', why = 'Fish Scale Shield gained (reward) (items can come from elsewhere)'},
            {t = 'event', zone = 240, event = 200, conf = 'inferred', why = 'Sigismund 200: the talk after completion'},
            {t = 'chat', re = "If I had known it was that delicate I wouldn't have asked for one%.", conf = 'inferred', why = 'Sigismund 200 (say #3595)'},
         }},
    },
}
