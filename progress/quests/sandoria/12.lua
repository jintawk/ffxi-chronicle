-- Step progress for The Brugaire Consortium (San d'Oria quest 12). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/The_Brugaire_Consortium.lua (Fontoumant 509 begins the quest on the accept
-- answer and hands over the first parcel; each delivery is a trade event (Regine 535, Apstaule 540, Thierride 539) and
-- Fontoumant then hands out the next parcel (511, 512); after the third delivery his event 515 runs quest:complete); client
-- event scripts S4 232_Fontoumant_010E8010.txt (509 accept branch say #7532; 511, 512 and 515 are not in the decoded scripts,
-- so they rest on LandSandBoat), 232_Regine_010E8013.txt (535), 232_Apstaule_010E801B.txt (540), 232_Thierride_010E800A.txt
-- (539). Bullet 1 bundles the offer with the three deliveries (its indented bullets), so it is done by the last delivery, the
-- Pub Parcel to Thierride, and the offer and the earlier deliveries only mark it reached; the draft ticked it at the accept
-- and completed the quest there. The rest of the quest log is set at the accept. The quest is not repeatable.
-- Full-inventory rule (coordinator, 2026-10-28): an event whose finish can fail on a full bag (giveItem or a reward item)
-- plays the same either way, so it and its lines are `reach` only; the quest log or a success-only signal proves the step.
return {
    title = 'The Brugaire Consortium',
    completes = 's2',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'talk to fontoumant in cargo room'},
         done = {
            {t = 'event', zone = 232, event = 539, why = 'Thierride 539: the last parcel (Pub Parcel) delivered'},
         },
         reach = {{t = 'chat', re = "That's the spirit! There may be some hope for your generation", why = 'Fontoumant 509, accepted (say #7532)'},
                  {t = 'event', zone = 232, event = 535, why = 'Regine 535: the Magic Shop Parcel delivered'},
                  {t = 'event', zone = 232, event = 540, why = 'Apstaule 540: the Auction Parcel delivered'}}},
        {id = 's2', at = {n = 2, fp = 'once all parcels are delivered talk'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 232, event = 515, why = 'Fontoumant 515: after the third delivery (the Lauan Shield may not fit)'}}},
    },
}
