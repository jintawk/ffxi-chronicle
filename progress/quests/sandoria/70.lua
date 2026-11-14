-- Step progress for Unexpected Treasure (San d'Oria quest 70). Data only; see progress/quests/sandoria/27.lua for the format.
-- Only two steps rest on strong signals. LandSandBoat names the quest (UNEXPECTED_TREASURE) but has no script for it and the
-- client event scripts of Morunaude and Calovour are not decoded, so the two talks (n=5, n=6) have no event or dialogue to
-- go on and stay plain bullets. What is left: the Moogle hands over key item 160 (small teacup, res/key_items.lua), and the
-- quest log is completed at Calovour with the Mistletoe (the page: "to complete this quest"; reward 12,000 gil). The draft
-- tied the completed bit to the Moogle bullet; the quest is completed three bullets later. The first three bullets are
-- preparation, notes on the Moogle's talk.
return {
    title = 'Unexpected Treasure',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's4', at = {n = 1, fp = 'purchase a cupboard from the furniture'}},
        {id = 's2', kind = 'note', with = 's4', at = {n = 2, fp = 'zone out and back into your'}},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'wait some time between 10 15'}},
        {id = 's4', at = {n = 4, fp = 'talk to your moogle he will'},
         done = {
            {t = 'ki', id = 160, gained = true, why = 'small teacup obtained'},
            {t = 'ki_have', id = 160, have = true, why = 'small teacup held'},
         }},
        {id = 's7', at = {n = 7, fp = 'bring calovour a mistletoe to complete'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (Calovour, Mistletoe)'},
         }},
    },
}
