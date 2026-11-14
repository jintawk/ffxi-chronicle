-- Step progress for Silence of the Rams (Bastok quest 48). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/Silence_of_the_Rams.lua (Paujean 195 begins the quest on finish, no refusal
-- branch, Norg fame 2; trading exactly a Lumbering Horn and a Rampaging Horn is event 196, which runs quest:complete);
-- client event script S4 236_Paujean_010EC009.txt (195 say #7688, 196 say #7692). The three horn bullets (get both horns, and
-- the two lists of where they drop) are notes on the trade. Event 196 also plays when the reward item (Purple
-- Belt) cannot be given, so it is `reach` and the quest log's completed bit proves the last step. The quest log is set at the accept. Not repeatable.
return {
    title = 'Silence of the Rams',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to paujean to begin the'},
         done = {
            {t = 'event', zone = 236, event = 195, why = 'Paujean 195: the quest begun'},
            {t = 'chat', re = 'Say, you look like a seasoned adventurer%.', why = 'Paujean 195 (say #7688)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's2', kind = 'note', with = 's5', at = {n = 2, fp = 'obtain a rampaging horn and a'}},
        {id = 's3', kind = 'note', with = 's5', at = {n = 3, fp = 'lumbering horn is obtainable via the'}},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'rampaging horn is obtainable via the'}},
        {id = 's5', at = {n = 5, fp = 'trade both items to paujean to'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 236, event = 196, why = 'Paujean 196: both horns accepted; plays even when the Purple Belt does not fit, so it is not proof'},
                  {t = 'chat', re = 'Incredible! You were able to defeat both of them!%?', why = 'Paujean 196 (say #7692)'}}},
    },
}
