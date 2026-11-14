-- Step progress for VW Op. 026: Tavnazian Terrors (Other Areas quest 84). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script (quests.lua lists VW_OP_026_TAVNAZIAN_TERRORS as id 84 only) and no client script for
-- Owain, so there are no event ids. What can be observed: the Hyacinth stratum abyssite (key item 2060) is handed over when
-- the player chooses to take part (bullet 2), and the page ends the quest on the return to Owain (bullet 4), which the quest
-- log's completed bit marks. The Voidwatch fights have no signal of their own and are a note on the return. The talk
-- bullet is a note on the choice that follows it. The completed bit is the page's own word ("to complete the quest"), not
-- verified in a capture.
return {
    title = 'VW Op. 026: Tavnazian Terrors',
    completes = 's4',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'speak with the npc owain in'}},
        {id = 's2', at = {n = 2, fp = 'choose to participate in voidwatch operations'},
         done = {
            {t = 'ki', id = 2060, gained = true, why = 'hyacinth stratum abyssite obtained'},
            {t = 'ki_have', id = 2060, have = true, why = 'hyacinth stratum abyssite held'},
         }},
        {id = 's3', kind = 'note', with = 's4', at = {n = 3, fp = 'defeat the following voidwatch notorious monsters'}},
        {id = 's4', at = {n = 4, fp = 'return to owain to complete the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the page: the return completes the quest)'},
         }},
    },
}
