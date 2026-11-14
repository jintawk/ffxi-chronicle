-- Step progress for The Bare Bones (Bastok quest 38). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/bastok/The_Bare_Bones.lua (Degenhard 256 is a plain progress event that begins the quest
-- with no option test; Degenhard 258 plays only for a trade of exactly one Bone Chip and runs quest:complete; Biggorf 257 is a
-- hint with no bullet of its own); client event script S4 235_Degenhard_010EB042.txt (256 say #7664, 258 say #7668). The bone
-- chip bullet is a note on the trade it feeds. Disagreement with the draft: none of substance.
return {
    title = 'The Bare Bones',
    completes = 's3',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's3', at = {n = 1, fp = 'obtain a bone chip from the'}},
        {id = 's2', at = {n = 2, fp = 'speak to degenhard to begin quest'},
         done = {
            {t = 'event', zone = 235, event = 256, why = 'Degenhard 256: begins the quest'},
            {t = 'chat', re = "Hah! Yah! I'm still alive and kickin'!", why = 'Degenhard 256 (say #7664)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 's3', at = {n = 3, fp = 'trade him the chip to complete'},
         done = {
            {t = 'event', zone = 235, event = 258, why = 'Degenhard 258: the Bone Chip accepted, completes'},
            {t = 'chat', re = 'Yes, that is the secret ingredient!', why = 'Degenhard 258 (say #7668)'},
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
    },
}
