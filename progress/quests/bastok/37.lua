-- Step progress for Groceries (Bastok quest 37). Data only; see progress/quests/sandoria/27.lua for the format.
-- The completing event and its line are a reach, not proof: with an item reward LandSandBoat plays them on a full-bag refusal too, so the quest log's completed bit carries the last step.
-- Two routes: read Tami's note (Zelman 162, then the jerky trade completes the quest at Tami 113) or leave it unread (Zelman 161,
-- Tami 112 pays 10 gil and resets Prog, so the loop repeats). The page lists the second route in bullets 6 to 8, which are
-- branches here: never inferred, and they leave the first route's `completes` step alone. A repeat of the loop is not tracked:
-- a completed run (Tami 113) is final in LandSandBoat, so there is no `repeatable` entry.
-- Evidence: LandSandBoat scripts/quests/bastok/Groceries.lua (Tami 110 begins the quest and gives key item 152, on any talk
-- while Prog is 0; Zelman 161 or 162 plays only at Prog 1, 162 when the note was read; Tami 111 plays only at Prog 3, 112 only at
-- Prog 2, 113 is the jerky trade at Prog 3 and runs quest:complete); client event scripts S4 234_Tami_010EA04A.txt (110 say
-- #10827, 111 say #10829, 112 say #10832, 113 say #10830) and 172_Zelman_010AC068.txt (161 say #7366/#7367, 162 say #7363); key
-- item 152 from res/key_items.lua. Disagreements with the draft: Tami 111 and 112 sat on the completing bullet (111 is the
-- reminder after the note was read, 112 is the other route); Zelman's shared first line (#7362) is not used, only the lines that
-- tell 161 and 162 apart; bullets 6 to 8 are branches.
-- Shared-signal audit: "Hey, you're an adventurer, right?" is also Baldric's in Stardust (bastok 24) and "You've read this,
-- haven't you?" is a substring of Nbu Latteh 234 in Mom, the Adventurer? (bastok 21) -> s1 and s3 chats now key on a second
-- phrase of Tami 110 / Zelman 162 that only they say.
return {
    title = 'Groceries',
    completes = 's5',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to tami in bastok mines'},
         done = {
            {t = 'event', zone = 234, event = 110, why = 'Tami 110: begins the quest, gives the note'},
            {t = 'chat', re = 'Could you take this note to my husband%?', why = 'Tami 110 (say #10827)'},
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'ki', id = 152, gained = true, why = "Tami's note obtained"},
            {t = 'ki_have', id = 152, have = true, why = "Tami's note held"},
            {t = 'chat', re = "obtained key item: tami's note", why = 'chat: key item obtained'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'she will give you the tami'}},
        {id = 's3', at = {n = 3, fp = 'proceed to zeruhn mines and locate'},
         done = {
            {t = 'event', zone = 172, event = 162, why = 'Zelman 162: the note was read'},
            {t = 'chat', re = 'See what she wants me to do%?', why = 'Zelman 162 (say #7363)'},
            {t = 'event', zone = 172, event = 161, conf = 'inferred', why = 'Zelman 161: also visited, note unread'},
            {t = 'event', zone = 234, event = 111, conf = 'inferred', why = 'Tami 111: reminder, only at Prog 3 (after Zelman 162)'},
            {t = 'chat', re = "What%? He thinks doing the groceries isn't dignified%?", conf = 'inferred', why = 'Tami 111 (say #10829)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'go to h 5 in bastok'}},
        {id = 's5', at = {n = 5, fp = 'trade the jerky to tami for'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {
            {t = 'event', zone = 234, event = 113, why = 'Tami 113: the jerky accepted, completes'},
            {t = 'chat', re = "You bought this, didn't you%?", why = 'Tami 113 (say #10830)'},
         }},
        {id = 's6', kind = 'branch', at = {n = 6, fp = 'proceed to zeruhn mines and locate'},
         done = {
            {t = 'event', zone = 172, event = 161, why = 'Zelman 161: the note unread'},
            {t = 'chat', re = 'Hah! What does she think I do all day', why = 'Zelman 161 (say #7366)'},
         }},
        {id = 's7', kind = 'branch', at = {n = 7, fp = 'he will tell you that he'},
         done = {
            {t = 'chat', re = 'Just tell her I got her message', why = 'Zelman 161 (say #7367)'},
         }},
        {id = 's8', kind = 'branch', at = {n = 8, fp = 'return to tami for your reward'},
         done = {
            {t = 'event', zone = 234, event = 112, why = 'Tami 112: plays only at Prog 2, pays 10 gil'},
            {t = 'chat', re = 'Ah, did you find my husband%?', why = 'Tami 112 (say #10832)'},
         }},
    },
}
