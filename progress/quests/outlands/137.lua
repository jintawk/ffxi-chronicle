-- Step progress for It's Not Your Vault (Outlands quest 137). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Its_Not_Your_Vault.lua (Keal 36 is the offer, played on a decline too and only option 1
-- begins the quest; while accepted his talk is 37, or 38 with the Sealed iron box held; the Sea Serpent Grotto ??? gives key item 295
-- through the quest's key item hand-out; 38's finish runs quest:complete and only then takes the box, and the reward includes a scroll,
-- so 38 also plays on a full bag; 39 plays once completed). Client event script S4 252_Keal_010FC021.txt (36 say #10296 on the Yes
-- branch, 37 say #10298, 38 say #10300). Key item 295 from res/key_items.lua. The grotto directions (n=2 to n=5) are notes on the ???
-- step. Event 38 is reach, and the log's completed bit or the box leaving the key items (taken only after the quest completed) proves
-- s7. Not repeatable.
return {
    title = "It's Not Your Vault",
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to keal h 8 to'},
         done = {
            {t = 'chat', re = 'Spoken like a true pirate!', why = 'Keal 36, Yes branch only (say #10296)'},
            {t = 'quest', current = true, why = 'quest log: accepted (Keal 36, option 1)'},
            {t = 'event', zone = 252, event = 37, conf = 'inferred', why = 'Keal 37: his talk while accepted without the box'},
            {t = 'chat', re = "Where's the storage room%?", conf = 'inferred', why = 'Keal 37 (say #10298)'},
         },
         reach = {{t = 'event', zone = 252, event = 36, why = 'Keal 36 offered (its finish needs option 1)'}}},
        {id = 's2', kind = 'note', with = 's6', at = {n = 2, fp = 'exit norg into sea serpent grotto'}},
        {id = 's3', kind = 'note', with = 's6', at = {n = 3, fp = 'once in sea serpent grotto head'}},
        {id = 's4', kind = 'note', with = 's6', at = {n = 4, fp = 'turn south at f 7 and'}},
        {id = 's5', kind = 'note', with = 's6', at = {n = 5, fp = 'the you re looking for is'}},
        {id = 's6', at = {n = 6, fp = 'examine the to get the key'},
         done = {
            {t = 'ki', id = 295, gained = true, after = 's1', why = 'sealed iron box obtained (the Sea Serpent Grotto ???)'},
            {t = 'ki_have', id = 295, have = true, after = 's1', why = 'sealed iron box held'},
            {t = 'chat', re = 'obtained key item: sealed iron box', after = 's1', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 38, after = 's1', conf = 'inferred', why = 'Keal 38: plays only with the box held'},
         }},
        {id = 's7', at = {n = 7, fp = 'return to keal to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Keal 38)'},
            {t = 'ki', id = 295, gained = false, after = 's6', why = 'sealed iron box taken, only after the quest was completed'},
         },
         reach = {
            {t = 'event', zone = 252, event = 38, after = 's6', why = 'Keal 38 (also plays when the bag is full: nothing is given)'},
            {t = 'chat', re = "That's what I was lookin' fer!", after = 's6', why = 'Keal 38 (say #10300)'},
         }},
    },
}
